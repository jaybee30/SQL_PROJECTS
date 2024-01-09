create database Tiny_shop_sales;

use Tiny_shop_sales;

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);


select * from customers;
select * from products;

-- Case study --
-- 1. Which product has the highest price? Only return a single row--
select product_name, max(price), concat('$', PRICE) as highest_price from products
group by product_name
order by price desc limit 1;

-- 2. Which customer has made the most orders?--
select c.first_name, c.last_name, a.customer_id as customer_info, max(b.quantity) as most_orders from orders a
join order_items b on b.order_id= a.order_id
join customers c on c.customer_id=a.customer_id
group by a.customer_id
order by max(b.quantity)
limit 1;

-- 3. What’s the total revenue per product?--
select product_name, sum(price*quantity) as Total_revenue from products
join order_items on order_items.product_id=products.product_id
group by product_name
order by Total_revenue desc;

-- 4. Find the day with the highest revenue.--
select o.order_date as day, sum(p.price*q.quantity) as Highest_revenue from orders o
join order_items q on q.order_id = o.order_id
join products p on p.product_id = q.product_id
group by order_date
order by Highest_revenue desc limit 1;

-- 5. Find the first order (by date) for each customer-- 

-- 6 Find the top 3 customers who have ordered the most distinct products--
select x.customer_id as customers, z.product_name, count( distinct z.product_name) as most_distinct_product from orders x
join order_items y on y.order_id=x.order_id
join products z on z.product_id = y.product_id
group by customers
order by most_distinct_product
desc limit 3;

-- 7. Which product has been bought the least in terms of quantity?--
select d.product_name as product, sum(e.quantity) as least_bought from products d 
join order_items e on e.product_id=d.product_id
group by product
order by least_bought asc;

-- 8. What is the median order total?--
