create schema dominos;
RENAME TABLE dominos.`data model - pizza sales.xlsx - pizza_sales`TO pizza;


## Q 1. Retrieve the total number of orders placed.
select count(order_id) as total_orders from pizza;


## Q 2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(total_price), 2) AS total_revenue
FROM
    pizza;


## Q 3. Calculate the average pizza per order.

SELECT 
    CAST(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id)
        AS DECIMAL (10 , 2 )) AS 'Avg Price Per Order'
FROM
    pizza;
    
    
## Q 4. Find the Percentage of Orders Made by Each Customer

SELECT 
    order_id, 
    (COUNT(*) / (SELECT COUNT(*) FROM pizza) * 100) AS percentage_of_orders
FROM 
    pizza
GROUP BY 
    order_id
ORDER BY 
    percentage_of_orders DESC;


## Q 5. Top and Bottom 5 Pizzas by revenue

SELECT 
    pizza_name, 
    ROUND(SUM(total_price)) AS total_revenue 
FROM 
    pizza
GROUP BY 
    pizza_name
ORDER BY 
    total_revenue DESC
LIMIT 5; -- Fetch the top 5 pizzas
------##-----##-----##---
SELECT 
    pizza_name, 
    ROUND(SUM(total_price)) AS total_revenue -- Rounds total revenue to the nearest whole number
FROM 
    pizza
GROUP BY 
    pizza_name
ORDER BY 
    total_revenue ASC
LIMIT 5; -- Fetech the bottom 5 pizzas

## Q 6. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_category, 
    SUM(quantity * total_price) AS Revenue,
    ROUND((SUM(quantity * total_price) / (SELECT SUM(quantity * total_price) FROM pizza) * 100)) AS Percentage_Contribution
FROM 
    pizza
GROUP BY 
    pizza_category
ORDER BY 
    Revenue DESC;


## Q 7.Identify the highest-priced pizza.
SELECT 
    pizza_name, total_price
FROM
    pizza
ORDER BY total_price DESC
LIMIT 1;

## Q 8.Identify the most common pizza size ordered.

SELECT 
    pizza_size, 
    COUNT(*) AS total_orders
FROM 
    pizza
GROUP BY 
    pizza_size
ORDER BY 
    total_orders DESC;
    
    
## Q 9. Identify the Most Popular Pizza Flavor in Each Category    
    
SELECT 
    pizza_category,
    pizza_name,
    total_quantity_sold
FROM (
    SELECT 
        pizza_category,
        pizza_name, 
        SUM(quantity) AS total_quantity_sold,
        RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(quantity) DESC) as Rank_
    FROM 
        pizza
    GROUP BY 
        pizza_category, pizza_name
) AS ranked_pizzas
WHERE 
    rank_ = 1
ORDER BY 
    pizza_category;
    
    
## Q 10. Identify the day with the highest number of orders.

    SELECT 
    order_date, 
    COUNT(order_id) AS total_orders
FROM 
    pizza
GROUP BY 
    order_date
ORDER BY 
    total_orders DESC
LIMIT 1;


## Q 11. Retrieve the most profitable day (highest revenue).

SELECT 
    order_date, 
    ROUND(SUM(total_price), 2) AS total_revenue
FROM 
    pizza
GROUP BY 
    order_date
ORDER BY 
    total_revenue DESC
LIMIT 1;


## Q 12. Identify peak ordering hours.

SELECT 
    HOUR(order_time) AS order_hour, 
    COUNT(order_id) AS total_orders
FROM 
    pizza
GROUP BY 
    HOUR(order_time)
ORDER BY 
    total_orders DESC;
