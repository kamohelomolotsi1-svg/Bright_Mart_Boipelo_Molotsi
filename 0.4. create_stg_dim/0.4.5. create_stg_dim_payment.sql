SELECT [payment_method]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

-----------------------------------------------------------------------------

USE stg_brightlearn_express;
GO


IF OBJECT_ID(N'[stg_brightlearn_express].[dbo].[stg_dim_payment]]', N'U') IS NULL
CREATE TABLE [stg_brightlearn_express].[dbo].[stg_dim_payment] (
       [payment_id] INT IDENTITY(1, 1) PRIMARY KEY,
       [payment_method] VARCHAR(255),

       );

---------------------------------------------------------------------------------------

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_payment] (
     [payment_method]

)

SELECT DISTINCT    [payment_method]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

-----------------------------------------------------------------------------------------

SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_payment]