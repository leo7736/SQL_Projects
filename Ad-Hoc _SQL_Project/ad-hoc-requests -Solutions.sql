-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region. 

SELECT DISTINCT(market) 
FROM gdb023.dim_product
WHERE
customer = "Atliq Exclusive" 
AND 
region = 'APAC'

-- 2. What is the percentage of unique product increase in 2021 vs. 2020?
with  Unique_2020 as
(select COUNT(distinct(product_code)) AS unique_products_2020 
FROM gdb023.fact_manufacturing_cost 
where cost_year = 2020 ),
Unique_2021 as 
(SELECT COUNT(DISTINCT(product_code)) AS unique_products_2021 
FROM gdb023.fact_manufacturing_cost 
WHERE cost_year = 2021 )

SELECT *,(Unique_2021.unique_products_2021 - Unique_2020.unique_products_2020)*100/Unique_2020.unique_products_2020
AS percentage_chg
FROM Unique_2020 cross join Unique_2021

-- 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
SELECT segment,count(distinct product) as product_count
 FROM gdb023.dim_product
 group by segment
 order by product_count desc
 
 -- 4. Which segment had the most increase in unique products in 2021 vs 2020? 
 with cte1 as(
SELECT p.segment,count(distinct p.product) as product_count_2020
 FROM gdb023.dim_product as p
 join gdb023.fact_sales_monthly as sal
 on p.product_code=sal.product_code
 where sal.fiscal_year=2020
 group by segment),
 cte2 as (
 SELECT p.segment,count(distinct p.product) as product_count_2021
 FROM gdb023.dim_product as p
 join gdb023.fact_sales_monthly as sal
 on p.product_code=sal.product_code
 where sal.fiscal_year=2021
 group by segment)
 select  cte1.segment,cte1.product_count_2020,cte2.product_count_2021,
 (cte2.product_count_2021-cte1.product_count_2020) as difference
 from cte1 join cte2
on cte1.segment = cte2.segment
order by difference

-- 5. Get the products that have the highest and lowest manufacturing costs. 
SELECT m.product_code,p.product,m.manufacturing_cost
FROM gdb023.dim_product as p  join gdb023.fact_manufacturing_cost as m
on p.product_code=m.product_code
where m.manufacturing_cost=(select max(manufacturing_cost) FROM gdb023.fact_manufacturing_cost )
or
m.manufacturing_cost=(select min(manufacturing_cost) FROM gdb023.fact_manufacturing_cost )

-- 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. 
SELECT cus.customer_code,cus.customer,avg(round(inv.pre_invoice_discount_pct,2))*100 as average_discount_percentage 
FROM gdb023.dim_customer as Cus join gdb023.fact_pre_invoice_deductions as inv
on cus.customer_code = inv.customer_code
where inv.fiscal_year=2021
and cus.market='India'
group by cus.customer,cus.customer_code
order by average_discount_percentage desc
limit 5

-- 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month
SELECT monthname(sal.date) as month,year(sal.date) as year,round(sum((gro.gross_price*sal.sold_quantity)),2) as Gross_sales_Amount
FROM gdb023.dim_customer as cus inner join gdb023.fact_sales_monthly as sal 
on cus.customer_code=sal.customer_code
inner join gdb023.fact_gross_price as gro 
on sal.product_code=gro.product_code and sal.fiscal_year=gro.fiscal_year
where cus.customer= 'Atliq Exclusive' 
group by month,year
order by year

-- 8. In which quarter of 2020, got the maximum total_sold_quantity?
SELECT
case 
when month(date) in (9,10,11) then 'quarter1'
when month(date) in (12,1,2) then 'quarter2'
when month(date) in (3,4,5) then 'quarter3'
when month(date) in (6,7,8) then 'quarter4'
end as quarter,sum(sold_quantity) as total_sold_quantity
 FROM gdb023.fact_sales_monthly
 where fiscal_year=2020
 group by quarter
 
-- 9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?
 with cte1 as(
SELECT channel,round(SUM(gro.gross_price * sal.sold_quantity))/1000000 AS 'gross_sales_mln' 
FROM gdb023.fact_gross_price as gro inner join gdb023.fact_sales_monthly as sal
on gro.product_code=sal.product_code and gro.fiscal_year=sal.fiscal_year
inner join gdb023.dim_customer as cus
on cus.customer_code=sal.customer_code
where sal.fiscal_year=2021
group by channel)
select *,round((gross_sales_mln*100))/sum(gross_sales_mln)  over () as  percentage_contrib
from cte1 
order by percentage_contrib desc

-- 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
with cte1 as(
SELECT p.division,p.product_code,p.product,
sum(sal.sold_quantity) as tot_sold_qnty
FROM gdb023.dim_product as p 
join gdb023.fact_sales_monthly as sal
on p.product_code=sal.product_code
where sal.fiscal_year=2021
group by p.division,p.product_code,p.product
),
cte2 as(
select *, RANK() OVER
(PARTITION BY division ORDER BY tot_sold_qnty DESC)
 AS Rank_order from cte1 )

SELECT * FROM cte2 
WHERE Rank_order <=3
