USE clean_brightlearn_express;
GO

/*=========================================================
  Create Clean Customer Dimension
=========================================================*/

IF OBJECT_ID(N'[clean_brightlearn_express].[dbo].[clean_dim_customer]', N'U') IS NULL
BEGIN
    CREATE TABLE [clean_brightlearn_express].[dbo].[clean_dim_customer]
    (
        customer_first_name      VARCHAR(255),
        customer_last_name       VARCHAR(255),
        customer_email           VARCHAR(255),
        customer_phone           VARCHAR(50),
        customer_city            VARCHAR(255),
        customer_province        VARCHAR(255),
        customer_loyalty_tier    VARCHAR(100),
        customer_since           DATETIME2
    );
END;
GO

/*=========================================================
  Populate Clean Customer Dimension
=========================================================*/

WITH CustomerCTE AS
(
    SELECT

        UPPER(LTRIM(RTRIM(customer_first_name))) AS customer_first_name,

        UPPER(LTRIM(RTRIM(customer_last_name))) AS customer_last_name,

        LOWER(LTRIM(RTRIM(ISNULL(customer_email,'')))) AS customer_email,

        LTRIM(RTRIM(ISNULL(customer_phone,''))) AS customer_phone,

        LTRIM(RTRIM(ISNULL(customer_city,''))) AS customer_city,

        LTRIM(RTRIM(ISNULL(customer_province,''))) AS customer_province,

        LTRIM(RTRIM(ISNULL(customer_loyalty_tier,''))) AS customer_loyalty_tier,

        customer_since,

        ROW_NUMBER() OVER
        (
            PARTITION BY

                UPPER(LTRIM(RTRIM(customer_first_name))),
                UPPER(LTRIM(RTRIM(customer_last_name)))

            ORDER BY

                CASE
                    WHEN customer_email IS NULL
                         OR LTRIM(RTRIM(customer_email)) = ''
                    THEN 2
                    ELSE 1
                END,

                customer_since
        ) AS rn

    FROM [stg_brightlearn_express].[dbo].[stg_dim_customer]

    WHERE

        customer_first_name IS NOT NULL
        AND customer_last_name IS NOT NULL
)

INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_customer]
(
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier,
    customer_since
)

SELECT

    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier,
    customer_since

FROM CustomerCTE C

WHERE rn = 1

AND NOT EXISTS
(
    SELECT 1
    FROM [clean_brightlearn_express].[dbo].[clean_dim_customer] D

    WHERE

        D.customer_first_name = C.customer_first_name
        AND D.customer_last_name = C.customer_last_name
);


-----------------------------------------------------------------------------------

SELECT * FROM [clean_brightlearn_express].[dbo].[clean_dim_customer]