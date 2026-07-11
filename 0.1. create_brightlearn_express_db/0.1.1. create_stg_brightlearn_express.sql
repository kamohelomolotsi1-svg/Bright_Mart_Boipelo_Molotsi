IF NOT EXISTS(SELECT name FROM sys.databases WHERE name = 'stg_brightlearn_express')
BEGIN
        CREATE DATABASE stg_brightlearn_express;
END