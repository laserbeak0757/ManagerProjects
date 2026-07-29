-- =============================================================================
-- SIP — Migration V0045__pauta_nna
-- =============================================================================
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql (denuncias.denuncia, casos.caso,
--               personas.persona, organizacion.funcionario)
--
-- ALCANCE (PDI-1553 — Registro adulto responsable / ANEXO N°3 "Formulario de
-- Factores de Riesgo NNA", Ley 21.057):
--   1. Crea catálogos nuevos en el esquema denuncias:
--        - denuncias.cat_tipo_acompanamiento_nna    (cómo se presenta el NNA)
--        - denuncias.cat_tipo_denunciante_nna       (quién denuncia: adulto o NNA)
--        - denuncias.cat_categoria_factor_riesgo_nna (5 secciones del Anexo N°3)
--        - denuncias.cat_factor_riesgo_nna           (25 ítems del checklist)
--   2. Agrega personas.persona.edad_declarada (SMALLINT NULL): edad aproximada
--      auto-reportada, usada cuando no se dispone de fecha_nacimiento exacta
--      (víctima NNA, acompañante, adulto protector o agresor capturados en
--      este formulario).
--   3. Crea denuncias.pauta_nna: cabecera 1:1 (opcional) con denuncia o caso,
--      con los campos propios del Anexo N°3 que no son responsabilidad de otro
--      esquema (N° de parte/denuncia, fecha del formulario, delito aparente).
--      La identificación de víctima/acompañante/adulto protector/agresor NO se
--      duplica aquí: se modela como personas.persona vinculadas a la denuncia
--      vía denuncias.denuncia_persona_rol (roles nuevos, ver BLOQUE 4) y sus
--      relaciones vía personas.relacion + personas.cat_tipo_relacion
--      (catálogo ya existente, reutilizado).
--   4. Crea denuncias.pauta_nna_factor_riesgo: respuesta (SI/NO/NO_SABE) +
--      observación por cada ítem del checklist, para la pauta.
--   5. Agrega códigos nuevos a casos.cat_tipo_rol_persona:
--        - ACOMPANANTE_NNA       (acompañante del NNA)
--        - ADULTO_PROTECTOR_NNA  (adulto protector, solo si es distinto al
--                                  acompañante — el Anexo N°3 los trata como
--                                  identificaciones separadas)
--        - AGRESOR_NNA           (agresor identificado espontáneamente, no
--                                  formalizado como IMPUTADO)
--      El seed real (MERGE) se aplica en R__casos_seeds.sql.
--
-- DATOS PRODUCTIVOS:
--   Esta migration no mueve datos existentes; solo agrega estructura nueva.
--
-- IDEMPOTENCIA:
--   Guardas IF OBJECT_ID / IF COL_LENGTH IS NULL en todos los bloques.
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
-- BLOQUE 1 — CATÁLOGOS NUEVOS
-- =============================================================================
-- Mismo patrón que denuncias.cat_estado_denuncia (V0007): id IDENTITY,
-- codigo único, nombre descriptivo, orden para presentación, es_activo para
-- baja lógica.
-- =============================================================================

-- ─── denuncias.cat_tipo_acompanamiento_nna ──────────────────────────────────
IF OBJECT_ID('[denuncias].[cat_tipo_acompanamiento_nna]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_tipo_acompanamiento_nna] (
        id_tipo_acompanamiento_nna INTEGER NOT NULL IDENTITY(1,1),
        codigo                     NVARCHAR(30) NOT NULL,
        nombre                     NVARCHAR(80) NOT NULL,
        orden                      INTEGER NULL,
        es_activo                  BIT NOT NULL CONSTRAINT df_cat_tipo_acompanamiento_nna_es_activo DEFAULT (1),
        CONSTRAINT pk_cat_tipo_acompanamiento_nna
            PRIMARY KEY (id_tipo_acompanamiento_nna),
        CONSTRAINT uq_cat_tipo_acompanamiento_nna_codigo
            UNIQUE (codigo)
    );
END;
GO

-- ─── denuncias.cat_tipo_denunciante_nna ─────────────────────────────────────
IF OBJECT_ID('[denuncias].[cat_tipo_denunciante_nna]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_tipo_denunciante_nna] (
        id_tipo_denunciante_nna INTEGER NOT NULL IDENTITY(1,1),
        codigo                  NVARCHAR(30) NOT NULL,
        nombre                  NVARCHAR(80) NOT NULL,
        orden                   INTEGER NULL,
        es_activo               BIT NOT NULL CONSTRAINT df_cat_tipo_denunciante_nna_es_activo DEFAULT (1),
        CONSTRAINT pk_cat_tipo_denunciante_nna
            PRIMARY KEY (id_tipo_denunciante_nna),
        CONSTRAINT uq_cat_tipo_denunciante_nna_codigo
            UNIQUE (codigo)
    );
END;
GO


-- =============================================================================
-- BLOQUE 2 — personas.persona.edad_declarada
-- =============================================================================
-- Edad aproximada auto-reportada por la propia persona (o por quien la
-- acompaña), para los casos en que no se dispone de fecha_nacimiento exacta.
-- No reemplaza fecha_nacimiento; conviven ambas columnas.
-- =============================================================================
IF COL_LENGTH(N'personas.persona', N'edad_declarada') IS NULL
    ALTER TABLE [personas].[persona] ADD [edad_declarada] SMALLINT NULL;
GO


-- =============================================================================
-- BLOQUE 3 — denuncias.pauta_nna (cabecera)
-- =============================================================================
-- Sigue el patrón estructural de denuncias.pauta_vif (V0001): FK opcional a
-- denuncia y a caso, id_funcionario_registra obligatorio, columnas de
-- auditoría incorporadas desde el origen (no requieren el ALTER posterior
-- que sí necesitó pauta_vif en V0027).
-- =============================================================================
IF OBJECT_ID('[denuncias].[pauta_nna]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[pauta_nna] (
        id_pauta_nna               INTEGER NOT NULL IDENTITY(1,1),
        id_denuncia                INTEGER NULL,
        id_caso                    INTEGER NULL,
        numero_parte_denuncia      NVARCHAR(50) NULL,
        fecha_formulario           DATE NULL,
        id_tipo_acompanamiento_nna INTEGER NOT NULL,
        id_tipo_denunciante_nna    INTEGER NOT NULL,
        delito_aparente            NVARCHAR(200) NULL,
        observaciones              NVARCHAR(2000) NULL,
        id_funcionario_registra    INTEGER NOT NULL,
        fecha_creacion              DATETIME2(7) NOT NULL CONSTRAINT df_pauta_nna_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion         DATETIME2(7) NULL,
        id_usuario_creador          INT NOT NULL,
        id_usuario_modificador      INT NULL,
        id_usuario_eliminador       INT NULL,
        fecha_eliminacion_logica    DATETIME2(7) NULL,
        CONSTRAINT pk_pauta_nna
            PRIMARY KEY (id_pauta_nna),
        CONSTRAINT fk_pauta_nna_denuncia
            FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia (id_denuncia),
        CONSTRAINT fk_pauta_nna_caso
            FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso),
        CONSTRAINT fk_pauta_nna_tipo_acompanamiento
            FOREIGN KEY (id_tipo_acompanamiento_nna) REFERENCES denuncias.cat_tipo_acompanamiento_nna (id_tipo_acompanamiento_nna),
        CONSTRAINT fk_pauta_nna_tipo_denunciante
            FOREIGN KEY (id_tipo_denunciante_nna) REFERENCES denuncias.cat_tipo_denunciante_nna (id_tipo_denunciante_nna),
        CONSTRAINT fk_pauta_nna_funcionario_registra
            FOREIGN KEY (id_funcionario_registra) REFERENCES organizacion.funcionario (id_funcionario),
        CONSTRAINT fk_pauta_nna_usuario_creador
            FOREIGN KEY (id_usuario_creador) REFERENCES auth.usuario (id_usuario),
        CONSTRAINT fk_pauta_nna_usuario_modificador
            FOREIGN KEY (id_usuario_modificador) REFERENCES auth.usuario (id_usuario),
        CONSTRAINT fk_pauta_nna_usuario_eliminador
            FOREIGN KEY (id_usuario_eliminador) REFERENCES auth.usuario (id_usuario)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_pauta_nna_denuncia' AND object_id = OBJECT_ID(N'denuncias.pauta_nna'))
    CREATE INDEX ix_pauta_nna_denuncia ON denuncias.pauta_nna (id_denuncia) WHERE id_denuncia IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_pauta_nna_caso' AND object_id = OBJECT_ID(N'denuncias.pauta_nna'))
    CREATE INDEX ix_pauta_nna_caso ON denuncias.pauta_nna (id_caso) WHERE id_caso IS NOT NULL;
GO


-- =============================================================================
-- BLOQUE 4 — denuncias.cat_categoria_factor_riesgo_nna
-- =============================================================================
-- Las 5 secciones del checklist del Anexo N°3 (Gravedad del delito, Factores
-- asociados a la víctima, Contacto del Agresor con la víctima, Antecedentes
-- del Agresor, Conducta del adulto protector/responsable/referente).
-- =============================================================================
IF OBJECT_ID('[denuncias].[cat_categoria_factor_riesgo_nna]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_categoria_factor_riesgo_nna] (
        id_categoria_factor_riesgo_nna INTEGER NOT NULL IDENTITY(1,1),
        codigo                         NVARCHAR(40) NOT NULL,
        nombre                         NVARCHAR(150) NOT NULL,
        orden                          INTEGER NULL,
        es_activo                      BIT NOT NULL CONSTRAINT df_cat_categoria_factor_riesgo_nna_es_activo DEFAULT (1),
        CONSTRAINT pk_cat_categoria_factor_riesgo_nna
            PRIMARY KEY (id_categoria_factor_riesgo_nna),
        CONSTRAINT uq_cat_categoria_factor_riesgo_nna_codigo
            UNIQUE (codigo)
    );
END;
GO


-- =============================================================================
-- BLOQUE 5 — denuncias.cat_factor_riesgo_nna
-- =============================================================================
-- Los 25 ítems del checklist, cada uno asociado a una categoría. El seed
-- (25 filas, texto exacto del Anexo N°3) se aplica vía MERGE idempotente en
-- migrations/repeatable/R__denuncias_seeds.sql.
-- =============================================================================
IF OBJECT_ID('[denuncias].[cat_factor_riesgo_nna]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[cat_factor_riesgo_nna] (
        id_factor_riesgo_nna           INTEGER NOT NULL IDENTITY(1,1),
        id_categoria_factor_riesgo_nna INTEGER NOT NULL,
        codigo                         NVARCHAR(60) NOT NULL,
        nombre                         NVARCHAR(150) NOT NULL,
        descripcion                    NVARCHAR(400) NOT NULL,
        orden                          INTEGER NULL,
        es_activo                     BIT NOT NULL CONSTRAINT df_cat_factor_riesgo_nna_es_activo DEFAULT (1),
        CONSTRAINT pk_cat_factor_riesgo_nna
            PRIMARY KEY (id_factor_riesgo_nna),
        CONSTRAINT uq_cat_factor_riesgo_nna_codigo
            UNIQUE (codigo),
        CONSTRAINT fk_cat_factor_riesgo_nna_categoria
            FOREIGN KEY (id_categoria_factor_riesgo_nna) REFERENCES denuncias.cat_categoria_factor_riesgo_nna (id_categoria_factor_riesgo_nna)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_cat_factor_riesgo_nna_categoria' AND object_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'))
    CREATE INDEX ix_cat_factor_riesgo_nna_categoria ON denuncias.cat_factor_riesgo_nna (id_categoria_factor_riesgo_nna);
