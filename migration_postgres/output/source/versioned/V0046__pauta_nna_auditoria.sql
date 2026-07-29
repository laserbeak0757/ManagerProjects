-- =============================================================================
-- SIP — Migration V0046__pauta_nna_auditoria
-- =============================================================================
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0045__pauta_nna.sql
--
-- ALCANCE (PDI-1553):
--   Agrega el bloque de auditoría estándar SIP (id_usuario_creador,
--   id_usuario_modificador, id_usuario_eliminador, fecha_creacion,
--   fecha_actualizacion, fecha_eliminacion_logica) a las tablas creadas en
--   V0045 que quedaron sin él:
--     - denuncias.cat_tipo_acompanamiento_nna
--     - denuncias.cat_tipo_denunciante_nna
--     - denuncias.cat_categoria_factor_riesgo_nna
--     - denuncias.cat_factor_riesgo_nna
--     - denuncias.pauta_nna_factor_riesgo (ya tenía fecha_creacion /
--       fecha_actualizacion; se completa con el resto)
--
--   NOTA: este bloque iba originalmente incluido en V0045, pero V0045 ya
--   había sido aplicado (checksum) en al menos un ambiente antes de
--   detectarse el faltante. Editar una migration versionada ya aplicada
--   rompe la validación de Flyway (checksum mismatch), así que el fix se
--   aplica acá como ALTER TABLE idempotente en vez de tocar V0045.
--
-- IDEMPOTENCIA:
--   Guardas IF COL_LENGTH / IF NOT EXISTS en todos los bloques. Sigue el
--   mismo patrón usado en V0027__agregar_columnas_auditoria_y_fks.sql para
--   pauta_vif y denuncia_persona_rol.
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
-- Macro-patrón repetido por tabla: agrega columnas, luego FKs a auth.usuario.
-- =============================================================================

