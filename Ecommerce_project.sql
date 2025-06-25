create database jatin_sql_project;
use jatin_sql_project;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    region VARCHAR(20)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);



CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Alice', 'North'),
(2, 'Bob', 'South'),
(3, 'Charlie', 'East'),
(4, 'David', 'West'),
(5, 'Eve', 'North');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 75000),
(102, 'Headphones', 'Electronics', 2000),
(103, 'Notebook', 'Stationery', 100),
(104, 'Pen', 'Stationery', 20),
(105, 'Backpack', 'Accessories', 1500);

INSERT INTO orders VALUES
(1001, 1, '2024-01-10'),
(1002, 2, '2024-01-15'),
(1003, 3, '2024-02-10'),
(1004, 4, '2024-02-18'),
(1005, 1, '2024-03-05'),
(1006, 5, '2024-03-25');

INSERT INTO order_items VALUES
(1, 1001, 101, 1),
(2, 1001, 102, 2),
(3, 1002, 103, 5),
(4, 1003, 104, 10),
(5, 1004, 101, 1),
(6, 1005, 105, 1),
(7, 1006, 103, 10),
(8, 1006, 102, 1);

-- total revenue by month
select month(order_date)as order_month, sum(products.price*order_items.quantity) as total_revenue
from orders
join order_items on orders.order_id= order_items.order_id
join products on order_items.product_id=products.product_id
group by month(order_date)
order by order_month;

-- top 5 customer who spend most
select customers.customer_name, sum(products.price*order_items.quantity) as total_spend
from customers
join orders
on customers.customer_id=orders.customer_id
join order_items
on orders.order_id=order_items.order_id
join products
on order_items.product_id=products.product_id
group by customers.customer_name
order by total_spend desc
limit 5;
-- product , quantity , total revenue- 
select products.product_name, sum(order_items.quantity),
sum(products.price*order_items.quantity) as total_revenue
from products
join order_items
on products.product_id=order_items.product_id
group by products.product_name;

-- total orders by region ,total revenue , avg_values
select customers.region , count(distinct orders.order_id) as total_orders,sum(products.price*order_items.quantity) as total_revenue,
sum(products.price*order_items.quantity)/count(distinct orders.order_id )as avg_value
from customers
join orders
on customers.customer_id=orders.customer_id
join order_items
on orders.order_id=order_items.order_id
join products
on order_items.product_id=products.product_id
group by customers.region;

-- months with total revenue and prev_month revenue and diff
with dallas as(
select month(orders.order_Date) as months ,sum(products.price*order_items.quantity) as total_revenue
from orders 
join order_items
on orders.order_id=order_items.order_id

join products
on order_items.product_id=products.product_id
group by month(orders.order_Date)
)
select months,total_revenue,lag(total_revenue)over ( order by months ) as prev_month,
total_revenue - lag(total_revenue) over ( order by months) as diff
from dallas;

-- dense ranked products on total_revenue
with dallas as(
select
 products.product_name , sum(products.price*order_items.quantity) as total_revenue
 from products
 join order_items
 on products.product_id=order_items.product_id
 group by products.product_name)
 
 select *,
 dense_rank() over (order by total_revenue desc) as ranked
 from dallas;

-- customer days gap btwn order and previous order 
with dallas as (
select customers.customer_name as customer_name, orders.order_Date as order_date
from customers
join orders
on customers.customer_id= orders.customer_id
)
select * , lead(order_date)over (partition by customer_name  order by order_date) as next_order,
datediff(lead(order_date)over (partition by customer_name  order by order_date),order_date) as gapdays
from dallas;

-- customers who returne to shop again  
with dallas as (
select customers.customer_name as customer_name, count(orders.order_id) as total_orders
from customers
join orders
on customers.customer_id= orders.customer_id
group by customers.customer_name
)
select * ,
case 
    when total_orders>1 then "returned"
else "no"
end as return_status
from dallas;