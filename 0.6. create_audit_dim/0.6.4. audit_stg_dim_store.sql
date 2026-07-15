-- audit_stg_dim_store

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();
DECLARE @StartTime DATETIME = GETDATE();
DECLARE @RowsInserted INT;

BEGIN TRY

    INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_store]
    (
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager
    )
    SELECT DISTINCT
           store_name,
           store_city,
           store_province,
           store_region,
           store_manager
    FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data];

    SET @RowsInserted = @@ROWCOUNT;

    INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
    VALUES
    (
        @BatchID,
        'Load stg_dim_store',
        @StartTime,
        GETDATE(),
        @RowsInserted,
        'SUCCESS',
        NULL
    );

END TRY

BEGIN CATCH

    INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
    VALUES
    (
        @BatchID,
        'Load stg_dim_store',
        @StartTime,
        GETDATE(),
        0,
        'FAILED',
        ERROR_MESSAGE()
    );

    THROW;

END CATCH;

--------------------------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[etl_audit_log]