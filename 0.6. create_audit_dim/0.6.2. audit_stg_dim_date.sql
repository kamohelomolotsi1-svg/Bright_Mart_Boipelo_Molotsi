USE stg_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Stg_Dim_Date
AS
BEGIN

SET NOCOUNT ON;

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();
DECLARE @StartTime DATETIME = GETDATE();
DECLARE @RowsInserted INT;

BEGIN TRY

    INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_date]
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

    SELECT DISTINCT
        CONVERT(INT, FORMAT(TransactionDate,'yyyyMMdd')),
        TransactionDate,
        DAY(TransactionDate),
        DATENAME(WEEKDAY, TransactionDate),
        MONTH(TransactionDate),
        DATENAME(MONTH, TransactionDate),
        DATEPART(QUARTER, TransactionDate),
        YEAR(TransactionDate),
        DATEPART(WEEK, TransactionDate),
        DATEPART(WEEKDAY, TransactionDate)

    FROM
    (
        SELECT
            COALESCE
            (
                TRY_CONVERT(DATE, transaction_date,23),
                TRY_CONVERT(DATE, transaction_date,103),
                TRY_CONVERT(DATE, transaction_date,105),
                TRY_CONVERT(DATE, transaction_date,111),
                TRY_PARSE(transaction_date AS DATE USING 'en-GB'),
                TRY_PARSE(transaction_date AS DATE USING 'en-US')
            ) AS TransactionDate

        FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

    ) D

    WHERE TransactionDate IS NOT NULL

    AND NOT EXISTS
    (
        SELECT 1
        FROM [stg_brightlearn_express].[dbo].[stg_dim_date] S
        WHERE S.full_date = D.TransactionDate
    );

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
        'usp_Load_Stg_Dim_Date',
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
        'usp_Load_Stg_Dim_Date',
        @StartTime,
        GETDATE(),
        0,
        'FAILED',
        ERROR_MESSAGE()
    );

    THROW;

END CATCH

END;
GO

------------------------------------------------------------------------------

EXEC dbo.usp_Load_Stg_Dim_Date;
SELECT * FROM [stg_brightlearn_express].[dbo].[etl_audit_log]
SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_date]