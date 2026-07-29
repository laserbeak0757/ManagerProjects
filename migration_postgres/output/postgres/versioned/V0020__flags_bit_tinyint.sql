-- =============================================================================
-- V0020__flags_bit_tinyint.sql
-- =============================================================================
-- Conversion de columnas flag SMALLINT -> boolean (106) / smallint (7).
-- Por columna:
-- 1. DROP de TODOS los indices que referencian la columna (columnas, INCLUDE o WHERE)
-- 2. DROP CHECK (ck_*) real
-- 3. DROP DEFAULT (df_*) real
-- 4. ALTER COLUMN al nuevo tipo
-- 5. Recrear DEFAULT
-- 6. Recrear indices
-- 7. Si smallint: recrear CHECK IN (0,1)
-- 18 indices afectados sobre 14 columnas (incluye INCLUDE y filtrados).
-- Nombres de constraints/indices tomados del esquema real.
-- Idempotente.
-- =============================================================================

SET XACT_ABORT ON;


-- ===== SECCION 1: smallint (7) =====

-- denuncias.pauta_vif.tiene_lesiones_visibles -> smallint
ALTER TABLE denuncias.pauta_vif DROP CONSTRAINT IF EXISTS ck_pauta_vif_tiene_lesiones_visibles;
ALTER TABLE denuncias.pauta_vif DROP CONSTRAINT IF EXISTS df_pauta_vif_tiene_lesiones_visibles;
ALTER TABLE denuncias.pauta_vif ALTER COLUMN tiene_lesiones_visibles smallint NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pauta_vif_tiene_lesiones_visibles' AND parent_object_id=OBJECT_ID(N'denuncias.pauta_vif'))
 ALTER TABLE denuncias.pauta_vif ADD CONSTRAINT df_pauta_vif_tiene_lesiones_visibles DEFAULT (0) FOR tiene_lesiones_visibles;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_pauta_vif_tiene_lesiones_visibles' AND parent_object_id=OBJECT_ID(N'denuncias.pauta_vif'))
 ALTER TABLE denuncias.pauta_vif WITH CHECK ADD CONSTRAINT ck_pauta_vif_tiene_lesiones_visibles CHECK (tiene_lesiones_visibles IN (0,1));

-- denuncias.procedimiento_persona.es_menor_edad -> smallint
ALTER TABLE denuncias.procedimiento_persona DROP CONSTRAINT IF EXISTS ck_procedimiento_persona_es_menor_edad;
ALTER TABLE denuncias.procedimiento_persona DROP CONSTRAINT IF EXISTS df_procedimiento_persona_es_menor_edad;
ALTER TABLE denuncias.procedimiento_persona ALTER COLUMN es_menor_edad smallint NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_procedimiento_persona_es_menor_edad' AND parent_object_id=OBJECT_ID(N'denuncias.procedimiento_persona'))
 ALTER TABLE denuncias.procedimiento_persona ADD CONSTRAINT df_procedimiento_persona_es_menor_edad DEFAULT (0) FOR es_menor_edad;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_procedimiento_persona_es_menor_edad' AND parent_object_id=OBJECT_ID(N'denuncias.procedimiento_persona'))
 ALTER TABLE denuncias.procedimiento_persona WITH CHECK ADD CONSTRAINT ck_procedimiento_persona_es_menor_edad CHECK (es_menor_edad IN (0,1));

-- diligencias.actividad_investigativa.es_resultado_negativo -> smallint
ALTER TABLE diligencias.actividad_investigativa DROP CONSTRAINT IF EXISTS ck_actividad_investigativa_es_resultado_negativo;
ALTER TABLE diligencias.actividad_investigativa DROP CONSTRAINT IF EXISTS df_actividad_investigativa_es_resultado_negativo;
ALTER TABLE diligencias.actividad_investigativa ALTER COLUMN es_resultado_negativo smallint NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_actividad_investigativa_es_resultado_negativo' AND parent_object_id=OBJECT_ID(N'diligencias.actividad_investigativa'))
 ALTER TABLE diligencias.actividad_investigativa ADD CONSTRAINT df_actividad_investigativa_es_resultado_negativo DEFAULT (0) FOR es_resultado_negativo;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_actividad_investigativa_es_resultado_negativo' AND parent_object_id=OBJECT_ID(N'diligencias.actividad_investigativa'))
 ALTER TABLE diligencias.actividad_investigativa WITH CHECK ADD CONSTRAINT ck_actividad_investigativa_es_resultado_negativo CHECK (es_resultado_negativo IN (0,1));

-- evidencias.arma.inscrita -> smallint
ALTER TABLE evidencias.arma DROP CONSTRAINT IF EXISTS ck_arma_inscrita;
ALTER TABLE evidencias.arma ALTER COLUMN inscrita smallint NULL;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_arma_inscrita' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma WITH CHECK ADD CONSTRAINT ck_arma_inscrita CHECK (inscrita IN (0,1));

-- evidencias.arma.tiene_capacidad_disparo_real -> smallint
ALTER TABLE evidencias.arma DROP CONSTRAINT IF EXISTS ck_arma_tiene_capacidad_disparo_real;
ALTER TABLE evidencias.arma DROP CONSTRAINT IF EXISTS df_arma_tiene_capacidad_disparo_real;
ALTER TABLE evidencias.arma ALTER COLUMN tiene_capacidad_disparo_real smallint NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_arma_tiene_capacidad_disparo_real' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma ADD CONSTRAINT df_arma_tiene_capacidad_disparo_real DEFAULT (0) FOR tiene_capacidad_disparo_real;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_arma_tiene_capacidad_disparo_real' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma WITH CHECK ADD CONSTRAINT ck_arma_tiene_capacidad_disparo_real CHECK (tiene_capacidad_disparo_real IN (0,1));

-- evidencias.cadena_custodia.sello_intacto -> smallint
ALTER TABLE evidencias.cadena_custodia DROP CONSTRAINT IF EXISTS ck_cadena_custodia_sello_intacto;
ALTER TABLE evidencias.cadena_custodia ALTER COLUMN sello_intacto smallint NULL;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_cadena_custodia_sello_intacto' AND parent_object_id=OBJECT_ID(N'evidencias.cadena_custodia'))
 ALTER TABLE evidencias.cadena_custodia WITH CHECK ADD CONSTRAINT ck_cadena_custodia_sello_intacto CHECK (sello_intacto IN (0,1));

-- personas.persona_natural.es_identificable -> smallint
ALTER TABLE personas.persona_natural DROP CONSTRAINT IF EXISTS ck_pn_es_identificable;
ALTER TABLE personas.persona_natural DROP CONSTRAINT IF EXISTS df_pn_es_identificable;
ALTER TABLE personas.persona_natural ALTER COLUMN es_identificable smallint NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pn_es_identificable' AND parent_object_id=OBJECT_ID(N'personas.persona_natural'))
 ALTER TABLE personas.persona_natural ADD CONSTRAINT df_pn_es_identificable DEFAULT (1) FOR es_identificable;
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'ck_pn_es_identificable' AND parent_object_id=OBJECT_ID(N'personas.persona_natural'))
 ALTER TABLE personas.persona_natural WITH CHECK ADD CONSTRAINT ck_pn_es_identificable CHECK (es_identificable IN (0,1));


-- ===== SECCION 2: boolean (106) =====

-- configuracion.cat_elemento_dominio.activo -> boolean
DROP INDEX IF EXISTS ix_cat_elemento_dominio_activo ON configuracion.cat_elemento_dominio;
ALTER TABLE configuracion.cat_elemento_dominio DROP CONSTRAINT IF EXISTS ck_cat_elemento_dominio_activo;
ALTER TABLE configuracion.cat_elemento_dominio DROP CONSTRAINT IF EXISTS df_cat_elemento_dominio_activo;
ALTER TABLE configuracion.cat_elemento_dominio ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_elemento_dominio_activo' AND parent_object_id=OBJECT_ID(N'configuracion.cat_elemento_dominio'))
 ALTER TABLE configuracion.cat_elemento_dominio ADD CONSTRAINT df_cat_elemento_dominio_activo DEFAULT (1) FOR activo;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_cat_elemento_dominio_activo' AND object_id=OBJECT_ID(N'configuracion.cat_elemento_dominio'))
 CREATE INDEX ix_cat_elemento_dominio_activo ON configuracion.cat_elemento_dominio (id_dominio, activo);

-- casos.cat_tipo_rol_persona.requiere_telefono -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_telefono;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_telefono;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_telefono boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_telefono' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_telefono DEFAULT (0) FOR requiere_telefono;

-- casos.cat_tipo_rol_persona.requiere_correo -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_correo;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_correo;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_correo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_correo' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_correo DEFAULT (0) FOR requiere_correo;

-- casos.cat_tipo_rol_persona.requiere_domicilio -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_domicilio;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_domicilio;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_domicilio boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_domicilio' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_domicilio DEFAULT (0) FOR requiere_domicilio;

-- casos.cat_tipo_rol_persona.requiere_identificacion -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_identificacion;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_identificacion;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_identificacion boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_identificacion' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_identificacion DEFAULT (0) FOR requiere_identificacion;

-- casos.cat_tipo_rol_persona.requiere_fecha_nacimiento -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_fecha_nacimiento;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_fecha_nacimiento;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_fecha_nacimiento boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_fecha_nacimiento' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_fecha_nacimiento DEFAULT (0) FOR requiere_fecha_nacimiento;

-- casos.cat_tipo_rol_persona.requiere_ocupacion -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_ocupacion;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_ocupacion;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_ocupacion boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_ocupacion' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_ocupacion DEFAULT (0) FOR requiere_ocupacion;

-- casos.cat_tipo_rol_persona.requiere_estado_civil -> boolean
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_rol_persona_requiere_estado_civil;
ALTER TABLE casos.cat_tipo_rol_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_rol_persona_requiere_estado_civil;
ALTER TABLE casos.cat_tipo_rol_persona ALTER COLUMN requiere_estado_civil boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rol_persona_requiere_estado_civil' AND parent_object_id=OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona ADD CONSTRAINT df_cat_tipo_rol_persona_requiere_estado_civil DEFAULT (0) FOR requiere_estado_civil;

