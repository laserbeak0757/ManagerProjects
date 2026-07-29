-- =========================================================================
-- V0016__lugar_general_hecho.sql
-- =========================================================================
-- Reemplaza los catalogos denuncias.cat_lugar_recepcion_denuncia y
-- denuncias.cat_detalle_lugar_recepcion_denuncia (que conceptualmente
-- representan el lugar de recepcion de la denuncia) por dos catalogos
-- nuevos en el esquema investigacion que clasifican el lugar general del
-- hecho:
--   investigacion.cat_lugar_general_hecho         (padre)
--   investigacion.cat_detalle_lugar_general_hecho (hijo)
--
-- Operaciones:
--   PARTE A - DROP de objetos dependientes (SPs, TVFs, FK, columna, tablas)
--   PARTE B - CREATE de los catalogos nuevos en investigacion
--   PARTE C - ADD de la FK desde investigacion.hecho hacia el nuevo detalle
--   PARTE D - Extended properties de los catalogos nuevos
--
-- Los modulos programables (TVFs + SPs) de acceso a los catalogos van en
-- R__investigacion_programmability.sql (repeatable migration).
--
-- Notas:
--   - Los catalogos nuevos NO heredan datos de los viejos (decision: son
--     catalogos nuevos, no renombrados). Su poblamiento ira en un R__.
--   - Patron idempotente con IF EXISTS / IF NOT EXISTS.
--   - Convencion del modelo: SMALLINT para flags, no BIT.
-- =========================================================================

SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
GO

-- =========================================================================
-- PARTE A - DROP de objetos dependientes
-- =========================================================================

-- A.1 Stored procedures
IF OBJECT_ID(N'denuncias.get_detalle_lugar_recepcion_denuncia', N'P') IS NOT NULL
    DROP PROCEDURE denuncias.get_detalle_lugar_recepcion_denuncia;
GO

IF OBJECT_ID(N'denuncias.get_lugar_recepcion_denuncia', N'P') IS NOT NULL
    DROP PROCEDURE denuncias.get_lugar_recepcion_denuncia;
GO

-- A.2 Table-valued functions
IF OBJECT_ID(N'denuncias.tvf_get_detalle_lugar_recepcion_denuncia', N'TF') IS NOT NULL
    DROP FUNCTION denuncias.tvf_get_detalle_lugar_recepcion_denuncia;
GO

IF OBJECT_ID(N'denuncias.tvf_get_lugar_recepcion_denuncia', N'TF') IS NOT NULL
    DROP FUNCTION denuncias.tvf_get_lugar_recepcion_denuncia;
GO

-- A.3 FK desde denuncia hacia el catalogo de detalle
IF EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'fk_denuncia_detalle_lugar_recepcion'
      AND parent_object_id = OBJECT_ID(N'denuncias.denuncia')
)
    ALTER TABLE denuncias.denuncia DROP CONSTRAINT fk_denuncia_detalle_lugar_recepcion;
GO

-- A.4 Columna en denuncia
IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE name = N'id_detalle_lugar_recepcion_denuncia'
      AND object_id = OBJECT_ID(N'denuncias.denuncia')
)
    ALTER TABLE denuncias.denuncia DROP COLUMN id_detalle_lugar_recepcion_denuncia;
GO

-- A.5 FK interna del catalogo (detalle -> padre)
IF EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'fk_cat_detalle_lugar_recepcion_lugar'
      AND parent_object_id = OBJECT_ID(N'denuncias.cat_detalle_lugar_recepcion_denuncia')
)
    ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
        DROP CONSTRAINT fk_cat_detalle_lugar_recepcion_lugar;
GO

-- A.6 Tabla de detalle (hija)
IF OBJECT_ID(N'denuncias.cat_detalle_lugar_recepcion_denuncia', N'U') IS NOT NULL
    DROP TABLE denuncias.cat_detalle_lugar_recepcion_denuncia;
GO

-- A.7 Tabla padre
IF OBJECT_ID(N'denuncias.cat_lugar_recepcion_denuncia', N'U') IS NOT NULL
    DROP TABLE denuncias.cat_lugar_recepcion_denuncia;
GO


-- =========================================================================
-- PARTE B - CREATE de catalogos nuevos en investigacion
-- =========================================================================

-- B.1 Padre: cat_lugar_general_hecho
IF OBJECT_ID(N'investigacion.cat_lugar_general_hecho', N'U') IS NULL
BEGIN
    CREATE TABLE investigacion.cat_lugar_general_hecho (
        id_lugar_general_hecho  INT             IDENTITY(1,1) NOT NULL,
        codigo                  NVARCHAR(20)    NOT NULL,
        descripcion             NVARCHAR(100)   NOT NULL,
        activo                  SMALLINT        NOT NULL CONSTRAINT df_cat_lugar_general_hecho_activo DEFAULT (1),
        CONSTRAINT pk_cat_lugar_general_hecho
            PRIMARY KEY CLUSTERED (id_lugar_general_hecho),
        CONSTRAINT uq_cat_lugar_general_hecho_codigo
            UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_lugar_general_hecho_activo
            CHECK (activo IN (0, 1))
    );