-- ─── denuncias.cat_tipo_acompanamiento_nna ──────────────────────────────────
IF COL_LENGTH(N'denuncias.cat_tipo_acompanamiento_nna', N'fecha_creacion') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] ADD [fecha_creacion] DATETIME2(7) NOT NULL CONSTRAINT df_cat_tipo_acompanamiento_nna_fecha_creacion DEFAULT SYSUTCDATETIME();
GO
IF COL_LENGTH(N'denuncias.cat_tipo_acompanamiento_nna', N'fecha_actualizacion') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] ADD [fecha_actualizacion] DATETIME2(7) NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_acompanamiento_nna', N'id_usuario_creador') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] ADD [id_usuario_creador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_acompanamiento_nna', N'id_usuario_modificador') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] ADD [id_usuario_modificador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_acompanamiento_nna', N'id_usuario_eliminador') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] ADD [id_usuario_eliminador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_acompanamiento_nna', N'fecha_eliminacion_logica') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] ADD [fecha_eliminacion_logica] DATETIME2(7) NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_acompanamiento_nna_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'))
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] WITH CHECK ADD CONSTRAINT [fk_cat_tipo_acompanamiento_nna_usuario_creador] FOREIGN KEY([id_usuario_creador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_acompanamiento_nna_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'))
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] WITH CHECK ADD CONSTRAINT [fk_cat_tipo_acompanamiento_nna_usuario_modificador] FOREIGN KEY([id_usuario_modificador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_acompanamiento_nna_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_acompanamiento_nna'))
    ALTER TABLE [denuncias].[cat_tipo_acompanamiento_nna] WITH CHECK ADD CONSTRAINT [fk_cat_tipo_acompanamiento_nna_usuario_eliminador] FOREIGN KEY([id_usuario_eliminador]) REFERENCES [auth].[usuario]([id_usuario]);
GO


-- ─── denuncias.cat_tipo_denunciante_nna ─────────────────────────────────────
IF COL_LENGTH(N'denuncias.cat_tipo_denunciante_nna', N'fecha_creacion') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] ADD [fecha_creacion] DATETIME2(7) NOT NULL CONSTRAINT df_cat_tipo_denunciante_nna_fecha_creacion DEFAULT SYSUTCDATETIME();
GO
IF COL_LENGTH(N'denuncias.cat_tipo_denunciante_nna', N'fecha_actualizacion') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] ADD [fecha_actualizacion] DATETIME2(7) NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_denunciante_nna', N'id_usuario_creador') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] ADD [id_usuario_creador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_denunciante_nna', N'id_usuario_modificador') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] ADD [id_usuario_modificador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_denunciante_nna', N'id_usuario_eliminador') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] ADD [id_usuario_eliminador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_tipo_denunciante_nna', N'fecha_eliminacion_logica') IS NULL
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] ADD [fecha_eliminacion_logica] DATETIME2(7) NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_denunciante_nna_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'))
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] WITH CHECK ADD CONSTRAINT [fk_cat_tipo_denunciante_nna_usuario_creador] FOREIGN KEY([id_usuario_creador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_denunciante_nna_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'))
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] WITH CHECK ADD CONSTRAINT [fk_cat_tipo_denunciante_nna_usuario_modificador] FOREIGN KEY([id_usuario_modificador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_denunciante_nna_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_denunciante_nna'))
    ALTER TABLE [denuncias].[cat_tipo_denunciante_nna] WITH CHECK ADD CONSTRAINT [fk_cat_tipo_denunciante_nna_usuario_eliminador] FOREIGN KEY([id_usuario_eliminador]) REFERENCES [auth].[usuario]([id_usuario]);
GO


-- ─── denuncias.cat_categoria_factor_riesgo_nna ──────────────────────────────
IF COL_LENGTH(N'denuncias.cat_categoria_factor_riesgo_nna', N'fecha_creacion') IS NULL
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] ADD [fecha_creacion] DATETIME2(7) NOT NULL CONSTRAINT df_cat_categoria_factor_riesgo_nna_fecha_creacion DEFAULT SYSUTCDATETIME();
GO
IF COL_LENGTH(N'denuncias.cat_categoria_factor_riesgo_nna', N'fecha_actualizacion') IS NULL
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] ADD [fecha_actualizacion] DATETIME2(7) NULL;
GO
IF COL_LENGTH(N'denuncias.cat_categoria_factor_riesgo_nna', N'id_usuario_creador') IS NULL
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] ADD [id_usuario_creador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_categoria_factor_riesgo_nna', N'id_usuario_modificador') IS NULL
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] ADD [id_usuario_modificador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_categoria_factor_riesgo_nna', N'id_usuario_eliminador') IS NULL
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] ADD [id_usuario_eliminador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_categoria_factor_riesgo_nna', N'fecha_eliminacion_logica') IS NULL
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] ADD [fecha_eliminacion_logica] DATETIME2(7) NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_categoria_factor_riesgo_nna_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'))
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] WITH CHECK ADD CONSTRAINT [fk_cat_categoria_factor_riesgo_nna_usuario_creador] FOREIGN KEY([id_usuario_creador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_categoria_factor_riesgo_nna_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'))
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] WITH CHECK ADD CONSTRAINT [fk_cat_categoria_factor_riesgo_nna_usuario_modificador] FOREIGN KEY([id_usuario_modificador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_categoria_factor_riesgo_nna_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_categoria_factor_riesgo_nna'))
    ALTER TABLE [denuncias].[cat_categoria_factor_riesgo_nna] WITH CHECK ADD CONSTRAINT [fk_cat_categoria_factor_riesgo_nna_usuario_eliminador] FOREIGN KEY([id_usuario_eliminador]) REFERENCES [auth].[usuario]([id_usuario]);
GO


-- ─── denuncias.cat_factor_riesgo_nna ─────────────────────────────────────────
IF COL_LENGTH(N'denuncias.cat_factor_riesgo_nna', N'fecha_creacion') IS NULL
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] ADD [fecha_creacion] DATETIME2(7) NOT NULL CONSTRAINT df_cat_factor_riesgo_nna_fecha_creacion DEFAULT SYSUTCDATETIME();
GO
IF COL_LENGTH(N'denuncias.cat_factor_riesgo_nna', N'fecha_actualizacion') IS NULL
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] ADD [fecha_actualizacion] DATETIME2(7) NULL;
GO
IF COL_LENGTH(N'denuncias.cat_factor_riesgo_nna', N'id_usuario_creador') IS NULL
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] ADD [id_usuario_creador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_factor_riesgo_nna', N'id_usuario_modificador') IS NULL
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] ADD [id_usuario_modificador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_factor_riesgo_nna', N'id_usuario_eliminador') IS NULL
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] ADD [id_usuario_eliminador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.cat_factor_riesgo_nna', N'fecha_eliminacion_logica') IS NULL
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] ADD [fecha_eliminacion_logica] DATETIME2(7) NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_factor_riesgo_nna_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'))
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] WITH CHECK ADD CONSTRAINT [fk_cat_factor_riesgo_nna_usuario_creador] FOREIGN KEY([id_usuario_creador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_factor_riesgo_nna_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'))
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] WITH CHECK ADD CONSTRAINT [fk_cat_factor_riesgo_nna_usuario_modificador] FOREIGN KEY([id_usuario_modificador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_factor_riesgo_nna_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_factor_riesgo_nna'))
    ALTER TABLE [denuncias].[cat_factor_riesgo_nna] WITH CHECK ADD CONSTRAINT [fk_cat_factor_riesgo_nna_usuario_eliminador] FOREIGN KEY([id_usuario_eliminador]) REFERENCES [auth].[usuario]([id_usuario]);
GO


-- ─── denuncias.pauta_nna_factor_riesgo ───────────────────────────────────────
-- Ya tenía fecha_creacion / fecha_actualizacion desde V0045; solo faltan las
-- columnas de usuario y la baja lógica.
IF COL_LENGTH(N'denuncias.pauta_nna_factor_riesgo', N'id_usuario_creador') IS NULL
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] ADD [id_usuario_creador] INT NOT NULL;
GO
IF COL_LENGTH(N'denuncias.pauta_nna_factor_riesgo', N'id_usuario_modificador') IS NULL
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] ADD [id_usuario_modificador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.pauta_nna_factor_riesgo', N'id_usuario_eliminador') IS NULL
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] ADD [id_usuario_eliminador] INT NULL;
GO
IF COL_LENGTH(N'denuncias.pauta_nna_factor_riesgo', N'fecha_eliminacion_logica') IS NULL
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] ADD [fecha_eliminacion_logica] DATETIME2(7) NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pauta_nna_factor_riesgo_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'))
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] WITH CHECK ADD CONSTRAINT [fk_pauta_nna_factor_riesgo_usuario_creador] FOREIGN KEY([id_usuario_creador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pauta_nna_factor_riesgo_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'))
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] WITH CHECK ADD CONSTRAINT [fk_pauta_nna_factor_riesgo_usuario_modificador] FOREIGN KEY([id_usuario_modificador]) REFERENCES [auth].[usuario]([id_usuario]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pauta_nna_factor_riesgo_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.pauta_nna_factor_riesgo'))
    ALTER TABLE [denuncias].[pauta_nna_factor_riesgo] WITH CHECK ADD CONSTRAINT [fk_pauta_nna_factor_riesgo_usuario_eliminador] FOREIGN KEY([id_usuario_eliminador]) REFERENCES [auth].[usuario]([id_usuario]);
GO


-- =============================================================================
-- DESCRIPCIONES EXTENDIDAS (MS_Description) — bloque de auditoría por tabla
-- =============================================================================
IF OBJECT_ID(N'tempdb..#tablas_auditoria_v0045') IS NOT NULL DROP TABLE #tablas_auditoria_v0045;
CREATE TABLE #tablas_auditoria_v0045 (esquema SYSNAME, tabla SYSNAME);
INSERT INTO #tablas_auditoria_v0045 (esquema, tabla) VALUES
    (N'denuncias', N'cat_tipo_acompanamiento_nna'),
    (N'denuncias', N'cat_tipo_denunciante_nna'),
    (N'denuncias', N'cat_categoria_factor_riesgo_nna'),
    (N'denuncias', N'cat_factor_riesgo_nna'),
    (N'denuncias', N'pauta_nna_factor_riesgo');

DECLARE @esquema SYSNAME, @tabla SYSNAME, @obj_id INT;
DECLARE cur_tablas CURSOR LOCAL FAST_FORWARD FOR SELECT esquema, tabla FROM #tablas_auditoria_v0045;
OPEN cur_tablas;
FETCH NEXT FROM cur_tablas INTO @esquema, @tabla;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @obj_id = OBJECT_ID(QUOTENAME(@esquema) + N'.' + QUOTENAME(@tabla));

    IF COL_LENGTH(@esquema + N'.' + @tabla, N'fecha_creacion') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = @obj_id AND minor_id = COLUMNPROPERTY(@obj_id, N'fecha_creacion', 'ColumnId') AND name = N'MS_Description')
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=N'Fecha/hora UTC de creación del registro. Asignada por el motor via SYSUTCDATETIME().',
            @level0type=N'SCHEMA',@level0name=@esquema,@level1type=N'TABLE',@level1name=@tabla,@level2type=N'COLUMN',@level2name=N'fecha_creacion';

    IF COL_LENGTH(@esquema + N'.' + @tabla, N'fecha_actualizacion') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = @obj_id AND minor_id = COLUMNPROPERTY(@obj_id, N'fecha_actualizacion', 'ColumnId') AND name = N'MS_Description')
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=N'Fecha/hora UTC de la última actualización del registro. NULL si nunca se ha modificado.',
            @level0type=N'SCHEMA',@level0name=@esquema,@level1type=N'TABLE',@level1name=@tabla,@level2type=N'COLUMN',@level2name=N'fecha_actualizacion';

    IF COL_LENGTH(@esquema + N'.' + @tabla, N'id_usuario_creador') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = @obj_id AND minor_id = COLUMNPROPERTY(@obj_id, N'id_usuario_creador', 'ColumnId') AND name = N'MS_Description')
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=N'FK a auth.usuario: quién creó el registro.',
            @level0type=N'SCHEMA',@level0name=@esquema,@level1type=N'TABLE',@level1name=@tabla,@level2type=N'COLUMN',@level2name=N'id_usuario_creador';

    IF COL_LENGTH(@esquema + N'.' + @tabla, N'id_usuario_modificador') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = @obj_id AND minor_id = COLUMNPROPERTY(@obj_id, N'id_usuario_modificador', 'ColumnId') AND name = N'MS_Description')
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=N'FK opcional a auth.usuario: quién realizó la última modificación. NULL si nunca se ha modificado.',
            @level0type=N'SCHEMA',@level0name=@esquema,@level1type=N'TABLE',@level1name=@tabla,@level2type=N'COLUMN',@level2name=N'id_usuario_modificador';

    IF COL_LENGTH(@esquema + N'.' + @tabla, N'id_usuario_eliminador') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = @obj_id AND minor_id = COLUMNPROPERTY(@obj_id, N'id_usuario_eliminador', 'ColumnId') AND name = N'MS_Description')
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=N'FK opcional a auth.usuario: quién realizó la baja lógica. NULL si el registro no ha sido eliminado.',
            @level0type=N'SCHEMA',@level0name=@esquema,@level1type=N'TABLE',@level1name=@tabla,@level2type=N'COLUMN',@level2name=N'id_usuario_eliminador';

    IF COL_LENGTH(@esquema + N'.' + @tabla, N'fecha_eliminacion_logica') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = @obj_id AND minor_id = COLUMNPROPERTY(@obj_id, N'fecha_eliminacion_logica', 'ColumnId') AND name = N'MS_Description')
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=N'Fecha/hora UTC de baja lógica del registro. NULL si el registro está vigente.',
            @level0type=N'SCHEMA',@level0name=@esquema,@level1type=N'TABLE',@level1name=@tabla,@level2type=N'COLUMN',@level2name=N'fecha_eliminacion_logica';

    FETCH NEXT FROM cur_tablas INTO @esquema, @tabla;
