USE dwh_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_DWH_Fact_Sales

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();

DECLARE @RowsInserted INT = 0;

BEGIN TRY

----------------------------------------------------------
-- Audit Start
----------------------------------------------------------

INSERT INTO [dwh_brightlearn_express].[dbo].[etl_audit_log]
(
    batch_id,
    procedure_name,
    table_name,
    layer_name,
    start_time,
    status
)

VALUES
(
    @BatchID,
    'usp_Load_DWH_Fact_Sales',
    'dwh_fact_sales',
    'Gold',
    GETDATE(),
    'Started'
);

BEGIN TRANSACTION;

----------------------------------------------------------
-- Load Fact Table
----------------------------------------------------------

INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_fact_sales]
(
    customer_key,
    product_key,
    date_id,
    store_key,
    payment_key,
    employment_key,
    qty,
    unit_price,
    cost_price,
    line_amount,
    transaction_amount,
    transaction_discount,
    stock_on_hand,
    reorder_threshold
)

SELECT

    DC.customer_key,

    DP.product_key,

    DD.date_id,

    DS.store_key,

    PM.payment_key,

    EM.employment_key,

    R.qty,

    R.unit_price,

    R.cost_price,

    R.line_amount,

    R.transaction_amount,

    R.transaction_discount,

    R.stock_on_hand,

    R.reorder_threshold

FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data] R

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_customer] DC

ON DC.customer_first_name = UPPER(LTRIM(RTRIM(R.customer_first_name)))

AND DC.customer_last_name = UPPER(LTRIM(RTRIM(R.customer_last_name)))

AND DC.is_current = 1

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_product] DP

ON DP.sku = UPPER(LTRIM(RTRIM(R.sku)))

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_store] DS

ON DS.store_name = UPPER(LTRIM(RTRIM(R.store_name)))

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_payment] PM

ON PM.payment_method = UPPER(LTRIM(RTRIM(R.payment_method)))

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_employment] EM

ON EM.cashier_name = UPPER(LTRIM(RTRIM(R.cashier_name)))

INNER JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_date] DD

ON DD.full_date =

COALESCE
(
TRY_CONVERT(date,R.transaction_date,23),
TRY_CONVERT(date,R.transaction_date,103),
TRY_CONVERT(date,R.transaction_date,105),
TRY_CONVERT(date,R.transaction_date,111),
TRY_PARSE(R.transaction_date AS DATE USING 'en-GB'),
TRY_PARSE(R.transaction_date AS DATE USING 'en-US')
)

WHERE NOT EXISTS
(

SELECT 1

FROM [dwh_brightlearn_express].[dbo].[dwh_fact_sales] F

WHERE

F.customer_key = DC.customer_key

AND F.product_key = DP.product_key

AND F.date_id = DD.date_id

AND F.store_key = DS.store_key

AND F.payment_key = PM.payment_key

AND F.employment_key = EM.employment_key

AND F.line_amount = R.line_amount

);

----------------------------------------------------------

SET @RowsInserted = @@ROWCOUNT;

----------------------------------------------------------

COMMIT TRANSACTION;

----------------------------------------------------------

UPDATE [dwh_brightlearn_express].[dbo].[etl_audit_log]

SET

end_time = GETDATE(),

rows_inserted = @RowsInserted,

status = 'Success'

WHERE batch_id = @BatchID;

END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0

ROLLBACK TRANSACTION;

UPDATE [dwh_brightlearn_express].[dbo].[etl_audit_log]

SET

end_time = GETDATE(),

status = 'Failed',

error_message = ERROR_MESSAGE()

WHERE batch_id = @BatchID;

THROW;

END CATCH

END;
GO

-------------------------------------------------------------------------

EXEC dbo.usp_Load_DWH_Fact_Sales;

--------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]