END
GO

-- B.2 Hijo: cat_detalle_lugar_general_hecho
IF OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho', N'U') IS NULL
BEGIN
    CREATE TABLE investigacion.cat_detalle_lugar_general_hecho (
        id_detalle_lugar_general_hecho  INT             IDENTITY(1,1) NOT NULL,
        id_lugar_general_hecho          INT             NOT NULL,
        codigo                          NVARCHAR(20)    NOT NULL,
        descripcion                     NVARCHAR(100)   NOT NULL,
        activo                          SMALLINT        NOT NULL CONSTRAINT df_cat_detalle_lugar_general_hecho_activo DEFAULT (1),
        CONSTRAINT pk_cat_detalle_lugar_general_hecho
            PRIMARY KEY CLUSTERED (id_detalle_lugar_general_hecho),
        CONSTRAINT uq_cat_detalle_lugar_general_hecho_codigo
            UNIQUE NONCLUSTERED (codigo),
        CONSTRAINT ck_cat_detalle_lugar_general_hecho_activo
            CHECK (activo IN (0, 1)),
        CONSTRAINT fk_cat_detalle_lugar_general_hecho_padre
            FOREIGN KEY (id_lugar_general_hecho)
            REFERENCES investigacion.cat_lugar_general_hecho (id_lugar_general_hecho)
    );
END
GO


-- =========================================================================
-- PARTE C - FK desde investigacion.hecho hacia el detalle
-- =========================================================================

-- C.1 Agregar columna en hecho
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE name = N'id_detalle_lugar_general_hecho'
      AND object_id = OBJECT_ID(N'investigacion.hecho')
)
    ALTER TABLE investigacion.hecho
        ADD id_detalle_lugar_general_hecho INT NULL;
GO

-- C.2 Crear FK
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'fk_hecho_detalle_lugar_general'
      AND parent_object_id = OBJECT_ID(N'investigacion.hecho')
)
    ALTER TABLE investigacion.hecho
        ADD CONSTRAINT fk_hecho_detalle_lugar_general
            FOREIGN KEY (id_detalle_lugar_general_hecho)
            REFERENCES investigacion.cat_detalle_lugar_general_hecho (id_detalle_lugar_general_hecho);
GO


-- =========================================================================
-- PARTE D - Extended properties de los catalogos nuevos
-- =========================================================================

-- D.1 Tabla padre
IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_lugar_general_hecho')
      AND minor_id = 0 AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Catalogo de clasificacion del lugar general donde ocurrio el hecho. Nivel padre (categoria amplia). El detalle especifico se modela en cat_detalle_lugar_general_hecho. No confundir con ubicacion.lugar (datos geograficos del sitio del suceso).',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_lugar_general_hecho';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_lugar_general_hecho'), N'codigo', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Codigo corto del lugar general del hecho. Unico. Estable para integraciones.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_lugar_general_hecho'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Descripcion del lugar general del hecho para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_lugar_general_hecho'), N'activo', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

-- D.2 Tabla hija
IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho')
      AND minor_id = 0 AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Catalogo de detalles del lugar general del hecho. Cada detalle pertenece a una categoria padre (FK a cat_lugar_general_hecho).',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_detalle_lugar_general_hecho';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'), N'id_lugar_general_hecho', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'FK al lugar padre. Determina bajo que categoria de lugar general se clasifica este detalle.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_detalle_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'id_lugar_general_hecho';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'), N'codigo', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Codigo corto del detalle. Unico en toda la tabla. Estable para integraciones.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_detalle_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'codigo';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'), N'descripcion', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Descripcion del detalle del lugar general del hecho para mostrar en UI.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_detalle_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'descripcion';
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'), N'activo', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'1 = vigente, disponible para seleccion. 0 = deshabilitado. CHECK IN (0,1).',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'cat_detalle_lugar_general_hecho',
        @level2type = N'COLUMN', @level2name = N'activo';
GO

-- D.3 Columna FK en investigacion.hecho
IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'investigacion.hecho')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'investigacion.hecho'), N'id_detalle_lugar_general_hecho', 'ColumnId')
      AND name = N'MS_Description'
)
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'FK a investigacion.cat_detalle_lugar_general_hecho. Clasificacion del lugar general donde ocurrio el hecho (categoria + detalle). El lugar padre se infiere navegando al catalogo de detalle. NULL en borradores o cuando no se ha clasificado aun.',
        @level0type = N'SCHEMA', @level0name = N'investigacion',
        @level1type = N'TABLE',  @level1name = N'hecho',
        @level2type = N'COLUMN', @level2name = N'id_detalle_lugar_general_hecho';
GO



COMMIT TRANSACTION;
GO
