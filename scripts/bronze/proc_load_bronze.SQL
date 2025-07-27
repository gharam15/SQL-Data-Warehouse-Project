/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

-- Create or alter the procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME ,@end_time DATETIME ,@batch_start_time DATETIME ,@batch_end_time DATETIME
    BEGIN TRY
    PRINT('=============================================')
    PRINT('load bronze layer')
	PRINT('=============================================')

	PRINT('--------------------------------------')
	PRINT('Loading CRM Tables')
	PRINT('--------------------------------------')
	SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.crm_cust_info;
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
	SET @end_time = GETDATE();

	PRINT'>> Load Duration: ' + CAST (DATEDIFF(second,@start_time ,@end_time) AS NVARCHAR)+ ' seconds.';
    TRUNCATE TABLE bronze.crm_prd_info;
    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
	SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.crm_sales_details;
    BULK INSERT bronze.crm_sales_details
    FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
	SET @end_time = GETDATE();
	PRINT('--------------------------------------')
	PRINT('Loading ERP Tables')
	
	PRINT('--------------------------------------')
	PRINT('Loading CRM Tables')
	PRINT('--------------------------------------')
	SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.erp_cust_az12;
    BULK INSERT bronze.erp_cust_az12
    FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
	SET @end_time = GETDATE();
	PRINT'>> Load Duration: ' + CAST (DATEDIFF(second,@start_time ,@end_time) AS NVARCHAR)+ ' seconds.';
    TRUNCATE TABLE bronze.erp_loc_a101;
    BULK INSERT bronze.erp_loc_a101
    FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
	SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
	SET @end_time = GETDATE();
	PRINT'>> Load Duration: ' + CAST (DATEDIFF(second,@start_time ,@end_time) AS NVARCHAR)+ ' seconds.';
    
	SET @batch_end_time = GETDATE();
	PRINT('Loading bronze layer is completed')
	PRINT'>> Total Load Duration: ' + CAST (DATEDIFF(second,@batch_start_time ,@batch_end_time) AS NVARCHAR)+ ' seconds.';
   
    END TRY
	BEGIN catch
	  PRINT('-------------------------------------')
	  PRINT('ERROR ON LOADING DATA IN BRONZE LAYER')
	  PRINT('ERROR Message'+ERROR_MESSAGE());
	  PRINT'ERROR Message'+CAST (ERROR_NUMBER() AS NVARCHAR)
	  PRINT('-------------------------------------')
	END catch
END
-- For Excutation Strored proc     
EXEC bronze.load_bronze
