USE restaurant_db;

-- Explore Items Table
-- Write a query to find the number of items on the menu
SELECT 
    COUNT(menu_item_id) AS no_of_items
FROM
    menu_items;

-- What are the least and most expensive items on the menu?
(SELECT 
    item_name, price
FROM
    menu_items
GROUP BY item_name
ORDER BY price DESC
LIMIT 1)
UNION
(SELECT 
    item_name, price
FROM
    menu_items
GROUP BY item_name
ORDER BY price
LIMIT 1);

-- How many Italian dishes are on the menu?
SELECT 
    COUNT(menu_item_id)
FROM
    menu_items
WHERE
    category = 'Italian';
    
-- What are the least and most expensive Italian dishes on the menu?
(SELECT 
    item_name, price
FROM
    menu_items
WHERE
    category = 'Italian'
GROUP BY item_name
ORDER BY price DESC
LIMIT 1) UNION (SELECT 
    item_name, price
FROM
    menu_items
WHERE
    category = 'Italian'
GROUP BY item_name
ORDER BY price
LIMIT 1);

-- How many dishes are in each category?
SELECT 
    category, COUNT(menu_item_id) as no_of_items
FROM
    menu_items
GROUP BY category;

-- What is the average dish price within each category?
SELECT 
    category, ROUND(AVG(price), 2) AS avg_price
FROM
    menu_items
GROUP BY category
ORDER BY avg_price;

-- Explore Orders Table
-- What is the date range of the table?
SELECT 
    MIN(order_date), MAX(order_date)
FROM
    order_details;

-- How many items were ordered within this date range?
SELECT 
    COUNT(DISTINCT order_id) AS no_of_orders
FROM
    order_details;

-- Which orders had the most number of items?
SELECT 
    order_id, COUNT(item_id) AS no_of_dishes_ordered
FROM
    order_details
GROUP BY order_id
ORDER BY no_of_dishes_ordered DESC
LIMIT 1;

-- How many orders had more than 12 items?
SELECT COUNT(order_id) AS high_value_orders
FROM
	(SELECT 
		order_id, COUNT(item_id) AS no_of_dishes_ordered
	FROM
		order_details
	GROUP BY order_id
	HAVING no_of_dishes_ordered > 12) as temp_a;

-- Analyze Customer Behaviour
-- Combine the menu_items and order_details tables into a single table
SELECT 
    *
FROM
    menu_items m
        LEFT JOIN
    order_details o ON m.menu_item_id = o.item_id;

-- What were the least and most ordered items? What categories were they in?
SELECT 
    m.item_name, m.category, COUNT(o.item_id)
FROM
    menu_items m
        JOIN
    order_details o ON m.menu_item_id = o.item_id
GROUP BY m.item_name, m.category
ORDER BY COUNT(o.item_id) DESC;

-- What were the top 5 orders that spent the most money?
SELECT 
    o.order_id, SUM(m.price) AS bill_value
FROM
    menu_items m
        JOIN
    order_details o ON m.menu_item_id = o.item_id
GROUP BY o.order_id
ORDER BY bill_value DESC
LIMIT 5;

-- View the details of the highest spend order. Which specific items were purchased?
SELECT 
    o.order_id, m.category, m.item_name, m.price
FROM
    menu_items m
        JOIN
    order_details o ON m.menu_item_id = o.item_id
WHERE
    o.order_id = (SELECT 
            o.order_id
        FROM
            menu_items m
                JOIN
            order_details o ON m.menu_item_id = o.item_id
        GROUP BY o.order_id
        ORDER BY SUM(m.price) DESC
        LIMIT 1)
ORDER BY m.category;

-- View the details of the top 5 highest spend orders
SELECT
    o.order_id, 
    m.category, 
    m.item_name, 
    m.price
FROM
    menu_items m
JOIN
    order_details o ON m.menu_item_id = o.item_id
JOIN
    (SELECT 
        o.order_id
    FROM
        menu_items m
    JOIN
        order_details o ON m.menu_item_id = o.item_id
    GROUP BY 
        o.order_id
    ORDER BY 
        SUM(m.price) DESC
    LIMIT 5) top_orders ON o.order_id = top_orders.order_id
ORDER BY 
    o.order_id, m.category;