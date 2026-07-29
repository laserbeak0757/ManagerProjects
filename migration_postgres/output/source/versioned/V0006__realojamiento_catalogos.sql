-- =============================================================================
-- SIP — Migration V0006__realojamiento_catalogos
-- =============================================================================
-- Versión:      4.0 v4 (incremental sobre V0005)
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql               (define las tablas origen)
--               V0003__nuevo_esquema_encargos.sql     (sin impacto directo)
--               V0004__drop_denuncias_encargos_legacy (sin impacto directo)
--
-- ALCANCE:
--   Realoja tres tablas que estaban en esquemas no-óptimos a su esquema
--   semánticamente correcto, con base en el análisis de FKs entrantes
--   realizado durante la consolidación del Diseño del Modelo de Datos:
--
--     1. casos.cat_tipo_relato       → denuncias.cat_tipo_relato
--        Único consumidor: denuncias.relato.id_tipo_relato.
--
--     2. casos.cat_programa_seguridad → configuracion.cat_programa_seguridad
--        Único consumidor actual: denuncias.procedimiento_policial. Se aloja
--        en `configuracion` por su naturaleza de catálogo institucional
--        transversal (programas gubernamentales de seguridad), aplicable
--        potencialmente a otros esquemas además de denuncias.
--
--     3. denuncias.fenomeno_delictual → investigacion.fenomeno_delictual
--        Único consumidor: investigacion.hecho_fenomeno. Pertenece
--        conceptualmente al dominio de investigación (fenómeno asociado al
--        hecho criminal), no al de la denuncia.
--
-- JUSTIFICACIÓN:
--   Las tres tablas eran "huérfanas semánticas": vivían en un esquema pero
--   ninguna tabla del propio esquema las referenciaba. La reubicación elimina
--   dependencias cruzadas innecesarias y deja cada tabla en el esquema cuyo
--   dominio funcional realmente le corresponde.
--
-- ESTRUCTURA DE CADA BLOQUE (PASOS 1, 2, 3):
--   a) DROP CONSTRAINT de las FKs que apuntan a la tabla origen
--   b) DROP CONSTRAINT de las FKs salientes de la tabla origen (si las hay)
--   c) CREATE TABLE en el esquema destino con estructura idéntica
--   d) sp_addextendedproperty con la descripción a nivel TABLE en el destino
--   e) sp_addextendedproperty con las descripciones a nivel COLUMN en el destino
--   f) INSERT INTO destino SELECT * FROM origen (con SET IDENTITY_INSERT
--      para preservar IDs si hay datos)
--   g) DROP TABLE origen
--   h) ADD CONSTRAINT de las FKs apuntando ahora al destino
--
--   El orden CREATE → descripciones → INSERT → DROP origen → FKs garantiza:
--     · La tabla destino queda documentada antes de cualquier operación de
--       datos, lo que sobrevive ante interrupciones intermedias.
--     · El DROP TABLE origen elimina automáticamente sus extended_properties
--       (no requiere limpieza explícita).
--
-- IDEMPOTENCIA:
--   Cada DROP CONSTRAINT verifica existencia con sys.foreign_keys.
--   Cada CREATE TABLE verifica con OBJECT_ID(...) IS NULL.
--   Cada sp_addextendedproperty verifica con sys.extended_properties.
--   La migration es segura ante reaplicación parcial accidental.
--
-- DATOS:
--   El INSERT...SELECT con IDENTITY_INSERT preserva los IDs originales si las
--   tablas tienen datos productivos. En línea base recién desplegada las
--   tablas suelen estar vacías, en cuyo caso el INSERT es no-op.
--
-- COHERENCIA CON V0005 (NO modificar V0005):
--   Las migrations se ejecutan secuencialmente y V0006 es idempotente y
--   reproducible desde cero. En cualquier ambiente nuevo el orden es:
--     · V0001 → crea las 3 tablas en su ubicación antigua
--               (casos.cat_tipo_relato, casos.cat_programa_seguridad,
--                denuncias.fenomeno_delictual).
--     · V0005 → aplica descripciones a esas 3 tablas en su ubicación
--               antigua. En este punto las tablas existen y la operación
--               es válida.
--     · V0006 → ejecuta DROP TABLE sobre las 3 tablas antiguas, lo que
--               elimina automáticamente sus extended properties
--               (cascada nativa de SQL Server), y crea las 3 tablas
--               nuevas con sus propias descripciones — idénticas en
--               contenido a las que V0005 aplicó previamente — en la
--               ubicación definitiva.
--   Resultado final: las 3 tablas viven en su nueva ubicación con
--   todas sus descripciones; no quedan restos en los esquemas antiguos
--   ni descripciones huérfanas. V0005 mantiene su coherencia histórica
--   y NO requiere modificación.
--
-- ROLLBACK:
--   No hay rollback automático en Flyway para Versioned migrations. Para
--   revertir, se requiere migration inversa o restauración desde backup.
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
-- PASO 1 — casos.cat_tipo_relato → denuncias.cat_tipo_relato
-- =============================================================================
-- Catálogo de tipos de relato asociado a una denuncia. Su único consumidor
-- es denuncias.relato; vivía en `casos` por motivos no estructurales.
-- =============================================================================

