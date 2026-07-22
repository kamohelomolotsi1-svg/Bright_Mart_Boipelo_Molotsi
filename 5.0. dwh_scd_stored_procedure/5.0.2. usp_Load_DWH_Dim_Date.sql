USE dwh_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_DWH_Dim_Date

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
        'usp_Load_DWH_Dim_Date',
        'dwh_dim_date',
        'Gold',
        GETDATE(),
        'Started'
    );

    BEGIN TRANSACTION;

    INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_date]
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

        C.date_key,
        C.full_date,
        C.day_number,
        C.day_name,
        C.month_number,
        C.month_name,
        C.quarter_number,
        C.year_number,
        C.week_number,
        C.day_of_week

    FROM [clean_brightlearn_express].[dbo].[clean_dim_date] C

    WHERE NOT EXISTS
    (
        SELECT 1

        FROM [dwh_brightlearn_express].[dbo].[dwh_dim_date] D

        WHERE D.date_key = C.date_key
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

----------------------------------------------------------------------------

EXEC dbo.usp_Load_DWH_Dim_Date;

-------------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]