END;
CLOSE cur_tablas;
DEALLOCATE cur_tablas;
DROP TABLE #tablas_auditoria_v0045;
GO

-- ─── Descripciones de las FK de auditoría agregadas por esta migration ──────
IF OBJECT_ID(N'tempdb..#fks_auditoria_v0045') IS NOT NULL DROP TABLE #fks_auditoria_v0045;
CREATE TABLE #fks_auditoria_v0045 (esquema SYSNAME, tabla SYSNAME, fk_nombre SYSNAME, rol NVARCHAR(20));
INSERT INTO #fks_auditoria_v0045 (esquema, tabla, fk_nombre, rol)
SELECT esquema, tabla, N'fk_' + tabla + N'_usuario_creador', N'creador' FROM (VALUES
    (N'denuncias', N'cat_tipo_acompanamiento_nna'),
    (N'denuncias', N'cat_tipo_denunciante_nna'),
    (N'denuncias', N'cat_categoria_factor_riesgo_nna'),
    (N'denuncias', N'cat_factor_riesgo_nna'),
    (N'denuncias', N'pauta_nna_factor_riesgo')) AS t(esquema, tabla)
UNION ALL
SELECT esquema, tabla, N'fk_' + tabla + N'_usuario_modificador', N'modificador' FROM (VALUES
    (N'denuncias', N'cat_tipo_acompanamiento_nna'),
    (N'denuncias', N'cat_tipo_denunciante_nna'),
    (N'denuncias', N'cat_categoria_factor_riesgo_nna'),
    (N'denuncias', N'cat_factor_riesgo_nna'),
    (N'denuncias', N'pauta_nna_factor_riesgo')) AS t(esquema, tabla)
