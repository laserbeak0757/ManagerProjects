-- ============================================================================
-- V0005 -- Descripciones complementarias del modelo SIP
-- ============================================================================
-- Este script agrega 279 descripciones extendidas (extended properties) a
-- columnas que quedaron sin documentar en V0001, V0002 y V0003.
--
-- Composicion:
-- - 182 descripciones reales (PKs, FKs, auditoria, flags, fechas claras,
-- contexto de doc PO01.02 Gestion de Diligencias, doc CAPJ Catalogo
-- de Delitos diciembre 2025)
-- - 69 descripciones tautologicas (campos estandar de catalogos cat_*/
-- tipo_*: codigo, nombre, descripcion, orden) -- marcadas para revision
-- en Pendientes_Diseno_Modelo_Datos_SIP.xlsx hoja 7
-- - 28 descripciones inferidas de conocimiento general (estandares ISO,
-- leyes chilenas: 20.000, 20.066, 21.325, Codigo Penal, DGMN) --
-- marcadas para validacion con PDI en hoja 8 del Excel de pendientes
--
-- Idempotente: cada bloque verifica con IF EXISTS antes de insertar.
-- ============================================================================

SET NOCOUNT ON;


-- ============================================================================
-- Esquema: analitica
-- ============================================================================

-- Tabla: analitica.aplicacion_reporte (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'aplicacion_reporte',
 @level2type = N'COLUMN', @level2name = N'id_aplicacion_reporte';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla analitica.aplicacion_reporte. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'analitica',
 @level1type = N'TABLE', @level1name = N'aplicacion_reporte',
 @level2type = N'COLUMN', @level2name = N'id_aplicacion_reporte';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'aplicacion_reporte',
 @level2type = N'COLUMN', @level2name = N'id_reporte';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a analitica.reporte_analitico. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'analitica',
 @level1type = N'TABLE', @level1name = N'aplicacion_reporte',
 @level2type = N'COLUMN', @level2name = N'id_reporte';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'aplicacion_reporte',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'analitica',
 @level1type = N'TABLE', @level1name = N'aplicacion_reporte',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';


-- ============================================================================
-- Esquema: archivos
-- ============================================================================

-- Tabla: archivos.cat_tipo_archivo (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_archivo',
 @level2type = N'COLUMN', @level2name = N'es_multimedia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si este tipo de archivo es multimedia (audio, video, imagen). 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'archivos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_archivo',
 @level2type = N'COLUMN', @level2name = N'es_multimedia';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_archivo',
 @level2type = N'COLUMN', @level2name = N'tamanio_max_mb';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'TamaÃ±o mÃ¡ximo permitido en megabytes para archivos de este tipo. Valor opcional â€” si es nulo, no se aplica restricciÃ³n especÃ­fica del tipo (queda sujeto al lÃ­mite global de la plataforma).',
 @level0type = N'SCHEMA', @level0name = N'archivos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_archivo',
 @level2type = N'COLUMN', @level2name = N'tamanio_max_mb';


-- ============================================================================
-- Esquema: casos
-- ============================================================================

-- Tabla: casos.caso (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a casos.cat_nivel_seguridad. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a casos.cat_grupo_operativo. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'fecha_endoso';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC en que la Jefatura realizÃ³ el endoso (asignaciÃ³n formal del caso/diligencia a un investigador). Marca el inicio del cronÃ³metro neto de gestiÃ³n del investigador, descontando tiempos burocrÃ¡ticos previos. Ver doc PO01.02.02 Gestionar Endoso.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'fecha_endoso';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'fecha_plazo_gestion_interna';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha lÃ­mite de gestiÃ³n interna del investigador, calculada como el plazo legal definido por FiscalÃ­a menos los tiempos de permanencia en bandejas administrativas previas. Ver doc PO01.02.01.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'caso',
 @level2type = N'COLUMN', @level2name = N'fecha_plazo_gestion_interna';


-- Tabla: casos.cat_complejidad (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_complejidad',
 @level2type = N'COLUMN', @level2name = N'id_complejidad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_complejidad',
 @level2type = N'COLUMN', @level2name = N'id_complejidad';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_complejidad',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de niveles de complejidad investigativa. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_complejidad',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_complejidad',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de niveles de complejidad investigativa. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_complejidad',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: casos.cat_estado_caso (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'id_estado_caso';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'id_estado_caso';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'es_terminal';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si este estado del caso es terminal (caso cerrado). 1 = terminal, 0 = no terminal.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'es_terminal';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de estados del caso. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de estados del caso. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_estado_caso',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: casos.cat_grupo_operativo (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'id_grupo_operativo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de grupos operativos para clasificaciÃ³n estadÃ­stica. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de grupos operativos para clasificaciÃ³n estadÃ­stica. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de grupos operativos para clasificaciÃ³n estadÃ­stica. Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_grupo_operativo',
 @level2type = N'COLUMN', @level2name = N'descripcion';


-- Tabla: casos.cat_nivel_seguridad (7 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_nivel_seguridad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de niveles de seguridad del caso. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de niveles de seguridad del caso. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de niveles de seguridad del caso. Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'descripcion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'orden';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Orden de presentaciÃ³n en interfaces (listas, dropdowns). Permite controlar la secuencia visible sin depender del id.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'orden';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'bloquea_busqueda_externa';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si este nivel de seguridad bloquea las consultas desde sistemas externos al SIP (1 = bloquea, 0 = permite). Niveles secretos tÃ­picamente bloquean.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_nivel_seguridad',
 @level2type = N'COLUMN', @level2name = N'bloquea_busqueda_externa';


-- Tabla: casos.cat_origen_caso (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_origen_caso',
 @level2type = N'COLUMN', @level2name = N'id_origen_caso';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_origen_caso',
 @level2type = N'COLUMN', @level2name = N'id_origen_caso';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_origen_caso',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de orÃ­genes del caso (denuncia, parte policial, derivaciÃ³n, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_origen_caso',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_origen_caso',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de orÃ­genes del caso (denuncia, parte policial, derivaciÃ³n, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_origen_caso',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: casos.cat_prioridad (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'id_prioridad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'id_prioridad';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de niveles de prioridad del caso. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de niveles de prioridad del caso. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'orden';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Orden de presentaciÃ³n en interfaces (listas, dropdowns). Permite controlar la secuencia visible sin depender del id.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'orden';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'color';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo de color hexadecimal (#RRGGBB) asociado al nivel de prioridad del caso. Permite que las interfaces de usuario (web, mÃ³vil, dashboards) representen visualmente la prioridad de manera consistente en toda la plataforma. El color forma parte del dato institucional del catÃ¡logo: PDI puede ajustarlo sin requerir cambios en las aplicaciones cliente. Campo opcional â€” si estÃ¡ nulo, las aplicaciones pueden aplicar su tema por defecto.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_prioridad',
 @level2type = N'COLUMN', @level2name = N'color';


-- Tabla: casos.cat_programa_seguridad (6 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_comuna';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a ubicacion.comuna. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_comuna';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de programas gubernamentales de seguridad por comuna. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de programas gubernamentales de seguridad por comuna. Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'descripcion';


-- Tabla: casos.cat_tipo_relato (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'id_tipo_relato';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'id_tipo_relato';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de relato asociado a una denuncia. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de relato asociado a una denuncia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: casos.cat_tipo_rol_persona (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_rol_persona',
 @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_rol_persona',
 @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_rol_persona',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de roles de persona en caso, denuncia o hecho (vÃ­ctima, imputado, testigo, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_rol_persona',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_rol_persona',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de roles de persona en caso, denuncia o hecho (vÃ­ctima, imputado, testigo, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'casos',
 @level1type = N'TABLE', @level1name = N'cat_tipo_rol_persona',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- ============================================================================
-- Esquema: denuncias
-- ============================================================================

-- Tabla: denuncias.denuncia (2 columnas)

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'denuncia',
 @level2type = N'COLUMN', @level2name = N'indicador_vif';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si la denuncia corresponde a un caso de Violencia Intrafamiliar (VIF) segÃºn Ley 20.066. 1 = es VIF, 0 = no es VIF. La calificaciÃ³n VIF se determina por la pertenencia del delito a las familias VIF definidas en el catÃ¡logo oficial de delitos de FiscalÃ­a (SecciÃ³n II del catÃ¡logo CAPJ). Activa flujos especiales de tratamiento, derivaciÃ³n y cautelares.',
 @level0type = N'SCHEMA', @level0name = N'denuncias',
 @level1type = N'TABLE', @level1name = N'denuncia',
 @level2type = N'COLUMN', @level2name = N'indicador_vif';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'denuncia',
 @level2type = N'COLUMN', @level2name = N'observaciones';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Texto libre con observaciones adicionales del funcionario sobre la denuncia. Campo opcional, complementa los relatos estructurados.',
 @level0type = N'SCHEMA', @level0name = N'denuncias',
 @level1type = N'TABLE', @level1name = N'denuncia',
 @level2type = N'COLUMN', @level2name = N'observaciones';


-- ============================================================================
-- Esquema: diligencias
-- ============================================================================

-- Tabla: diligencias.actividad_investigativa (10 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'id_actividad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'id_actividad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'id_diligencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a diligencias.diligencia. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'id_diligencia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'id_funcionario';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'id_funcionario';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'es_resultado_negativo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si la actividad investigativa arrojÃ³ resultado negativo (debe registrarse igual para trazabilidad). 1 = negativo, 0 = positivo o pendiente.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'es_resultado_negativo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de eliminaciÃ³n lÃ³gica del registro (soft-delete). NULL si el registro estÃ¡ activo.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'fecha_actividad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC en que se ejecutÃ³ la actividad investigativa registrada en la bitÃ¡cora del caso.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'fecha_actividad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'tipo_actividad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Tipo de actividad investigativa registrada en la bitÃ¡cora. El doc PO01.02.03.01 distingue tres rutas: Judicial (Ã³rdenes de arresto/aprehensiÃ³n/detenciÃ³n), Especializada (apoyo de LACRIM/ERTA/JENAOES) y AutÃ³noma (vigilancia, interceptaciÃ³n, seguimiento, etc.).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'tipo_actividad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n detallada de la actividad investigativa realizada por el investigador. Texto libre que documenta la acciÃ³n ejecutada en terreno o en oficina.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'descripcion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'resultado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Resultado obtenido de la actividad investigativa. Puede ser positivo, negativo o pendiente. Si es negativo, debe marcarse es_resultado_negativo = 1 y registrarse igual para trazabilidad.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'actividad_investigativa',
 @level2type = N'COLUMN', @level2name = N'resultado';


-- Tabla: diligencias.cat_especialidad_pericial (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'id_especialidad_pericial';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'id_especialidad_pericial';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de especialidades periciales del LACRIM. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de especialidades periciales del LACRIM. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de especialidades periciales del LACRIM. Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_especialidad_pericial',
 @level2type = N'COLUMN', @level2name = N'descripcion';


-- Tabla: diligencias.cat_estado_diligencia (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_estado_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_estado_diligencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_estado_diligencia';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_diligencia',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de estados de diligencia. Valor corto y estable que las aplicaciones y procesos de integraciÃ³n referencian de forma directa; no representa el identificador tÃ©cnico del registro.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_diligencia',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_diligencia',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de estados de diligencia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_diligencia',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_estado_instruccion (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_estado_instruccion',
 @level2type = N'COLUMN', @level2name = N'id_estado_instruccion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_instruccion',
 @level2type = N'COLUMN', @level2name = N'id_estado_instruccion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_instruccion',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de estados de instrucciÃ³n fiscal. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_instruccion',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_instruccion',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de estados de instrucciÃ³n fiscal. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_instruccion',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_fuente_observacion_externa (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_fuente_observacion_externa',
 @level2type = N'COLUMN', @level2name = N'id_fuente_observacion_externa';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_fuente_observacion_externa',
 @level2type = N'COLUMN', @level2name = N'id_fuente_observacion_externa';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_fuente_observacion_externa',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de fuentes de notificaciones externas (tribunal, fiscalÃ­a, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_fuente_observacion_externa',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_fuente_observacion_externa',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de fuentes de notificaciones externas (tribunal, fiscalÃ­a, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_fuente_observacion_externa',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_tipo_detencion (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_detencion',
 @level2type = N'COLUMN', @level2name = N'id_tipo_detencion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_detencion',
 @level2type = N'COLUMN', @level2name = N'id_tipo_detencion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_detencion',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de detenciÃ³n (flagrancia, orden judicial, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_detencion',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_detencion',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de detenciÃ³n (flagrancia, orden judicial, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_detencion',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_tipo_diligencia (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_tipo_diligencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_tipo_diligencia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'es_primera_diligencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si este tipo corresponde a "primera diligencia" (plazo legal de 48 horas segÃºn FiscalÃ­a). 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'es_primera_diligencia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'requiere_autorizacion_judicial';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si la ejecuciÃ³n de este tipo de diligencia requiere autorizaciÃ³n judicial previa. 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'requiere_autorizacion_judicial';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de diligencia policial. Valor corto y estable que las aplicaciones y procesos de integraciÃ³n referencian de forma directa; no representa el identificador tÃ©cnico del registro.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de diligencia policial. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_diligencia',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_tipo_informe (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_informe',
 @level2type = N'COLUMN', @level2name = N'id_tipo_informe';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_informe',
 @level2type = N'COLUMN', @level2name = N'id_tipo_informe';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_informe',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de informe policial (primeras diligencias, final, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_informe',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_informe',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de informe policial (primeras diligencias, final, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_informe',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_tipo_instruccion (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_instruccion',
 @level2type = N'COLUMN', @level2name = N'id_tipo_instruccion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_instruccion',
 @level2type = N'COLUMN', @level2name = N'id_tipo_instruccion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_instruccion',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de instrucciÃ³n fiscal. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_instruccion',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_instruccion',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de instrucciÃ³n fiscal. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_instruccion',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_tipo_notificacion_externa (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_notificacion_externa',
 @level2type = N'COLUMN', @level2name = N'id_tipo_notificacion_externa';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_notificacion_externa',
 @level2type = N'COLUMN', @level2name = N'id_tipo_notificacion_externa';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_notificacion_externa',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de notificaciÃ³n externa recibida. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_notificacion_externa',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_notificacion_externa',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de notificaciÃ³n externa recibida. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_notificacion_externa',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.cat_tipo_peritaje (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_peritaje',
 @level2type = N'COLUMN', @level2name = N'id_tipo_peritaje';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_peritaje',
 @level2type = N'COLUMN', @level2name = N'id_tipo_peritaje';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_peritaje',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de peritaje (balÃ­stico, dactilar, bioquÃ­mico, etc.). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_peritaje',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_peritaje',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de peritaje (balÃ­stico, dactilar, bioquÃ­mico, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_peritaje',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: diligencias.informe_policial (1 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'informe_policial',
 @level2type = N'COLUMN', @level2name = N'estado_informe';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Estado del informe policial dentro del flujo de visaciÃ³n. Estados tÃ­picos segÃºn doc PO01.02: Firmado por funcionario â†’ Visado por Jefatura â†’ Notificada a FiscalÃ­a â†’ Finalizada. Si es rechazado, vuelve a "En EjecuciÃ³n".',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'informe_policial',
 @level2type = N'COLUMN', @level2name = N'estado_informe';


-- Tabla: diligencias.orden_arresto (8 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_orden_arresto';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla diligencias.orden_arresto. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_orden_arresto';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_caso';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a casos.caso. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_caso';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_persona';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_persona';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de eliminaciÃ³n lÃ³gica del registro (soft-delete). NULL si el registro estÃ¡ activo.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_emision';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha en que el tribunal emitiÃ³ la orden de arresto civil.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_arresto',
 @level2type = N'COLUMN', @level2name = N'fecha_emision';


-- Tabla: diligencias.orden_detencion (10 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_orden_detencion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla diligencias.orden_detencion. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_orden_detencion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_caso';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a casos.caso. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_caso';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_persona';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_persona';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'es_secreta';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si la orden de detenciÃ³n estÃ¡ clasificada como secreta. 1 = secreta, 0 = pÃºblica.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'es_secreta';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de eliminaciÃ³n lÃ³gica del registro (soft-delete). NULL si el registro estÃ¡ activo.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_emision';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha en que el tribunal emitiÃ³ la orden de detenciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_emision';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha de vencimiento de la orden de detenciÃ³n. Plazo legal: 10 dÃ­as desde la emisiÃ³n (RN11/RN24, doc PO01.02).',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'orden_detencion',
 @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';


-- Tabla: diligencias.peritaje (1 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'peritaje',
 @level2type = N'COLUMN', @level2name = N'id_solicitud_concurrencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a diligencias.solicitud_concurrencia_pericial. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'diligencias',
 @level1type = N'TABLE', @level1name = N'peritaje',
 @level2type = N'COLUMN', @level2name = N'id_solicitud_concurrencia';


-- ============================================================================
-- Esquema: encargos
-- ============================================================================

-- Tabla: encargos.encargo (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo',
 @level2type = N'COLUMN', @level2name = N'id_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla encargos.encargo. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo',
 @level2type = N'COLUMN', @level2name = N'id_encargo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo',
 @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.tipo_encargo. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo',
 @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';


-- Tabla: encargos.encargo_denuncia (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_encargo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_denuncia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a denuncias.denuncia. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_denuncia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_persona_buscada';


-- Tabla: encargos.encargo_orden_judicial (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_encargo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_orden_judicial';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.orden_judicial. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_orden_judicial';


-- Tabla: encargos.encargo_persona_diligencia (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_persona_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_persona_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_encargo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_persona_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_diligencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a diligencias.diligencia. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_persona_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_diligencia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'encargo_persona_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'encargo_persona_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_persona_buscada';


-- Tabla: encargos.orden_judicial (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_orden_judicial';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla encargos.orden_judicial. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_orden_judicial';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.tipo_orden_judicial. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_persona_buscada';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_persona_buscada';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'orden_judicial',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';


-- Tabla: encargos.tarea_encargo (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_encargo',
 @level2type = N'COLUMN', @level2name = N'id_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'tarea_encargo',
 @level2type = N'COLUMN', @level2name = N'id_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_encargo',
 @level2type = N'COLUMN', @level2name = N'id_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a encargos.encargo. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'tarea_encargo',
 @level2type = N'COLUMN', @level2name = N'id_encargo';


-- Tabla: encargos.tipo_encargo (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_encargo',
 @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla encargos.tipo_encargo. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'tipo_encargo',
 @level2type = N'COLUMN', @level2name = N'id_tipo_encargo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'tipo_encargo',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de encargo (persona, arma, vehÃ­culo, otro). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'tipo_encargo',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: encargos.tipo_orden_judicial (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla encargos.tipo_orden_judicial. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'tipo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'id_tipo_orden_judicial';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'tipo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de orden judicial provenientes del PJUD. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'encargos',
 @level1type = N'TABLE', @level1name = N'tipo_orden_judicial',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- ============================================================================
-- Esquema: evidencias
-- ============================================================================

-- Tabla: evidencias.cat_catalogo_armas (10 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'familia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Familia general del arma (ej: arma corta, arma larga, arma blanca, contundente, etc.). Primer nivel de clasificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'familia';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'tipo_arma';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Tipo especÃ­fico dentro de la familia (ej: pistola, revÃ³lver, escopeta, fusil, cuchillo). Segundo nivel de clasificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'tipo_arma';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'marca';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Marca o fabricante del arma (ej: Glock, Beretta, Smith & Wesson, FAMAE).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'marca';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'modelo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Modelo especÃ­fico del arma segÃºn fabricante (ej: G17, 92FS, M&P9).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'modelo';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'calibre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Calibre del arma usando notaciÃ³n estÃ¡ndar (ej: 9mm, .22LR, .38 Special, 12 ga, 7.62Ã—39).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'calibre';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'pais_fabricante';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'PaÃ­s donde se fabricÃ³ el arma. Usar nombre del paÃ­s en espaÃ±ol.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'pais_fabricante';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'dgmn_ref';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia o cÃ³digo del arma en el catÃ¡logo de la DirecciÃ³n General de MovilizaciÃ³n Nacional (DGMN), entidad chilena que controla el registro de armas. Campo opcional.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_catalogo_armas',
 @level2type = N'COLUMN', @level2name = N'dgmn_ref';


-- Tabla: evidencias.cat_clasificacion_arma (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de clasificaciones normativas de arma (convencional, hechiza, fogueo, fantasÃ­a). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de clasificaciones normativas de arma (convencional, hechiza, fogueo, fantasÃ­a). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de clasificaciones normativas de arma (convencional, hechiza, fogueo, fantasÃ­a). Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_clasificacion_arma',
 @level2type = N'COLUMN', @level2name = N'descripcion';


-- Tabla: evidencias.cat_droga (7 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'id_droga';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'id_droga';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de sustancias controladas (catÃ¡logo normativo). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'alias';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombres alternativos o de calle de la sustancia (ej: "pasta base" para clorhidrato de cocaÃ­na base). Lista separada por comas para facilitar bÃºsqueda. Campo opcional.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'alias';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'unidad_medida';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Unidad de medida estÃ¡ndar para la sustancia (ej: gramos, dosis, papelillos, plantas). Determina cÃ³mo se cuantifica al incautar.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'unidad_medida';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'categoria_legal';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CategorÃ­a legal de la sustancia segÃºn Ley 20.000 (ej: "Lista I", "Lista II", "Precursor quÃ­mico"). Determina las consecuencias jurÃ­dicas asociadas.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_droga',
 @level2type = N'COLUMN', @level2name = N'categoria_legal';


-- Tabla: evidencias.cat_estado_especie (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'id_estado_especie';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'id_estado_especie';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'es_salida_definitiva';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si este estado representa salida definitiva de la cadena de custodia (devoluciÃ³n, destrucciÃ³n, etc.). 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'es_salida_definitiva';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de estados de la especie en custodia. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de estados de la especie en custodia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_estado_especie',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: evidencias.cat_institucion (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_institucion',
 @level2type = N'COLUMN', @level2name = N'id_institucion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_institucion',
 @level2type = N'COLUMN', @level2name = N'id_institucion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_institucion',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de instituciones receptoras o emisoras en transferencias de evidencia. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_institucion',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_institucion',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de instituciones receptoras o emisoras en transferencias de evidencia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_institucion',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: evidencias.cat_proposito_transferencia (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_proposito_transferencia',
 @level2type = N'COLUMN', @level2name = N'id_proposito';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_proposito_transferencia',
 @level2type = N'COLUMN', @level2name = N'id_proposito';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_proposito_transferencia',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de propÃ³sitos de transferencia de evidencia. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_proposito_transferencia',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_proposito_transferencia',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de propÃ³sitos de transferencia de evidencia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_proposito_transferencia',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: evidencias.cat_tipo_custodia (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_custodia',
 @level2type = N'COLUMN', @level2name = N'id_tipo_custodia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_custodia',
 @level2type = N'COLUMN', @level2name = N'id_tipo_custodia';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_custodia',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de custodia de evidencia. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_custodia',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_custodia',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de custodia de evidencia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_custodia',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: evidencias.cat_tipo_extension_especie (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'id_tipo_extension_especie';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'id_tipo_extension_especie';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'requiere_extension';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si este tipo de especie requiere completar formularios de extensiÃ³n especÃ­ficos. 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'requiere_extension';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de extensiÃ³n especÃ­fica de especie. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de extensiÃ³n especÃ­fica de especie. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_extension_especie',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: evidencias.especie_arma (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'especie_arma',
 @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a evidencias.cat_clasificacion_arma. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'especie_arma',
 @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'especie_arma',
 @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a evidencias.cat_catalogo_armas. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'especie_arma',
 @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'especie_arma',
 @level2type = N'COLUMN', @level2name = N'dgmn_ref';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia DGMN del arma incautada en este caso especÃ­fico. Vincula con el catÃ¡logo de la DirecciÃ³n General de MovilizaciÃ³n Nacional. Campo opcional.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'especie_arma',
 @level2type = N'COLUMN', @level2name = N'dgmn_ref';


-- Tabla: evidencias.especie_droga (1 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'especie_droga',
 @level2type = N'COLUMN', @level2name = N'id_droga';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a evidencias.cat_droga. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'evidencias',
 @level1type = N'TABLE', @level1name = N'especie_droga',
 @level2type = N'COLUMN', @level2name = N'id_droga';


-- ============================================================================
-- Esquema: investigacion
-- ============================================================================

-- Tabla: investigacion.cat_circunstancia_modificatoria (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'id_circunstancia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'id_circunstancia';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de circunstancias modificatorias de responsabilidad penal (agravantes, atenuantes). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de circunstancias modificatorias de responsabilidad penal (agravantes, atenuantes). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'ClasificaciÃ³n de la circunstancia: ATENUANTE (rebaja la pena, art. 11 CP) o AGRAVANTE (aumenta la pena, art. 12 CP).',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'tipo';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'articulo_cp';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'ArtÃ­culo del CÃ³digo Penal chileno que define la circunstancia (ej: "Art. 11 NÂ°1", "Art. 12 NÂ°5").',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_circunstancia_modificatoria',
 @level2type = N'COLUMN', @level2name = N'articulo_cp';


-- Tabla: investigacion.cat_delito (7 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_inicio_vigencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha desde la cual el cÃ³digo CAPJ del delito estÃ¡ vigente. Campo opcional.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_inicio_vigencia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_fin_vigencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha hasta la cual el cÃ³digo CAPJ del delito estuvo vigente. NULL si sigue vigente.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_fin_vigencia';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre oficial del delito segÃºn la CodificaciÃ³n Penal definida por la ComisiÃ³n Interinstitucional liderada por la CorporaciÃ³n Administrativa del Poder Judicial (CAPJ). El nombre proviene del catÃ¡logo oficial de FiscalÃ­a y se mantiene actualizado mediante cargas periÃ³dicas (ver SecciÃ³n 11 del documento de diseÃ±o).',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'cuerpo_legal';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Cuerpo legal donde se tipifica el delito (ej: "CÃ³digo Penal", "Ley 20.000", "Ley 17.798", "Ley 18.290"). Permite trazar la fuente normativa.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'cuerpo_legal';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'articulo_legal';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'ArtÃ­culo especÃ­fico dentro del cuerpo legal que tipifica el delito (ej: "Art. 391 NÂ°1", "Art. 4Â°", "Art. 196").',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_delito',
 @level2type = N'COLUMN', @level2name = N'articulo_legal';


-- Tabla: investigacion.cat_grado_ejecucion (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_grado_ejecucion',
 @level2type = N'COLUMN', @level2name = N'id_grado_ejecucion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_ejecucion',
 @level2type = N'COLUMN', @level2name = N'id_grado_ejecucion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grado_ejecucion',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de grados de ejecuciÃ³n del delito (consumado, tentativa, frustrado). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_ejecucion',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grado_ejecucion',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de grados de ejecuciÃ³n del delito (consumado, tentativa, frustrado). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_ejecucion',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: investigacion.cat_grado_participacion (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'id_grado_participacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'id_grado_participacion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de grados de participaciÃ³n criminal (autor, cÃ³mplice, encubridor). Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'codigo';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de grados de participaciÃ³n criminal (autor, cÃ³mplice, encubridor). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'articulo_cp';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'ArtÃ­culo del CÃ³digo Penal chileno que define el grado de participaciÃ³n (ej: "Art. 14", "Art. 15", "Art. 16", "Art. 17").',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'cat_grado_participacion',
 @level2type = N'COLUMN', @level2name = N'articulo_cp';


-- Tabla: investigacion.protocolo_delito (6 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'id_protocolo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'id_protocolo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a investigacion.clasificacion_delito. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'activo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'activo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de eliminaciÃ³n lÃ³gica del registro (soft-delete). NULL si el registro estÃ¡ activo.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'protocolo_delito',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';


-- ============================================================================
-- Esquema: migracion
-- ============================================================================

-- Tabla: migracion.expulsion (12 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_expulsion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla migracion.expulsion. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_expulsion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_persona';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a personas.persona. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_persona';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_denuncia_mig';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a migracion.denuncia_administrativa_migratoria. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_denuncia_mig';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de eliminaciÃ³n lÃ³gica del registro (soft-delete). NULL si el registro estÃ¡ activo.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_notificacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha en que se notificÃ³ formalmente la resoluciÃ³n de expulsiÃ³n al afectado.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_notificacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_vencimiento_apelacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha lÃ­mite para que el afectado presente apelaciÃ³n contra la resoluciÃ³n de expulsiÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_vencimiento_apelacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_salida_fisica';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC en que se ejecutÃ³ efectivamente la salida fÃ­sica del paÃ­s.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'fecha_salida_fisica';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'plazo_apelacion_dias';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Plazo en dÃ­as corridos que tiene el afectado para presentar apelaciÃ³n contra la resoluciÃ³n de expulsiÃ³n, contado desde la notificaciÃ³n. Determinado por la Ley 21.325 segÃºn el tipo de expulsiÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'plazo_apelacion_dias';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'prohibicion_ingreso_anos';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'AÃ±os de prohibiciÃ³n de reingreso al paÃ­s asociados a la expulsiÃ³n. SegÃºn Ley 21.325: 10 aÃ±os para expulsiÃ³n judicial, 25 aÃ±os para expulsiÃ³n administrativa por delito grave.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'expulsion',
 @level2type = N'COLUMN', @level2name = N'prohibicion_ingreso_anos';


-- Tabla: migracion.fiscalizacion_planificada (7 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'id_fiscalizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'id_fiscalizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'id_unidad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.unidad. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'id_unidad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de eliminaciÃ³n lÃ³gica del registro (soft-delete). NULL si el registro estÃ¡ activo.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_planificacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha planificada para la ejecuciÃ³n de la fiscalizaciÃ³n migratoria.',
 @level0type = N'SCHEMA', @level0name = N'migracion',
 @level1type = N'TABLE', @level1name = N'fiscalizacion_planificada',
 @level2type = N'COLUMN', @level2name = N'fecha_planificacion';


-- ============================================================================
-- Esquema: organizacion
-- ============================================================================

-- Tabla: organizacion.unidad (1 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'unidad',
 @level2type = N'COLUMN', @level2name = N'es_lacrim';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si la unidad pertenece a LACRIM (Laboratorio de CriminalÃ­stica PDI). 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'organizacion',
 @level1type = N'TABLE', @level1name = N'unidad',
 @level2type = N'COLUMN', @level2name = N'es_lacrim';


-- ============================================================================
-- Esquema: personas
-- ============================================================================

-- Tabla: personas.cat_nacionalidad (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'cat_nacionalidad',
 @level2type = N'COLUMN', @level2name = N'id_nacionalidad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'personas',
 @level1type = N'TABLE', @level1name = N'cat_nacionalidad',
 @level2type = N'COLUMN', @level2name = N'id_nacionalidad';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_nacionalidad',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo ISO 3166-1 alpha-3 del paÃ­s de la nacionalidad (3 letras, ej: CHL, ARG, USA, ESP). EstÃ¡ndar internacional para identificaciÃ³n de paÃ­ses.',
 @level0type = N'SCHEMA', @level0name = N'personas',
 @level1type = N'TABLE', @level1name = N'cat_nacionalidad',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'cat_nacionalidad',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo ISO 3166-1 alpha-2 del paÃ­s de la nacionalidad (2 letras, ej: CL, AR, US, ES). Usado en URLs, dominios y APIs.',
 @level0type = N'SCHEMA', @level0name = N'personas',
 @level1type = N'TABLE', @level1name = N'cat_nacionalidad',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';


-- ============================================================================
-- Esquema: tareas
-- ============================================================================

-- Tabla: tareas.bandeja (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'bandeja',
 @level2type = N'COLUMN', @level2name = N'id_bandeja';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.bandeja. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'bandeja',
 @level2type = N'COLUMN', @level2name = N'id_bandeja';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'bandeja',
 @level2type = N'COLUMN', @level2name = N'id_unidad';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a organizacion.unidad. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'bandeja',
 @level2type = N'COLUMN', @level2name = N'id_unidad';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'bandeja',
 @level2type = N'COLUMN', @level2name = N'id_funcionario';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'bandeja',
 @level2type = N'COLUMN', @level2name = N'id_funcionario';


-- Tabla: tareas.documento (6 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.documento. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_documento';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tipo_documento. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_documento';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_anulacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_anulacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'fecha_anulacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC en que se anulÃ³ el documento. NULL si el documento sigue vigente.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'documento',
 @level2type = N'COLUMN', @level2name = N'fecha_anulacion';


-- Tabla: tareas.estado_tarea (7 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.estado_tarea. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tipo_estado_tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_estado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_estado';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_bandeja';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.bandeja. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_bandeja';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_bandeja_aprobacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a tareas.bandeja. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_bandeja_aprobacion';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'fecha_estado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC en que la tarea entrÃ³ en el estado registrado. Permite reconstruir la lÃ­nea de tiempo de la tarea.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'estado_tarea',
 @level2type = N'COLUMN', @level2name = N'fecha_estado';


-- Tabla: tareas.tarea (4 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.tarea. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tipo_tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea_actual';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a tareas.estado_tarea. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea_actual';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_tarea_dependiente';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a tareas.tarea. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea',
 @level2type = N'COLUMN', @level2name = N'id_tarea_dependiente';


-- Tabla: tareas.tarea_archivo_adjunto (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_archivo_adjunto',
 @level2type = N'COLUMN', @level2name = N'id_archivo';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a archivos.archivo. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_archivo_adjunto',
 @level2type = N'COLUMN', @level2name = N'id_archivo';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_archivo_adjunto',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.estado_tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_archivo_adjunto',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea';


-- Tabla: tareas.tarea_denuncia (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_denuncia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a denuncias.denuncia. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_denuncia',
 @level2type = N'COLUMN', @level2name = N'id_denuncia';


-- Tabla: tareas.tarea_diligencia (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_diligencia';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a diligencias.diligencia. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_diligencia',
 @level2type = N'COLUMN', @level2name = N'id_diligencia';


-- Tabla: tareas.tarea_documento (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_documento',
 @level2type = N'COLUMN', @level2name = N'id_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.documento. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_documento',
 @level2type = N'COLUMN', @level2name = N'id_documento';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tarea_documento',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.estado_tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tarea_documento',
 @level2type = N'COLUMN', @level2name = N'id_estado_tarea';


-- Tabla: tareas.tipo_documento (3 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.tipo_documento. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_documento';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_documento',
 @level2type = N'COLUMN', @level2name = N'vigente';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ vigente. 1 = vigente, 0 = no vigente.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_documento',
 @level2type = N'COLUMN', @level2name = N'vigente';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'tipo_documento',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos documentales (denuncia, OI, PD, IP, etc.). Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_documento',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: tareas.tipo_estado_tarea (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.tipo_estado_tarea. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_estado_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_estado_tarea';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'tipo_estado_tarea',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de estados posibles de una tarea. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_estado_tarea',
 @level2type = N'COLUMN', @level2name = N'nombre';


-- Tabla: tareas.tipo_tarea (5 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.tipo_tarea. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'requiere_aprobacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si las tareas de este tipo requieren aprobaciÃ³n jerÃ¡rquica para finalizar. 1 = sÃ­, 0 = no.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'requiere_aprobacion';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de tarea segÃºn las acciones y asociaciones que ofrecen. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'nombre';

-- descripcion tautologica (revisar en Excel hoja 7)
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de tipos de tarea segÃºn las acciones y asociaciones que ofrecen. Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'descripcion';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'permite_adjuntar_archivos';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si las tareas de este tipo permiten adjuntar archivos (1 = sÃ­, 0 = no). Determina si la UI muestra el control de carga de archivos.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea',
 @level2type = N'COLUMN', @level2name = N'permite_adjuntar_archivos';


-- Tabla: tareas.tipo_tarea_tipo_documento (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea_tipo_documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tipo_tarea. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea_tipo_documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_tarea';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'tipo_tarea_tipo_documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.tipo_documento. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'tipo_tarea_tipo_documento',
 @level2type = N'COLUMN', @level2name = N'id_tipo_documento';


-- Tabla: tareas.version_documento (10 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_version_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del registro en la tabla tareas.version_documento. Clave primaria autogenerada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_version_documento';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_documento';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a tareas.documento. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_documento';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_version';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a organizacion.funcionario. Vincula este registro con su entidad relacionada.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_version';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_archivo_por_visar';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a archivos.archivo. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_archivo_por_visar';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_visado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a organizacion.funcionario. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_funcionario_visado';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_archivo_firmado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a archivos.archivo. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'id_archivo_firmado';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'fecha_version';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n de esta versiÃ³n del documento.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'fecha_version';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'fecha_visado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC del visado jerÃ¡rquico de la versiÃ³n del documento por parte de Jefatura (control de calidad sobre el informe policial). NO es firma electrÃ³nica. Ver doc PO01.02.04 Visar Informe Policial.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'fecha_visado';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'fecha_firmado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC en que se aplicÃ³ firma electrÃ³nica avanzada (FEA) al documento vÃ­a API OTP. NULL si la versiÃ³n aÃºn no se ha firmado.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'fecha_firmado';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'comentario_visado';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Comentario tÃ©cnico de la Jefatura al visar la versiÃ³n del documento. Obligatorio cuando la Jefatura rechaza el informe (la diligencia vuelve a "En EjecuciÃ³n" para que el investigador subsane). Ver doc PO01.02.04.',
 @level0type = N'SCHEMA', @level0name = N'tareas',
 @level1type = N'TABLE', @level1name = N'version_documento',
 @level2type = N'COLUMN', @level2name = N'comentario_visado';


-- ============================================================================
-- Esquema: ubicacion
-- ============================================================================

-- Tabla: ubicacion.lugar (2 columnas)

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'lugar',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'ubicacion',
 @level1type = N'TABLE', @level1name = N'lugar',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';

-- descripcion real
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
 @level1type = N'TABLE', @level1name = N'lugar',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima actualizaciÃ³n del registro. Se actualiza en cada modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'ubicacion',
 @level1type = N'TABLE', @level1name = N'lugar',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';


-- Tabla: ubicacion.pais (2 columnas)

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'pais',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo ISO 3166-1 alpha-3 del paÃ­s (3 letras, ej: CHL, ARG, USA, ESP). EstÃ¡ndar internacional para identificaciÃ³n de paÃ­ses.',
 @level0type = N'SCHEMA', @level0name = N'ubicacion',
 @level1type = N'TABLE', @level1name = N'pais',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_3';

-- descripcion inferida (validar con PDI - Excel hoja 8)
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
 @level1type = N'TABLE', @level1name = N'pais',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';
EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo ISO 3166-1 alpha-2 del paÃ­s (2 letras, ej: CL, AR, US, ES). Usado en URLs, dominios y APIs.',
 @level0type = N'SCHEMA', @level0name = N'ubicacion',
 @level1type = N'TABLE', @level1name = N'pais',
 @level2type = N'COLUMN', @level2name = N'codigo_iso_alpha_2';


-- ============================================================================
-- Fin V0005__descripciones_complementarias.sql
-- 279 descripciones agregadas.
-- Cobertura post-V0005: 1.533 / 1.558 columnas (98.4%)
-- Pendientes reales: 25 columnas que requieren documentos PDI especificos
-- ============================================================================
