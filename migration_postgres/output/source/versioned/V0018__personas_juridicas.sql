-- =============================================================================
-- V0017__personas_juridicas.sql
-- =============================================================================
-- Incorpora el concepto de PERSONA JURIDICA al esquema personas, refactor-
-- izando in-place la tabla raiz personas.persona para que sea un agregador
-- neutral entre persona NATURAL y persona JURIDICA.
--
-- ESTRATEGIA:
--   1. Crear catalogos nuevos (sin datos - los seeds van en R__).
--   2. Agregar columna id_tipo_persona a personas.persona con DEFAULT 1
--      (NATURAL) y FK al nuevo catalogo. El seed que crea la fila id=1
--      en cat_tipo_persona vive en R__personas_juridicas_seeds.sql; corre
--      despues de esta migration. No hay ventana operativa de fallo.
--   3. Crear personas.persona_natural con las columnas que hoy estan en
--      persona y son conceptualmente naturales.
--   4. Quitar de persona las columnas movidas (4 FKs + 2 CHECKs + 8 cols).
--      La base puede no tener datos transaccionales en persona; el SP
--      obtener_o_crear_persona se refactoriza en R__personas_programmability.
--   5. Crear persona_juridica enriquecida (constitucion / disolucion / pais).
--   6. Crear satélites de PJ: pj_nombre, pj_actividad_economica,
--      pj_representante_legal (con tipo de representacion y vigencia).
--   7. Crear indices unicos filtrados.
--   8. Extended properties de tablas nuevas y columna persona.id_tipo_persona.
--   9. Extended properties de las 8 columnas movidas a persona_natural
--      (recupera las descripciones institucionales que se perdieron al
--      hacer DROP COLUMN en el paso 4).
--  10. Extended properties de columnas nuevas (catalogos y transaccionales).
--
-- IMPORTANTE:
--   - NO toca las FKs entrantes a personas.persona: la PK no cambia, solo
--     se reorganizan columnas internas.
--   - Flyway envuelve la migration en su propia transaccion. Si algo falla,
--     hace ROLLBACK y marca la migration como failed.
--   - Patron DROP IF EXISTS / IF NOT EXISTS para idempotencia.
-- =============================================================================

SET XACT_ABORT ON;
GO


-- =============================================================================
-- PASO 1 - CATALOGOS NUEVOS
-- =============================================================================

-- 1.1 cat_tipo_persona  (NATURAL | JURIDICA)
IF OBJECT_ID(N'personas.cat_tipo_persona', N'U') IS NULL
BEGIN
    CREATE TABLE personas.cat_tipo_persona (
        id_tipo_persona  INT          IDENTITY(1,1) NOT NULL,
        codigo           NVARCHAR(20) NOT NULL,
        descripcion      NVARCHAR(100) NOT NULL,
        activo           SMALLINT     NOT NULL CONSTRAINT df_cat_tipo_persona_activo DEFAULT 1,
        CONSTRAINT pk_cat_tipo_persona     PRIMARY KEY CLUSTERED (id_tipo_persona),
        CONSTRAINT uq_cat_tipo_persona_cod UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_tipo_persona_cod CHECK (codigo IN (N'NATURAL', N'JURIDICA')),
        CONSTRAINT ck_cat_tipo_persona_act CHECK (activo IN (0, 1))
    );
END
GO

-- 1.2 cat_tipo_nombre  (RAZON_SOCIAL | NOMBRE_FANTASIA)
IF OBJECT_ID(N'personas.cat_tipo_nombre', N'U') IS NULL
BEGIN
    CREATE TABLE personas.cat_tipo_nombre (
        id_tipo_nombre  INT          IDENTITY(1,1) NOT NULL,
        codigo          NVARCHAR(30) NOT NULL,
        descripcion     NVARCHAR(100) NOT NULL,
        activo          SMALLINT     NOT NULL CONSTRAINT df_cat_tipo_nombre_activo DEFAULT 1,
        CONSTRAINT pk_cat_tipo_nombre     PRIMARY KEY CLUSTERED (id_tipo_nombre),
        CONSTRAINT uq_cat_tipo_nombre_cod UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_tipo_nombre_act CHECK (activo IN (0, 1))
    );
END
GO

