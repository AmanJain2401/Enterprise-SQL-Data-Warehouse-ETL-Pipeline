-- We Can connect this table's id (cat_id) with prd_key of crm_prd_info table
SELECT prd_key FROM silver.crm_prd_info

-- QUALITY CHECK and LOAD erp_cust_az12

-- Quality CHECK bronze Layer:
-- 1. Check unwanted spaces
SELECt * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(Cat) OR SUBCAT != TRIM(SUBCAT) OR maintenance != TRIM(maintenance)

-- 2. Data Standardization and Consistency
SELECT DISTINCT
cat 
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT
subcat 
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2

-- ######################################################
-- Finally insterting into silver.crm_prd_info:
INSERT INTO silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
)

-- ######################################################
-- Transformation:
SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2

-- Silver layer CHECK
SELECT * FROM silver.erp_px_cat_g1v2
