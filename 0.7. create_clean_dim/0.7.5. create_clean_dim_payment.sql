USE clean_brightlearn_express;
GO

IF OBJECT_ID(N'[clean_brightlearn_express].[dbo].[clean_dim_payment]', N'U') IS NULL
BEGIN
    CREATE TABLE [clean_brightlearn_express].[dbo].[clean_dim_payment]
    (
        payment_method VARCHAR(255)
    );
END;
GO