-- investigacion.hecho_lugar.es_principal -> boolean
DROP INDEX IF EXISTS ux_hecho_lugar_principal_activo ON investigacion.hecho_lugar;
ALTER TABLE investigacion.hecho_lugar DROP CONSTRAINT IF EXISTS ck_hecho_lugar_es_principal;
ALTER TABLE investigacion.hecho_lugar DROP CONSTRAINT IF EXISTS df_hecho_lugar_es_principal;
ALTER TABLE investigacion.hecho_lugar ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_hecho_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'investigacion.hecho_lugar'))
 ALTER TABLE investigacion.hecho_lugar ADD CONSTRAINT df_hecho_lugar_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_hecho_lugar_principal_activo' AND object_id=OBJECT_ID(N'investigacion.hecho_lugar'))
 CREATE UNIQUE INDEX ux_hecho_lugar_principal_activo ON investigacion.hecho_lugar (id_hecho) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- analitica.cat_tipo_reporte.activo -> boolean
ALTER TABLE analitica.cat_tipo_reporte DROP CONSTRAINT IF EXISTS ck_cat_tipo_reporte_activo;
ALTER TABLE analitica.cat_tipo_reporte DROP CONSTRAINT IF EXISTS df_cat_tipo_reporte_activo;
ALTER TABLE analitica.cat_tipo_reporte ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_reporte_activo' AND parent_object_id=OBJECT_ID(N'analitica.cat_tipo_reporte'))
 ALTER TABLE analitica.cat_tipo_reporte ADD CONSTRAINT df_cat_tipo_reporte_activo DEFAULT (1) FOR activo;

-- analitica.configuracion_reporte_periodico.activo -> boolean
ALTER TABLE analitica.configuracion_reporte_periodico DROP CONSTRAINT IF EXISTS ck_configuracion_reporte_periodico_activo;
ALTER TABLE analitica.configuracion_reporte_periodico DROP CONSTRAINT IF EXISTS df_configuracion_reporte_periodico_activo;
ALTER TABLE analitica.configuracion_reporte_periodico ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_configuracion_reporte_periodico_activo' AND parent_object_id=OBJECT_ID(N'analitica.configuracion_reporte_periodico'))
 ALTER TABLE analitica.configuracion_reporte_periodico ADD CONSTRAINT df_configuracion_reporte_periodico_activo DEFAULT (1) FOR activo;

-- analitica.foco_caso.es_caso_principal -> boolean
ALTER TABLE analitica.foco_caso DROP CONSTRAINT IF EXISTS ck_foco_caso_es_caso_principal;
ALTER TABLE analitica.foco_caso DROP CONSTRAINT IF EXISTS df_foco_caso_es_caso_principal;
ALTER TABLE analitica.foco_caso ALTER COLUMN es_caso_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_foco_caso_es_caso_principal' AND parent_object_id=OBJECT_ID(N'analitica.foco_caso'))
 ALTER TABLE analitica.foco_caso ADD CONSTRAINT df_foco_caso_es_caso_principal DEFAULT (0) FOR es_caso_principal;

-- archivos.cat_tipo_archivo.es_multimedia -> boolean
ALTER TABLE archivos.cat_tipo_archivo DROP CONSTRAINT IF EXISTS ck_cat_tipo_archivo_es_multimedia;
ALTER TABLE archivos.cat_tipo_archivo DROP CONSTRAINT IF EXISTS df_cat_tipo_archivo_es_multimedia;
ALTER TABLE archivos.cat_tipo_archivo ALTER COLUMN es_multimedia boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_archivo_es_multimedia' AND parent_object_id=OBJECT_ID(N'archivos.cat_tipo_archivo'))
 ALTER TABLE archivos.cat_tipo_archivo ADD CONSTRAINT df_cat_tipo_archivo_es_multimedia DEFAULT (0) FOR es_multimedia;

-- auth.parametro.activo -> boolean
ALTER TABLE auth.parametro DROP CONSTRAINT IF EXISTS ck_parametro_activo;
ALTER TABLE auth.parametro DROP CONSTRAINT IF EXISTS df_parametro_activo;
ALTER TABLE auth.parametro ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_parametro_activo' AND parent_object_id=OBJECT_ID(N'auth.parametro'))
 ALTER TABLE auth.parametro ADD CONSTRAINT df_parametro_activo DEFAULT (1) FOR activo;

-- auth.usuario.activo -> boolean
ALTER TABLE auth.usuario DROP CONSTRAINT IF EXISTS ck_usuario_activo;
ALTER TABLE auth.usuario DROP CONSTRAINT IF EXISTS df_usuario_activo;
ALTER TABLE auth.usuario ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_usuario_activo' AND parent_object_id=OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario ADD CONSTRAINT df_usuario_activo DEFAULT (1) FOR activo;

-- casos.cat_estado_caso.es_terminal -> boolean
ALTER TABLE casos.cat_estado_caso DROP CONSTRAINT IF EXISTS ck_cat_estado_caso_es_terminal;
ALTER TABLE casos.cat_estado_caso DROP CONSTRAINT IF EXISTS df_cat_estado_caso_es_terminal;
ALTER TABLE casos.cat_estado_caso ALTER COLUMN es_terminal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_caso_es_terminal' AND parent_object_id=OBJECT_ID(N'casos.cat_estado_caso'))
 ALTER TABLE casos.cat_estado_caso ADD CONSTRAINT df_cat_estado_caso_es_terminal DEFAULT (0) FOR es_terminal;

-- casos.cat_grupo_operativo.activo -> boolean
ALTER TABLE casos.cat_grupo_operativo DROP CONSTRAINT IF EXISTS ck_cat_grupo_operativo_activo;
ALTER TABLE casos.cat_grupo_operativo DROP CONSTRAINT IF EXISTS df_cat_grupo_operativo_activo;
ALTER TABLE casos.cat_grupo_operativo ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_grupo_operativo_activo' AND parent_object_id=OBJECT_ID(N'casos.cat_grupo_operativo'))
 ALTER TABLE casos.cat_grupo_operativo ADD CONSTRAINT df_cat_grupo_operativo_activo DEFAULT (1) FOR activo;

-- casos.cat_nivel_seguridad.bloquea_busqueda_externa -> boolean
ALTER TABLE casos.cat_nivel_seguridad DROP CONSTRAINT IF EXISTS ck_cat_nivel_seguridad_bloquea_busqueda_externa;
ALTER TABLE casos.cat_nivel_seguridad DROP CONSTRAINT IF EXISTS df_cat_nivel_seguridad_bloquea_busqueda_externa;
ALTER TABLE casos.cat_nivel_seguridad ALTER COLUMN bloquea_busqueda_externa boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_nivel_seguridad_bloquea_busqueda_externa' AND parent_object_id=OBJECT_ID(N'casos.cat_nivel_seguridad'))
 ALTER TABLE casos.cat_nivel_seguridad ADD CONSTRAINT df_cat_nivel_seguridad_bloquea_busqueda_externa DEFAULT (0) FOR bloquea_busqueda_externa;

-- casos.cat_nivel_seguridad.activo -> boolean
ALTER TABLE casos.cat_nivel_seguridad DROP CONSTRAINT IF EXISTS ck_cat_nivel_seguridad_activo;
ALTER TABLE casos.cat_nivel_seguridad DROP CONSTRAINT IF EXISTS df_cat_nivel_seguridad_activo;
ALTER TABLE casos.cat_nivel_seguridad ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_nivel_seguridad_activo' AND parent_object_id=OBJECT_ID(N'casos.cat_nivel_seguridad'))
 ALTER TABLE casos.cat_nivel_seguridad ADD CONSTRAINT df_cat_nivel_seguridad_activo DEFAULT (1) FOR activo;

-- catalogo_bienes.clase.activo -> boolean
DROP INDEX IF EXISTS ix_clase_familia ON catalogo_bienes.clase;
DROP INDEX IF EXISTS ix_clase_nombre ON catalogo_bienes.clase;
ALTER TABLE catalogo_bienes.clase DROP CONSTRAINT IF EXISTS ck_clase_activo;
ALTER TABLE catalogo_bienes.clase DROP CONSTRAINT IF EXISTS df_clase_activo;
ALTER TABLE catalogo_bienes.clase ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_clase_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.clase'))
 ALTER TABLE catalogo_bienes.clase ADD CONSTRAINT df_clase_activo DEFAULT (1) FOR activo;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_clase_familia' AND object_id=OBJECT_ID(N'catalogo_bienes.clase'))
 CREATE INDEX ix_clase_familia ON catalogo_bienes.clase (id_familia, id_version) INCLUDE (codigo, nombre, activo);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_clase_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.clase'))
 CREATE INDEX ix_clase_nombre ON catalogo_bienes.clase (nombre) INCLUDE (codigo, id_version, activo);

-- catalogo_bienes.familia.activo -> boolean
DROP INDEX IF EXISTS ix_familia_segmento ON catalogo_bienes.familia;
DROP INDEX IF EXISTS ix_familia_nombre ON catalogo_bienes.familia;
ALTER TABLE catalogo_bienes.familia DROP CONSTRAINT IF EXISTS ck_familia_activo;
ALTER TABLE catalogo_bienes.familia DROP CONSTRAINT IF EXISTS df_familia_activo;
ALTER TABLE catalogo_bienes.familia ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_familia_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.familia'))
 ALTER TABLE catalogo_bienes.familia ADD CONSTRAINT df_familia_activo DEFAULT (1) FOR activo;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_familia_segmento' AND object_id=OBJECT_ID(N'catalogo_bienes.familia'))
 CREATE INDEX ix_familia_segmento ON catalogo_bienes.familia (id_segmento, id_version) INCLUDE (codigo, nombre, activo);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_familia_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.familia'))
 CREATE INDEX ix_familia_nombre ON catalogo_bienes.familia (nombre) INCLUDE (codigo, id_version, activo);

