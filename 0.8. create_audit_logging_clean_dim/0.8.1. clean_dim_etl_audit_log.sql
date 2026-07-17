USE clean_brightlearn_express;
GO

IF OBJECT_ID(N'[clean_brightlearn_express].[dbo].[etl_audit_log]', N'U') IS NULL
BEGIN
    CREATE TABLE [clean_brightlearn_express].[dbo].[etl_audit_log]
    (
        audit_id        INT IDENTITY(1,1) PRIMARY KEY,
        batch_id        UNIQUEIDENTIFIER,
        procedure_name  VARCHAR(255),
        start_time      DATETIME2,
        end_time        DATETIME2,
        rows_inserted   INT,
        status          VARCHAR(50),
        error_message   VARCHAR(MAX)
    );
END;
GO