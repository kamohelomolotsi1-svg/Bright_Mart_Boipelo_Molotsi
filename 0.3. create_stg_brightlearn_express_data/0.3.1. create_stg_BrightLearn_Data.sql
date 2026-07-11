USE [stg_brightlearn_express]
GO


IF (OBJECT_ID('[stg_brightlearn_express].[dbo].[stg_BrightLearn_Data]') IS NOT NULL )
BEGIN
  PRINT 'Table with the same name available'
END
ELSE
BEGIN
CREATE TABLE [stg_brightlearn_express].[dbo].[stg_BrightLearn_Data](
	[transaction_date] [nvarchar](50) NOT NULL,
	[payment_method] [nvarchar](50) NOT NULL,
	[cashier_name] [nvarchar](50) NOT NULL,
	[transaction_amount] [float] NOT NULL,
	[transaction_discount] [float] NOT NULL,
	[customer_first_name] [nvarchar](50) NULL,
	[customer_last_name] [nvarchar](50) NULL,
	[customer_email] [nvarchar](50) NULL,
	[customer_phone] [int] NULL,
	[customer_city] [nvarchar](50) NULL,
	[customer_province] [nvarchar](50) NULL,
	[customer_loyalty_tier] [nvarchar](50) NULL,
	[customer_since] [datetime2](7) NULL,
	[store_name] [nvarchar](50) NOT NULL,
	[store_city] [nvarchar](50) NOT NULL,
	[store_province] [nvarchar](50) NOT NULL,
	[store_region] [nvarchar](50) NOT NULL,
	[store_manager] [nvarchar](50) NOT NULL,
	[product_name] [nvarchar](50) NOT NULL,
	[category] [nvarchar](50) NULL,
	[sub_category] [nvarchar](50) NOT NULL,
	[sku] [nvarchar](50) NOT NULL,
	[unit_price] [float] NOT NULL,
	[cost_price] [float] NOT NULL,
	[supplier] [nvarchar](50) NOT NULL,
	[qty] [nvarchar](50) NOT NULL,
	[line_amount] [float] NOT NULL,
	[stock_on_hand] [int] NOT NULL,
	[reorder_threshold] [int] NOT NULL
);
END


