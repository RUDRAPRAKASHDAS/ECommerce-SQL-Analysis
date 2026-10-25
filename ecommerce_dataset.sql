use e_commerce_project;
show tables;
select * from customers limit 10;
select * from orders limit 10;
select * from order_items limit 10;
select * from products limit 10;
-- 1.What is our total revenue so far?
SELECT SUM(quantity * unit_price) AS total_revenue
FROM order_items;
-- 2.How many total orders have we received?
select count(*) as total_order from orders;
-- --3.How many total customers do we have?
select count(*) as total_customers from customers ;
-- 4.How many total products do we sell?
select count(*) as total_Products from products;
-- 5.what is the average amount a customer spends per orders

select round(sum(quantity*unit_price)/count(distinct order_id ),2) as avg_orders
from order_items;
-- 6.What are the top 5 best-selling products?
select p.product_name,sum(o.quantity) as total_qty
from order_items o join products p on 
o.product_id=p.product_id
group by product_name
order by total_qty desc
limit 5;
-- 7.Which category is generating the most revenue?
select p.category,sum(oi.quantity*oi.unit_price) as Total_revenue
from order_items oi join products p on oi.product_id= p.product_id
group by p.category
order by Total_revenue;
-- 8.Who are our top 5 most valuable customers?
select c.customer_id,c.customer_name,sum(oi.quantity*oi.unit_price) as revenue
from orders o join customers c on c.customer_id= o.customer_id 
join order_items oi on oi.order_id=o.order_id
group by c.customer_id, c.customer_name
order by revenue desc limit 5;
-- 9.How has our revenue trended month by month?
select date_format(o.order_date,'%Y-%M') as month,
sum(oi.quantity*oi.unit_price) as total_revenue
from orders o join order_items oi on oi.order_id=o.order_id
group by month 
order by month desc;

-- 10.Which city is generating the most sales?
select c.city, round(sum(oi.quantity*oi.unit_price),2) as rev
from customers c join orders o on o.customer_id= c.customer_id 
join order_items oi on oi.order_id=o.order_id 
group by c.city 
order by rev desc 
limit 1;
-- 11.find duplicate puchase orders?
select customer_id, count(order_id) as total_orders from orders 
group by customer_id 
having total_orders >1
order by total_orders desc;
-- 12.Which customers have never placed an order?
select c.customer_ID ,c.customer_name from customers c 
left join orders o  on c.customer_id = o.customer_id 
where o.customer_id is null ;
-- 13.Which customers have been inactive in the last 90 days?
select c.customer_id,c.customer_name ,max(o.order_date ) as last_orders
from customers c left join orders o on c.customer_id = o.customer_id
group by  c.customer_id,c.customer_name 
having last_orders <"2026-07-30" or last_orders is null 
order by last_orders ;
-- with cte 
WITH last_orders AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       last_order_date
FROM last_orders
WHERE last_order_date IS NULL 
   OR DATEDIFF('2026-04-30', last_order_date) > 90;

---------

SELECT c.customer_id,
       c.customer_name,
       MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING DATEDIFF(CURDATE(), MAX(o.order_date)) > 90;
-- What is the best-selling category?
select p.category,sum(oi.quantity) as unit_sold
from products p join order_items oi  on oi.product_id= p.product_id
group by p.category
order by unit_sold desc
limit 1;
-- which product generate highest revenue 
select p.product_name , round(sum(oi.quantity*oi.unit_price),2) as total_revenue 
from products p join order_items oi on oi.product_id = p. product_id 
group by p.product_name
order by total_revenue desc
limit 1;
-- which product generate lowest revenue
select p.product_name , round(sum(oi.quantity*oi.unit_price),2) as total_revenue 
from products p join order_items oi on oi.product_id = p. product_id 
group by p.product_name
order by total_revenue asc
limit 1;
-- on average how many product are bought per order
select avg(product_count) as avg_count from (select order_id,sum(quantity) as product_count 
from order_items 
group by order_id )t;
-- Which orders are worth more than 10,000?
select order_id,sum(quantity*unit_price ) as total_price 
from order_items 
group by order_id 
having total_price >10000
order by total_price desc;
-- 19.Which customers have the highest average order value?
select customer_id ,avg(order_value) as avg_value from (select o.customer_id ,o.order_id,sum(oi.quantity*oi.unit_price) as order_value
from orders o 
join order_items oi on o.order_id=oi.order_id 
group by o.customer_id ,o.order_id 
order by order_value) t
group by customer_id 
order by avg_value desc
limit 1;
-- 20.What are the top 3 cities by revenue?
select c.city, sum(oi.quantity*oi.unit_price) as total_revenue 
 from customers c join orders o on o.customer_id= c.customer_id join 
 order_items oi on oi.order_id=o.order_id 
 group by c.city
 order by total_revenue desc
 limit 3 ;
 