GO


-- =============================================================================
-- BLOQUE 6 — denuncias.pauta_nna_factor_riesgo (respuestas del checklist)
-- =============================================================================
-- Una fila por (pauta_nna, factor_riesgo_nna) respondida. respuesta usa CHECK
-- de dominio cerrado (SI/NO/NO_SABE) en vez de catálogo aparte: es un valor
-- fijo de 3 estados que no requiere administración ni crecerá.
-- =============================================================================
IF OBJECT_ID('[denuncias].[pauta_nna_factor_riesgo]', 'U') IS NULL
BEGIN
    CREATE TABLE [denuncias].[pauta_nna_factor_riesgo] (
        id_pauta_nna_factor_riesgo INTEGER NOT NULL IDENTITY(1,1),
        id_pauta_nna               INTEGER NOT NULL,
        id_factor_riesgo_nna       INTEGER NOT NULL,
        respuesta                  NVARCHAR(10) NULL,
        observaciones              NVARCHAR(500) NULL,
        fecha_creacion             DATETIME2(7) NOT NULL CONSTRAINT df_pauta_nna_factor_riesgo_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion        DATETIME2(7) NULL,
        CONSTRAINT pk_pauta_nna_factor_riesgo
            PRIMARY KEY (id_pauta_nna_factor_riesgo),
        CONSTRAINT fk_pauta_nna_factor_riesgo_pauta
            FOREIGN KEY (id_pauta_nna) REFERENCES denuncias.pauta_nna (id_pauta_nna),
        CONSTRAINT fk_pauta_nna_factor_riesgo_factor
            FOREIGN KEY (id_factor_riesgo_nna) REFERENCES denuncias.cat_factor_riesgo_nna (id_factor_riesgo_nna),
        CONSTRAINT uq_pauta_nna_factor_riesgo
            UNIQUE (id_pauta_nna, id_factor_riesgo_nna),
        CONSTRAINT ck_pauta_nna_factor_riesgo_respuesta
            CHECK (respuesta IN ('SI','NO','NO_SABE'))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_pauta_nna_factor_riesgo_pauta' AND object_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'))
    CREATE INDEX ix_pauta_nna_factor_riesgo_pauta ON denuncias.pauta_nna_factor_riesgo (id_pauta_nna);
