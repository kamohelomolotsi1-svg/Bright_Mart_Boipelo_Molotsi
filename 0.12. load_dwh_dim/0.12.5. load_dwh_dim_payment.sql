USE dwh_brightlearn_express;
GO

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
GO

-----------------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[dwh_dim_payment]