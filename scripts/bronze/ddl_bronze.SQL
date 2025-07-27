/*
================================================================================
DDL Script : Create bronze Tables
=================================================================================
this script for craete tabled in bronze schema ,dropping tables  exiting tables
if they already exist.
Run this script to re-defined the DDL structure for bronze tables
==================================================================================
*/


USE DataWarehouse;
GO

-- Create schemas
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO

-- Drop and recreate bronze tables
IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO
CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
GO

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm  NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
GO

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num  NVARCHAR(50),
	sls_prd_key  NVARCHAR(50),
	sls_cust_id  INT,
	sls_order_dt INT,
	sls_ship_dt  INT,
	sls_due_dt   INT,
	sls_sales    INT,	
	sls_quantity INT,	
	sls_price    INT
);
GO

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),	
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);
GO

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
