# Ad-Hoc-Requests-Atliq-Hardwares
  SQL solutions for ad-hoc business requests in consumer goods domain.


 ## Overview

 ### About Atliq Hardwares
 Atliq Hardwares, a fictional computer hardware manufacturer in India, expanding presence in international markets. The company seeks to enhance its data analytics capabilities to improve business performance and decision-making but executives struggle to get quick 
 insights.<br>
<br>To address this, Tony Sharma, their analytics director created an SQL challenges to evaluate candidates' ability to derive valuable insights from the data.

### Challenges
- Task: Solve 10 ad-hoc business requests using SQL.<br> 
- Objective: Provide data insights that support managemnet decisions.<br>
- Scope: Create a report focused on sales, customers, and pricing data, tailored for top-level management.<br>
<br>

 ## Data Information
 The Atliq Hardwares database consists of 6 key tables. These table caontains customer data, product info, monthly sales, fiscal year, maufacturing cost, and more.
 Here is a quick view of all the table :

**dim_customer**

 | **customer_code** | **customer**    | **platform_**  | **channel** | **market** | **sub_zone** | **region** |
|-------------------|-----------------|----------------|-------------|------------|--------------|------------|
| 70002017          | Atliq Exclusive | Brick & Mortar | Direct      | India      | India        | APAC       |
| 70002018          | Atliq e Store   | E-Commerce     | Direct      | India      | India        | APAC       |
| 70003181          | Atliq Exclusive | Brick & Mortar | Direct      | Indonesia  | ROA          | APAC       |
| 70003182          | Atliq e Store   | E-Commerce     | Direct      | Indonesia  | ROA          | APAC       |

<br>

**dim_product**

| **product_code** | **division** | **segment** | **category**    | **product**                                                 | **variant**   |
|------------------|--------------|-------------|-----------------|-------------------------------------------------------------|---------------|
| A0118150103      | P & A        | Peripherals | Internal HDD    | AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache | Premium       |
| A0118150104      | P & A        | Peripherals | Internal HDD    | AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache | Premium Plus  |
| A7321160301      | N & S        | Networking  | Wi fi extender  | AQ Wi Power Dx3                                             | Standard      |
| A7321160302      | N & S        | Networking  | Wi fi extender  | AQ Wi Power Dx3                                             | Plus          |


<br>

**fact_gross_price**

| **product_code** | **fiscal_year** | **gross_price** |
|------------------|-----------------|-----------------|
| A0118150101      | 2021            | 19.0573         |
| A0118150102      | 2020            | 19.8577         |
| A0118150103      | 2020            | 22.1317         |

**In the "fiscal_year" column, year starts in September and covers the fiscal years 2020 and 2021 data.

<br>

**fact_manufacturing_cost**

| **product_code** | **cost_year** | **manufacturing_cost** |
|------------------|---------------|------------------------|
| A0118150101      | 2021          | 5.5172                 |
| A0118150102      | 2020          | 5.7180                 |
| A0118150103      | 2021          | 6.5900                 |
| A0118150104      | 2020          | 6.4789                 |

**The "cost_year" column contains the fiscal year in which the product was manufactured.


<br>

**fact_pre_invoice_deductions**

| **customer_code** | **fiscal_year** | **pre_invoice_discount_pct** |
|-------------------|-----------------|------------------------------|
| 70002017          | 2021            | 0.0703                       |
| 70002018          | 2020            | 0.2255                       |
| 70003181          | 2021            | 0.0974                       |
| 70003182          | 2020            | 0.1823                       |

**The "pre_invoice_discount_pct" column contains the percentage of discounts applied to the gross price of each product before the invoice is generated, typically for long-term contracts or large orders.

<br>

**fact_sales_monthly**

| **date**   | **product_code** | **customer_code** | **sold_quantity** | **fiscal_year** |
|------------|------------------|-------------------|-------------------|-----------------|
| 2019-09-01 | A0118150101      | 90023029          | 8                 | 2020            |
| 2019-10-01 | A3019150205      | 70003181          | 203               | 2020            |
| 2020-01-01 | A5119110306      | 90002015          | 14                | 2020            |
| 2021-06-01 | A3819150205      | 90008165          | 25                | 2021            |

**The "date" column contains sale date of a product in a monthly format for the fiscal year 2020 and 2021.

