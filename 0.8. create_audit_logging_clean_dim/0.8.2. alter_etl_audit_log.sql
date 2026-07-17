-- alter etl_audit_log

USE clean_brightlearn_express;
GO

ALTER TABLE [clean_brightlearn_express].[dbo].[etl_audit_log]
ADD
    table_name VARCHAR(255),
    layer_name VARCHAR(50);
GO