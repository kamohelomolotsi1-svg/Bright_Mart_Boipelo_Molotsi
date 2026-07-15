IF NOT EXISTS(SELECT name FROM sys.databases WHERE name = 'clean_brightlearn_express')
BEGIN
        CREATE DATABASE clean_brightlearn_express;
END


