-- Which 5 products generated highest revenue:

SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue

FROM gold.facts_sales f

LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key

GROUP BY p.product_name
ORDER BY total_revenue DESC

-- What are the 5 worst performing products in terms of sales:

SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue

FROM gold.facts_sales f

LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key

GROUP BY p.product_name
ORDER BY total_revenue 

-- Which 5 subcategories generated highest revenue:

SELECT TOP 5
p.subcategory,
SUM(f.sales_amount) AS total_revenue

FROM gold.facts_sales f

LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key

GROUP BY p.subcategory
ORDER BY total_revenue DESC

-- Which Worst 5 subcategories generated Lowest revenue:

SELECT TOP 5
p.subcategory,
SUM(f.sales_amount) AS total_revenue

FROM gold.facts_sales f

LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key

GROUP BY p.subcategory
ORDER BY total_revenue 