-- 1.3 cat_tipo_persona_juridica
IF OBJECT_ID(N'personas.cat_tipo_persona_juridica', N'U') IS NULL
BEGIN
    CREATE TABLE personas.cat_tipo_persona_juridica (
        id_tipo_persona_juridica INT          IDENTITY(1,1) NOT NULL,
        codigo                   NVARCHAR(20) NOT NULL,
        descripcion              NVARCHAR(200) NOT NULL,
        activo                   SMALLINT     NOT NULL CONSTRAINT df_cat_tipo_pj_activo DEFAULT 1,
        CONSTRAINT pk_cat_tipo_persona_juridica     PRIMARY KEY CLUSTERED (id_tipo_persona_juridica),
        CONSTRAINT uq_cat_tipo_persona_juridica_cod UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_tipo_persona_juridica_act CHECK (activo IN (0, 1))
    );
END
GO

-- 1.4 cat_actividad_economica  (CIIU rev.4)
IF OBJECT_ID(N'personas.cat_actividad_economica', N'U') IS NULL
BEGIN
    CREATE TABLE personas.cat_actividad_economica (
        id_actividad_economica INT          IDENTITY(1,1) NOT NULL,
        codigo                 NVARCHAR(20) NOT NULL,
        descripcion            NVARCHAR(300) NOT NULL,
        activo                 SMALLINT     NOT NULL CONSTRAINT df_cat_act_eco_activo DEFAULT 1,
        CONSTRAINT pk_cat_actividad_economica     PRIMARY KEY CLUSTERED (id_actividad_economica),
        CONSTRAINT uq_cat_actividad_economica_cod UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_actividad_economica_act CHECK (activo IN (0, 1))
    );
END
GO

-- 1.5 cat_tipo_representacion
IF OBJECT_ID(N'personas.cat_tipo_representacion', N'U') IS NULL
BEGIN
    CREATE TABLE personas.cat_tipo_representacion (
        id_tipo_representacion INT          IDENTITY(1,1) NOT NULL,
        codigo                 NVARCHAR(30) NOT NULL,
        descripcion            NVARCHAR(200) NOT NULL,
        activo                 SMALLINT     NOT NULL CONSTRAINT df_cat_tipo_rep_activo DEFAULT 1,
        CONSTRAINT pk_cat_tipo_representacion     PRIMARY KEY CLUSTERED (id_tipo_representacion),
        CONSTRAINT uq_cat_tipo_representacion_cod UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_tipo_representacion_act CHECK (activo IN (0, 1))
    );
END
GO


-- =============================================================================
-- PASO 2 - AGREGAR id_tipo_persona A personas.persona
-- =============================================================================

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'personas.persona')
      AND name = N'id_tipo_persona'
)
    ALTER TABLE personas.persona
        ADD id_tipo_persona INT NOT NULL
            CONSTRAINT df_persona_tipo DEFAULT 1;  -- 1 = NATURAL
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'fk_persona_tipo'
      AND parent_object_id = OBJECT_ID(N'personas.persona')
)
    ALTER TABLE personas.persona
        ADD CONSTRAINT fk_persona_tipo
            FOREIGN KEY (id_tipo_persona)
            REFERENCES personas.cat_tipo_persona (id_tipo_persona);
GO


-- =============================================================================
-- PASO 3 - CREAR personas.persona_natural
-- =============================================================================

