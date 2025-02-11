# Ad-Hoc-Requests-Atliq-Hardwares
 SQL solutions for ad-hoc business requests in the consumer goods domain.
---

 ## Overview

 ### About Atliq Hardwares
 Atliq Hardwares, a fictional computer hardware manufacturer in India, expanding presence in international markets. The company seeks to enhance its data analytics capabilities to improve business performance and decision-making but executives struggle to get quick insights.<br>
<br>To address this, Tony Sharma, their analytics director created an SQL challenges to evaluate candidates' ability to derive valuable insights from the data.

### Challenges
🔹 Task: Solve 10 ad-hoc business requests using SQL.<br> 
🔹 Objective: Provide data insights that support managemnet decisions.<br>
🔹 Scope: Create a report focused on sales, customers, and pricing data, tailored for top-level management.<br>

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
