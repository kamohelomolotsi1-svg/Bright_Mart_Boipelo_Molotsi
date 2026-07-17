WITH StoreCTE AS
(
    SELECT
        UPPER(LTRIM(RTRIM(store_name))) AS store_name,
        UPPER(LTRIM(RTRIM(store_city))) AS store_city,
        UPPER(LTRIM(RTRIM(store_province))) AS store_province,
        UPPER(LTRIM(RTRIM(store_region))) AS store_region,
        UPPER(LTRIM(RTRIM(store_manager))) AS store_manager,

        ROW_NUMBER() OVER
        (
            PARTITION BY UPPER(LTRIM(RTRIM(store_name)))
            ORDER BY UPPER(LTRIM(RTRIM(store_city)))
        ) AS rn

    FROM [stg_brightlearn_express].[dbo].[stg_dim_store]
    WHERE store_name IS NOT NULL
)

INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_store]
(
    store_name,
    store_city,
    store_province,
    store_region,
    store_manager
)
SELECT
    store_name,
    store_city,
    store_province,
    store_region,
    store_manager
FROM StoreCTE S
WHERE rn = 1
AND NOT EXISTS
(
    SELECT 1
    FROM [clean_brightlearn_express].[dbo].[clean_dim_store] D
    WHERE D.store_name = S.store_name
);
GO


------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[clean_dim_store]