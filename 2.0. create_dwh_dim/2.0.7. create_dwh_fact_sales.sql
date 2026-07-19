--DROP TABLE IF EXISTS [dwh_brightlearn_express].[dbo].[dwh_fact_sales]

USE dwh_brightlearn_express;
GO

IF OBJECT_ID('[dwh_brightlearn_express].[dbo].[dwh_fact_sales]','U') IS NULL
BEGIN

CREATE TABLE [dwh_brightlearn_express].[dbo].[dwh_fact_sales]
(
    sales_key BIGINT IDENTITY(1,1) PRIMARY KEY,

    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    date_id INT NOT NULL,
    store_key INT NOT NULL,
    payment_key INT NOT NULL,
    employment_key INT NOT NULL,

    qty INT,
    unit_price DECIMAL(18,2),
    cost_price DECIMAL(18,2),
    line_amount DECIMAL(18,2),
    transaction_amount DECIMAL(18,2),
    transaction_discount DECIMAL(18,2),
    stock_on_hand INT,
    reorder_threshold INT,

    CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY(customer_key)
        REFERENCES [dwh_brightlearn_express].[dbo].[dwh_dim_customer](customer_key),

    CONSTRAINT FK_FactSales_Product
        FOREIGN KEY(product_key)
        REFERENCES [dwh_brightlearn_express].[dbo].[dwh_dim_product](product_key),

    CONSTRAINT FK_FactSales_Date
        FOREIGN KEY(date_id)
        REFERENCES [dwh_brightlearn_express].[dbo].[dwh_dim_date](date_id),

    CONSTRAINT FK_FactSales_Store
        FOREIGN KEY(store_key)
        REFERENCES [dwh_brightlearn_express].[dbo].[dwh_dim_store](store_key),

    CONSTRAINT FK_FactSales_Payment
        FOREIGN KEY(payment_key)
        REFERENCES [dwh_brightlearn_express].[dbo].[dwh_dim_payment](payment_key),

    CONSTRAINT FK_FactSales_Employment
        FOREIGN KEY(employment_key)
        REFERENCES [dwh_brightlearn_express].[dbo].[dwh_dim_employment](employment_key)
);

END;
GO