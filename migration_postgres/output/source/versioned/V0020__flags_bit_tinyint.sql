-- =============================================================================
-- V0020__flags_bit_tinyint.sql
-- =============================================================================
-- Conversion de columnas flag SMALLINT -> BIT (106) / TINYINT (7).
-- Por columna:
--   1. DROP de TODOS los indices que referencian la columna (columnas, INCLUDE o WHERE)
--   2. DROP CHECK (ck_*) real
--   3. DROP DEFAULT (df_*) real
--   4. ALTER COLUMN al nuevo tipo
--   5. Recrear DEFAULT
--   6. Recrear indices
--   7. Si TINYINT: recrear CHECK IN (0,1)
-- 18 indices afectados sobre 14 columnas (incluye INCLUDE y filtrados).
-- Nombres de constraints/indices tomados del esquema real.
-- Idempotente.
-- =============================================================================

SET XACT_ABORT ON;
GO


-- ===== SECCION 1: TINYINT (7) =====

-- denuncias.pauta_vif.tiene_lesiones_visibles  ->  TINYINT
ALTER TABLE [denuncias].[pauta_vif] DROP CONSTRAINT IF EXISTS [ck_pauta_vif_tiene_lesiones_visibles];
GO
ALTER TABLE [denuncias].[pauta_vif] DROP CONSTRAINT IF EXISTS [df_pauta_vif_tiene_lesiones_visibles];
GO
ALTER TABLE [denuncias].[pauta_vif] ALTER COLUMN [tiene_lesiones_visibles] TINYINT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pauta_vif_tiene_lesiones_visibles' AND parent_object_id=OBJECT_ID(N'denuncias.pauta_vif'))
    ALTER TABLE [denuncias].[pauta_vif] ADD CONSTRAINT [df_pauta_vif_tiene_lesiones_visibles] DEFAULT (0) FOR [tiene_lesiones_visibles];
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_pauta_vif_tiene_lesiones_visibles' AND parent_object_id=OBJECT_ID(N'denuncias.pauta_vif'))
    ALTER TABLE [denuncias].[pauta_vif] WITH CHECK ADD CONSTRAINT [ck_pauta_vif_tiene_lesiones_visibles] CHECK ([tiene_lesiones_visibles] IN (0,1));
GO

-- denuncias.procedimiento_persona.es_menor_edad  ->  TINYINT
ALTER TABLE [denuncias].[procedimiento_persona] DROP CONSTRAINT IF EXISTS [ck_procedimiento_persona_es_menor_edad];
GO
ALTER TABLE [denuncias].[procedimiento_persona] DROP CONSTRAINT IF EXISTS [df_procedimiento_persona_es_menor_edad];
GO
ALTER TABLE [denuncias].[procedimiento_persona] ALTER COLUMN [es_menor_edad] TINYINT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_procedimiento_persona_es_menor_edad' AND parent_object_id=OBJECT_ID(N'denuncias.procedimiento_persona'))
    ALTER TABLE [denuncias].[procedimiento_persona] ADD CONSTRAINT [df_procedimiento_persona_es_menor_edad] DEFAULT (0) FOR [es_menor_edad];
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_procedimiento_persona_es_menor_edad' AND parent_object_id=OBJECT_ID(N'denuncias.procedimiento_persona'))
    ALTER TABLE [denuncias].[procedimiento_persona] WITH CHECK ADD CONSTRAINT [ck_procedimiento_persona_es_menor_edad] CHECK ([es_menor_edad] IN (0,1));
GO

-- diligencias.actividad_investigativa.es_resultado_negativo  ->  TINYINT
ALTER TABLE [diligencias].[actividad_investigativa] DROP CONSTRAINT IF EXISTS [ck_actividad_investigativa_es_resultado_negativo];
GO
ALTER TABLE [diligencias].[actividad_investigativa] DROP CONSTRAINT IF EXISTS [df_actividad_investigativa_es_resultado_negativo];
GO
ALTER TABLE [diligencias].[actividad_investigativa] ALTER COLUMN [es_resultado_negativo] TINYINT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_actividad_investigativa_es_resultado_negativo' AND parent_object_id=OBJECT_ID(N'diligencias.actividad_investigativa'))
    ALTER TABLE [diligencias].[actividad_investigativa] ADD CONSTRAINT [df_actividad_investigativa_es_resultado_negativo] DEFAULT (0) FOR [es_resultado_negativo];
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_actividad_investigativa_es_resultado_negativo' AND parent_object_id=OBJECT_ID(N'diligencias.actividad_investigativa'))
    ALTER TABLE [diligencias].[actividad_investigativa] WITH CHECK ADD CONSTRAINT [ck_actividad_investigativa_es_resultado_negativo] CHECK ([es_resultado_negativo] IN (0,1));
GO

-- evidencias.arma.inscrita  ->  TINYINT
ALTER TABLE [evidencias].[arma] DROP CONSTRAINT IF EXISTS [ck_arma_inscrita];
GO
ALTER TABLE [evidencias].[arma] ALTER COLUMN [inscrita] TINYINT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_arma_inscrita' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
    ALTER TABLE [evidencias].[arma] WITH CHECK ADD CONSTRAINT [ck_arma_inscrita] CHECK ([inscrita] IN (0,1));
GO

-- evidencias.arma.tiene_capacidad_disparo_real  ->  TINYINT
ALTER TABLE [evidencias].[arma] DROP CONSTRAINT IF EXISTS [ck_arma_tiene_capacidad_disparo_real];
GO
ALTER TABLE [evidencias].[arma] DROP CONSTRAINT IF EXISTS [df_arma_tiene_capacidad_disparo_real];
GO
ALTER TABLE [evidencias].[arma] ALTER COLUMN [tiene_capacidad_disparo_real] TINYINT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_arma_tiene_capacidad_disparo_real' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
    ALTER TABLE [evidencias].[arma] ADD CONSTRAINT [df_arma_tiene_capacidad_disparo_real] DEFAULT (0) FOR [tiene_capacidad_disparo_real];
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_arma_tiene_capacidad_disparo_real' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
    ALTER TABLE [evidencias].[arma] WITH CHECK ADD CONSTRAINT [ck_arma_tiene_capacidad_disparo_real] CHECK ([tiene_capacidad_disparo_real] IN (0,1));
GO

-- evidencias.cadena_custodia.sello_intacto  ->  TINYINT
ALTER TABLE [evidencias].[cadena_custodia] DROP CONSTRAINT IF EXISTS [ck_cadena_custodia_sello_intacto];
GO
ALTER TABLE [evidencias].[cadena_custodia] ALTER COLUMN [sello_intacto] TINYINT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_cadena_custodia_sello_intacto' AND parent_object_id=OBJECT_ID(N'evidencias.cadena_custodia'))
    ALTER TABLE [evidencias].[cadena_custodia] WITH CHECK ADD CONSTRAINT [ck_cadena_custodia_sello_intacto] CHECK ([sello_intacto] IN (0,1));
GO

-- personas.persona_natural.es_identificable  ->  TINYINT
ALTER TABLE [personas].[persona_natural] DROP CONSTRAINT IF EXISTS [ck_pn_es_identificable];
GO
ALTER TABLE [personas].[persona_natural] DROP CONSTRAINT IF EXISTS [df_pn_es_identificable];
GO
ALTER TABLE [personas].[persona_natural] ALTER COLUMN [es_identificable] TINYINT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pn_es_identificable' AND parent_object_id=OBJECT_ID(N'personas.persona_natural'))
    ALTER TABLE [personas].[persona_natural] ADD CONSTRAINT [df_pn_es_identificable] DEFAULT (1) FOR [es_identificable];
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_pn_es_identificable' AND parent_object_id=OBJECT_ID(N'personas.persona_natural'))
    ALTER TABLE [personas].[persona_natural] WITH CHECK ADD CONSTRAINT [ck_pn_es_identificable] CHECK ([es_identificable] IN (0,1));
GO


-- ===== SECCION 2: BIT (106) =====

-- configuracion.cat_elemento_dominio.activo  ->  BIT
DROP INDEX IF EXISTS [ix_cat_elemento_dominio_activo] ON [configuracion].[cat_elemento_dominio];
GO
ALTER TABLE [configuracion].[cat_elemento_dominio] DROP CONSTRAINT IF EXISTS [ck_cat_elemento_dominio_activo];
GO
ALTER TABLE [configuracion].[cat_elemento_dominio] DROP CONSTRAINT IF EXISTS [df_cat_elemento_dominio_activo];
GO
ALTER TABLE [configuracion].[cat_elemento_dominio] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_elemento_dominio_activo' AND parent_object_id=OBJECT_ID(N'configuracion.cat_elemento_dominio'))
    ALTER TABLE [configuracion].[cat_elemento_dominio] ADD CONSTRAINT [df_cat_elemento_dominio_activo] DEFAULT (1) FOR [activo];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_cat_elemento_dominio_activo' AND object_id=OBJECT_ID(N'configuracion.cat_elemento_dominio'))
    CREATE INDEX [ix_cat_elemento_dominio_activo] ON [configuracion].[cat_elemento_dominio] (id_dominio, activo);
GO

-- casos.cat_tipo_rol_persona.requiere_telefono  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_telefono];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_telefono];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_telefono] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_telefono' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_telefono] DEFAULT (0) FOR [requiere_telefono];
GO

-- casos.cat_tipo_rol_persona.requiere_correo  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_correo];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_correo];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_correo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_correo' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_correo] DEFAULT (0) FOR [requiere_correo];
GO

-- casos.cat_tipo_rol_persona.requiere_domicilio  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_domicilio];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_domicilio];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_domicilio] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_domicilio' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_domicilio] DEFAULT (0) FOR [requiere_domicilio];
GO

-- casos.cat_tipo_rol_persona.requiere_identificacion  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_identificacion];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_identificacion];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_identificacion] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_identificacion' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_identificacion] DEFAULT (0) FOR [requiere_identificacion];
GO

-- casos.cat_tipo_rol_persona.requiere_fecha_nacimiento  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_fecha_nacimiento];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_fecha_nacimiento];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_fecha_nacimiento] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_fecha_nacimiento' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_fecha_nacimiento] DEFAULT (0) FOR [requiere_fecha_nacimiento];
GO

-- casos.cat_tipo_rol_persona.requiere_ocupacion  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_ocupacion];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_ocupacion];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_ocupacion] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_ocupacion' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_ocupacion] DEFAULT (0) FOR [requiere_ocupacion];
GO

-- casos.cat_tipo_rol_persona.requiere_estado_civil  ->  BIT
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_rol_persona_requiere_estado_civil];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rol_persona_requiere_estado_civil];
GO
ALTER TABLE [casos].[cat_tipo_rol_persona] ALTER COLUMN [requiere_estado_civil] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_estado_civil' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
    ALTER TABLE [casos].[cat_tipo_rol_persona] ADD CONSTRAINT [df_cat_tipo_rol_persona_requiere_estado_civil] DEFAULT (0) FOR [requiere_estado_civil];
