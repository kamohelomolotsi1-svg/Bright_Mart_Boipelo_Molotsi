USE clean_brightlearn_express;
GO

IF OBJECT_ID(N'[clean_brightlearn_express].[dbo].[clean_dim_product]', N'U') IS NULL
BEGIN
    CREATE TABLE [clean_brightlearn_express].[dbo].[clean_dim_product]
    (
        product_name    VARCHAR(255),
        category        VARCHAR(255),
        sub_category    VARCHAR(255),
        sku             VARCHAR(255),
        supplier        VARCHAR(255)
    );
END;
GO

