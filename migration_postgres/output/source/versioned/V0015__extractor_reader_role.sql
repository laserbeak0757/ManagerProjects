-- =============================================================================
-- SIP - Rol de lectura para procesos de extraccion
-- =============================================================================

SET NOCOUNT ON;
GO

IF DATABASE_PRINCIPAL_ID(N'extractor_reader') IS NULL
BEGIN
    CREATE ROLE [extractor_reader];
END;
GO

DECLARE @GrantSql nvarchar(max) = N'';

SELECT @GrantSql = @GrantSql
    + N'GRANT SELECT ON SCHEMA::' + QUOTENAME(s.name) + N' TO [extractor_reader];'
    + CHAR(13) + CHAR(10)
FROM sys.schemas s
WHERE s.name NOT IN (N'sys', N'INFORMATION_SCHEMA')
ORDER BY s.name;

IF @GrantSql <> N''
BEGIN
    EXEC sys.sp_executesql @GrantSql;
END;
GO
