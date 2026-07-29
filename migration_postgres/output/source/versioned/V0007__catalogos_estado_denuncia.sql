-- =============================================================================
-- SIP — Migration V0007__catalogos_estado_denuncia
-- =============================================================================
-- Versión:      4.0 v6 (incremental sobre V0006)
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql (define denuncias.denuncia)
--               V0006__realojamiento_catalogos.sql (estado vivo previo)
--
-- ALCANCE:
--   1. Crea dos catálogos nuevos en el esquema denuncias para soportar las
--      máquinas de estado del proceso PO01.01 v2.0.0 (Gestión de Denuncias):
--        - denuncias.cat_estado_denuncia        (7 valores)
--        - denuncias.cat_estado_envio_fiscalia  (3 valores)
--
--   2. Reemplaza las columnas NVARCHAR(20) de denuncias.denuncia por
--      claves foráneas a los nuevos catálogos:
--        - estado_denuncia        (NVARCHAR) → id_estado_denuncia (INTEGER FK)
--        - estado_envio_fiscalia  (NVARCHAR) → id_estado_envio_fiscalia (INTEGER FK)
--
--   3. Elimina la columna redundante estado_borrador. Sus valores
--      (BORRADOR/COMPLETA/VISADA) duplicaban funcionalidad de estado_denuncia
--      con un dominio menos completo que el del proceso PO01.01 v2.0.0.
--
--   4. Repara el bug detectado en denuncias.procedimiento_policial:
--      la FK fk_proc_programa estaba duplicada apuntando a dos tablas
--      distintas (residuo del realojamiento del V0006 de cat_programa_seguridad
--      desde casos a configuracion).
--
--   5. Actualiza descripciones extendidas de las columnas afectadas.
--
-- JUSTIFICACIÓN (resumen):
--   El esquema denuncias mantenía 3 columnas de estado como NVARCHAR(20) sin
--   catálogo respaldado por FK ni CHECK constraint, contraviniendo el patrón
--   aplicado en otros esquemas operativos del modelo (casos.cat_estado_caso,
--   diligencias.cat_estado_diligencia, evidencias.cat_estado_especie). El
--   análisis del proceso PO01.01 v2.0.0 (BPMN + documento de proceso) confirmó
--   que estas columnas representan máquinas de estado con dominios cerrados
--   que requieren catálogo institucional.
--
--   Detalle del análisis comparativo: ver documento "Hallazgos del Modelo SIP
--   vs Proceso PO01.01 - Gestión de Denuncias".
--
-- DATOS PRODUCTIVOS:
--   Esta migration aplica sobre una base nueva sin datos productivos. Por
--   esto NO se incluyen bloques de migración de datos. Los catálogos quedan
--   vacíos al término de V0007 — los datos semilla se cargan mediante el
--   script repetible R__denuncias_seed.sql.
--
-- ORDEN DE EJECUCIÓN:
--   V0007 (este script, estructural) DEBE ejecutarse antes de R__denuncias_seed.
--   Flyway garantiza este orden: las versionadas se aplican en orden de versión,
--   las repetibles se aplican al final del bucle de versionadas y se reaplican
--   cada vez que su contenido cambia.
--
-- IDEMPOTENCIA:
--   Se aplican guardas IF EXISTS / IF NOT EXISTS donde corresponde para que
--   la migration sea segura ante reaplicación parcial (ej: drop accidental +
--   restore + re-migrate).
--
-- ROLLBACK:
--   No hay rollback automático en Flyway para Versioned migrations. Si se
--   requiere revertir, debe restaurarse desde backup. Como esta migration
--   aplica sobre base nueva sin datos, el rollback equivale a recrear desde
--   V0001 hasta V0006.
-- =============================================================================
SET ANSI_NULLS ON;
GO
SET ANSI_WARNINGS ON;
GO
SET ANSI_PADDING ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET CONCAT_NULL_YIELDS_NULL ON;
GO


-- =============================================================================
-- BLOQUE 1 — CREAR CATÁLOGOS NUEVOS
-- =============================================================================
-- Sigue el patrón de catálogos del modelo: id IDENTITY, codigo único,
-- nombre descriptivo, es_terminal para reportería, orden para presentación,
-- activo para baja lógica. CHECK constraints sobre los SMALLINT booleanos.
-- =============================================================================