GO

-- investigacion.hecho_lugar.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_hecho_lugar_principal_activo] ON [investigacion].[hecho_lugar];
GO
ALTER TABLE [investigacion].[hecho_lugar] DROP CONSTRAINT IF EXISTS [ck_hecho_lugar_es_principal];
GO
ALTER TABLE [investigacion].[hecho_lugar] DROP CONSTRAINT IF EXISTS [df_hecho_lugar_es_principal];
GO
ALTER TABLE [investigacion].[hecho_lugar] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_hecho_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'investigacion.hecho_lugar'))
    ALTER TABLE [investigacion].[hecho_lugar] ADD CONSTRAINT [df_hecho_lugar_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_hecho_lugar_principal_activo' AND object_id=OBJECT_ID(N'investigacion.hecho_lugar'))
    CREATE UNIQUE INDEX [ux_hecho_lugar_principal_activo] ON [investigacion].[hecho_lugar] (id_hecho) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- analitica.cat_tipo_reporte.activo  ->  BIT
ALTER TABLE [analitica].[cat_tipo_reporte] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_reporte_activo];
GO
ALTER TABLE [analitica].[cat_tipo_reporte] DROP CONSTRAINT IF EXISTS [df_cat_tipo_reporte_activo];
GO
ALTER TABLE [analitica].[cat_tipo_reporte] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_reporte_activo' AND parent_object_id=OBJECT_ID(N'analitica.cat_tipo_reporte'))
    ALTER TABLE [analitica].[cat_tipo_reporte] ADD CONSTRAINT [df_cat_tipo_reporte_activo] DEFAULT (1) FOR [activo];
GO

-- analitica.configuracion_reporte_periodico.activo  ->  BIT
ALTER TABLE [analitica].[configuracion_reporte_periodico] DROP CONSTRAINT IF EXISTS [ck_configuracion_reporte_periodico_activo];
GO
ALTER TABLE [analitica].[configuracion_reporte_periodico] DROP CONSTRAINT IF EXISTS [df_configuracion_reporte_periodico_activo];
GO
ALTER TABLE [analitica].[configuracion_reporte_periodico] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_configuracion_reporte_periodico_activo' AND parent_object_id=OBJECT_ID(N'analitica.configuracion_reporte_periodico'))
    ALTER TABLE [analitica].[configuracion_reporte_periodico] ADD CONSTRAINT [df_configuracion_reporte_periodico_activo] DEFAULT (1) FOR [activo];
GO

-- analitica.foco_caso.es_caso_principal  ->  BIT
ALTER TABLE [analitica].[foco_caso] DROP CONSTRAINT IF EXISTS [ck_foco_caso_es_caso_principal];
GO
ALTER TABLE [analitica].[foco_caso] DROP CONSTRAINT IF EXISTS [df_foco_caso_es_caso_principal];
GO
ALTER TABLE [analitica].[foco_caso] ALTER COLUMN [es_caso_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_foco_caso_es_caso_principal' AND parent_object_id=OBJECT_ID(N'analitica.foco_caso'))
    ALTER TABLE [analitica].[foco_caso] ADD CONSTRAINT [df_foco_caso_es_caso_principal] DEFAULT (0) FOR [es_caso_principal];
GO

-- archivos.cat_tipo_archivo.es_multimedia  ->  BIT
ALTER TABLE [archivos].[cat_tipo_archivo] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_archivo_es_multimedia];
GO
ALTER TABLE [archivos].[cat_tipo_archivo] DROP CONSTRAINT IF EXISTS [df_cat_tipo_archivo_es_multimedia];
GO
ALTER TABLE [archivos].[cat_tipo_archivo] ALTER COLUMN [es_multimedia] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_archivo_es_multimedia' AND parent_object_id=OBJECT_ID(N'archivos.cat_tipo_archivo'))
    ALTER TABLE [archivos].[cat_tipo_archivo] ADD CONSTRAINT [df_cat_tipo_archivo_es_multimedia] DEFAULT (0) FOR [es_multimedia];
GO

-- auth.parametro.activo  ->  BIT
ALTER TABLE [auth].[parametro] DROP CONSTRAINT IF EXISTS [ck_parametro_activo];
GO
ALTER TABLE [auth].[parametro] DROP CONSTRAINT IF EXISTS [df_parametro_activo];
GO
ALTER TABLE [auth].[parametro] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_parametro_activo' AND parent_object_id=OBJECT_ID(N'auth.parametro'))
    ALTER TABLE [auth].[parametro] ADD CONSTRAINT [df_parametro_activo] DEFAULT (1) FOR [activo];
GO

-- auth.usuario.activo  ->  BIT
ALTER TABLE [auth].[usuario] DROP CONSTRAINT IF EXISTS [ck_usuario_activo];
GO
ALTER TABLE [auth].[usuario] DROP CONSTRAINT IF EXISTS [df_usuario_activo];
GO
ALTER TABLE [auth].[usuario] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_usuario_activo' AND parent_object_id=OBJECT_ID(N'auth.usuario'))
    ALTER TABLE [auth].[usuario] ADD CONSTRAINT [df_usuario_activo] DEFAULT (1) FOR [activo];
GO

-- casos.cat_estado_caso.es_terminal  ->  BIT
ALTER TABLE [casos].[cat_estado_caso] DROP CONSTRAINT IF EXISTS [ck_cat_estado_caso_es_terminal];
GO
ALTER TABLE [casos].[cat_estado_caso] DROP CONSTRAINT IF EXISTS [df_cat_estado_caso_es_terminal];
GO
ALTER TABLE [casos].[cat_estado_caso] ALTER COLUMN [es_terminal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_caso_es_terminal' AND parent_object_id=OBJECT_ID(N'casos.cat_estado_caso'))
    ALTER TABLE [casos].[cat_estado_caso] ADD CONSTRAINT [df_cat_estado_caso_es_terminal] DEFAULT (0) FOR [es_terminal];
GO

-- casos.cat_grupo_operativo.activo  ->  BIT
ALTER TABLE [casos].[cat_grupo_operativo] DROP CONSTRAINT IF EXISTS [ck_cat_grupo_operativo_activo];
GO
ALTER TABLE [casos].[cat_grupo_operativo] DROP CONSTRAINT IF EXISTS [df_cat_grupo_operativo_activo];
GO
ALTER TABLE [casos].[cat_grupo_operativo] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_grupo_operativo_activo' AND parent_object_id=OBJECT_ID(N'casos.cat_grupo_operativo'))
    ALTER TABLE [casos].[cat_grupo_operativo] ADD CONSTRAINT [df_cat_grupo_operativo_activo] DEFAULT (1) FOR [activo];
GO

-- casos.cat_nivel_seguridad.bloquea_busqueda_externa  ->  BIT
ALTER TABLE [casos].[cat_nivel_seguridad] DROP CONSTRAINT IF EXISTS [ck_cat_nivel_seguridad_bloquea_busqueda_externa];
GO
ALTER TABLE [casos].[cat_nivel_seguridad] DROP CONSTRAINT IF EXISTS [df_cat_nivel_seguridad_bloquea_busqueda_externa];
GO
ALTER TABLE [casos].[cat_nivel_seguridad] ALTER COLUMN [bloquea_busqueda_externa] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_nivel_seguridad_bloquea_busqueda_externa' AND parent_object_id=OBJECT_ID(N'casos.cat_nivel_seguridad'))
    ALTER TABLE [casos].[cat_nivel_seguridad] ADD CONSTRAINT [df_cat_nivel_seguridad_bloquea_busqueda_externa] DEFAULT (0) FOR [bloquea_busqueda_externa];
GO

-- casos.cat_nivel_seguridad.activo  ->  BIT
ALTER TABLE [casos].[cat_nivel_seguridad] DROP CONSTRAINT IF EXISTS [ck_cat_nivel_seguridad_activo];
GO
ALTER TABLE [casos].[cat_nivel_seguridad] DROP CONSTRAINT IF EXISTS [df_cat_nivel_seguridad_activo];
GO
ALTER TABLE [casos].[cat_nivel_seguridad] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_nivel_seguridad_activo' AND parent_object_id=OBJECT_ID(N'casos.cat_nivel_seguridad'))
    ALTER TABLE [casos].[cat_nivel_seguridad] ADD CONSTRAINT [df_cat_nivel_seguridad_activo] DEFAULT (1) FOR [activo];
GO

-- catalogo_bienes.clase.activo  ->  BIT
DROP INDEX IF EXISTS [ix_clase_familia] ON [catalogo_bienes].[clase];
GO
DROP INDEX IF EXISTS [ix_clase_nombre] ON [catalogo_bienes].[clase];
GO
ALTER TABLE [catalogo_bienes].[clase] DROP CONSTRAINT IF EXISTS [ck_clase_activo];
GO
ALTER TABLE [catalogo_bienes].[clase] DROP CONSTRAINT IF EXISTS [df_clase_activo];
GO
ALTER TABLE [catalogo_bienes].[clase] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_clase_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.clase'))
    ALTER TABLE [catalogo_bienes].[clase] ADD CONSTRAINT [df_clase_activo] DEFAULT (1) FOR [activo];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_clase_familia' AND object_id=OBJECT_ID(N'catalogo_bienes.clase'))
    CREATE INDEX [ix_clase_familia] ON [catalogo_bienes].[clase] (id_familia, id_version) INCLUDE (codigo, nombre, activo);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_clase_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.clase'))
    CREATE INDEX [ix_clase_nombre] ON [catalogo_bienes].[clase] (nombre) INCLUDE (codigo, id_version, activo);
GO

-- catalogo_bienes.familia.activo  ->  BIT
DROP INDEX IF EXISTS [ix_familia_segmento] ON [catalogo_bienes].[familia];
GO
DROP INDEX IF EXISTS [ix_familia_nombre] ON [catalogo_bienes].[familia];
GO
ALTER TABLE [catalogo_bienes].[familia] DROP CONSTRAINT IF EXISTS [ck_familia_activo];
GO
ALTER TABLE [catalogo_bienes].[familia] DROP CONSTRAINT IF EXISTS [df_familia_activo];
GO
ALTER TABLE [catalogo_bienes].[familia] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_familia_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.familia'))
    ALTER TABLE [catalogo_bienes].[familia] ADD CONSTRAINT [df_familia_activo] DEFAULT (1) FOR [activo];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_familia_segmento' AND object_id=OBJECT_ID(N'catalogo_bienes.familia'))
    CREATE INDEX [ix_familia_segmento] ON [catalogo_bienes].[familia] (id_segmento, id_version) INCLUDE (codigo, nombre, activo);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_familia_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.familia'))
    CREATE INDEX [ix_familia_nombre] ON [catalogo_bienes].[familia] (nombre) INCLUDE (codigo, id_version, activo);
GO

-- catalogo_bienes.producto.activo  ->  BIT
DROP INDEX IF EXISTS [ix_producto_clase] ON [catalogo_bienes].[producto];
GO
DROP INDEX IF EXISTS [ix_producto_nombre] ON [catalogo_bienes].[producto];
GO
DROP INDEX IF EXISTS [ix_producto_codigo] ON [catalogo_bienes].[producto];
GO
ALTER TABLE [catalogo_bienes].[producto] DROP CONSTRAINT IF EXISTS [ck_producto_activo];
GO
ALTER TABLE [catalogo_bienes].[producto] DROP CONSTRAINT IF EXISTS [df_producto_activo];
GO
ALTER TABLE [catalogo_bienes].[producto] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_producto_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.producto'))
    ALTER TABLE [catalogo_bienes].[producto] ADD CONSTRAINT [df_producto_activo] DEFAULT (1) FOR [activo];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_producto_clase' AND object_id=OBJECT_ID(N'catalogo_bienes.producto'))
    CREATE INDEX [ix_producto_clase] ON [catalogo_bienes].[producto] (id_clase, id_version) INCLUDE (codigo, nombre, activo);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_producto_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.producto'))
    CREATE INDEX [ix_producto_nombre] ON [catalogo_bienes].[producto] (nombre) INCLUDE (codigo, id_version, activo);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_producto_codigo' AND object_id=OBJECT_ID(N'catalogo_bienes.producto'))
    CREATE INDEX [ix_producto_codigo] ON [catalogo_bienes].[producto] (codigo, id_version) INCLUDE (nombre, activo, id_clase);
GO

-- catalogo_bienes.segmento.activo  ->  BIT
DROP INDEX IF EXISTS [ix_segmento_nombre] ON [catalogo_bienes].[segmento];
GO
ALTER TABLE [catalogo_bienes].[segmento] DROP CONSTRAINT IF EXISTS [ck_segmento_activo];
GO
ALTER TABLE [catalogo_bienes].[segmento] DROP CONSTRAINT IF EXISTS [df_segmento_activo];
GO
ALTER TABLE [catalogo_bienes].[segmento] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_segmento_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.segmento'))
    ALTER TABLE [catalogo_bienes].[segmento] ADD CONSTRAINT [df_segmento_activo] DEFAULT (1) FOR [activo];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_segmento_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.segmento'))
    CREATE INDEX [ix_segmento_nombre] ON [catalogo_bienes].[segmento] (nombre) INCLUDE (codigo, id_version, activo);
GO

-- catalogo_bienes.version_catalogo.es_vigente  ->  BIT
DROP INDEX IF EXISTS [uq_version_catalogo_vigente] ON [catalogo_bienes].[version_catalogo];
GO
ALTER TABLE [catalogo_bienes].[version_catalogo] DROP CONSTRAINT IF EXISTS [ck_version_catalogo_es_vigente];
GO
ALTER TABLE [catalogo_bienes].[version_catalogo] DROP CONSTRAINT IF EXISTS [df_version_catalogo_es_vigente];
GO
ALTER TABLE [catalogo_bienes].[version_catalogo] ALTER COLUMN [es_vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_version_catalogo_es_vigente' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.version_catalogo'))
    ALTER TABLE [catalogo_bienes].[version_catalogo] ADD CONSTRAINT [df_version_catalogo_es_vigente] DEFAULT (0) FOR [es_vigente];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'uq_version_catalogo_vigente' AND object_id=OBJECT_ID(N'catalogo_bienes.version_catalogo'))
    CREATE UNIQUE INDEX [uq_version_catalogo_vigente] ON [catalogo_bienes].[version_catalogo] (es_vigente) WHERE es_vigente = 1;
