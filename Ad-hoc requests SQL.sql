use gdb023;




/* Request 1. Provide the list of markets in which customer "Atliq Exclusive" operates its
business in the APAC region.*/

select distinct market from dim_customer where customer='Atliq Exclusive' and region='APAC';





/* Request 2. What is the percentage of unique product increase in 2021 vs. 2020? The
final output contains these fields,
unique_products_2020
unique_products_2021
percentage_chg*/

with cte1 as(
       select count(distinct product_code) AS unique_products_2021 
from   dbo.fact_gross_price 
where  fiscal_year=2021
),
cte2 as(
     select count(distinct product_code) AS unique_products_2020 
from dbo.fact_gross_price 
where fiscal_year=2020
),
cte3 as(
       select * from cte1 CROSS JOIN cte2 
)

    select *,
          CAST(  ((CAST(unique_products_2021 AS DECIMAL(10,2)) - 
                 CAST(unique_products_2020 AS DECIMAL(10,2))) / 
              CAST(unique_products_2020 AS DECIMAL(10,2)) * 100) AS DECIMAL(10,2)
	     ) 
          AS percentage_chg
    from cte3;






/* Request 3. Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains
2 fields,
segment
product_count*/

select segment,
	count(distinct product_code) as product_count 
from dbo.dim_product 
group by segment
order by product_count desc;






/* Request 4. Follow-up: Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment
product_count_2020
product_count_2021
difference*/

--join two table first
with cte1 as(
       select a.product_code,
	      a.segment,b.fiscal_year 
from dim_product as a 
join fact_gross_price as b on a.product_code=b.product_code
),

--counted product from the year 2021 by segment
cte2 as(
     select segment,
	    count(distinct product_code) as product_count2021 
from cte1 
where fiscal_year=2021 
group by segment
),

--counted product from the year 2020 by segment
cte3 as(
    select segment,
	   count(distinct product_code) as product_count2020
from cte1 
where fiscal_year=2020 
group by segment
),

--as segment common then join this and got result by segment in 2021 and 2020 total unique products
cte4 as(
    select cte2.segment,
	   cte2.product_count2021,
	   cte3.product_count2020,
           (cte2.product_count2021-cte3.product_count2020) AS differences 
 from 
 cte2 FULL OUTER JOIN cte3 on cte2.segment=cte3.segment )

--lastly select max difference of the most increase in unique products(2021 vs 2020)
select * from cte4 order by differences desc;








/* Request 5. Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost*/

with cte1 as(
         select a.product_code,
	        a.product,
	        b.manufacturing_cost
from dim_product as a 
join fact_manufacturing_cost as b on a.product_code=b.product_code
),

--after joining use subquery to get max,min manufacturing cost from cte1
cte2 as(
     select product_code,
	product,
	manufacturing_cost 
from cte1
where 
    manufacturing_cost = (select max(manufacturing_cost) 
from cte1)
),

cte3 as(
    select product_code,
	   product,
	   manufacturing_cost 
    from cte1
    where manufacturing_cost = (select min(manufacturing_cost) from cte1)
)
	
--to show max and min cost use union(as it shows in vertically)
select * from cte2 union select * from cte3;





/* Request 6. Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage
*/

with cte1 as(
         select a.customer_code,
                a.customer,
                a.market,
                b.fiscal_year,
                b.pre_invoice_discount_pct
        from
           dim_customer as a
        join fact_pre_invoice_deductions as b
          on a.customer_code=b.customer_code
),

cte2 as(
     select customer_code,
            customer,
            cast(avg(pre_invoice_discount_pct)*100 as decimal(10,2)) as average_discount_percentage,
            market
     from
         cte1
     where fiscal_year=2021
     group by customer_code,
              customer,
               market
)

select top 5 customer_code,
       customer,average_discount_percentage
from cte2 
where market='India'
order by average_discount_percentage desc;









/* Request 7. Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns:
Month
Year
Gross sales Amount
gross sales=gross price * sold quantity
*/

with cte1 as(
      select customer_code 
from dim_customer 
where customer='Atliq Exclusive'
),

cte2 as(
    select a.date,
	   a.customer_code,
	   a.sold_quantity,
	   a.product_code,a.fiscal_year
     from 
        fact_sales_monthly as a 
    join cte1 as b on a.customer_code=b.customer_code
),