-- 1.a) Eliminar la FK entrante desde denuncias.relato
IF EXISTS (SELECT 1 FROM sys.foreign_keys
           WHERE name = 'fk_relato_tipo'
             AND parent_object_id = OBJECT_ID('[denuncias].[relato]'))
    ALTER TABLE [denuncias].[relato] DROP CONSTRAINT [fk_relato_tipo];
GO

-- 1.b) Crear la nueva tabla en el esquema destino
IF OBJECT_ID('[denuncias].[cat_tipo_relato]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_tipo_relato] (
        id_tipo_relato INTEGER IDENTITY(1,1) NOT NULL,
        codigo NVARCHAR(30) NOT NULL,
        nombre NVARCHAR(100) NOT NULL,
        CONSTRAINT pk_cat_tipo_relato PRIMARY KEY (id_tipo_relato),
        CONSTRAINT uq_cat_tipo_relato UNIQUE (codigo)
    );
END
GO

-- 1.c) Descripciones extendidas (TABLE + COLUMNS) en el destino
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE name = 'MS_Description'
                 AND major_id = OBJECT_ID('[denuncias].[cat_tipo_relato]')
                 AND minor_id = 0 AND class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Catálogo de tipos de relato asociado a una denuncia.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato';
END
GO


IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[denuncias].[cat_tipo_relato]')
                 AND c.name = 'id_tipo_relato' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
        @level2type = N'COLUMN', @level2name = N'id_tipo_relato';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[denuncias].[cat_tipo_relato]')
                 AND c.name = 'codigo' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Código identificador único en el catálogo de tipos de relato asociado a una denuncia. Valor corto y estable que las aplicaciones referencian de forma directa.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
        @level2type = N'COLUMN', @level2name = N'codigo';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[denuncias].[cat_tipo_relato]')
                 AND c.name = 'nombre' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Nombre legible en el catálogo de tipos de relato asociado a una denuncia. Usado en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
        @level2type = N'COLUMN', @level2name = N'nombre';
END
GO

-- 1.d) Migrar datos preservando IDs (si los hubiera)
IF OBJECT_ID('[casos].[cat_tipo_relato]', 'U') IS NOT NULL
   AND EXISTS (SELECT 1 FROM [casos].[cat_tipo_relato])
BEGIN
    SET IDENTITY_INSERT [denuncias].[cat_tipo_relato] ON;
    INSERT INTO [denuncias].[cat_tipo_relato] (id_tipo_relato, codigo, nombre)
    SELECT id_tipo_relato, codigo, nombre FROM [casos].[cat_tipo_relato];
    SET IDENTITY_INSERT [denuncias].[cat_tipo_relato] OFF;
END
GO

-- 1.e) Eliminar la tabla origen
IF OBJECT_ID('[casos].[cat_tipo_relato]', 'U') IS NOT NULL
    DROP TABLE [casos].[cat_tipo_relato];
GO

-- 1.f) Recrear la FK apuntando ahora a la nueva ubicación
ALTER TABLE [denuncias].[relato]
    ADD CONSTRAINT fk_relato_tipo FOREIGN KEY (id_tipo_relato)
    REFERENCES [denuncias].[cat_tipo_relato] (id_tipo_relato);
GO


-- =============================================================================
-- PASO 2 — casos.cat_programa_seguridad → configuracion.cat_programa_seguridad
-- =============================================================================
-- Catálogo de programas gubernamentales de seguridad. Su único consumidor
-- actual es denuncias.procedimiento_policial, pero por su naturaleza
-- transversal (catálogo institucional aplicable a múltiples dominios) se
-- aloja en `configuracion` y no en `denuncias`.
-- =============================================================================

-- 2.a) Eliminar la FK entrante desde denuncias.procedimiento_policial
IF EXISTS (SELECT 1 FROM sys.foreign_keys
           WHERE name = 'fk_proc_programa'
             AND parent_object_id = OBJECT_ID('[denuncias].[procedimiento_policial]'))
    ALTER TABLE [denuncias].[procedimiento_policial] DROP CONSTRAINT [fk_proc_programa];
GO

-- 2.b) Eliminar la FK saliente de la tabla origen (a ubicacion.comuna)
IF EXISTS (SELECT 1 FROM sys.foreign_keys
           WHERE name = 'fk_progseq_comuna'
             AND parent_object_id = OBJECT_ID('[casos].[cat_programa_seguridad]'))
    ALTER TABLE [casos].[cat_programa_seguridad] DROP CONSTRAINT [fk_progseq_comuna];
GO

-- 2.c) Crear la nueva tabla en el esquema destino
IF OBJECT_ID('[configuracion].[cat_programa_seguridad]', 'U') IS NULL
BEGIN
    CREATE TABLE [configuracion].[cat_programa_seguridad] (
        id_programa_seguridad INTEGER IDENTITY(1,1) NOT NULL,
        nombre NVARCHAR(200) NOT NULL,
        descripcion NVARCHAR(500) NULL,
        id_comuna INTEGER NULL,
        activo SMALLINT NOT NULL DEFAULT 1
            CONSTRAINT ck_cat_programa_seguridad_activo CHECK (activo IN (0,1)),
        fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT pk_cat_programa_seguridad PRIMARY KEY (id_programa_seguridad)
    );
END
GO

-- 2.d) Descripciones extendidas (TABLE + COLUMNS) en el destino
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE name = 'MS_Description'
                 AND major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND minor_id = 0 AND class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Catálogo de programas gubernamentales de seguridad según comuna. Fuente: S14.',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad';
END
GO


IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND c.name = 'id_programa_seguridad' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND c.name = 'id_comuna' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Referencia opcional a ubicacion.comuna. Puede ser nulo si la asociación no aplica al registro.',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'id_comuna';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND c.name = 'activo' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'activo';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND c.name = 'fecha_registro' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND c.name = 'nombre' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Nombre legible en el catálogo de programas gubernamentales de seguridad por comuna. Usado en interfaces y reportes.',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'nombre';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[configuracion].[cat_programa_seguridad]')
                 AND c.name = 'descripcion' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Descripción extendida en el catálogo de programas gubernamentales de seguridad por comuna. Texto opcional con información adicional.',
        @level0type = N'SCHEMA', @level0name = N'configuracion',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'descripcion';
END
GO

-- 2.e) Migrar datos preservando IDs (si los hubiera)
IF OBJECT_ID('[casos].[cat_programa_seguridad]', 'U') IS NOT NULL
   AND EXISTS (SELECT 1 FROM [casos].[cat_programa_seguridad])
BEGIN
    SET IDENTITY_INSERT [configuracion].[cat_programa_seguridad] ON;
    INSERT INTO [configuracion].[cat_programa_seguridad]
        (id_programa_seguridad, nombre, descripcion, id_comuna, activo, fecha_registro)
    SELECT
        id_programa_seguridad, nombre, descripcion, id_comuna, activo, fecha_registro
    FROM [casos].[cat_programa_seguridad];
    SET IDENTITY_INSERT [configuracion].[cat_programa_seguridad] OFF;
END
GO

-- 2.f) Eliminar la tabla origen
IF OBJECT_ID('[casos].[cat_programa_seguridad]', 'U') IS NOT NULL
    DROP TABLE [casos].[cat_programa_seguridad];
GO

-- 2.g) Recrear la FK saliente desde la nueva ubicación a ubicacion.comuna
ALTER TABLE [configuracion].[cat_programa_seguridad]
    ADD CONSTRAINT fk_progseq_comuna FOREIGN KEY (id_comuna)
    REFERENCES [ubicacion].[comuna] (id_comuna);
GO

-- 2.h) Recrear la FK entrante desde denuncias.procedimiento_policial
ALTER TABLE [denuncias].[procedimiento_policial]
    ADD CONSTRAINT fk_proc_programa FOREIGN KEY (id_programa_seguridad)
    REFERENCES [configuracion].[cat_programa_seguridad] (id_programa_seguridad);
GO


-- =============================================================================
-- PASO 3 — denuncias.fenomeno_delictual → investigacion.fenomeno_delictual
-- =============================================================================
-- Catálogo oficial de fenómenos delictuales del Ministerio Público. Pertenece
-- conceptualmente al dominio de investigación (el fenómeno se asocia al
-- hecho criminal, no a la denuncia), y su único consumidor es
-- investigacion.hecho_fenomeno.
-- =============================================================================

-- 3.a) Eliminar la FK entrante desde investigacion.hecho_fenomeno
IF EXISTS (SELECT 1 FROM sys.foreign_keys
           WHERE name = 'fk_hecho_fenomeno_fenomeno'
             AND parent_object_id = OBJECT_ID('[investigacion].[hecho_fenomeno]'))
    ALTER TABLE [investigacion].[hecho_fenomeno]
        DROP CONSTRAINT [fk_hecho_fenomeno_fenomeno];
GO

-- 3.b) Crear la nueva tabla en el esquema destino
IF OBJECT_ID('[investigacion].[fenomeno_delictual]', 'U') IS NULL
BEGIN
    CREATE TABLE [investigacion].[fenomeno_delictual] (
        id_fenomeno INTEGER IDENTITY(1,1) NOT NULL,
        codigo_mp NVARCHAR(30) NOT NULL,
        nombre NVARCHAR(200) NOT NULL,
        descripcion NVARCHAR(2000) NULL,
        anio_vigencia INTEGER NULL,
        vigente SMALLINT NOT NULL DEFAULT 1
            CONSTRAINT ck_fenomeno_delictual_vigente CHECK (vigente IN (0,1)),
        fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion DATETIME2(7) NULL,
        CONSTRAINT pk_fenomeno_delictual PRIMARY KEY (id_fenomeno),
        CONSTRAINT uq_fenomeno_codigo_mp UNIQUE (codigo_mp, anio_vigencia)
    );
END
GO

-- 3.c) Descripciones extendidas (TABLE + COLUMNS) en el destino
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE name = 'MS_Description'
                 AND major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND minor_id = 0 AND class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Catálogo oficial de fenómenos delictuales del Ministerio Público (MP define el catálogo, PDI lo aplica al hecho). v3.1 v1: el fenómeno se asigna al hecho criminal vía investigacion.hecho_fenomeno (M:N), no a la denuncia. Actualización anual junio. Fuente: S1, NotebookLM.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual';
END
GO


IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'id_fenomeno' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Identificador único del fenómeno delictual. Clave primaria generada por el sistema.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'id_fenomeno';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'codigo_mp' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Código oficial del fenómeno asignado por el Ministerio Público.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'codigo_mp';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'nombre' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Nombre oficial del fenómeno delictual. Ej: Robo con violencia, Tráfico de drogas, Homicidio, Turbazo, Abordazo, Encerrona.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'nombre';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'descripcion' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Diccionario tooltip del fenómeno delictual. v3.1 v1: ampliado de VARCHAR(500) a VARCHAR(2000) para soportar descripciones detalladas que diferencian conceptos similares (ej. distinguir Abordazo vs Encerrona). Campo opcional.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'descripcion';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'anio_vigencia' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Año de vigencia del fenómeno según la versión del catálogo del Ministerio Público. Campo opcional.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'anio_vigencia';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'vigente' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Indica si el fenómeno está vigente en el catálogo actual. Valor 1 = vigente. Los fenómenos desactivados se preservan para trazabilidad de denuncias históricas.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'vigente';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'fecha_registro' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
               JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
               WHERE ep.name = 'MS_Description'
                 AND ep.major_id = OBJECT_ID('[investigacion].[fenomeno_delictual]')
                 AND c.name = 'fecha_actualizacion' AND ep.class = 1)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Fecha y hora UTC de la última modificación.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
