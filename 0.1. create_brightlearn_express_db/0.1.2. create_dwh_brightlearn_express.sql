IF NOT EXISTS(SELECT name FROM sys.databases WHERE name = 'dwh_brightlearn_express')
BEGIN
        CREATE DATABASE dwh_brightlearn_express;
END