IF OBJECT_ID(N'personas.persona_natural', N'U') IS NULL
BEGIN
    CREATE TABLE personas.persona_natural (
        id_persona_natural    INT          IDENTITY(1,1) NOT NULL,
        id_persona            INT          NOT NULL,

        fecha_nacimiento      DATE         NULL,
        fecha_defuncion       DATE         NULL,
        id_sexo               INT          NULL,
        id_genero             INT          NULL,
        id_pais_nacionalidad  INT          NULL,
        id_comuna_nacimiento  INT          NULL,
        es_identificable      SMALLINT     NOT NULL CONSTRAINT df_pn_es_identificable     DEFAULT 1,
        domicilio_extranjero  SMALLINT     NOT NULL CONSTRAINT df_pn_domicilio_extranjero DEFAULT 0,

        fecha_registro        DATETIME2(7) NOT NULL CONSTRAINT df_pn_fecha_registro DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion   DATETIME2(7) NULL,
        fecha_eliminacion     DATETIME2(7) NULL,

        CONSTRAINT pk_persona_natural         PRIMARY KEY CLUSTERED (id_persona_natural),
        CONSTRAINT uq_persona_natural_persona UNIQUE NONCLUSTERED (id_persona),
        CONSTRAINT fk_pn_persona              FOREIGN KEY (id_persona)
            REFERENCES personas.persona (id_persona),
        CONSTRAINT fk_pn_sexo                 FOREIGN KEY (id_sexo)
            REFERENCES personas.cat_sexo (id_sexo),
        CONSTRAINT fk_pn_genero               FOREIGN KEY (id_genero)
            REFERENCES personas.cat_genero (id_genero),
        CONSTRAINT fk_pn_pais_nacionalidad    FOREIGN KEY (id_pais_nacionalidad)
            REFERENCES ubicacion.pais (id_pais),
        CONSTRAINT fk_pn_comuna_nacimiento    FOREIGN KEY (id_comuna_nacimiento)
            REFERENCES ubicacion.comuna (id_comuna),
        CONSTRAINT ck_pn_es_identificable     CHECK (es_identificable IN (0, 1)),
        CONSTRAINT ck_pn_domicilio_extranjero CHECK (domicilio_extranjero IN (0, 1)),
        CONSTRAINT ck_pn_defuncion            CHECK (fecha_defuncion IS NULL
                                                     OR fecha_defuncion >= fecha_nacimiento)
    );
END
GO


-- =============================================================================
-- PASO 4 - REMOVER COLUMNAS NATURALES DE personas.persona
-- =============================================================================

-- 4.1 Dropear FKs salientes (4)
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS fk_persona_sexo;
GO
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS fk_persona_genero;
GO
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS fk_persona_pais;
GO
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS fk_persona_comuna_nac;
GO

-- 4.2 Dropear CHECK constraints (2)
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS ck_persona_es_identificable;
GO
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS ck_persona_domicilio_extranjero;
GO

-- 4.3 Dropear DEFAULT constraints de las columnas a eliminar
-- (solo es_identificable y domicilio_extranjero tienen DEFAULT;
--  las otras 6 columnas no tienen).
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS df_persona_es_identificable;
GO
ALTER TABLE personas.persona DROP CONSTRAINT IF EXISTS df_persona_domicilio_extranjero;
GO

-- 4.4 Dropear las 8 columnas
ALTER TABLE personas.persona DROP COLUMN IF EXISTS fecha_nacimiento;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS fecha_defuncion;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS id_sexo;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS id_genero;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS id_pais_nacionalidad;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS id_comuna_nacimiento;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS es_identificable;
GO
ALTER TABLE personas.persona DROP COLUMN IF EXISTS domicilio_extranjero;
GO


-- =============================================================================
-- PASO 5 - CREAR personas.persona_juridica
-- =============================================================================

IF OBJECT_ID(N'personas.persona_juridica', N'U') IS NULL
BEGIN
    CREATE TABLE personas.persona_juridica (
        id_persona_juridica      INT          IDENTITY(1,1) NOT NULL,
        id_persona               INT          NOT NULL,
        id_tipo_persona_juridica INT          NOT NULL,

        fecha_constitucion       DATE         NULL,
        fecha_disolucion         DATE         NULL,
        id_pais_constitucion     INT          NULL,

        fecha_registro           DATETIME2(7) NOT NULL CONSTRAINT df_pj_fecha_registro DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion      DATETIME2(7) NULL,
        fecha_eliminacion        DATETIME2(7) NULL,

        CONSTRAINT pk_persona_juridica         PRIMARY KEY CLUSTERED (id_persona_juridica),
        CONSTRAINT uq_persona_juridica_persona UNIQUE NONCLUSTERED (id_persona),
        CONSTRAINT fk_pj_persona               FOREIGN KEY (id_persona)
            REFERENCES personas.persona (id_persona),
        CONSTRAINT fk_pj_tipo                  FOREIGN KEY (id_tipo_persona_juridica)
            REFERENCES personas.cat_tipo_persona_juridica (id_tipo_persona_juridica),
        CONSTRAINT fk_pj_pais_constitucion     FOREIGN KEY (id_pais_constitucion)
            REFERENCES ubicacion.pais (id_pais),
        CONSTRAINT ck_pj_disolucion            CHECK (fecha_disolucion IS NULL
                                                      OR fecha_disolucion >= fecha_constitucion)
    );
