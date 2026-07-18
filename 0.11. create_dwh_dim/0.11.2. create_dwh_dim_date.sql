USE dwh_brightlearn_express;
GO

IF OBJECT_ID(N'[dwh_brightlearn_express].[dbo].[dwh_dim_date]',N'U') IS NULL
BEGIN

CREATE TABLE [dwh_brightlearn_express].[dbo].[dwh_dim_date]
(
    date_id INT IDENTITY(1,1) PRIMARY KEY,

    date_key INT,
    full_date DATE,
    day_number TINYINT,
    day_name VARCHAR(20),
    month_number TINYINT,
    month_name VARCHAR(20),
    quarter_number TINYINT,
    year_number SMALLINT,
    week_number TINYINT,
    day_of_week TINYINT
);

END;
GO