GO


-- =============================================================================
-- BLOQUE 7 — Nuevos roles en casos.cat_tipo_rol_persona (estructura)
-- =============================================================================
-- Solo se valida aquí que la tabla exista (creada en V0001). El seed de las
-- filas ACOMPANANTE_NNA / ADULTO_PROTECTOR_NNA / AGRESOR_NNA se aplica vía
-- MERGE idempotente en migrations/repeatable/R__casos_seeds.sql (mismo
-- mecanismo usado para VICTIMA_NNA), para mantener un único punto de verdad
-- de los datos del catálogo.
-- =============================================================================


-- =============================================================================
-- BLOQUE 8 — DESCRIPCIONES EXTENDIDAS (MS_Description)
-- =============================================================================

-- ─── denuncias.cat_tipo_acompanamiento_nna ──────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de formas en que se presenta el NNA a denunciar (ej: acompañado por adulto, solo, derivado). Item del Anexo N°3 "Formulario de Factores de Riesgo NNA" (Ley 21.057).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'), N'id_tipo_acompanamiento_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del tipo de acompañamiento. Clave primaria autogenerada por el motor.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'COLUMN',@level2name=N'id_tipo_acompanamiento_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'), N'codigo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Código abreviado del tipo de acompañamiento, en mayúsculas. Inmutable una vez creado el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'COLUMN',@level2name=N'codigo';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'), N'nombre', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del tipo de acompañamiento para presentación en interfaces y reportes.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'COLUMN',@level2name=N'nombre';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'), N'orden', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Orden numérico de presentación del ítem en interfaces y reportes.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'COLUMN',@level2name=N'orden';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'), N'es_activo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indicador lógico de actividad del ítem. 1 = activo (admitido para nuevas pautas), 0 = inactivo (preserva trazabilidad histórica).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'COLUMN',@level2name=N'es_activo';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_acompanamiento_nna', N'CONSTRAINT', N'pk_cat_tipo_acompanamiento_nna'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Clave primaria autonumérica del catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'CONSTRAINT',@level2name=N'pk_cat_tipo_acompanamiento_nna';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_acompanamiento_nna', N'CONSTRAINT', N'uq_cat_tipo_acompanamiento_nna_codigo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Garantiza que el código del tipo de acompañamiento sea único en el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'CONSTRAINT',@level2name=N'uq_cat_tipo_acompanamiento_nna_codigo';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_acompanamiento_nna', N'CONSTRAINT', N'df_cat_tipo_acompanamiento_nna_es_activo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de es_activo: todo ítem nuevo nace activo (1).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_tipo_acompanamiento_nna_es_activo';
GO

