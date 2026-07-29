-- =============================================================================
-- SIP — Migration V0048__pauta_nna_condicion_nna
-- =============================================================================
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0045__pauta_nna.sql (denuncias.pauta_nna)
--
-- ALCANCE (PDI-1553):
--   Agrega a denuncias.pauta_nna los campos de la sub-sección "1.1 Condición
--   víctima niños(as) y adolescentes" (pantalla "Antecedentes del delito" del
--   front, punto 1 "Datos del hecho"). Aunque la UI los muestra junto a los
--   datos del hecho, son propiedad de la condición NNA de la denuncia (mismo
--   dominio del Anexo N°3), no del hecho delictual en si — de ahi que se
--   agregan a pauta_nna y no a denuncias.denuncia_hecho.
--
--   Columnas nuevas:
--     - es_derivado_tribunal_familia          BIT
--     - tiene_adulto_responsable              BIT (fuente de verdad; ya no se
--       calcula a partir de si vino acompanante/adulto protector)
--     - ingreso_declaracion_espontanea_grabada BIT
--     - contactar_defensoria_penal            BIT
--     - firma_apercibimiento_art26            BIT (mismo patron que
--       denuncias.pauta_vif.firma_apercibimiento_art26; boton "Acta de
--       apercibimiento Art. 26 CPP" en el front)
--
-- IDEMPOTENCIA:
--   Guardas IF COL_LENGTH IS NULL.
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

IF COL_LENGTH(N'denuncias.pauta_nna', N'es_derivado_tribunal_familia') IS NULL
    ALTER TABLE [denuncias].[pauta_nna] ADD [es_derivado_tribunal_familia] BIT NOT NULL CONSTRAINT df_pauta_nna_es_derivado_tribunal_familia DEFAULT (0);
GO

IF COL_LENGTH(N'denuncias.pauta_nna', N'tiene_adulto_responsable') IS NULL
    ALTER TABLE [denuncias].[pauta_nna] ADD [tiene_adulto_responsable] BIT NOT NULL CONSTRAINT df_pauta_nna_tiene_adulto_responsable DEFAULT (0);
GO

IF COL_LENGTH(N'denuncias.pauta_nna', N'ingreso_declaracion_espontanea_grabada') IS NULL
    ALTER TABLE [denuncias].[pauta_nna] ADD [ingreso_declaracion_espontanea_grabada] BIT NOT NULL CONSTRAINT df_pauta_nna_ingreso_declaracion_espontanea_grabada DEFAULT (0);
GO

IF COL_LENGTH(N'denuncias.pauta_nna', N'contactar_defensoria_penal') IS NULL
    ALTER TABLE [denuncias].[pauta_nna] ADD [contactar_defensoria_penal] BIT NOT NULL CONSTRAINT df_pauta_nna_contactar_defensoria_penal DEFAULT (0);
GO

IF COL_LENGTH(N'denuncias.pauta_nna', N'firma_apercibimiento_art26') IS NULL
    ALTER TABLE [denuncias].[pauta_nna] ADD [firma_apercibimiento_art26] BIT NOT NULL CONSTRAINT df_pauta_nna_firma_apercibimiento_art26 DEFAULT (0);
GO


-- =============================================================================
-- DESCRIPCIONES EXTENDIDAS (MS_Description)
-- =============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'es_derivado_tribunal_familia', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si el caso fue derivado a Tribunal de Familia. Sub-sección "1.1 Condición víctima niños(as) y adolescentes" del Anexo N°3.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'es_derivado_tribunal_familia';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'tiene_adulto_responsable', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si el NNA cuenta con un adulto responsable. Fuente de verdad de este dato; ya no se calcula a partir de si vino acompañante/adulto protector.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'tiene_adulto_responsable';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'ingreso_declaracion_espontanea_grabada', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si se registró el ingreso de la declaración espontánea grabada del NNA.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'ingreso_declaracion_espontanea_grabada';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'contactar_defensoria_penal', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si corresponde contactar a la Defensoría Penal Pública.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'contactar_defensoria_penal';
GO
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'firma_apercibimiento_art26', 'ColumnId') AND name = N'MS_Description')
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si se firmó el acta de apercibimiento Art. 26 CPP. Mismo patrón que denuncias.pauta_vif.firma_apercibimiento_art26.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'firma_apercibimiento_art26';
GO

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_es_derivado_tribunal_familia'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de es_derivado_tribunal_familia: 0 (no derivado) mientras no se registre lo contrario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_es_derivado_tribunal_familia';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_tiene_adulto_responsable'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de tiene_adulto_responsable: 0 (sin adulto responsable) mientras no se registre lo contrario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_tiene_adulto_responsable';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_ingreso_declaracion_espontanea_grabada'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de ingreso_declaracion_espontanea_grabada: 0 (sin registro) mientras no se registre lo contrario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_ingreso_declaracion_espontanea_grabada';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_contactar_defensoria_penal'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de contactar_defensoria_penal: 0 (no corresponde) mientras no se registre lo contrario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_contactar_defensoria_penal';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_firma_apercibimiento_art26'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de firma_apercibimiento_art26: 0 (sin firma) mientras no se registre lo contrario.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_firma_apercibimiento_art26';
GO
