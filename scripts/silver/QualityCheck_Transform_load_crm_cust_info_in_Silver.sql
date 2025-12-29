-- Quality Checking  Bronze Layer:
-- 1. CHECK for nulls or duplicates in primary key
-- Expectation: No Result

-- 2. CHECK for unwanted spaces:
-- Expectation: No Result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--3. CHECK the consistency of values in low cardinality columns (Martial status and gndr):
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info

-- ######################################################
-- Finally Inserting into silver table:
INSERT INTO silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_material_status,
cst_gndr,
cst_create_date
)

-- ######################################################
-- TRANFORMATION:
SELECT 
cst_id,
cst_key,

-- Trimming: Removing unwanted spaces
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,

-- Data normalization/Standardization
CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_material_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'n/a' -- Handling missing values
END cst_gndr,
cst_create_date

-- Removing Duplicates
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info WHERE cst_id IS NOT NULL
)t 
WHERE flag_last =1 -- gives latest version of duplicated data and all are now unique

-- ######################################################
-- Quality checking for silver layer:
-- 2. CHECK for unwanted spaces:
-- Expectation: No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--3. CHECK the consistency of values in low cardinality columns (Martial status and gndr):
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info