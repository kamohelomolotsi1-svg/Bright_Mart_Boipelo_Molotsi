USE dwh_brightlearn_express;
GO

INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_date]
(
    date_key,
    full_date,
    day_number,
    day_name,
    month_number,
    month_name,
    quarter_number,
    year_number,
    week_number,
    day_of_week
)

SELECT

    C.date_key,
    C.full_date,
    C.day_number,
    C.day_name,
    C.month_number,
    C.month_name,
    C.quarter_number,
    C.year_number,
    C.week_number,
    C.day_of_week

FROM [clean_brightlearn_express].[dbo].[clean_dim_date] C

WHERE NOT EXISTS
(
    SELECT 1

    FROM [dwh_brightlearn_express].[dbo].[dwh_dim_date] D

    WHERE D.date_key = C.date_key
);
GO

----------------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[dwh_dim_date]