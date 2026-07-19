USE dwh_brightlearn_express;
GO

IF OBJECT_ID(N'[dwh_brightlearn_express].[dbo].[etl_audit_log]',N'U') IS NULL
BEGIN

CREATE TABLE [dwh_brightlearn_express].[dbo].[etl_audit_log]
(
    audit_id INT IDENTITY(1,1) PRIMARY KEY,

    batch_id UNIQUEIDENTIFIER,

    procedure_name VARCHAR(255),

    table_name VARCHAR(255),

    layer_name VARCHAR(50),

    start_time DATETIME2,

    end_time DATETIME2,

    rows_inserted INT,

    status VARCHAR(50),

    error_message VARCHAR(MAX)

);

END;
GO