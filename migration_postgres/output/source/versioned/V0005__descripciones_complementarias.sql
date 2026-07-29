-- ============================================================================
-- V0005 -- Descripciones complementarias del modelo SIP
-- ============================================================================
-- Este script agrega 279 descripciones extendidas (extended properties) a
-- columnas que quedaron sin documentar en V0001, V0002 y V0003.
--
-- Composicion:
--   - 182 descripciones reales (PKs, FKs, auditoria, flags, fechas claras,
--     contexto de doc PO01.02 Gestion de Diligencias, doc CAPJ Catalogo
--     de Delitos diciembre 2025)
--   - 69 descripciones tautologicas (campos estandar de catalogos cat_*/
--     tipo_*: codigo, nombre, descripcion, orden) -- marcadas para revision
--     en Pendientes_Diseno_Modelo_Datos_SIP.xlsx hoja 7
--   - 28 descripciones inferidas de conocimiento general (estandares ISO,
--     leyes chilenas: 20.000, 20.066, 21.325, Codigo Penal, DGMN) --
--     marcadas para validacion con PDI en hoja 8 del Excel de pendientes
--
-- Idempotente: cada bloque verifica con IF EXISTS antes de insertar.
-- ============================================================================

SET NOCOUNT ON;
GO


-- ============================================================================
-- Esquema: analitica
-- ============================================================================

