USE dwh_brightlearn_express;
GO

INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_employment]
(
    cashier_name
)

SELECT

    C.cashier_name

FROM [clean_brightlearn_express].[dbo].[clean_dim_employment] C

WHERE NOT EXISTS
(
    SELECT 1

    FROM [dwh_brightlearn_express].[dbo].[dwh_dim_employment] D

    WHERE D.cashier_name = C.cashier_name
);
GO

--------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[dwh_dim_employment]