-- FULL LOAD: TRUNCATE + INSERT
-- EXEC bronze.load_bronze -- datawarehouse\[programmability\stored procedures

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; -- Creating Variables
	BEGIN TRY
		SET @batch_start_time = GETDATE()
		PRINT '==========================================================';
		PRINT 'Bronze Layer Load';
		PRINT '==========================================================';

		PRINT '----------------------------------------------------------';
		PRINT 'Loading CRM TABLES';
		PRINT '----------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting data into Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Projects\SQLDataWarehouse\SQL DataWarehouse\datasets\source_crm\cust_info.csv'
		WITH (

			FIRSTROW = 2, -- actual first row is just header in every csv file
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting data into Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Projects\SQLDataWarehouse\SQL DataWarehouse\datasets\source_crm\prd_info.csv'
		WITH (

			FIRSTROW = 2, -- actual first row is just header in every csv file
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting data into Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Projects\SQLDataWarehouse\SQL DataWarehouse\datasets\source_crm\sales_details.csv'
		WITH (

			FIRSTROW = 2, -- actual first row is just header in every csv file
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting data into Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Projects\SQLDataWarehouse\SQL DataWarehouse\datasets\source_erp\CUST_AZ12.csv'
		WITH (

			FIRSTROW = 2, -- actual first row is just header in every csv file
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting data into Table: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Projects\SQLDataWarehouse\SQL DataWarehouse\datasets\source_erp\LOC_A101.csv'
		WITH (

			FIRSTROW = 2, -- actual first row is just header in every csv file
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting data into Table: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Projects\SQLDataWarehouse\SQL DataWarehouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (

			FIRSTROW = 2, -- actual first row is just header in every csv file
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> --------------'

		SET @batch_end_time = GETDATE()
		PRINT '================================';
		PRINT ' LOADING Bronze Layer Completed';
		PRINT '>> TOTAL LOAD DURATION: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '===================================='
	
	-- SELECT * FROM bronze.crm_cust_info; -- Quality checking
	-- SELECT COUNT(*) FROM bronze.crm_cust_info;
	END TRY
	BEGIN CATCH
		PRINT '================================================'
		PRINT 'ERROR Occured during loading in Bronze Layer'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================'
	END CATCH
END