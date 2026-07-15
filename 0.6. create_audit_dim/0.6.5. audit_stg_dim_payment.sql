-- audit_stg_dim_payment

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();
DECLARE @StartTime DATETIME = GETDATE();
DECLARE @RowsInserted INT;

BEGIN TRY

    INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_payment]
    (
        payment_method
    )
    SELECT DISTINCT
           payment_method
    FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data];

    SET @RowsInserted = @@ROWCOUNT;

    INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
    VALUES
    (
        @BatchID,
        'Load stg_dim_payment',
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
        'Load stg_dim_payment',
        @StartTime,
        GETDATE(),
        0,
        'FAILED',
        ERROR_MESSAGE()
    );

    THROW;

END CATCH;

-------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[etl_audit_log]
SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_payment]