END
GO


-- =============================================================================
-- PASO 6 - SATELITES DE PERSONA JURIDICA
-- =============================================================================

-- 6.1 pj_nombre (razon social / nombre de fantasia)
IF OBJECT_ID(N'personas.pj_nombre', N'U') IS NULL
BEGIN
    CREATE TABLE personas.pj_nombre (
        id_pj_nombre        INT          IDENTITY(1,1) NOT NULL,
        id_persona_juridica INT          NOT NULL,
        id_tipo_nombre      INT          NOT NULL,
        nombre              NVARCHAR(300) NOT NULL,

        fecha_registro      DATETIME2(7) NOT NULL CONSTRAINT df_pjn_fecha_registro DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion DATETIME2(7) NULL,
        fecha_eliminacion   DATETIME2(7) NULL,

        CONSTRAINT pk_pj_nombre            PRIMARY KEY CLUSTERED (id_pj_nombre),
        CONSTRAINT fk_pjn_persona_juridica FOREIGN KEY (id_persona_juridica)
            REFERENCES personas.persona_juridica (id_persona_juridica),
        CONSTRAINT fk_pjn_tipo_nombre      FOREIGN KEY (id_tipo_nombre)
            REFERENCES personas.cat_tipo_nombre (id_tipo_nombre)
    );
END
GO

-- 6.2 pj_actividad_economica (M:N con es_principal + columna calculada para "una sola principal activa")
IF OBJECT_ID(N'personas.pj_actividad_economica', N'U') IS NULL
BEGIN
    CREATE TABLE personas.pj_actividad_economica (
        id_pj_actividad        INT          IDENTITY(1,1) NOT NULL,
        id_persona_juridica    INT          NOT NULL,
        id_actividad_economica INT          NOT NULL,
        es_principal           SMALLINT     NOT NULL CONSTRAINT df_pjae_es_principal DEFAULT 0,

        fecha_registro         DATETIME2(7) NOT NULL CONSTRAINT df_pjae_fecha_registro DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion    DATETIME2(7) NULL,
        fecha_eliminacion      DATETIME2(7) NULL,


        CONSTRAINT pk_pj_actividad_economica PRIMARY KEY CLUSTERED (id_pj_actividad),
        CONSTRAINT fk_pjae_persona_juridica  FOREIGN KEY (id_persona_juridica)
            REFERENCES personas.persona_juridica (id_persona_juridica),
        CONSTRAINT fk_pjae_actividad         FOREIGN KEY (id_actividad_economica)
            REFERENCES personas.cat_actividad_economica (id_actividad_economica),
        CONSTRAINT ck_pjae_es_principal      CHECK (es_principal IN (0, 1))
    );
END
GO

-- 6.3 pj_representante_legal (con tipo y vigencia)
IF OBJECT_ID(N'personas.pj_representante_legal', N'U') IS NULL
BEGIN
    CREATE TABLE personas.pj_representante_legal (
        id_pj_representante    INT          IDENTITY(1,1) NOT NULL,
        id_persona_juridica    INT          NOT NULL,
        id_persona_natural     INT          NOT NULL,
        id_tipo_representacion INT          NOT NULL,
        fecha_inicio_vigencia  DATE         NOT NULL,
        fecha_fin_vigencia     DATE         NULL,   -- NULL = vigente
        observaciones          NVARCHAR(500) NULL,

        fecha_registro         DATETIME2(7) NOT NULL CONSTRAINT df_pjrl_fecha_registro DEFAULT SYSUTCDATETIME(),
        fecha_actualizacion    DATETIME2(7) NULL,
        fecha_eliminacion      DATETIME2(7) NULL,

        CONSTRAINT pk_pj_representante_legal   PRIMARY KEY CLUSTERED (id_pj_representante),
        CONSTRAINT fk_pjrl_persona_juridica    FOREIGN KEY (id_persona_juridica)
            REFERENCES personas.persona_juridica (id_persona_juridica),
        CONSTRAINT fk_pjrl_persona_natural     FOREIGN KEY (id_persona_natural)
            REFERENCES personas.persona_natural (id_persona_natural),
        CONSTRAINT fk_pjrl_tipo_representacion FOREIGN KEY (id_tipo_representacion)
            REFERENCES personas.cat_tipo_representacion (id_tipo_representacion),
        CONSTRAINT ck_pjrl_vigencia            CHECK (fecha_fin_vigencia IS NULL
                                                      OR fecha_fin_vigencia >= fecha_inicio_vigencia)
    );
