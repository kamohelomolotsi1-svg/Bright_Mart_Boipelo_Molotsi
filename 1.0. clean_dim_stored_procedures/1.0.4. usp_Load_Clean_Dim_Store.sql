USE clean_brightlearn_express;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Load_Clean_Dim_Store

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
            'usp_Load_Clean_Dim_Store',
            'clean_dim_store',
            'Clean',
            @StartTime,
            'Started'
        );

        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- Store Load
        ----------------------------------------------------

        WITH StoreCTE AS
        (
            SELECT

                UPPER(LTRIM(RTRIM(store_name))) AS store_name,

                UPPER(LTRIM(RTRIM(store_city))) AS store_city,

                UPPER(LTRIM(RTRIM(store_province))) AS store_province,

                UPPER(LTRIM(RTRIM(store_region))) AS store_region,

                UPPER(LTRIM(RTRIM(store_manager))) AS store_manager,

                ROW_NUMBER() OVER
                (
                    PARTITION BY UPPER(LTRIM(RTRIM(store_name)))

                    ORDER BY UPPER(LTRIM(RTRIM(store_city)))
                ) AS rn

            FROM [stg_brightlearn_express].[dbo].[stg_dim_store]

            WHERE store_name IS NOT NULL
        )

        INSERT INTO [clean_brightlearn_express].[dbo].[clean_dim_store]
        (
            store_name,
            store_city,
            store_province,
            store_region,
            store_manager
        )

        SELECT

            store_name,
            store_city,
            store_province,
            store_region,
            store_manager

        FROM StoreCTE S

        WHERE rn = 1

        AND NOT EXISTS
        (
            SELECT 1
            FROM [clean_brightlearn_express].[dbo].[clean_dim_store] D
            WHERE D.store_name = S.store_name
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

--------------------------------------------------------------------------------

EXEC dbo.usp_Load_Clean_Dim_Store;

--------------------------------------------------------------------------------

select * from [clean_brightlearn_express].[dbo].[etl_audit_log]