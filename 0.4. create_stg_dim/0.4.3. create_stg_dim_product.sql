SELECT [product_name],
       [category],
       [sub_category],
       [sku],
       [supplier]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

  ----------------------------------------------------------------------------------

USE stg_brightlearn_express;
GO


IF OBJECT_ID(N'[stg_brightlearn_express].[dbo].[stg_dim_product]', N'U') IS NULL
CREATE TABLE [stg_brightlearn_express].[dbo].[stg_dim_product] (
       [product_name] VARCHAR(255),
       [category] VARCHAR(255),
       [sub_category] VARCHAR(255),
       [sku] VARCHAR(255),
       [supplier] VARCHAR(255)

       );

---------------------------------------------------------------------------------------

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_product] (
       [product_name],
       [category],
       [sub_category],
       [sku],
       [supplier]

)

SELECT DISTINCT [product_name],
                [category],
                [sub_category],
                [sku],
                [supplier]
FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data]

---------------------------------------------------------------------------------

    SELECT * FROM [stg_brightlearn_express].[dbo].[stg_dim_product]