-- 21.How are customers ranked based on revenue?
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue_rank;
-- or 
with customer_rev as ( select o.customer_id,
    SUM(oi.quantity * oi.unit_price) AS total_revenue from orders o join order_items oi on 
      o.order_id = oi.order_id
     group by o.customer_id)
     select customer_id ,total_revenue,dense_rank()over(order by total_revenue desc) as rnk 
     from customer_rev
     order by rnk  ;
-- 22.What is the top-selling product in each category?
with cte as ( select p.category,p.product_name , sum(oi.quantity) as total_sold
from products p join order_items oi on oi.product_id=p.product_id 
group by p.category,p.product_name)
select category, product_name ,total_sold from 
( select *, row_number()over(partition by category order by total_sold desc) as rnk 
from cte )t
where rnk =1;
;
-- or
select category,product_name,Total_sold from(
select p.category,p.product_name,sum(oi.quantity) as Total_sold,
row_number() over(partition by category order by sum(oi.quantity) desc) as rnk 
from products p
join order_items oi on oi.product_id = p.product_id 
group by p.category,p.product_name)t
where rnk =1;

-- 23.How has our revenue accumulated over time — running total?
with daily_sales as ( select o.order_date, sum(oi.quantity*oi.unit_price) as revenue 
from orders o 
join order_items oi on o.order_id =oi.order_id 
group by o.order_date)
select order_date,revenue,sum(revenue)over(order by revenue ) as running_total 
from daily_sales 
order by order_date 
limit 5;
-- 24.When was each customer's previous order placed?
select customer_id,order_id,order_date,lag(order_date)over(partition by customer_id order by order_date) as privious_date 
from orders 
order by customer_id , order_date ;
-- 25.When was each customer's next  order placed?
select customer_id,order_id,order_date,lead(order_date)over(partition by customer_id order by order_date) as Next_date 
from orders 
order by customer_id , order_date ;
-- or
select c.customer_id, c.customer_name, o.order_id,o.order_date,
lag(o.order_date)over(partition by c.customer_id order by o.order_date) as privious_orders
from customers c join orders o on c.customer_id = o.customer_id
order by c.customer_id, o.order_date;
-- 26.How many days are there between a customer's consecutive orders?
select customer_id ,order_date ,
datediff(order_date,lag(order_date)over(partition by customer_id order by order_date)) as days_between_orders
from orders ;
-- 27.Who are the top 3 customers by revenue?
select c.customer_id, sum(oi.quantity*oi.unit_price) as total_revenue 
 from customers c join orders o on o.customer_id= c.customer_id join 
 order_items oi on oi.order_id=o.order_id 
 group by c.customer_id
 order by total_revenue desc
 limit 3 ;
--  or
with customer_revenue as (select c.customer_id, sum(oi.quantity*oi.unit_price) as total_revenue 
 from customers c join orders o on o.customer_id= c.customer_id join 
 order_items oi on oi.order_id=o.order_id 
 group by c.customer_id )
 select customer_id,total_revenue,rnk from ( select *,dense_rank()over(order by total_revenue desc ) as rnk 
 from customer_revenue )t 
 where rnk <=3;
-- 28. What percentage does each product contribute to total revenue?
with product_info as (select p.product_name,sum(oi.quantity*oi.unit_price) as total_revenue
from products p left join order_items oi on p.product_id=oi.product_id
group by p.product_name )
select product_name ,total_revenue,round((total_revenue*100)/sum(total_revenue)over(),0) as percentage
from product_info
order by total_revenue desc;

