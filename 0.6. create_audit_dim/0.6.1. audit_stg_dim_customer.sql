-- audit_stg_dim_customer

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();
DECLARE @StartTime DATETIME = GETDATE();
DECLARE @RowsInserted INT;

BEGIN TRY

    INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_customer]
    (
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier,
        customer_since
    )

    SELECT DISTINCT
           customer_first_name,
           customer_last_name,
           customer_email,
           customer_phone,
           customer_city,
           customer_province,
           customer_loyalty_tier,
           customer_since
    FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data];

    SET @RowsInserted = @@ROWCOUNT;

    INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
    (
        batch_id,
        procedure_name,
        start_time,
        end_time,
        rows_inserted,
        status,
        error_message
    )
    VALUES
    (
        @BatchID,
        'Load stg_dim_customer',
        @StartTime,
        GETDATE(),
        @RowsInserted,
        'SUCCESS',
        NULL
    );

END TRY

BEGIN CATCH

    INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
    (
        batch_id,
        procedure_name,
        start_time,
        end_time,
        rows_inserted,
        status,
        error_message
    )
    VALUES
    (
        @BatchID,
        'Load stg_dim_customer',
        @StartTime,
        GETDATE(),
        0,
        'FAILED',
        ERROR_MESSAGE()
    );

    THROW;

END CATCH;

-------------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[etl_audit_log]