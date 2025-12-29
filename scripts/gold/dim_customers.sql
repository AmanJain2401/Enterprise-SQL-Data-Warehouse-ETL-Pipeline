-- Creating Gold View of Dimension - Customers:
CREATE VIEW gold.dim_customers AS
SELECT 
	-- Surrogate key:
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_material_status AS martial_status,
	
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for Gender Info if its not null
		 ELSE COALESCE(ca.gen, 'n/a') --  if ci.cst_gndr is null take from ca..gen
	END AS gender,

	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci

LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

-- #######################################################
/*
-- Quality Checking before creating the Dimension Table:
-- 1. Checking for duplicates:
SELECT cst_id, COUNT(*) FROM
(SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_material_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry

FROM silver.crm_cust_info ci

LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
)t GROUP BY cst_id 
HAVING COUNT(*) >1


-- 2. Checking for gnder mismatch in ci.cst_gndr and ca.gen:
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,

FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2
*/

-- #######################################################
/*
-- Quality Checking the Dimension Table
SELECT * FROM gold.dim_customers
SELECT DISTINCT gender FROM gold.dim_customers
*/
