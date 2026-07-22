USE dwh_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_DWH_Dim_Product

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
        'usp_Load_DWH_Dim_Product',
        'dwh_dim_product',
        'Gold',
        GETDATE(),
        'Started'
    );

    BEGIN TRANSACTION;

    INSERT INTO [dwh_brightlearn_express].[dbo].[dwh_dim_product]
    (
        product_name,
        category,
        sub_category,
        sku,
        supplier
    )

    SELECT

        C.product_name,
        C.category,
        C.sub_category,
        C.sku,
        C.supplier

    FROM [clean_brightlearn_express].[dbo].[clean_dim_product] C

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dwh_brightlearn_express].[dbo].[dwh_dim_product] D
        WHERE D.sku = C.sku
    );

    SET @RowsInserted = @@ROWCOUNT;

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

-----------------------------------------------------------------------------------

EXEC dbo.usp_Load_DWH_Dim_Product;

---------------------------------------------------------------------------------------

SELECT * FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]