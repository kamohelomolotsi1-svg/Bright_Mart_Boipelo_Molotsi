USE clean_brightlearn_express;
GO

IF OBJECT_ID(N'[clean_brightlearn_express].[dbo].[clean_dim_employment]', N'U') IS NULL
BEGIN
    CREATE TABLE [clean_brightlearn_express].[dbo].[clean_dim_employment]
    (
        cashier_name VARCHAR(255)
    );
END;
GO

