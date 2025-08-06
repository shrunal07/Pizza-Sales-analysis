CREATE DATABASE Pizza_Sales_Analysis


pizzas: (pizza_id (PK), pizza_type_id, size, price)
pizza_types: (pizza_type_id (PK), name, category, ingredients)
orders: (order_id (PK), date, time)
order_details: (order_details_id (PK), order_id, pizza_id, quantity)


SELECT * FROM ORDER_DETAILS
SELECT * FROM ORDERS
select * from pizza_types
select * from pizzas


--1. Retrieve all orders:
SELECT * FROM orders;
--Answer: Returns all orders with order_id, date, and time.


--2. Total number of pizzas available:
SELECT COUNT(*) AS total_pizzas FROM pizzas;
--Answer: Shows the total number of pizza records.


--3. Unique pizza sizes available:
SELECT DISTINCT size FROM pizzas;
--Answer: Lists all unique pizza sizes offered.


--4. Orders placed on a specific date ('2024-06-01'):
SELECT * FROM orders WHERE date = '2024-06-01';
--Answer: Retrieves orders placed on June 1, 2024.

--5. Total revenue generated from pizza sales:
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
--Answer: Calculates total sales revenue.


--6. Top 5 most frequently ordered pizzas:
SELECT TOP 5 p.pizza_id, pt.name, SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name
ORDER BY total_ordered DESC;
--Answer: Returns the five most frequently ordered pizzas.


--7. Average price of pizzas by category:
SELECT pt.category, AVG(p.price) AS avg_price
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;
--Answer: Provides the average price of pizzas per category.


--8. Highest revenue-generating pizza type:
SELECT TOP 1 pt.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC;
--Answer: Identifies the most profitable pizza.


--9. Top 3 busiest order dates:
SELECT TOP 3 date, COUNT(order_id) AS order_count
FROM orders
GROUP BY date
ORDER BY order_count DESC;
--Answer: Returns the top three dates with the highest order volume.


--10.Least ordered pizza:
SELECT TOP 1 p.pizza_id, pt.name, SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name
ORDER BY total_ordered ASC;
--Answer: Identifies the least popular pizza.


--11.Month-over-month growth in pizza sales:
SELECT DATEPART(YEAR, date) AS year, DATEPART(MONTH, date) AS month,
SUM(od.quantity) AS total_sales,
LAG(SUM(od.quantity)) OVER (ORDER BY DATEPART(YEAR, date), DATEPART(MONTH,
date)) AS prev_month_sales,
(SUM(od.quantity) - LAG(SUM(od.quantity)) OVER (ORDER BY DATEPART(YEAR,
date), DATEPART(MONTH, date))) * 100.0 / LAG(SUM(od.quantity)) OVER (ORDER
BY DATEPART(YEAR, date), DATEPART(MONTH, date)) AS growth_percentage
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DATEPART(YEAR, date), DATEPART(MONTH, date);
--Answer: Computes the month-over-month sales growth.


--12.Percentage contribution of each pizza category to total sales:
SELECT pt.category, SUM(od.quantity * p.price) AS category_sales,
SUM(od.quantity * p.price) * 100.0 / (SELECT SUM(od.quantity * p.price)
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id) AS
sales_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;
--Answer: Shows the percentage contribution of each pizza category.


--13.Rank pizzas by their popularity:

SELECT p.pizza_id, pt.name, SUM(od.quantity) AS total_ordered,
RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS rank_order
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name;
--Answer: Assigns a rank to pizzas based on their popularity.


--14. Optimized query for fetching all orders with pizza details:
CREATE INDEX idx_order_details ON order_details(order_id, pizza_id);
SELECT o.order_id, o.date, o.time, pt.name, p.size, od.quantity, p.price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id;
--Answer: Uses indexing to improve query performance when retrieving order details.


--Retrieve all columns from the orders table.
SELECT * FROM orders;


--Find the total number of pizzas available in the pizzas table.
SELECT COUNT(*) AS total_pizzas FROM pizzas;


--List unique pizza sizes available.
SELECT DISTINCT size FROM pizzas;


--Retrieve orders placed on a specific date ('2024-06-01').
SELECT * FROM orders WHERE date = '2024-06-01';


--Find the total revenue generated from pizza sales.
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