-- Tabla: analitica.aplicacion_reporte (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'analitica'
        AND t.name = N'aplicacion_reporte'
        AND c.name = N'id_aplicacion_reporte'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'analitica',
        @level1type = N'TABLE',  @level1name = N'aplicacion_reporte',
        @level2type = N'COLUMN', @level2name = N'id_aplicacion_reporte';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla analitica.aplicacion_reporte. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'aplicacion_reporte',
    @level2type = N'COLUMN', @level2name = N'id_aplicacion_reporte';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'analitica'
        AND t.name = N'aplicacion_reporte'
        AND c.name = N'id_reporte'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'analitica',
        @level1type = N'TABLE',  @level1name = N'aplicacion_reporte',
        @level2type = N'COLUMN', @level2name = N'id_reporte';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a analitica.reporte_analitico. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'aplicacion_reporte',
    @level2type = N'COLUMN', @level2name = N'id_reporte';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'analitica'
        AND t.name = N'aplicacion_reporte'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'analitica',
        @level1type = N'TABLE',  @level1name = N'aplicacion_reporte',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'aplicacion_reporte',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO


-- ============================================================================
-- Esquema: archivos
-- ============================================================================

-- Tabla: archivos.cat_tipo_archivo (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos'
        AND t.name = N'cat_tipo_archivo'
        AND c.name = N'es_multimedia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'es_multimedia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este tipo de archivo es multimedia (audio, video, imagen). 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'es_multimedia';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'archivos'
        AND t.name = N'cat_tipo_archivo'
        AND c.name = N'tamanio_max_mb'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'archivos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
        @level2type = N'COLUMN', @level2name = N'tamanio_max_mb';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tamaño máximo permitido en megabytes para archivos de este tipo. Valor opcional — si es nulo, no se aplica restricción específica del tipo (queda sujeto al límite global de la plataforma).',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'tamanio_max_mb';
GO


-- ============================================================================
-- Esquema: casos
-- ============================================================================

-- Tabla: casos.caso (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'caso'
        AND c.name = N'id_nivel_seguridad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'caso',
        @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a casos.cat_nivel_seguridad. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'caso'
        AND c.name = N'id_grupo_operativo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'caso',
        @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a casos.cat_grupo_operativo. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'caso'
        AND c.name = N'fecha_endoso'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'caso',
        @level2type = N'COLUMN', @level2name = N'fecha_endoso';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que la Jefatura realizó el endoso (asignación formal del caso/diligencia a un investigador). Marca el inicio del cronómetro neto de gestión del investigador, descontando tiempos burocráticos previos. Ver doc PO01.02.02 Gestionar Endoso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_endoso';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'caso'
        AND c.name = N'fecha_plazo_gestion_interna'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'caso',
        @level2type = N'COLUMN', @level2name = N'fecha_plazo_gestion_interna';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha límite de gestión interna del investigador, calculada como el plazo legal definido por Fiscalía menos los tiempos de permanencia en bandejas administrativas previas. Ver doc PO01.02.01.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_plazo_gestion_interna';
GO


-- Tabla: casos.cat_complejidad (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_complejidad'
        AND c.name = N'id_complejidad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_complejidad',
        @level2type = N'COLUMN', @level2name = N'id_complejidad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_complejidad',
    @level2type = N'COLUMN', @level2name = N'id_complejidad';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_complejidad'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_complejidad',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de niveles de complejidad investigativa. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_complejidad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_complejidad'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_complejidad',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de niveles de complejidad investigativa. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_complejidad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: casos.cat_estado_caso (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_estado_caso'
        AND c.name = N'id_estado_caso'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
        @level2type = N'COLUMN', @level2name = N'id_estado_caso';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
    @level2type = N'COLUMN', @level2name = N'id_estado_caso';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_estado_caso'
        AND c.name = N'es_terminal'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
        @level2type = N'COLUMN', @level2name = N'es_terminal';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este estado del caso es terminal (caso cerrado). 1 = terminal, 0 = no terminal.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
    @level2type = N'COLUMN', @level2name = N'es_terminal';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_estado_caso'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de estados del caso. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_estado_caso'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de estados del caso. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_estado_caso',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: casos.cat_grupo_operativo (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_grupo_operativo'
        AND c.name = N'id_grupo_operativo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
        @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
    @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_grupo_operativo'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_grupo_operativo'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de grupos operativos para clasificación estadística. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_grupo_operativo'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de grupos operativos para clasificación estadística. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_grupo_operativo'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida en el catálogo de grupos operativos para clasificación estadística. Texto opcional con información adicional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO


-- Tabla: casos.cat_nivel_seguridad (7 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'id_nivel_seguridad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de niveles de seguridad del caso. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de niveles de seguridad del caso. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida en el catálogo de niveles de seguridad del caso. Texto opcional con información adicional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'orden'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'orden';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Orden de presentación en interfaces (listas, dropdowns). Permite controlar la secuencia visible sin depender del id.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'orden';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_nivel_seguridad'
        AND c.name = N'bloquea_busqueda_externa'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
        @level2type = N'COLUMN', @level2name = N'bloquea_busqueda_externa';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este nivel de seguridad bloquea las consultas desde sistemas externos al SIP (1 = bloquea, 0 = permite). Niveles secretos típicamente bloquean.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad',
    @level2type = N'COLUMN', @level2name = N'bloquea_busqueda_externa';
GO


-- Tabla: casos.cat_origen_caso (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_origen_caso'
        AND c.name = N'id_origen_caso'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_origen_caso',
        @level2type = N'COLUMN', @level2name = N'id_origen_caso';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_origen_caso',
    @level2type = N'COLUMN', @level2name = N'id_origen_caso';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_origen_caso'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_origen_caso',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de orígenes del caso (denuncia, parte policial, derivación, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_origen_caso',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_origen_caso'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_origen_caso',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de orígenes del caso (denuncia, parte policial, derivación, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_origen_caso',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: casos.cat_prioridad (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_prioridad'
        AND c.name = N'id_prioridad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_prioridad',
        @level2type = N'COLUMN', @level2name = N'id_prioridad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_prioridad',
    @level2type = N'COLUMN', @level2name = N'id_prioridad';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_prioridad'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_prioridad',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de niveles de prioridad del caso. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_prioridad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_prioridad'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_prioridad',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de niveles de prioridad del caso. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_prioridad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_prioridad'
        AND c.name = N'orden'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_prioridad',
        @level2type = N'COLUMN', @level2name = N'orden';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Orden de presentación en interfaces (listas, dropdowns). Permite controlar la secuencia visible sin depender del id.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_prioridad',
    @level2type = N'COLUMN', @level2name = N'orden';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_prioridad'
        AND c.name = N'color'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_prioridad',
        @level2type = N'COLUMN', @level2name = N'color';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de color hexadecimal (#RRGGBB) asociado al nivel de prioridad del caso. Permite que las interfaces de usuario (web, móvil, dashboards) representen visualmente la prioridad de manera consistente en toda la plataforma. El color forma parte del dato institucional del catálogo: PDI puede ajustarlo sin requerir cambios en las aplicaciones cliente. Campo opcional — si está nulo, las aplicaciones pueden aplicar su tema por defecto.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_prioridad',
    @level2type = N'COLUMN', @level2name = N'color';
GO


-- Tabla: casos.cat_programa_seguridad (6 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_programa_seguridad'
        AND c.name = N'id_programa_seguridad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
    @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_programa_seguridad'
        AND c.name = N'id_comuna'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'id_comuna';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a ubicacion.comuna. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
    @level2type = N'COLUMN', @level2name = N'id_comuna';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_programa_seguridad'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_programa_seguridad'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_programa_seguridad'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de programas gubernamentales de seguridad por comuna. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_programa_seguridad'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida en el catálogo de programas gubernamentales de seguridad por comuna. Texto opcional con información adicional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO


-- Tabla: casos.cat_tipo_relato (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_tipo_relato'
        AND c.name = N'id_tipo_relato'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
        @level2type = N'COLUMN', @level2name = N'id_tipo_relato';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relato';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_tipo_relato'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de relato asociado a una denuncia. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_tipo_relato'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de relato asociado a una denuncia. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relato',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: casos.cat_tipo_rol_persona (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_tipo_rol_persona'
        AND c.name = N'id_tipo_rol_persona'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
        @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_tipo_rol_persona'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de roles de persona en caso, denuncia o hecho (víctima, imputado, testigo, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'casos'
        AND t.name = N'cat_tipo_rol_persona'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'casos',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de roles de persona en caso, denuncia o hecho (víctima, imputado, testigo, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- ============================================================================
-- Esquema: denuncias
-- ============================================================================

-- Tabla: denuncias.denuncia (2 columnas)

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'denuncias'
        AND t.name = N'denuncia'
        AND c.name = N'indicador_vif'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE',  @level1name = N'denuncia',
        @level2type = N'COLUMN', @level2name = N'indicador_vif';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la denuncia corresponde a un caso de Violencia Intrafamiliar (VIF) según Ley 20.066. 1 = es VIF, 0 = no es VIF. La calificación VIF se determina por la pertenencia del delito a las familias VIF definidas en el catálogo oficial de delitos de Fiscalía (Sección II del catálogo CAPJ). Activa flujos especiales de tratamiento, derivación y cautelares.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'indicador_vif';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'denuncias'
        AND t.name = N'denuncia'
        AND c.name = N'observaciones'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'denuncias',
        @level1type = N'TABLE',  @level1name = N'denuncia',
        @level2type = N'COLUMN', @level2name = N'observaciones';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Texto libre con observaciones adicionales del funcionario sobre la denuncia. Campo opcional, complementa los relatos estructurados.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO


-- ============================================================================
-- Esquema: diligencias
-- ============================================================================

-- Tabla: diligencias.actividad_investigativa (10 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'id_actividad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'id_actividad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'id_actividad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'id_diligencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a diligencias.diligencia. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'id_funcionario'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'es_resultado_negativo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'es_resultado_negativo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la actividad investigativa arrojó resultado negativo (debe registrarse igual para trazabilidad). 1 = negativo, 0 = positivo o pendiente.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'es_resultado_negativo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'fecha_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica del registro (soft-delete). NULL si el registro está activo.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'fecha_actividad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'fecha_actividad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se ejecutó la actividad investigativa registrada en la bitácora del caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'fecha_actividad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'tipo_actividad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'tipo_actividad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de actividad investigativa registrada en la bitácora. El doc PO01.02.03.01 distingue tres rutas: Judicial (órdenes de arresto/aprehensión/detención), Especializada (apoyo de LACRIM/ERTA/JENAOES) y Autónoma (vigilancia, interceptación, seguimiento, etc.).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'tipo_actividad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción detallada de la actividad investigativa realizada por el investigador. Texto libre que documenta la acción ejecutada en terreno o en oficina.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'actividad_investigativa'
        AND c.name = N'resultado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
        @level2type = N'COLUMN', @level2name = N'resultado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resultado obtenido de la actividad investigativa. Puede ser positivo, negativo o pendiente. Si es negativo, debe marcarse es_resultado_negativo = 1 y registrarse igual para trazabilidad.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa',
    @level2type = N'COLUMN', @level2name = N'resultado';
GO


-- Tabla: diligencias.cat_especialidad_pericial (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_especialidad_pericial'
        AND c.name = N'id_especialidad_pericial'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
        @level2type = N'COLUMN', @level2name = N'id_especialidad_pericial';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
    @level2type = N'COLUMN', @level2name = N'id_especialidad_pericial';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_especialidad_pericial'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_especialidad_pericial'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de especialidades periciales del LACRIM. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_especialidad_pericial'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de especialidades periciales del LACRIM. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_especialidad_pericial'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida en el catálogo de especialidades periciales del LACRIM. Texto opcional con información adicional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO


-- Tabla: diligencias.cat_estado_diligencia (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_estado_diligencia'
        AND c.name = N'id_estado_diligencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_estado_diligencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_estado_diligencia';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_estado_diligencia'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de estados de diligencia. Valor corto y estable que las aplicaciones y procesos de integración referencian de forma directa; no representa el identificador técnico del registro.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_estado_diligencia'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de estados de diligencia. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_estado_instruccion (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_estado_instruccion'
        AND c.name = N'id_estado_instruccion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion',
        @level2type = N'COLUMN', @level2name = N'id_estado_instruccion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion',
    @level2type = N'COLUMN', @level2name = N'id_estado_instruccion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_estado_instruccion'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de estados de instrucción fiscal. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_estado_instruccion'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de estados de instrucción fiscal. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_fuente_observacion_externa (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_fuente_observacion_externa'
        AND c.name = N'id_fuente_observacion_externa'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa',
        @level2type = N'COLUMN', @level2name = N'id_fuente_observacion_externa';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_fuente_observacion_externa';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_fuente_observacion_externa'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de fuentes de notificaciones externas (tribunal, fiscalía, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_fuente_observacion_externa'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de fuentes de notificaciones externas (tribunal, fiscalía, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_tipo_detencion (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_detencion'
        AND c.name = N'id_tipo_detencion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion',
        @level2type = N'COLUMN', @level2name = N'id_tipo_detencion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_detencion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_detencion'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de detención (flagrancia, orden judicial, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_detencion'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de detención (flagrancia, orden judicial, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_tipo_diligencia (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_diligencia'
        AND c.name = N'id_tipo_diligencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_tipo_diligencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_diligencia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_diligencia'
        AND c.name = N'es_primera_diligencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
        @level2type = N'COLUMN', @level2name = N'es_primera_diligencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este tipo corresponde a "primera diligencia" (plazo legal de 48 horas según Fiscalía). 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
    @level2type = N'COLUMN', @level2name = N'es_primera_diligencia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_diligencia'
        AND c.name = N'requiere_autorizacion_judicial'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
        @level2type = N'COLUMN', @level2name = N'requiere_autorizacion_judicial';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la ejecución de este tipo de diligencia requiere autorización judicial previa. 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
    @level2type = N'COLUMN', @level2name = N'requiere_autorizacion_judicial';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_diligencia'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de diligencia policial. Valor corto y estable que las aplicaciones y procesos de integración referencian de forma directa; no representa el identificador técnico del registro.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_diligencia'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de diligencia policial. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_tipo_informe (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_informe'
        AND c.name = N'id_tipo_informe'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_informe',
        @level2type = N'COLUMN', @level2name = N'id_tipo_informe';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_informe',
    @level2type = N'COLUMN', @level2name = N'id_tipo_informe';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_informe'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_informe',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de informe policial (primeras diligencias, final, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_informe',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_informe'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_informe',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de informe policial (primeras diligencias, final, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_informe',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_tipo_instruccion (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_instruccion'
        AND c.name = N'id_tipo_instruccion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion',
        @level2type = N'COLUMN', @level2name = N'id_tipo_instruccion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_instruccion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_instruccion'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de instrucción fiscal. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_instruccion'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de instrucción fiscal. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_tipo_notificacion_externa (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_notificacion_externa'
        AND c.name = N'id_tipo_notificacion_externa'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa',
        @level2type = N'COLUMN', @level2name = N'id_tipo_notificacion_externa';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_tipo_notificacion_externa';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_notificacion_externa'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de notificación externa recibida. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_notificacion_externa'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de notificación externa recibida. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.cat_tipo_peritaje (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_peritaje'
        AND c.name = N'id_tipo_peritaje'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje',
        @level2type = N'COLUMN', @level2name = N'id_tipo_peritaje';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje',
    @level2type = N'COLUMN', @level2name = N'id_tipo_peritaje';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_peritaje'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de peritaje (balístico, dactilar, bioquímico, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'cat_tipo_peritaje'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de peritaje (balístico, dactilar, bioquímico, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: diligencias.informe_policial (1 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'informe_policial'
        AND c.name = N'estado_informe'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'informe_policial',
        @level2type = N'COLUMN', @level2name = N'estado_informe';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del informe policial dentro del flujo de visación. Estados típicos según doc PO01.02: Firmado por funcionario → Visado por Jefatura → Notificada a Fiscalía → Finalizada. Si es rechazado, vuelve a "En Ejecución".',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'estado_informe';
GO


-- Tabla: diligencias.orden_arresto (8 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'id_orden_arresto'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'id_orden_arresto';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla diligencias.orden_arresto. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'id_orden_arresto';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'id_caso'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'id_caso';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a casos.caso. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'id_persona'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'id_persona';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'id_funcionario_registra'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'fecha_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica del registro (soft-delete). NULL si el registro está activo.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_arresto'
        AND c.name = N'fecha_emision'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_arresto',
        @level2type = N'COLUMN', @level2name = N'fecha_emision';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que el tribunal emitió la orden de arresto civil.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto',
    @level2type = N'COLUMN', @level2name = N'fecha_emision';
GO


-- Tabla: diligencias.orden_detencion (10 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'id_orden_detencion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'id_orden_detencion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla diligencias.orden_detencion. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'id_orden_detencion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'id_caso'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'id_caso';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a casos.caso. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'id_persona'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'id_persona';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'es_secreta'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'es_secreta';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la orden de detención está clasificada como secreta. 1 = secreta, 0 = pública.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'es_secreta';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'id_funcionario_registra'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'fecha_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica del registro (soft-delete). NULL si el registro está activo.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'fecha_emision'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'fecha_emision';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que el tribunal emitió la orden de detención.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_emision';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'orden_detencion'
        AND c.name = N'fecha_vencimiento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'orden_detencion',
        @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de vencimiento de la orden de detención. Plazo legal: 10 días desde la emisión (RN11/RN24, doc PO01.02).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
GO


-- Tabla: diligencias.peritaje (1 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'diligencias'
        AND t.name = N'peritaje'
        AND c.name = N'id_solicitud_concurrencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'diligencias',
        @level1type = N'TABLE',  @level1name = N'peritaje',
        @level2type = N'COLUMN', @level2name = N'id_solicitud_concurrencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a diligencias.solicitud_concurrencia_pericial. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_solicitud_concurrencia';
GO


-- ============================================================================
-- Esquema: encargos
-- ============================================================================

-- Tabla: encargos.encargo (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo'
        AND c.name = N'id_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo',
        @level2type = N'COLUMN', @level2name = N'id_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla encargos.encargo. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo',
    @level2type = N'COLUMN', @level2name = N'id_encargo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo'
        AND c.name = N'id_tipo_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo',
        @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.tipo_encargo. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';
GO


-- Tabla: encargos.encargo_denuncia (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_denuncia'
        AND c.name = N'id_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_denuncia',
    @level2type = N'COLUMN', @level2name = N'id_encargo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_denuncia'
        AND c.name = N'id_denuncia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a denuncias.denuncia. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_denuncia',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_denuncia'
        AND c.name = N'id_persona_buscada'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_denuncia',
    @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
GO


-- Tabla: encargos.encargo_orden_judicial (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_orden_judicial'
        AND c.name = N'id_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_orden_judicial',
        @level2type = N'COLUMN', @level2name = N'id_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_orden_judicial',
    @level2type = N'COLUMN', @level2name = N'id_encargo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_orden_judicial'
        AND c.name = N'id_orden_judicial'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_orden_judicial',
        @level2type = N'COLUMN', @level2name = N'id_orden_judicial';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.orden_judicial. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_orden_judicial',
    @level2type = N'COLUMN', @level2name = N'id_orden_judicial';
GO


-- Tabla: encargos.encargo_persona_diligencia (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_persona_diligencia'
        AND c.name = N'id_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_persona_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_persona_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_encargo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_persona_diligencia'
        AND c.name = N'id_diligencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_persona_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a diligencias.diligencia. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_persona_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'encargo_persona_diligencia'
        AND c.name = N'id_persona_buscada'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'encargo_persona_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'encargo_persona_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
GO


-- Tabla: encargos.orden_judicial (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'orden_judicial'
        AND c.name = N'id_orden_judicial'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'orden_judicial',
        @level2type = N'COLUMN', @level2name = N'id_orden_judicial';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla encargos.orden_judicial. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'orden_judicial',
    @level2type = N'COLUMN', @level2name = N'id_orden_judicial';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'orden_judicial'
        AND c.name = N'id_tipo_orden_judicial'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'orden_judicial',
        @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.tipo_orden_judicial. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'orden_judicial',
    @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'orden_judicial'
        AND c.name = N'id_persona_buscada'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'orden_judicial',
        @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'orden_judicial',
    @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'orden_judicial'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'orden_judicial',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'orden_judicial',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO


-- Tabla: encargos.tarea_encargo (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'tarea_encargo'
        AND c.name = N'id_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'tarea_encargo',
        @level2type = N'COLUMN', @level2name = N'id_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'tarea_encargo',
    @level2type = N'COLUMN', @level2name = N'id_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'tarea_encargo'
        AND c.name = N'id_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'tarea_encargo',
        @level2type = N'COLUMN', @level2name = N'id_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'tarea_encargo',
    @level2type = N'COLUMN', @level2name = N'id_encargo';
GO


-- Tabla: encargos.tipo_encargo (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'tipo_encargo'
        AND c.name = N'id_tipo_encargo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'tipo_encargo',
        @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla encargos.tipo_encargo. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'tipo_encargo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'tipo_encargo'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'tipo_encargo',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de encargo (persona, arma, vehículo, otro). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'tipo_encargo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: encargos.tipo_orden_judicial (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'tipo_orden_judicial'
        AND c.name = N'id_tipo_orden_judicial'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'tipo_orden_judicial',
        @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla encargos.tipo_orden_judicial. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'tipo_orden_judicial',
    @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'encargos'
        AND t.name = N'tipo_orden_judicial'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'encargos',
        @level1type = N'TABLE',  @level1name = N'tipo_orden_judicial',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de orden judicial provenientes del PJUD. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'encargos',
    @level1type = N'TABLE',  @level1name = N'tipo_orden_judicial',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- ============================================================================
-- Esquema: evidencias
-- ============================================================================

-- Tabla: evidencias.cat_catalogo_armas (10 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'id_catalogo_arma'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'familia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'familia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Familia general del arma (ej: arma corta, arma larga, arma blanca, contundente, etc.). Primer nivel de clasificación.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'familia';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'tipo_arma'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'tipo_arma';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo específico dentro de la familia (ej: pistola, revólver, escopeta, fusil, cuchillo). Segundo nivel de clasificación.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'tipo_arma';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'marca'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'marca';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca o fabricante del arma (ej: Glock, Beretta, Smith & Wesson, FAMAE).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'marca';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'modelo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'modelo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Modelo específico del arma según fabricante (ej: G17, 92FS, M&P9).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'modelo';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'calibre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'calibre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Calibre del arma usando notación estándar (ej: 9mm, .22LR, .38 Special, 12 ga, 7.62×39).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'calibre';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'pais_fabricante'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'pais_fabricante';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País donde se fabricó el arma. Usar nombre del país en español.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'pais_fabricante';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_catalogo_armas'
        AND c.name = N'dgmn_ref'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
        @level2type = N'COLUMN', @level2name = N'dgmn_ref';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia o código del arma en el catálogo de la Dirección General de Movilización Nacional (DGMN), entidad chilena que controla el registro de armas. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas',
    @level2type = N'COLUMN', @level2name = N'dgmn_ref';
GO


-- Tabla: evidencias.cat_clasificacion_arma (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_clasificacion_arma'
        AND c.name = N'id_clasificacion_arma'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
        @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_clasificacion_arma'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_clasificacion_arma'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de clasificaciones normativas de arma (convencional, hechiza, fogueo, fantasía). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_clasificacion_arma'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de clasificaciones normativas de arma (convencional, hechiza, fogueo, fantasía). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_clasificacion_arma'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida en el catálogo de clasificaciones normativas de arma (convencional, hechiza, fogueo, fantasía). Texto opcional con información adicional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO


-- Tabla: evidencias.cat_droga (7 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'id_droga'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'id_droga';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'id_droga';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de sustancias controladas (catálogo normativo). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'alias'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'alias';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombres alternativos o de calle de la sustancia (ej: "pasta base" para clorhidrato de cocaína base). Lista separada por comas para facilitar búsqueda. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'alias';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'unidad_medida'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'unidad_medida';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad de medida estándar para la sustancia (ej: gramos, dosis, papelillos, plantas). Determina cómo se cuantifica al incautar.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'unidad_medida';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_droga'
        AND c.name = N'categoria_legal'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_droga',
        @level2type = N'COLUMN', @level2name = N'categoria_legal';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Categoría legal de la sustancia según Ley 20.000 (ej: "Lista I", "Lista II", "Precursor químico"). Determina las consecuencias jurídicas asociadas.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga',
    @level2type = N'COLUMN', @level2name = N'categoria_legal';
GO


-- Tabla: evidencias.cat_estado_especie (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_estado_especie'
        AND c.name = N'id_estado_especie'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
        @level2type = N'COLUMN', @level2name = N'id_estado_especie';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
    @level2type = N'COLUMN', @level2name = N'id_estado_especie';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_estado_especie'
        AND c.name = N'es_salida_definitiva'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
        @level2type = N'COLUMN', @level2name = N'es_salida_definitiva';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este estado representa salida definitiva de la cadena de custodia (devolución, destrucción, etc.). 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
    @level2type = N'COLUMN', @level2name = N'es_salida_definitiva';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_estado_especie'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de estados de la especie en custodia. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_estado_especie'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de estados de la especie en custodia. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_especie',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: evidencias.cat_institucion (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_institucion'
        AND c.name = N'id_institucion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_institucion',
        @level2type = N'COLUMN', @level2name = N'id_institucion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_institucion',
    @level2type = N'COLUMN', @level2name = N'id_institucion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_institucion'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_institucion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de instituciones receptoras o emisoras en transferencias de evidencia. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_institucion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_institucion'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_institucion',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de instituciones receptoras o emisoras en transferencias de evidencia. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_institucion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: evidencias.cat_proposito_transferencia (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_proposito_transferencia'
        AND c.name = N'id_proposito'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia',
        @level2type = N'COLUMN', @level2name = N'id_proposito';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia',
    @level2type = N'COLUMN', @level2name = N'id_proposito';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_proposito_transferencia'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de propósitos de transferencia de evidencia. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_proposito_transferencia'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de propósitos de transferencia de evidencia. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: evidencias.cat_tipo_custodia (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_custodia'
        AND c.name = N'id_tipo_custodia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia',
        @level2type = N'COLUMN', @level2name = N'id_tipo_custodia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_custodia';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_custodia'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de custodia de evidencia. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_custodia'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de custodia de evidencia. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: evidencias.cat_tipo_extension_especie (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_extension_especie'
        AND c.name = N'id_tipo_extension_especie'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
        @level2type = N'COLUMN', @level2name = N'id_tipo_extension_especie';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
    @level2type = N'COLUMN', @level2name = N'id_tipo_extension_especie';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_extension_especie'
        AND c.name = N'requiere_extension'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
        @level2type = N'COLUMN', @level2name = N'requiere_extension';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este tipo de especie requiere completar formularios de extensión específicos. 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
    @level2type = N'COLUMN', @level2name = N'requiere_extension';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_extension_especie'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de tipos de extensión específica de especie. Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'cat_tipo_extension_especie'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de extensión específica de especie. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: evidencias.especie_arma (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'especie_arma'
        AND c.name = N'id_clasificacion_arma'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'especie_arma',
        @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a evidencias.cat_clasificacion_arma. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_arma',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'especie_arma'
        AND c.name = N'id_catalogo_arma'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'especie_arma',
        @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a evidencias.cat_catalogo_armas. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_arma',
    @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'especie_arma'
        AND c.name = N'dgmn_ref'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'especie_arma',
        @level2type = N'COLUMN', @level2name = N'dgmn_ref';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia DGMN del arma incautada en este caso específico. Vincula con el catálogo de la Dirección General de Movilización Nacional. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_arma',
    @level2type = N'COLUMN', @level2name = N'dgmn_ref';
GO


-- Tabla: evidencias.especie_droga (1 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'evidencias'
        AND t.name = N'especie_droga'
        AND c.name = N'id_droga'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'evidencias',
        @level1type = N'TABLE',  @level1name = N'especie_droga',
        @level2type = N'COLUMN', @level2name = N'id_droga';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a evidencias.cat_droga. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'id_droga';
GO


-- ============================================================================
-- Esquema: investigacion
-- ============================================================================

-- Tabla: investigacion.cat_circunstancia_modificatoria (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_circunstancia_modificatoria'
        AND c.name = N'id_circunstancia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
        @level2type = N'COLUMN', @level2name = N'id_circunstancia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
    @level2type = N'COLUMN', @level2name = N'id_circunstancia';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_circunstancia_modificatoria'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de circunstancias modificatorias de responsabilidad penal (agravantes, atenuantes). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_circunstancia_modificatoria'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de circunstancias modificatorias de responsabilidad penal (agravantes, atenuantes). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_circunstancia_modificatoria'
        AND c.name = N'tipo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
        @level2type = N'COLUMN', @level2name = N'tipo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación de la circunstancia: ATENUANTE (rebaja la pena, art. 11 CP) o AGRAVANTE (aumenta la pena, art. 12 CP).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
    @level2type = N'COLUMN', @level2name = N'tipo';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_circunstancia_modificatoria'
        AND c.name = N'articulo_cp'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
        @level2type = N'COLUMN', @level2name = N'articulo_cp';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Artículo del Código Penal chileno que define la circunstancia (ej: "Art. 11 N°1", "Art. 12 N°5").',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria',
    @level2type = N'COLUMN', @level2name = N'articulo_cp';
GO


-- Tabla: investigacion.cat_delito (7 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'fecha_inicio_vigencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_inicio_vigencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha desde la cual el código CAPJ del delito está vigente. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_inicio_vigencia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'fecha_fin_vigencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_fin_vigencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha hasta la cual el código CAPJ del delito estuvo vigente. NULL si sigue vigente.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_fin_vigencia';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial del delito según la Codificación Penal definida por la Comisión Interinstitucional liderada por la Corporación Administrativa del Poder Judicial (CAPJ). El nombre proviene del catálogo oficial de Fiscalía y se mantiene actualizado mediante cargas periódicas (ver Sección 11 del documento de diseño).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'cuerpo_legal'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'cuerpo_legal';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cuerpo legal donde se tipifica el delito (ej: "Código Penal", "Ley 20.000", "Ley 17.798", "Ley 18.290"). Permite trazar la fuente normativa.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'cuerpo_legal';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_delito'
        AND c.name = N'articulo_legal'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_delito',
        @level2type = N'COLUMN', @level2name = N'articulo_legal';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Artículo específico dentro del cuerpo legal que tipifica el delito (ej: "Art. 391 N°1", "Art. 4°", "Art. 196").',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'articulo_legal';
GO


-- Tabla: investigacion.cat_grado_ejecucion (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_ejecucion'
        AND c.name = N'id_grado_ejecucion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion',
        @level2type = N'COLUMN', @level2name = N'id_grado_ejecucion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion',
    @level2type = N'COLUMN', @level2name = N'id_grado_ejecucion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_ejecucion'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de grados de ejecución del delito (consumado, tentativa, frustrado). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_ejecucion'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de grados de ejecución del delito (consumado, tentativa, frustrado). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: investigacion.cat_grado_participacion (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_participacion'
        AND c.name = N'id_grado_participacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
        @level2type = N'COLUMN', @level2name = N'id_grado_participacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
    @level2type = N'COLUMN', @level2name = N'id_grado_participacion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_participacion'
        AND c.name = N'codigo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código identificador único en el catálogo de grados de participación criminal (autor, cómplice, encubridor). Valor corto y estable que las aplicaciones referencian de forma directa.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_participacion'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de grados de participación criminal (autor, cómplice, encubridor). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'cat_grado_participacion'
        AND c.name = N'articulo_cp'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
        @level2type = N'COLUMN', @level2name = N'articulo_cp';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Artículo del Código Penal chileno que define el grado de participación (ej: "Art. 14", "Art. 15", "Art. 16", "Art. 17").',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_participacion',
    @level2type = N'COLUMN', @level2name = N'articulo_cp';
GO


-- Tabla: investigacion.protocolo_delito (6 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'protocolo_delito'
        AND c.name = N'id_protocolo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'protocolo_delito',
        @level2type = N'COLUMN', @level2name = N'id_protocolo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito',
    @level2type = N'COLUMN', @level2name = N'id_protocolo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'protocolo_delito'
        AND c.name = N'id_clasificacion_delito'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'protocolo_delito',
        @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a investigacion.clasificacion_delito. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'protocolo_delito'
        AND c.name = N'activo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'protocolo_delito',
        @level2type = N'COLUMN', @level2name = N'activo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está activo en el sistema. 1 = activo, 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'protocolo_delito'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'protocolo_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'protocolo_delito'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'protocolo_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'investigacion'
        AND t.name = N'protocolo_delito'
        AND c.name = N'fecha_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'protocolo_delito',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica del registro (soft-delete). NULL si el registro está activo.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO


-- ============================================================================
-- Esquema: migracion
-- ============================================================================

-- Tabla: migracion.expulsion (12 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'id_expulsion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'id_expulsion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla migracion.expulsion. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'id_expulsion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'id_persona'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'id_persona';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'id_denuncia_mig'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'id_denuncia_mig';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a migracion.denuncia_administrativa_migratoria. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'id_denuncia_mig';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'id_funcionario_registra'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'fecha_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica del registro (soft-delete). NULL si el registro está activo.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'fecha_notificacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'fecha_notificacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se notificó formalmente la resolución de expulsión al afectado.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'fecha_notificacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'fecha_vencimiento_apelacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'fecha_vencimiento_apelacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha límite para que el afectado presente apelación contra la resolución de expulsión.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'fecha_vencimiento_apelacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'fecha_salida_fisica'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'fecha_salida_fisica';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se ejecutó efectivamente la salida física del país.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'fecha_salida_fisica';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'plazo_apelacion_dias'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'plazo_apelacion_dias';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Plazo en días corridos que tiene el afectado para presentar apelación contra la resolución de expulsión, contado desde la notificación. Determinado por la Ley 21.325 según el tipo de expulsión.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'plazo_apelacion_dias';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'expulsion'
        AND c.name = N'prohibicion_ingreso_anos'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'expulsion',
        @level2type = N'COLUMN', @level2name = N'prohibicion_ingreso_anos';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Años de prohibición de reingreso al país asociados a la expulsión. Según Ley 21.325: 10 años para expulsión judicial, 25 años para expulsión administrativa por delito grave.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion',
    @level2type = N'COLUMN', @level2name = N'prohibicion_ingreso_anos';
GO


-- Tabla: migracion.fiscalizacion_planificada (7 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'id_fiscalizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'id_fiscalizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'id_fiscalizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'id_unidad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'id_unidad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.unidad. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'id_funcionario_responsable'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'fecha_eliminacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica del registro (soft-delete). NULL si el registro está activo.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'migracion'
        AND t.name = N'fiscalizacion_planificada'
        AND c.name = N'fecha_planificacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'migracion',
        @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
        @level2type = N'COLUMN', @level2name = N'fecha_planificacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha planificada para la ejecución de la fiscalización migratoria.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada',
    @level2type = N'COLUMN', @level2name = N'fecha_planificacion';
GO


-- ============================================================================
-- Esquema: organizacion
-- ============================================================================

-- Tabla: organizacion.unidad (1 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'organizacion'
        AND t.name = N'unidad'
        AND c.name = N'es_lacrim'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'organizacion',
        @level1type = N'TABLE',  @level1name = N'unidad',
        @level2type = N'COLUMN', @level2name = N'es_lacrim';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la unidad pertenece a LACRIM (Laboratorio de Criminalística PDI). 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'es_lacrim';
GO


-- ============================================================================
-- Esquema: personas
-- ============================================================================

-- Tabla: personas.cat_nacionalidad (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'personas'
        AND t.name = N'cat_nacionalidad'
        AND c.name = N'id_nacionalidad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
        @level2type = N'COLUMN', @level2name = N'id_nacionalidad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a otra entidad del modelo (clave foránea).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
    @level2type = N'COLUMN', @level2name = N'id_nacionalidad';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'personas'
        AND t.name = N'cat_nacionalidad'
        AND c.name = N'codigo_iso_alpha_3'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
        @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código ISO 3166-1 alpha-3 del país de la nacionalidad (3 letras, ej: CHL, ARG, USA, ESP). Estándar internacional para identificación de países.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
    @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'personas'
        AND t.name = N'cat_nacionalidad'
        AND c.name = N'codigo_iso_alpha_2'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
        @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código ISO 3166-1 alpha-2 del país de la nacionalidad (2 letras, ej: CL, AR, US, ES). Usado en URLs, dominios y APIs.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
    @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';
GO


-- ============================================================================
-- Esquema: tareas
-- ============================================================================

-- Tabla: tareas.bandeja (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'bandeja'
        AND c.name = N'id_bandeja'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'bandeja',
        @level2type = N'COLUMN', @level2name = N'id_bandeja';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.bandeja. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'bandeja',
    @level2type = N'COLUMN', @level2name = N'id_bandeja';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'bandeja'
        AND c.name = N'id_unidad'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'bandeja',
        @level2type = N'COLUMN', @level2name = N'id_unidad';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a organizacion.unidad. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'bandeja',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'bandeja'
        AND c.name = N'id_funcionario'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'bandeja',
        @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'bandeja',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO


-- Tabla: tareas.documento (6 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'documento'
        AND c.name = N'id_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'documento',
        @level2type = N'COLUMN', @level2name = N'id_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.documento. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'documento',
    @level2type = N'COLUMN', @level2name = N'id_documento';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'documento'
        AND c.name = N'id_tipo_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'documento',
        @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tipo_documento. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'documento',
    @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'documento'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'documento',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'documento',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'documento'
        AND c.name = N'id_funcionario_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'documento',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'documento',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'documento'
        AND c.name = N'id_funcionario_anulacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'documento',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_anulacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'documento',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_anulacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'documento'
        AND c.name = N'fecha_anulacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'documento',
        @level2type = N'COLUMN', @level2name = N'fecha_anulacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se anuló el documento. NULL si el documento sigue vigente.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'documento',
    @level2type = N'COLUMN', @level2name = N'fecha_anulacion';
GO


-- Tabla: tareas.estado_tarea (7 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'id_estado_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.estado_tarea. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'id_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'id_tipo_estado_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tipo_estado_tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'id_funcionario_estado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_estado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_estado';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'id_bandeja'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_bandeja';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.bandeja. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_bandeja';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'id_bandeja_aprobacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_bandeja_aprobacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a tareas.bandeja. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_bandeja_aprobacion';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'estado_tarea'
        AND c.name = N'fecha_estado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'estado_tarea',
        @level2type = N'COLUMN', @level2name = N'fecha_estado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que la tarea entró en el estado registrado. Permite reconstruir la línea de tiempo de la tarea.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea',
    @level2type = N'COLUMN', @level2name = N'fecha_estado';
GO


-- Tabla: tareas.tarea (4 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea'
        AND c.name = N'id_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea',
        @level2type = N'COLUMN', @level2name = N'id_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.tarea. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea',
    @level2type = N'COLUMN', @level2name = N'id_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea'
        AND c.name = N'id_tipo_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea',
        @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tipo_tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea',
    @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea'
        AND c.name = N'id_estado_tarea_actual'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea',
        @level2type = N'COLUMN', @level2name = N'id_estado_tarea_actual';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a tareas.estado_tarea. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea',
    @level2type = N'COLUMN', @level2name = N'id_estado_tarea_actual';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea'
        AND c.name = N'id_tarea_dependiente'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea',
        @level2type = N'COLUMN', @level2name = N'id_tarea_dependiente';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a tareas.tarea. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea',
    @level2type = N'COLUMN', @level2name = N'id_tarea_dependiente';
GO


-- Tabla: tareas.tarea_archivo_adjunto (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_archivo_adjunto'
        AND c.name = N'id_archivo'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_archivo_adjunto',
        @level2type = N'COLUMN', @level2name = N'id_archivo';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a archivos.archivo. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_archivo_adjunto',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_archivo_adjunto'
        AND c.name = N'id_estado_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_archivo_adjunto',
        @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.estado_tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_archivo_adjunto',
    @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
GO


-- Tabla: tareas.tarea_denuncia (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_denuncia'
        AND c.name = N'id_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_denuncia',
    @level2type = N'COLUMN', @level2name = N'id_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_denuncia'
        AND c.name = N'id_denuncia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_denuncia',
        @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a denuncias.denuncia. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_denuncia',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO


-- Tabla: tareas.tarea_diligencia (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_diligencia'
        AND c.name = N'id_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_diligencia'
        AND c.name = N'id_diligencia'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_diligencia',
        @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a diligencias.diligencia. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_diligencia',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO


-- Tabla: tareas.tarea_documento (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_documento'
        AND c.name = N'id_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_documento',
        @level2type = N'COLUMN', @level2name = N'id_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.documento. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_documento',
    @level2type = N'COLUMN', @level2name = N'id_documento';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tarea_documento'
        AND c.name = N'id_estado_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tarea_documento',
        @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.estado_tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_documento',
    @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
GO


-- Tabla: tareas.tipo_documento (3 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_documento'
        AND c.name = N'id_tipo_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_documento',
        @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.tipo_documento. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_documento',
    @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_documento'
        AND c.name = N'vigente'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_documento',
        @level2type = N'COLUMN', @level2name = N'vigente';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el registro está vigente. 1 = vigente, 0 = no vigente.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_documento',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_documento'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_documento',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos documentales (denuncia, OI, PD, IP, etc.). Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_documento',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: tareas.tipo_estado_tarea (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_estado_tarea'
        AND c.name = N'id_tipo_estado_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_estado_tarea',
        @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.tipo_estado_tarea. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_estado_tarea',
    @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_estado_tarea'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_estado_tarea',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de estados posibles de una tarea. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_estado_tarea',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO


-- Tabla: tareas.tipo_tarea (5 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea'
        AND c.name = N'id_tipo_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea',
        @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.tipo_tarea. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea',
    @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea'
        AND c.name = N'requiere_aprobacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea',
        @level2type = N'COLUMN', @level2name = N'requiere_aprobacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si las tareas de este tipo requieren aprobación jerárquica para finalizar. 1 = sí, 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea',
    @level2type = N'COLUMN', @level2name = N'requiere_aprobacion';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea'
        AND c.name = N'nombre'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea',
        @level2type = N'COLUMN', @level2name = N'nombre';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible en el catálogo de tipos de tarea según las acciones y asociaciones que ofrecen. Usado en interfaces y reportes.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- [descripcion tautologica (revisar en Excel hoja 7)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea'
        AND c.name = N'descripcion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida en el catálogo de tipos de tarea según las acciones y asociaciones que ofrecen. Texto opcional con información adicional.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea'
        AND c.name = N'permite_adjuntar_archivos'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea',
        @level2type = N'COLUMN', @level2name = N'permite_adjuntar_archivos';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si las tareas de este tipo permiten adjuntar archivos (1 = sí, 0 = no). Determina si la UI muestra el control de carga de archivos.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea',
    @level2type = N'COLUMN', @level2name = N'permite_adjuntar_archivos';
GO


-- Tabla: tareas.tipo_tarea_tipo_documento (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea_tipo_documento'
        AND c.name = N'id_tipo_tarea'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea_tipo_documento',
        @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tipo_tarea. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea_tipo_documento',
    @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'tipo_tarea_tipo_documento'
        AND c.name = N'id_tipo_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'tipo_tarea_tipo_documento',
        @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.tipo_documento. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea_tipo_documento',
    @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO


-- Tabla: tareas.version_documento (10 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'id_version_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'id_version_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en la tabla tareas.version_documento. Clave primaria autogenerada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'id_version_documento';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'id_documento'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'id_documento';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a tareas.documento. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'id_documento';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'id_funcionario_version'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_version';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_version';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'id_archivo_por_visar'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'id_archivo_por_visar';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a archivos.archivo. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'id_archivo_por_visar';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'id_funcionario_visado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'id_funcionario_visado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_visado';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'id_archivo_firmado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'id_archivo_firmado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia opcional a archivos.archivo. Puede ser nulo si la asociación no aplica al registro.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'id_archivo_firmado';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'fecha_version'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'fecha_version';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación de esta versión del documento.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'fecha_version';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'fecha_visado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'fecha_visado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC del visado jerárquico de la versión del documento por parte de Jefatura (control de calidad sobre el informe policial). NO es firma electrónica. Ver doc PO01.02.04 Visar Informe Policial.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'fecha_visado';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'fecha_firmado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'fecha_firmado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se aplicó firma electrónica avanzada (FEA) al documento vía API OTP. NULL si la versión aún no se ha firmado.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'fecha_firmado';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'tareas'
        AND t.name = N'version_documento'
        AND c.name = N'comentario_visado'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'tareas',
        @level1type = N'TABLE',  @level1name = N'version_documento',
        @level2type = N'COLUMN', @level2name = N'comentario_visado';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Comentario técnico de la Jefatura al visar la versión del documento. Obligatorio cuando la Jefatura rechaza el informe (la diligencia vuelve a "En Ejecución" para que el investigador subsane). Ver doc PO01.02.04.',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento',
    @level2type = N'COLUMN', @level2name = N'comentario_visado';
GO


-- ============================================================================
-- Esquema: ubicacion
-- ============================================================================

-- Tabla: ubicacion.lugar (2 columnas)

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'ubicacion'
        AND t.name = N'lugar'
        AND c.name = N'fecha_registro'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'ubicacion',
        @level1type = N'TABLE',  @level1name = N'lugar',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro en el sistema. Default: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

-- [descripcion real]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'ubicacion'
        AND t.name = N'lugar'
        AND c.name = N'fecha_actualizacion'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'ubicacion',
        @level1type = N'TABLE',  @level1name = N'lugar',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización del registro. Se actualiza en cada modificación.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO


-- Tabla: ubicacion.pais (2 columnas)

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'ubicacion'
        AND t.name = N'pais'
        AND c.name = N'codigo_iso_alpha_3'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'ubicacion',
        @level1type = N'TABLE',  @level1name = N'pais',
        @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código ISO 3166-1 alpha-3 del país (3 letras, ej: CHL, ARG, USA, ESP). Estándar internacional para identificación de países.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'pais',
    @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';
GO

-- [descripcion inferida (validar con PDI - Excel hoja 8)]
IF EXISTS (
    SELECT 1 FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.name = N'MS_Description'
        AND s.name = N'ubicacion'
        AND t.name = N'pais'
        AND c.name = N'codigo_iso_alpha_2'
)
    EXEC sys.sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA', @level0name = N'ubicacion',
        @level1type = N'TABLE',  @level1name = N'pais',
        @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';
GO
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código ISO 3166-1 alpha-2 del país (2 letras, ej: CL, AR, US, ES). Usado en URLs, dominios y APIs.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'pais',
    @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';
GO


-- ============================================================================
-- Fin V0005__descripciones_complementarias.sql
-- 279 descripciones agregadas.
-- Cobertura post-V0005: 1.533 / 1.558 columnas (98.4%)
-- Pendientes reales: 25 columnas que requieren documentos PDI especificos
-- ============================================================================