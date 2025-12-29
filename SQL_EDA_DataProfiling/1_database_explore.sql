-- Database EXploaration ###########

-- 1. Exploring ALL objects in the Database:
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Exploring ALL Columns in the Database:
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

-- 2. Dimesnions Exploration:
-- Identifying the unique values (cetegory) in each Dimension
SELECT DISTINCT country FROM gold.dim_customers

-- Exploring the Categories of "THE MJAOR DIVISIONS"
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3

-- 3. Exploring the Date columns: The boundaries i.e. earliest and latest dates
-- MIN/MAX Functions
SELECT order_date FROM gold.facts_sales

SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.facts_sales

-- Finding the youngest and oldest customer
SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers

