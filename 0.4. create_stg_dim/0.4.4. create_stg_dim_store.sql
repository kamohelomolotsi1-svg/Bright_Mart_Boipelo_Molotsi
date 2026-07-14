SELECT [store_name],
       [store_city],
       [store_province],
       [store_region],
       [store_manager]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

----------------------------------------------------------------------------------

DROP TABLE IF EXISTS [stg_brightlearn_express].[dbo].[stg_dim_store]
USE stg_brightlearn_express;
GO


IF OBJECT_ID(N'[stg_brightlearn_express].[dbo].[stg_dim_store]', N'U') IS NULL
CREATE TABLE [stg_brightlearn_express].[dbo].[stg_dim_store] (
       [store_id] INT IDENTITY(1, 1) PRIMARY KEY,
       [store_name] VARCHAR(255),
       [store_city] VARCHAR(255),
       [store_province] VARCHAR(255),
       [store_region] VARCHAR(255),
       [store_manager] VARCHAR(255)

       );

------------------------------------------------------------------------------------------

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_store] (
       [store_name],
       [store_city],
       [store_province],
       [store_region],
       [store_manager]

)

SELECT DISTINCT    [store_name],
                   [store_city],
                   [store_province],
                   [store_region],
                   [store_manager]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

---------------------------------------------------------------------------------

    SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_store]