END
GO


-- =============================================================================
-- PASO 7 - INDICES UNICOS FILTRADOS
-- =============================================================================

-- 7.1 pj_nombre: maximo un registro activo de cada tipo por PJ
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ux_pjn_tipo_activo'
      AND object_id = OBJECT_ID(N'personas.pj_nombre')
)
    CREATE UNIQUE NONCLUSTERED INDEX ux_pjn_tipo_activo
        ON personas.pj_nombre (id_persona_juridica, id_tipo_nombre)
        WHERE fecha_eliminacion IS NULL;
GO

-- 7.2 pj_actividad_economica: no duplicar la misma actividad activa por PJ
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ux_pjae_actividad_activa'
      AND object_id = OBJECT_ID(N'personas.pj_actividad_economica')
)
    CREATE UNIQUE NONCLUSTERED INDEX ux_pjae_actividad_activa
        ON personas.pj_actividad_economica (id_persona_juridica, id_actividad_economica)
        WHERE fecha_eliminacion IS NULL;
GO

-- 7.3 (eliminado) - La unicidad de "es_principal=1 activa por PJ" se aplica
-- via el SP personas.agregar_pj_actividad_economica (ver
-- R__personas_juridicas_programmability.sql). SQL Server no permite indices
-- filtrados sobre columnas calculadas (Msg 10609), por eso se opto por
-- enforcement aplicativo en lugar de declarativo.

-- 7.3 pj_representante_legal: no repetir (PJ, persona natural, tipo) activo
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ux_pjrl_activo'
      AND object_id = OBJECT_ID(N'personas.pj_representante_legal')
)
    CREATE UNIQUE NONCLUSTERED INDEX ux_pjrl_activo
        ON personas.pj_representante_legal
            (id_persona_juridica, id_persona_natural, id_tipo_representacion)
        WHERE fecha_eliminacion IS NULL;
GO


-- =============================================================================
-- PASO 8 - EXTENDED PROPERTIES
-- =============================================================================
-- Descripciones de las tablas y columnas nuevas. Envueltas en IF NOT EXISTS
-- para que la migration sea idempotente.

-- 8.1 cat_tipo_persona
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Catalogo de tipo de persona: NATURAL (persona fisica) o JURIDICA (entidad con personalidad legal propia, como empresas).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona';
GO

-- 8.2 cat_tipo_nombre
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_nombre') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Catalogo de tipos de nombre para personas juridicas: RAZON_SOCIAL (nombre legal oficial) o NOMBRE_FANTASIA (nombre comercial publico).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_nombre';
GO

-- 8.3 cat_tipo_persona_juridica
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona_juridica') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Catalogo de tipos de persona juridica (estructura societaria): SA, SpA, EIRL, Cooperativa, Fundacion, Ministerio, etc.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona_juridica';
GO

-- 8.4 cat_actividad_economica
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_actividad_economica') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Catalogo de actividades economicas. Basado en CIIU rev.4. Codigo es el identificador estandar de cada actividad.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_actividad_economica';
GO

-- 8.5 cat_tipo_representacion
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_representacion') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Catalogo de tipos de representacion legal de una persona juridica: REP_LEGAL, GERENTE_GENERAL, APODERADO, etc.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_representacion';
GO

-- 8.6 persona.id_tipo_persona
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona'), N'id_tipo_persona', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a cat_tipo_persona. Discrimina si la persona es NATURAL o JURIDICA. DEFAULT 1 (NATURAL).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona',
        @level2type = N'COLUMN', @level2name = N'id_tipo_persona';
GO

-- 8.7 persona_natural
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Atributos especificos de personas naturales (fisicas). Relacion 1:1 con personas.persona via id_persona.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural';
GO

-- 8.8 persona_juridica
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Atributos especificos de personas juridicas (empresas, organismos, etc). Relacion 1:1 con personas.persona via id_persona.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica';
GO