UNION ALL
SELECT esquema, tabla, N'fk_' + tabla + N'_usuario_eliminador', N'eliminador' FROM (VALUES
    (N'denuncias', N'cat_tipo_acompanamiento_nna'),
    (N'denuncias', N'cat_tipo_denunciante_nna'),
    (N'denuncias', N'cat_categoria_factor_riesgo_nna'),
    (N'denuncias', N'cat_factor_riesgo_nna'),
    (N'denuncias', N'pauta_nna_factor_riesgo')) AS t(esquema, tabla);

DECLARE @f_esquema SYSNAME, @f_tabla SYSNAME, @f_fk SYSNAME, @f_rol NVARCHAR(20), @f_desc NVARCHAR(500);
DECLARE cur_fks CURSOR LOCAL FAST_FORWARD FOR SELECT esquema, tabla, fk_nombre, rol FROM #fks_auditoria_v0045;
OPEN cur_fks;
FETCH NEXT FROM cur_fks INTO @f_esquema, @f_tabla, @f_fk, @f_rol;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = @f_fk AND parent_object_id = OBJECT_ID(QUOTENAME(@f_esquema) + N'.' + QUOTENAME(@f_tabla)))
       AND NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', @f_esquema, N'TABLE', @f_tabla, N'CONSTRAINT', @f_fk))
    BEGIN
        SET @f_desc = N'FK del bloque de auditoría estándar SIP: referencia a auth.usuario (usuario ' + @f_rol + N').';
        EXEC sys.sp_addextendedproperty @name=N'MS_Description',
            @value=@f_desc,
            @level0type=N'SCHEMA',@level0name=@f_esquema,@level1type=N'TABLE',@level1name=@f_tabla,@level2type=N'CONSTRAINT',@level2name=@f_fk;
    END;

    FETCH NEXT FROM cur_fks INTO @f_esquema, @f_tabla, @f_fk, @f_rol;
