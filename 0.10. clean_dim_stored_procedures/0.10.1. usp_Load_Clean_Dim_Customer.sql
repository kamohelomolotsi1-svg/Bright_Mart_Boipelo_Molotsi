USE clean_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Clean_Dim_Customer

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
        'usp_Load_Clean_Dim_Customer',
        'clean_dim_customer',
        'Clean',
        @StartTime,
        'Started'
    );

    BEGIN TRANSACTION;

    ----------------------------------------------------
    -- Customer Load
    ----------------------------------------------------

    WITH CustomerCTE AS
    (
        SELECT

            UPPER(LTRIM(RTRIM(customer_first_name))) AS customer_first_name,

            UPPER(LTRIM(RTRIM(customer_last_name))) AS customer_last_name,

            LOWER(LTRIM(RTRIM(ISNULL(customer_email,'')))) AS customer_email,

            LTRIM(RTRIM(ISNULL(customer_phone,''))) AS customer_phone,

            LTRIM(RTRIM(ISNULL(customer_city,''))) AS customer_city,

            LTRIM(RTRIM(ISNULL(customer_province,''))) AS customer_province,

            LTRIM(RTRIM(ISNULL(customer_loyalty_tier,''))) AS customer_loyalty_tier,

            customer_since,

            ROW_NUMBER() OVER
            (
                PARTITION BY

                    UPPER(LTRIM(RTRIM(customer_first_name))),
                    UPPER(LTRIM(RTRIM(customer_last_name)))

                ORDER BY

                    CASE

                        WHEN customer_email IS NULL
                        OR LTRIM(RTRIM(customer_email))=''

                        THEN 2

                        ELSE 1

                    END,

                    customer_since

            ) AS rn

        FROM [stg_brightlearn_express].[dbo].[stg_dim_customer]

        WHERE

        customer_first_name IS NOT NULL

        AND customer_last_name IS NOT NULL
    )

    INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_customer]
    (

        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier,
        customer_since

    )

    SELECT

        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier,
        customer_since

    FROM CustomerCTE C

    WHERE rn=1

    AND NOT EXISTS

    (

        SELECT 1

        FROM [clean_brightlearn_express].[dbo].[clean_dim_customer] D

        WHERE

        D.customer_first_name=C.customer_first_name

        AND D.customer_last_name=C.customer_last_name

    );

    SET @RowsInserted = @@ROWCOUNT;

    COMMIT TRANSACTION;

    ----------------------------------------------------
    -- Success Audit
    ----------------------------------------------------

    UPDATE [clean_brightlearn_express].[dbo].[etl_audit_log]

    SET

        end_time=GETDATE(),

        rows_inserted=@RowsInserted,

        status='Success'

    WHERE batch_id=@BatchID;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT>0

        ROLLBACK TRANSACTION;

    UPDATE [clean_brightlearn_express].[dbo].[etl_audit_log]

    SET

        end_time=GETDATE(),

        status='Failed',

        error_message=ERROR_MESSAGE()

    WHERE batch_id=@BatchID;

    THROW;

END CATCH

END;
GO

-----------------------------------------------------------------------------

EXEC dbo.usp_Load_Clean_Dim_Customer;