### Data Source
To get this data and all other information, can go [Ad-hoc requests_SQL_challenge](https://codebasics.io/challenge/codebasics-resume-project-challenge/7)<br>
or get the dataset from [atliq_hardware_db](https://drive.google.com/drive/folders/1vj7rMZiUM5ucA6dygV01V4D6K5Zu1P7q?usp=drive_link) that is structured across multiple tables, allowing in-depth analysis to answer ad-hoc business requests.<br>

<br>

## Requests
This project 10 ad-hoc requests related to sales performance, customer engagement across different channel and market, products and pricing data at Atliq Hardwares. Ecah requests is solved using SQL(MSSQL) providing opportunities for improvement and making informed decisions.


### Featured Requests 

🔹Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The output should contains segment and product_count fields.

``` sql

select segment,
       count(distinct product_code) as product_count 
from  dbo.dim_product 
group by segment
order by product_count desc;

```
<br>



Result
| **segment** | **product_count** |
|-------------|-------------------|
| Notebook    | 129               |
| Accessories | 116               |
| Peripherals | 84                |
| Desktop     | 32                |
| Storage     | 27                |
| Networking  | 9                 |

The report demonstrates total unique products in each segemnt and it is sorted in descending order based on product count.The "Notebook" segment has 129 unique products, indicating a strong product portfolio in this category.
The "Accessories" segment follows with 116 unique products,also holding a significant share. This information helps product management teams to evaluate key segments and optimize product strategies.<br>


  <br>

🔹Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields, segment, product_count_2020, product_count_2021 and difference



``` sql

with cte1 as(
        select a.product_code,a.segment,b.fiscal_year
        from dim_product as a
        join fact_gross_price as b
        on a.product_code=b.product_code
),
cte2 as(
      select segment,
             count(distinct product_code) as product_count2021 
      from cte1
      where fiscal_year=2021
      group by segment
),
cte3 as(
     select segment,
            count(distinct product_code) as product_count2020
     from cte1
     where fiscal_year=2020
     group by segment
),

cte4 as(
     select cte2.segment,
            cte2.product_count2021,
            cte3.product_count2020,
           (cte2.product_count2021-cte3.product_count2020) AS differences
     from 
     cte2
     FULL OUTER JOIN cte3
     on cte2.segment=cte3.segment
)

select * from cte4
where differences=(select MAX(differences) from cte4);



```
<br>

Result
| **segment** | **product_count2021** | **product_count2020** | **differences** |
|-------------|-----------------------|-----------------------|-----------------|
| Accessories | 103                   | 69                    | 34              |

After extracting the segment with the highest product increase using a subquery, the results highlight notable product expansion across multiple segments. The "Accessories" segment experienced the highest growth, with 34 additional unique products in 2021 compared to 2020. This indicates strong market demand and potential profitability of accessorie product.

| segment     | product_count2021 | product_count2020 | differences |
|-------------|-------------------|-------------------|-------------|
| Accessories | 103               | 69                | 34          |
| Notebook    | 108               | 92                | 16          |
| Peripherals | 75                | 59                | 16          |
| Desktop     | 22                | 7                 | 15          |
| Storage     | 17                | 12                | 5           |
| Networking  | 9                 | 6                 | 3           |

Following this, the "Notebook" and "Peripherals" segments each saw an increase of 16 unique products that reflects significant expansion. In "Desktop" segment there is also experienced notable growth, adding 15 unique products.
This will help to understand product growth within different segments and can guide in product development. By leveraging these insights, the company can make data-driven decisions to enhance their product and strengthen market positioning.<br>

 <br>

🔹Generate a report that contains top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in "Indian" market. The final output contains these fields, customer_code, customer, average_discount_percentage

``` sql

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

```
<br>

Result

| **customer_code** | **customer** | **average_discount_percentage** |
|-------------------|--------------|---------------------------------|
| 90002009          | Flipkart     | 30.83                           |
| 90002006          | Viveks       | 30.38                           |
| 90002003          | Ezone        | 30.28                           |
| 90002002          | Croma        | 30.25                           |
| 90002016          | Amazon       | 29.33                           |

This report provides a list of top 5 customers in the Indian market who received the highest average pre-invoice discount percentage for the fiscal year 2021. Flipkart received the highest average discount of 30.83%, followed by Viveks at 30.38% and Ezone 30.28%. This significant discount received by these customers indicate that Flipcart and Viveks are key players in the indian market with strong negotiation power.<br>

Understanding why these customers receive high discounts can help the business develop competitive pricing policies and refine negotiation strategies, ensuring both profitability and strong customer relationships in the Indian market.




      




