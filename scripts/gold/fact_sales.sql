-- Creating Gold view of Fact - Sales:
CREATE VIEW gold.facts_sales AS
SELECT
    -- Dimensions
	sd.sls_ord_num AS order_number,
	pr.product_key,
	-- sd.sls_prd_key,
	cu.customer_key,
	--sd.sls_cust_id,

	-- Dates
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,

	-- Measures
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price

FROM silver.crm_sales_details as sd

LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number

LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id

-- Quality Check:
SELECT * FROM gold.facts_sales f

-- Foreign KEy Integrity:
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

SELECT * FROM gold.facts_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL