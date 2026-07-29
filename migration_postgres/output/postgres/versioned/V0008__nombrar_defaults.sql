-- =============================================================================
-- SIP â€” Migration V0008__nombrar_defaults
-- =============================================================================
-- VersiÃ³n: 4.0 v7 (incremental sobre V0007)
-- Compatible: SQL Server 2017+ (forward-compatible 2022)
-- Depende de: V0001 .. V0007
--
-- ALCANCE:
-- Renombra todos los DEFAULT constraints autogenerados por SQL Server
-- (con prefijo DF__ y sufijo hexadecimal aleatorio) al patrÃ³n
-- institucional df_<tabla>_<columna>.
--
-- JUSTIFICACIÃ“N:
-- En V0001 (y subsecuentes hasta V0006), las columnas con clÃ¡usula DEFAULT
-- inline se declararon sin nombre explÃ­cito de constraint. SQL Server les
-- asignÃ³ nombres autogenerados (ej: DF__denuncia__estado__6C6E1476) cuyo
-- sufijo hexadecimal varÃ­a entre ambientes.
--
-- Esto generÃ³ un problema operativo en V0007 al intentar dropear las 3
-- columnas de estado de denuncias.denuncia: el motor exige eliminar primero
-- los DEFAULT constraints dependientes, lo que requiriÃ³ un bloque dinÃ¡mico
-- de descubrimiento (sys.default_constraints + sys.columns) para resolverlos.
--
-- El mismo problema se manifestarÃ¡ en cualquier migration futura que toque
-- columnas con DEFAULT autogenerado. La soluciÃ³n estructural es renombrar
-- los 279 constraints autogenerados al patrÃ³n institucional, dejando el
-- modelo consistente con la convenciÃ³n de naming declarada en Â§3.3 del
-- DiseÃ±o del Modelo de Datos: pk_<tabla>, fk_<tabla>_<atributo>,
-- ix_<tabla>_<columnas>, uq_<tabla>_<columnas>, ck_<tabla>_<columna>,
-- df_<tabla>_<columna>.
--
-- IDEMPOTENCIA:
-- El script descubre dinÃ¡micamente los DEFAULT constraints cuyo nombre
-- sigue el patrÃ³n autogenerado (DF__*) y los renombra al patrÃ³n
-- df_<tabla>_<columna>. Los constraints que ya tengan el nombre objetivo
-- no se tocan. Reaplicar el script no produce cambios.
--
-- ALCANCE DE OBJETOS:
-- 18 esquemas del modelo SIP. Estimado: 279 DEFAULT constraints renombrados.
--
-- IMPACTO:
-- sp_rename sobre constraints es atÃ³mico, no reescribe tablas, no toca
-- datos, no bloquea operaciones. Tiempo estimado de ejecuciÃ³n: < 10 segundos
-- sobre la lÃ­nea base 4.0.
-- =============================================================================
SET ANSI_NULLS ON;
SET ANSI_WARNINGS ON;
SET ANSI_PADDING ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;


-- =============================================================================
-- Script dinÃ¡mico de renombrado
-- =============================================================================
SET NOCOUNT ON;

DECLARE @rename_sql text = N'';
DECLARE @count_renombrados INT = 0;
DECLARE @count_omitidos INT = 0;

-- Construir lista de todos los renombrados a aplicar
DECLARE @renombres TABLE (
 schema_name SYSNAME,
 table_name SYSNAME,
 column_name SYSNAME,
 old_name SYSNAME,
 new_name SYSNAME
);

INSERT INTO @renombres (schema_name, table_name, column_name, old_name, new_name)
SELECT
 s.name AS schema_name,
 t.name AS table_name,
 c.name AS column_name,
 dc.name AS old_name,
 LEFT(N'df_' + t.name + N'_' + c.name, 128) AS new_name
 FROM sys.default_constraints dc
 JOIN sys.tables t ON t.object_id = dc.parent_object_id
 JOIN sys.schemas s ON s.schema_id = t.schema_id
 JOIN sys.columns c ON c.object_id = dc.parent_object_id
 AND c.column_id = dc.parent_column_id
 WHERE s.name IN (
 N'analitica', N'archivos', N'auth', N'casos', N'catalogo_bienes',
 N'configuracion', N'cooperacion_int', N'denuncias', N'diligencias',
 N'encargos', N'evidencias', N'investigacion', N'migracion',
 N'organizacion', N'personas', N'tareas', N'ubicacion', N'vehiculos'
 )
 -- Solo renombrar autogenerados (patrÃ³n DF__<tabla>__<col>__<hex>)
 AND dc.name LIKE N'DF__%'
 -- Y solo si el nombre actual no coincide ya con el target
 AND dc.name <> LEFT(N'df_' + t.name + N'_' + c.name, 128);

