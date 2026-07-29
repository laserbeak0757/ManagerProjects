/* =============================================================================
 V0025 - Renombre de columnas de auditoria y correccion de dependientes
 -----------------------------------------------------------------------------
 Alcance (solo parte estructural "destructiva", atomica):
 - Renombra 95 columnas fecha_registro -> fecha_creacion
 - Renombra 63 columnas fecha_eliminacion -> fecha_eliminacion_logica
 - Renombra 95 constraints DEFAULT df_*_fecha_registro -> df_*_fecha_creacion
 - Recrea 14 indices unicos filtrados (WHERE fecha_eliminacion IS NULL)
 - (Los SP/funciones se corrigen en los R__*_programmability.sql, NO aqui)

 NO incluido (va en V0026+): nuevas columnas id_usuario_* / fecha_actualizacion,
 FKs a auth.usuario, y NOT NULL en dos tiempos. Sin backfill.

 Seguridad:
 - SET XACT_ABORT ON: cualquier error en ejecucion aborta el lote.
 - Atomicidad por la transaccion por-migracion de Flyway (todo aqui es DDL
 transaccional en SQL Server; un fallo revierte la migracion completa).
 - Idempotencia: cada paso estructural con guarda (COL_LENGTH / sys.indexes /
 OBJECT_ID) para tolerar re-ejecucion sobre estado parcial.
 - Requisito: SQL Server 2016+ (sp_rename, indices filtrados).

 NOTA: ix_denuncia_mig_estado / ix_denuncia_mig_persona usan fecha_registro como
 COLUMNA CLAVE (no en WHERE); sp_rename los actualiza solo, no se recrean.
 NOTA: los 34 SP/funciones se regeneraron reemplazando nombres de columna;
 conviene una compilacion de revision en DEV.
 ============================================================================= */
SET XACT_ABORT ON;
SET NOCOUNT ON;

/* ---------- 1) DROP de los 14 indices filtrados sobre fecha_eliminacion ---------- */
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_denperrol_principal_activo' AND object_id = OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 DROP INDEX ux_denperrol_principal_activo ON denuncias.denuncia_persona_rol;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_hecho_lugar_principal_activo' AND object_id = OBJECT_ID(N'investigacion.hecho_lugar'))
 DROP INDEX ux_hecho_lugar_principal_activo ON investigacion.hecho_lugar;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_correo_principal_activo' AND object_id = OBJECT_ID(N'personas.correo'))
 DROP INDEX ux_correo_principal_activo ON personas.correo;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_foto_principal_activa' AND object_id = OBJECT_ID(N'personas.fotografia'))
 DROP INDEX ux_foto_principal_activa ON personas.fotografia;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_ident_doc_activo' AND object_id = OBJECT_ID(N'personas.identificacion'))
 DROP INDEX ux_ident_doc_activo ON personas.identificacion;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_ident_principal_activo' AND object_id = OBJECT_ID(N'personas.identificacion'))
 DROP INDEX ux_ident_principal_activo ON personas.identificacion;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_persona_lugar_principal_activo' AND object_id = OBJECT_ID(N'personas.persona_lugar'))
 DROP INDEX ux_persona_lugar_principal_activo ON personas.persona_lugar;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_pjae_actividad_activa' AND object_id = OBJECT_ID(N'personas.pj_actividad_economica'))
 DROP INDEX ux_pjae_actividad_activa ON personas.pj_actividad_economica;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_pjn_tipo_activo' AND object_id = OBJECT_ID(N'personas.pj_nombre'))
 DROP INDEX ux_pjn_tipo_activo ON personas.pj_nombre;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_pjrl_activo' AND object_id = OBJECT_ID(N'personas.pj_representante_legal'))
 DROP INDEX ux_pjrl_activo ON personas.pj_representante_legal;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_telefono_principal_activo' AND object_id = OBJECT_ID(N'personas.telefono'))
 DROP INDEX ux_telefono_principal_activo ON personas.telefono;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_perveh_principal_activo' AND object_id = OBJECT_ID(N'vehiculos.persona_vehiculo'))
 DROP INDEX ux_perveh_principal_activo ON vehiculos.persona_vehiculo;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_vehiculo_patente' AND object_id = OBJECT_ID(N'vehiculos.vehiculo'))
 DROP INDEX ux_vehiculo_patente ON vehiculos.vehiculo;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_vehiculo_vin' AND object_id = OBJECT_ID(N'vehiculos.vehiculo'))
 DROP INDEX ux_vehiculo_vin ON vehiculos.vehiculo;