-- ─── denuncias.cat_estado_denuncia ──────────────────────────────────────────
IF OBJECT_ID('[denuncias].[cat_estado_denuncia]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_estado_denuncia] (
        id_estado_denuncia INTEGER NOT NULL IDENTITY(1,1),
        codigo             NVARCHAR(30) NOT NULL,
        nombre             NVARCHAR(80) NOT NULL,
        es_terminal        SMALLINT NOT NULL DEFAULT 0,
        orden              INTEGER NULL,
        activo             SMALLINT NOT NULL DEFAULT 1,
        CONSTRAINT pk_cat_estado_denuncia
            PRIMARY KEY (id_estado_denuncia),
        CONSTRAINT uq_cat_estado_denuncia_codigo
            UNIQUE (codigo),
        CONSTRAINT ck_cat_estado_denuncia_es_terminal
            CHECK (es_terminal IN (0,1)),
        CONSTRAINT ck_cat_estado_denuncia_activo
            CHECK (activo IN (0,1))
    );
END;
GO

-- ─── denuncias.cat_estado_envio_fiscalia ────────────────────────────────────
IF OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_estado_envio_fiscalia] (
        id_estado_envio_fiscalia INTEGER NOT NULL IDENTITY(1,1),
        codigo                   NVARCHAR(30) NOT NULL,
        nombre                   NVARCHAR(80) NOT NULL,
        es_terminal              SMALLINT NOT NULL DEFAULT 0,
        orden                    INTEGER NULL,
        activo                   SMALLINT NOT NULL DEFAULT 1,
        CONSTRAINT pk_cat_estado_envio_fiscalia
            PRIMARY KEY (id_estado_envio_fiscalia),
        CONSTRAINT uq_cat_estado_envio_fiscalia_codigo
            UNIQUE (codigo),
        CONSTRAINT ck_cat_estado_envio_fiscalia_es_terminal
            CHECK (es_terminal IN (0,1)),
        CONSTRAINT ck_cat_estado_envio_fiscalia_activo
            CHECK (activo IN (0,1))
    );
END;
GO


-- =============================================================================
-- BLOQUE 2 — DESCRIPCIONES EXTENDIDAS DE LOS CATÁLOGOS NUEVOS
-- =============================================================================

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = 0
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Catálogo de estados de la denuncia en su ciclo de vida operativo. Refleja la máquina de estados del proceso PO01.01 v2.0.0 (Gestión de Denuncias) más el estado terminal ANULADA. Los estados terminales (es_terminal = 1) cierran el ciclo de vida.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Catálogo de estados de la denuncia en su ciclo de vida operativo. Refleja la máquina de estados del proceso PO01.01 v2.0.0 (Gestión de Denuncias) más el estado terminal ANULADA. Los estados terminales (es_terminal = 1) cierran el ciclo de vida.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_denuncia]'), 'id_estado_denuncia', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Identificador único del estado de denuncia. Clave primaria autogenerada por el motor.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_estado_denuncia';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Identificador único del estado de denuncia. Clave primaria autogenerada por el motor.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_estado_denuncia';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_denuncia]'), 'codigo', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Código abreviado del estado, en mayúsculas con guion bajo. Inmutable una vez creado el catálogo. Ej: BORRADOR, FIRMADA_POR_JEFATURA, NOTIFICADA_FISCALIA.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'codigo';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Código abreviado del estado, en mayúsculas con guion bajo. Inmutable una vez creado el catálogo. Ej: BORRADOR, FIRMADA_POR_JEFATURA, NOTIFICADA_FISCALIA.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_denuncia]'), 'nombre', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Nombre descriptivo del estado para presentación en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'nombre';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Nombre descriptivo del estado para presentación en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_denuncia]'), 'es_terminal', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Indica si el estado cierra el ciclo de vida de la denuncia. 1 = terminal (NOTIFICADA_FISCALIA, ANULADA), 0 = transitorio.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'es_terminal';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Indica si el estado cierra el ciclo de vida de la denuncia. 1 = terminal (NOTIFICADA_FISCALIA, ANULADA), 0 = transitorio.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'es_terminal';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_denuncia]'), 'orden', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Orden numérico de presentación del estado en interfaces y reportes. Refleja la secuencia natural de la máquina de estados.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'orden';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Orden numérico de presentación del estado en interfaces y reportes. Refleja la secuencia natural de la máquina de estados.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'orden';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_denuncia]'), 'activo', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Indicador lógico de actividad del estado. 1 = activo (admitido para nuevas denuncias), 0 = inactivo (preserva trazabilidad histórica pero no admite nuevas asignaciones).',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'activo';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Indicador lógico de actividad del estado. 1 = activo (admitido para nuevas denuncias), 0 = inactivo (preserva trazabilidad histórica pero no admite nuevas asignaciones).',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_denuncia',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

-- ─── cat_estado_envio_fiscalia ──────────────────────────────────────────────
IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = 0
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Catálogo de estados del subflujo de envío de la denuncia al Ministerio Público. Refleja la integración con la API de Bitácora Web de Fiscalía documentada en PO01.01.04 Notificar Fiscalía.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Catálogo de estados del subflujo de envío de la denuncia al Ministerio Público. Refleja la integración con la API de Bitácora Web de Fiscalía documentada en PO01.01.04 Notificar Fiscalía.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]'), 'id_estado_envio_fiscalia', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Identificador único del estado de envío a Fiscalía. Clave primaria autogenerada por el motor.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'id_estado_envio_fiscalia';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Identificador único del estado de envío a Fiscalía. Clave primaria autogenerada por el motor.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'id_estado_envio_fiscalia';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]'), 'codigo', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Código abreviado del estado, en mayúsculas. Inmutable una vez creado el catálogo. Ej: PENDIENTE, ENVIADO, PRORROGADO.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'codigo';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Código abreviado del estado, en mayúsculas. Inmutable una vez creado el catálogo. Ej: PENDIENTE, ENVIADO, PRORROGADO.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]'), 'nombre', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Nombre descriptivo del estado para presentación en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'nombre';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Nombre descriptivo del estado para presentación en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]'), 'es_terminal', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Indica si el estado cierra el subflujo de envío. Bajo el modelo actual, ningún estado se considera terminal estructuralmente: el cierre exitoso se infiere por la presencia del RUC en denuncia.folio_externo.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'es_terminal';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Indica si el estado cierra el subflujo de envío. Bajo el modelo actual, ningún estado se considera terminal estructuralmente: el cierre exitoso se infiere por la presencia del RUC en denuncia.folio_externo.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'es_terminal';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]'), 'orden', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Orden numérico de presentación del estado en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'orden';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Orden numérico de presentación del estado en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'orden';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[cat_estado_envio_fiscalia]'), 'activo', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Indicador lógico de actividad del estado. 1 = activo, 0 = inactivo.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'activo';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Indicador lógico de actividad del estado. 1 = activo, 0 = inactivo.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'cat_estado_envio_fiscalia',
        @level2type = N'COLUMN', @level2name = N'activo';
GO


-- =============================================================================
-- BLOQUE 3 — REEMPLAZAR COLUMNAS DE ESTADO EN denuncias.denuncia
-- =============================================================================
-- Como no hay datos productivos, se realiza el cambio limpio:
--   1. Drop del índice ix_denuncia_estado (referencia la columna antigua).
--   2. Drop de las 3 columnas de estado.
--   3. Add de las 2 columnas FK nuevas.
--   4. Add de las constraints FK.
--   5. Recrear el índice ix_denuncia_estado sobre la columna FK nueva.
--   6. Crear índice adicional para consultas operativas de envío a fiscalía.
-- =============================================================================

-- 3.1 — Drop del índice antes de poder dropear la columna
IF EXISTS (SELECT 1 FROM sys.indexes
            WHERE name = 'ix_denuncia_estado'
              AND object_id = OBJECT_ID('[denuncias].[denuncia]'))
BEGIN
    DROP INDEX [ix_denuncia_estado] ON [denuncias].[denuncia];
END;
GO

-- 3.2 — Drop dinámico de DEFAULT constraints autogenerados
-- ─────────────────────────────────────────────────────────────────────────
-- Las columnas estado_denuncia, estado_envio_fiscalia y estado_borrador
-- fueron declaradas en V0001 con DEFAULT inline sin nombre explícito de
-- constraint. SQL Server les asignó nombres autogenerados con sufijo
-- aleatorio (DF__denuncia__estado__XXXXXXXX) que VARÍAN entre ambientes.
-- Para poder dropear las columnas, hay que eliminar primero los DEFAULT
-- constraints asociados, descubriendo sus nombres dinámicamente vía
-- sys.default_constraints + sys.columns.
-- ─────────────────────────────────────────────────────────────────────────
DECLARE @drop_default_sql NVARCHAR(MAX) = N'';

SELECT @drop_default_sql = @drop_default_sql
     + N'ALTER TABLE [denuncias].[denuncia] DROP CONSTRAINT ['
     + dc.name + N'];' + CHAR(13) + CHAR(10)
  FROM sys.default_constraints dc
  JOIN sys.columns c
    ON c.object_id = dc.parent_object_id
   AND c.column_id = dc.parent_column_id
 WHERE dc.parent_object_id = OBJECT_ID('[denuncias].[denuncia]')
   AND c.name IN (N'estado_denuncia', N'estado_envio_fiscalia', N'estado_borrador');

IF LEN(@drop_default_sql) > 0
BEGIN
    PRINT N'V0007 - Eliminando DEFAULT constraints autogenerados:';
    PRINT @drop_default_sql;
    EXEC sp_executesql @drop_default_sql;
END;
GO

-- 3.3 — Drop de las 3 columnas de estado
-- Nota: estado_borrador se elimina sin reemplazo (era redundante con estado_denuncia)
IF COL_LENGTH('[denuncias].[denuncia]', 'estado_denuncia') IS NOT NULL
    ALTER TABLE [denuncias].[denuncia] DROP COLUMN [estado_denuncia];
GO

IF COL_LENGTH('[denuncias].[denuncia]', 'estado_envio_fiscalia') IS NOT NULL
    ALTER TABLE [denuncias].[denuncia] DROP COLUMN [estado_envio_fiscalia];
GO

IF COL_LENGTH('[denuncias].[denuncia]', 'estado_borrador') IS NOT NULL
    ALTER TABLE [denuncias].[denuncia] DROP COLUMN [estado_borrador];
GO

-- 3.4 — Add columnas FK nuevas
-- id_estado_denuncia: NOT NULL (toda denuncia tiene siempre un estado)
-- id_estado_envio_fiscalia: NULL (solo aplica desde que la denuncia entra al
--   subflujo de envío, post-firma de jefatura)
IF COL_LENGTH('[denuncias].[denuncia]', 'id_estado_denuncia') IS NULL
    ALTER TABLE [denuncias].[denuncia]
        ADD [id_estado_denuncia] INTEGER NOT NULL
            CONSTRAINT df_denuncia_estado DEFAULT (1);  -- 1 = BORRADOR (semilla R__)
GO

IF COL_LENGTH('[denuncias].[denuncia]', 'id_estado_envio_fiscalia') IS NULL
    ALTER TABLE [denuncias].[denuncia]
        ADD [id_estado_envio_fiscalia] INTEGER NULL;
GO

-- 3.5 — Add constraints FK
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
                WHERE name = 'fk_denuncia_estado_denuncia'
                  AND parent_object_id = OBJECT_ID('[denuncias].[denuncia]'))
BEGIN
    ALTER TABLE [denuncias].[denuncia]
        ADD CONSTRAINT fk_denuncia_estado_denuncia
            FOREIGN KEY (id_estado_denuncia)
            REFERENCES [denuncias].[cat_estado_denuncia] (id_estado_denuncia);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
                WHERE name = 'fk_denuncia_estado_envio_fiscalia'
                  AND parent_object_id = OBJECT_ID('[denuncias].[denuncia]'))
BEGIN
    ALTER TABLE [denuncias].[denuncia]
        ADD CONSTRAINT fk_denuncia_estado_envio_fiscalia
            FOREIGN KEY (id_estado_envio_fiscalia)
            REFERENCES [denuncias].[cat_estado_envio_fiscalia] (id_estado_envio_fiscalia);
END;
GO

-- 3.6 — Recrear índice operativo (ahora sobre la columna FK nueva)
IF NOT EXISTS (SELECT 1 FROM sys.indexes
                WHERE name = 'ix_denuncia_estado'
                  AND object_id = OBJECT_ID('[denuncias].[denuncia]'))
BEGIN
    CREATE INDEX [ix_denuncia_estado]
        ON [denuncias].[denuncia] (id_estado_denuncia, fecha_denuncia);
END;
GO

-- 3.7 — Índice adicional para consultas operativas de envío a fiscalía
-- (filtered index: solo registros con envío iniciado)
IF NOT EXISTS (SELECT 1 FROM sys.indexes
                WHERE name = 'ix_denuncia_envio_fiscalia'
                  AND object_id = OBJECT_ID('[denuncias].[denuncia]'))
BEGIN
    CREATE INDEX [ix_denuncia_envio_fiscalia]
        ON [denuncias].[denuncia] (id_estado_envio_fiscalia)
        WHERE id_estado_envio_fiscalia IS NOT NULL;
END;
GO


-- =============================================================================
-- BLOQUE 4 — DESCRIPCIONES EXTENDIDAS DE LAS COLUMNAS NUEVAS
-- =============================================================================

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[denuncia]'), 'id_estado_denuncia', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Estado actual de la denuncia en su ciclo de vida operativo. FK a denuncias.cat_estado_denuncia. La máquina de estados sigue el proceso PO01.01 v2.0.0: BORRADOR → FIRMADA_POR_INVESTIGADOR → EN_REVISION → (OBSERVADO ↔ EN_REVISION) → FIRMADA_POR_JEFATURA → NOTIFICADA_FISCALIA. El estado terminal alternativo ANULADA admite ingreso desde estados no terminales. La validación de transiciones permitidas es responsabilidad de la capa de aplicación.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'denuncia',
        @level2type = N'COLUMN', @level2name = N'id_estado_denuncia';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Estado actual de la denuncia en su ciclo de vida operativo. FK a denuncias.cat_estado_denuncia. La máquina de estados sigue el proceso PO01.01 v2.0.0: BORRADOR → FIRMADA_POR_INVESTIGADOR → EN_REVISION → (OBSERVADO ↔ EN_REVISION) → FIRMADA_POR_JEFATURA → NOTIFICADA_FISCALIA. El estado terminal alternativo ANULADA admite ingreso desde estados no terminales. La validación de transiciones permitidas es responsabilidad de la capa de aplicación.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'denuncia',
        @level2type = N'COLUMN', @level2name = N'id_estado_denuncia';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties
        WHERE class = 1
          AND major_id = OBJECT_ID('[denuncias].[denuncia]')
          AND minor_id = COLUMNPROPERTY(OBJECT_ID('[denuncias].[denuncia]'), 'id_estado_envio_fiscalia', 'ColumnId')
          AND name = N'MS_Description'
)
    EXEC sys.sp_updateextendedproperty
        @name  = N'MS_Description',
        @value = N'Estado del subflujo de envío de la denuncia a Fiscalía. FK a denuncias.cat_estado_envio_fiscalia. Es NULL hasta que la denuncia entra al subflujo de envío (tras FIRMADA_POR_JEFATURA). Valores: PENDIENTE → ENVIADO → PRORROGADO. El cierre exitoso del envío se infiere por la presencia del RUC en denuncia.folio_externo. Documentado en proceso PO01.01.04 Notificar Fiscalía.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'denuncia',
        @level2type = N'COLUMN', @level2name = N'id_estado_envio_fiscalia';
ELSE
    EXEC sys.sp_addextendedproperty
        @name  = N'MS_Description',
        @value = N'Estado del subflujo de envío de la denuncia a Fiscalía. FK a denuncias.cat_estado_envio_fiscalia. Es NULL hasta que la denuncia entra al subflujo de envío (tras FIRMADA_POR_JEFATURA). Valores: PENDIENTE → ENVIADO → PRORROGADO. El cierre exitoso del envío se infiere por la presencia del RUC en denuncia.folio_externo. Documentado en proceso PO01.01.04 Notificar Fiscalía.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE', @level1name = N'denuncia',
        @level2type = N'COLUMN', @level2name = N'id_estado_envio_fiscalia';
GO


-- =============================================================================
-- BLOQUE 5 — REPARAR BUG DE FK DUPLICADA EN procedimiento_policial
-- =============================================================================
-- El V0006 (realojamiento de cat_programa_seguridad de casos a configuracion)
-- dejó dos FKs con el mismo nombre fk_proc_programa apuntando a tablas
-- distintas:
--   - fk_proc_programa: id_programa_seguridad → casos.cat_programa_seguridad
--   - fk_proc_programa: id_programa_seguridad → configuracion.cat_programa_seguridad
--
-- Esto puede generar comportamiento ambiguo. La FK correcta es la que apunta
-- a configuracion (destino del realojamiento). Se elimina la FK obsoleta
-- (la que apunta a casos) y se mantiene únicamente la nueva, renombrándola
-- para mayor claridad si es necesario.
-- =============================================================================

-- Diagnóstico: listar FKs actuales sobre procedimiento_policial.id_programa_seguridad
-- (informativo en logs de ejecución)
DECLARE @fk_obsoleta_id INT;

SELECT @fk_obsoleta_id = fk.object_id
  FROM sys.foreign_keys fk
  JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
  JOIN sys.columns c ON c.object_id = fkc.parent_object_id 
                    AND c.column_id = fkc.parent_column_id
 WHERE fk.parent_object_id = OBJECT_ID('[denuncias].[procedimiento_policial]')
   AND c.name = 'id_programa_seguridad'
   AND fk.referenced_object_id = OBJECT_ID('[casos].[cat_programa_seguridad]');

IF @fk_obsoleta_id IS NOT NULL
BEGIN
    DECLARE @fk_obsoleta_nombre NVARCHAR(128);
    SELECT @fk_obsoleta_nombre = name FROM sys.foreign_keys WHERE object_id = @fk_obsoleta_id;
    DECLARE @sql NVARCHAR(500) = 
        N'ALTER TABLE [denuncias].[procedimiento_policial] DROP CONSTRAINT [' 
        + @fk_obsoleta_nombre + N']';
    EXEC sp_executesql @sql;
END;
GO


-- =============================================================================
-- FIN — V0007__catalogos_estado_denuncia
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--
--   -- Catálogos creados
--   SELECT name FROM sys.tables
--    WHERE schema_id = SCHEMA_ID('denuncias')
--      AND name IN ('cat_estado_denuncia', 'cat_estado_envio_fiscalia');
--   -- esperado: 2 filas
--
--   -- Catálogos vacíos (los datos los carga R__denuncias_seed.sql)
--   SELECT COUNT(*) FROM [denuncias].[cat_estado_denuncia];
--   SELECT COUNT(*) FROM [denuncias].[cat_estado_envio_fiscalia];
--   -- esperado: 0 filas en cada uno (hasta que corra R__denuncias_seed)
--
--   -- Columnas nuevas en denuncia
--   SELECT name, system_type_id, is_nullable
--     FROM sys.columns
--    WHERE object_id = OBJECT_ID('[denuncias].[denuncia]')
--      AND name IN ('id_estado_denuncia', 'id_estado_envio_fiscalia');
--   -- esperado: 2 filas con tipo INT (56)
--
--   -- Columnas viejas eliminadas
--   SELECT name FROM sys.columns
--    WHERE object_id = OBJECT_ID('[denuncias].[denuncia]')
--      AND name IN ('estado_denuncia', 'estado_envio_fiscalia', 'estado_borrador');
--   -- esperado: 0 filas
--
--   -- FKs creadas
--   SELECT name FROM sys.foreign_keys
--    WHERE parent_object_id = OBJECT_ID('[denuncias].[denuncia]')
--      AND name IN ('fk_denuncia_estado_denuncia', 'fk_denuncia_estado_envio_fiscalia');
--   -- esperado: 2 filas
--
--   -- FK obsoleta de procedimiento_policial eliminada
--   SELECT fk.name, OBJECT_NAME(fk.referenced_object_id) AS referenced_table
--     FROM sys.foreign_keys fk
--    WHERE fk.parent_object_id = OBJECT_ID('[denuncias].[procedimiento_policial]')
--      AND fk.referenced_object_id = OBJECT_ID('[casos].[cat_programa_seguridad]');
--   -- esperado: 0 filas
--
--   -- Verificar que el índice operativo se recreó correctamente
--   SELECT i.name, c.name AS column_name
--     FROM sys.indexes i
--     JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
--     JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
--    WHERE i.object_id = OBJECT_ID('[denuncias].[denuncia]')
--      AND i.name IN ('ix_denuncia_estado', 'ix_denuncia_envio_fiscalia')
--    ORDER BY i.name, ic.key_ordinal;
--   -- esperado: 3 filas (ix_denuncia_estado x 2 columnas, ix_denuncia_envio_fiscalia x 1)
-- =============================================================================