-- catalogo_bienes.producto.activo -> boolean
DROP INDEX IF EXISTS ix_producto_clase ON catalogo_bienes.producto;
DROP INDEX IF EXISTS ix_producto_nombre ON catalogo_bienes.producto;
DROP INDEX IF EXISTS ix_producto_codigo ON catalogo_bienes.producto;
ALTER TABLE catalogo_bienes.producto DROP CONSTRAINT IF EXISTS ck_producto_activo;
ALTER TABLE catalogo_bienes.producto DROP CONSTRAINT IF EXISTS df_producto_activo;
ALTER TABLE catalogo_bienes.producto ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_producto_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.producto'))
 ALTER TABLE catalogo_bienes.producto ADD CONSTRAINT df_producto_activo DEFAULT (1) FOR activo;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_producto_clase' AND object_id=OBJECT_ID(N'catalogo_bienes.producto'))
 CREATE INDEX ix_producto_clase ON catalogo_bienes.producto (id_clase, id_version) INCLUDE (codigo, nombre, activo);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_producto_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.producto'))
 CREATE INDEX ix_producto_nombre ON catalogo_bienes.producto (nombre) INCLUDE (codigo, id_version, activo);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_producto_codigo' AND object_id=OBJECT_ID(N'catalogo_bienes.producto'))
 CREATE INDEX ix_producto_codigo ON catalogo_bienes.producto (codigo, id_version) INCLUDE (nombre, activo, id_clase);

-- catalogo_bienes.segmento.activo -> boolean
DROP INDEX IF EXISTS ix_segmento_nombre ON catalogo_bienes.segmento;
ALTER TABLE catalogo_bienes.segmento DROP CONSTRAINT IF EXISTS ck_segmento_activo;
ALTER TABLE catalogo_bienes.segmento DROP CONSTRAINT IF EXISTS df_segmento_activo;
ALTER TABLE catalogo_bienes.segmento ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_segmento_activo' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.segmento'))
 ALTER TABLE catalogo_bienes.segmento ADD CONSTRAINT df_segmento_activo DEFAULT (1) FOR activo;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ix_segmento_nombre' AND object_id=OBJECT_ID(N'catalogo_bienes.segmento'))
 CREATE INDEX ix_segmento_nombre ON catalogo_bienes.segmento (nombre) INCLUDE (codigo, id_version, activo);

-- catalogo_bienes.version_catalogo.es_vigente -> boolean
DROP INDEX IF EXISTS uq_version_catalogo_vigente ON catalogo_bienes.version_catalogo;
ALTER TABLE catalogo_bienes.version_catalogo DROP CONSTRAINT IF EXISTS ck_version_catalogo_es_vigente;
ALTER TABLE catalogo_bienes.version_catalogo DROP CONSTRAINT IF EXISTS df_version_catalogo_es_vigente;
ALTER TABLE catalogo_bienes.version_catalogo ALTER COLUMN es_vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_version_catalogo_es_vigente' AND parent_object_id=OBJECT_ID(N'catalogo_bienes.version_catalogo'))
 ALTER TABLE catalogo_bienes.version_catalogo ADD CONSTRAINT df_version_catalogo_es_vigente DEFAULT (0) FOR es_vigente;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'uq_version_catalogo_vigente' AND object_id=OBJECT_ID(N'catalogo_bienes.version_catalogo'))
 CREATE UNIQUE INDEX uq_version_catalogo_vigente ON catalogo_bienes.version_catalogo (es_vigente) WHERE es_vigente = 1;

-- configuracion.cat_programa_seguridad.activo -> boolean
ALTER TABLE configuracion.cat_programa_seguridad DROP CONSTRAINT IF EXISTS ck_cat_programa_seguridad_activo;
ALTER TABLE configuracion.cat_programa_seguridad DROP CONSTRAINT IF EXISTS df_cat_programa_seguridad_activo;
ALTER TABLE configuracion.cat_programa_seguridad ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_programa_seguridad_activo' AND parent_object_id=OBJECT_ID(N'configuracion.cat_programa_seguridad'))
 ALTER TABLE configuracion.cat_programa_seguridad ADD CONSTRAINT df_cat_programa_seguridad_activo DEFAULT (1) FOR activo;

-- cooperacion_int.cat_elemento_cooperacion_internacional.activo -> boolean
ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional DROP CONSTRAINT IF EXISTS ck_cat_elemento_cooperacion_internacional_activo;
ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional DROP CONSTRAINT IF EXISTS df_cat_elemento_cooperacion_internacional_activo;
ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_elemento_cooperacion_internacional_activo' AND parent_object_id=OBJECT_ID(N'cooperacion_int.cat_elemento_cooperacion_internacional'))
 ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional ADD CONSTRAINT df_cat_elemento_cooperacion_internacional_activo DEFAULT (1) FOR activo;

-- cooperacion_int.entidad_interpol.es_pdi -> boolean
ALTER TABLE cooperacion_int.entidad_interpol DROP CONSTRAINT IF EXISTS ck_entidad_interpol_es_pdi;
ALTER TABLE cooperacion_int.entidad_interpol DROP CONSTRAINT IF EXISTS df_entidad_interpol_es_pdi;
ALTER TABLE cooperacion_int.entidad_interpol ALTER COLUMN es_pdi boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_entidad_interpol_es_pdi' AND parent_object_id=OBJECT_ID(N'cooperacion_int.entidad_interpol'))
 ALTER TABLE cooperacion_int.entidad_interpol ADD CONSTRAINT df_entidad_interpol_es_pdi DEFAULT (0) FOR es_pdi;

-- cooperacion_int.entidad_interpol.activo -> boolean
ALTER TABLE cooperacion_int.entidad_interpol DROP CONSTRAINT IF EXISTS ck_entidad_interpol_activo;
ALTER TABLE cooperacion_int.entidad_interpol DROP CONSTRAINT IF EXISTS df_entidad_interpol_activo;
ALTER TABLE cooperacion_int.entidad_interpol ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_entidad_interpol_activo' AND parent_object_id=OBJECT_ID(N'cooperacion_int.entidad_interpol'))
 ALTER TABLE cooperacion_int.entidad_interpol ADD CONSTRAINT df_entidad_interpol_activo DEFAULT (1) FOR activo;

-- cooperacion_int.estado_solicitud_interpol.activo -> boolean
ALTER TABLE cooperacion_int.estado_solicitud_interpol DROP CONSTRAINT IF EXISTS ck_estado_solicitud_interpol_activo;
ALTER TABLE cooperacion_int.estado_solicitud_interpol DROP CONSTRAINT IF EXISTS df_estado_solicitud_interpol_activo;
ALTER TABLE cooperacion_int.estado_solicitud_interpol ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_estado_solicitud_interpol_activo' AND parent_object_id=OBJECT_ID(N'cooperacion_int.estado_solicitud_interpol'))
 ALTER TABLE cooperacion_int.estado_solicitud_interpol ADD CONSTRAINT df_estado_solicitud_interpol_activo DEFAULT (1) FOR activo;

-- cooperacion_int.solicitud_interpol.tiene_huella_dactilar -> boolean
ALTER TABLE cooperacion_int.solicitud_interpol DROP CONSTRAINT IF EXISTS ck_solicitud_interpol_tiene_huella_dactilar;
ALTER TABLE cooperacion_int.solicitud_interpol DROP CONSTRAINT IF EXISTS df_solicitud_interpol_tiene_huella_dactilar;
ALTER TABLE cooperacion_int.solicitud_interpol ALTER COLUMN tiene_huella_dactilar boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_solicitud_interpol_tiene_huella_dactilar' AND parent_object_id=OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
 ALTER TABLE cooperacion_int.solicitud_interpol ADD CONSTRAINT df_solicitud_interpol_tiene_huella_dactilar DEFAULT (0) FOR tiene_huella_dactilar;

-- cooperacion_int.solicitud_interpol.bloquear_edicion_origen -> boolean
ALTER TABLE cooperacion_int.solicitud_interpol DROP CONSTRAINT IF EXISTS ck_solicitud_interpol_bloquear_edicion_origen;
ALTER TABLE cooperacion_int.solicitud_interpol DROP CONSTRAINT IF EXISTS df_solicitud_interpol_bloquear_edicion_origen;
ALTER TABLE cooperacion_int.solicitud_interpol ALTER COLUMN bloquear_edicion_origen boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_solicitud_interpol_bloquear_edicion_origen' AND parent_object_id=OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
 ALTER TABLE cooperacion_int.solicitud_interpol ADD CONSTRAINT df_solicitud_interpol_bloquear_edicion_origen DEFAULT (0) FOR bloquear_edicion_origen;

-- denuncias.cat_estado_denuncia.es_terminal -> boolean
ALTER TABLE denuncias.cat_estado_denuncia DROP CONSTRAINT IF EXISTS ck_cat_estado_denuncia_es_terminal;
ALTER TABLE denuncias.cat_estado_denuncia DROP CONSTRAINT IF EXISTS df_cat_estado_denuncia_es_terminal;
ALTER TABLE denuncias.cat_estado_denuncia ALTER COLUMN es_terminal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_denuncia_es_terminal' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_denuncia'))
 ALTER TABLE denuncias.cat_estado_denuncia ADD CONSTRAINT df_cat_estado_denuncia_es_terminal DEFAULT (0) FOR es_terminal;

-- denuncias.cat_estado_denuncia.activo -> boolean
ALTER TABLE denuncias.cat_estado_denuncia DROP CONSTRAINT IF EXISTS ck_cat_estado_denuncia_activo;
ALTER TABLE denuncias.cat_estado_denuncia DROP CONSTRAINT IF EXISTS df_cat_estado_denuncia_activo;
ALTER TABLE denuncias.cat_estado_denuncia ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_denuncia_activo' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_denuncia'))
 ALTER TABLE denuncias.cat_estado_denuncia ADD CONSTRAINT df_cat_estado_denuncia_activo DEFAULT (1) FOR activo;

-- denuncias.cat_estado_envio_fiscalia.es_terminal -> boolean
ALTER TABLE denuncias.cat_estado_envio_fiscalia DROP CONSTRAINT IF EXISTS ck_cat_estado_envio_fiscalia_es_terminal;
ALTER TABLE denuncias.cat_estado_envio_fiscalia DROP CONSTRAINT IF EXISTS df_cat_estado_envio_fiscalia_es_terminal;
ALTER TABLE denuncias.cat_estado_envio_fiscalia ALTER COLUMN es_terminal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_envio_fiscalia_es_terminal' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_envio_fiscalia'))
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD CONSTRAINT df_cat_estado_envio_fiscalia_es_terminal DEFAULT (0) FOR es_terminal;

-- denuncias.cat_estado_envio_fiscalia.activo -> boolean
ALTER TABLE denuncias.cat_estado_envio_fiscalia DROP CONSTRAINT IF EXISTS ck_cat_estado_envio_fiscalia_activo;
ALTER TABLE denuncias.cat_estado_envio_fiscalia DROP CONSTRAINT IF EXISTS df_cat_estado_envio_fiscalia_activo;
ALTER TABLE denuncias.cat_estado_envio_fiscalia ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_envio_fiscalia_activo' AND parent_object_id=OBJECT_ID(N'denuncias.cat_estado_envio_fiscalia'))
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD CONSTRAINT df_cat_estado_envio_fiscalia_activo DEFAULT (1) FOR activo;

-- denuncias.cat_tipo_denuncia.activo -> boolean
ALTER TABLE denuncias.cat_tipo_denuncia DROP CONSTRAINT IF EXISTS ck_cat_tipo_denuncia_activo;
ALTER TABLE denuncias.cat_tipo_denuncia DROP CONSTRAINT IF EXISTS df_cat_tipo_denuncia_activo;
ALTER TABLE denuncias.cat_tipo_denuncia ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_denuncia_activo' AND parent_object_id=OBJECT_ID(N'denuncias.cat_tipo_denuncia'))
 ALTER TABLE denuncias.cat_tipo_denuncia ADD CONSTRAINT df_cat_tipo_denuncia_activo DEFAULT (1) FOR activo;

-- denuncias.denuncia_persona_rol.es_declarante -> boolean
ALTER TABLE denuncias.denuncia_persona_rol DROP CONSTRAINT IF EXISTS ck_denuncia_persona_rol_es_declarante;
ALTER TABLE denuncias.denuncia_persona_rol DROP CONSTRAINT IF EXISTS df_denuncia_persona_rol_es_declarante;
ALTER TABLE denuncias.denuncia_persona_rol ALTER COLUMN es_declarante boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_denuncia_persona_rol_es_declarante' AND parent_object_id=OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 ALTER TABLE denuncias.denuncia_persona_rol ADD CONSTRAINT df_denuncia_persona_rol_es_declarante DEFAULT (0) FOR es_declarante;

-- denuncias.denuncia_persona_rol.es_principal -> boolean
DROP INDEX IF EXISTS ux_denperrol_principal_activo ON denuncias.denuncia_persona_rol;
ALTER TABLE denuncias.denuncia_persona_rol DROP CONSTRAINT IF EXISTS ck_denuncia_persona_rol_es_principal;
ALTER TABLE denuncias.denuncia_persona_rol DROP CONSTRAINT IF EXISTS df_denuncia_persona_rol_es_principal;
ALTER TABLE denuncias.denuncia_persona_rol ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_denuncia_persona_rol_es_principal' AND parent_object_id=OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 ALTER TABLE denuncias.denuncia_persona_rol ADD CONSTRAINT df_denuncia_persona_rol_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_denperrol_principal_activo' AND object_id=OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 CREATE UNIQUE INDEX ux_denperrol_principal_activo ON denuncias.denuncia_persona_rol (id_denuncia) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- denuncias.pauta_vif.firma_apercibimiento_art26 -> boolean
ALTER TABLE denuncias.pauta_vif DROP CONSTRAINT IF EXISTS ck_pauta_vif_firma_apercibimiento_art26;
ALTER TABLE denuncias.pauta_vif DROP CONSTRAINT IF EXISTS df_pauta_vif_firma_apercibimiento_art26;
ALTER TABLE denuncias.pauta_vif ALTER COLUMN firma_apercibimiento_art26 boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pauta_vif_firma_apercibimiento_art26' AND parent_object_id=OBJECT_ID(N'denuncias.pauta_vif'))
 ALTER TABLE denuncias.pauta_vif ADD CONSTRAINT df_pauta_vif_firma_apercibimiento_art26 DEFAULT (0) FOR firma_apercibimiento_art26;

-- denuncias.relato.declarante_es_denunciante -> boolean
ALTER TABLE denuncias.relato DROP CONSTRAINT IF EXISTS ck_relato_declarante_es_denunciante;
ALTER TABLE denuncias.relato DROP CONSTRAINT IF EXISTS df_relato_declarante_es_denunciante;
ALTER TABLE denuncias.relato ALTER COLUMN declarante_es_denunciante boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_relato_declarante_es_denunciante' AND parent_object_id=OBJECT_ID(N'denuncias.relato'))
 ALTER TABLE denuncias.relato ADD CONSTRAINT df_relato_declarante_es_denunciante DEFAULT (1) FOR declarante_es_denunciante;

-- diligencias.cat_especialidad_pericial.activo -> boolean
ALTER TABLE diligencias.cat_especialidad_pericial DROP CONSTRAINT IF EXISTS ck_cat_especialidad_pericial_activo;
ALTER TABLE diligencias.cat_especialidad_pericial DROP CONSTRAINT IF EXISTS df_cat_especialidad_pericial_activo;
ALTER TABLE diligencias.cat_especialidad_pericial ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_especialidad_pericial_activo' AND parent_object_id=OBJECT_ID(N'diligencias.cat_especialidad_pericial'))
 ALTER TABLE diligencias.cat_especialidad_pericial ADD CONSTRAINT df_cat_especialidad_pericial_activo DEFAULT (1) FOR activo;

-- diligencias.cat_tipo_diligencia.es_primera_diligencia -> boolean
ALTER TABLE diligencias.cat_tipo_diligencia DROP CONSTRAINT IF EXISTS ck_cat_tipo_diligencia_es_primera_diligencia;
ALTER TABLE diligencias.cat_tipo_diligencia DROP CONSTRAINT IF EXISTS df_cat_tipo_diligencia_es_primera_diligencia;
ALTER TABLE diligencias.cat_tipo_diligencia ALTER COLUMN es_primera_diligencia boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_diligencia_es_primera_diligencia' AND parent_object_id=OBJECT_ID(N'diligencias.cat_tipo_diligencia'))
 ALTER TABLE diligencias.cat_tipo_diligencia ADD CONSTRAINT df_cat_tipo_diligencia_es_primera_diligencia DEFAULT (0) FOR es_primera_diligencia;

-- diligencias.cat_tipo_diligencia.requiere_autorizacion_judicial -> boolean
ALTER TABLE diligencias.cat_tipo_diligencia DROP CONSTRAINT IF EXISTS ck_cat_tipo_diligencia_requiere_autorizacion_judicial;
ALTER TABLE diligencias.cat_tipo_diligencia DROP CONSTRAINT IF EXISTS df_cat_tipo_diligencia_requiere_autorizacion_judicial;
ALTER TABLE diligencias.cat_tipo_diligencia ALTER COLUMN requiere_autorizacion_judicial boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_diligencia_requiere_autorizacion_judicial' AND parent_object_id=OBJECT_ID(N'diligencias.cat_tipo_diligencia'))
 ALTER TABLE diligencias.cat_tipo_diligencia ADD CONSTRAINT df_cat_tipo_diligencia_requiere_autorizacion_judicial DEFAULT (0) FOR requiere_autorizacion_judicial;

-- diligencias.cat_tipo_notificacion_externa.actualiza_estado_caso -> boolean
ALTER TABLE diligencias.cat_tipo_notificacion_externa DROP CONSTRAINT IF EXISTS ck_cat_tipo_notificacion_externa_actualiza_estado_caso;
ALTER TABLE diligencias.cat_tipo_notificacion_externa DROP CONSTRAINT IF EXISTS df_cat_tipo_notificacion_externa_actualiza_estado_caso;
ALTER TABLE diligencias.cat_tipo_notificacion_externa ALTER COLUMN actualiza_estado_caso boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_notificacion_externa_actualiza_estado_caso' AND parent_object_id=OBJECT_ID(N'diligencias.cat_tipo_notificacion_externa'))
 ALTER TABLE diligencias.cat_tipo_notificacion_externa ADD CONSTRAINT df_cat_tipo_notificacion_externa_actualiza_estado_caso DEFAULT (0) FOR actualiza_estado_caso;

-- diligencias.detencion.alerta_extranjero -> boolean
ALTER TABLE diligencias.detencion DROP CONSTRAINT IF EXISTS ck_detencion_alerta_extranjero;
ALTER TABLE diligencias.detencion DROP CONSTRAINT IF EXISTS df_detencion_alerta_extranjero;
ALTER TABLE diligencias.detencion ALTER COLUMN alerta_extranjero boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_detencion_alerta_extranjero' AND parent_object_id=OBJECT_ID(N'diligencias.detencion'))
 ALTER TABLE diligencias.detencion ADD CONSTRAINT df_detencion_alerta_extranjero DEFAULT (0) FOR alerta_extranjero;

-- diligencias.detencion_lugar.es_principal -> boolean
ALTER TABLE diligencias.detencion_lugar DROP CONSTRAINT IF EXISTS ck_detencion_lugar_es_principal;
ALTER TABLE diligencias.detencion_lugar DROP CONSTRAINT IF EXISTS df_detencion_lugar_es_principal;
ALTER TABLE diligencias.detencion_lugar ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_detencion_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'diligencias.detencion_lugar'))
 ALTER TABLE diligencias.detencion_lugar ADD CONSTRAINT df_detencion_lugar_es_principal DEFAULT (0) FOR es_principal;

-- diligencias.diligencia.es_origen_institucional -> boolean
ALTER TABLE diligencias.diligencia DROP CONSTRAINT IF EXISTS ck_diligencia_es_origen_institucional;
ALTER TABLE diligencias.diligencia DROP CONSTRAINT IF EXISTS df_diligencia_es_origen_institucional;
ALTER TABLE diligencias.diligencia ALTER COLUMN es_origen_institucional boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_es_origen_institucional' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia'))
 ALTER TABLE diligencias.diligencia ADD CONSTRAINT df_diligencia_es_origen_institucional DEFAULT (0) FOR es_origen_institucional;