GO

-- configuracion.cat_programa_seguridad.activo  ->  BIT
ALTER TABLE [configuracion].[cat_programa_seguridad] DROP CONSTRAINT IF EXISTS [ck_cat_programa_seguridad_activo];
GO
ALTER TABLE [configuracion].[cat_programa_seguridad] DROP CONSTRAINT IF EXISTS [df_cat_programa_seguridad_activo];
GO
ALTER TABLE [configuracion].[cat_programa_seguridad] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_programa_seguridad_activo' AND parent_object_id=OBJECT_ID(N'configuracion.cat_programa_seguridad'))
    ALTER TABLE [configuracion].[cat_programa_seguridad] ADD CONSTRAINT [df_cat_programa_seguridad_activo] DEFAULT (1) FOR [activo];
GO

-- cooperacion_int.cat_elemento_cooperacion_internacional.activo  ->  BIT
ALTER TABLE [cooperacion_int].[cat_elemento_cooperacion_internacional] DROP CONSTRAINT IF EXISTS [ck_cat_elemento_cooperacion_internacional_activo];
GO
ALTER TABLE [cooperacion_int].[cat_elemento_cooperacion_internacional] DROP CONSTRAINT IF EXISTS [df_cat_elemento_cooperacion_internacional_activo];
GO
ALTER TABLE [cooperacion_int].[cat_elemento_cooperacion_internacional] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_elemento_cooperacion_internacional_activo' AND parent_object_id=OBJECT_ID(N'cooperacion_int.cat_elemento_cooperacion_internacional'))
    ALTER TABLE [cooperacion_int].[cat_elemento_cooperacion_internacional] ADD CONSTRAINT [df_cat_elemento_cooperacion_internacional_activo] DEFAULT (1) FOR [activo];
GO

-- cooperacion_int.entidad_interpol.es_pdi  ->  BIT
ALTER TABLE [cooperacion_int].[entidad_interpol] DROP CONSTRAINT IF EXISTS [ck_entidad_interpol_es_pdi];
GO
ALTER TABLE [cooperacion_int].[entidad_interpol] DROP CONSTRAINT IF EXISTS [df_entidad_interpol_es_pdi];
GO
ALTER TABLE [cooperacion_int].[entidad_interpol] ALTER COLUMN [es_pdi] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_entidad_interpol_es_pdi' AND parent_object_id=OBJECT_ID(N'cooperacion_int.entidad_interpol'))
    ALTER TABLE [cooperacion_int].[entidad_interpol] ADD CONSTRAINT [df_entidad_interpol_es_pdi] DEFAULT (0) FOR [es_pdi];
GO

-- cooperacion_int.entidad_interpol.activo  ->  BIT
ALTER TABLE [cooperacion_int].[entidad_interpol] DROP CONSTRAINT IF EXISTS [ck_entidad_interpol_activo];
GO
ALTER TABLE [cooperacion_int].[entidad_interpol] DROP CONSTRAINT IF EXISTS [df_entidad_interpol_activo];
GO
ALTER TABLE [cooperacion_int].[entidad_interpol] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_entidad_interpol_activo' AND parent_object_id=OBJECT_ID(N'cooperacion_int.entidad_interpol'))
    ALTER TABLE [cooperacion_int].[entidad_interpol] ADD CONSTRAINT [df_entidad_interpol_activo] DEFAULT (1) FOR [activo];
GO

-- cooperacion_int.estado_solicitud_interpol.activo  ->  BIT
ALTER TABLE [cooperacion_int].[estado_solicitud_interpol] DROP CONSTRAINT IF EXISTS [ck_estado_solicitud_interpol_activo];
GO
ALTER TABLE [cooperacion_int].[estado_solicitud_interpol] DROP CONSTRAINT IF EXISTS [df_estado_solicitud_interpol_activo];
GO
ALTER TABLE [cooperacion_int].[estado_solicitud_interpol] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_estado_solicitud_interpol_activo' AND parent_object_id=OBJECT_ID(N'cooperacion_int.estado_solicitud_interpol'))
    ALTER TABLE [cooperacion_int].[estado_solicitud_interpol] ADD CONSTRAINT [df_estado_solicitud_interpol_activo] DEFAULT (1) FOR [activo];
GO

-- cooperacion_int.solicitud_interpol.tiene_huella_dactilar  ->  BIT
ALTER TABLE [cooperacion_int].[solicitud_interpol] DROP CONSTRAINT IF EXISTS [ck_solicitud_interpol_tiene_huella_dactilar];
GO
ALTER TABLE [cooperacion_int].[solicitud_interpol] DROP CONSTRAINT IF EXISTS [df_solicitud_interpol_tiene_huella_dactilar];
GO
ALTER TABLE [cooperacion_int].[solicitud_interpol] ALTER COLUMN [tiene_huella_dactilar] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_solicitud_interpol_tiene_huella_dactilar' AND parent_object_id=OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
    ALTER TABLE [cooperacion_int].[solicitud_interpol] ADD CONSTRAINT [df_solicitud_interpol_tiene_huella_dactilar] DEFAULT (0) FOR [tiene_huella_dactilar];
GO

-- cooperacion_int.solicitud_interpol.bloquear_edicion_origen  ->  BIT
ALTER TABLE [cooperacion_int].[solicitud_interpol] DROP CONSTRAINT IF EXISTS [ck_solicitud_interpol_bloquear_edicion_origen];
GO
ALTER TABLE [cooperacion_int].[solicitud_interpol] DROP CONSTRAINT IF EXISTS [df_solicitud_interpol_bloquear_edicion_origen];
GO
ALTER TABLE [cooperacion_int].[solicitud_interpol] ALTER COLUMN [bloquear_edicion_origen] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_solicitud_interpol_bloquear_edicion_origen' AND parent_object_id=OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
    ALTER TABLE [cooperacion_int].[solicitud_interpol] ADD CONSTRAINT [df_solicitud_interpol_bloquear_edicion_origen] DEFAULT (0) FOR [bloquear_edicion_origen];
GO

-- denuncias.cat_estado_denuncia.es_terminal  ->  BIT
ALTER TABLE [denuncias].[cat_estado_denuncia] DROP CONSTRAINT IF EXISTS [ck_cat_estado_denuncia_es_terminal];
GO
ALTER TABLE [denuncias].[cat_estado_denuncia] DROP CONSTRAINT IF EXISTS [df_cat_estado_denuncia_es_terminal];
GO
ALTER TABLE [denuncias].[cat_estado_denuncia] ALTER COLUMN [es_terminal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_denuncia_es_terminal' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_denuncia'))
    ALTER TABLE [denuncias].[cat_estado_denuncia] ADD CONSTRAINT [df_cat_estado_denuncia_es_terminal] DEFAULT (0) FOR [es_terminal];
GO

-- denuncias.cat_estado_denuncia.activo  ->  BIT
ALTER TABLE [denuncias].[cat_estado_denuncia] DROP CONSTRAINT IF EXISTS [ck_cat_estado_denuncia_activo];
GO
ALTER TABLE [denuncias].[cat_estado_denuncia] DROP CONSTRAINT IF EXISTS [df_cat_estado_denuncia_activo];
GO
ALTER TABLE [denuncias].[cat_estado_denuncia] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_denuncia_activo' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_denuncia'))
    ALTER TABLE [denuncias].[cat_estado_denuncia] ADD CONSTRAINT [df_cat_estado_denuncia_activo] DEFAULT (1) FOR [activo];
GO

