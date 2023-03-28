--Case Study Questions
--Each of the following case study questions can be answered using a single SQL statement:


--1.What is the total amount each customer spent at the restaurant?

select sales.customer_id, SUM(menu.price)
from sales join  menu 
on sales.product_id = menu.product_id
group by customer_id
order by customer_id


--2.How many days has each customer visited the restaurant?

select customer_id, count(distinct(order_date)) as 
from sales 
group by customer_id
order by customer_id

--3.What was the first item from the menu purchased by each customer?

with cte_order as( select sales.customer_id, menu.product_name,
ROW_NUMBER() over (partition by sales.customer_id
order by
sales.order_date,
sales.product_id) as item_order
FROM sales
    JOIN menu
    ON sales.product_id = menu.product_id 
)
select customer_id,product_name
from cte_order
where item_order = 1

--4.What is the most purchased item on the menu and how many times was it purchased by all customers?

select sales.product_id,menu.product_name,count(sales.product_id) as order_count
from sales inner join menu
on sales.product_id = menu.product_id
group by sales.product_id,menu.product_name
order by order_count desc
OFFSET 0 ROWS 
FETCH FIRST 1 ROWS ONLY

--5.Which item was the most popular for each customer?

with cte_rank as(
select customer_id,product_name,count(sales.product_id) as order_count,
RANK () over(partition by sales.customer_id 
order by count(sales.product_id) desc) as rank
from sales join menu
on sales.product_id=menu.product_id
group by customer_id,sales.product_id,menu.product_name
)
select customer_id,product_name,order_count
from cte_rank
where rank=1

--6.Which item was purchased first by the customer after they became a member?

with cte_rank as(
select sales.customer_id,menu.product_name,members.join_date,sales.order_date,
RANK() over(partition by sales.customer_id order by sales.order_date) as rank
from sales 
join menu on sales.product_id=menu.product_id
join members on sales.customer_id=members.customer_id
where sales.order_date>members.join_date
)
select customer_id,product_name,join_date as loyalty_join_date,order_date
from cte_rank
where rank =1

--7.Which item was purchased just before the customer became a member?

with cte_rank as(
select sales.customer_id,menu.product_name,members.join_date,sales.order_date,
RANK() over(partition by sales.customer_id order by sales.order_date desc) as rank
from sales 
join menu on sales.product_id=menu.product_id
join members on sales.customer_id=members.customer_id
where sales.order_date<members.join_date
)
select customer_id,product_name,order_date,join_date as loyalty_join_date
from cte_rank
where rank =1

--8.What is the total items and amount spent for each member before they became a member?

select sales.customer_id,COUNT(sales.product_id) total_item,SUM(menu.price) amount_spent
from sales 
join menu on sales.product_id=menu.product_id
join members on sales.customer_id=members.customer_id
where members.join_date>sales.order_date
group by sales.customer_id
order by sales.customer_id

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with cte_points as (
Select *, Case When product_name = 'sushi' THEN price*20
               Else price*10
	       End as Points
From Menu
)
select sales.customer_id,sum(cte_points.Points) as points
from sales join cte_points on sales.product_id=cte_points.product_id
group by sales.customer_id

--10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


WITH cte_dates as (
   SELECT *, 
      DATEADD(DAY, 6, join_date) AS valid_date, 
      EOMONTH('2021-01-31') AS last_date
   FROM members 
)
Select sales.Customer_id, 
       SUM(Case 
	  When sales.order_date between cte_dates.join_date and cte_dates.valid_date Then menu.price*20
	  When menu.product_name = 'sushi' THEN menu.price*20
	  Else menu.price*10
	  END 
	  ) as Points
From cte_dates
join Sales
On cte_dates.customer_id = sales.customer_id
Join menu
On menu.product_id = sales.product_id
Where sales.order_date < cte_dates.last_date
Group by sales.customer_id
