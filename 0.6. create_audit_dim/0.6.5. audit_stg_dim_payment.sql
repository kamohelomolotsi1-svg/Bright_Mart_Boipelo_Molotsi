USE stg_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Stg_Dim_Payment
AS
BEGIN

SET NOCOUNT ON;

DECLARE @BatchID UNIQUEIDENTIFIER=NEWID();
DECLARE @StartTime DATETIME=GETDATE();
DECLARE @RowsInserted INT;

BEGIN TRY

INSERT INTO [stg_brightlearn_express].[dbo].[stg_dim_payment]
(
payment_method
)

SELECT DISTINCT

payment_method

FROM [stg_brightlearn_express].[dbo].[BrightLearn_Raw_Data];

SET @RowsInserted=@@ROWCOUNT;

INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
(batch_id,procedure_name,start_time,end_time,rows_inserted,status,error_message)

VALUES
(
@BatchID,
'usp_Load_Stg_Dim_Payment',
@StartTime,
GETDATE(),
@RowsInserted,
'SUCCESS',
NULL
);

END TRY

BEGIN CATCH

INSERT INTO [stg_brightlearn_express].[dbo].[etl_audit_log]
(batch_id,procedure_name,start_time,end_time,rows_inserted,status,error_message)

VALUES
(
@BatchID,
'usp_Load_Stg_Dim_Payment',
@StartTime,
GETDATE(),
0,
'FAILED',
ERROR_MESSAGE()
);

THROW;

END CATCH

END;
GO

------------------------------------------------------------------

EXEC dbo.usp_Load_Stg_Dim_Payment;