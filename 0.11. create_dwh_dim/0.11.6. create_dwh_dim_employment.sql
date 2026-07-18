USE dwh_brightlearn_express;
GO

IF OBJECT_ID(N'[dwh_brightlearn_express].[dbo].[dwh_dim_employment]', N'U') IS NULL
BEGIN

    CREATE TABLE [dwh_brightlearn_express].[dbo].[dwh_dim_employment]
    (
        employment_key INT IDENTITY(1,1) PRIMARY KEY,

        cashier_name VARCHAR(255)
    );

END;
GO