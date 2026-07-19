-- Solution for Thabo Nkosi, Head of Merchandising
-- 8. Based on the June 2024 inventory snapshot embedded in the source data, which store-product combinations currently have stock levels below their reorder threshold?
----No store-product combinations were identified with stock levels below their reorder thresholds in the June 2024 inventory snapshot. Based on the available data, no products require immediate replenishment or inventory intervention.

SELECT

S.store_name,

P.product_name,

F.stock_on_hand,

F.reorder_threshold

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_store] S

ON F.store_key=S.store_key

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_product] P

ON F.product_key=P.product_key

WHERE

F.stock_on_hand<F.reorder_threshold

ORDER BY

S.store_name,

P.product_name;

