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
GO

----------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[clean_dim_employment]