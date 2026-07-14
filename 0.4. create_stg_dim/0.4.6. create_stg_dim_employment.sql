SELECT [cashier_name]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

-----------------------------------------------------------------------

USE stg_brightlearn_express;
GO


IF OBJECT_ID(N'[stg_brightlearn_express].[dbo].[stg_dim_employment]', N'U') IS NULL
CREATE TABLE [stg_brightlearn_express].[dbo].[stg_dim_employment] (
       [employment_id] INT IDENTITY(1, 1) PRIMARY KEY,
       [cashier_name] VARCHAR(255),

       );
----------------------------------------------------------------------------------

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_employment] (
     [cashier_name]

)

SELECT DISTINCT    [cashier_name]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

-----------------------------------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_employment]