--Retrieve the names of all pizza categories from the pizza_types table.
SELECT DISTINCT category FROM pizza_types;


--Find the most expensive pizza and its price.
SELECT TOP 1 * FROM pizzas ORDER BY price DESC;


--Count the number of orders placed in the last 7 days.
SELECT COUNT(*) AS recent_orders
FROM orders
WHERE date >= DATEADD(DAY, -7, GETDATE());

--List all orders along with the number of pizzas in each order.
SELECT od.order_id, SUM(od.quantity) AS total_pizzas
FROM order_details od
GROUP BY od.order_id;


--Retrieve pizzas that cost more than $15 but less than $25.
SELECT * FROM pizzas WHERE price BETWEEN 15 AND 25;



--Find the top 5 most frequently ordered pizzas.
SELECT TOP 5 p.pizza_id, pt.name, SUM(od.quantity) AS total_ordered
FROM order_details AS od
JOIN 
pizzas AS p ON od.pizza_id = p.pizza_id
JOIN 
pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name
ORDER BY total_ordered DESC;

--Retrieve the average price of pizzas by category.
SELECT pt.category, AVG(p.price) AS avg_price
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


--Identify customers who placed more than 5 orders in a month.
--(Assuming there is a customer_id column in orders)
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
WHERE DATEPART(MONTH, date) = DATEPART(MONTH, GETDATE())
GROUP BY customer_id
HAVING COUNT(order_id) > 5;


--Retrieve the most popular pizza size based on orders.
SELECT TOP 1 p.size, SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_ordered DESC;


--Find the highest revenue-generating pizza type.
SELECT TOP 1 pt.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC;


--List the top 3 busiest order dates based on the number of orders.
SELECT TOP 3 date, COUNT(order_id) AS order_count
FROM orders
GROUP BY date
ORDER BY order_count DESC;


--Calculate the total quantity of pizzas sold per pizza type.
SELECT pt.name, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_sold DESC;


--Find the least ordered pizza.
SELECT TOP 1 p.pizza_id, pt.name, SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name
ORDER BY total_ordered ASC;


--Show the cumulative sales revenue per day for the last 30 days.
SELECT date, SUM(od.quantity * p.price) OVER (ORDER BY date) AS
cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
WHERE date >= DATEADD(DAY, -30, GETDATE());


--Identify orders where more than 3 pizzas were ordered in a single transaction.
SELECT order_id, SUM(quantity) AS total_pizzas
FROM order_details
GROUP BY order_id
HAVING SUM(quantity) > 3;


--Calculate the month-over-month growth in pizza sales.
SELECT
 DATEPART(YEAR, date) AS year,
 DATEPART(MONTH, date) AS month,
 SUM(od.quantity) AS total_sales,
 LAG(SUM(od.quantity)) OVER (ORDER BY DATEPART(YEAR, date),
DATEPART(MONTH, date)) AS prev_month_sales,
 (SUM(od.quantity) - LAG(SUM(od.quantity)) OVER (ORDER BY DATEPART(YEAR,
date), DATEPART(MONTH, date))) * 100.0 / LAG(SUM(od.quantity)) OVER (ORDER
BY DATEPART(YEAR, date), DATEPART(MONTH, date)) AS growth_percentage
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DATEPART(YEAR, date), DATEPART(MONTH, date);


--Find the percentage contribution of each pizza category to total sales.
SELECT pt.category,
 SUM(od.quantity * p.price) AS category_sales,
 SUM(od.quantity * p.price) * 100.0 / (SELECT SUM(od.quantity *
p.price) FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id)
AS sales_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


--Find repeat customers (customers who placed more than 3 orders in different months).
SELECT customer_id, COUNT(DISTINCT DATEPART(MONTH, date)) AS active_months
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT DATEPART(MONTH, date)) > 3;


--Rank pizzas by their popularity using the RANK() window function.
SELECT p.pizza_id, pt.name, SUM(od.quantity) AS total_ordered,
 RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS rank_order
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name;


--Optimize a query fetching all orders with pizza details using indexing and joins.
CREATE INDEX idx_order_details ON order_details(order_id, pizza_id);
SELECT o.order_id, o.date, o.time, pt.name, p.size, od.quantity, p.price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id;
