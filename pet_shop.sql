DROP DATABASE IF EXISTS pet_shop;
CREATE DATABASE pet_shop;
USE pet_shop;

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_category VARCHAR(30) NOT NULL,
    product_name VARCHAR(30) NOT NULL,
    price NUMERIC(7 , 2) NOT NULL
);
-- product can be one out of 4 listed categories
ALTER TABLE product
ADD CONSTRAINT chk_cat CHECK (product_category IN ("dogs", "cats", "birds", "fish"));

INSERT INTO product(product_category, product_name, price)
	VALUES 
    ("dogs", "food", 1543.41),
    ("dogs", "treat", 299.99),
    ("dogs", "toy", 1100),
    ("dogs", "bed", 5030.33),
    ("dogs", "collar", 709.99),
    ("dogs", "bowls", 905),
    ("dogs", "clothes", 2060.54),
    ("dogs", "transporter", 6920),
    ("cats", "food", 2455.55),
    ("cats", "treat", 449.99),
    ("cats", "toy", 617),
    ("cats", "bed", 3499),
    ("cats", "scratcher", 3879),
    ("cats", "bowls", 798.98),
    ("cats", "transporter", 5569.76),
	("birds", "food", 743.35),
    ("birds", "treat", 349),
    ("birds", "toy", 209.29),
    ("birds", "hygine", 699.59),
    ("birds", "transporter", 2200),
	("fish", "food", 443.22),
    ("fish", "decoration", 1199),
    ("fish", "hygine", 769.4),
    ("fish", "lighting", 2999),
    ("fish", "aquarsalesium", 4299);

-- TABLE sales(
-- id INT PRIMARY KEY,
-- product_id INT NOT NULL,
-- date DATE NOT NULL,
-- quantity INT NOT NULL,
-- );
-- cheking imported data
SELECT 
    *
FROM
    sales
LIMIT 10;
-- deleting empty column
ALTER TABLE sales DROP COLUMN ï»¿dumm;

-- total revanue and number of sales
SELECT SUM(s.quantity * p.price) AS revanue, COUNT(DISTINCT s.id) AS total_sales
FROM sales s
LEFT JOIN product p
	ON s.product_id = p.product_id;

-- best sale
-- 147141.95 
-- not included in final report
SELECT
	s.id,
    SUM(s.quantity * p.price) as best_sale
FROM sales s
LEFT JOIN product p
	ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- revanue by category
SELECT 
	DATE_FORMAT(s.order_date, "%Y-%m-%d") AS order_date, -- order_date was in datetime format
    p.product_category,
    s.quantity * p.price AS sold
FROM sales s
LEFT JOIN product p
	ON s.product_id = p.product_id
ORDER BY 2, 1;

-- revanue by month
SELECT 
	MONTH(s.order_date) AS "month",
    SUM(s.quantity * p.price) AS revanue
FROM sales s
LEFT JOIN product p
	ON s.product_id = p.product_id
GROUP BY 1 
ORDER BY 1;

-- revanue by distinct product name
WITH by_name AS(
	SELECT 
    p.product_name,
    SUM(s.quantity * p.price) OVER(
				PARTITION BY p.product_name
				) AS sold
	FROM sales s
	LEFT JOIN product p
		ON s.product_id = p.product_id
)
SELECT 
	DISTINCT product_name,
	sold
FROM by_name
ORDER BY sold DESC;