END
GO

-- 3.d) Migrar datos preservando IDs (si los hubiera)
IF OBJECT_ID('[denuncias].[fenomeno_delictual]', 'U') IS NOT NULL
   AND EXISTS (SELECT 1 FROM [denuncias].[fenomeno_delictual])
BEGIN
    SET IDENTITY_INSERT [investigacion].[fenomeno_delictual] ON;
    INSERT INTO [investigacion].[fenomeno_delictual]
        (id_fenomeno, codigo_mp, nombre, descripcion, anio_vigencia,
         vigente, fecha_registro, fecha_actualizacion)
    SELECT
        id_fenomeno, codigo_mp, nombre, descripcion, anio_vigencia,
        vigente, fecha_registro, fecha_actualizacion
    FROM [denuncias].[fenomeno_delictual];
    SET IDENTITY_INSERT [investigacion].[fenomeno_delictual] OFF;
END
GO

-- 3.e) Eliminar la tabla origen
IF OBJECT_ID('[denuncias].[fenomeno_delictual]', 'U') IS NOT NULL
    DROP TABLE [denuncias].[fenomeno_delictual];
GO

-- 3.f) Recrear la FK apuntando ahora a la nueva ubicación
ALTER TABLE [investigacion].[hecho_fenomeno]
    ADD CONSTRAINT fk_hecho_fenomeno_fenomeno FOREIGN KEY (id_fenomeno)
    REFERENCES [investigacion].[fenomeno_delictual] (id_fenomeno);
GO


-- =============================================================================
-- FIN — V0006__realojamiento_catalogos
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--
--   -- Las tablas deben existir en su nueva ubicación
--   SELECT s.name AS schema_name, t.name AS table_name
--     FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
--    WHERE (s.name = 'denuncias'    AND t.name = 'cat_tipo_relato')
--       OR (s.name = 'configuracion' AND t.name = 'cat_programa_seguridad')
--       OR (s.name = 'investigacion' AND t.name = 'fenomeno_delictual');
--   -- esperado: 3 filas
--
--   -- Las tablas NO deben existir en su ubicación antigua
--   SELECT s.name AS schema_name, t.name AS table_name
--     FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
--    WHERE (s.name = 'casos'     AND t.name IN ('cat_tipo_relato','cat_programa_seguridad'))
--       OR (s.name = 'denuncias' AND t.name = 'fenomeno_delictual');
--   -- esperado: 0 filas
--
--   -- Las FKs deben apuntar a la nueva ubicación
--   SELECT fk.name, OBJECT_SCHEMA_NAME(fk.parent_object_id) + '.' +
--          OBJECT_NAME(fk.parent_object_id) AS parent,
--          OBJECT_SCHEMA_NAME(fk.referenced_object_id) + '.' +
--          OBJECT_NAME(fk.referenced_object_id) AS referenced
--     FROM sys.foreign_keys fk
--    WHERE fk.name IN ('fk_relato_tipo','fk_proc_programa',
--                      'fk_progseq_comuna','fk_hecho_fenomeno_fenomeno');
--
--   -- Las descripciones extendidas deben existir en las nuevas ubicaciones
--   SELECT OBJECT_SCHEMA_NAME(ep.major_id) AS schema_name,
--          OBJECT_NAME(ep.major_id) AS table_name,
--          c.name AS column_name,
--          CAST(ep.value AS NVARCHAR(MAX)) AS descripcion
--     FROM sys.extended_properties ep
--     LEFT JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
--    WHERE ep.name = 'MS_Description'
--      AND ep.class = 1
--      AND OBJECT_SCHEMA_NAME(ep.major_id) IN ('denuncias','configuracion','investigacion')
--      AND OBJECT_NAME(ep.major_id) IN ('cat_tipo_relato','cat_programa_seguridad','fenomeno_delictual')
--    ORDER BY 1, 2, c.column_id;
--   -- esperado: 20 filas (3 TABLE-level + 17 COLUMN-level)
--
--   -- Conteo total de tablas debe mantenerse (222)
--   SELECT COUNT(*) FROM sys.tables;                                  -- esperado: 222
-- =============================================================================