cte3 as(
     select YEAR(date) as [Year],
	    DATENAME(M,date) as [Month],
	    sold_quantity,
	    gross_price 
     from cte2 as a 
     join 
	fact_gross_price as b
     on 
	a.product_code=b.product_code
)

select [Year],
       [Month],
       SUM((gross_price*sold_quantity)) as Gross_sales_Amount 
from cte3 
group by [Month],[Year]
order by [Year],[Month] desc;



/* Request 8. In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity*/

with cte as(
       select distinct [date],
              case 
	          when date between '2019-09-01' and '2019-11-01' then 'Q1'
                  when date between '2019-11-01' and '2020-02-01' then 'Q2'
	          when date between '2020-02-01' and '2020-05-01' then 'Q3'
	          when date between '2020-05-01' and '2020-08-01' then 'Q4'
              end as [Quarter],
	      sold_quantity 
	from fact_sales_monthly 
        where fiscal_year=2020
)
 select [Quarter],
	SUM(sold_quantity) as total_sold_quantity 
 from cte 
group by [Quarter] 
order by total_sold_quantity desc;








/* Request 9. Which channel helped to bring more gross sales in the fiscal year 2021
and the percentage of contribution? The final output contains these fields,
channel
gross_sales_mln
percentage*/


--first join the table to get required columns together
with cte1 as(
        select a.customer_code,a.sold_quantity,a.fiscal_year,a.product_code,b.channel from 
        fact_sales_monthly as a join dim_customer as b on a.customer_code=b.customer_code),

 --then join with fact_gross_price table to get gross_price column as well where fiscal_year is same on both table
cte2 as(
      select a.*,gross_price 
from cte1 as a 
join fact_gross_price as b
 on a.product_code=b.product_code and 
    a.fiscal_year=b.fiscal_year
),

--this return the gross sales(in million) of the product in each channel on the year 2021
cte3 as(
       select channel,
       CAST(
	   SUM((gross_price*sold_quantity))/1000000 AS DECIMAL(10,2)
	)as gross_sales_mln 
 from cte2 
 where fiscal_year=2021 
 group by channel
)

--show the channel wise gross sales in million unit and percentage of contribution- using subquery
select channel,
	gross_sales_mln,
ROUND(CAST(
	(gross_sales_mln/contribute)*100 AS DECIMAL(10,2)),
2) as percentage
from cte3,
	(select sum(gross_sales_mln) as contribute from cte3) as cont_table
order by gross_sales_mln desc;




--another approach-without subquery,cte
SELECT b.channel,
  CAST(SUM(c.gross_price * a.sold_quantity) / 1000000 AS DECIMAL(10,2)) AS gross_sales_mln,
  ROUND(
        CAST((SUM(c.gross_price * a.sold_quantity) * 100.0) / 
        SUM(SUM(c.gross_price * a.sold_quantity)) OVER() AS DECIMAL(10,2)), 2
    ) AS percentage
FROM fact_sales_monthly as a
JOIN dim_customer as b on a.customer_code = b.customer_code
JOIN fact_gross_price as c on a.product_code = c.product_code 
    and a.fiscal_year = c.fiscal_year
WHERE a.fiscal_year = 2021
GROUP BY b.channel
ORDER BY gross_sales_mln DESC;









/* Request 10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields-
division
product_code
product
total_sold_quantity
rank_order*/

 

 --prothome join korsi 2021 er data
with cte1 as(
select a.division,a.product_code,a.product,b.sold_quantity,b.fiscal_year from dim_product as a join
fact_sales_monthly as b on a.product_code=b.product_code where b.fiscal_year=2021),

--then each product er quantity sold bar korlum 
cte2 as(
select division,product_code,product,SUM(sold_quantity) AS total_sold_quantity from cte1 
group by product,product_code,division),


/*division er upor partition disi jeno ekta division a bashi solded(order by quanti_sold) product 
gular rank kore*/
cte3 as(
select *,RANK() over(partition by division order by total_sold_quantity desc) as ranking from cte2)

--last cte3 theke top 3 bar korsi where condition use kore
select * from cte3 where ranking<=3;



