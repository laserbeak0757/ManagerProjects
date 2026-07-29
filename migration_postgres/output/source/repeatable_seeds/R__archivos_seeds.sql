SET NOCOUNT ON;
GO

-- =============================================================================
-- R__archivos_seeds.sql
-- Seed idempotente del catálogo del esquema archivos.
-- Estrategia: MERGE (MATCHED + NOT MATCHED BY TARGET) + IDENTITY_INSERT.
-- No incluye DELETE de huérfanos.
--
-- cat_entidad_vinculable: entidades de negocio a las que se puede asociar un
-- archivo por el vínculo polimórfico. id explícito = contrato estable entre
-- ambientes (dev, QA, prod). columna_pk sigue la convención id_<entidad>.
--
-- Se excluyen a propósito:
--   * Catálogos, tablas puente y de detalle (no reciben adjuntos).
--   * Entidades que ya manejan su archivo canónico por FK física
--     (personas.fotografia, denuncias.relato, diligencias.notificacion_externa,
--      casos.matriz_riesgo, analitica.reporte_analitico, documentos.version_documento,
--      tareas.tarea_archivo_adjunto).
--
-- Para habilitar una entidad nueva: agregar una fila al VALUES con su id, su
-- esquema, su entidad (tabla) y su columna PK. No requiere migración versionada.
-- Nota: parte/acta se agregan cuando se creen esos esquemas.
--
-- Los id son permanentes: no se reutilizan ni reasignan al agregar/quitar filas
-- (pueden quedar huecos en la numeración; es correcto).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- cat_tipo_archivo: tipos de archivo. Requerido por archivos.archivo
-- (id_tipo_archivo es NOT NULL con FK a este catálogo): sin estos registros no
-- es posible cargar archivos. Conjunto inicial; ajustar codigos/limites según
-- necesidad. es_multimedia: 1 = audio/video/imagen, 0 = no. tamanio_max_mb NULL
-- = sin límite específico del tipo.
-- -----------------------------------------------------------------------------
SET IDENTITY_INSERT archivos.cat_tipo_archivo ON;
GO

MERGE archivos.cat_tipo_archivo AS target
USING (VALUES
    (1, N'PDF',        N'Documento PDF',         0,   50),
    (2, N'IMG',        N'Imagen',                1,   20),
    (3, N'DOC_OFFICE', N'Documento Office',      0,   50),
    (4, N'DOC_ESCAN',  N'Documento escaneado',   0,   30),
    (5, N'VIDEO',       N'Video',                1,  500),
    (6, N'AUDIO',       N'Audio',                1,  100),
    (7, N'PLANILLA',    N'Planilla de cálculo',  0,   50),
    (8, N'PRESENTACION',N'Presentación',         0,  100),
    (9, N'CORREO',      N'Correo electrónico',   0,   50),
    (10,N'COMPRIMIDO',  N'Archivo comprimido',   0,  200),
    (11,N'OTRO',        N'Otro',                 0, NULL)
) AS src (id_tipo_archivo, codigo, nombre, es_multimedia, tamanio_max_mb)
ON target.id_tipo_archivo = src.id_tipo_archivo
WHEN MATCHED THEN UPDATE SET
    target.codigo         = src.codigo,
    target.nombre         = src.nombre,
    target.es_multimedia  = src.es_multimedia,
    target.tamanio_max_mb = src.tamanio_max_mb
WHEN NOT MATCHED THEN INSERT
    (id_tipo_archivo, codigo, nombre, es_multimedia, tamanio_max_mb, fecha_creacion)
    VALUES
    (src.id_tipo_archivo, src.codigo, src.nombre, src.es_multimedia, src.tamanio_max_mb, SYSUTCDATETIME());
GO

SET IDENTITY_INSERT archivos.cat_tipo_archivo OFF;
GO

-- -----------------------------------------------------------------------------
-- cat_entidad_vinculable: entidades a las que se puede asociar un archivo.
-- -----------------------------------------------------------------------------
SET IDENTITY_INSERT archivos.cat_entidad_vinculable ON;
GO

MERGE archivos.cat_entidad_vinculable AS target
USING (VALUES
    -- casos
    ( 5, N'casos',           N'caso',                    N'id_caso'                 ),
    (11, N'casos',           N'carpeta',                 N'id_carpeta'              ),
    -- cooperacion_int
    (28, N'cooperacion_int', N'solicitud_interpol',      N'id_solicitud'            ),
    -- denuncias
    ( 4, N'denuncias',       N'denuncia',                N'id_denuncia'             ),
    ( 9, N'denuncias',       N'procedimiento_policial',  N'id_procedimiento'        ),
    -- diligencias
    ( 6, N'diligencias',     N'diligencia',              N'id_diligencia'           ),
    (12, N'diligencias',     N'informe_policial',        N'id_informe'              ),
    (13, N'diligencias',     N'peritaje',                N'id_peritaje'             ),
    (14, N'diligencias',     N'actividad_investigativa', N'id_actividad'            ),
    (15, N'diligencias',     N'orden_arresto',           N'id_orden_arresto'        ),
    (16, N'diligencias',     N'orden_detencion',         N'id_orden_detencion'      ),
    (17, N'diligencias',     N'instruccion_fiscal',      N'id_instruccion_fiscal'   ),
    (18, N'diligencias',     N'detencion',               N'id_detencion'            ),
    -- documentos
    ( 3, N'documentos',      N'documento',               N'id_documento'            ),
    -- encargos
    (26, N'encargos',        N'encargo',                 N'id_encargo'              ),
    (27, N'encargos',        N'orden_judicial',          N'id_orden_judicial'       ),
    -- evidencias
    (19, N'evidencias',      N'evidencia',               N'id_evidencia'            ),
    (20, N'evidencias',      N'especie',                 N'id_especie'              ),
    (21, N'evidencias',      N'arma',                    N'id_arma'                 ),
    (22, N'evidencias',      N'incautacion',             N'id_incautacion'          ),
    (23, N'evidencias',      N'cadena_custodia',         N'id_cadena'               ),
    -- investigacion
    (24, N'investigacion',   N'hecho',                   N'id_hecho'                ),
    (25, N'investigacion',   N'delito_imputado',         N'id_delito_imputado'      ),
    -- personas
    ( 1, N'personas',        N'persona',                 N'id_persona'              ),
    ( 7, N'personas',        N'identificacion',          N'id_identificacion'       ),
    ( 8, N'personas',        N'referencia_biometrica',   N'id_referencia_biometrica'),
    -- vehiculos
    ( 2, N'vehiculos',       N'vehiculo',                N'id_vehiculo'             )
) AS src (id_entidad_vinculable, esquema, entidad, columna_pk)
ON target.id_entidad_vinculable = src.id_entidad_vinculable
WHEN MATCHED THEN UPDATE SET
    target.esquema      = src.esquema,
    target.entidad      = src.entidad,
    target.columna_pk   = src.columna_pk
WHEN NOT MATCHED THEN INSERT
    (id_entidad_vinculable, esquema, entidad, columna_pk, activo, fecha_creacion)
    VALUES
    (src.id_entidad_vinculable, src.esquema, src.entidad, src.columna_pk, 1, SYSUTCDATETIME());
GO

SET IDENTITY_INSERT archivos.cat_entidad_vinculable OFF;
GO
