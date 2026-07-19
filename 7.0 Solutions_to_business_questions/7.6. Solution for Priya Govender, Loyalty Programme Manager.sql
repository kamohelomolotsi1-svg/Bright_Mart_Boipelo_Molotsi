
--Solution for Priya Govender, Loyalty Programme Manager
-- 6. What is the average transaction value broken down by customer loyalty tier (Bronze, Silver, Gold)?

SELECT

C.customer_loyalty_tier,

AVG(F.transaction_amount) AS AverageTransactionValue

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_customer] C

ON F.customer_key=C.customer_key

GROUP BY

C.customer_loyalty_tier;