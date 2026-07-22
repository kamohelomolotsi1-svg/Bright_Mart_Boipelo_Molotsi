USE dwh_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_DWH_Dim_Store

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();
DECLARE @RowsInserted INT = 0;

BEGIN TRY

    INSERT INTO [dwh_brightlearn_express].[dbo].[etl_audit_log]
    (
        batch_id,
        procedure_name,
        table_name,
        layer_name,
        start_time,
        status
    )

    VALUES
    (
        @BatchID,
        'usp_Load_DWH_Dim_Store',
        'dwh_dim_store',
        'Gold',
        GETDATE(),
        'Started'
    );

    BEGIN TRANSACTION;

    INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_store]
    (
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager
    )

    SELECT

        C.store_name,
        C.store_city,
        C.store_province,
        C.store_region,
        C.store_manager

    FROM [clean_brightlearn_express].[dbo].[clean_dim_store] C

    WHERE NOT EXISTS
    (
        SELECT 1

        FROM [dwh_brightlearn_express].[dbo].[dwh_dim_store] D

        WHERE D.store_name = C.store_name
    );

    SET @RowsInserted = @@ROWCOUNT;

    COMMIT TRANSACTION;

    UPDATE [dwh_brightlearn_express].[dbo].[etl_audit_log]

    SET

        end_time = GETDATE(),
        rows_inserted = @RowsInserted,
        status = 'Success'

    WHERE batch_id = @BatchID;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    UPDATE [dwh_brightlearn_express].[dbo].[etl_audit_log]

    SET

        end_time = GETDATE(),
        status = 'Failed',
        error_message = ERROR_MESSAGE()

    WHERE batch_id = @BatchID;

    THROW;

END CATCH

END;
GO

------------------------------------------------------------------------------

EXEC usp_Load_DWH_Dim_Store;

------------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]
