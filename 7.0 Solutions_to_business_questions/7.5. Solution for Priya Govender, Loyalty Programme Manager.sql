--Solution for Priya Govender, Loyalty Programme Manager
---- 5. Which registered loyalty customers have not made a purchase since 28 April 2024? These customers must be flagged for a targeted win-back campaign.
---- No registered loyalty customers qualified for the targeted win-back campaign because every loyalty customer made at least one purchase after 28 April 2024.

SELECT

C.customer_first_name,

C.customer_last_name,

C.customer_email,

MAX(D.full_date) AS LastPurchaseDate

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_customer] C

ON F.customer_key=C.customer_key

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_date] D

ON F.date_id=D.date_id

GROUP BY

C.customer_first_name,

C.customer_last_name,

C.customer_email

HAVING

MAX(D.full_date)<'2024-04-28';


SELECT

    MIN(full_date) AS EarliestPurchase,
    MAX(full_date) AS LatestPurchase

FROM [dwh_brightlearn_express].[dbo].[dwh_dim_date];

