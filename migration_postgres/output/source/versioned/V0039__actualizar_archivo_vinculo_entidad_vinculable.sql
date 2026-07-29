/* =============================================================================
    V0039 — Actualización de archivos: catálogo de entidades vinculables y
            normalización del discriminador de archivo_vinculo (ESTRUCTURA)
    PDI Chile — SIP. SQL Server. Flyway.

    Contexto
    El vínculo polimórfico usaba un discriminador de texto libre
    (esquema NVARCHAR(10) + entidad NVARCHAR(50)) sin integridad y con ancho
    insuficiente (esquema no admite nombres > 10, p. ej. 'diligencias').

    Cambios (solo estructura)
    - Crea archivos.cat_entidad_vinculable: catálogo de entidades vinculables
      (directorio esquema/entidad/PK). No lleva FK a los dominios (polimórfico).
    - Renombra la PK id_vinculo -> id_archivo_vinculo (convención PK = tabla).
    - Reemplaza (esquema, entidad) por id_entidad_vinculable (INT, FK al catálogo).
    - Reconstruye el UNIQUE y agrega índice de lookup compacto.

    El SEED del catálogo vive en el repetible R__archivos_seeds.sql (corre después
    de las versionadas). La programabilidad (SP validador, detector) en
    R__archivos_programmability.sql.

    Nota: esta migración asume archivo_vinculo sin datos por resolver. Si hubiera
    filas, el paso 4 aborta con THROW (el poblado dependería del seed, que es
    posterior; en ese caso los vínculos deben resolverse manualmente antes).

    Idempotente. Transacción por migración de Flyway. XACT_ABORT ON.
   ============================================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

/* -----------------------------------------------------------------------------
   1) Catálogo cat_entidad_vinculable (IDENTITY, patrón catálogo: 5 col. auditoría)
   ----------------------------------------------------------------------------- */
IF OBJECT_ID(N'archivos.cat_entidad_vinculable', N'U') IS NULL
BEGIN
    CREATE TABLE archivos.cat_entidad_vinculable (
        id_entidad_vinculable   INTEGER IDENTITY(1,1) NOT NULL,
        esquema                 SYSNAME NOT NULL,
        entidad                 SYSNAME NOT NULL,
        columna_pk              SYSNAME NOT NULL,
        activo                  BIT NOT NULL CONSTRAINT df_cat_entidad_vinculable_activo DEFAULT (1),
        id_usuario_modificador  INTEGER NULL,
        id_usuario_eliminador   INTEGER NULL,
        fecha_creacion          DATETIME2(7) NULL,
        fecha_actualizacion     DATETIME2(7) NULL,
        fecha_eliminacion_logica DATETIME2(7) NULL,
        CONSTRAINT pk_cat_entidad_vinculable PRIMARY KEY (id_entidad_vinculable),
        CONSTRAINT uq_cat_entidad_vinculable UNIQUE (esquema, entidad)
    );
END
GO

/* -----------------------------------------------------------------------------
   2) Renombrar la PK: id_vinculo -> id_archivo_vinculo (convención PK = tabla).
      sp_rename conserva IDENTITY y la PK; no recrea la tabla.
   ----------------------------------------------------------------------------- */
IF  COL_LENGTH(N'archivos.archivo_vinculo', N'id_vinculo') IS NOT NULL
AND COL_LENGTH(N'archivos.archivo_vinculo', N'id_archivo_vinculo') IS NULL
BEGIN
    EXEC sp_rename N'archivos.archivo_vinculo.id_vinculo', N'id_archivo_vinculo', N'COLUMN';
END
GO

/* -----------------------------------------------------------------------------
   3) Nueva columna id_entidad_vinculable (nullable de momento)
   ----------------------------------------------------------------------------- */
IF COL_LENGTH(N'archivos.archivo_vinculo', N'id_entidad_vinculable') IS NULL
    ALTER TABLE archivos.archivo_vinculo ADD id_entidad_vinculable INTEGER NULL;
GO

/* -----------------------------------------------------------------------------
   4) Seguridad: esta migración estructural asume la tabla sin datos por resolver.
      Si existieran vínculos (con columnas de texto aún presentes), abortar: deben
      resolverse manualmente porque el seed del catálogo es posterior (repetible).
   ----------------------------------------------------------------------------- */
IF COL_LENGTH(N'archivos.archivo_vinculo', N'entidad') IS NOT NULL
   AND EXISTS (SELECT 1 FROM archivos.archivo_vinculo)
BEGIN
    THROW 50039, N'V0039: archivo_vinculo tiene datos. Resolver id_entidad_vinculable antes de aplicar (el seed del catálogo corre como repetible, posterior a esta migración).', 1;
END
GO

/* -----------------------------------------------------------------------------
   5) id_entidad_vinculable NOT NULL (tabla vacía -> sin default necesario)
   ----------------------------------------------------------------------------- */
IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'archivos.archivo_vinculo')
      AND name = N'id_entidad_vinculable' AND is_nullable = 1
)
    ALTER TABLE archivos.archivo_vinculo ALTER COLUMN id_entidad_vinculable INTEGER NOT NULL;
GO

/* -----------------------------------------------------------------------------
   6) Constraints: soltar UNIQUE viejo (usa esquema/entidad), FK al catálogo,
      UNIQUE nuevo
   ----------------------------------------------------------------------------- */
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'uq_vinculo_archivo_entidad' AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
    ALTER TABLE archivos.archivo_vinculo DROP CONSTRAINT uq_vinculo_archivo_entidad;
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = N'fk_vinculo_entidad' AND type = N'F')
    ALTER TABLE archivos.archivo_vinculo
        ADD CONSTRAINT fk_vinculo_entidad FOREIGN KEY (id_entidad_vinculable)
            REFERENCES archivos.cat_entidad_vinculable (id_entidad_vinculable);
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = N'uq_vinculo_archivo_entidad' AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
    ALTER TABLE archivos.archivo_vinculo
        ADD CONSTRAINT uq_vinculo_archivo_entidad UNIQUE (id_archivo, id_entidad_vinculable, id_entidad);
GO

/* -----------------------------------------------------------------------------
   7) Eliminar el discriminador de texto (esquema, entidad)
   ----------------------------------------------------------------------------- */
IF COL_LENGTH(N'archivos.archivo_vinculo', N'entidad') IS NOT NULL
    ALTER TABLE archivos.archivo_vinculo DROP COLUMN entidad;
GO
IF COL_LENGTH(N'archivos.archivo_vinculo', N'esquema') IS NOT NULL
    ALTER TABLE archivos.archivo_vinculo DROP COLUMN esquema;
GO

/* -----------------------------------------------------------------------------
   8) Índice de lookup compacto
   ----------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_vinculo_entidad' AND object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
    CREATE NONCLUSTERED INDEX ix_vinculo_entidad
        ON archivos.archivo_vinculo (id_entidad_vinculable, id_entidad)
        INCLUDE (id_archivo)
        WHERE fecha_eliminacion_logica IS NULL;
GO

/* -----------------------------------------------------------------------------
   9) Descripciones (MS_Description)
   ----------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'archivos.cat_entidad_vinculable') AND minor_id = 0 AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty
        @name=N'MS_Description',
        @value=N'Catálogo de entidades que pueden vincularse a un archivo. Define cada entidad vinculable (esquema, entidad, columna PK) para resolver el vínculo polimórfico. No tiene FK a los dominios.',
        @level0type=N'SCHEMA', @level0name=N'archivos',
        @level1type=N'TABLE',  @level1name=N'cat_entidad_vinculable';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'archivos.archivo_vinculo') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'archivos.archivo_vinculo'), N'id_entidad_vinculable', N'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty
        @name=N'MS_Description',
        @value=N'Entidad vinculable a la que se asocia el archivo (qué tabla). FK a archivos.cat_entidad_vinculable. Junto con id_entidad (qué fila) resuelve la referencia polimórfica.',
        @level0type=N'SCHEMA',  @level0name=N'archivos',
        @level1type=N'TABLE',   @level1name=N'archivo_vinculo',
        @level2type=N'COLUMN',  @level2name=N'id_entidad_vinculable';
GO
