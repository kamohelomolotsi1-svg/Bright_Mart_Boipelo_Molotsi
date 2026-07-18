USE dwh_brightlearn_express;
GO

ALTER TABLE [dwh_brightlearn_express].[dbo].[etl_audit_log]
ADD
    table_name VARCHAR(255),
    layer_name VARCHAR(50);
GO