-- ─── denuncias.cat_tipo_denunciante_nna ─────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de tipos de denunciante del Anexo N°3 (quién denuncia: el propio NNA o un adulto en su representación).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'), N'id_tipo_denunciante_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del tipo de denunciante. Clave primaria autogenerada por el motor.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'COLUMN',@level2name=N'id_tipo_denunciante_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'), N'codigo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Código abreviado del tipo de denunciante, en mayúsculas. Inmutable una vez creado el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'COLUMN',@level2name=N'codigo';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'), N'nombre', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del tipo de denunciante para presentación en interfaces y reportes.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'COLUMN',@level2name=N'nombre';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'), N'orden', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Orden numérico de presentación del ítem en interfaces y reportes.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'COLUMN',@level2name=N'orden';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'), N'es_activo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indicador lógico de actividad del ítem. 1 = activo (admitido para nuevas pautas), 0 = inactivo (preserva trazabilidad histórica).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'COLUMN',@level2name=N'es_activo';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_denunciante_nna', N'CONSTRAINT', N'pk_cat_tipo_denunciante_nna'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Clave primaria autonumérica del catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'CONSTRAINT',@level2name=N'pk_cat_tipo_denunciante_nna';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_denunciante_nna', N'CONSTRAINT', N'uq_cat_tipo_denunciante_nna_codigo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Garantiza que el código del tipo de denunciante sea único en el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'CONSTRAINT',@level2name=N'uq_cat_tipo_denunciante_nna_codigo';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_denunciante_nna', N'CONSTRAINT', N'df_cat_tipo_denunciante_nna_es_activo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de es_activo: todo ítem nuevo nace activo (1).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_tipo_denunciante_nna_es_activo';
GO

