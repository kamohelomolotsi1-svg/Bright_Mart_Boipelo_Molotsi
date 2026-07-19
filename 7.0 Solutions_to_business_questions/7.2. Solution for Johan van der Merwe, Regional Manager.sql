--Solution for Johan van der Merwe, Regional Manager
-- 2. What was the total revenue per store, broken down by month, for the January–June 2024 period?


SELECT

    S.store_name,

    D.year_number,

    D.month_name,

    SUM(F.line_amount) AS TotalRevenue

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_store] S

ON F.store_key = S.store_key

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_date] D

ON F.date_id = D.date_id

WHERE

D.full_date BETWEEN '2024-01-01' AND '2024-06-30'

GROUP BY

S.store_name,

D.year_number,

D.month_number,

D.month_name

ORDER BY

S.store_name,

D.month_number;