-- 8.9 pj_nombre
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Nombres de una persona juridica. Cada PJ puede tener un nombre por tipo (razon social, nombre de fantasia).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre';
GO

-- 8.10 pj_actividad_economica
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Actividades economicas asociadas a una persona juridica. Relacion M:N con cat_actividad_economica. Una sola puede ser principal activa por PJ.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica';
GO

-- 8.11 pj_representante_legal
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Representantes legales de una persona juridica. Relacion entre PJ y persona natural con tipo de representacion y vigencia temporal.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal';
GO


-- =============================================================================
-- PASO 9 - EXTENDED PROPERTIES DE COLUMNAS MOVIDAS A persona_natural
-- =============================================================================
-- Las 8 columnas que se movieron de personas.persona a personas.persona_natural
-- tenian descripciones documentadas. Se reponen aqui con sus textos
-- institucionales originales.

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'fecha_nacimiento', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de nacimiento de la persona. Opcional - puede ser desconocida en personas NN o extranjeras sin documento.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'fecha_nacimiento';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'fecha_defuncion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de defuncion de la persona. Se registra cuando existe constancia oficial del fallecimiento. Campo opcional.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'fecha_defuncion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'id_sexo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Sexo biologico registral de la persona. FK a personas.cat_sexo. Valores: MASCULINO, FEMENINO, INDETERMINADO.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'id_sexo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'id_genero', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Identidad de genero de la persona, independiente del sexo registral. FK a personas.cat_genero.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'id_genero';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'id_pais_nacionalidad', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Pais de nacionalidad de la persona. FK a ubicacion.pais.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'id_pais_nacionalidad';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'id_comuna_nacimiento', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Comuna de nacimiento de la persona dentro del territorio nacional. FK a ubicacion.comuna. Campo opcional.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'id_comuna_nacimiento';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'es_identificable', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Indica si la persona ha sido formalmente identificada. Valor 0 = persona NN (no identificada), registrada con datos parciales o descripcion fisica. Valor 1 = persona identificada con documento valido.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'es_identificable';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'domicilio_extranjero', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Indica si el domicilio principal de la persona se encuentra fuera del territorio nacional. Valor 1 = domicilio en el extranjero. Relevante para procesos de extradicion y cooperacion internacional.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'domicilio_extranjero';
GO

-- =============================================================================
-- PASO 10 - EXTENDED PROPERTIES DE COLUMNAS NUEVAS
-- =============================================================================
-- Documenta las columnas nuevas de los catalogos y de las tablas de PJ.
-- Solo se incluyen aquellas cuya descripcion es derivable del nombre + tipo +
-- constraints. Las que requieren contexto institucional (fecha_constitucion,
-- fecha_disolucion, nombre, observaciones) NO se incluyen
-- y quedan pendientes para validacion con PDI.

-- ---------------------------------------------------------------------------
-- 10.1  Columnas de catalogos
-- ---------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_persona'), N'codigo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Codigo corto del tipo de persona. Unico. Valores: NATURAL, JURIDICA.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_persona'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Descripcion del tipo de persona para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_persona'), N'activo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_nombre'), N'codigo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Codigo corto del tipo de nombre. Unico. Valores: RAZON_SOCIAL, NOMBRE_FANTASIA.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_nombre',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_nombre'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Descripcion del tipo de nombre para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_nombre',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_nombre'), N'activo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_nombre',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_persona_juridica'), N'codigo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Codigo corto del tipo de persona juridica. Unico. Estable para integraciones.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona_juridica',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_persona_juridica'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Descripcion del tipo de persona juridica para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona_juridica',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_persona_juridica'), N'activo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_persona_juridica',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_actividad_economica'), N'codigo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Codigo de la actividad economica. Unico. CIIU rev.4.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_actividad_economica'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Descripcion de la actividad economica para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_actividad_economica'), N'activo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_representacion')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_representacion'), N'codigo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Codigo corto del tipo de representacion. Unico. Estable para integraciones.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_representacion',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_representacion')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_representacion'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Descripcion del tipo de representacion para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_representacion',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.cat_tipo_representacion')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.cat_tipo_representacion'), N'activo', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'cat_tipo_representacion',
        @level2type = N'COLUMN', @level2name = N'activo';
GO


