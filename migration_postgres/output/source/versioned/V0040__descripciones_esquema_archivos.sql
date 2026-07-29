-- =============================================================================
-- V0040 -- Descripciones (MS_Description) del esquema archivos
-- PDI Chile -- SIP. SQL Server. Flyway.
--
-- Documenta a nivel de base de datos las 4 tablas del esquema archivos y todas
-- sus columnas (estado posterior a V0039). Objetivo: mantenibilidad -- la
-- documentacion vive junto al modelo y se lee desde sys.extended_properties.
--
-- Tablas: cat_tipo_archivo, archivo, archivo_vinculo, cat_entidad_vinculable.
-- Patron: drop-then-add (idempotente y actualizable en cada corrida),
-- identico a V0005.
-- =============================================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

-- =============================================================================
-- Tabla: archivos.cat_tipo_archivo
-- =============================================================================

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.tables t ON ep.major_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description' AND ep.minor_id = 0
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de archivo del sistema (documento, imagen, video, etc.). Clasifica cada fila de archivos.archivo. Patrón de catálogo: 5 columnas de auditoría (omite id_usuario_creador).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'id_tipo_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'id_tipo_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de archivo. Clave primaria autogenerada (IDENTITY).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código único y estable del tipo de archivo (p. ej. ''PDF'', ''IMG'', ''VIDEO''). Uso programático; UNIQUE.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible del tipo de archivo para presentación al usuario.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'es_multimedia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'es_multimedia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el tipo corresponde a contenido multimedia (audio, video, imagen). 1 = sí, 0 = no. CHECK (0,1).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'es_multimedia';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'tamanio_max_mb'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'tamanio_max_mb';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tamaño máximo permitido en MB para archivos de este tipo. NULL = sin límite específico del tipo (rige el límite global de la plataforma).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'tamanio_max_mb';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'id_usuario_modificador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario de la última modificación del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'id_usuario_eliminador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario que efectuó la baja lógica del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'fecha_creacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de creación del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la última actualización del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_tipo_archivo' AND c.name = N'fecha_eliminacion_logica'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la baja lógica. NULL = registro vigente. Los registros no se borran físicamente; la eliminación es siempre lógica.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO


-- =============================================================================
-- Tabla: archivos.archivo
-- =============================================================================

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.tables t ON ep.major_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description' AND ep.minor_id = 0
        AND s.name = N'archivos' AND t.name = N'archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Metadata y ubicación de cada archivo físico cargado en el sistema. El contenido binario reside en almacenamiento externo; la columna ruta apunta a él. Entidad central del subsistema de archivos.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del archivo. Clave primaria autogenerada (IDENTITY).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'nombre_original'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'nombre_original';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre original del archivo tal como lo cargó el usuario. Valor descriptivo.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'nombre_original';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'nombre_almacenado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'nombre_almacenado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre con que el archivo se persiste en el almacenamiento (normalizado y único). Evita colisiones y caracteres inválidos.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'nombre_almacenado';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'ruta'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'ruta';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Ruta o clave de ubicación del archivo en el almacenamiento físico externo.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'ruta';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'mime_type'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'mime_type';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo MIME del contenido (p. ej. ''application/pdf'', ''image/jpeg''). Determina el manejo del archivo.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'mime_type';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'extension'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'extension';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Extensión del archivo sin el punto (p. ej. ''pdf''). Informativa.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'extension';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'tamano_bytes'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'tamano_bytes';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tamaño del archivo en bytes.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'tamano_bytes';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'hash_sha256'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'hash_sha256';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hash SHA-256 del contenido. Permite verificar integridad y detectar duplicados.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'hash_sha256';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_tipo_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_tipo_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de archivo. FK a archivos.cat_tipo_archivo.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_funcionario_carga'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_carga';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que realizó la carga del archivo. Referencia a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_carga';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'origen'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'origen';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Origen o canal de la carga (módulo, proceso o sistema que originó el archivo).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'origen';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_archivo_version_anterior'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_archivo_version_anterior';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión inmediatamente anterior del mismo archivo. FK recursiva a archivos.archivo; encadena el historial de versiones. NULL en la primera versión.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_archivo_version_anterior';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'numero_version'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'numero_version';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de versión del archivo dentro de su cadena de versiones. Inicia en 1.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'numero_version';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'fecha_carga'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_carga';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora de la carga del archivo (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_carga';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'fecha_eliminacion_logica'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la baja lógica. NULL = registro vigente. Los registros no se borran físicamente; la eliminación es siempre lógica.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'motivo_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'motivo_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Motivo registrado al dar de baja lógica el archivo. NULL si el archivo está vigente.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'motivo_eliminacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_usuario_creador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_creador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario que creó el registro (auditoría). Referencia lógica a auth.usuario; sin FK física (la integridad de auditoría se delega a la aplicación, ver V0032).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_creador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_usuario_modificador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario de la última modificación del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'id_usuario_eliminador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario que efectuó la baja lógica del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'fecha_creacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de creación del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo' AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la última actualización del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO


-- =============================================================================
-- Tabla: archivos.archivo_vinculo
-- =============================================================================

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.tables t ON ep.major_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description' AND ep.minor_id = 0
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Asociación polimórfica entre un archivo y una entidad de negocio. Permite vincular un mismo archivo a cualquier entidad declarada en archivos.cat_entidad_vinculable (relación M:N). Patrón polimórfico: la referencia a la fila (id_entidad) no tiene FK física; su integridad se valida en la capa de aplicación (procedimiento validador) y con un detector de huérfanos.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_archivo_vinculo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_archivo_vinculo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo. Clave primaria autogenerada (IDENTITY). Antes ''id_vinculo'' (renombrado en V0039).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_archivo_vinculo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivo vinculado. FK a archivos.archivo.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_entidad_vinculable'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_entidad_vinculable';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad de negocio a la que se asocia el archivo (indica QUÉ tabla). FK a archivos.cat_entidad_vinculable. Junto con id_entidad resuelve la referencia polimórfica.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_entidad_vinculable';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_entidad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_entidad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la fila específica dentro de la tabla indicada por id_entidad_vinculable (indica CUÁL fila). Sin FK física, por diseño polimórfico; su existencia se valida en la aplicación.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_entidad';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'rol_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'rol_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol o propósito del archivo dentro de la entidad vinculada (p. ej. ''ADJUNTO'', ''FOTO_PERFIL''). Opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'rol_archivo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'fecha_vinculo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'fecha_vinculo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que se creó el vínculo (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'fecha_vinculo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_usuario_creador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_creador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario que creó el registro (auditoría). Referencia lógica a auth.usuario; sin FK física (la integridad de auditoría se delega a la aplicación, ver V0032).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_creador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_usuario_modificador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario de la última modificación del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'id_usuario_eliminador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario que efectuó la baja lógica del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'fecha_creacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de creación del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la última actualización del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'archivo_vinculo' AND c.name = N'fecha_eliminacion_logica'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la baja lógica. NULL = registro vigente. Los registros no se borran físicamente; la eliminación es siempre lógica.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO


-- =============================================================================
-- Tabla: archivos.cat_entidad_vinculable
-- =============================================================================

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.tables t ON ep.major_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description' AND ep.minor_id = 0
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de entidades de negocio a las que se puede asociar un archivo mediante el vínculo polimórfico (archivos.archivo_vinculo). Cada fila declara una tabla vinculable con su esquema, su nombre y su columna PK, que el procedimiento validador usa para comprobar la existencia de la fila referenciada. No tiene FK hacia los dominios: esa ausencia mantiene el desacople entre esquemas. Patrón de catálogo: 5 columnas de auditoría. Los id_entidad_vinculable son permanentes: una vez asignados no se reutilizan ni se reasignan, ni siquiera si la entidad se elimina o inhabilita, para no invalidar los vínculos existentes en archivo_vinculo (por eso el seed puede dejar huecos en la numeración).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'id_entidad_vinculable'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'id_entidad_vinculable';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la entidad vinculable. Clave primaria (IDENTITY). Es el valor referenciado por archivos.archivo_vinculo.id_entidad_vinculable. Los ids se siembran de forma explícita y son permanentes: estables entre ambientes (dev/QA/prod) y nunca se reutilizan ni reasignan una vez usados, ni siquiera si la entidad se elimina o inhabilita.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'id_entidad_vinculable';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'esquema'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'esquema';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del esquema de la tabla vinculable (p. ej. ''denuncias''). Parte de la identificación de la entidad.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'esquema';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'entidad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'entidad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la tabla vinculable a la que se puede asociar un archivo (p. ej. ''denuncia''). Junto con esquema forma la clave única.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'entidad';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'columna_pk'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'columna_pk';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la columna de clave primaria de la tabla vinculable (p. ej. ''id_denuncia''). La usa el procedimiento validador para comprobar la existencia de la fila referenciada.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'columna_pk';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Habilita (1) o inhabilita (0) la entidad como destino de vínculos, sin eliminar la fila. Default 1.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'id_usuario_modificador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario de la última modificación del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'id_usuario_modificador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'id_usuario_eliminador'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Usuario que efectuó la baja lógica del registro (auditoría). Referencia lógica a auth.usuario, sin FK física.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'id_usuario_eliminador';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'fecha_creacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de creación del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la última actualización del registro (UTC).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos' AND t.name = N'cat_entidad_vinculable' AND c.name = N'fecha_eliminacion_logica'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca temporal de la baja lógica. NULL = registro vigente. Los registros no se borran físicamente; la eliminación es siempre lógica.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_entidad_vinculable',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion_logica';
GO