--  29.What is the month-over-month revenue growth?
with monthly_sales as (
select date_format(o.order_date, "%Y-%m") as months ,sum(oi.quantity*oi.unit_price) as revenue 
from orders o join order_items oi on oi.order_id = o.order_id 
group by  months
order by months)
select *,lag(revenue)over(order by months) as privious_month_sales ,
round((100*(revenue - lag(revenue)over(order by months))/lag(revenue)over(order by months)),0) as mom_growth_percentage 
from monthly_sales;
--  30.What was each customer's highest-value order?
with Highest_value as (select c.customer_id ,o.order_id,sum(oi.quantity*oi.unit_price) as revenue 
from customers c join orders o on c.customer_id=o.customer_id join
order_items oi on oi.order_id=o.order_id
group by c.customer_id ,o.order_id
order by revenue desc)
select * from (select *,row_number()over(Partition by customer_id order by revenue desc)as rnk
from Highest_value) t
where rnk =1;
-- 31.What is each customer's lifetime value — CLV?
select c.customer_id ,o.order_id,sum(oi.quantity*oi.unit_price) as customer_lifetime_orders
from customers c join orders o on c.customer_id=o.customer_id join
order_items oi on oi.order_id=o.order_id
group by c.customer_id ,o.order_id
order by customer_lifetime_orders desc;
-- 32.What percentage of customers make repeat purchases?
with customer_purchage as ( select customer_id,count(*) as total_order
from orders
group by customer_id)
select round(100*count(case when total_order>1 then 1 end)/count(*),0) as repeat_purchase_percentage
from customer_purchage;
-- 33.How many customers are new vs returning?
WITH first_orders AS (
    SELECT customer_id,
           MIN(order_date) AS first_order
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN o.order_date = f.first_order
            THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS customer_type,
    COUNT(*) AS total_orders
FROM orders o
JOIN first_orders f
    ON o.customer_id = f.customer_id
GROUP BY customer_type;
-- 34.How many customers were active each month — retention?
WITH CTE AS ( SELECT distinct CUSTOMER_ID, date_format(ORDER_DATE,"%y-%M") AS ORDER_MONTH
FROM ORDERS)
SELECT ORDER_MONTH ,COUNT(distinct CUSTOMER_ID ) AS ACTIVE_CUSTOMER 
FROM CTE
GROUP BY ORDER_MONTH
ORDER BY ACTIVE_CUSTOMER;
-- 35.(Which customers purchase from more than one category?)
SELECT O.CUSTOMER_ID , COUNT(DISTINCT P.CATEGORY) AS CTGR
FROM ORDERS O JOIN ORDER_ITEMS OI ON OI.ORDER_ID =O.OREDR_ID 
JOIN PRODUCTS P ON P.PRODUCTS_ID =O.PRODUCT_ID 
GROUP BY O.CUSTMER_ID 
HAVING COUNT(DISTINCT P.CATEGORY)>1;
-- 36.Which customers purchase from more than one category?
select oi1.product_id  as product_1,
oi2.product_id as product_2,
count(*) as total_count from order_items oi1 
join order_items oi2
on oi1.order_id =oi2.order_id and oi1.product_id<oi2.product_id
group by oi1.product_id,oi2.product_id
order by total_count desc
limit 10;
-- 37.On average, how many days pass between a customer's orders?
with Order_Gap as ( select customer_id ,order_date ,lag(order_date)over(
partition by customer_id order by order_date ) as previous_order_date
from orders )
select customer_id ,round(avg(datediff(order_date,previous_order_date)),0) as avg_days_between_orders
from Order_Gap
where previous_order_date is not  null
group by customer_id 
order by avg_days_between_orders;
-- 38.Which product category is growing the fastest?
with monthly_sales as (
  select date_format(order_date ,"%y-%m") as month_date ,
  p.category,sum(oi.quantity*oi.unit_price) as revenue 
   FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.category, month_date)
    select month_date ,category,revenue as rvn,
    round(revenue-lag(revenue)over(partition by category order by month_date ),0) as revenue_growth 
    from monthly_sales
    order by revenue_growth desc;
--    39.Which customers are at risk of churn?
select customer_id ,max(order_date) as last_order_date 
from orders 
group by customer_id 
having max(order_date)<"2026-04-30"
order by last_order_date;
-- 40.How do customers look based on RFM — Recency, Frequency, Monetary — analysis?
select o.customer_id,datediff('2026-07-30',max(o.order_date) )as Recency ,
count(distinct o.order_id ) as frequancy ,
sum(oi.quantity*oi.unit_price) as Monetary
from orders o join
order_items oi on o.order_id = oi.order_id 
group by customer_id 
order by Monetary;
-- 41.What is the daily sales trend?
select o.order_date , sum(oi.quantity*oi.unit_price) as Total_revenue 
from orders o join order_items oi on 
o.order_id=oi.order_id
group by o.order_date
order by Total_revenue;
-- 42.What are the top 10 best-selling products?
 select p.product_name , sum(oi.quantity) as total_product 
 from Order_items oi join products p
 on P.product_id = oi.product_id
 Group by p.product_name
 order by total_product desc 
 limit 10;
 
--  43.Who are the top 10 customers by revenue?)
 SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;
-- 44.How much revenue comes from male vs female customers?
select c.gender, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.gender
order by total_revenue desc;
-- 45.What is our customer churn rate?
WITH churned_customers AS (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING MAX(order_date) < CURRENT_DATE - INTERVAL 90 DAY
)
SELECT
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT customer_id) FROM customers),
        2
    ) AS churn_rate
FROM churned_customers;
-- 46.(What percentage of orders get cancelled?)
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS cancellation_percentage
FROM orders;
-- 47.How many orders were delivered vs cancelled?
SELECT
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
FROM orders;
-- 48.(What is the worst-selling category?)
SELECT
    p.category,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_sold ASC
LIMIT 1;
49.What is the most expensive product sold?
SELECT
    p.product_name,
    oi.unit_price
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
ORDER BY oi.unit_price DESC
LIMIT 1;
-- 50.Which month had the highest revenue?
SELECT
    MONTH(o.order_date) AS month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date)
ORDER BY revenue DESC
LIMIT 1;
-- 51.How many new customers were acquired each month?
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    DATE_FORMAT(first_order_date, '%Y-%m') AS month,
    COUNT(customer_id) AS new_customers
FROM first_orders
GROUP BY DATE_FORMAT(first_order_date, '%Y-%m')
ORDER BY month;
-- 52.What percentage does each category contribute to total revenue?
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.category
)
SELECT
    category,
    revenue,
    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM category_revenue
ORDER BY revenue_percentage DESC;
-- END