-- diligencias.diligencia.autoriza_descerrajamiento -> boolean
ALTER TABLE diligencias.diligencia DROP CONSTRAINT IF EXISTS ck_diligencia_autoriza_descerrajamiento;
ALTER TABLE diligencias.diligencia DROP CONSTRAINT IF EXISTS df_diligencia_autoriza_descerrajamiento;
ALTER TABLE diligencias.diligencia ALTER COLUMN autoriza_descerrajamiento boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_autoriza_descerrajamiento' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia'))
 ALTER TABLE diligencias.diligencia ADD CONSTRAINT df_diligencia_autoriza_descerrajamiento DEFAULT (0) FOR autoriza_descerrajamiento;

-- diligencias.diligencia.es_bitacora -> boolean
ALTER TABLE diligencias.diligencia DROP CONSTRAINT IF EXISTS ck_diligencia_es_bitacora;
ALTER TABLE diligencias.diligencia DROP CONSTRAINT IF EXISTS df_diligencia_es_bitacora;
ALTER TABLE diligencias.diligencia ALTER COLUMN es_bitacora boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_es_bitacora' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia'))
 ALTER TABLE diligencias.diligencia ADD CONSTRAINT df_diligencia_es_bitacora DEFAULT (0) FOR es_bitacora;

-- diligencias.diligencia_lugar.es_principal -> boolean
ALTER TABLE diligencias.diligencia_lugar DROP CONSTRAINT IF EXISTS ck_diligencia_lugar_es_principal;
ALTER TABLE diligencias.diligencia_lugar DROP CONSTRAINT IF EXISTS df_diligencia_lugar_es_principal;
ALTER TABLE diligencias.diligencia_lugar ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_diligencia_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'diligencias.diligencia_lugar'))
 ALTER TABLE diligencias.diligencia_lugar ADD CONSTRAINT df_diligencia_lugar_es_principal DEFAULT (0) FOR es_principal;

-- diligencias.instruccion_fiscal.es_orden_verbal -> boolean
ALTER TABLE diligencias.instruccion_fiscal DROP CONSTRAINT IF EXISTS ck_instruccion_fiscal_es_orden_verbal;
ALTER TABLE diligencias.instruccion_fiscal DROP CONSTRAINT IF EXISTS df_instruccion_fiscal_es_orden_verbal;
ALTER TABLE diligencias.instruccion_fiscal ALTER COLUMN es_orden_verbal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_instruccion_fiscal_es_orden_verbal' AND parent_object_id=OBJECT_ID(N'diligencias.instruccion_fiscal'))
 ALTER TABLE diligencias.instruccion_fiscal ADD CONSTRAINT df_instruccion_fiscal_es_orden_verbal DEFAULT (0) FOR es_orden_verbal;

-- diligencias.instruccion_fiscal.es_secreto -> boolean
ALTER TABLE diligencias.instruccion_fiscal DROP CONSTRAINT IF EXISTS ck_instruccion_fiscal_es_secreto;
ALTER TABLE diligencias.instruccion_fiscal DROP CONSTRAINT IF EXISTS df_instruccion_fiscal_es_secreto;
ALTER TABLE diligencias.instruccion_fiscal ALTER COLUMN es_secreto boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_instruccion_fiscal_es_secreto' AND parent_object_id=OBJECT_ID(N'diligencias.instruccion_fiscal'))
 ALTER TABLE diligencias.instruccion_fiscal ADD CONSTRAINT df_instruccion_fiscal_es_secreto DEFAULT (0) FOR es_secreto;

-- diligencias.orden_detencion.es_secreta -> boolean
ALTER TABLE diligencias.orden_detencion DROP CONSTRAINT IF EXISTS ck_orden_detencion_es_secreta;
ALTER TABLE diligencias.orden_detencion DROP CONSTRAINT IF EXISTS df_orden_detencion_es_secreta;
ALTER TABLE diligencias.orden_detencion ALTER COLUMN es_secreta boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_orden_detencion_es_secreta' AND parent_object_id=OBJECT_ID(N'diligencias.orden_detencion'))
 ALTER TABLE diligencias.orden_detencion ADD CONSTRAINT df_orden_detencion_es_secreta DEFAULT (0) FOR es_secreta;

-- diligencias.solicitud_concurrencia_pericial.es_homicidio -> boolean
ALTER TABLE diligencias.solicitud_concurrencia_pericial DROP CONSTRAINT IF EXISTS ck_solicitud_concurrencia_pericial_es_homicidio;
ALTER TABLE diligencias.solicitud_concurrencia_pericial DROP CONSTRAINT IF EXISTS df_solicitud_concurrencia_pericial_es_homicidio;
ALTER TABLE diligencias.solicitud_concurrencia_pericial ALTER COLUMN es_homicidio boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_solicitud_concurrencia_pericial_es_homicidio' AND parent_object_id=OBJECT_ID(N'diligencias.solicitud_concurrencia_pericial'))
 ALTER TABLE diligencias.solicitud_concurrencia_pericial ADD CONSTRAINT df_solicitud_concurrencia_pericial_es_homicidio DEFAULT (0) FOR es_homicidio;

-- evidencias.arma.es_mencionada -> boolean
ALTER TABLE evidencias.arma DROP CONSTRAINT IF EXISTS ck_arma_es_mencionada;
ALTER TABLE evidencias.arma DROP CONSTRAINT IF EXISTS df_arma_es_mencionada;
ALTER TABLE evidencias.arma ALTER COLUMN es_mencionada boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_arma_es_mencionada' AND parent_object_id=OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma ADD CONSTRAINT df_arma_es_mencionada DEFAULT (0) FOR es_mencionada;

-- evidencias.cat_catalogo_armas.activo -> boolean
ALTER TABLE evidencias.cat_catalogo_armas DROP CONSTRAINT IF EXISTS ck_cat_catalogo_armas_activo;
ALTER TABLE evidencias.cat_catalogo_armas DROP CONSTRAINT IF EXISTS df_cat_catalogo_armas_activo;
ALTER TABLE evidencias.cat_catalogo_armas ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_catalogo_armas_activo' AND parent_object_id=OBJECT_ID(N'evidencias.cat_catalogo_armas'))
 ALTER TABLE evidencias.cat_catalogo_armas ADD CONSTRAINT df_cat_catalogo_armas_activo DEFAULT (1) FOR activo;

-- evidencias.cat_clasificacion_arma.activo -> boolean
ALTER TABLE evidencias.cat_clasificacion_arma DROP CONSTRAINT IF EXISTS ck_cat_clasificacion_arma_activo;
ALTER TABLE evidencias.cat_clasificacion_arma DROP CONSTRAINT IF EXISTS df_cat_clasificacion_arma_activo;
ALTER TABLE evidencias.cat_clasificacion_arma ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_clasificacion_arma_activo' AND parent_object_id=OBJECT_ID(N'evidencias.cat_clasificacion_arma'))
 ALTER TABLE evidencias.cat_clasificacion_arma ADD CONSTRAINT df_cat_clasificacion_arma_activo DEFAULT (1) FOR activo;

-- evidencias.cat_droga.activo -> boolean
ALTER TABLE evidencias.cat_droga DROP CONSTRAINT IF EXISTS ck_cat_droga_activo;
ALTER TABLE evidencias.cat_droga DROP CONSTRAINT IF EXISTS df_cat_droga_activo;
ALTER TABLE evidencias.cat_droga ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_droga_activo' AND parent_object_id=OBJECT_ID(N'evidencias.cat_droga'))
 ALTER TABLE evidencias.cat_droga ADD CONSTRAINT df_cat_droga_activo DEFAULT (1) FOR activo;

-- evidencias.cat_estado_especie.es_salida_definitiva -> boolean
ALTER TABLE evidencias.cat_estado_especie DROP CONSTRAINT IF EXISTS ck_cat_estado_especie_es_salida_definitiva;
ALTER TABLE evidencias.cat_estado_especie DROP CONSTRAINT IF EXISTS df_cat_estado_especie_es_salida_definitiva;
ALTER TABLE evidencias.cat_estado_especie ALTER COLUMN es_salida_definitiva boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_estado_especie_es_salida_definitiva' AND parent_object_id=OBJECT_ID(N'evidencias.cat_estado_especie'))
 ALTER TABLE evidencias.cat_estado_especie ADD CONSTRAINT df_cat_estado_especie_es_salida_definitiva DEFAULT (0) FOR es_salida_definitiva;

-- evidencias.cat_tipo_extension_especie.requiere_extension -> boolean
ALTER TABLE evidencias.cat_tipo_extension_especie DROP CONSTRAINT IF EXISTS ck_cat_tipo_extension_especie_requiere_extension;
ALTER TABLE evidencias.cat_tipo_extension_especie DROP CONSTRAINT IF EXISTS df_cat_tipo_extension_especie_requiere_extension;
ALTER TABLE evidencias.cat_tipo_extension_especie ALTER COLUMN requiere_extension boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_extension_especie_requiere_extension' AND parent_object_id=OBJECT_ID(N'evidencias.cat_tipo_extension_especie'))
 ALTER TABLE evidencias.cat_tipo_extension_especie ADD CONSTRAINT df_cat_tipo_extension_especie_requiere_extension DEFAULT (0) FOR requiere_extension;

-- evidencias.especie.registro_fotografico -> boolean
ALTER TABLE evidencias.especie DROP CONSTRAINT IF EXISTS ck_especie_registro_fotografico;
ALTER TABLE evidencias.especie DROP CONSTRAINT IF EXISTS df_especie_registro_fotografico;
ALTER TABLE evidencias.especie ALTER COLUMN registro_fotografico boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_especie_registro_fotografico' AND parent_object_id=OBJECT_ID(N'evidencias.especie'))
 ALTER TABLE evidencias.especie ADD CONSTRAINT df_especie_registro_fotografico DEFAULT (0) FOR registro_fotografico;

-- evidencias.especie_droga.es_orientativo -> boolean
ALTER TABLE evidencias.especie_droga DROP CONSTRAINT IF EXISTS ck_especie_droga_es_orientativo;
ALTER TABLE evidencias.especie_droga DROP CONSTRAINT IF EXISTS df_especie_droga_es_orientativo;
ALTER TABLE evidencias.especie_droga ALTER COLUMN es_orientativo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_especie_droga_es_orientativo' AND parent_object_id=OBJECT_ID(N'evidencias.especie_droga'))
 ALTER TABLE evidencias.especie_droga ADD CONSTRAINT df_especie_droga_es_orientativo DEFAULT (0) FOR es_orientativo;

