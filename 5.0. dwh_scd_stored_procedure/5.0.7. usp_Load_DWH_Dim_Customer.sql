-- SCD Type 2 Stored Procedure

USE dwh_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_DWH_Dim_Customer

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();

DECLARE @RowsInserted INT = 0;

BEGIN TRY

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
'usp_Load_DWH_Dim_Customer',
'dwh_dim_customer',
'Gold',
GETDATE(),
'Started'
);

BEGIN TRANSACTION;

----------------------------------------------------------------------------

-- EXPIRE THE OLD RECORD

UPDATE D

SET

expiry_date = GETDATE(),

is_current = 0

FROM [dwh_brightlearn_express].[dbo].[dwh_dim_customer] D

INNER JOIN [clean_brightlearn_express].[dbo].[clean_dim_customer] C

ON

D.customer_first_name = C.customer_first_name

AND D.customer_last_name = C.customer_last_name

WHERE

D.is_current = 1

AND
(
ISNULL(D.customer_email,'') <> ISNULL(C.customer_email,'')

OR ISNULL(D.customer_phone,'') <> ISNULL(C.customer_phone,'')

OR ISNULL(D.customer_city,'') <> ISNULL(C.customer_city,'')

OR ISNULL(D.customer_province,'') <> ISNULL(C.customer_province,'')

OR ISNULL(D.customer_loyalty_tier,'') <> ISNULL(C.customer_loyalty_tier,'')

);

----------------------------------------------------------------------------------

-- Insert New Customers and Changed Customers

INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_customer]
(
customer_first_name,
customer_last_name,
customer_email,
customer_phone,
customer_city,
customer_province,
customer_loyalty_tier,
customer_since,
effective_date,
expiry_date,
is_current
)

SELECT

C.customer_first_name,

C.customer_last_name,

C.customer_email,

C.customer_phone,

C.customer_city,

C.customer_province,

C.customer_loyalty_tier,

C.customer_since,

GETDATE(),

NULL,

1

FROM [clean_brightlearn_express].[dbo].[clean_dim_customer] C

LEFT JOIN [dwh_brightlearn_express].[dbo].[dwh_dim_customer] D

ON

D.customer_first_name = C.customer_first_name

AND D.customer_last_name = C.customer_last_name

AND D.is_current = 1

WHERE

D.customer_key IS NULL

OR

ISNULL(D.customer_email,'') <> ISNULL(C.customer_email,'')

OR ISNULL(D.customer_phone,'') <> ISNULL(C.customer_phone,'')

OR ISNULL(D.customer_city,'') <> ISNULL(C.customer_city,'')

OR ISNULL(D.customer_province,'') <> ISNULL(C.customer_province,'')

OR ISNULL(D.customer_loyalty_tier,'') <> ISNULL(C.customer_loyalty_tier,'');

---------------------------------------------------------------------------------

-- capturing how many rows were inserted

SET @RowsInserted = @@ROWCOUNT;

-----------------------------------------------------------------------------------

-- commit and update audit

COMMIT TRANSACTION;

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

EXEC dbo.usp_Load_DWH_Dim_Customer;

---------------------------------------------------------------------------

SELECT *
FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]
ORDER BY audit_id DESC;

----------------------------------------------------------------------------

