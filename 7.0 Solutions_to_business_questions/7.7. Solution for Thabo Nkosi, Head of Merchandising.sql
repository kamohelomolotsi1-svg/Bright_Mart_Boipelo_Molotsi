--Solution for Thabo Nkosi, Head of Merchandising
--7. What is the total quantity sold per product category, per store, for the reporting period?

SELECT

P.category,

S.store_name,

SUM(F.qty) AS TotalQuantitySold

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_product] P

ON F.product_key=P.product_key

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_store] S

ON F.store_key=S.store_key

GROUP BY

P.category,

S.store_name

ORDER BY

P.category,

TotalQuantitySold DESC;