-- evidencias.especie_lugar.es_principal -> boolean
ALTER TABLE evidencias.especie_lugar DROP CONSTRAINT IF EXISTS ck_especie_lugar_es_principal;
ALTER TABLE evidencias.especie_lugar DROP CONSTRAINT IF EXISTS df_especie_lugar_es_principal;
ALTER TABLE evidencias.especie_lugar ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_especie_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'evidencias.especie_lugar'))
 ALTER TABLE evidencias.especie_lugar ADD CONSTRAINT df_especie_lugar_es_principal DEFAULT (0) FOR es_principal;

-- evidencias.evidencia_lugar.es_principal -> boolean
ALTER TABLE evidencias.evidencia_lugar DROP CONSTRAINT IF EXISTS ck_evidencia_lugar_es_principal;
ALTER TABLE evidencias.evidencia_lugar DROP CONSTRAINT IF EXISTS df_evidencia_lugar_es_principal;
ALTER TABLE evidencias.evidencia_lugar ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_evidencia_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'evidencias.evidencia_lugar'))
 ALTER TABLE evidencias.evidencia_lugar ADD CONSTRAINT df_evidencia_lugar_es_principal DEFAULT (0) FOR es_principal;

-- evidencias.incautacion.acta_generada -> boolean
ALTER TABLE evidencias.incautacion DROP CONSTRAINT IF EXISTS ck_incautacion_acta_generada;
ALTER TABLE evidencias.incautacion DROP CONSTRAINT IF EXISTS df_incautacion_acta_generada;
ALTER TABLE evidencias.incautacion ALTER COLUMN acta_generada boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_incautacion_acta_generada' AND parent_object_id=OBJECT_ID(N'evidencias.incautacion'))
 ALTER TABLE evidencias.incautacion ADD CONSTRAINT df_incautacion_acta_generada DEFAULT (0) FOR acta_generada;

-- investigacion.cat_delito.requiere_peritaje_adn -> boolean
ALTER TABLE investigacion.cat_delito DROP CONSTRAINT IF EXISTS ck_cat_delito_requiere_peritaje_adn;
ALTER TABLE investigacion.cat_delito DROP CONSTRAINT IF EXISTS df_cat_delito_requiere_peritaje_adn;
ALTER TABLE investigacion.cat_delito ALTER COLUMN requiere_peritaje_adn boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_delito_requiere_peritaje_adn' AND parent_object_id=OBJECT_ID(N'investigacion.cat_delito'))
 ALTER TABLE investigacion.cat_delito ADD CONSTRAINT df_cat_delito_requiere_peritaje_adn DEFAULT (0) FOR requiere_peritaje_adn;

-- investigacion.cat_delito.vigente -> boolean
ALTER TABLE investigacion.cat_delito DROP CONSTRAINT IF EXISTS ck_cat_delito_vigente;
ALTER TABLE investigacion.cat_delito DROP CONSTRAINT IF EXISTS df_cat_delito_vigente;
ALTER TABLE investigacion.cat_delito ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_delito_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_delito'))
 ALTER TABLE investigacion.cat_delito ADD CONSTRAINT df_cat_delito_vigente DEFAULT (1) FOR vigente;

-- investigacion.cat_detalle_lugar_general_hecho.activo -> boolean
ALTER TABLE investigacion.cat_detalle_lugar_general_hecho DROP CONSTRAINT IF EXISTS ck_cat_detalle_lugar_general_hecho_activo;
ALTER TABLE investigacion.cat_detalle_lugar_general_hecho DROP CONSTRAINT IF EXISTS df_cat_detalle_lugar_general_hecho_activo;
ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_detalle_lugar_general_hecho_activo' AND parent_object_id=OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'))
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ADD CONSTRAINT df_cat_detalle_lugar_general_hecho_activo DEFAULT (1) FOR activo;

-- investigacion.cat_forma_contacto.vigente -> boolean
ALTER TABLE investigacion.cat_forma_contacto DROP CONSTRAINT IF EXISTS ck_cat_forma_contacto_vigente;
ALTER TABLE investigacion.cat_forma_contacto DROP CONSTRAINT IF EXISTS df_cat_forma_contacto_vigente;
ALTER TABLE investigacion.cat_forma_contacto ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_forma_contacto_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_forma_contacto'))
 ALTER TABLE investigacion.cat_forma_contacto ADD CONSTRAINT df_cat_forma_contacto_vigente DEFAULT (1) FOR vigente;

-- investigacion.cat_lugar_general_hecho.activo -> boolean
ALTER TABLE investigacion.cat_lugar_general_hecho DROP CONSTRAINT IF EXISTS ck_cat_lugar_general_hecho_activo;
ALTER TABLE investigacion.cat_lugar_general_hecho DROP CONSTRAINT IF EXISTS df_cat_lugar_general_hecho_activo;
ALTER TABLE investigacion.cat_lugar_general_hecho ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_lugar_general_hecho_activo' AND parent_object_id=OBJECT_ID(N'investigacion.cat_lugar_general_hecho'))
 ALTER TABLE investigacion.cat_lugar_general_hecho ADD CONSTRAINT df_cat_lugar_general_hecho_activo DEFAULT (1) FOR activo;

-- investigacion.cat_movil.aplica_homicidio -> boolean
ALTER TABLE investigacion.cat_movil DROP CONSTRAINT IF EXISTS ck_cat_movil_aplica_homicidio;
ALTER TABLE investigacion.cat_movil DROP CONSTRAINT IF EXISTS df_cat_movil_aplica_homicidio;
ALTER TABLE investigacion.cat_movil ALTER COLUMN aplica_homicidio boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_movil_aplica_homicidio' AND parent_object_id=OBJECT_ID(N'investigacion.cat_movil'))
 ALTER TABLE investigacion.cat_movil ADD CONSTRAINT df_cat_movil_aplica_homicidio DEFAULT (0) FOR aplica_homicidio;

-- investigacion.cat_movil.aplica_secuestro -> boolean
ALTER TABLE investigacion.cat_movil DROP CONSTRAINT IF EXISTS ck_cat_movil_aplica_secuestro;
ALTER TABLE investigacion.cat_movil DROP CONSTRAINT IF EXISTS df_cat_movil_aplica_secuestro;
ALTER TABLE investigacion.cat_movil ALTER COLUMN aplica_secuestro boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_movil_aplica_secuestro' AND parent_object_id=OBJECT_ID(N'investigacion.cat_movil'))
 ALTER TABLE investigacion.cat_movil ADD CONSTRAINT df_cat_movil_aplica_secuestro DEFAULT (0) FOR aplica_secuestro;

-- investigacion.cat_movil.vigente -> boolean
ALTER TABLE investigacion.cat_movil DROP CONSTRAINT IF EXISTS ck_cat_movil_vigente;
ALTER TABLE investigacion.cat_movil DROP CONSTRAINT IF EXISTS df_cat_movil_vigente;
ALTER TABLE investigacion.cat_movil ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_movil_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_movil'))
 ALTER TABLE investigacion.cat_movil ADD CONSTRAINT df_cat_movil_vigente DEFAULT (1) FOR vigente;

-- investigacion.cat_punto_acceso.vigente -> boolean
ALTER TABLE investigacion.cat_punto_acceso DROP CONSTRAINT IF EXISTS ck_cat_punto_acceso_vigente;
ALTER TABLE investigacion.cat_punto_acceso DROP CONSTRAINT IF EXISTS df_cat_punto_acceso_vigente;
ALTER TABLE investigacion.cat_punto_acceso ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_punto_acceso_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_punto_acceso'))
 ALTER TABLE investigacion.cat_punto_acceso ADD CONSTRAINT df_cat_punto_acceso_vigente DEFAULT (1) FOR vigente;

-- investigacion.cat_transporte_utilizado.vigente -> boolean
ALTER TABLE investigacion.cat_transporte_utilizado DROP CONSTRAINT IF EXISTS ck_cat_transporte_utilizado_vigente;
ALTER TABLE investigacion.cat_transporte_utilizado DROP CONSTRAINT IF EXISTS df_cat_transporte_utilizado_vigente;
ALTER TABLE investigacion.cat_transporte_utilizado ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_transporte_utilizado_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.cat_transporte_utilizado'))
 ALTER TABLE investigacion.cat_transporte_utilizado ADD CONSTRAINT df_cat_transporte_utilizado_vigente DEFAULT (1) FOR vigente;

-- investigacion.fenomeno_delictual.vigente -> boolean
ALTER TABLE investigacion.fenomeno_delictual DROP CONSTRAINT IF EXISTS ck_fenomeno_delictual_vigente;
ALTER TABLE investigacion.fenomeno_delictual DROP CONSTRAINT IF EXISTS df_fenomeno_delictual_vigente;
ALTER TABLE investigacion.fenomeno_delictual ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_fenomeno_delictual_vigente' AND parent_object_id=OBJECT_ID(N'investigacion.fenomeno_delictual'))
 ALTER TABLE investigacion.fenomeno_delictual ADD CONSTRAINT df_fenomeno_delictual_vigente DEFAULT (1) FOR vigente;

-- investigacion.hecho_fenomeno.es_principal -> boolean
ALTER TABLE investigacion.hecho_fenomeno DROP CONSTRAINT IF EXISTS ck_hecho_fenomeno_es_principal;
ALTER TABLE investigacion.hecho_fenomeno DROP CONSTRAINT IF EXISTS df_hecho_fenomeno_es_principal;
ALTER TABLE investigacion.hecho_fenomeno ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_hecho_fenomeno_es_principal' AND parent_object_id=OBJECT_ID(N'investigacion.hecho_fenomeno'))
 ALTER TABLE investigacion.hecho_fenomeno ADD CONSTRAINT df_hecho_fenomeno_es_principal DEFAULT (0) FOR es_principal;

