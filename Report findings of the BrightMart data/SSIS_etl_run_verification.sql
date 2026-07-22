USE stg_brightlearn_express;
GO

SELECT *
FROM [stg_brightlearn_express].[dbo].[etl_audit_log]
ORDER BY audit_id DESC;

--------------------------------------------------------------------------------------------------

USE clean_brightlearn_express;
GO

SELECT *
FROM [clean_brightlearn_express].[dbo].[etl_audit_log]
ORDER BY audit_id DESC;

-------------------------------------------------------------------------------------------------

USE dwh_brightlearn_express;;
GO

SELECT *
FROM [dwh_brightlearn_express].[dbo].[etl_audit_log]
ORDER BY audit_id DESC;