-- denuncias.cat_estado_envio_fiscalia.es_terminal  ->  BIT
ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] DROP CONSTRAINT IF EXISTS [ck_cat_estado_envio_fiscalia_es_terminal];
GO
ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] DROP CONSTRAINT IF EXISTS [df_cat_estado_envio_fiscalia_es_terminal];
GO
ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] ALTER COLUMN [es_terminal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_envio_fiscalia_es_terminal' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_envio_fiscalia'))
    ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] ADD CONSTRAINT [df_cat_estado_envio_fiscalia_es_terminal] DEFAULT (0) FOR [es_terminal];
GO

-- denuncias.cat_estado_envio_fiscalia.activo  ->  BIT
ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] DROP CONSTRAINT IF EXISTS [ck_cat_estado_envio_fiscalia_activo];
GO
ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] DROP CONSTRAINT IF EXISTS [df_cat_estado_envio_fiscalia_activo];
GO
ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_envio_fiscalia_activo' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_envio_fiscalia'))
    ALTER TABLE [denuncias].[cat_estado_envio_fiscalia] ADD CONSTRAINT [df_cat_estado_envio_fiscalia_activo] DEFAULT (1) FOR [activo];
GO

-- denuncias.cat_tipo_denuncia.activo  ->  BIT
ALTER TABLE [denuncias].[cat_tipo_denuncia] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_denuncia_activo];
GO
ALTER TABLE [denuncias].[cat_tipo_denuncia] DROP CONSTRAINT IF EXISTS [df_cat_tipo_denuncia_activo];
GO
ALTER TABLE [denuncias].[cat_tipo_denuncia] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_denuncia_activo' AND parent_object_id=OBJECT_ID(N'denuncias.cat_tipo_denuncia'))
    ALTER TABLE [denuncias].[cat_tipo_denuncia] ADD CONSTRAINT [df_cat_tipo_denuncia_activo] DEFAULT (1) FOR [activo];
GO

-- denuncias.denuncia_persona_rol.es_declarante  ->  BIT
ALTER TABLE [denuncias].[denuncia_persona_rol] DROP CONSTRAINT IF EXISTS [ck_denuncia_persona_rol_es_declarante];
GO
ALTER TABLE [denuncias].[denuncia_persona_rol] DROP CONSTRAINT IF EXISTS [df_denuncia_persona_rol_es_declarante];
GO
ALTER TABLE [denuncias].[denuncia_persona_rol] ALTER COLUMN [es_declarante] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_denuncia_persona_rol_es_declarante' AND parent_object_id=OBJECT_ID(N'denuncias.denuncia_persona_rol'))
    ALTER TABLE [denuncias].[denuncia_persona_rol] ADD CONSTRAINT [df_denuncia_persona_rol_es_declarante] DEFAULT (0) FOR [es_declarante];
GO

-- denuncias.denuncia_persona_rol.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_denperrol_principal_activo] ON [denuncias].[denuncia_persona_rol];
GO
ALTER TABLE [denuncias].[denuncia_persona_rol] DROP CONSTRAINT IF EXISTS [ck_denuncia_persona_rol_es_principal];
GO
ALTER TABLE [denuncias].[denuncia_persona_rol] DROP CONSTRAINT IF EXISTS [df_denuncia_persona_rol_es_principal];
GO
ALTER TABLE [denuncias].[denuncia_persona_rol] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_denuncia_persona_rol_es_principal' AND parent_object_id=OBJECT_ID(N'denuncias.denuncia_persona_rol'))
    ALTER TABLE [denuncias].[denuncia_persona_rol] ADD CONSTRAINT [df_denuncia_persona_rol_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_denperrol_principal_activo' AND object_id=OBJECT_ID(N'denuncias.denuncia_persona_rol'))
    CREATE UNIQUE INDEX [ux_denperrol_principal_activo] ON [denuncias].[denuncia_persona_rol] (id_denuncia) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- denuncias.pauta_vif.firma_apercibimiento_art26  ->  BIT
ALTER TABLE [denuncias].[pauta_vif] DROP CONSTRAINT IF EXISTS [ck_pauta_vif_firma_apercibimiento_art26];
GO
ALTER TABLE [denuncias].[pauta_vif] DROP CONSTRAINT IF EXISTS [df_pauta_vif_firma_apercibimiento_art26];
GO
ALTER TABLE [denuncias].[pauta_vif] ALTER COLUMN [firma_apercibimiento_art26] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pauta_vif_firma_apercibimiento_art26' AND parent_object_id=OBJECT_ID(N'denuncias.pauta_vif'))
    ALTER TABLE [denuncias].[pauta_vif] ADD CONSTRAINT [df_pauta_vif_firma_apercibimiento_art26] DEFAULT (0) FOR [firma_apercibimiento_art26];
GO

-- denuncias.relato.declarante_es_denunciante  ->  BIT
ALTER TABLE [denuncias].[relato] DROP CONSTRAINT IF EXISTS [ck_relato_declarante_es_denunciante];
GO
ALTER TABLE [denuncias].[relato] DROP CONSTRAINT IF EXISTS [df_relato_declarante_es_denunciante];
GO
ALTER TABLE [denuncias].[relato] ALTER COLUMN [declarante_es_denunciante] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_relato_declarante_es_denunciante' AND parent_object_id=OBJECT_ID(N'denuncias.relato'))
    ALTER TABLE [denuncias].[relato] ADD CONSTRAINT [df_relato_declarante_es_denunciante] DEFAULT (1) FOR [declarante_es_denunciante];
GO

-- diligencias.cat_especialidad_pericial.activo  ->  BIT
ALTER TABLE [diligencias].[cat_especialidad_pericial] DROP CONSTRAINT IF EXISTS [ck_cat_especialidad_pericial_activo];
GO
ALTER TABLE [diligencias].[cat_especialidad_pericial] DROP CONSTRAINT IF EXISTS [df_cat_especialidad_pericial_activo];
GO
ALTER TABLE [diligencias].[cat_especialidad_pericial] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_especialidad_pericial_activo' AND parent_object_id=OBJECT_ID(N'diligencias.cat_especialidad_pericial'))
    ALTER TABLE [diligencias].[cat_especialidad_pericial] ADD CONSTRAINT [df_cat_especialidad_pericial_activo] DEFAULT (1) FOR [activo];
GO

-- diligencias.cat_tipo_diligencia.es_primera_diligencia  ->  BIT
ALTER TABLE [diligencias].[cat_tipo_diligencia] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_diligencia_es_primera_diligencia];
GO
ALTER TABLE [diligencias].[cat_tipo_diligencia] DROP CONSTRAINT IF EXISTS [df_cat_tipo_diligencia_es_primera_diligencia];
GO
ALTER TABLE [diligencias].[cat_tipo_diligencia] ALTER COLUMN [es_primera_diligencia] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_diligencia_es_primera_diligencia' AND parent_object_id=OBJECT_ID(N'diligencias.cat_tipo_diligencia'))
    ALTER TABLE [diligencias].[cat_tipo_diligencia] ADD CONSTRAINT [df_cat_tipo_diligencia_es_primera_diligencia] DEFAULT (0) FOR [es_primera_diligencia];
GO

-- diligencias.cat_tipo_diligencia.requiere_autorizacion_judicial  ->  BIT
ALTER TABLE [diligencias].[cat_tipo_diligencia] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_diligencia_requiere_autorizacion_judicial];
GO
ALTER TABLE [diligencias].[cat_tipo_diligencia] DROP CONSTRAINT IF EXISTS [df_cat_tipo_diligencia_requiere_autorizacion_judicial];
GO
ALTER TABLE [diligencias].[cat_tipo_diligencia] ALTER COLUMN [requiere_autorizacion_judicial] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_diligencia_requiere_autorizacion_judicial' AND parent_object_id=OBJECT_ID(N'diligencias.cat_tipo_diligencia'))
    ALTER TABLE [diligencias].[cat_tipo_diligencia] ADD CONSTRAINT [df_cat_tipo_diligencia_requiere_autorizacion_judicial] DEFAULT (0) FOR [requiere_autorizacion_judicial];
GO

-- diligencias.cat_tipo_notificacion_externa.actualiza_estado_caso  ->  BIT
ALTER TABLE [diligencias].[cat_tipo_notificacion_externa] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_notificacion_externa_actualiza_estado_caso];
GO
ALTER TABLE [diligencias].[cat_tipo_notificacion_externa] DROP CONSTRAINT IF EXISTS [df_cat_tipo_notificacion_externa_actualiza_estado_caso];
GO
ALTER TABLE [diligencias].[cat_tipo_notificacion_externa] ALTER COLUMN [actualiza_estado_caso] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_notificacion_externa_actualiza_estado_caso' AND parent_object_id=OBJECT_ID(N'diligencias.cat_tipo_notificacion_externa'))
    ALTER TABLE [diligencias].[cat_tipo_notificacion_externa] ADD CONSTRAINT [df_cat_tipo_notificacion_externa_actualiza_estado_caso] DEFAULT (0) FOR [actualiza_estado_caso];
GO

-- diligencias.detencion.alerta_extranjero  ->  BIT
ALTER TABLE [diligencias].[detencion] DROP CONSTRAINT IF EXISTS [ck_detencion_alerta_extranjero];
GO
ALTER TABLE [diligencias].[detencion] DROP CONSTRAINT IF EXISTS [df_detencion_alerta_extranjero];
GO
ALTER TABLE [diligencias].[detencion] ALTER COLUMN [alerta_extranjero] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_detencion_alerta_extranjero' AND parent_object_id=OBJECT_ID(N'diligencias.detencion'))
    ALTER TABLE [diligencias].[detencion] ADD CONSTRAINT [df_detencion_alerta_extranjero] DEFAULT (0) FOR [alerta_extranjero];
GO

-- diligencias.detencion_lugar.es_principal  ->  BIT
ALTER TABLE [diligencias].[detencion_lugar] DROP CONSTRAINT IF EXISTS [ck_detencion_lugar_es_principal];
GO
ALTER TABLE [diligencias].[detencion_lugar] DROP CONSTRAINT IF EXISTS [df_detencion_lugar_es_principal];
GO
ALTER TABLE [diligencias].[detencion_lugar] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_detencion_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'diligencias.detencion_lugar'))
    ALTER TABLE [diligencias].[detencion_lugar] ADD CONSTRAINT [df_detencion_lugar_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- diligencias.diligencia.es_origen_institucional  ->  BIT
ALTER TABLE [diligencias].[diligencia] DROP CONSTRAINT IF EXISTS [ck_diligencia_es_origen_institucional];
GO
ALTER TABLE [diligencias].[diligencia] DROP CONSTRAINT IF EXISTS [df_diligencia_es_origen_institucional];
GO
ALTER TABLE [diligencias].[diligencia] ALTER COLUMN [es_origen_institucional] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_es_origen_institucional' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia'))
    ALTER TABLE [diligencias].[diligencia] ADD CONSTRAINT [df_diligencia_es_origen_institucional] DEFAULT (0) FOR [es_origen_institucional];
