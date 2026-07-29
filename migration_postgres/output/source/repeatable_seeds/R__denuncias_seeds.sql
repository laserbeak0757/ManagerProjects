-- =============================================================================
-- SIP — Repeatable Migration R__denuncias_seed.sql
-- =============================================================================
-- Tipo:         Repeatable (Flyway). Se aplica automáticamente cada vez que
--               su contenido cambia (no requiere nueva versión).
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0007__catalogos_estado_denuncia.sql (crea las tablas)
--
-- ALCANCE:
--   Carga de datos semilla institucionales del esquema denuncias:
--     - denuncias.cat_estado_denuncia        (7 filas)
--     - denuncias.cat_estado_envio_fiscalia  (3 filas)
--
-- CRITERIO DE CONTENIDO:
--   Los valores cargados son los derivados del análisis del proceso PO01.01
--   v2.0.0 (Gestión de Denuncias), validados contra los BPMN del subproceso.
--   Los campos auxiliares (es_terminal, orden) reflejan la semántica
--   operativa de cada estado.
--
-- IDEMPOTENCIA:
--   Implementada vía MERGE. Cada bloque INSERT/UPDATE solo modifica filas
--   cuando hay diferencia real en algún campo, evitando escrituras
--   innecesarias en sucesivas reaplicaciones del script.
--
-- POLÍTICA DE BORRADO:
--   No se incluye WHEN NOT MATCHED BY SOURCE THEN DELETE. Esto preserva
--   filas adicionales que algún operador haya cargado manualmente en el
--   catálogo. Para hacer un reset completo del catálogo, debe ejecutarse
--   manualmente un DELETE previo (con cuidado de las FKs entrantes).
--
-- ORDEN DE EJECUCIÓN:
--   Flyway aplica las repetibles después de las versionadas en cada bucle.
--   Este script asume que V0007 ya está aplicado (las tablas existen).
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
-- BLOQUE 1 — denuncias.cat_estado_denuncia
-- =============================================================================
-- Estados derivados del proceso PO01.01 v2.0.0:
--   1. BORRADOR                 (PO01.01.01 Registrar Denuncia, salida)
--   2. FIRMADA_POR_INVESTIGADOR (PO01.01.02 Completar Denuncia, salida)
--   3. EN_REVISION              (PO01.01.03 Visar Denuncia, "Cambiar estado a En Revisión")
--   4. OBSERVADO                (PO01.01.03 Visar Denuncia, rama "Si requiere más detalle")
--   5. FIRMADA_POR_JEFATURA     (PO01.01.03 Visar Denuncia, "Cambiar estado a Firmado por Jefatura")
--   6. NOTIFICADA_FISCALIA      (PO01.01.04 Notificar Fiscalía, estado terminal)
--   7. ANULADA                  (estado terminal alternativo, complementario al proceso)
-- =============================================================================

;WITH src(codigo, nombre, es_terminal, orden) AS (
    SELECT * FROM (VALUES
        (N'BORRADOR',                  N'Borrador',                       0, 10),
        (N'ENVIADA_A_VISAR',  N'Enviada a visar',       0, 20),
        (N'EN_REVISION',               N'En revisión',                    0, 30),
        (N'OBSERVADO',                 N'Observada',                      0, 40),
        (N'FIRMADA_POR_JEFATURA',      N'Firmada por jefatura',           0, 50),
        (N'NOTIFICADA_FISCALIA',       N'Notificada a Fiscalía',          1, 60),
        (N'ANULADA',                   N'Anulada',                        1, 99)
    ) v(codigo, nombre, es_terminal, orden)
)
MERGE [denuncias].[cat_estado_denuncia] AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND (tgt.nombre <> src.nombre
                  OR tgt.es_terminal <> src.es_terminal
                  OR ISNULL(tgt.orden, -1) <> src.orden)
    THEN UPDATE SET
         nombre      = src.nombre,
         es_terminal = src.es_terminal,
         orden       = src.orden
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, nombre, es_terminal, orden, activo)
         VALUES (src.codigo, src.nombre, src.es_terminal, src.orden, 1);
GO


