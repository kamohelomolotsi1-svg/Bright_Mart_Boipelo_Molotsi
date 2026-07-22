USE dwh_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_DWH_Dim_Payment

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
        'usp_Load_DWH_Dim_Payment',
        'dwh_dim_payment',
        'Gold',
        GETDATE(),
        'Started'
    );

    BEGIN TRANSACTION;

    INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_payment]
    (
        payment_method
    )

    SELECT

        C.payment_method

    FROM [clean_brightlearn_express].[dbo].[clean_dim_payment] C

    WHERE NOT EXISTS
    (
        SELECT 1

        FROM [dwh_brightlearn_express].[dbo].[dwh_dim_payment] D

        WHERE D.payment_method = C.payment_method
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

-----------------------------------------------------------------------------

EXEC dbo.usp_Load_DWH_Dim_Payment;

-----------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]