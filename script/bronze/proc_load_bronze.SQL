--EXEC bronze.load_bronze --- used for executing the stored procedure no need to execute the entire scrip

CREATE OR ALTER PROCEDURE bronze.load_bronze AS  ---- used for craeting stored procedure
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME ,@batch_start_time DATETIME,@batch_end_time DATETIME; --- Declaring the variables for time duration taken to execute the load process for the total batch
	BEGIN TRY --- Error handling
		SET @batch_start_time = GETDATE(); ---intializing the time
		--- BULK INSERT for bronze.crm_cust_info
		TRUNCATE TABLE bronze.crm_cust_info; ----used for delete all the rows in table
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\THIPPRED\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW=2,             ----In CSV files the first row always starts from 2nd row because 1st row will the filed name 
			FIELDTERMINATOR=',',    ----filed separator
			TABLOCK                 ----No other process can read or write to the table until the insert finishes
			);

		--- BULK INSERT for bronze.crm_prd_info
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\THIPPRED\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
			);

		--- BULK INSERT for bronze.crm_sales_details
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\THIPPRED\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
			);

		--- BULK INSERT for bronze.erp_CUST_AZ12
		TRUNCATE TABLE bronze.erp_CUST_AZ12;
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\THIPPRED\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
			);

		--- BULK INSERT for bronze.erp_LOC_A101
		TRUNCATE TABLE bronze.erp_LOC_A101;
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\THIPPRED\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
			);

		--- BULK INSERT for bronze.erp_PX_CAT_G1V2
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\THIPPRED\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
			);
		SET @batch_end_time = GETDATE();
		PRINT'>> TOTAL Load Duratiomn '+ CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
	PRINT'error occured during the bronze layer loading'
	END CATCH
END
