USE clean_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Clean_Dim_Employment

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

        INSERT INTO [clean_brightlearn_express].[dbo].[etl_audit_log]
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
            'usp_Load_Clean_Dim_Employment',
            'clean_dim_employment',
            'Clean',
            @StartTime,
            'Started'
        );

        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- Employment Load
        ----------------------------------------------------

        INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_employment]
        (
            cashier_name
        )

        SELECT DISTINCT

            UPPER(LTRIM(RTRIM(cashier_name)))

        FROM [stg_brightlearn_express].[dbo].[stg_dim_employment] S

        WHERE cashier_name IS NOT NULL

        AND NOT EXISTS
        (
            SELECT 1
            FROM [clean_brightlearn_express].[dbo].[clean_dim_employment] D
            WHERE D.cashier_name = UPPER(LTRIM(RTRIM(S.cashier_name)))
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

-----------------------------------------------------------------------

EXEC dbo.usp_Load_Clean_Dim_Employment;

------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[etl_audit_log]