GO

-- diligencias.diligencia.autoriza_descerrajamiento  ->  BIT
ALTER TABLE [diligencias].[diligencia] DROP CONSTRAINT IF EXISTS [ck_diligencia_autoriza_descerrajamiento];
GO
ALTER TABLE [diligencias].[diligencia] DROP CONSTRAINT IF EXISTS [df_diligencia_autoriza_descerrajamiento];
GO
ALTER TABLE [diligencias].[diligencia] ALTER COLUMN [autoriza_descerrajamiento] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_autoriza_descerrajamiento' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia'))
    ALTER TABLE [diligencias].[diligencia] ADD CONSTRAINT [df_diligencia_autoriza_descerrajamiento] DEFAULT (0) FOR [autoriza_descerrajamiento];
GO

-- diligencias.diligencia.es_bitacora  ->  BIT
ALTER TABLE [diligencias].[diligencia] DROP CONSTRAINT IF EXISTS [ck_diligencia_es_bitacora];
GO
ALTER TABLE [diligencias].[diligencia] DROP CONSTRAINT IF EXISTS [df_diligencia_es_bitacora];
GO
ALTER TABLE [diligencias].[diligencia] ALTER COLUMN [es_bitacora] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_es_bitacora' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia'))
    ALTER TABLE [diligencias].[diligencia] ADD CONSTRAINT [df_diligencia_es_bitacora] DEFAULT (0) FOR [es_bitacora];
GO

-- diligencias.diligencia_lugar.es_principal  ->  BIT
ALTER TABLE [diligencias].[diligencia_lugar] DROP CONSTRAINT IF EXISTS [ck_diligencia_lugar_es_principal];
GO
ALTER TABLE [diligencias].[diligencia_lugar] DROP CONSTRAINT IF EXISTS [df_diligencia_lugar_es_principal];
GO
ALTER TABLE [diligencias].[diligencia_lugar] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia_lugar'))
    ALTER TABLE [diligencias].[diligencia_lugar] ADD CONSTRAINT [df_diligencia_lugar_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- diligencias.instruccion_fiscal.es_orden_verbal  ->  BIT
ALTER TABLE [diligencias].[instruccion_fiscal] DROP CONSTRAINT IF EXISTS [ck_instruccion_fiscal_es_orden_verbal];
GO
ALTER TABLE [diligencias].[instruccion_fiscal] DROP CONSTRAINT IF EXISTS [df_instruccion_fiscal_es_orden_verbal];
GO
ALTER TABLE [diligencias].[instruccion_fiscal] ALTER COLUMN [es_orden_verbal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_instruccion_fiscal_es_orden_verbal' AND parent_object_id=OBJECT_ID(N'diligencias.instruccion_fiscal'))
    ALTER TABLE [diligencias].[instruccion_fiscal] ADD CONSTRAINT [df_instruccion_fiscal_es_orden_verbal] DEFAULT (0) FOR [es_orden_verbal];
GO

-- diligencias.instruccion_fiscal.es_secreto  ->  BIT
ALTER TABLE [diligencias].[instruccion_fiscal] DROP CONSTRAINT IF EXISTS [ck_instruccion_fiscal_es_secreto];
GO
ALTER TABLE [diligencias].[instruccion_fiscal] DROP CONSTRAINT IF EXISTS [df_instruccion_fiscal_es_secreto];
GO
ALTER TABLE [diligencias].[instruccion_fiscal] ALTER COLUMN [es_secreto] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_instruccion_fiscal_es_secreto' AND parent_object_id=OBJECT_ID(N'diligencias.instruccion_fiscal'))
    ALTER TABLE [diligencias].[instruccion_fiscal] ADD CONSTRAINT [df_instruccion_fiscal_es_secreto] DEFAULT (0) FOR [es_secreto];
GO

-- diligencias.orden_detencion.es_secreta  ->  BIT
ALTER TABLE [diligencias].[orden_detencion] DROP CONSTRAINT IF EXISTS [ck_orden_detencion_es_secreta];
GO
ALTER TABLE [diligencias].[orden_detencion] DROP CONSTRAINT IF EXISTS [df_orden_detencion_es_secreta];
GO
ALTER TABLE [diligencias].[orden_detencion] ALTER COLUMN [es_secreta] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_orden_detencion_es_secreta' AND parent_object_id=OBJECT_ID(N'diligencias.orden_detencion'))
    ALTER TABLE [diligencias].[orden_detencion] ADD CONSTRAINT [df_orden_detencion_es_secreta] DEFAULT (0) FOR [es_secreta];
GO

-- diligencias.solicitud_concurrencia_pericial.es_homicidio  ->  BIT
ALTER TABLE [diligencias].[solicitud_concurrencia_pericial] DROP CONSTRAINT IF EXISTS [ck_solicitud_concurrencia_pericial_es_homicidio];
GO
ALTER TABLE [diligencias].[solicitud_concurrencia_pericial] DROP CONSTRAINT IF EXISTS [df_solicitud_concurrencia_pericial_es_homicidio];
GO
ALTER TABLE [diligencias].[solicitud_concurrencia_pericial] ALTER COLUMN [es_homicidio] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_solicitud_concurrencia_pericial_es_homicidio' AND parent_object_id=OBJECT_ID(N'diligencias.solicitud_concurrencia_pericial'))
    ALTER TABLE [diligencias].[solicitud_concurrencia_pericial] ADD CONSTRAINT [df_solicitud_concurrencia_pericial_es_homicidio] DEFAULT (0) FOR [es_homicidio];
GO

-- evidencias.arma.es_mencionada  ->  BIT
ALTER TABLE [evidencias].[arma] DROP CONSTRAINT IF EXISTS [ck_arma_es_mencionada];
GO
ALTER TABLE [evidencias].[arma] DROP CONSTRAINT IF EXISTS [df_arma_es_mencionada];
GO
ALTER TABLE [evidencias].[arma] ALTER COLUMN [es_mencionada] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_arma_es_mencionada' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
    ALTER TABLE [evidencias].[arma] ADD CONSTRAINT [df_arma_es_mencionada] DEFAULT (0) FOR [es_mencionada];
GO

-- evidencias.cat_catalogo_armas.activo  ->  BIT
ALTER TABLE [evidencias].[cat_catalogo_armas] DROP CONSTRAINT IF EXISTS [ck_cat_catalogo_armas_activo];
GO
ALTER TABLE [evidencias].[cat_catalogo_armas] DROP CONSTRAINT IF EXISTS [df_cat_catalogo_armas_activo];
GO
ALTER TABLE [evidencias].[cat_catalogo_armas] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_catalogo_armas_activo' AND parent_object_id=OBJECT_ID(N'evidencias.cat_catalogo_armas'))
    ALTER TABLE [evidencias].[cat_catalogo_armas] ADD CONSTRAINT [df_cat_catalogo_armas_activo] DEFAULT (1) FOR [activo];
GO

-- evidencias.cat_clasificacion_arma.activo  ->  BIT
ALTER TABLE [evidencias].[cat_clasificacion_arma] DROP CONSTRAINT IF EXISTS [ck_cat_clasificacion_arma_activo];
GO
ALTER TABLE [evidencias].[cat_clasificacion_arma] DROP CONSTRAINT IF EXISTS [df_cat_clasificacion_arma_activo];
GO
ALTER TABLE [evidencias].[cat_clasificacion_arma] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_clasificacion_arma_activo' AND parent_object_id=OBJECT_ID(N'evidencias.cat_clasificacion_arma'))
    ALTER TABLE [evidencias].[cat_clasificacion_arma] ADD CONSTRAINT [df_cat_clasificacion_arma_activo] DEFAULT (1) FOR [activo];
GO

-- evidencias.cat_droga.activo  ->  BIT
ALTER TABLE [evidencias].[cat_droga] DROP CONSTRAINT IF EXISTS [ck_cat_droga_activo];
GO
ALTER TABLE [evidencias].[cat_droga] DROP CONSTRAINT IF EXISTS [df_cat_droga_activo];
GO
ALTER TABLE [evidencias].[cat_droga] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_droga_activo' AND parent_object_id=OBJECT_ID(N'evidencias.cat_droga'))
    ALTER TABLE [evidencias].[cat_droga] ADD CONSTRAINT [df_cat_droga_activo] DEFAULT (1) FOR [activo];
GO

-- evidencias.cat_estado_especie.es_salida_definitiva  ->  BIT
ALTER TABLE [evidencias].[cat_estado_especie] DROP CONSTRAINT IF EXISTS [ck_cat_estado_especie_es_salida_definitiva];
GO
ALTER TABLE [evidencias].[cat_estado_especie] DROP CONSTRAINT IF EXISTS [df_cat_estado_especie_es_salida_definitiva];
GO
ALTER TABLE [evidencias].[cat_estado_especie] ALTER COLUMN [es_salida_definitiva] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_especie_es_salida_definitiva' AND parent_object_id=OBJECT_ID(N'evidencias.cat_estado_especie'))
    ALTER TABLE [evidencias].[cat_estado_especie] ADD CONSTRAINT [df_cat_estado_especie_es_salida_definitiva] DEFAULT (0) FOR [es_salida_definitiva];
GO

-- evidencias.cat_tipo_extension_especie.requiere_extension  ->  BIT
ALTER TABLE [evidencias].[cat_tipo_extension_especie] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_extension_especie_requiere_extension];
GO
ALTER TABLE [evidencias].[cat_tipo_extension_especie] DROP CONSTRAINT IF EXISTS [df_cat_tipo_extension_especie_requiere_extension];
GO
ALTER TABLE [evidencias].[cat_tipo_extension_especie] ALTER COLUMN [requiere_extension] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_extension_especie_requiere_extension' AND parent_object_id=OBJECT_ID(N'evidencias.cat_tipo_extension_especie'))
    ALTER TABLE [evidencias].[cat_tipo_extension_especie] ADD CONSTRAINT [df_cat_tipo_extension_especie_requiere_extension] DEFAULT (0) FOR [requiere_extension];
GO

-- evidencias.especie.registro_fotografico  ->  BIT
ALTER TABLE [evidencias].[especie] DROP CONSTRAINT IF EXISTS [ck_especie_registro_fotografico];
GO
ALTER TABLE [evidencias].[especie] DROP CONSTRAINT IF EXISTS [df_especie_registro_fotografico];
GO
ALTER TABLE [evidencias].[especie] ALTER COLUMN [registro_fotografico] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_especie_registro_fotografico' AND parent_object_id=OBJECT_ID(N'evidencias.especie'))
    ALTER TABLE [evidencias].[especie] ADD CONSTRAINT [df_especie_registro_fotografico] DEFAULT (0) FOR [registro_fotografico];
GO

-- evidencias.especie_droga.es_orientativo  ->  BIT
ALTER TABLE [evidencias].[especie_droga] DROP CONSTRAINT IF EXISTS [ck_especie_droga_es_orientativo];
GO
ALTER TABLE [evidencias].[especie_droga] DROP CONSTRAINT IF EXISTS [df_especie_droga_es_orientativo];
GO
ALTER TABLE [evidencias].[especie_droga] ALTER COLUMN [es_orientativo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_especie_droga_es_orientativo' AND parent_object_id=OBJECT_ID(N'evidencias.especie_droga'))
    ALTER TABLE [evidencias].[especie_droga] ADD CONSTRAINT [df_especie_droga_es_orientativo] DEFAULT (0) FOR [es_orientativo];
GO

-- evidencias.especie_lugar.es_principal  ->  BIT
ALTER TABLE [evidencias].[especie_lugar] DROP CONSTRAINT IF EXISTS [ck_especie_lugar_es_principal];
GO
ALTER TABLE [evidencias].[especie_lugar] DROP CONSTRAINT IF EXISTS [df_especie_lugar_es_principal];
GO
ALTER TABLE [evidencias].[especie_lugar] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_especie_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'evidencias.especie_lugar'))
    ALTER TABLE [evidencias].[especie_lugar] ADD CONSTRAINT [df_especie_lugar_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- evidencias.evidencia_lugar.es_principal  ->  BIT
ALTER TABLE [evidencias].[evidencia_lugar] DROP CONSTRAINT IF EXISTS [ck_evidencia_lugar_es_principal];
GO
ALTER TABLE [evidencias].[evidencia_lugar] DROP CONSTRAINT IF EXISTS [df_evidencia_lugar_es_principal];
GO
ALTER TABLE [evidencias].[evidencia_lugar] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_evidencia_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'evidencias.evidencia_lugar'))
    ALTER TABLE [evidencias].[evidencia_lugar] ADD CONSTRAINT [df_evidencia_lugar_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- evidencias.incautacion.acta_generada  ->  BIT
ALTER TABLE [evidencias].[incautacion] DROP CONSTRAINT IF EXISTS [ck_incautacion_acta_generada];
GO
ALTER TABLE [evidencias].[incautacion] DROP CONSTRAINT IF EXISTS [df_incautacion_acta_generada];
GO
ALTER TABLE [evidencias].[incautacion] ALTER COLUMN [acta_generada] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_incautacion_acta_generada' AND parent_object_id=OBJECT_ID(N'evidencias.incautacion'))
    ALTER TABLE [evidencias].[incautacion] ADD CONSTRAINT [df_incautacion_acta_generada] DEFAULT (0) FOR [acta_generada];
GO

-- investigacion.cat_delito.requiere_peritaje_adn  ->  BIT
ALTER TABLE [investigacion].[cat_delito] DROP CONSTRAINT IF EXISTS [ck_cat_delito_requiere_peritaje_adn];
GO
ALTER TABLE [investigacion].[cat_delito] DROP CONSTRAINT IF EXISTS [df_cat_delito_requiere_peritaje_adn];
GO
ALTER TABLE [investigacion].[cat_delito] ALTER COLUMN [requiere_peritaje_adn] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_delito_requiere_peritaje_adn' AND parent_object_id=OBJECT_ID(N'investigacion.cat_delito'))
    ALTER TABLE [investigacion].[cat_delito] ADD CONSTRAINT [df_cat_delito_requiere_peritaje_adn] DEFAULT (0) FOR [requiere_peritaje_adn];
GO

-- investigacion.cat_delito.vigente  ->  BIT
ALTER TABLE [investigacion].[cat_delito] DROP CONSTRAINT IF EXISTS [ck_cat_delito_vigente];
GO
ALTER TABLE [investigacion].[cat_delito] DROP CONSTRAINT IF EXISTS [df_cat_delito_vigente];
GO
ALTER TABLE [investigacion].[cat_delito] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_delito_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_delito'))
    ALTER TABLE [investigacion].[cat_delito] ADD CONSTRAINT [df_cat_delito_vigente] DEFAULT (1) FOR [vigente];
GO

-- investigacion.cat_detalle_lugar_general_hecho.activo  ->  BIT
ALTER TABLE [investigacion].[cat_detalle_lugar_general_hecho] DROP CONSTRAINT IF EXISTS [ck_cat_detalle_lugar_general_hecho_activo];
GO
ALTER TABLE [investigacion].[cat_detalle_lugar_general_hecho] DROP CONSTRAINT IF EXISTS [df_cat_detalle_lugar_general_hecho_activo];
GO
ALTER TABLE [investigacion].[cat_detalle_lugar_general_hecho] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_detalle_lugar_general_hecho_activo' AND parent_object_id=OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'))
    ALTER TABLE [investigacion].[cat_detalle_lugar_general_hecho] ADD CONSTRAINT [df_cat_detalle_lugar_general_hecho_activo] DEFAULT (1) FOR [activo];
