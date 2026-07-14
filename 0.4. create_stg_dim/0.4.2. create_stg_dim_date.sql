SELECT [transaction_date]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

---------------------------------------------------------------
DROP TABLE IF EXISTS [stg_brightlearn_express].[dbo].[stg_dim_date]
USE stg_brightlearn_express;
GO

IF OBJECT_ID('[stg_brightlearn_express].[dbo].[stg_dim_date]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_brightlearn_express].[dbo].[stg_dim_date]
    (
        [date_id] INT IDENTITY(1, 1) PRIMARY KEY,
        [date_key] INT,
        [full_date] DATE,
        [day_number] TINYINT,
        [day_name] VARCHAR(20),
        [month_number] TINYINT,
        [month_name] VARCHAR(20),
        [quarter_number] TINYINT,
        [year_number] SMALLINT,
        [week_number] TINYINT,
        [day_of_week] TINYINT
    );
END;
GO

------------------------------------------------------------------------------

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_date]
(
    [date_key],
    [full_date],
    [day_number],
    [day_name],
    [month_number],
    [month_name],
    [quarter_number],
    [year_number],
    [week_number],
    [day_of_week]
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(TransactionDate, 'yyyyMMdd')) AS date_key,
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
            TRY_CONVERT(DATE, transaction_date, 23),   -- yyyy-mm-dd
            TRY_CONVERT(DATE, transaction_date, 103),  -- dd/mm/yyyy
            TRY_CONVERT(DATE, transaction_date, 105),  -- dd-mm-yyyy
            TRY_CONVERT(DATE, transaction_date, 111),  -- yyyy/mm/dd
            TRY_PARSE(transaction_date AS DATE USING 'en-GB'),
            TRY_PARSE(transaction_date AS DATE USING 'en-US')
        ) AS TransactionDate
    FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]
) AS D
WHERE TransactionDate IS NOT NULL
AND NOT EXISTS
(
    SELECT 1
    FROM [stg_brightlearn_express].[dbo].[stg_dim_date] S
    WHERE S.full_date = D.TransactionDate
);
GO


--------------------------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_date]