-- =============================================================================
-- BLOQUE 2 — denuncias.cat_estado_envio_fiscalia
-- =============================================================================
-- Estados del subflujo de envío a Fiscalía, derivados del BPMN de
-- PO01.01.04 Notificar Fiscalía y de la descripción extendida vigente
-- de la columna estado_envio_fiscalia en V0001:
--   1. PENDIENTE  (default — denuncia firmada por jefatura, lista para enviar)
--   2. ENVIADO    (acta enviada vía API a Bitácora Web)
--   3. PRORROGADO (espera de 5 días + reconsulta RUC en bucle)
--
-- Nota: el cierre exitoso del envío se infiere por la presencia del RUC en
-- denuncia.folio_externo (no requiere un estado RUC_RECIBIDO explícito).
-- =============================================================================

;WITH src(codigo, nombre, es_terminal, orden) AS (
    SELECT * FROM (VALUES
        (N'PENDIENTE',  N'Pendiente de envío',                 0, 10),
        (N'ENVIADO',    N'Enviado a Fiscalía',                 0, 20),
        (N'PRORROGADO', N'Prórroga en curso (espera de RUC)',  0, 30)
    ) v(codigo, nombre, es_terminal, orden)
)
MERGE [denuncias].[cat_estado_envio_fiscalia] AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND (tgt.nombre <> src.nombre
                  OR tgt.es_terminal <> src.es_terminal
                  OR ISNULL(tgt.orden, -1) <> src.orden)
    THEN UPDATE SET
         nombre      = src.nombre,
         es_terminal = src.es_terminal,
         orden       = src.orden
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, nombre, es_terminal, orden, activo)
         VALUES (src.codigo, src.nombre, src.es_terminal, src.orden, 1);
GO


-- =============================================================================
-- FIN — R__denuncias_seed.sql
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--
--   -- Verificar conteos
--   SELECT COUNT(*) FROM [denuncias].[cat_estado_denuncia];
--   -- esperado: 7 filas
--
--   SELECT COUNT(*) FROM [denuncias].[cat_estado_envio_fiscalia];
--   -- esperado: 3 filas
--
--   -- Verificar contenido y orden
--   SELECT codigo, nombre, es_terminal, orden, activo
--     FROM [denuncias].[cat_estado_denuncia]
--    ORDER BY orden;
--
--   SELECT codigo, nombre, es_terminal, orden, activo
--     FROM [denuncias].[cat_estado_envio_fiscalia]
--    ORDER BY orden;
--
--   -- Reaplicación segura: ejecutar este script dos veces seguidas no
--   -- debe producir cambios en la segunda ejecución (es @@ROWCOUNT = 0).
-- =============================================================================

IF NOT EXISTS (SELECT 1 FROM denuncias.cat_tipo_relato)
BEGIN
INSERT INTO denuncias.cat_tipo_relato
(
codigo,
nombre
)
VALUES
('DECLARACION', 'declaracion')
END
GO


-- =============================================================================
-- BLOQUE 3 — denuncias.cat_tipo_acompanamiento_nna (PDI-1553)
-- =============================================================================
-- Tabla creada en V0045__pauta_nna.sql.
-- =============================================================================

;WITH src(codigo, nombre, orden) AS (
    SELECT * FROM (VALUES
        (N'NNA_ACOMPANADO_ADULTO',   N'NNA acompañado por adulto',     10),
        (N'NNA_SOLO',                N'NNA solo',                      20),
        (N'NNA_ACOMPANADO_OTRO_NNA', N'NNA acompañado por otro NNA',   30)
    ) v(codigo, nombre, orden)
)
MERGE [denuncias].[cat_tipo_acompanamiento_nna] AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND (tgt.nombre <> src.nombre OR ISNULL(tgt.orden, -1) <> src.orden)
    THEN UPDATE SET
         nombre = src.nombre,
         orden  = src.orden
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, nombre, orden, es_activo)
         VALUES (src.codigo, src.nombre, src.orden, 1);
GO


-- =============================================================================
-- BLOQUE 4 — denuncias.cat_tipo_denunciante_nna (PDI-1553)
-- =============================================================================
-- Tabla creada en V0045__pauta_nna.sql.
-- =============================================================================

;WITH src(codigo, nombre, orden) AS (
    SELECT * FROM (VALUES
        (N'ADULTO', N'Adulto', 10),
        (N'NNA',    N'NNA',    20)
    ) v(codigo, nombre, orden)
)
MERGE [denuncias].[cat_tipo_denunciante_nna] AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND (tgt.nombre <> src.nombre OR ISNULL(tgt.orden, -1) <> src.orden)
    THEN UPDATE SET
         nombre = src.nombre,
         orden  = src.orden
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, nombre, orden, es_activo)
         VALUES (src.codigo, src.nombre, src.orden, 1);
GO


