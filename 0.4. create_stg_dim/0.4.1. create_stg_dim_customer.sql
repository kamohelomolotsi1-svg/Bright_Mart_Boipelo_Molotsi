SELECT [customer_first_name]
      ,[customer_last_name]
      ,[customer_email]
      ,[customer_phone]
      ,[customer_city]
      ,[customer_province]
      ,[customer_loyalty_tier]
      ,[customer_since]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]


-------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [stg_brightlearn_express].[dbo].[stg_dim_customer]

USE stg_brightlearn_express;
GO


IF OBJECT_ID(N'[stg_brightlearn_express].[dbo].[stg_dim_customer]', N'U') IS NULL
CREATE TABLE [stg_brightlearn_express].[dbo].[stg_dim_customer] (
       [customer_first_name] VARCHAR(255),
       [customer_last_name] VARCHAR(255),
       [customer_email] VARCHAR(255),
       [customer_phone] INT,
       [customer_city] VARCHAR(255),
       [customer_province] VARCHAR(255),
       [customer_loyalty_tier] VARCHAR(255),
       [customer_since] DATETIME2

       );


------------------------------------------------------------------------------------------

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_customer] (
[customer_first_name],
[customer_last_name],
[customer_email],
[customer_phone],
[customer_city],
[customer_province],
[customer_loyalty_tier],
[customer_since]

)

SELECT DISTINCT [customer_first_name],
                [customer_last_name],
                [customer_email],
                [customer_phone],
                [customer_city],
                [customer_province],
                [customer_loyalty_tier],
                [customer_since]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

-------------------------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_customer]


