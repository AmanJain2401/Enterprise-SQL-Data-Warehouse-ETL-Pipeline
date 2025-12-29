-- Connect this table to crm_cust_info through cst_key and cid in this table:
-- QUALITY CHECK and LOAD erp_cust_az12

-- Quality CHECK bronze Layer:
-- 1. Check cid is matching the key in cust info
SELECT * FROM silver.crm_cust_info;

-- 2. IDentify out of range dates:
SELECT DISTINCT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate>GETDATE ()

-- 3. Data Standardization and Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

-- ######################################################
-- Finally insterting into silver.crm_prd_info:
INSERT INTO silver.erp_cust_az12(
	cid,
	bdate,
	gen 
)

-- ######################################################
-- Transformation:
SELECT 

-- Handeled Invalid Values
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END AS cid,

-- Handeled Invalid Values
CASE WHEN bdate > GETDATE() THEN NULL
     ELSE bdate
END AS bdate,

-- Handeled Missing values and Data normalized
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen

FROM bronze.erp_cust_az12

-- ########################################
-- Quality Checks for silver layer:

-- 2. IDentify out of range dates:
SELECT DISTINCT 
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate>GETDATE ()

-- 3. Data Standardization and Consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12