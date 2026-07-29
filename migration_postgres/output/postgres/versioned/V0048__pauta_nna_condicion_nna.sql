-- =============================================================================
-- SIP â€” Migration V0048__pauta_nna_condicion_nna
-- =============================================================================
-- Compatible: SQL Server 2017+ (forward-compatible 2022)
-- Depende de: V0045__pauta_nna.sql (denuncias.pauta_nna)
--
-- ALCANCE (PDI-1553):
-- Agrega a denuncias.pauta_nna los campos de la sub-secciÃ³n "1.1 CondiciÃ³n
-- vÃ­ctima niÃ±os(as) y adolescentes" (pantalla "Antecedentes del delito" del
-- front, punto 1 "Datos del hecho"). Aunque la UI los muestra junto a los
-- datos del hecho, son propiedad de la condiciÃ³n NNA de la denuncia (mismo
-- dominio del Anexo NÂ°3), no del hecho delictual en si â€” de ahi que se
-- agregan a pauta_nna y no a denuncias.denuncia_hecho.
--
-- Columnas nuevas:
-- - es_derivado_tribunal_familia boolean
-- - tiene_adulto_responsable boolean (fuente de verdad; ya no se
-- calcula a partir de si vino acompanante/adulto protector)
-- - ingreso_declaracion_espontanea_grabada boolean
-- - contactar_defensoria_penal boolean
-- - firma_apercibimiento_art26 boolean (mismo patron que
-- denuncias.pauta_vif.firma_apercibimiento_art26; boton "Acta de
-- apercibimiento Art. 26 CPP" en el front)
--
-- IDEMPOTENCIA:
-- Guardas IF COL_LENGTH IS NULL.
-- =============================================================================
SET ANSI_NULLS ON;
SET ANSI_WARNINGS ON;
SET ANSI_PADDING ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;

IF COL_LENGTH(N'denuncias.pauta_nna', N'es_derivado_tribunal_familia') IS NULL
 ALTER TABLE denuncias.pauta_nna ADD es_derivado_tribunal_familia boolean NOT NULL CONSTRAINT df_pauta_nna_es_derivado_tribunal_familia DEFAULT (0);

IF COL_LENGTH(N'denuncias.pauta_nna', N'tiene_adulto_responsable') IS NULL
 ALTER TABLE denuncias.pauta_nna ADD tiene_adulto_responsable boolean NOT NULL CONSTRAINT df_pauta_nna_tiene_adulto_responsable DEFAULT (0);

IF COL_LENGTH(N'denuncias.pauta_nna', N'ingreso_declaracion_espontanea_grabada') IS NULL
 ALTER TABLE denuncias.pauta_nna ADD ingreso_declaracion_espontanea_grabada boolean NOT NULL CONSTRAINT df_pauta_nna_ingreso_declaracion_espontanea_grabada DEFAULT (0);

IF COL_LENGTH(N'denuncias.pauta_nna', N'contactar_defensoria_penal') IS NULL
 ALTER TABLE denuncias.pauta_nna ADD contactar_defensoria_penal boolean NOT NULL CONSTRAINT df_pauta_nna_contactar_defensoria_penal DEFAULT (0);

IF COL_LENGTH(N'denuncias.pauta_nna', N'firma_apercibimiento_art26') IS NULL
 ALTER TABLE denuncias.pauta_nna ADD firma_apercibimiento_art26 boolean NOT NULL CONSTRAINT df_pauta_nna_firma_apercibimiento_art26 DEFAULT (0);


-- =============================================================================
-- DESCRIPCIONES EXTENDIDAS (MS_Description)
-- =============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'es_derivado_tribunal_familia', 'ColumnId') AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Indica si el caso fue derivado a Tribunal de Familia. Sub-secciÃ³n "1.1 CondiciÃ³n vÃ­ctima niÃ±os(as) y adolescentes" del Anexo NÂ°3.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'es_derivado_tribunal_familia';
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'tiene_adulto_responsable', 'ColumnId') AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Indica si el NNA cuenta con un adulto responsable. Fuente de verdad de este dato; ya no se calcula a partir de si vino acompaÃ±ante/adulto protector.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'tiene_adulto_responsable';
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'ingreso_declaracion_espontanea_grabada', 'ColumnId') AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Indica si se registrÃ³ el ingreso de la declaraciÃ³n espontÃ¡nea grabada del NNA.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'ingreso_declaracion_espontanea_grabada';
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'contactar_defensoria_penal', 'ColumnId') AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Indica si corresponde contactar a la DefensorÃ­a Penal PÃºblica.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'contactar_defensoria_penal';
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID(N'denuncias.pauta_nna') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'denuncias.pauta_nna'), N'firma_apercibimiento_art26', 'ColumnId') AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Indica si se firmÃ³ el acta de apercibimiento Art. 26 CPP. Mismo patrÃ³n que denuncias.pauta_vif.firma_apercibimiento_art26.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'COLUMN',@level2name=N'firma_apercibimiento_art26';

IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_es_derivado_tribunal_familia'))
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Valor por defecto de es_derivado_tribunal_familia: 0 (no derivado) mientras no se registre lo contrario.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_es_derivado_tribunal_familia';
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_tiene_adulto_responsable'))
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Valor por defecto de tiene_adulto_responsable: 0 (sin adulto responsable) mientras no se registre lo contrario.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_tiene_adulto_responsable';
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_ingreso_declaracion_espontanea_grabada'))
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Valor por defecto de ingreso_declaracion_espontanea_grabada: 0 (sin registro) mientras no se registre lo contrario.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_ingreso_declaracion_espontanea_grabada';
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_contactar_defensoria_penal'))
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Valor por defecto de contactar_defensoria_penal: 0 (no corresponde) mientras no se registre lo contrario.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_contactar_defensoria_penal';
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'pauta_nna', N'CONSTRAINT', N'df_pauta_nna_firma_apercibimiento_art26'))
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Valor por defecto de firma_apercibimiento_art26: 0 (sin firma) mientras no se registre lo contrario.',
 @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'pauta_nna',@level2type=N'CONSTRAINT',@level2name=N'df_pauta_nna_firma_apercibimiento_art26';

