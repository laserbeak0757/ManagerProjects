/* =============================================================================
 V0032 â€” Eliminar las FKs de auditoria (id_usuario_*) hacia auth.usuario
 PDI Chile â€” SIP. SQL Server. Flyway.

 Contexto / decision:
 Decision: la integridad de id_usuario_* se gestiona en la capa de aplicacion
 (los SP escriben el id_usuario resuelto desde el token/AD). Se ELIMINAN las
 640 FKs de auditoria. Se CONSERVAN las columnas y TODAS las FKs de negocio.

 Alcance EXACTO (no toca nada mas):
 - Solo FKs cuya columna hija sea id_usuario_creador, id_usuario_modificador
 o id_usuario_eliminador, Y que referencien auth.usuario.
 - NO toca id_funcionario_registra ni ninguna otra FK del modelo.

 Metodo: dinamico sobre el catalogo del sistema (no depende de nombres de
 constraint). Idempotente: re-ejecutar no encuentra nada y no falla.
 Asume transaccion por-migracion de Flyway. Refuerzo XACT_ABORT.
 ============================================================================= */

SET XACT_ABORT ON;
SET NOCOUNT ON;

DECLARE @sql text = N'';
DECLARE @count INT;

;WITH fk_auditoria AS (
 SELECT
 fk.object_id AS fk_id,
 QUOTENAME(ps.name) AS esquema_q,
 QUOTENAME(pt.name) AS tabla_q,
 QUOTENAME(fk.name) AS fk_q
 FROM sys.foreign_keys fk
 JOIN sys.tables pt ON pt.object_id = fk.parent_object_id
 JOIN sys.schemas ps ON ps.schema_id = pt.schema_id
 JOIN sys.tables rt ON rt.object_id = fk.referenced_object_id
 JOIN sys.schemas rs ON rs.schema_id = rt.schema_id
 JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
 JOIN sys.columns pc
 ON pc.object_id = fkc.parent_object_id
 AND pc.column_id = fkc.parent_column_id
 WHERE rs.name = N'auth'
 AND rt.name = N'usuario'
 AND pc.name IN (N'id_usuario_creador', N'id_usuario_modificador', N'id_usuario_eliminador')
)
SELECT @sql = STRING_AGG(
 CAST('ALTER TABLE ' + esquema_q + '.' + tabla_q + ' DROP CONSTRAINT ' + fk_q + ';' AS text),
 CHAR(13) + CHAR(10))
FROM fk_auditoria;

SELECT @count = COUNT(*)
FROM sys.foreign_keys fk
JOIN sys.tables rt ON rt.object_id = fk.referenced_object_id
JOIN sys.schemas rs ON rs.schema_id = rt.schema_id
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
JOIN sys.columns pc
 ON pc.object_id = fkc.parent_object_id
 AND pc.column_id = fkc.parent_column_id
WHERE rs.name = N'auth' AND rt.name = N'usuario'
 AND pc.name IN (N'id_usuario_creador', N'id_usuario_modificador', N'id_usuario_eliminador');

PRINT CONCAT('V0032: FKs de auditoria a eliminar = ', ISNULL(@count, 0));

IF @sql IS NOT NULL AND LEN(@sql) > 0
 EXEC sys.sp_executesql @sql;

PRINT 'V0029: completado.';

