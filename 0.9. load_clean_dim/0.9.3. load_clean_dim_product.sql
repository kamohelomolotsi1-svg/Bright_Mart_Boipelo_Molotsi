TRUNCATE TABLE [clean_brightlearn_express].[dbo].[clean_dim_product]

-----------------------------------------------------------------------

WITH ProductCTE AS
(
    SELECT

        UPPER(LTRIM(RTRIM(product_name))) AS product_name,

        UPPER(LTRIM(RTRIM(ISNULL(category,'UNKNOWN')))) AS category,

        UPPER(LTRIM(RTRIM(ISNULL(sub_category,'UNKNOWN')))) AS sub_category,

        UPPER(LTRIM(RTRIM(sku))) AS sku,

        UPPER(LTRIM(RTRIM(ISNULL(supplier,'UNKNOWN')))) AS supplier,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                UPPER(LTRIM(RTRIM(sku)))

            ORDER BY

                CASE
                    WHEN category IS NULL
                         OR LTRIM(RTRIM(category)) = ''
                    THEN 2
                    ELSE 1
                END,

                CASE
                    WHEN sub_category IS NULL
                         OR LTRIM(RTRIM(sub_category)) = ''
                    THEN 2
                    ELSE 1
                END,

                CASE
                    WHEN supplier IS NULL
                         OR LTRIM(RTRIM(supplier)) = ''
                    THEN 2
                    ELSE 1
                END,

                UPPER(LTRIM(RTRIM(product_name)))
        ) AS rn

    FROM [stg_brightlearn_express].[dbo].[stg_dim_product]

    WHERE
        sku IS NOT NULL
)

INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_product]
(
    product_name,
    category,
    sub_category,
    sku,
    supplier
)

SELECT

    product_name,
    category,
    sub_category,
    sku,
    supplier

FROM ProductCTE P

WHERE rn = 1

AND NOT EXISTS
(
    SELECT 1
    FROM [clean_brightlearn_express].[dbo].[clean_dim_product] D

    WHERE D.sku = P.sku
);
GO

----------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[clean_dim_product]