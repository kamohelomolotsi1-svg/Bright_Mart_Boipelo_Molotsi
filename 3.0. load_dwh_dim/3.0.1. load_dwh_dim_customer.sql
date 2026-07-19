INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_customer]
(
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier,
    customer_since,
    effective_date,
    expiry_date,
    is_current
)

SELECT

    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier,
    customer_since,

    GETDATE(),

    NULL,

    1

FROM [clean_brightlearn_express].[dbo].[clean_dim_customer];

------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[dwh_dim_customer];