-- investigacion.protocolo_delito.activo -> boolean
ALTER TABLE investigacion.protocolo_delito DROP CONSTRAINT IF EXISTS ck_protocolo_delito_activo;
ALTER TABLE investigacion.protocolo_delito DROP CONSTRAINT IF EXISTS df_protocolo_delito_activo;
ALTER TABLE investigacion.protocolo_delito ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_protocolo_delito_activo' AND parent_object_id=OBJECT_ID(N'investigacion.protocolo_delito'))
 ALTER TABLE investigacion.protocolo_delito ADD CONSTRAINT df_protocolo_delito_activo DEFAULT (1) FOR activo;

-- migracion.cat_tipo_infraccion_migratoria.activo -> boolean
ALTER TABLE migracion.cat_tipo_infraccion_migratoria DROP CONSTRAINT IF EXISTS ck_cat_tipo_infraccion_migratoria_activo;
ALTER TABLE migracion.cat_tipo_infraccion_migratoria DROP CONSTRAINT IF EXISTS df_cat_tipo_infraccion_migratoria_activo;
ALTER TABLE migracion.cat_tipo_infraccion_migratoria ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_infraccion_migratoria_activo' AND parent_object_id=OBJECT_ID(N'migracion.cat_tipo_infraccion_migratoria'))
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria ADD CONSTRAINT df_cat_tipo_infraccion_migratoria_activo DEFAULT (1) FOR activo;

-- migracion.denuncia_administrativa_migratoria.generada_en_ausencia -> boolean
ALTER TABLE migracion.denuncia_administrativa_migratoria DROP CONSTRAINT IF EXISTS ck_denuncia_administrativa_migratoria_generada_en_ausencia;
ALTER TABLE migracion.denuncia_administrativa_migratoria DROP CONSTRAINT IF EXISTS df_denuncia_administrativa_migratoria_generada_en_ausencia;
ALTER TABLE migracion.denuncia_administrativa_migratoria ALTER COLUMN generada_en_ausencia boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_denuncia_administrativa_migratoria_generada_en_ausencia' AND parent_object_id=OBJECT_ID(N'migracion.denuncia_administrativa_migratoria'))
 ALTER TABLE migracion.denuncia_administrativa_migratoria ADD CONSTRAINT df_denuncia_administrativa_migratoria_generada_en_ausencia DEFAULT (0) FOR generada_en_ausencia;

-- organizacion.cat_nivel_organismo.activo -> boolean
ALTER TABLE organizacion.cat_nivel_organismo DROP CONSTRAINT IF EXISTS ck_cat_nivel_organismo_activo;
ALTER TABLE organizacion.cat_nivel_organismo DROP CONSTRAINT IF EXISTS df_cat_nivel_organismo_activo;
ALTER TABLE organizacion.cat_nivel_organismo ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_nivel_organismo_activo' AND parent_object_id=OBJECT_ID(N'organizacion.cat_nivel_organismo'))
 ALTER TABLE organizacion.cat_nivel_organismo ADD CONSTRAINT df_cat_nivel_organismo_activo DEFAULT (1) FOR activo;

-- organizacion.cat_organismo_externo.activo -> boolean
ALTER TABLE organizacion.cat_organismo_externo DROP CONSTRAINT IF EXISTS ck_cat_organismo_externo_activo;
ALTER TABLE organizacion.cat_organismo_externo DROP CONSTRAINT IF EXISTS df_cat_organismo_externo_activo;
ALTER TABLE organizacion.cat_organismo_externo ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_organismo_externo_activo' AND parent_object_id=OBJECT_ID(N'organizacion.cat_organismo_externo'))
 ALTER TABLE organizacion.cat_organismo_externo ADD CONSTRAINT df_cat_organismo_externo_activo DEFAULT (1) FOR activo;

-- organizacion.cat_tipo_organismo.activo -> boolean
ALTER TABLE organizacion.cat_tipo_organismo DROP CONSTRAINT IF EXISTS ck_cat_tipo_organismo_activo;
ALTER TABLE organizacion.cat_tipo_organismo DROP CONSTRAINT IF EXISTS df_cat_tipo_organismo_activo;
ALTER TABLE organizacion.cat_tipo_organismo ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_organismo_activo' AND parent_object_id=OBJECT_ID(N'organizacion.cat_tipo_organismo'))
 ALTER TABLE organizacion.cat_tipo_organismo ADD CONSTRAINT df_cat_tipo_organismo_activo DEFAULT (1) FOR activo;

-- personas.cat_actividad_economica.activo -> boolean
ALTER TABLE personas.cat_actividad_economica DROP CONSTRAINT IF EXISTS ck_cat_actividad_economica_act;
ALTER TABLE personas.cat_actividad_economica DROP CONSTRAINT IF EXISTS df_cat_act_eco_activo;
ALTER TABLE personas.cat_actividad_economica ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_act_eco_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_actividad_economica'))
 ALTER TABLE personas.cat_actividad_economica ADD CONSTRAINT df_cat_act_eco_activo DEFAULT (1) FOR activo;

-- personas.cat_ocupacion.activo -> boolean
ALTER TABLE personas.cat_ocupacion DROP CONSTRAINT IF EXISTS ck_cat_ocupacion_activo;
ALTER TABLE personas.cat_ocupacion DROP CONSTRAINT IF EXISTS df_cat_ocupacion_activo;
ALTER TABLE personas.cat_ocupacion ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_ocupacion_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_ocupacion'))
 ALTER TABLE personas.cat_ocupacion ADD CONSTRAINT df_cat_ocupacion_activo DEFAULT (1) FOR activo;

-- personas.cat_tipo_nombre.activo -> boolean
ALTER TABLE personas.cat_tipo_nombre DROP CONSTRAINT IF EXISTS ck_cat_tipo_nombre_act;
ALTER TABLE personas.cat_tipo_nombre DROP CONSTRAINT IF EXISTS df_cat_tipo_nombre_activo;
ALTER TABLE personas.cat_tipo_nombre ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_nombre_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_nombre'))
 ALTER TABLE personas.cat_tipo_nombre ADD CONSTRAINT df_cat_tipo_nombre_activo DEFAULT (1) FOR activo;

-- personas.cat_tipo_persona.activo -> boolean
ALTER TABLE personas.cat_tipo_persona DROP CONSTRAINT IF EXISTS ck_cat_tipo_persona_act;
ALTER TABLE personas.cat_tipo_persona DROP CONSTRAINT IF EXISTS df_cat_tipo_persona_activo;
ALTER TABLE personas.cat_tipo_persona ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_persona_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_persona'))
 ALTER TABLE personas.cat_tipo_persona ADD CONSTRAINT df_cat_tipo_persona_activo DEFAULT (1) FOR activo;

-- personas.cat_tipo_persona_juridica.activo -> boolean
ALTER TABLE personas.cat_tipo_persona_juridica DROP CONSTRAINT IF EXISTS ck_cat_tipo_persona_juridica_act;
ALTER TABLE personas.cat_tipo_persona_juridica DROP CONSTRAINT IF EXISTS df_cat_tipo_pj_activo;
ALTER TABLE personas.cat_tipo_persona_juridica ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_pj_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_persona_juridica'))
 ALTER TABLE personas.cat_tipo_persona_juridica ADD CONSTRAINT df_cat_tipo_pj_activo DEFAULT (1) FOR activo;

-- personas.cat_tipo_relacion.es_bidireccional -> boolean
ALTER TABLE personas.cat_tipo_relacion DROP CONSTRAINT IF EXISTS ck_cat_tipo_relacion_es_bidireccional;
ALTER TABLE personas.cat_tipo_relacion DROP CONSTRAINT IF EXISTS df_cat_tipo_relacion_es_bidireccional;
ALTER TABLE personas.cat_tipo_relacion ALTER COLUMN es_bidireccional boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_relacion_es_bidireccional' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_relacion'))
 ALTER TABLE personas.cat_tipo_relacion ADD CONSTRAINT df_cat_tipo_relacion_es_bidireccional DEFAULT (0) FOR es_bidireccional;

-- personas.cat_tipo_representacion.activo -> boolean
ALTER TABLE personas.cat_tipo_representacion DROP CONSTRAINT IF EXISTS ck_cat_tipo_representacion_act;
ALTER TABLE personas.cat_tipo_representacion DROP CONSTRAINT IF EXISTS df_cat_tipo_rep_activo;
ALTER TABLE personas.cat_tipo_representacion ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_rep_activo' AND parent_object_id=OBJECT_ID(N'personas.cat_tipo_representacion'))
 ALTER TABLE personas.cat_tipo_representacion ADD CONSTRAINT df_cat_tipo_rep_activo DEFAULT (1) FOR activo;

-- personas.contacto_otro.es_principal -> boolean
ALTER TABLE personas.contacto_otro DROP CONSTRAINT IF EXISTS ck_contacto_otro_es_principal;
ALTER TABLE personas.contacto_otro DROP CONSTRAINT IF EXISTS df_contacto_otro_es_principal;
ALTER TABLE personas.contacto_otro ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_contacto_otro_es_principal' AND parent_object_id=OBJECT_ID(N'personas.contacto_otro'))
 ALTER TABLE personas.contacto_otro ADD CONSTRAINT df_contacto_otro_es_principal DEFAULT (0) FOR es_principal;