-- ─── personas.persona.edad_declarada ────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'personas.persona') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona'), N'edad_declarada', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Edad aproximada auto-reportada por la persona (o por quien la acompaña), usada cuando no se dispone de fecha_nacimiento exacta. No reemplaza fecha_nacimiento; ambas columnas conviven.',
        @level0type=N'SCHEMA',@level0name=N'personas',@level1type=N'TABLE',@level1name=N'persona',@level2type=N'COLUMN',@level2name=N'edad_declarada';
GO

-- ─── denuncias.pauta_nna ─────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Cabecera 1:1 (opcional) con denuncia o caso, con los campos propios del Anexo N°3 "Formulario de Factores de Riesgo NNA" (Ley 21.057) que no son responsabilidad de otro esquema. La identificación de víctima/acompañante/adulto protector/agresor se modela vía denuncias.denuncia_persona_rol, no aquí.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_pauta_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la pauta NNA. Clave primaria autogenerada por el motor.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_pauta_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_denuncia', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional a denuncias.denuncia. NULL si la pauta está asociada a un caso en vez de a una denuncia.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_denuncia';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_caso', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional a casos.caso. NULL si la pauta está asociada a una denuncia en vez de a un caso.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_caso';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'numero_parte_denuncia', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'N° de parte/denuncia policial asociado al formulario del Anexo N°3.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'numero_parte_denuncia';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'fecha_formulario', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fecha de aplicación del formulario del Anexo N°3.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'fecha_formulario';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_tipo_acompanamiento_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_tipo_acompanamiento_nna: cómo se presenta el NNA en la denuncia.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_tipo_acompanamiento_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_tipo_denunciante_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_tipo_denunciante_nna: quién denuncia (el NNA o un adulto en su representación).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_tipo_denunciante_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'delito_aparente', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Descripción del delito aparente informado en el formulario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'delito_aparente';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'observaciones', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Observaciones libres registradas por el funcionario al aplicar el formulario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'observaciones';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_funcionario_registra', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK obligatoria a organizacion.funcionario: quién registró la pauta.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_funcionario_registra';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'fecha_creacion', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fecha/hora UTC de creación del registro. Asignada por el motor via SYSUTCDATETIME().',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'fecha_creacion';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'fecha_actualizacion', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fecha/hora UTC de la última actualización del registro. NULL si nunca se ha modificado.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'fecha_actualizacion';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_usuario_creador', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK obligatoria a auth.usuario: quién creó el registro.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_usuario_creador';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_usuario_modificador', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional a auth.usuario: quién realizó la última modificación. NULL si nunca se ha modificado.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_usuario_modificador';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'id_usuario_eliminador', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional a auth.usuario: quién realizó la baja lógica. NULL si el registro no ha sido eliminado.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'id_usuario_eliminador';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'fecha_eliminacion_logica', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fecha/hora UTC de baja lógica del registro. NULL si el registro está vigente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'fecha_eliminacion_logica';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'pk_pauta_nna'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Clave primaria autonumérica de la pauta NNA.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'pk_pauta_nna';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_tipo_acompanamiento'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_tipo_acompanamiento_nna: cómo se presenta el NNA en la denuncia.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_tipo_acompanamiento';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_tipo_denunciante'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_tipo_denunciante_nna: quién denuncia (el NNA o un adulto en su representación).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_tipo_denunciante';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_funcionario_registra'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a organizacion.funcionario: quién registró la pauta.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_funcionario_registra';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_usuario_creador'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK del bloque de auditoría estándar SIP: referencia a auth.usuario (usuario creador).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_usuario_creador';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_usuario_modificador'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK del bloque de auditoría estándar SIP: referencia a auth.usuario (usuario modificador).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_usuario_modificador';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_usuario_eliminador'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK del bloque de auditoría estándar SIP: referencia a auth.usuario (usuario eliminador).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_usuario_eliminador';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_fecha_creacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de fecha_creacion: red de seguridad para asegurar UTC aunque el procedimiento no la puebla explícitamente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_fecha_creacion';
GO

