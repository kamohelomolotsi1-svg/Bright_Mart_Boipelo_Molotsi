USE dwh_brightlearn_express;
GO

IF OBJECT_ID(N'[dwh_brightlearn_express].[dbo].[dwh_dim_store]', N'U') IS NULL
BEGIN

    CREATE TABLE [dwh_brightlearn_express].[dbo].[dwh_dim_store]
    (
        store_key INT IDENTITY(1,1) PRIMARY KEY,

        store_name VARCHAR(255),
        store_city VARCHAR(255),
        store_province VARCHAR(255),
        store_region VARCHAR(255),
        store_manager VARCHAR(255)
    );

END;
GO