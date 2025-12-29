-- QUALITY CHECK and LOAD crm_prd_info

-- Quality CHECK bronze Layer:
-- 1. Check for invalid dates:
SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE 
sls_order_dt <=0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101 
OR sls_order_dt < 19000101
-- we found 0 and strange nos != 8 

-- 2. Check for shipping dates:
SELECT 
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE 
sls_ship_dt <=0 
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt > 20500101 
OR sls_ship_dt < 19000101

-- 3. Check for due dates:
SELECT 
NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE 
sls_due_dt <=0 
OR LEN(sls_due_dt) != 8 
OR sls_due_dt > 20500101 
OR sls_due_dt < 19000101

-- 4. Order dat always < shipping or due date:
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- 5. Check Data Consistency: Between Sales, Quantity and Price:
-- >> Sales = quantity * price
-- >> Values must not be NULL, zero, or Negative
SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <=0
        THEN sls_sales/ NULLIF(sls_quantity,0)
     ELSE sls_price
END AS sls_price

FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- ######################################################
-- Finally insterting into silver.crm_sales_info:
INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

-- ######################################################
-- Transformation:
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
-- Handling Invalid Data and DataType Casting
CASE WHEN sls_order_dt = 0 or LEN(sls_order_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- as int cannot be casted into date directly, so first to varchar and then to date
END AS sls_order_dt,

CASE WHEN sls_ship_dt = 0 or LEN(sls_ship_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) -- as int cannot be casted into date directly, so first to varchar and then to date
END AS sls_ship_dt,

CASE WHEN sls_due_dt = 0 or LEN(sls_due_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) -- as int cannot be casted into date directly, so first to varchar and then to date
END AS sls_due_dt,

-- Handling the Missing and Invalid Data
CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,

sls_quantity,

CASE WHEN sls_price IS NULL OR sls_price <=0
        THEN sls_sales/ NULLIF(sls_quantity,0)
     ELSE sls_price
END AS sls_price

FROM bronze.crm_sales_details

-- WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)
-- WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
-- WHERE sls_ord_num != TRIM(sls_ord_num)

-- ######################################################
-- Quality CHECK silver Layer:
-- Quality chekc for silver.crm_sales_details table:

-- 1. Invalid date check
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- 2. Business Rules Check Data Consistency: Between Sales, Quantity and Price:
-- >> Sales = quantity * price
-- >> Values must not be NULL, zero, or Negative
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Final Look:
SELECT * FROM silver.crm_sales_details