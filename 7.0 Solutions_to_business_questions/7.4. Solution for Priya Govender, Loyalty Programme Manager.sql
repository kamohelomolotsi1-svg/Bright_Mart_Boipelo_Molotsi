-- Solution for Priya Govender, Loyalty Programme Manager
-- 4. Who are the top 10 loyalty customers ranked by total spend over the reporting period?

SELECT TOP (10)

C.customer_first_name,

C.customer_last_name,

C.customer_loyalty_tier,

SUM(F.line_amount) AS TotalSpend

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_customer] C

ON F.customer_key=C.customer_key

GROUP BY

C.customer_first_name,

C.customer_last_name,

C.customer_loyalty_tier

ORDER BY

TotalSpend DESC;