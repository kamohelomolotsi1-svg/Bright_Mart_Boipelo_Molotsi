-- Solution for Thabo Nkosi, Head of Merchandising
-- 1. What were the top 5 best-selling products by total revenue between January and June 2024?

SELECT TOP (5)

    P.product_name,

    SUM(F.line_amount) AS TotalRevenue

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_product] P

ON F.product_key = P.product_key

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_date] D

ON F.date_id = D.date_id

WHERE

D.full_date BETWEEN '2024-01-01' AND '2024-06-30'

GROUP BY

P.product_name

ORDER BY

TotalRevenue DESC;