GO

-- investigacion.cat_forma_contacto.vigente  ->  BIT
ALTER TABLE [investigacion].[cat_forma_contacto] DROP CONSTRAINT IF EXISTS [ck_cat_forma_contacto_vigente];
GO
ALTER TABLE [investigacion].[cat_forma_contacto] DROP CONSTRAINT IF EXISTS [df_cat_forma_contacto_vigente];
GO
ALTER TABLE [investigacion].[cat_forma_contacto] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_forma_contacto_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_forma_contacto'))
    ALTER TABLE [investigacion].[cat_forma_contacto] ADD CONSTRAINT [df_cat_forma_contacto_vigente] DEFAULT (1) FOR [vigente];
GO

-- investigacion.cat_lugar_general_hecho.activo  ->  BIT
ALTER TABLE [investigacion].[cat_lugar_general_hecho] DROP CONSTRAINT IF EXISTS [ck_cat_lugar_general_hecho_activo];
GO
ALTER TABLE [investigacion].[cat_lugar_general_hecho] DROP CONSTRAINT IF EXISTS [df_cat_lugar_general_hecho_activo];
GO
ALTER TABLE [investigacion].[cat_lugar_general_hecho] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_lugar_general_hecho_activo' AND parent_object_id=OBJECT_ID(N'investigacion.cat_lugar_general_hecho'))
    ALTER TABLE [investigacion].[cat_lugar_general_hecho] ADD CONSTRAINT [df_cat_lugar_general_hecho_activo] DEFAULT (1) FOR [activo];
GO

-- investigacion.cat_movil.aplica_homicidio  ->  BIT
ALTER TABLE [investigacion].[cat_movil] DROP CONSTRAINT IF EXISTS [ck_cat_movil_aplica_homicidio];
GO
ALTER TABLE [investigacion].[cat_movil] DROP CONSTRAINT IF EXISTS [df_cat_movil_aplica_homicidio];
GO
ALTER TABLE [investigacion].[cat_movil] ALTER COLUMN [aplica_homicidio] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_movil_aplica_homicidio' AND parent_object_id=OBJECT_ID(N'investigacion.cat_movil'))
    ALTER TABLE [investigacion].[cat_movil] ADD CONSTRAINT [df_cat_movil_aplica_homicidio] DEFAULT (0) FOR [aplica_homicidio];
GO

-- investigacion.cat_movil.aplica_secuestro  ->  BIT
ALTER TABLE [investigacion].[cat_movil] DROP CONSTRAINT IF EXISTS [ck_cat_movil_aplica_secuestro];
GO
ALTER TABLE [investigacion].[cat_movil] DROP CONSTRAINT IF EXISTS [df_cat_movil_aplica_secuestro];
GO
ALTER TABLE [investigacion].[cat_movil] ALTER COLUMN [aplica_secuestro] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_movil_aplica_secuestro' AND parent_object_id=OBJECT_ID(N'investigacion.cat_movil'))
    ALTER TABLE [investigacion].[cat_movil] ADD CONSTRAINT [df_cat_movil_aplica_secuestro] DEFAULT (0) FOR [aplica_secuestro];
GO

-- investigacion.cat_movil.vigente  ->  BIT
ALTER TABLE [investigacion].[cat_movil] DROP CONSTRAINT IF EXISTS [ck_cat_movil_vigente];
GO
ALTER TABLE [investigacion].[cat_movil] DROP CONSTRAINT IF EXISTS [df_cat_movil_vigente];
GO
ALTER TABLE [investigacion].[cat_movil] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_movil_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_movil'))
    ALTER TABLE [investigacion].[cat_movil] ADD CONSTRAINT [df_cat_movil_vigente] DEFAULT (1) FOR [vigente];
GO

-- investigacion.cat_punto_acceso.vigente  ->  BIT
ALTER TABLE [investigacion].[cat_punto_acceso] DROP CONSTRAINT IF EXISTS [ck_cat_punto_acceso_vigente];
GO
ALTER TABLE [investigacion].[cat_punto_acceso] DROP CONSTRAINT IF EXISTS [df_cat_punto_acceso_vigente];
GO
ALTER TABLE [investigacion].[cat_punto_acceso] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_punto_acceso_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_punto_acceso'))
    ALTER TABLE [investigacion].[cat_punto_acceso] ADD CONSTRAINT [df_cat_punto_acceso_vigente] DEFAULT (1) FOR [vigente];
GO

-- investigacion.cat_transporte_utilizado.vigente  ->  BIT
ALTER TABLE [investigacion].[cat_transporte_utilizado] DROP CONSTRAINT IF EXISTS [ck_cat_transporte_utilizado_vigente];
GO
ALTER TABLE [investigacion].[cat_transporte_utilizado] DROP CONSTRAINT IF EXISTS [df_cat_transporte_utilizado_vigente];
GO
ALTER TABLE [investigacion].[cat_transporte_utilizado] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_transporte_utilizado_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_transporte_utilizado'))
    ALTER TABLE [investigacion].[cat_transporte_utilizado] ADD CONSTRAINT [df_cat_transporte_utilizado_vigente] DEFAULT (1) FOR [vigente];
GO

-- investigacion.fenomeno_delictual.vigente  ->  BIT
ALTER TABLE [investigacion].[fenomeno_delictual] DROP CONSTRAINT IF EXISTS [ck_fenomeno_delictual_vigente];
GO
ALTER TABLE [investigacion].[fenomeno_delictual] DROP CONSTRAINT IF EXISTS [df_fenomeno_delictual_vigente];
GO
ALTER TABLE [investigacion].[fenomeno_delictual] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_fenomeno_delictual_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.fenomeno_delictual'))
    ALTER TABLE [investigacion].[fenomeno_delictual] ADD CONSTRAINT [df_fenomeno_delictual_vigente] DEFAULT (1) FOR [vigente];
GO