-- ─── denuncias.cat_categoria_factor_riesgo_nna ──────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de las 5 secciones del checklist del Anexo N°3 (Gravedad del delito, Factores asociados a la víctima, Contacto del Agresor con la víctima, Antecedentes del Agresor, Conducta del adulto protector/responsable/referente).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'), N'id_categoria_factor_riesgo_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la categoría de factor de riesgo. Clave primaria autogenerada por el motor.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'id_categoria_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'), N'codigo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Código abreviado de la categoría, en mayúsculas. Inmutable una vez creado el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'codigo';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'), N'nombre', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo de la categoría para presentación en interfaces y reportes.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'nombre';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'), N'orden', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Orden numérico de presentación de la sección en interfaces y reportes.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'orden';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'), N'es_activo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indicador lógico de actividad de la categoría. 1 = activo, 0 = inactivo (preserva trazabilidad histórica).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'es_activo';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_categoria_factor_riesgo_nna', N'CONSTRAINT', N'pk_cat_categoria_factor_riesgo_nna'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Clave primaria autonumérica del catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'pk_cat_categoria_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_categoria_factor_riesgo_nna', N'CONSTRAINT', N'uq_cat_categoria_factor_riesgo_nna_codigo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Garantiza que el código de la categoría sea único en el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'uq_cat_categoria_factor_riesgo_nna_codigo';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_categoria_factor_riesgo_nna', N'CONSTRAINT', N'df_cat_categoria_factor_riesgo_nna_es_activo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de es_activo: toda categoría nueva nace activa (1).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_categoria_factor_riesgo_nna_es_activo';
GO

-- ─── denuncias.cat_factor_riesgo_nna ─────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de los 25 ítems del checklist del Anexo N°3, cada uno asociado a una categoría (denuncias.cat_categoria_factor_riesgo_nna). Seed vía MERGE en R__denuncias_seeds.sql.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'id_factor_riesgo_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del ítem del checklist. Clave primaria autogenerada por el motor.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'id_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'id_categoria_factor_riesgo_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_categoria_factor_riesgo_nna: sección del Anexo N°3 a la que pertenece el ítem.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'id_categoria_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'codigo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Código abreviado del ítem, en mayúsculas. Inmutable una vez creado el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'codigo';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'nombre', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Etiqueta corta y presentable del ítem, derivada de descripcion, para uso en interfaces donde el texto completo del checklist es demasiado extenso.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'nombre';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'descripcion', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Texto exacto del ítem del checklist del Anexo N°3.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'descripcion';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'orden', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Orden numérico de presentación del ítem dentro de su categoría.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'orden';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'), N'es_activo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indicador lógico de actividad del ítem. 1 = activo, 0 = inactivo (preserva trazabilidad histórica).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'COLUMN',@level2name=N'es_activo';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_factor_riesgo_nna', N'CONSTRAINT', N'pk_cat_factor_riesgo_nna'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Clave primaria autonumérica del catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'pk_cat_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_factor_riesgo_nna', N'CONSTRAINT', N'uq_cat_factor_riesgo_nna_codigo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Garantiza que el código del ítem sea único en el catálogo.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'uq_cat_factor_riesgo_nna_codigo';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_factor_riesgo_nna', N'CONSTRAINT', N'fk_cat_factor_riesgo_nna_categoria'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_categoria_factor_riesgo_nna: sección del Anexo N°3 a la que pertenece el ítem.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_cat_factor_riesgo_nna_categoria';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_factor_riesgo_nna', N'CONSTRAINT', N'df_cat_factor_riesgo_nna_es_activo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de es_activo: todo ítem nuevo nace activo (1).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_factor_riesgo_nna_es_activo';
GO