-- Verificar que no haya colisiones de nombre nuevo (ej: dos columnas en
-- distintas tablas que generen el mismo df_<tabla>_<columna>; no deberÃ­a
-- pasar pero es defensivo)
DECLARE @colisiones INT;
SELECT @colisiones = COUNT(*) - COUNT(DISTINCT new_name) FROM @renombres;
IF @colisiones > 0
BEGIN
 RAISERROR(N'V0008: Detectadas %d colisiones de nombre nuevo. Aborta.', 16, 1, @colisiones);
 RETURN;
END;

-- Verificar tambiÃ©n que el nombre nuevo no exista ya como otro objeto
DECLARE @colisiones_existentes INT = 0;
SELECT @colisiones_existentes = COUNT(*)
 FROM @renombres r
 WHERE EXISTS (
 SELECT 1
 FROM sys.objects o
 WHERE o.name = r.new_name
 AND o.object_id <> OBJECT_ID(QUOTENAME(r.schema_name) + N'.' + r.old_name)
 );
IF @colisiones_existentes > 0
BEGIN
 PRINT N'V0008: ATENCIÃ“N - hay ' + CAST(@colisiones_existentes AS varchar(10))
 + N' nombres objetivo que ya existen como otros objetos. Revisar antes de continuar.';
 -- No hacemos RETURN para que el operador vea el detalle
END;

-- Imprimir resumen previo
DECLARE @total_a_renombrar INT;
SELECT @total_a_renombrar = COUNT(*) FROM @renombres;
PRINT N'V0008: ' + CAST(@total_a_renombrar AS varchar(10))
 + N' DEFAULT constraints autogenerados a renombrar.';

-- Aplicar los renombrados uno a uno
DECLARE rename_cursor CURSOR LOCAL FAST_FORWARD FOR
 SELECT schema_name, old_name, new_name
 FROM @renombres
 ORDER BY schema_name, table_name, column_name;

DECLARE @s SYSNAME, @old SYSNAME, @new SYSNAME;
OPEN rename_cursor;
FETCH NEXT FROM rename_cursor INTO @s, @old, @new;
WHILE @@FETCH_STATUS = 0
BEGIN
 BEGIN TRY
 DECLARE @full_old_name varchar(300) = QUOTENAME(@s) + N'.' + QUOTENAME(@old);
 EXEC sp_rename @objname = @full_old_name, @newname = @new, @objtype = N'OBJECT';
 SET @count_renombrados = @count_renombrados + 1;
 END TRY
 BEGIN CATCH
 PRINT N'V0008: ERROR al renombrar ' + @full_old_name
 + N' -> ' + @new + N' : ' + ERROR_MESSAGE();
 SET @count_omitidos = @count_omitidos + 1;
 END CATCH;
 FETCH NEXT FROM rename_cursor INTO @s, @old, @new;
END;
CLOSE rename_cursor;
DEALLOCATE rename_cursor;

PRINT N'V0008: Renombrados exitosos: ' + CAST(@count_renombrados AS varchar(10));
PRINT N'V0008: Omitidos por error: ' + CAST(@count_omitidos AS varchar(10));


-- =============================================================================
-- FIN â€” V0008__nombrar_defaults
-- =============================================================================
-- ValidaciÃ³n recomendada (despuÃ©s de ejecutar):
--
-- -- Listar DEFAULTs que aÃºn tengan nombre autogenerado (deberÃ­a ser 0
-- -- despuÃ©s de aplicar V0008, salvo que se hayan creado nuevos en
-- -- ALTER TABLE posteriores sin nombrar).
-- SELECT s.name AS schema_name, t.name AS table_name, c.name AS column_name,
-- dc.name AS constraint_name
-- FROM sys.default_constraints dc
-- JOIN sys.tables t ON t.object_id = dc.parent_object_id
-- JOIN sys.schemas s ON s.schema_id = t.schema_id
-- JOIN sys.columns c ON c.object_id = dc.parent_object_id
-- AND c.column_id = dc.parent_column_id
-- WHERE dc.name LIKE 'DF__%'
-- AND s.name IN ('analitica','archivos','auth','casos','catalogo_bienes',
-- 'configuracion','cooperacion_int','denuncias','diligencias',
-- 'encargos','evidencias','investigacion','migracion',
-- 'organizacion','personas','tareas','ubicacion','vehiculos')
-- ORDER BY s.name, t.name, c.name;
-- -- esperado: 0 filas
--
-- -- Conteo de DEFAULTs que siguen el patrÃ³n df_<tabla>_<columna>
-- SELECT COUNT(*)
-- FROM sys.default_constraints dc
-- JOIN sys.tables t ON t.object_id = dc.parent_object_id
-- JOIN sys.schemas s ON s.schema_id = t.schema_id
-- WHERE s.name IN ('analitica','archivos','auth','casos','catalogo_bienes',
-- 'configuracion','cooperacion_int','denuncias','diligencias',
-- 'encargos','evidencias','investigacion','migracion',
-- 'organizacion','personas','tareas','ubicacion','vehiculos')
-- AND dc.name LIKE 'df_%';
-- -- esperado: 279 filas (aprox, depende del estado al momento de aplicar)
-- =============================================================================

