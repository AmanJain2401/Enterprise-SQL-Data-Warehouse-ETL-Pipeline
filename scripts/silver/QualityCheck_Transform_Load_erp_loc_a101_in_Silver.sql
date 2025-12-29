-- This connects to crm_cust_info using cid in this table with cst_key in cust_info
SELECT cst_key FROM silver.crm_cust_info

-- QUALITY CHECK and LOAD erp_loc_a101
-- Quality CHECK bronze Layer:
-- 1. Data Standardization and Consistency
SELECT DISTINCT 
cntry AS old_cntry,

CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101 
ORDER BY cntry


-- ######################################################
-- Finally insterting into silver.crm_prd_info:
INSERT INTO silver.erp_loc_a101(
	cid,
	cntry
)

-- ######################################################
-- Transformation:
SELECT

REPLACE(cid, '-','') cid,

-- Handeled missing vlaues and normalize values
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 ELSE TRIM(cntry)

END AS cntry
FROM bronze.erp_loc_a101

-- ########################################
-- QUality Checks for silver layer:

-- 1. Data Standardization and Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101

SELECT * FROM silver.erp_loc_a101;