-- investigacion.hecho_fenomeno.es_principal  ->  BIT
ALTER TABLE [investigacion].[hecho_fenomeno] DROP CONSTRAINT IF EXISTS [ck_hecho_fenomeno_es_principal];
GO
ALTER TABLE [investigacion].[hecho_fenomeno] DROP CONSTRAINT IF EXISTS [df_hecho_fenomeno_es_principal];
GO
ALTER TABLE [investigacion].[hecho_fenomeno] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_hecho_fenomeno_es_principal' AND parent_object_id=OBJECT_ID(N'investigacion.hecho_fenomeno'))
    ALTER TABLE [investigacion].[hecho_fenomeno] ADD CONSTRAINT [df_hecho_fenomeno_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- investigacion.protocolo_delito.activo  ->  BIT
ALTER TABLE [investigacion].[protocolo_delito] DROP CONSTRAINT IF EXISTS [ck_protocolo_delito_activo];
GO
ALTER TABLE [investigacion].[protocolo_delito] DROP CONSTRAINT IF EXISTS [df_protocolo_delito_activo];
GO
ALTER TABLE [investigacion].[protocolo_delito] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_protocolo_delito_activo' AND parent_object_id=OBJECT_ID(N'investigacion.protocolo_delito'))
    ALTER TABLE [investigacion].[protocolo_delito] ADD CONSTRAINT [df_protocolo_delito_activo] DEFAULT (1) FOR [activo];
GO

-- migracion.cat_tipo_infraccion_migratoria.activo  ->  BIT
ALTER TABLE [migracion].[cat_tipo_infraccion_migratoria] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_infraccion_migratoria_activo];
GO
ALTER TABLE [migracion].[cat_tipo_infraccion_migratoria] DROP CONSTRAINT IF EXISTS [df_cat_tipo_infraccion_migratoria_activo];
GO
ALTER TABLE [migracion].[cat_tipo_infraccion_migratoria] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_infraccion_migratoria_activo' AND parent_object_id=OBJECT_ID(N'migracion.cat_tipo_infraccion_migratoria'))
    ALTER TABLE [migracion].[cat_tipo_infraccion_migratoria] ADD CONSTRAINT [df_cat_tipo_infraccion_migratoria_activo] DEFAULT (1) FOR [activo];
GO

-- migracion.denuncia_administrativa_migratoria.generada_en_ausencia  ->  BIT
ALTER TABLE [migracion].[denuncia_administrativa_migratoria] DROP CONSTRAINT IF EXISTS [ck_denuncia_administrativa_migratoria_generada_en_ausencia];
GO
ALTER TABLE [migracion].[denuncia_administrativa_migratoria] DROP CONSTRAINT IF EXISTS [df_denuncia_administrativa_migratoria_generada_en_ausencia];
GO
ALTER TABLE [migracion].[denuncia_administrativa_migratoria] ALTER COLUMN [generada_en_ausencia] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_denuncia_administrativa_migratoria_generada_en_ausencia' AND parent_object_id=OBJECT_ID(N'migracion.denuncia_administrativa_migratoria'))
    ALTER TABLE [migracion].[denuncia_administrativa_migratoria] ADD CONSTRAINT [df_denuncia_administrativa_migratoria_generada_en_ausencia] DEFAULT (0) FOR [generada_en_ausencia];
GO

-- organizacion.cat_nivel_organismo.activo  ->  BIT
ALTER TABLE [organizacion].[cat_nivel_organismo] DROP CONSTRAINT IF EXISTS [ck_cat_nivel_organismo_activo];
GO
ALTER TABLE [organizacion].[cat_nivel_organismo] DROP CONSTRAINT IF EXISTS [df_cat_nivel_organismo_activo];
GO
ALTER TABLE [organizacion].[cat_nivel_organismo] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_nivel_organismo_activo' AND parent_object_id=OBJECT_ID(N'organizacion.cat_nivel_organismo'))
    ALTER TABLE [organizacion].[cat_nivel_organismo] ADD CONSTRAINT [df_cat_nivel_organismo_activo] DEFAULT (1) FOR [activo];
GO

-- organizacion.cat_organismo_externo.activo  ->  BIT
ALTER TABLE [organizacion].[cat_organismo_externo] DROP CONSTRAINT IF EXISTS [ck_cat_organismo_externo_activo];
GO
ALTER TABLE [organizacion].[cat_organismo_externo] DROP CONSTRAINT IF EXISTS [df_cat_organismo_externo_activo];
GO
ALTER TABLE [organizacion].[cat_organismo_externo] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_organismo_externo_activo' AND parent_object_id=OBJECT_ID(N'organizacion.cat_organismo_externo'))
    ALTER TABLE [organizacion].[cat_organismo_externo] ADD CONSTRAINT [df_cat_organismo_externo_activo] DEFAULT (1) FOR [activo];
GO

-- organizacion.cat_tipo_organismo.activo  ->  BIT
ALTER TABLE [organizacion].[cat_tipo_organismo] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_organismo_activo];
GO
ALTER TABLE [organizacion].[cat_tipo_organismo] DROP CONSTRAINT IF EXISTS [df_cat_tipo_organismo_activo];
GO
ALTER TABLE [organizacion].[cat_tipo_organismo] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_organismo_activo' AND parent_object_id=OBJECT_ID(N'organizacion.cat_tipo_organismo'))
    ALTER TABLE [organizacion].[cat_tipo_organismo] ADD CONSTRAINT [df_cat_tipo_organismo_activo] DEFAULT (1) FOR [activo];
GO

-- personas.cat_actividad_economica.activo  ->  BIT
ALTER TABLE [personas].[cat_actividad_economica] DROP CONSTRAINT IF EXISTS [ck_cat_actividad_economica_act];
GO
ALTER TABLE [personas].[cat_actividad_economica] DROP CONSTRAINT IF EXISTS [df_cat_act_eco_activo];
GO
ALTER TABLE [personas].[cat_actividad_economica] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_act_eco_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_actividad_economica'))
    ALTER TABLE [personas].[cat_actividad_economica] ADD CONSTRAINT [df_cat_act_eco_activo] DEFAULT (1) FOR [activo];
GO

-- personas.cat_ocupacion.activo  ->  BIT
ALTER TABLE [personas].[cat_ocupacion] DROP CONSTRAINT IF EXISTS [ck_cat_ocupacion_activo];
GO
ALTER TABLE [personas].[cat_ocupacion] DROP CONSTRAINT IF EXISTS [df_cat_ocupacion_activo];
GO
ALTER TABLE [personas].[cat_ocupacion] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_ocupacion_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_ocupacion'))
    ALTER TABLE [personas].[cat_ocupacion] ADD CONSTRAINT [df_cat_ocupacion_activo] DEFAULT (1) FOR [activo];
GO

-- personas.cat_tipo_nombre.activo  ->  BIT
ALTER TABLE [personas].[cat_tipo_nombre] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_nombre_act];
GO
ALTER TABLE [personas].[cat_tipo_nombre] DROP CONSTRAINT IF EXISTS [df_cat_tipo_nombre_activo];
GO
ALTER TABLE [personas].[cat_tipo_nombre] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_nombre_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_nombre'))
    ALTER TABLE [personas].[cat_tipo_nombre] ADD CONSTRAINT [df_cat_tipo_nombre_activo] DEFAULT (1) FOR [activo];
GO

-- personas.cat_tipo_persona.activo  ->  BIT
ALTER TABLE [personas].[cat_tipo_persona] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_persona_act];
GO
ALTER TABLE [personas].[cat_tipo_persona] DROP CONSTRAINT IF EXISTS [df_cat_tipo_persona_activo];
GO
ALTER TABLE [personas].[cat_tipo_persona] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_persona_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_persona'))
    ALTER TABLE [personas].[cat_tipo_persona] ADD CONSTRAINT [df_cat_tipo_persona_activo] DEFAULT (1) FOR [activo];
GO

-- personas.cat_tipo_persona_juridica.activo  ->  BIT
ALTER TABLE [personas].[cat_tipo_persona_juridica] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_persona_juridica_act];
GO
ALTER TABLE [personas].[cat_tipo_persona_juridica] DROP CONSTRAINT IF EXISTS [df_cat_tipo_pj_activo];
GO
ALTER TABLE [personas].[cat_tipo_persona_juridica] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_pj_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_persona_juridica'))
    ALTER TABLE [personas].[cat_tipo_persona_juridica] ADD CONSTRAINT [df_cat_tipo_pj_activo] DEFAULT (1) FOR [activo];
GO

-- personas.cat_tipo_relacion.es_bidireccional  ->  BIT
ALTER TABLE [personas].[cat_tipo_relacion] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_relacion_es_bidireccional];
GO
ALTER TABLE [personas].[cat_tipo_relacion] DROP CONSTRAINT IF EXISTS [df_cat_tipo_relacion_es_bidireccional];
GO
ALTER TABLE [personas].[cat_tipo_relacion] ALTER COLUMN [es_bidireccional] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_relacion_es_bidireccional' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_relacion'))
    ALTER TABLE [personas].[cat_tipo_relacion] ADD CONSTRAINT [df_cat_tipo_relacion_es_bidireccional] DEFAULT (0) FOR [es_bidireccional];
GO

-- personas.cat_tipo_representacion.activo  ->  BIT
ALTER TABLE [personas].[cat_tipo_representacion] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_representacion_act];
GO
ALTER TABLE [personas].[cat_tipo_representacion] DROP CONSTRAINT IF EXISTS [df_cat_tipo_rep_activo];
GO
ALTER TABLE [personas].[cat_tipo_representacion] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rep_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_representacion'))
    ALTER TABLE [personas].[cat_tipo_representacion] ADD CONSTRAINT [df_cat_tipo_rep_activo] DEFAULT (1) FOR [activo];
GO

-- personas.contacto_otro.es_principal  ->  BIT
ALTER TABLE [personas].[contacto_otro] DROP CONSTRAINT IF EXISTS [ck_contacto_otro_es_principal];
GO
ALTER TABLE [personas].[contacto_otro] DROP CONSTRAINT IF EXISTS [df_contacto_otro_es_principal];
GO
ALTER TABLE [personas].[contacto_otro] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_contacto_otro_es_principal' AND parent_object_id=OBJECT_ID(N'personas.contacto_otro'))
    ALTER TABLE [personas].[contacto_otro] ADD CONSTRAINT [df_contacto_otro_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- personas.correo.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_correo_principal_activo] ON [personas].[correo];