-- =============================================================================
-- BLOQUE 5 — denuncias.cat_categoria_factor_riesgo_nna (PDI-1553, Anexo N°3)
-- =============================================================================
-- Tabla creada en V0045__pauta_nna.sql. Texto exacto de los encabezados del
-- checklist del Anexo N°3 "Formulario de Factores de Riesgo NNA".
-- =============================================================================

;WITH src(codigo, nombre, orden) AS (
    SELECT * FROM (VALUES
        (N'GRAVEDAD_DELITO',            N'Gravedad del delito',                                     10),
        (N'FACTORES_VICTIMA',           N'Factores asociados a la víctima',                         20),
        (N'CONTACTO_AGRESOR',           N'Contacto del Agresor con la víctima',                      30),
        (N'ANTECEDENTES_AGRESOR',       N'Antecedentes del Agresor (si ha sido identificado espontáneamente)', 40),
        (N'CONDUCTA_ADULTO_PROTECTOR',  N'Conducta del adulto protector/responsable/referente',      50)
    ) v(codigo, nombre, orden)
)
MERGE [denuncias].[cat_categoria_factor_riesgo_nna] AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND (tgt.nombre <> src.nombre OR ISNULL(tgt.orden, -1) <> src.orden)
    THEN UPDATE SET
         nombre = src.nombre,
         orden  = src.orden
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, nombre, orden, es_activo)
         VALUES (src.codigo, src.nombre, src.orden, 1);
GO


-- =============================================================================
-- BLOQUE 6 — denuncias.cat_factor_riesgo_nna (PDI-1553, Anexo N°3)
-- =============================================================================
-- Tabla creada en V0045__pauta_nna.sql. 25 ítems, texto exacto del Anexo N°3.
-- El id_categoria_factor_riesgo_nna se resuelve por codigo de categoría
-- (subconsulta), no por id fijo, para no depender del orden de inserción.
-- =============================================================================

;WITH src(codigo_categoria, codigo, nombre, descripcion, orden) AS (
    SELECT * FROM (VALUES
        -- 1. Gravedad del delito
        (N'GRAVEDAD_DELITO', N'LESIONES_ASOCIADAS_HECHO',    N'Lesiones asociadas al hecho',              N'Presenta y/o señala lesiones asociadas al hecho denunciado.', 10),
        (N'GRAVEDAD_DELITO', N'LESIONES_ANTERIORES_HECHO',   N'Lesiones anteriores al hecho',              N'Presenta y/o señala lesiones anteriores al hecho denunciado (fracturas, cortes, quemaduras u otros).', 20),
        (N'GRAVEDAD_DELITO', N'UTILIZACION_OBJETOS_ARMAS',   N'Utilización de objetos o armas',            N'Se señala la utilización de objetos o armas en el delito.', 30),
        (N'GRAVEDAD_DELITO', N'AMENAZAS_POR_DEVELACION',     N'Amenazas por develación',                   N'Se señalan amenazas por parte del agresor asociadas a la develación del hecho.', 40),
        (N'GRAVEDAD_DELITO', N'RIESGO_VIDA_NNA',             N'Riesgo de vida del NNA',                    N'Se puso en riesgo la vida de NNA (tales como amenazas con armas, lesiones graves, intento de homicidio).', 50),
        (N'GRAVEDAD_DELITO', N'HECHO_RECIENTE',              N'Hecho reciente',                            N'Se trata de hechos recientes (hasta 3 días).', 60),
        (N'GRAVEDAD_DELITO', N'HECHO_REITERADO',             N'Hecho reiterado',                           N'Se trata de hechos reiterados (más de una vez).', 70),
        (N'GRAVEDAD_DELITO', N'CASO_FLAGRANCIA',              N'Caso de flagrancia',                       N'Se trata de un caso de flagrancia (hasta 12 horas).', 80),

        -- 2. Factores asociados a la víctima
        (N'FACTORES_VICTIMA', N'NACIONALIDAD',                N'Nacionalidad',                            N'Nacionalidad.', 10),
        (N'FACTORES_VICTIMA', N'GENERO_SEXO',                 N'Género y/o sexo',                          N'Género y/o Sexo.', 20),
        (N'FACTORES_VICTIMA', N'PUEBLO_ORIGINARIO',           N'Pueblo originario',                        N'Perteneciente a pueblo originario.', 30),
        (N'FACTORES_VICTIMA', N'SITUACION_DISCAPACIDAD',      N'Situación de discapacidad',                N'Presenta evidente situación de discapacidad física, mental, intelectual y/o sensorial u otra reportada por acompañante.', 40),
        (N'FACTORES_VICTIMA', N'ALTERACION_ESTADO_EMOCIONAL', N'Alteración del estado emocional',          N'Presenta evidente alteración del estado emocional (crisis de llanto, elevada angustia, inquietud motriz, dificultad para respirar, suspensión del habla o mutismo).', 50),
        (N'FACTORES_VICTIMA', N'IDEACION_INTENTO_SUICIDIO',   N'Ideación o intento de suicidio',           N'Señala espontáneamente ideación o intento previo de suicidio.', 60),

        -- 3. Contacto del Agresor con la víctima
        (N'CONTACTO_AGRESOR', N'VIVE_CON_NNA',                N'Vive con NNA',                             N'Vive con NNA.', 10),
        (N'CONTACTO_AGRESOR', N'CONTACTO_DIRECTO_SIN_VIVIR',  N'Contacto directo sin vivir con NNA',       N'No vive con NNA, pero tiene o puede tener contacto personal directo con él.', 20),

        -- 4. Antecedentes del Agresor
        (N'ANTECEDENTES_AGRESOR', N'CONSUMO_PROBLEMATICO_OH_DROGAS',  N'Consumo problemático de alcohol o drogas', N'Presenta consumo problemático de alcohol o drogas.', 10),
        (N'ANTECEDENTES_AGRESOR', N'DENUNCIAS_ANTERIORES_SEXUALES',  N'Denuncias anteriores por delitos sexuales', N'Presenta denuncias anteriores por delitos sexuales (de acuerdo a consulta en sistema).', 20),
        (N'ANTECEDENTES_AGRESOR', N'DENUNCIAS_ANTERIORES_VIOLENTOS', N'Denuncias anteriores por delitos violentos', N'Presenta denuncias anteriores por delitos violentos (de acuerdo a consulta en sistema).', 30),
        (N'ANTECEDENTES_AGRESOR', N'SENTENCIAS_CONDENATORIAS',       N'Sentencias condenatorias',                  N'Tiene sentencias condenatorias por delitos sexuales o violentos (de acuerdo a consulta en sistema).', 40),

        -- 5. Conducta del adulto protector/responsable/referente
        (N'CONDUCTA_ADULTO_PROTECTOR', N'ES_PADRE_MADRE',           N'Es el padre o la madre',            N'Es el padre/madre.', 10),
        (N'CONDUCTA_ADULTO_PROTECTOR', N'CREE_RELATO_NNA',          N'Cree en el relato del NNA',         N'Cree en el relato de NNA.', 20),
        (N'CONDUCTA_ADULTO_PROTECTOR', N'CONDUCTAS_PROTECTORAS',    N'Conductas protectoras',             N'Tiene conductas protectoras hacia NNA.', 30),
        (N'CONDUCTA_ADULTO_PROTECTOR', N'MINIMIZA_HECHOS',          N'Minimiza los hechos',               N'Minimiza los hechos.', 40),
        (N'CONDUCTA_ADULTO_PROTECTOR', N'RESPALDA_AGRESOR',         N'Respalda al agresor',               N'Respalda al agresor.', 50)
    ) v(codigo_categoria, codigo, nombre, descripcion, orden)
)
MERGE [denuncias].[cat_factor_riesgo_nna] AS tgt
USING (
    SELECT c.id_categoria_factor_riesgo_nna, s.codigo, s.nombre, s.descripcion, s.orden
    FROM src s
    JOIN denuncias.cat_categoria_factor_riesgo_nna c ON c.codigo = s.codigo_categoria
) AS src ON tgt.codigo = src.codigo
WHEN MATCHED AND (tgt.nombre <> src.nombre
                  OR tgt.descripcion <> src.descripcion
                  OR tgt.id_categoria_factor_riesgo_nna <> src.id_categoria_factor_riesgo_nna
                  OR ISNULL(tgt.orden, -1) <> src.orden)
    THEN UPDATE SET
         nombre                         = src.nombre,
         descripcion                    = src.descripcion,
         id_categoria_factor_riesgo_nna = src.id_categoria_factor_riesgo_nna,
         orden                          = src.orden
WHEN NOT MATCHED BY TARGET
    THEN INSERT (id_categoria_factor_riesgo_nna, codigo, nombre, descripcion, orden, es_activo)
         VALUES (src.id_categoria_factor_riesgo_nna, src.codigo, src.nombre, src.descripcion, src.orden, 1);
GO