-- personas.correo.es_principal -> boolean
DROP INDEX IF EXISTS ux_correo_principal_activo ON personas.correo;
ALTER TABLE personas.correo DROP CONSTRAINT IF EXISTS ck_correo_es_principal;
ALTER TABLE personas.correo DROP CONSTRAINT IF EXISTS df_correo_es_principal;
ALTER TABLE personas.correo ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_correo_es_principal' AND parent_object_id=OBJECT_ID(N'personas.correo'))
 ALTER TABLE personas.correo ADD CONSTRAINT df_correo_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_correo_principal_activo' AND object_id=OBJECT_ID(N'personas.correo'))
 CREATE UNIQUE INDEX ux_correo_principal_activo ON personas.correo (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- personas.empleo.es_actual -> boolean
ALTER TABLE personas.empleo DROP CONSTRAINT IF EXISTS ck_empleo_es_actual;
ALTER TABLE personas.empleo DROP CONSTRAINT IF EXISTS df_empleo_es_actual;
ALTER TABLE personas.empleo ALTER COLUMN es_actual boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_empleo_es_actual' AND parent_object_id=OBJECT_ID(N'personas.empleo'))
 ALTER TABLE personas.empleo ADD CONSTRAINT df_empleo_es_actual DEFAULT (1) FOR es_actual;

-- personas.fotografia.es_principal -> boolean
DROP INDEX IF EXISTS ux_foto_principal_activa ON personas.fotografia;
ALTER TABLE personas.fotografia DROP CONSTRAINT IF EXISTS ck_fotografia_es_principal;
ALTER TABLE personas.fotografia DROP CONSTRAINT IF EXISTS df_fotografia_es_principal;
ALTER TABLE personas.fotografia ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_fotografia_es_principal' AND parent_object_id=OBJECT_ID(N'personas.fotografia'))
 ALTER TABLE personas.fotografia ADD CONSTRAINT df_fotografia_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_foto_principal_activa' AND object_id=OBJECT_ID(N'personas.fotografia'))
 CREATE UNIQUE INDEX ux_foto_principal_activa ON personas.fotografia (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- personas.identificacion.es_principal -> boolean
DROP INDEX IF EXISTS ux_ident_principal_activo ON personas.identificacion;
ALTER TABLE personas.identificacion DROP CONSTRAINT IF EXISTS ck_identificacion_es_principal;
ALTER TABLE personas.identificacion DROP CONSTRAINT IF EXISTS df_identificacion_es_principal;
ALTER TABLE personas.identificacion ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_identificacion_es_principal' AND parent_object_id=OBJECT_ID(N'personas.identificacion'))
 ALTER TABLE personas.identificacion ADD CONSTRAINT df_identificacion_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_ident_principal_activo' AND object_id=OBJECT_ID(N'personas.identificacion'))
 CREATE UNIQUE INDEX ux_ident_principal_activo ON personas.identificacion (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- personas.identificacion.es_temporal -> boolean
ALTER TABLE personas.identificacion DROP CONSTRAINT IF EXISTS ck_identificacion_es_temporal;
ALTER TABLE personas.identificacion DROP CONSTRAINT IF EXISTS df_identificacion_es_temporal;
ALTER TABLE personas.identificacion ALTER COLUMN es_temporal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_identificacion_es_temporal' AND parent_object_id=OBJECT_ID(N'personas.identificacion'))
 ALTER TABLE personas.identificacion ADD CONSTRAINT df_identificacion_es_temporal DEFAULT (0) FOR es_temporal;

-- personas.nombre.es_nombre_supuesto -> boolean
ALTER TABLE personas.nombre DROP CONSTRAINT IF EXISTS ck_nombre_es_nombre_supuesto;
ALTER TABLE personas.nombre DROP CONSTRAINT IF EXISTS df_nombre_es_nombre_supuesto;
ALTER TABLE personas.nombre ALTER COLUMN es_nombre_supuesto boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_nombre_es_nombre_supuesto' AND parent_object_id=OBJECT_ID(N'personas.nombre'))
 ALTER TABLE personas.nombre ADD CONSTRAINT df_nombre_es_nombre_supuesto DEFAULT (0) FOR es_nombre_supuesto;

-- personas.persona_lugar.es_principal -> boolean
DROP INDEX IF EXISTS ux_persona_lugar_principal_activo ON personas.persona_lugar;
ALTER TABLE personas.persona_lugar DROP CONSTRAINT IF EXISTS ck_persona_lugar_es_principal;
ALTER TABLE personas.persona_lugar DROP CONSTRAINT IF EXISTS df_persona_lugar_es_principal;
ALTER TABLE personas.persona_lugar ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_persona_lugar_es_principal' AND parent_object_id=OBJECT_ID(N'personas.persona_lugar'))
 ALTER TABLE personas.persona_lugar ADD CONSTRAINT df_persona_lugar_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_persona_lugar_principal_activo' AND object_id=OBJECT_ID(N'personas.persona_lugar'))
 CREATE UNIQUE INDEX ux_persona_lugar_principal_activo ON personas.persona_lugar (id_persona, id_rol_lugar) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- personas.persona_natural.domicilio_extranjero -> boolean
ALTER TABLE personas.persona_natural DROP CONSTRAINT IF EXISTS ck_pn_domicilio_extranjero;
ALTER TABLE personas.persona_natural DROP CONSTRAINT IF EXISTS df_pn_domicilio_extranjero;
ALTER TABLE personas.persona_natural ALTER COLUMN domicilio_extranjero boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pn_domicilio_extranjero' AND parent_object_id=OBJECT_ID(N'personas.persona_natural'))
 ALTER TABLE personas.persona_natural ADD CONSTRAINT df_pn_domicilio_extranjero DEFAULT (0) FOR domicilio_extranjero;

-- personas.pj_actividad_economica.es_principal -> boolean
ALTER TABLE personas.pj_actividad_economica DROP CONSTRAINT IF EXISTS ck_pjae_es_principal;
ALTER TABLE personas.pj_actividad_economica DROP CONSTRAINT IF EXISTS df_pjae_es_principal;
ALTER TABLE personas.pj_actividad_economica ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_pjae_es_principal' AND parent_object_id=OBJECT_ID(N'personas.pj_actividad_economica'))
 ALTER TABLE personas.pj_actividad_economica ADD CONSTRAINT df_pjae_es_principal DEFAULT (0) FOR es_principal;

-- personas.telefono.es_principal -> boolean
DROP INDEX IF EXISTS ux_telefono_principal_activo ON personas.telefono;
ALTER TABLE personas.telefono DROP CONSTRAINT IF EXISTS ck_telefono_es_principal;
ALTER TABLE personas.telefono DROP CONSTRAINT IF EXISTS df_telefono_es_principal;
ALTER TABLE personas.telefono ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_telefono_es_principal' AND parent_object_id=OBJECT_ID(N'personas.telefono'))
 ALTER TABLE personas.telefono ADD CONSTRAINT df_telefono_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_telefono_principal_activo' AND object_id=OBJECT_ID(N'personas.telefono'))
 CREATE UNIQUE INDEX ux_telefono_principal_activo ON personas.telefono (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

-- tareas.tipo_documento.vigente -> boolean
ALTER TABLE tareas.tipo_documento DROP CONSTRAINT IF EXISTS ck_tipo_documento_vigente;
ALTER TABLE tareas.tipo_documento DROP CONSTRAINT IF EXISTS df_tipo_documento_vigente;
ALTER TABLE tareas.tipo_documento ALTER COLUMN vigente boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_tipo_documento_vigente' AND parent_object_id=OBJECT_ID(N'tareas.tipo_documento'))
 ALTER TABLE tareas.tipo_documento ADD CONSTRAINT df_tipo_documento_vigente DEFAULT (1) FOR vigente;

-- tareas.tipo_tarea.requiere_aprobacion -> boolean
ALTER TABLE tareas.tipo_tarea DROP CONSTRAINT IF EXISTS ck_tipo_tarea_requiere_aprobacion;
ALTER TABLE tareas.tipo_tarea DROP CONSTRAINT IF EXISTS df_tipo_tarea_requiere_aprobacion;
ALTER TABLE tareas.tipo_tarea ALTER COLUMN requiere_aprobacion boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_tipo_tarea_requiere_aprobacion' AND parent_object_id=OBJECT_ID(N'tareas.tipo_tarea'))
 ALTER TABLE tareas.tipo_tarea ADD CONSTRAINT df_tipo_tarea_requiere_aprobacion DEFAULT (0) FOR requiere_aprobacion;

-- tareas.tipo_tarea.permite_adjuntar_archivos -> boolean
ALTER TABLE tareas.tipo_tarea DROP CONSTRAINT IF EXISTS ck_tipo_tarea_permite_adjuntar_archivos;
ALTER TABLE tareas.tipo_tarea DROP CONSTRAINT IF EXISTS df_tipo_tarea_permite_adjuntar_archivos;
ALTER TABLE tareas.tipo_tarea ALTER COLUMN permite_adjuntar_archivos boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_tipo_tarea_permite_adjuntar_archivos' AND parent_object_id=OBJECT_ID(N'tareas.tipo_tarea'))
 ALTER TABLE tareas.tipo_tarea ADD CONSTRAINT df_tipo_tarea_permite_adjuntar_archivos DEFAULT (0) FOR permite_adjuntar_archivos;

-- ubicacion.cat_tipo_subdivision.activo -> boolean
ALTER TABLE ubicacion.cat_tipo_subdivision DROP CONSTRAINT IF EXISTS ck_cat_tipo_subdivision_activo;
ALTER TABLE ubicacion.cat_tipo_subdivision DROP CONSTRAINT IF EXISTS df_cat_tipo_subdivision_activo;
ALTER TABLE ubicacion.cat_tipo_subdivision ALTER COLUMN activo boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_cat_tipo_subdivision_activo' AND parent_object_id=OBJECT_ID(N'ubicacion.cat_tipo_subdivision'))
 ALTER TABLE ubicacion.cat_tipo_subdivision ADD CONSTRAINT df_cat_tipo_subdivision_activo DEFAULT (1) FOR activo;

-- vehiculos.persona_vehiculo.es_principal -> boolean
DROP INDEX IF EXISTS ux_perveh_principal_activo ON vehiculos.persona_vehiculo;
ALTER TABLE vehiculos.persona_vehiculo DROP CONSTRAINT IF EXISTS ck_persona_vehiculo_es_principal;
ALTER TABLE vehiculos.persona_vehiculo DROP CONSTRAINT IF EXISTS df_persona_vehiculo_es_principal;
ALTER TABLE vehiculos.persona_vehiculo ALTER COLUMN es_principal boolean NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name=N'df_persona_vehiculo_es_principal' AND parent_object_id=OBJECT_ID(N'vehiculos.persona_vehiculo'))
 ALTER TABLE vehiculos.persona_vehiculo ADD CONSTRAINT df_persona_vehiculo_es_principal DEFAULT (0) FOR es_principal;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'ux_perveh_principal_activo' AND object_id=OBJECT_ID(N'vehiculos.persona_vehiculo'))
 CREATE UNIQUE INDEX ux_perveh_principal_activo ON vehiculos.persona_vehiculo (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;

