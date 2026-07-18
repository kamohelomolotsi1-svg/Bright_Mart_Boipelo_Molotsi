USE clean_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Clean_Dim_Payment

AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();

    DECLARE @StartTime DATETIME2 = GETDATE();

    DECLARE @RowsInserted INT = 0;

    BEGIN TRY

        ----------------------------------------------------
        -- Insert Audit Record
        ----------------------------------------------------

        INSERT INTO dbo.etl_audit_log
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
            'usp_Load_Clean_Dim_Payment',
            'clean_dim_payment',
            'Clean',
            @StartTime,
            'Started'
        );

        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- Payment Load
        ----------------------------------------------------

        INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_payment]
        (
            payment_method
        )

        SELECT DISTINCT

            UPPER(LTRIM(RTRIM(payment_method)))

        FROM [stg_brightlearn_express].[dbo].[stg_dim_payment] S

        WHERE payment_method IS NOT NULL

        AND NOT EXISTS
        (
            SELECT 1
            FROM [clean_brightlearn_express].[dbo].[clean_dim_payment] D
            WHERE D.payment_method = UPPER(LTRIM(RTRIM(S.payment_method)))
        );

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRANSACTION;

        ----------------------------------------------------
        -- Success Audit
        ----------------------------------------------------

        UPDATE [clean_brightlearn_express].[dbo].[etl_audit_log]

        SET

            end_time = GETDATE(),

            rows_inserted = @RowsInserted,

            status = 'Success'

        WHERE batch_id = @BatchID;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        UPDATE [clean_brightlearn_express].[dbo].[etl_audit_log]

        SET

            end_time = GETDATE(),

            status = 'Failed',

            error_message = ERROR_MESSAGE()

        WHERE batch_id = @BatchID;

        THROW;

    END CATCH

END;
GO

----------------------------------------------------------------------------------
EXEC dbo.usp_Load_Clean_Dim_Payment;

---------------------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[etl_audit_log]