-- ---------------------------------------------------------------------------
-- 10.2  Columnas de tablas transaccionales (persona_natural, persona_juridica,
--       satelites). Las 8 columnas movidas a persona_natural estan en PASO 9.
-- ---------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'id_persona_natural', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Identificador unico de la persona natural. Clave primaria.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'id_persona_natural';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'id_persona', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a personas.persona. Relacion 1:1 con la entidad raiz.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'id_persona';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'fecha_registro', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creacion del registro. Valor por defecto: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'fecha_actualizacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de la ultima actualizacion del registro.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_natural')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_natural'), N'fecha_eliminacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de baja logica del registro (soft-delete). NULL = vigente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_natural',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'id_persona_juridica', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Identificador unico de la persona juridica. Clave primaria.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'id_persona_juridica';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'id_persona', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a personas.persona. Relacion 1:1 con la entidad raiz.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'id_persona';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'id_tipo_persona_juridica', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a cat_tipo_persona_juridica. Estructura societaria (SA, SpA, EIRL, etc.).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'id_tipo_persona_juridica';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'id_pais_constitucion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a ubicacion.pais. Pais donde la persona juridica fue constituida legalmente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'id_pais_constitucion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'fecha_registro', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creacion del registro. Valor por defecto: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'fecha_actualizacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de la ultima actualizacion del registro.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.persona_juridica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.persona_juridica'), N'fecha_eliminacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de baja logica del registro (soft-delete). NULL = vigente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'persona_juridica',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_nombre'), N'id_pj_nombre', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Identificador unico del nombre. Clave primaria.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre',
        @level2type = N'COLUMN', @level2name = N'id_pj_nombre';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_nombre'), N'id_persona_juridica', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a personas.persona_juridica.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre',
        @level2type = N'COLUMN', @level2name = N'id_persona_juridica';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_nombre'), N'id_tipo_nombre', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a cat_tipo_nombre. RAZON_SOCIAL o NOMBRE_FANTASIA.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre',
        @level2type = N'COLUMN', @level2name = N'id_tipo_nombre';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_nombre'), N'fecha_registro', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creacion del registro. Valor por defecto: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_nombre'), N'fecha_actualizacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de la ultima actualizacion del registro.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_nombre')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_nombre'), N'fecha_eliminacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de baja logica del registro (soft-delete). NULL = vigente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_nombre',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'id_pj_actividad', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Identificador unico del vinculo PJ-actividad. Clave primaria.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'id_pj_actividad';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'id_persona_juridica', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a personas.persona_juridica.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'id_persona_juridica';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'id_actividad_economica', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a cat_actividad_economica. Codigo CIIU.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'id_actividad_economica';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'es_principal', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'1 = actividad economica principal de la persona juridica. 0 = actividad secundaria. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'es_principal';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'fecha_registro', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creacion del registro. Valor por defecto: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'fecha_actualizacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de la ultima actualizacion del registro.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_actividad_economica')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_actividad_economica'), N'fecha_eliminacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de baja logica del registro (soft-delete). NULL = vigente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_actividad_economica',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'id_pj_representante', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Identificador unico del vinculo PJ-representante. Clave primaria.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'id_pj_representante';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'id_persona_juridica', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a personas.persona_juridica.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'id_persona_juridica';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'id_persona_natural', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a personas.persona_natural. La persona fisica que ejerce la representacion.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'id_persona_natural';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'id_tipo_representacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'FK a cat_tipo_representacion. Tipo de representacion legal (REP_LEGAL, GERENTE_GENERAL, etc.).',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'id_tipo_representacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'fecha_inicio_vigencia', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha desde la cual la representacion esta vigente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'fecha_inicio_vigencia';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'fecha_fin_vigencia', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha hasta la cual la representacion esta vigente. NULL = vigente indefinidamente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'fecha_fin_vigencia';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'fecha_registro', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de creacion del registro. Valor por defecto: SYSUTCDATETIME().',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'fecha_actualizacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha y hora UTC de la ultima actualizacion del registro.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'personas.pj_representante_legal')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'personas.pj_representante_legal'), N'fecha_eliminacion', 'ColumnId')
      AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = N'Fecha de baja logica del registro (soft-delete). NULL = vigente.',
        @level0type = N'SCHEMA', @level0name = N'personas',
        @level1type = N'TABLE',  @level1name = N'pj_representante_legal',
        @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

