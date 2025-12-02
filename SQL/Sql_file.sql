create database apple_project;
use apple_project;

-- import data to sql:
 
 CREATE TABLE category (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/category.csv'
INTO TABLE category
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(category_id, category_name);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(200),
    category_id VARCHAR(20),
    launch_date DATE,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(product_id, product_name, category_id, launch_date, price);

CREATE TABLE stores(
    store_id VARCHAR(20) PRIMARY KEY,
    store_name VARCHAR(200),
    city VARCHAR(100),
    country VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stores.csv'
INTO TABLE stores
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(store_id, store_name, city, country);

CREATE TABLE sales (
    sale_id VARCHAR(20),
    sale_date DATE,
    store_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(sale_id, sale_date, store_id, product_id, quantity);

CREATE TABLE warranty (
    claim_id VARCHAR(20) PRIMARY KEY,
    claim_date DATE,
    sale_id VARCHAR(20),
    repair_status VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/warranty.csv'
INTO TABLE warranty
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(claim_id, claim_date, sale_id, repair_status);

ALTER TABLE sales
ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id);

ALTER TABLE sales
ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE sales
MODIFY sale_id VARCHAR(20) PRIMARY KEY;

ALTER TABLE warranty
ADD CONSTRAINT fk_warranty FOREIGN KEY (sale_id) REFERENCES sales(sale_id);


/* ----------------------------------------------
            DATA CLEANING
---------------------------------------------- */

-- check duplicates 

Select category_id ,count(*) FROM category GROUP BY category_id HAVING count(*) > 1;

SELECT sale_id, COUNT(*) AS count_duplicates FROM sales GROUP BY sale_id HAVING COUNT(*) > 1;

SELECT Product_ID,product_name,count(*) FROM products GROUP BY Product_ID,product_name
HAVING COUNT(*) > 1;

SELECT store_id, COUNT(*) FROM stores GROUP BY store_id HAVING COUNT(*) > 1;

SELECT claim_id, COUNT(*) FROM warranty GROUP BY claim_id HAVING COUNT(*) > 1;

-- Check for invalid quantities
SELECT * FROM sales WHERE quantity <= 0;

-- Remove invalid foreign keys
SELECT sale_id
FROM sales s
LEFT JOIN stores st USING(store_id)
WHERE st.store_id IS NULL;

SELECT w.claim_id
FROM warranty w
LEFT JOIN sales s USING(sale_id)
WHERE s.sale_id IS NULL;

-- null values
SELECT * FROM products WHERE product_name IS NULL;

SELECT store_id FROM stores WHERE store_id IS NULL;

-- distinct values
SELECT DISTINCT repair_status FROM warranty;



-- ******** ANALYTICAL SQL QUERIES ******** 

-- Total Revenue(KPI) --

SELECT 
    CONCAT('$', FORMAT(SUM(s.quantity * p.price), 2)) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.Product_ID;

-- Average Order Size --
SELECT AVG(quantity) FROM sales;

-- Top 5 selling products --

SELECT p.product_name, SUM(s.quantity) AS units_sold
FROM sales s
JOIN products p USING(product_id)
GROUP BY product_name
ORDER BY units_sold 
DESC LIMIT 5;

-- Most profitable category --
SELECT c.category_name,
       SUM(s.quantity * p.price) AS revenue
FROM sales s
JOIN products p USING(product_id)
JOIN category c USING(category_id)
GROUP BY c.category_name
ORDER BY revenue DESC LIMIT 1;


-- Yearly Sales Trend --

SELECT YEAR(sale_date) AS year, SUM(quantity) as units_sold
FROM sales
GROUP BY year
order by year ;


-- Sales Before vs After Product Launch --
SELECT 
    p.product_name,
    SUM(CASE WHEN s.sale_date < p.Launch_Date THEN quantity ELSE 0 END) AS before_launch,
    SUM(CASE WHEN s.sale_date >= p.Launch_Date THEN quantity ELSE 0 END) AS after_launch
FROM sales s
JOIN products p USING(product_id)
GROUP BY p.product_name;

-- Store Distribution by Country --
SELECT country, COUNT(*) AS total_stores
FROM stores
GROUP BY country;


-- TOP 10 Revenue by Country --
SELECT 
    st.Country,
    SUM(s.quantity * p.Price) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.Product_ID
JOIN stores st  ON s.store_id = st.Store_ID
GROUP BY st.Country
ORDER BY total_revenue DESC LIMIT 10;


-- Products with high claims (bad quality)--
SELECT p.product_name, COUNT(*) AS claims
FROM warranty w
JOIN sales s USING(sale_id)
JOIN products p USING(product_id)
GROUP BY p.product_name
ORDER BY claims DESC;

-- Pending vs Completed Status --
SELECT repair_status, COUNT(*) AS count FROM warranty GROUP BY repair_status;

-- Warranty Claims Within X Days of Sale --
SELECT 
    w.claim_id,
    DATEDIFF(w.claim_date, s.sale_date) AS days_after_sale
FROM warranty w
JOIN sales s USING(sale_id);

-- creating index --
CREATE INDEX idx_sale_date ON sales(sale_date);
CREATE INDEX idx_product ON sales(product_id);
CREATE INDEX idx_store ON sales(store_id);

EXPLAIN SELECT * FROM sales WHERE product_id='P-48';

-- views --
CREATE VIEW sales_dashboard_view AS
SELECT 
    s.sale_date,
    st.store_name,
    p.product_name,
    c.category_name,
    s.quantity,
    p.price,
    (quantity * price) AS revenue
FROM sales s
JOIN products p USING(product_id)
JOIN category c USING(category_id)
JOIN stores st USING(store_id);


