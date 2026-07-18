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

---------------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------

-- 3. What is the month-over-month revenue growth rate across all stores combined?

WITH MonthlyRevenue AS
(
SELECT

D.year_number,

D.month_number,

SUM(F.line_amount) AS Revenue

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_date] D

ON F.date_id=D.date_id

GROUP BY

D.year_number,

D.month_number
)

SELECT

year_number,

month_number,

Revenue,

LAG(Revenue) OVER(ORDER BY year_number,month_number) AS PreviousMonth,

ROUND(

((Revenue-

LAG(Revenue) OVER(ORDER BY year_number,month_number))

/

NULLIF(LAG(Revenue) OVER(ORDER BY year_number,month_number),0)

)*100,2)

AS GrowthPercent

FROM MonthlyRevenue;

--------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------

-- 5. Which registered loyalty customers have not made a purchase since 28 April 2024? These customers must be flagged for a targeted win-back campaign.

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

-- No registered loyalty customers qualified for the targeted win-back campaign because every loyalty customer made at least one purchase after 28 April 2024.

-- 6. What is the average transaction value broken down by customer loyalty tier (Bronze, Silver, Gold)?

SELECT

C.customer_loyalty_tier,

AVG(F.transaction_amount) AS AverageTransactionValue

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_customer] C

ON F.customer_key=C.customer_key

GROUP BY

C.customer_loyalty_tier;


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



-- 8. Based on the June 2024 inventory snapshot embedded in the source data, which store-product combinations currently have stock levels below their reorder threshold?

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

--No store-product combinations were identified with stock levels below their reorder thresholds in the June 2024 inventory snapshot. Based on the available data, no products require immediate replenishment or inventory intervention.