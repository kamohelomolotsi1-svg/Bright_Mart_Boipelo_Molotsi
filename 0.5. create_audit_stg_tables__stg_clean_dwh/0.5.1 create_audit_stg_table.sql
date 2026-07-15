USE stg_brightlearn_express;
GO

CREATE TABLE [dbo.etl_audit_log]
(
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    batch_id UNIQUEIDENTIFIER,
    procedure_name VARCHAR(255),
    start_time DATETIME,
    end_time DATETIME,
    rows_inserted INT,
    status VARCHAR(20),
    error_message NVARCHAR(MAX)
);



