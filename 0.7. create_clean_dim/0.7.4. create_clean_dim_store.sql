USE clean_brightlearn_express;
GO

IF OBJECT_ID(N'[clean_brightlearn_express].[dbo].[clean_dim_store]', N'U') IS NULL
BEGIN
    CREATE TABLE [clean_brightlearn_express].[dbo].[clean_dim_store]
    (
        store_name      VARCHAR(255),
        store_city      VARCHAR(255),
        store_province  VARCHAR(255),
        store_region    VARCHAR(255),
        store_manager   VARCHAR(255)
    );
END;
GO