-- ─── denuncias.pauta_nna_factor_riesgo ───────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Respuesta (SI/NO/NO_SABE) y observación para cada ítem del checklist del Anexo N°3, por pauta_nna.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'id_pauta_nna_factor_riesgo', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la respuesta. Clave primaria autogenerada por el motor.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'id_pauta_nna_factor_riesgo';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'id_pauta_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.pauta_nna: pauta a la que pertenece esta respuesta.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'id_pauta_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'id_factor_riesgo_nna', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_factor_riesgo_nna: ítem del checklist respondido.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'id_factor_riesgo_nna';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'respuesta', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Respuesta al ítem del checklist. Dominio cerrado: SI, NO, NO_SABE.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'respuesta';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'observaciones', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Observación libre asociada a la respuesta del ítem.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'observaciones';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'fecha_creacion', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fecha/hora UTC de creación del registro. Asignada por el motor via SYSUTCDATETIME().',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'fecha_creacion';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'), N'fecha_actualizacion', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fecha/hora UTC de la última actualización del registro. NULL si nunca se ha modificado.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'COLUMN',@level2name=N'fecha_actualizacion';
GO

-- ─── Restricciones e índices ─────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'CONSTRAINT', N'pk_pauta_nna_factor_riesgo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Clave primaria autonumérica de la respuesta.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'CONSTRAINT',@level2name=N'pk_pauta_nna_factor_riesgo';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'CONSTRAINT', N'fk_pauta_nna_factor_riesgo_pauta'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.pauta_nna: pauta a la que pertenece esta respuesta.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_factor_riesgo_pauta';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'CONSTRAINT', N'fk_pauta_nna_factor_riesgo_factor'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a denuncias.cat_factor_riesgo_nna: ítem del checklist respondido.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_factor_riesgo_factor';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'CONSTRAINT', N'df_pauta_nna_factor_riesgo_fecha_creacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de fecha_creacion: red de seguridad para asegurar UTC aunque el procedimiento no la puebla explícitamente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_factor_riesgo_fecha_creacion';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_denuncia'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional: pauta_nna.id_denuncia → denuncias.denuncia.id_denuncia.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_denuncia';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'fk_pauta_nna_caso'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional: pauta_nna.id_caso → casos.caso.id_caso.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'fk_pauta_nna_caso';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'INDEX', N'ix_pauta_nna_denuncia'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Índice filtrado (id_denuncia IS NOT NULL) para búsquedas de pauta_nna por denuncia.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'INDEX',@level2name=N'ix_pauta_nna_denuncia';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'INDEX', N'ix_pauta_nna_caso'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Índice filtrado (id_caso IS NOT NULL) para búsquedas de pauta_nna por caso.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'INDEX',@level2name=N'ix_pauta_nna_caso';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_factor_riesgo_nna', N'INDEX', N'ix_cat_factor_riesgo_nna_categoria'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Índice de soporte para el JOIN de cat_factor_riesgo_nna con su categoría.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'INDEX',@level2name=N'ix_cat_factor_riesgo_nna_categoria';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'INDEX', N'ix_pauta_nna_factor_riesgo_pauta'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Índice de soporte para listar las respuestas del checklist de una pauta_nna.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'INDEX',@level2name=N'ix_pauta_nna_factor_riesgo_pauta';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'CONSTRAINT', N'uq_pauta_nna_factor_riesgo'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Garantiza una única respuesta por combinación (pauta_nna, factor_riesgo_nna).',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'CONSTRAINT',@level2name=N'uq_pauta_nna_factor_riesgo';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna_factor_riesgo', N'CONSTRAINT', N'ck_pauta_nna_factor_riesgo_respuesta'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Restringe respuesta al dominio cerrado SI/NO/NO_SABE.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna_factor_riesgo',@level2type=N'CONSTRAINT',@level2name=N'ck_pauta_nna_factor_riesgo_respuesta';
GO
