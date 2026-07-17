USE clean_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Clean_Dim_Product

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @BatchID UNIQUEIDENTIFIER = NEWID();

DECLARE @StartTime DATETIME2 = GETDATE();

DECLARE @RowsInserted INT = 0;

BEGIN TRY

    ----------------------------------------------------
    -- Insert Audit Record
    ----------------------------------------------------

    INSERT INTO [clean_brightlearn_express].[dbo].[etl_audit_log]
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
        'usp_Load_Clean_Dim_Product',
        'clean_dim_product',
        'Clean',
        @StartTime,
        'Started'
    );

    BEGIN TRANSACTION;

    ----------------------------------------------------
    -- Product Load
    ----------------------------------------------------

    WITH ProductCTE AS
    (
        SELECT

            UPPER(LTRIM(RTRIM(product_name))) AS product_name,

            UPPER(LTRIM(RTRIM(ISNULL(category,'UNKNOWN')))) AS category,

            UPPER(LTRIM(RTRIM(ISNULL(sub_category,'UNKNOWN')))) AS sub_category,

            UPPER(LTRIM(RTRIM(sku))) AS sku,

            UPPER(LTRIM(RTRIM(ISNULL(supplier,'UNKNOWN')))) AS supplier,

            ROW_NUMBER() OVER
            (
                PARTITION BY
                    UPPER(LTRIM(RTRIM(sku)))

                ORDER BY

                    CASE
                        WHEN category IS NULL
                             OR LTRIM(RTRIM(category)) = ''
                        THEN 2
                        ELSE 1
                    END,

                    CASE
                        WHEN sub_category IS NULL
                             OR LTRIM(RTRIM(sub_category)) = ''
                        THEN 2
                        ELSE 1
                    END,

                    CASE
                        WHEN supplier IS NULL
                             OR LTRIM(RTRIM(supplier)) = ''
                        THEN 2
                        ELSE 1
                    END,

                    UPPER(LTRIM(RTRIM(product_name)))
            ) AS rn

        FROM [stg_brightlearn_express].[dbo].[stg_dim_product]

        WHERE sku IS NOT NULL
    )

    INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_product]
    (
        product_name,
        category,
        sub_category,
        sku,
        supplier
    )

    SELECT

        product_name,
        category,
        sub_category,
        sku,
        supplier

    FROM ProductCTE P

    WHERE rn = 1

    AND NOT EXISTS
    (
        SELECT 1
        FROM [clean_brightlearn_express].[dbo].[clean_dim_product] D
        WHERE D.sku = P.sku
    );

    SET @RowsInserted = @@ROWCOUNT;

    COMMIT TRANSACTION;

    ----------------------------------------------------
    -- Success Audit
    ----------------------------------------------------

    UPDATE [clean_brightlearn_express].[dbo].[etl_audit_log]

    SET

        end_time = GETDATE(),

        rows_inserted = @RowsInserted,

        status = 'Success'

    WHERE batch_id = @BatchID;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    UPDATE [clean_brightlearn_express].[dbo].[etl_audit_log]

    SET

        end_time = GETDATE(),

        status = 'Failed',

        error_message = ERROR_MESSAGE()

    WHERE batch_id = @BatchID;

    THROW;

END CATCH

END;
GO

---------------------------------------------------------------------------

EXEC dbo.usp_Load_Clean_Dim_Product;