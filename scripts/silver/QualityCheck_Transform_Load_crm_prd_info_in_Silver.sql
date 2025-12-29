-- QUALITY CHECK and LOAD crm_prd_info

-- Quality CHECK bronze Layer:
-- 1. Check for nullls or duplicates in primary key:
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) >1 OR prd_id IS NULL

-- 2. check for spaces:
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- 3. check for negative or null:
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- 4. Data consistency in prd_line:
SELECT DISTINCT prd_line FROM bronze.crm_prd_info

-- 5. checking for invalid Date Oders
SELECT * 
FROM bronze.crm_prd_info 
WHERE prd_end_dt < prd_start_dt

-- ######################################################
-- Finally insterting into silver.crm_prd_info:
INSERT INTO silver.crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
-- ######################################################
-- Transformation:
SELECT
prd_id,
-- Extract Category ID: joins this to erp_px_cat_g1v2: SELECT distinct id from bronze.erp_px_cat_g1v2
REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id, -- as first 5 characters of prd_key are cat_id

-- Extract Product Key: now this connects this to sales_details: SELECT sls_prd_key FROM bronzze.crm_sales_details
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- as not fixed like above

prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
/*
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line,
*/
-- using quick case for simple mapping
CASE UPPER(TRIM(prd_line)) 
     WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a' -- Handling missing values
END AS prd_line,

-- DataType Casting: Casted DATETIME as only DATE and tranformed EndDate = startdate of next record -1
CAST (prd_start_dt AS DATE) AS prd_start_dt,

-- Data Enrichment
CAST(
     LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
     AS DATE) AS prd_end_dt

FROM bronze.crm_prd_info

/*
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') NOT IN
(SELECT distinct id from bronze.erp_px_cat_g1v2) -- filters out unmatched data after applying transformation
*/
-- ######################################################
-- Quality CHECK silver Layer:
-- 1. Check for nullls or duplicates in primary key:
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) >1 OR prd_id IS NULL

-- 2. check for spaces:
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- 3. check for negative or null:
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- 4. Data consistency in prd_line:
SELECT DISTINCT prd_line FROM silver.crm_prd_info

-- 5. checking for invalid Date Oders
SELECT * 
FROM silver.crm_prd_info 
WHERE prd_end_dt < prd_start_dt

-- Finally last view of silver crm_prd_info:
SELECT * FROM silver.crm_prd_info 