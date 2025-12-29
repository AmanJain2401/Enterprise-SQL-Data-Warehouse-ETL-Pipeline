-- Measures Explorations: Calculating key metrics
-- using SUM, AVG, COUNT...

-- Finding the total sales:
SELECT SUM(sales_amount) as total_sales FROM gold.facts_sales

-- Finding no of items are sold:
SELECT SUM(quantity) as total_quantity FROM gold.facts_sales

-- Finding Avg selling price:
SELECT AVG(price) as avg_price FROM gold.facts_sales

-- Finding the Total no of orders:
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.facts_sales

-- Finding the total number of products:
SELECT COUNT(product_key) as total_products FROM gold.dim_products

-- Finding the total no of customers:
SELECT COUNT(customer_key) as total_customers FROM gold.dim_customers

-- Finding the total no of customers that has placed an order:
SELECT COUNT(DISTINCT customer_key) as total_customers FROM gold.facts_sales

-- ###################################################################################
-- Generating a Final Report:
SELECT 
'Total Sales' as measure_name,
SUM(sales_amount) AS measure_value 
FROM gold.facts_sales
UNION ALL
-- Finding no of items are sold:
SELECT 
'Total Quantity' as measure_name, 
SUM(quantity) as measure_value 
FROM gold.facts_sales
UNION ALL
-- Finding Avg selling price:
SELECT 'Average Price' as measure_name, 
AVG(price) as measure_value 
FROM gold.facts_sales
UNION ALL
-- Finding the Total no of orders:
SELECT 'Total Orders' as measure_name, 
COUNT(DISTINCT order_number) AS measure_value 
FROM gold.facts_sales
UNION ALL
-- Finding the total number of products:
SELECT 'Total Products' as measure_name,
COUNT(product_key) as measure_value 
FROM gold.dim_products
UNION ALL
-- Finding the total no of customers:
SELECT 'Total Customers' as measure_name,
COUNT(customer_key) as measure_value 
FROM gold.dim_customers