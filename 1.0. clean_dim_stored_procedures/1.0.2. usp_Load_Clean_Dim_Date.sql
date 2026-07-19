USE clean_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Clean_Dim_Date

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
        'usp_Load_Clean_Dim_Date',
        'clean_dim_date',
        'Clean',
        @StartTime,
        'Started'
    );

    BEGIN TRANSACTION;

    ----------------------------------------------------
    -- Date Load
    ----------------------------------------------------

    INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_date]
    (
        date_key,
        full_date,
        day_number,
        day_name,
        month_number,
        month_name,
        quarter_number,
        year_number,
        week_number,
        day_of_week
    )

    SELECT
        date_key,
        full_date,
        day_number,
        UPPER(LTRIM(RTRIM(day_name))),
        month_number,
        UPPER(LTRIM(RTRIM(month_name))),
        quarter_number,
        year_number,
        week_number,
        day_of_week

    FROM [stg_brightlearn_express].[dbo].[stg_dim_date] S

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM [clean_brightlearn_express].[dbo].[clean_dim_date] D
        WHERE D.full_date = S.full_date
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

----------------------------------------------------------------------------

EXEC dbo.usp_Load_Clean_Dim_Date;

------------------------------------------------------------------------------

