/* =============================================================================
    V0038 — Elimina nivel de confidencialidad del esquema archivos y tabla cat
    PDI Chile — SIP. SQL Server. Flyway.

    Se eliminan FK, columnas y la tabla cat_nivel_confidencialidad completa.

    Cambios
    - Elimina FK fk_archivo_nivel de archivos.archivo.
    - Elimina columna id_nivel_confidencialidad de archivos.archivo.
    - Elimina FK fk_archivo_vinculo_nivel_confidencialidad de archivos.archivo_vinculo.
    - Elimina columna id_nivel_confidencialidad de archivos.archivo_vinculo.
    - Elimina FK fk_instfisc_nivel de diligencias.instruccion_fiscal.
    - Elimina columna id_nivel_confidencialidad de diligencias.instruccion_fiscal.
    - Elimina tabla archivos.cat_nivel_confidencialidad.

    Idempotente. Transacción por migración de Flyway. XACT_ABORT ON.

   ============================================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON;
SET NOCOUNT ON;

GO

/* 1) Eliminar FK de archivos.archivo */
IF EXISTS ( SELECT 1 FROM sys.foreign_keys
            WHERE name = N'fk_archivo_nivel'
              AND parent_object_id = OBJECT_ID(N'archivos.archivo'))
    ALTER TABLE archivos.archivo
        DROP CONSTRAINT fk_archivo_nivel;

GO

/* 2) Eliminar columna id_nivel_confidencialidad de archivos.archivo */
IF COL_LENGTH(N'archivos.archivo', N'id_nivel_confidencialidad') IS NOT NULL
    ALTER TABLE archivos.archivo
        DROP COLUMN id_nivel_confidencialidad;

GO

/* 3) Eliminar FK de archivos.archivo_vinculo */
IF EXISTS ( SELECT 1 FROM sys.foreign_keys
            WHERE name = N'fk_archivo_vinculo_nivel_confidencialidad'
              AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
    ALTER TABLE archivos.archivo_vinculo
        DROP CONSTRAINT fk_archivo_vinculo_nivel_confidencialidad;

GO

/* 4) Eliminar columna id_nivel_confidencialidad de archivos.archivo_vinculo */
IF COL_LENGTH(N'archivos.archivo_vinculo', N'id_nivel_confidencialidad') IS NOT NULL
    ALTER TABLE archivos.archivo_vinculo
        DROP COLUMN id_nivel_confidencialidad;

GO

/* 5) Eliminar FK de diligencias.instruccion_fiscal */
IF EXISTS ( SELECT 1 FROM sys.foreign_keys
            WHERE name = N'fk_instfisc_nivel'
              AND parent_object_id = OBJECT_ID(N'diligencias.instruccion_fiscal'))
    ALTER TABLE diligencias.instruccion_fiscal
        DROP CONSTRAINT fk_instfisc_nivel;

GO

/* 6) Eliminar columna id_nivel_confidencialidad de diligencias.instruccion_fiscal */
IF COL_LENGTH(N'diligencias.instruccion_fiscal', N'id_nivel_confidencialidad') IS NOT NULL
    ALTER TABLE diligencias.instruccion_fiscal
        DROP COLUMN id_nivel_confidencialidad;

GO

/* 7) Eliminar tabla archivos.cat_nivel_confidencialidad */
IF OBJECT_ID(N'archivos.cat_nivel_confidencialidad', N'U') IS NOT NULL
    DROP TABLE archivos.cat_nivel_confidencialidad;

GO

PRINT 'V0038: completado (nivel_confidencialidad eliminado completamente).';

GO