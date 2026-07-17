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
GO

---------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[clean_dim_payment]