END;
CLOSE cur_fks;
DEALLOCATE cur_fks;
DROP TABLE #fks_auditoria_v0045;
GO

-- ─── Descripciones de los DEFAULT de fecha_creacion agregados por esta migration ──
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_acompanamiento_nna', N'CONSTRAINT', N'df_cat_tipo_acompanamiento_nna_fecha_creacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de fecha_creacion: red de seguridad para asegurar UTC aunque el procedimiento no la puebla explícitamente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_acompanamiento_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_tipo_acompanamiento_nna_fecha_creacion';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_tipo_denunciante_nna', N'CONSTRAINT', N'df_cat_tipo_denunciante_nna_fecha_creacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de fecha_creacion: red de seguridad para asegurar UTC aunque el procedimiento no la puebla explícitamente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_tipo_denunciante_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_tipo_denunciante_nna_fecha_creacion';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_categoria_factor_riesgo_nna', N'CONSTRAINT', N'df_cat_categoria_factor_riesgo_nna_fecha_creacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de fecha_creacion: red de seguridad para asegurar UTC aunque el procedimiento no la puebla explícitamente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_categoria_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_categoria_factor_riesgo_nna_fecha_creacion';
GO
IF NOT EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'denuncias', N'TABLE', N'cat_factor_riesgo_nna', N'CONSTRAINT', N'df_cat_factor_riesgo_nna_fecha_creacion'))
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor por defecto de fecha_creacion: red de seguridad para asegurar UTC aunque el procedimiento no la puebla explícitamente.',
        @level0type=N'SCHEMA',@level0name=N'denuncias',@level1type=N'TABLE',@level1name=N'cat_factor_riesgo_nna',@level2type=N'CONSTRAINT',@level2name=N'df_cat_factor_riesgo_nna_fecha_creacion';
GO