GO
ALTER TABLE [personas].[correo] DROP CONSTRAINT IF EXISTS [ck_correo_es_principal];
GO
ALTER TABLE [personas].[correo] DROP CONSTRAINT IF EXISTS [df_correo_es_principal];
GO
ALTER TABLE [personas].[correo] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_correo_es_principal' AND parent_object_id=OBJECT_ID(N'personas.correo'))
    ALTER TABLE [personas].[correo] ADD CONSTRAINT [df_correo_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_correo_principal_activo' AND object_id=OBJECT_ID(N'personas.correo'))
    CREATE UNIQUE INDEX [ux_correo_principal_activo] ON [personas].[correo] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- personas.empleo.es_actual  ->  BIT
ALTER TABLE [personas].[empleo] DROP CONSTRAINT IF EXISTS [ck_empleo_es_actual];
GO
ALTER TABLE [personas].[empleo] DROP CONSTRAINT IF EXISTS [df_empleo_es_actual];
GO
ALTER TABLE [personas].[empleo] ALTER COLUMN [es_actual] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_empleo_es_actual' AND parent_object_id=OBJECT_ID(N'personas.empleo'))
    ALTER TABLE [personas].[empleo] ADD CONSTRAINT [df_empleo_es_actual] DEFAULT (1) FOR [es_actual];
GO

-- personas.fotografia.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_foto_principal_activa] ON [personas].[fotografia];
GO
ALTER TABLE [personas].[fotografia] DROP CONSTRAINT IF EXISTS [ck_fotografia_es_principal];
GO
ALTER TABLE [personas].[fotografia] DROP CONSTRAINT IF EXISTS [df_fotografia_es_principal];
GO
ALTER TABLE [personas].[fotografia] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_fotografia_es_principal' AND parent_object_id=OBJECT_ID(N'personas.fotografia'))
    ALTER TABLE [personas].[fotografia] ADD CONSTRAINT [df_fotografia_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_foto_principal_activa' AND object_id=OBJECT_ID(N'personas.fotografia'))
    CREATE UNIQUE INDEX [ux_foto_principal_activa] ON [personas].[fotografia] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- personas.identificacion.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_ident_principal_activo] ON [personas].[identificacion];
GO
ALTER TABLE [personas].[identificacion] DROP CONSTRAINT IF EXISTS [ck_identificacion_es_principal];
GO
ALTER TABLE [personas].[identificacion] DROP CONSTRAINT IF EXISTS [df_identificacion_es_principal];
GO
ALTER TABLE [personas].[identificacion] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_identificacion_es_principal' AND parent_object_id=OBJECT_ID(N'personas.identificacion'))
    ALTER TABLE [personas].[identificacion] ADD CONSTRAINT [df_identificacion_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_ident_principal_activo' AND object_id=OBJECT_ID(N'personas.identificacion'))
    CREATE UNIQUE INDEX [ux_ident_principal_activo] ON [personas].[identificacion] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- personas.identificacion.es_temporal  ->  BIT
ALTER TABLE [personas].[identificacion] DROP CONSTRAINT IF EXISTS [ck_identificacion_es_temporal];
GO
ALTER TABLE [personas].[identificacion] DROP CONSTRAINT IF EXISTS [df_identificacion_es_temporal];
GO
ALTER TABLE [personas].[identificacion] ALTER COLUMN [es_temporal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_identificacion_es_temporal' AND parent_object_id=OBJECT_ID(N'personas.identificacion'))
    ALTER TABLE [personas].[identificacion] ADD CONSTRAINT [df_identificacion_es_temporal] DEFAULT (0) FOR [es_temporal];
GO

-- personas.nombre.es_nombre_supuesto  ->  BIT
ALTER TABLE [personas].[nombre] DROP CONSTRAINT IF EXISTS [ck_nombre_es_nombre_supuesto];
GO
ALTER TABLE [personas].[nombre] DROP CONSTRAINT IF EXISTS [df_nombre_es_nombre_supuesto];
GO
ALTER TABLE [personas].[nombre] ALTER COLUMN [es_nombre_supuesto] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_nombre_es_nombre_supuesto' AND parent_object_id=OBJECT_ID(N'personas.nombre'))
    ALTER TABLE [personas].[nombre] ADD CONSTRAINT [df_nombre_es_nombre_supuesto] DEFAULT (0) FOR [es_nombre_supuesto];
GO

-- personas.persona_lugar.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_persona_lugar_principal_activo] ON [personas].[persona_lugar];
GO
ALTER TABLE [personas].[persona_lugar] DROP CONSTRAINT IF EXISTS [ck_persona_lugar_es_principal];
GO
ALTER TABLE [personas].[persona_lugar] DROP CONSTRAINT IF EXISTS [df_persona_lugar_es_principal];
GO
ALTER TABLE [personas].[persona_lugar] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_persona_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'personas.persona_lugar'))
    ALTER TABLE [personas].[persona_lugar] ADD CONSTRAINT [df_persona_lugar_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_persona_lugar_principal_activo' AND object_id=OBJECT_ID(N'personas.persona_lugar'))
    CREATE UNIQUE INDEX [ux_persona_lugar_principal_activo] ON [personas].[persona_lugar] (id_persona, id_rol_lugar) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- personas.persona_natural.domicilio_extranjero  ->  BIT
ALTER TABLE [personas].[persona_natural] DROP CONSTRAINT IF EXISTS [ck_pn_domicilio_extranjero];
GO
ALTER TABLE [personas].[persona_natural] DROP CONSTRAINT IF EXISTS [df_pn_domicilio_extranjero];
GO
ALTER TABLE [personas].[persona_natural] ALTER COLUMN [domicilio_extranjero] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pn_domicilio_extranjero' AND parent_object_id=OBJECT_ID(N'personas.persona_natural'))
    ALTER TABLE [personas].[persona_natural] ADD CONSTRAINT [df_pn_domicilio_extranjero] DEFAULT (0) FOR [domicilio_extranjero];
GO

-- personas.pj_actividad_economica.es_principal  ->  BIT
ALTER TABLE [personas].[pj_actividad_economica] DROP CONSTRAINT IF EXISTS [ck_pjae_es_principal];
GO
ALTER TABLE [personas].[pj_actividad_economica] DROP CONSTRAINT IF EXISTS [df_pjae_es_principal];
GO
ALTER TABLE [personas].[pj_actividad_economica] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pjae_es_principal' AND parent_object_id=OBJECT_ID(N'personas.pj_actividad_economica'))
    ALTER TABLE [personas].[pj_actividad_economica] ADD CONSTRAINT [df_pjae_es_principal] DEFAULT (0) FOR [es_principal];
GO

-- personas.telefono.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_telefono_principal_activo] ON [personas].[telefono];
GO
ALTER TABLE [personas].[telefono] DROP CONSTRAINT IF EXISTS [ck_telefono_es_principal];
GO
ALTER TABLE [personas].[telefono] DROP CONSTRAINT IF EXISTS [df_telefono_es_principal];
GO
ALTER TABLE [personas].[telefono] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_telefono_es_principal' AND parent_object_id=OBJECT_ID(N'personas.telefono'))
    ALTER TABLE [personas].[telefono] ADD CONSTRAINT [df_telefono_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_telefono_principal_activo' AND object_id=OBJECT_ID(N'personas.telefono'))
    CREATE UNIQUE INDEX [ux_telefono_principal_activo] ON [personas].[telefono] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

-- tareas.tipo_documento.vigente  ->  BIT
ALTER TABLE [tareas].[tipo_documento] DROP CONSTRAINT IF EXISTS [ck_tipo_documento_vigente];
GO
ALTER TABLE [tareas].[tipo_documento] DROP CONSTRAINT IF EXISTS [df_tipo_documento_vigente];
GO
ALTER TABLE [tareas].[tipo_documento] ALTER COLUMN [vigente] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_tipo_documento_vigente' AND parent_object_id=OBJECT_ID(N'tareas.tipo_documento'))
    ALTER TABLE [tareas].[tipo_documento] ADD CONSTRAINT [df_tipo_documento_vigente] DEFAULT (1) FOR [vigente];
GO

-- tareas.tipo_tarea.requiere_aprobacion  ->  BIT
ALTER TABLE [tareas].[tipo_tarea] DROP CONSTRAINT IF EXISTS [ck_tipo_tarea_requiere_aprobacion];
GO
ALTER TABLE [tareas].[tipo_tarea] DROP CONSTRAINT IF EXISTS [df_tipo_tarea_requiere_aprobacion];
GO
ALTER TABLE [tareas].[tipo_tarea] ALTER COLUMN [requiere_aprobacion] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_tipo_tarea_requiere_aprobacion' AND parent_object_id=OBJECT_ID(N'tareas.tipo_tarea'))
    ALTER TABLE [tareas].[tipo_tarea] ADD CONSTRAINT [df_tipo_tarea_requiere_aprobacion] DEFAULT (0) FOR [requiere_aprobacion];
GO

-- tareas.tipo_tarea.permite_adjuntar_archivos  ->  BIT
ALTER TABLE [tareas].[tipo_tarea] DROP CONSTRAINT IF EXISTS [ck_tipo_tarea_permite_adjuntar_archivos];
GO
ALTER TABLE [tareas].[tipo_tarea] DROP CONSTRAINT IF EXISTS [df_tipo_tarea_permite_adjuntar_archivos];
GO
ALTER TABLE [tareas].[tipo_tarea] ALTER COLUMN [permite_adjuntar_archivos] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_tipo_tarea_permite_adjuntar_archivos' AND parent_object_id=OBJECT_ID(N'tareas.tipo_tarea'))
    ALTER TABLE [tareas].[tipo_tarea] ADD CONSTRAINT [df_tipo_tarea_permite_adjuntar_archivos] DEFAULT (0) FOR [permite_adjuntar_archivos];
GO

-- ubicacion.cat_tipo_subdivision.activo  ->  BIT
ALTER TABLE [ubicacion].[cat_tipo_subdivision] DROP CONSTRAINT IF EXISTS [ck_cat_tipo_subdivision_activo];
GO
ALTER TABLE [ubicacion].[cat_tipo_subdivision] DROP CONSTRAINT IF EXISTS [df_cat_tipo_subdivision_activo];
GO
ALTER TABLE [ubicacion].[cat_tipo_subdivision] ALTER COLUMN [activo] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_subdivision_activo' AND parent_object_id=OBJECT_ID(N'ubicacion.cat_tipo_subdivision'))
    ALTER TABLE [ubicacion].[cat_tipo_subdivision] ADD CONSTRAINT [df_cat_tipo_subdivision_activo] DEFAULT (1) FOR [activo];
GO

-- vehiculos.persona_vehiculo.es_principal  ->  BIT
DROP INDEX IF EXISTS [ux_perveh_principal_activo] ON [vehiculos].[persona_vehiculo];
GO
ALTER TABLE [vehiculos].[persona_vehiculo] DROP CONSTRAINT IF EXISTS [ck_persona_vehiculo_es_principal];
GO
ALTER TABLE [vehiculos].[persona_vehiculo] DROP CONSTRAINT IF EXISTS [df_persona_vehiculo_es_principal];
GO
ALTER TABLE [vehiculos].[persona_vehiculo] ALTER COLUMN [es_principal] BIT NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_persona_vehiculo_es_principal' AND parent_object_id=OBJECT_ID(N'vehiculos.persona_vehiculo'))
    ALTER TABLE [vehiculos].[persona_vehiculo] ADD CONSTRAINT [df_persona_vehiculo_es_principal] DEFAULT (0) FOR [es_principal];
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_perveh_principal_activo' AND object_id=OBJECT_ID(N'vehiculos.persona_vehiculo'))
    CREATE UNIQUE INDEX [ux_perveh_principal_activo] ON [vehiculos].[persona_vehiculo] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO
