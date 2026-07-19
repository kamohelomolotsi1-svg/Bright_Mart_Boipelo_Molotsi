--Solution for Rofhiwa, CEO
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