/* ---------- 2) Renombre de columnas (sp_rename, con guarda idempotente) ---------- */
IF COL_LENGTH('organizacion.unidad','fecha_registro') IS NOT NULL AND COL_LENGTH('organizacion.unidad','fecha_creacion') IS NULL
 EXEC sp_rename N'organizacion.unidad.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.hecho','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.hecho','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.hecho.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('organizacion.cat_organismo_externo','fecha_registro') IS NOT NULL AND COL_LENGTH('organizacion.cat_organismo_externo','fecha_creacion') IS NULL
 EXEC sp_rename N'organizacion.cat_organismo_externo.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('denuncias.denuncia','fecha_registro') IS NOT NULL AND COL_LENGTH('denuncias.denuncia','fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.denuncia.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.cat_forma_contacto','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.cat_forma_contacto','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.cat_forma_contacto.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.cat_punto_acceso','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.cat_punto_acceso','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.cat_punto_acceso.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.cat_transporte_utilizado','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.cat_transporte_utilizado','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.cat_transporte_utilizado.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.hecho_persona_rol','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.hecho_persona_rol','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.hecho_persona_rol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('denuncias.relato','fecha_registro') IS NOT NULL AND COL_LENGTH('denuncias.relato','fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.relato.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.nombre','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.nombre','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.nombre.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.identificacion','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.identificacion','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.identificacion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.cat_delito','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.cat_delito','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.cat_delito.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.delito_imputado','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.delito_imputado','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.delito_imputado.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('ubicacion.lugar_base','fecha_registro') IS NOT NULL AND COL_LENGTH('ubicacion.lugar_base','fecha_creacion') IS NULL
 EXEC sp_rename N'ubicacion.lugar_base.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('ubicacion.lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('ubicacion.lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'ubicacion.lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.hecho_lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.hecho_lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.hecho_lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.fenomeno_delictual','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.fenomeno_delictual','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.fenomeno_delictual.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('analitica.aplicacion_reporte','fecha_registro') IS NOT NULL AND COL_LENGTH('analitica.aplicacion_reporte','fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.aplicacion_reporte.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('analitica.configuracion_reporte_periodico','fecha_registro') IS NOT NULL AND COL_LENGTH('analitica.configuracion_reporte_periodico','fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.configuracion_reporte_periodico.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('analitica.matriz_analisis','fecha_registro') IS NOT NULL AND COL_LENGTH('analitica.matriz_analisis','fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.matriz_analisis.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('analitica.reporte_analitico','fecha_registro') IS NOT NULL AND COL_LENGTH('analitica.reporte_analitico','fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.reporte_analitico.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('analitica.reporte_analitico_caso','fecha_registro') IS NOT NULL AND COL_LENGTH('analitica.reporte_analitico_caso','fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.reporte_analitico_caso.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('analitica.vinculo_entidad','fecha_registro') IS NOT NULL AND COL_LENGTH('analitica.vinculo_entidad','fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.vinculo_entidad.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('casos.carpeta','fecha_registro') IS NOT NULL AND COL_LENGTH('casos.carpeta','fecha_creacion') IS NULL
 EXEC sp_rename N'casos.carpeta.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('casos.caso','fecha_registro') IS NOT NULL AND COL_LENGTH('casos.caso','fecha_creacion') IS NULL
 EXEC sp_rename N'casos.caso.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('casos.caso_persona_rol','fecha_registro') IS NOT NULL AND COL_LENGTH('casos.caso_persona_rol','fecha_creacion') IS NULL
 EXEC sp_rename N'casos.caso_persona_rol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('casos.caso_referencia_judicial','fecha_registro') IS NOT NULL AND COL_LENGTH('casos.caso_referencia_judicial','fecha_creacion') IS NULL
 EXEC sp_rename N'casos.caso_referencia_judicial.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('catalogo_bienes.clase','fecha_registro') IS NOT NULL AND COL_LENGTH('catalogo_bienes.clase','fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.clase.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('catalogo_bienes.familia','fecha_registro') IS NOT NULL AND COL_LENGTH('catalogo_bienes.familia','fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.familia.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('catalogo_bienes.producto','fecha_registro') IS NOT NULL AND COL_LENGTH('catalogo_bienes.producto','fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.producto.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('catalogo_bienes.segmento','fecha_registro') IS NOT NULL AND COL_LENGTH('catalogo_bienes.segmento','fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.segmento.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('configuracion.cat_programa_seguridad','fecha_registro') IS NOT NULL AND COL_LENGTH('configuracion.cat_programa_seguridad','fecha_creacion') IS NULL
 EXEC sp_rename N'configuracion.cat_programa_seguridad.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('cooperacion_int.cat_elemento_cooperacion_internacional','fecha_registro') IS NOT NULL AND COL_LENGTH('cooperacion_int.cat_elemento_cooperacion_internacional','fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.cat_elemento_cooperacion_internacional.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('cooperacion_int.entidad_interpol','fecha_registro') IS NOT NULL AND COL_LENGTH('cooperacion_int.entidad_interpol','fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.entidad_interpol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('cooperacion_int.estado_solicitud_interpol','fecha_registro') IS NOT NULL AND COL_LENGTH('cooperacion_int.estado_solicitud_interpol','fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.estado_solicitud_interpol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('cooperacion_int.motivo_solicitud_interpol','fecha_registro') IS NOT NULL AND COL_LENGTH('cooperacion_int.motivo_solicitud_interpol','fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.motivo_solicitud_interpol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('cooperacion_int.solicitud_interpol','fecha_registro') IS NOT NULL AND COL_LENGTH('cooperacion_int.solicitud_interpol','fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.solicitud_interpol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('cooperacion_int.tipo_consulta_solicitud_interpol','fecha_registro') IS NOT NULL AND COL_LENGTH('cooperacion_int.tipo_consulta_solicitud_interpol','fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.tipo_consulta_solicitud_interpol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('denuncias.denuncia_persona_rol','fecha_registro') IS NOT NULL AND COL_LENGTH('denuncias.denuncia_persona_rol','fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.denuncia_persona_rol.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('denuncias.pauta_vif','fecha_registro') IS NOT NULL AND COL_LENGTH('denuncias.pauta_vif','fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.pauta_vif.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('denuncias.procedimiento_persona','fecha_registro') IS NOT NULL AND COL_LENGTH('denuncias.procedimiento_persona','fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.procedimiento_persona.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('denuncias.procedimiento_policial','fecha_registro') IS NOT NULL AND COL_LENGTH('denuncias.procedimiento_policial','fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.procedimiento_policial.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.actividad_investigativa','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.actividad_investigativa','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.actividad_investigativa.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.detencion','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.detencion','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.detencion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.detencion_lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.detencion_lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.detencion_lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.diligencia','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.diligencia','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.diligencia.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.diligencia_lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.diligencia_lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.diligencia_lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.informe_policial','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.informe_policial','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.informe_policial.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.instruccion_fiscal','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.instruccion_fiscal','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.instruccion_fiscal.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.notificacion_externa','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.notificacion_externa','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.notificacion_externa.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.orden_arresto','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.orden_arresto','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.orden_arresto.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.orden_detencion','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.orden_detencion','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.orden_detencion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('diligencias.peritaje','fecha_registro') IS NOT NULL AND COL_LENGTH('diligencias.peritaje','fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.peritaje.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('encargos.orden_judicial','fecha_registro') IS NOT NULL AND COL_LENGTH('encargos.orden_judicial','fecha_creacion') IS NULL
 EXEC sp_rename N'encargos.orden_judicial.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.arma','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.arma','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.arma.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.cat_catalogo_armas','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.cat_catalogo_armas','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.cat_catalogo_armas.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.cat_droga','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.cat_droga','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.cat_droga.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.especie','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.especie','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.especie.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.especie_lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.especie_lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.especie_lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.especie_retencion','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.especie_retencion','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.especie_retencion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.evidencia','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.evidencia','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.evidencia.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.evidencia_lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.evidencia_lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.evidencia_lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('evidencias.incautacion','fecha_registro') IS NOT NULL AND COL_LENGTH('evidencias.incautacion','fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.incautacion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.cat_movil','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.cat_movil','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.cat_movil.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.delito_imputado_persona','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.delito_imputado_persona','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.delito_imputado_persona.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.protocolo_delito','fecha_registro') IS NOT NULL AND COL_LENGTH('investigacion.protocolo_delito','fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.protocolo_delito.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('migracion.denuncia_administrativa_migratoria','fecha_registro') IS NOT NULL AND COL_LENGTH('migracion.denuncia_administrativa_migratoria','fecha_creacion') IS NULL
 EXEC sp_rename N'migracion.denuncia_administrativa_migratoria.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('migracion.expulsion','fecha_registro') IS NOT NULL AND COL_LENGTH('migracion.expulsion','fecha_creacion') IS NULL
 EXEC sp_rename N'migracion.expulsion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('migracion.fiscalizacion_planificada','fecha_registro') IS NOT NULL AND COL_LENGTH('migracion.fiscalizacion_planificada','fecha_creacion') IS NULL
 EXEC sp_rename N'migracion.fiscalizacion_planificada.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('organizacion.funcionario','fecha_registro') IS NOT NULL AND COL_LENGTH('organizacion.funcionario','fecha_creacion') IS NULL
 EXEC sp_rename N'organizacion.funcionario.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.alias','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.alias','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.alias.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.anotacion','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.anotacion','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.anotacion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.contacto_otro','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.contacto_otro','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.contacto_otro.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.correo','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.correo','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.correo.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.descripcion_fisica','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.descripcion_fisica','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.descripcion_fisica.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.empleo','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.empleo','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.empleo.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.escolaridad','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.escolaridad','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.escolaridad.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.estado_civil','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.estado_civil','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.estado_civil.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.fotografia','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.fotografia','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.fotografia.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.persona','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.persona','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.persona.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.persona_juridica','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.persona_juridica','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.persona_juridica.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.persona_lugar','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.persona_lugar','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.persona_lugar.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.persona_natural','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.persona_natural','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.persona_natural.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.pj_actividad_economica','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.pj_actividad_economica','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.pj_actividad_economica.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.pj_nombre','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.pj_nombre','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.pj_nombre.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.pj_representante_legal','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.pj_representante_legal','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.pj_representante_legal.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.rasgo_distintivo','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.rasgo_distintivo','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.rasgo_distintivo.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.red_social','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.red_social','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.red_social.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.referencia_biometrica','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.referencia_biometrica','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.referencia_biometrica.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.relacion','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.relacion','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.relacion.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('personas.telefono','fecha_registro') IS NOT NULL AND COL_LENGTH('personas.telefono','fecha_creacion') IS NULL
 EXEC sp_rename N'personas.telefono.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('tareas.documento','fecha_registro') IS NOT NULL AND COL_LENGTH('tareas.documento','fecha_creacion') IS NULL
 EXEC sp_rename N'tareas.documento.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('ubicacion.cat_tipo_subdivision','fecha_registro') IS NOT NULL AND COL_LENGTH('ubicacion.cat_tipo_subdivision','fecha_creacion') IS NULL
 EXEC sp_rename N'ubicacion.cat_tipo_subdivision.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('vehiculos.persona_vehiculo','fecha_registro') IS NOT NULL AND COL_LENGTH('vehiculos.persona_vehiculo','fecha_creacion') IS NULL
 EXEC sp_rename N'vehiculos.persona_vehiculo.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('vehiculos.vehiculo','fecha_registro') IS NOT NULL AND COL_LENGTH('vehiculos.vehiculo','fecha_creacion') IS NULL
 EXEC sp_rename N'vehiculos.vehiculo.fecha_registro', N'fecha_creacion', N'COLUMN';
IF COL_LENGTH('investigacion.hecho','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.hecho','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.hecho.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('investigacion.hecho_persona_rol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.hecho_persona_rol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.hecho_persona_rol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('denuncias.relato','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('denuncias.relato','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'denuncias.relato.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.nombre','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.nombre','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.nombre.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.identificacion','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.identificacion','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.identificacion.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('investigacion.delito_imputado','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.delito_imputado','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.delito_imputado.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('ubicacion.lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('ubicacion.lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'ubicacion.lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('investigacion.hecho_lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.hecho_lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.hecho_lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('investigacion.hecho_fenomeno','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.hecho_fenomeno','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.hecho_fenomeno.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('analitica.vinculo_entidad','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('analitica.vinculo_entidad','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'analitica.vinculo_entidad.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('archivos.archivo','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('archivos.archivo','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'archivos.archivo.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('casos.caso','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('casos.caso','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'casos.caso.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('casos.caso_persona_rol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('casos.caso_persona_rol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'casos.caso_persona_rol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('cooperacion_int.cat_elemento_cooperacion_internacional','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('cooperacion_int.cat_elemento_cooperacion_internacional','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'cooperacion_int.cat_elemento_cooperacion_internacional.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('cooperacion_int.entidad_interpol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('cooperacion_int.entidad_interpol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'cooperacion_int.entidad_interpol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('cooperacion_int.estado_solicitud_interpol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('cooperacion_int.estado_solicitud_interpol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'cooperacion_int.estado_solicitud_interpol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('cooperacion_int.motivo_solicitud_interpol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('cooperacion_int.motivo_solicitud_interpol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'cooperacion_int.motivo_solicitud_interpol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('cooperacion_int.solicitud_interpol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('cooperacion_int.solicitud_interpol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'cooperacion_int.solicitud_interpol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('cooperacion_int.tipo_consulta_solicitud_interpol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('cooperacion_int.tipo_consulta_solicitud_interpol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'cooperacion_int.tipo_consulta_solicitud_interpol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('denuncias.denuncia_persona_rol','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('denuncias.denuncia_persona_rol','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'denuncias.denuncia_persona_rol.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('denuncias.procedimiento_policial','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('denuncias.procedimiento_policial','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'denuncias.procedimiento_policial.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.actividad_investigativa','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.actividad_investigativa','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.actividad_investigativa.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.detencion','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.detencion','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.detencion.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.detencion_lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.detencion_lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.detencion_lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.diligencia','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.diligencia','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.diligencia.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.diligencia_lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.diligencia_lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.diligencia_lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.informe_policial','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.informe_policial','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.informe_policial.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.instruccion_fiscal','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.instruccion_fiscal','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.instruccion_fiscal.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.orden_arresto','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.orden_arresto','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.orden_arresto.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.orden_detencion','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.orden_detencion','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.orden_detencion.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('diligencias.peritaje','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('diligencias.peritaje','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'diligencias.peritaje.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('evidencias.especie','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('evidencias.especie','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'evidencias.especie.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('evidencias.especie_lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('evidencias.especie_lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'evidencias.especie_lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('evidencias.evidencia','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('evidencias.evidencia','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'evidencias.evidencia.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('evidencias.evidencia_lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('evidencias.evidencia_lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'evidencias.evidencia_lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('investigacion.delito_imputado_persona','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.delito_imputado_persona','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.delito_imputado_persona.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('investigacion.protocolo_delito','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('investigacion.protocolo_delito','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'investigacion.protocolo_delito.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('migracion.expulsion','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('migracion.expulsion','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'migracion.expulsion.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('migracion.fiscalizacion_planificada','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('migracion.fiscalizacion_planificada','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'migracion.fiscalizacion_planificada.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('organizacion.funcionario','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('organizacion.funcionario','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'organizacion.funcionario.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.alias','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.alias','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.alias.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.anotacion','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.anotacion','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.anotacion.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.contacto_otro','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.contacto_otro','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.contacto_otro.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.correo','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.correo','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.correo.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.descripcion_fisica','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.descripcion_fisica','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.descripcion_fisica.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.empleo','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.empleo','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.empleo.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.escolaridad','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.escolaridad','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.escolaridad.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.estado_civil','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.estado_civil','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.estado_civil.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.fotografia','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.fotografia','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.fotografia.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.persona','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.persona','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.persona.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.persona_juridica','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.persona_juridica','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.persona_juridica.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.persona_lugar','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.persona_lugar','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.persona_lugar.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.persona_natural','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.persona_natural','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.persona_natural.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.pj_actividad_economica','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.pj_actividad_economica','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.pj_actividad_economica.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.pj_nombre','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.pj_nombre','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.pj_nombre.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.pj_representante_legal','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.pj_representante_legal','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.pj_representante_legal.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.rasgo_distintivo','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.rasgo_distintivo','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.rasgo_distintivo.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.red_social','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.red_social','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.red_social.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.referencia_biometrica','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.referencia_biometrica','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.referencia_biometrica.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.relacion','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.relacion','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.relacion.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('personas.telefono','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('personas.telefono','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'personas.telefono.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('vehiculos.persona_vehiculo','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('vehiculos.persona_vehiculo','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'vehiculos.persona_vehiculo.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';
IF COL_LENGTH('vehiculos.vehiculo','fecha_eliminacion') IS NOT NULL AND COL_LENGTH('vehiculos.vehiculo','fecha_eliminacion_logica') IS NULL
 EXEC sp_rename N'vehiculos.vehiculo.fecha_eliminacion', N'fecha_eliminacion_logica', N'COLUMN';

/* ---------- 3) Renombre de constraints DEFAULT df_*_fecha_registro ---------- */
IF OBJECT_ID('analitica.df_aplicacion_reporte_fecha_registro') IS NOT NULL AND OBJECT_ID('analitica.df_aplicacion_reporte_fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.df_aplicacion_reporte_fecha_registro', N'df_aplicacion_reporte_fecha_creacion';
IF OBJECT_ID('analitica.df_configuracion_reporte_periodico_fecha_registro') IS NOT NULL AND OBJECT_ID('analitica.df_configuracion_reporte_periodico_fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.df_configuracion_reporte_periodico_fecha_registro', N'df_configuracion_reporte_periodico_fecha_creacion';
IF OBJECT_ID('analitica.df_matriz_analisis_fecha_registro') IS NOT NULL AND OBJECT_ID('analitica.df_matriz_analisis_fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.df_matriz_analisis_fecha_registro', N'df_matriz_analisis_fecha_creacion';
IF OBJECT_ID('analitica.df_reporte_analitico_fecha_registro') IS NOT NULL AND OBJECT_ID('analitica.df_reporte_analitico_fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.df_reporte_analitico_fecha_registro', N'df_reporte_analitico_fecha_creacion';
IF OBJECT_ID('analitica.df_reporte_analitico_caso_fecha_registro') IS NOT NULL AND OBJECT_ID('analitica.df_reporte_analitico_caso_fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.df_reporte_analitico_caso_fecha_registro', N'df_reporte_analitico_caso_fecha_creacion';
IF OBJECT_ID('analitica.df_vinculo_entidad_fecha_registro') IS NOT NULL AND OBJECT_ID('analitica.df_vinculo_entidad_fecha_creacion') IS NULL
 EXEC sp_rename N'analitica.df_vinculo_entidad_fecha_registro', N'df_vinculo_entidad_fecha_creacion';
IF OBJECT_ID('casos.df_carpeta_fecha_registro') IS NOT NULL AND OBJECT_ID('casos.df_carpeta_fecha_creacion') IS NULL
 EXEC sp_rename N'casos.df_carpeta_fecha_registro', N'df_carpeta_fecha_creacion';
IF OBJECT_ID('casos.df_caso_fecha_registro') IS NOT NULL AND OBJECT_ID('casos.df_caso_fecha_creacion') IS NULL
 EXEC sp_rename N'casos.df_caso_fecha_registro', N'df_caso_fecha_creacion';
IF OBJECT_ID('casos.df_caso_persona_rol_fecha_registro') IS NOT NULL AND OBJECT_ID('casos.df_caso_persona_rol_fecha_creacion') IS NULL
 EXEC sp_rename N'casos.df_caso_persona_rol_fecha_registro', N'df_caso_persona_rol_fecha_creacion';
IF OBJECT_ID('casos.df_caso_referencia_judicial_fecha_registro') IS NOT NULL AND OBJECT_ID('casos.df_caso_referencia_judicial_fecha_creacion') IS NULL
 EXEC sp_rename N'casos.df_caso_referencia_judicial_fecha_registro', N'df_caso_referencia_judicial_fecha_creacion';
IF OBJECT_ID('catalogo_bienes.df_clase_fecha_registro') IS NOT NULL AND OBJECT_ID('catalogo_bienes.df_clase_fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.df_clase_fecha_registro', N'df_clase_fecha_creacion';
IF OBJECT_ID('catalogo_bienes.df_familia_fecha_registro') IS NOT NULL AND OBJECT_ID('catalogo_bienes.df_familia_fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.df_familia_fecha_registro', N'df_familia_fecha_creacion';
IF OBJECT_ID('catalogo_bienes.df_producto_fecha_registro') IS NOT NULL AND OBJECT_ID('catalogo_bienes.df_producto_fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.df_producto_fecha_registro', N'df_producto_fecha_creacion';
IF OBJECT_ID('catalogo_bienes.df_segmento_fecha_registro') IS NOT NULL AND OBJECT_ID('catalogo_bienes.df_segmento_fecha_creacion') IS NULL
 EXEC sp_rename N'catalogo_bienes.df_segmento_fecha_registro', N'df_segmento_fecha_creacion';
IF OBJECT_ID('configuracion.df_cat_programa_seguridad_fecha_registro') IS NOT NULL AND OBJECT_ID('configuracion.df_cat_programa_seguridad_fecha_creacion') IS NULL
 EXEC sp_rename N'configuracion.df_cat_programa_seguridad_fecha_registro', N'df_cat_programa_seguridad_fecha_creacion';
IF OBJECT_ID('cooperacion_int.df_cat_elemento_cooperacion_internacional_fecha_registro') IS NOT NULL AND OBJECT_ID('cooperacion_int.df_cat_elemento_cooperacion_internacional_fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.df_cat_elemento_cooperacion_internacional_fecha_registro', N'df_cat_elemento_cooperacion_internacional_fecha_creacion';
IF OBJECT_ID('cooperacion_int.df_entidad_interpol_fecha_registro') IS NOT NULL AND OBJECT_ID('cooperacion_int.df_entidad_interpol_fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.df_entidad_interpol_fecha_registro', N'df_entidad_interpol_fecha_creacion';
IF OBJECT_ID('cooperacion_int.df_estado_solicitud_interpol_fecha_registro') IS NOT NULL AND OBJECT_ID('cooperacion_int.df_estado_solicitud_interpol_fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.df_estado_solicitud_interpol_fecha_registro', N'df_estado_solicitud_interpol_fecha_creacion';
IF OBJECT_ID('cooperacion_int.df_motivo_solicitud_interpol_fecha_registro') IS NOT NULL AND OBJECT_ID('cooperacion_int.df_motivo_solicitud_interpol_fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.df_motivo_solicitud_interpol_fecha_registro', N'df_motivo_solicitud_interpol_fecha_creacion';
IF OBJECT_ID('cooperacion_int.df_solicitud_interpol_fecha_registro') IS NOT NULL AND OBJECT_ID('cooperacion_int.df_solicitud_interpol_fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.df_solicitud_interpol_fecha_registro', N'df_solicitud_interpol_fecha_creacion';
IF OBJECT_ID('cooperacion_int.df_tipo_consulta_solicitud_interpol_fecha_registro') IS NOT NULL AND OBJECT_ID('cooperacion_int.df_tipo_consulta_solicitud_interpol_fecha_creacion') IS NULL
 EXEC sp_rename N'cooperacion_int.df_tipo_consulta_solicitud_interpol_fecha_registro', N'df_tipo_consulta_solicitud_interpol_fecha_creacion';
IF OBJECT_ID('denuncias.df_denuncia_fecha_registro') IS NOT NULL AND OBJECT_ID('denuncias.df_denuncia_fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.df_denuncia_fecha_registro', N'df_denuncia_fecha_creacion';
IF OBJECT_ID('denuncias.df_denuncia_persona_rol_fecha_registro') IS NOT NULL AND OBJECT_ID('denuncias.df_denuncia_persona_rol_fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.df_denuncia_persona_rol_fecha_registro', N'df_denuncia_persona_rol_fecha_creacion';
IF OBJECT_ID('denuncias.df_pauta_vif_fecha_registro') IS NOT NULL AND OBJECT_ID('denuncias.df_pauta_vif_fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.df_pauta_vif_fecha_registro', N'df_pauta_vif_fecha_creacion';
IF OBJECT_ID('denuncias.df_procedimiento_persona_fecha_registro') IS NOT NULL AND OBJECT_ID('denuncias.df_procedimiento_persona_fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.df_procedimiento_persona_fecha_registro', N'df_procedimiento_persona_fecha_creacion';
IF OBJECT_ID('denuncias.df_procedimiento_policial_fecha_registro') IS NOT NULL AND OBJECT_ID('denuncias.df_procedimiento_policial_fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.df_procedimiento_policial_fecha_registro', N'df_procedimiento_policial_fecha_creacion';
IF OBJECT_ID('denuncias.df_relato_fecha_registro') IS NOT NULL AND OBJECT_ID('denuncias.df_relato_fecha_creacion') IS NULL
 EXEC sp_rename N'denuncias.df_relato_fecha_registro', N'df_relato_fecha_creacion';
IF OBJECT_ID('diligencias.df_actividad_investigativa_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_actividad_investigativa_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_actividad_investigativa_fecha_registro', N'df_actividad_investigativa_fecha_creacion';
IF OBJECT_ID('diligencias.df_detencion_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_detencion_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_detencion_fecha_registro', N'df_detencion_fecha_creacion';
IF OBJECT_ID('diligencias.df_detencion_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_detencion_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_detencion_lugar_fecha_registro', N'df_detencion_lugar_fecha_creacion';
IF OBJECT_ID('diligencias.df_diligencia_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_diligencia_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_diligencia_fecha_registro', N'df_diligencia_fecha_creacion';
IF OBJECT_ID('diligencias.df_diligencia_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_diligencia_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_diligencia_lugar_fecha_registro', N'df_diligencia_lugar_fecha_creacion';
IF OBJECT_ID('diligencias.df_informe_policial_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_informe_policial_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_informe_policial_fecha_registro', N'df_informe_policial_fecha_creacion';
IF OBJECT_ID('diligencias.df_instruccion_fiscal_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_instruccion_fiscal_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_instruccion_fiscal_fecha_registro', N'df_instruccion_fiscal_fecha_creacion';
IF OBJECT_ID('diligencias.df_notificacion_externa_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_notificacion_externa_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_notificacion_externa_fecha_registro', N'df_notificacion_externa_fecha_creacion';
IF OBJECT_ID('diligencias.df_orden_arresto_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_orden_arresto_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_orden_arresto_fecha_registro', N'df_orden_arresto_fecha_creacion';
IF OBJECT_ID('diligencias.df_orden_detencion_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_orden_detencion_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_orden_detencion_fecha_registro', N'df_orden_detencion_fecha_creacion';
IF OBJECT_ID('diligencias.df_peritaje_fecha_registro') IS NOT NULL AND OBJECT_ID('diligencias.df_peritaje_fecha_creacion') IS NULL
 EXEC sp_rename N'diligencias.df_peritaje_fecha_registro', N'df_peritaje_fecha_creacion';
IF OBJECT_ID('encargos.df_orden_judicial_fecha_registro') IS NOT NULL AND OBJECT_ID('encargos.df_orden_judicial_fecha_creacion') IS NULL
 EXEC sp_rename N'encargos.df_orden_judicial_fecha_registro', N'df_orden_judicial_fecha_creacion';
IF OBJECT_ID('evidencias.df_arma_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_arma_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_arma_fecha_registro', N'df_arma_fecha_creacion';
IF OBJECT_ID('evidencias.df_cat_catalogo_armas_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_cat_catalogo_armas_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_cat_catalogo_armas_fecha_registro', N'df_cat_catalogo_armas_fecha_creacion';
IF OBJECT_ID('evidencias.df_cat_droga_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_cat_droga_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_cat_droga_fecha_registro', N'df_cat_droga_fecha_creacion';
IF OBJECT_ID('evidencias.df_especie_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_especie_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_especie_fecha_registro', N'df_especie_fecha_creacion';
IF OBJECT_ID('evidencias.df_especie_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_especie_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_especie_lugar_fecha_registro', N'df_especie_lugar_fecha_creacion';
IF OBJECT_ID('evidencias.df_especie_retencion_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_especie_retencion_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_especie_retencion_fecha_registro', N'df_especie_retencion_fecha_creacion';
IF OBJECT_ID('evidencias.df_evidencia_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_evidencia_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_evidencia_fecha_registro', N'df_evidencia_fecha_creacion';
IF OBJECT_ID('evidencias.df_evidencia_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_evidencia_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_evidencia_lugar_fecha_registro', N'df_evidencia_lugar_fecha_creacion';
IF OBJECT_ID('evidencias.df_incautacion_fecha_registro') IS NOT NULL AND OBJECT_ID('evidencias.df_incautacion_fecha_creacion') IS NULL
 EXEC sp_rename N'evidencias.df_incautacion_fecha_registro', N'df_incautacion_fecha_creacion';
IF OBJECT_ID('investigacion.df_cat_delito_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_cat_delito_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_cat_delito_fecha_registro', N'df_cat_delito_fecha_creacion';
IF OBJECT_ID('investigacion.df_cat_forma_contacto_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_cat_forma_contacto_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_cat_forma_contacto_fecha_registro', N'df_cat_forma_contacto_fecha_creacion';
IF OBJECT_ID('investigacion.df_cat_movil_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_cat_movil_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_cat_movil_fecha_registro', N'df_cat_movil_fecha_creacion';
IF OBJECT_ID('investigacion.df_cat_punto_acceso_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_cat_punto_acceso_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_cat_punto_acceso_fecha_registro', N'df_cat_punto_acceso_fecha_creacion';
IF OBJECT_ID('investigacion.df_cat_transporte_utilizado_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_cat_transporte_utilizado_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_cat_transporte_utilizado_fecha_registro', N'df_cat_transporte_utilizado_fecha_creacion';
IF OBJECT_ID('investigacion.df_delito_imputado_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_delito_imputado_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_delito_imputado_fecha_registro', N'df_delito_imputado_fecha_creacion';
IF OBJECT_ID('investigacion.df_delito_imputado_persona_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_delito_imputado_persona_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_delito_imputado_persona_fecha_registro', N'df_delito_imputado_persona_fecha_creacion';
IF OBJECT_ID('investigacion.df_fenomeno_delictual_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_fenomeno_delictual_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_fenomeno_delictual_fecha_registro', N'df_fenomeno_delictual_fecha_creacion';
IF OBJECT_ID('investigacion.df_hecho_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_hecho_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_hecho_fecha_registro', N'df_hecho_fecha_creacion';
IF OBJECT_ID('investigacion.df_hecho_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_hecho_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_hecho_lugar_fecha_registro', N'df_hecho_lugar_fecha_creacion';
IF OBJECT_ID('investigacion.df_hecho_persona_rol_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_hecho_persona_rol_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_hecho_persona_rol_fecha_registro', N'df_hecho_persona_rol_fecha_creacion';
IF OBJECT_ID('investigacion.df_protocolo_delito_fecha_registro') IS NOT NULL AND OBJECT_ID('investigacion.df_protocolo_delito_fecha_creacion') IS NULL
 EXEC sp_rename N'investigacion.df_protocolo_delito_fecha_registro', N'df_protocolo_delito_fecha_creacion';
IF OBJECT_ID('migracion.df_denuncia_administrativa_migratoria_fecha_registro') IS NOT NULL AND OBJECT_ID('migracion.df_denuncia_administrativa_migratoria_fecha_creacion') IS NULL
 EXEC sp_rename N'migracion.df_denuncia_administrativa_migratoria_fecha_registro', N'df_denuncia_administrativa_migratoria_fecha_creacion';
IF OBJECT_ID('migracion.df_expulsion_fecha_registro') IS NOT NULL AND OBJECT_ID('migracion.df_expulsion_fecha_creacion') IS NULL
 EXEC sp_rename N'migracion.df_expulsion_fecha_registro', N'df_expulsion_fecha_creacion';
IF OBJECT_ID('migracion.df_fiscalizacion_planificada_fecha_registro') IS NOT NULL AND OBJECT_ID('migracion.df_fiscalizacion_planificada_fecha_creacion') IS NULL
 EXEC sp_rename N'migracion.df_fiscalizacion_planificada_fecha_registro', N'df_fiscalizacion_planificada_fecha_creacion';
IF OBJECT_ID('organizacion.df_cat_organismo_externo_fecha_registro') IS NOT NULL AND OBJECT_ID('organizacion.df_cat_organismo_externo_fecha_creacion') IS NULL
 EXEC sp_rename N'organizacion.df_cat_organismo_externo_fecha_registro', N'df_cat_organismo_externo_fecha_creacion';
IF OBJECT_ID('organizacion.df_funcionario_fecha_registro') IS NOT NULL AND OBJECT_ID('organizacion.df_funcionario_fecha_creacion') IS NULL
 EXEC sp_rename N'organizacion.df_funcionario_fecha_registro', N'df_funcionario_fecha_creacion';
IF OBJECT_ID('organizacion.df_unidad_fecha_registro') IS NOT NULL AND OBJECT_ID('organizacion.df_unidad_fecha_creacion') IS NULL
 EXEC sp_rename N'organizacion.df_unidad_fecha_registro', N'df_unidad_fecha_creacion';
IF OBJECT_ID('personas.df_alias_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_alias_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_alias_fecha_registro', N'df_alias_fecha_creacion';
IF OBJECT_ID('personas.df_anotacion_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_anotacion_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_anotacion_fecha_registro', N'df_anotacion_fecha_creacion';
IF OBJECT_ID('personas.df_contacto_otro_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_contacto_otro_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_contacto_otro_fecha_registro', N'df_contacto_otro_fecha_creacion';
IF OBJECT_ID('personas.df_correo_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_correo_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_correo_fecha_registro', N'df_correo_fecha_creacion';
IF OBJECT_ID('personas.df_descripcion_fisica_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_descripcion_fisica_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_descripcion_fisica_fecha_registro', N'df_descripcion_fisica_fecha_creacion';
IF OBJECT_ID('personas.df_empleo_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_empleo_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_empleo_fecha_registro', N'df_empleo_fecha_creacion';
IF OBJECT_ID('personas.df_escolaridad_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_escolaridad_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_escolaridad_fecha_registro', N'df_escolaridad_fecha_creacion';
IF OBJECT_ID('personas.df_estado_civil_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_estado_civil_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_estado_civil_fecha_registro', N'df_estado_civil_fecha_creacion';
IF OBJECT_ID('personas.df_fotografia_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_fotografia_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_fotografia_fecha_registro', N'df_fotografia_fecha_creacion';
IF OBJECT_ID('personas.df_identificacion_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_identificacion_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_identificacion_fecha_registro', N'df_identificacion_fecha_creacion';
IF OBJECT_ID('personas.df_nombre_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_nombre_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_nombre_fecha_registro', N'df_nombre_fecha_creacion';
IF OBJECT_ID('personas.df_persona_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_persona_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_persona_fecha_registro', N'df_persona_fecha_creacion';
IF OBJECT_ID('personas.df_pj_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_pj_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_pj_fecha_registro', N'df_pj_fecha_creacion';
IF OBJECT_ID('personas.df_persona_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_persona_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_persona_lugar_fecha_registro', N'df_persona_lugar_fecha_creacion';
IF OBJECT_ID('personas.df_pn_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_pn_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_pn_fecha_registro', N'df_pn_fecha_creacion';
IF OBJECT_ID('personas.df_pjae_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_pjae_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_pjae_fecha_registro', N'df_pjae_fecha_creacion';
IF OBJECT_ID('personas.df_pjn_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_pjn_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_pjn_fecha_registro', N'df_pjn_fecha_creacion';
IF OBJECT_ID('personas.df_pjrl_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_pjrl_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_pjrl_fecha_registro', N'df_pjrl_fecha_creacion';
IF OBJECT_ID('personas.df_rasgo_distintivo_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_rasgo_distintivo_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_rasgo_distintivo_fecha_registro', N'df_rasgo_distintivo_fecha_creacion';
IF OBJECT_ID('personas.df_red_social_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_red_social_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_red_social_fecha_registro', N'df_red_social_fecha_creacion';
IF OBJECT_ID('personas.df_referencia_biometrica_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_referencia_biometrica_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_referencia_biometrica_fecha_registro', N'df_referencia_biometrica_fecha_creacion';
IF OBJECT_ID('personas.df_relacion_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_relacion_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_relacion_fecha_registro', N'df_relacion_fecha_creacion';
IF OBJECT_ID('personas.df_telefono_fecha_registro') IS NOT NULL AND OBJECT_ID('personas.df_telefono_fecha_creacion') IS NULL
 EXEC sp_rename N'personas.df_telefono_fecha_registro', N'df_telefono_fecha_creacion';
IF OBJECT_ID('tareas.df_documento_fecha_registro') IS NOT NULL AND OBJECT_ID('tareas.df_documento_fecha_creacion') IS NULL
 EXEC sp_rename N'tareas.df_documento_fecha_registro', N'df_documento_fecha_creacion';
IF OBJECT_ID('ubicacion.df_cat_tipo_subdivision_fecha_registro') IS NOT NULL AND OBJECT_ID('ubicacion.df_cat_tipo_subdivision_fecha_creacion') IS NULL
 EXEC sp_rename N'ubicacion.df_cat_tipo_subdivision_fecha_registro', N'df_cat_tipo_subdivision_fecha_creacion';
IF OBJECT_ID('ubicacion.df_lugar_fecha_registro') IS NOT NULL AND OBJECT_ID('ubicacion.df_lugar_fecha_creacion') IS NULL
 EXEC sp_rename N'ubicacion.df_lugar_fecha_registro', N'df_lugar_fecha_creacion';
IF OBJECT_ID('ubicacion.df_lugar_base_fecha_registro') IS NOT NULL AND OBJECT_ID('ubicacion.df_lugar_base_fecha_creacion') IS NULL
 EXEC sp_rename N'ubicacion.df_lugar_base_fecha_registro', N'df_lugar_base_fecha_creacion';
IF OBJECT_ID('vehiculos.df_persona_vehiculo_fecha_registro') IS NOT NULL AND OBJECT_ID('vehiculos.df_persona_vehiculo_fecha_creacion') IS NULL
 EXEC sp_rename N'vehiculos.df_persona_vehiculo_fecha_registro', N'df_persona_vehiculo_fecha_creacion';
IF OBJECT_ID('vehiculos.df_vehiculo_fecha_registro') IS NOT NULL AND OBJECT_ID('vehiculos.df_vehiculo_fecha_creacion') IS NULL
 EXEC sp_rename N'vehiculos.df_vehiculo_fecha_registro', N'df_vehiculo_fecha_creacion';

/* ---------- 4) Recreacion de los 14 indices con fecha_eliminacion_logica ---------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_denperrol_principal_activo' AND object_id = OBJECT_ID(N'denuncias.denuncia_persona_rol'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_denperrol_principal_activo ON denuncias.denuncia_persona_rol
 (
 id_denuncia ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_hecho_lugar_principal_activo' AND object_id = OBJECT_ID(N'investigacion.hecho_lugar'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_hecho_lugar_principal_activo ON investigacion.hecho_lugar
 (
 id_hecho ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_correo_principal_activo' AND object_id = OBJECT_ID(N'personas.correo'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_correo_principal_activo ON personas.correo
 (
 id_persona ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_foto_principal_activa' AND object_id = OBJECT_ID(N'personas.fotografia'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_foto_principal_activa ON personas.fotografia
 (
 id_persona ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_ident_doc_activo' AND object_id = OBJECT_ID(N'personas.identificacion'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_ident_doc_activo ON personas.identificacion
 (
 id_tipo_documento ASC,
 numero_documento ASC,
 id_pais_emisor ASC
 )
 WHERE (fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_ident_principal_activo' AND object_id = OBJECT_ID(N'personas.identificacion'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_ident_principal_activo ON personas.identificacion
 (
 id_persona ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_persona_lugar_principal_activo' AND object_id = OBJECT_ID(N'personas.persona_lugar'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_persona_lugar_principal_activo ON personas.persona_lugar
 (
 id_persona ASC,
 id_rol_lugar ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_pjae_actividad_activa' AND object_id = OBJECT_ID(N'personas.pj_actividad_economica'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_pjae_actividad_activa ON personas.pj_actividad_economica
 (
 id_persona_juridica ASC,
 id_actividad_economica ASC
 )
 WHERE (fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_pjn_tipo_activo' AND object_id = OBJECT_ID(N'personas.pj_nombre'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_pjn_tipo_activo ON personas.pj_nombre
 (
 id_persona_juridica ASC,
 id_tipo_nombre ASC
 )
 WHERE (fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_pjrl_activo' AND object_id = OBJECT_ID(N'personas.pj_representante_legal'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_pjrl_activo ON personas.pj_representante_legal
 (
 id_persona_juridica ASC,
 id_persona_natural ASC,
 id_tipo_representacion ASC
 )
 WHERE (fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_telefono_principal_activo' AND object_id = OBJECT_ID(N'personas.telefono'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_telefono_principal_activo ON personas.telefono
 (
 id_persona ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_perveh_principal_activo' AND object_id = OBJECT_ID(N'vehiculos.persona_vehiculo'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_perveh_principal_activo ON vehiculos.persona_vehiculo
 (
 id_persona ASC
 )
 WHERE (es_principal=(1) AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_vehiculo_patente' AND object_id = OBJECT_ID(N'vehiculos.vehiculo'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_vehiculo_patente ON vehiculos.vehiculo
 (
 patente ASC
 )
 WHERE (patente IS NOT NULL AND fecha_eliminacion_logica IS NULL)
 END;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ux_vehiculo_vin' AND object_id = OBJECT_ID(N'vehiculos.vehiculo'))
BEGIN
 CREATE UNIQUE NONCLUSTERED INDEX ux_vehiculo_vin ON vehiculos.vehiculo
 (
 vin ASC
 )
 WHERE (vin IS NOT NULL AND fecha_eliminacion_logica IS NULL)
 END;

/* =============================================================================
 FIN V0025 (parte estructural). Los stored procedures y funciones que
 referenciaban fecha_registro / fecha_eliminacion se corrigen en sus
 migraciones repetibles R__*_programmability.sql (fuente de verdad de la
 programabilidad), que Flyway re-aplica tras esta migracion.
 ============================================================================= */

