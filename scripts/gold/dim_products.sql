-- Creating Gold View of Dimension - Products:
CREATE VIEW gold.dim_products AS

SELECT
	-- Surrogate key:
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn

LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id

-- Filter out all historical data
WHERE prd_end_dt IS NULL -- if end_dt is null then we have current data (we need current info not historical info sometimes)

-- #######################################################
/*
-- Quality Checking before creating the Dimension Table:
-- 1. Checking for duplicates:
SELECT prd_key, COUNT(*) FROM
(SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pn.prd_end_dt,
pc.cat,
pc.subcat,
pc.maintenance

FROM silver.crm_prd_info pn

LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id

-- Filter out all historical data
WHERE prd_end_dt IS NULL -- if end_dt is null then we have current data (we need current info not historical info sometimes)
)t GROUP BY prd_key
HAVING COUNT(*) > 1


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
SELECT * FROM gold.dim_products
*/

