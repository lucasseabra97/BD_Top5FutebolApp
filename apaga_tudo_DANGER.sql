use top_5_futebol;
go

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT @sql = @sql + N'
  ALTER TABLE ' + QUOTENAME(s.name) + N'.'
  + QUOTENAME(t.name) + N' DROP CONSTRAINT '
  + QUOTENAME(c.name) + ';'
FROM sys.objects AS c
INNER JOIN sys.tables AS t
ON c.parent_object_id = t.[object_id]
INNER JOIN sys.schemas AS s 
ON t.[schema_id] = s.[schema_id]
WHERE c.[type] IN ('D','C','F','PK','UQ')
ORDER BY c.[type];

PRINT @sql;
EXEC sys.sp_executesql @sql;


use top_5_futebol;
go
DECLARE @SqlStatement NVARCHAR(MAX)
SELECT @SqlStatement = 
    COALESCE(@SqlStatement, N'') + N'DROP TABLE [gestao_futebol].' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestao_futebol' and TABLE_TYPE = 'BASE TABLE'

PRINT @SqlStatement
EXEC sys.sp_executesql @SqlStatement;

use top_5_futebol;
go




DECLARE @sql NVARCHAR(max)=''

SELECT @sql += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql






go
create Procedure [dbo].[DeleteAllProcedures]
As 
declare @schemaName varchar(500)    
declare @procName varchar(500)
declare cur cursor
for select s.Name, p.Name from sys.procedures p
INNER JOIN sys.schemas s ON p.schema_id = s.schema_id
WHERE p.type = 'P' and is_ms_shipped = 0 and p.name not like 'sp[_]%diagram%'
ORDER BY s.Name, p.Name
open cur

fetch next from cur into @schemaName,@procName
while @@fetch_status = 0
begin
if @procName <> 'DeleteAllProcedures'
exec('drop procedure ' + @schemaName + '.' + @procName)
fetch next from cur into @schemaName,@procName
end
close cur
deallocate cur

go

EXEC [dbo].[DeleteAllProcedures]
go

use top_5_futebol;
go

DROP FUNCTION gestao_futebol.GolosPorJogoFunction
DROP FUNCTION gestao_futebol.TabelaGolosPorJogo
DROP FUNCTION gestao_futebol.TabelaGolosPorJogoHome
DROP FUNCTION gestao_futebol.TabelaGolosPorJogoAway
DROP FUNCTION gestao_futebol.TabelaPontosPorEquipa

DROP FUNCTION gestao_futebol.TabelaGolosPorJogoF