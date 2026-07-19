USE dwh_brightlearn_express;
GO

IF OBJECT_ID('[dwh_brightlearn_express].[dbo].[dwh_dim_customer]','U') IS NULL
BEGIN

    CREATE TABLE [dwh_brightlearn_express].[dbo].[dwh_dim_customer]
    (
        customer_key INT IDENTITY(1,1) PRIMARY KEY,

        customer_first_name VARCHAR(255),
        customer_last_name VARCHAR(255),
        customer_email VARCHAR(255),
        customer_phone VARCHAR(50),
        customer_city VARCHAR(255),
        customer_province VARCHAR(255),
        customer_loyalty_tier VARCHAR(100),
        customer_since DATETIME2,

        effective_date DATETIME2,
        expiry_date DATETIME2,

        is_current BIT
    );

END;
GO