## Case Study #1: Danny's Diner 
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="Image" width="500" height="520">

  View the [**case study**](https://8weeksqlchallenge.com/case-study-1/) and my [**solution**](https://github.com/leo7736/SQL_Projects/blob/main/Danny's%20Diner-SQL%20Challenge/danny's%20diner.sql)
 
## Problem Statement
  Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!


##  Dataset
Danny has shared with you 3 key datasets for this case study:

### **```sales```**

<details>
<summary>
View table
</summary>

The sales table captures all ```customer_id``` level purchases with an corresponding ```order_date``` and ```product_id``` information for when and what menu items were ordered.

|customer_id|order_date|product_id|
|-----------|----------|----------|
|A          |2021-01-01|1         |
|A          |2021-01-01|2         |
|A          |2021-01-07|2         |
|A          |2021-01-10|3         |
|A          |2021-01-11|3         |
|A          |2021-01-11|3         |
|B          |2021-01-01|2         |
|B          |2021-01-02|2         |
|B          |2021-01-04|1         |
|B          |2021-01-11|1         |
|B          |2021-01-16|3         |
|B          |2021-02-01|3         |
|C          |2021-01-01|3         |
|C          |2021-01-01|3         |
|C          |2021-01-07|3         |

 </details>

### **```menu```**

<details>
<summary>
View table
</summary>

The menu table maps the ```product_id``` to the actual ```product_name``` and price of each menu item.

|product_id |product_name|price     |
|-----------|------------|----------|
|1          |sushi       |10        |
|2          |curry       |15        |
|3          |ramen       |12        |

</details>

### **```members```**

<details>
<summary>
View table
</summary>

The final members table captures the ```join_date``` when a ```customer_id``` joined the beta version of the Danny’s Diner loyalty program.

|customer_id|join_date |
|-----------|----------|
|A          |1/7/2021  |
|B          |1/9/2021  |

 </details>

 
### Entity Relationship Diagram:

![image](https://github.com/leo7736/SQL_Projects/blob/main/Danny's%20Diner-SQL%20Challenge/images/hp.danny's_diner%20-%20Diagram_0_%20-%20Microsoft%20SQL%20Server%20Management%20Studio%2028-Mar-23%2011_44_49%20AM%20(2).png)

  
### Case Study Questions:

1.  What is the total amount each customer spent at the restaurant?
2.  How many days has each customer visited the restaurant?
3.  What was the first item from the menu purchased by each customer?
4.  What is the most purchased item on the menu and how many times was it purchased by all customers?
5.  Which item was the most popular for each customer?
6.  Which item was purchased first by the customer after they became a member?
7.  Which item was purchased just before the customer became a member?
8.  What is the total items and amount spent for each member before they became a member?
9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
    not just sushi - how many points do customer A and B have at the end of January?
    
### suggestions for improving Danny's business

1.Offer seasonal specials or limited-time menu items to keep customers interested and coming back.

2.Implement a referral program where customers can receive discounts or free items for bringing in new customers.

3.Collect feedback from customers through surveys or suggestion boxes to identify areas for improvement and address any concerns.
