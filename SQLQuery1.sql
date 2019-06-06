--create database top_5_futebol
USE top_5_futebol
GO
--CREATE SCHEMA gestao_futebol
GO

----------------------------------------------------------------------------------------------------------------------------------------

:setvar path "C:\Users\LucasSeabra\Desktop\BD\BD_Top5FutebolApp"
--:r $(path)\myfile.sql 

:r $(path)\apaga_tudo_DANGER.sql
:r $(path)\SQL_DDL.sql
:r $(path)\Triggers.sql
:r $(path)\UDFs.sql
:r $(path)\StoredProcedures.sql
:r $(path)\SQL_DML.sql
:r $(path)\comandos.sql

