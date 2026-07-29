-- =============================================================================
-- SIP — Migration V0047__denuncia_persona_rol_relacion
-- =============================================================================
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql (denuncias.denuncia_persona_rol,
--               personas.cat_tipo_relacion)
--
-- ALCANCE (PDI-1553):
--   Agrega denuncias.denuncia_persona_rol.id_tipo_relacion (INT NULL, FK a
--   personas.cat_tipo_relacion), para registrar "relación de esta persona con
--   la víctima" en el contexto de la denuncia (acompañante→víctima, adulto
--   protector→víctima, agresor→víctima en el Anexo N°3 NNA; reutilizable por
--   cualquier otro flujo de denuncias que necesite el mismo dato).
--
--   Se evita deliberadamente usar personas.relacion (tabla operacional del
--   esquema personas) para este dato: escribir ahí desde sip-ms-denuncias
--   violaría la regla "un esquema = un microservicio". La FK agregada acá
--   apunta a un catálogo de solo lectura (personas.cat_tipo_relacion, ya
--   existente), consistente con el patrón ya usado por esta misma tabla para
--   id_tipo_rol_persona (FK a casos.cat_tipo_rol_persona). Es referencia para
--   integridad, no una escritura de datos operacionales de otro esquema.
--
-- IDEMPOTENCIA:
--   Guardas IF COL_LENGTH / IF NOT EXISTS.
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

IF COL_LENGTH(N'denuncias.denuncia_persona_rol', N'id_tipo_relacion') IS NULL
    ALTER TABLE [denuncias].[denuncia_persona_rol] ADD [id_tipo_relacion] INT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_persona_rol_tipo_relacion' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_persona_rol'))
    ALTER TABLE [denuncias].[denuncia_persona_rol] WITH CHECK ADD CONSTRAINT [fk_denuncia_persona_rol_tipo_relacion] FOREIGN KEY([id_tipo_relacion]) REFERENCES [personas].[cat_tipo_relacion]([id_tipo_relacion]);
GO


-- =============================================================================
-- DESCRIPCIONES EXTENDIDAS (MS_Description)
-- =============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.denuncia_persona_rol') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.denuncia_persona_rol'), N'id_tipo_relacion', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK opcional a personas.cat_tipo_relacion: relación de esta persona con la víctima en el contexto de la denuncia (ej: acompañante→víctima, adulto protector→víctima, agresor→víctima). Referencia de solo lectura a un catálogo de otro esquema; no implica escritura en personas.relacion.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'denuncia_persona_rol',@level2type=N'COLUMN',@level2name=N'id_tipo_relacion';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'denuncia_persona_rol', N'CONSTRAINT', N'fk_denuncia_persona_rol_tipo_relacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK de denuncia_persona_rol.id_tipo_relacion al catálogo de solo lectura personas.cat_tipo_relacion.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'denuncia_persona_rol',@level2type=N'CONSTRAINT',@level2name=N'fk_denuncia_persona_rol_tipo_relacion';
GO
