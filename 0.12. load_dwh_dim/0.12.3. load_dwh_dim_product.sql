USE dwh_brightlearn_express;
GO

INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_product]
(
    product_name,
    category,
    sub_category,
    sku,
    supplier
)

SELECT

    C.product_name,
    C.category,
    C.sub_category,
    C.sku,
    C.supplier

FROM [clean_brightlearn_express].[dbo].[clean_dim_product] C

WHERE NOT EXISTS
(
    SELECT 1
    FROM [dwh_brightlearn_express].[dbo].[dwh_dim_product] D
    WHERE D.sku = C.sku
);
GO

-----------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[dwh_dim_product]