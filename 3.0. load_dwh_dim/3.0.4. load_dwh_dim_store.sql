USE dwh_brightlearn_express;
GO

INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_store]
(
    store_name,
    store_city,
    store_province,
    store_region,
    store_manager
)

SELECT

    C.store_name,
    C.store_city,
    C.store_province,
    C.store_region,
    C.store_manager

FROM [clean_brightlearn_express].[dbo].[clean_dim_store] C

WHERE NOT EXISTS
(
    SELECT 1

    FROM [dwh_brightlearn_express].[dbo].[dwh_dim_store] D

    WHERE D.store_name = C.store_name
);
GO

-----------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[dwh_dim_store]