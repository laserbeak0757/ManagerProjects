# Mapa Visual por Dominio: operativo

Version artefacto: 1.0.0
Generado: 2026-07-28 16:39:31
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: casos, denuncias, diligencias, encargos, investigacion, tareas

```mermaid
flowchart LR
    N_analitica_foco_caso[analitica.foco_caso]
    N_analitica_reporte_analitico_caso[analitica.reporte_analitico_caso]
    N_archivos_archivo[archivos.archivo]
    N_archivos_cat_nivel_confidencialidad[archivos.cat_nivel_confidencialidad]
    N_casos_agrupacion_causa[casos.agrupacion_causa]
    N_casos_agrupacion_causa_caso[casos.agrupacion_causa_caso]
    N_casos_asignacion_funcionario[casos.asignacion_funcionario]
    N_casos_carpeta[casos.carpeta]
    N_casos_carpeta_colaborador[casos.carpeta_colaborador]
    N_casos_caso[casos.caso]
    N_casos_caso_historial_estado[casos.caso_historial_estado]
    N_casos_caso_persona_rol[casos.caso_persona_rol]
    N_casos_caso_referencia_judicial[casos.caso_referencia_judicial]
    N_casos_cat_complejidad[casos.cat_complejidad]
    N_casos_cat_estado_caso[casos.cat_estado_caso]
    N_casos_cat_grupo_operativo[casos.cat_grupo_operativo]
    N_casos_cat_nivel_seguridad[casos.cat_nivel_seguridad]
    N_casos_cat_origen_caso[casos.cat_origen_caso]
    N_casos_cat_prioridad[casos.cat_prioridad]
    N_casos_cat_tipo_rol_persona[casos.cat_tipo_rol_persona]
    N_casos_matriz_riesgo[casos.matriz_riesgo]
    N_configuracion_cat_programa_seguridad[configuracion.cat_programa_seguridad]
    N_denuncias_cat_detalle_lugar_recepcion_denuncia[denuncias.cat_detalle_lugar_recepcion_denuncia]
    N_denuncias_cat_estado_denuncia[denuncias.cat_estado_denuncia]
    N_denuncias_cat_estado_envio_fiscalia[denuncias.cat_estado_envio_fiscalia]
    N_denuncias_cat_lugar_recepcion_denuncia[denuncias.cat_lugar_recepcion_denuncia]
    N_denuncias_cat_tipo_denuncia[denuncias.cat_tipo_denuncia]
    N_denuncias_cat_tipo_relato[denuncias.cat_tipo_relato]
    N_denuncias_denuncia[denuncias.denuncia]
    N_denuncias_denuncia_hecho[denuncias.denuncia_hecho]
    N_denuncias_denuncia_persona_rol[denuncias.denuncia_persona_rol]
    N_denuncias_log_guardar_denuncia[denuncias.log_guardar_denuncia]
    N_denuncias_pauta_vif[denuncias.pauta_vif]
    N_denuncias_procedimiento_persona[denuncias.procedimiento_persona]
    N_denuncias_procedimiento_policial[denuncias.procedimiento_policial]
    N_denuncias_relato[denuncias.relato]
    N_diligencias_actividad_investigativa[diligencias.actividad_investigativa]
    N_diligencias_cat_especialidad_pericial[diligencias.cat_especialidad_pericial]
    N_diligencias_cat_estado_diligencia[diligencias.cat_estado_diligencia]
    N_diligencias_cat_estado_instruccion[diligencias.cat_estado_instruccion]
    N_diligencias_cat_fuente_observacion_externa[diligencias.cat_fuente_observacion_externa]
    N_diligencias_cat_tipo_detencion[diligencias.cat_tipo_detencion]
    N_diligencias_cat_tipo_diligencia[diligencias.cat_tipo_diligencia]
    N_diligencias_cat_tipo_informe[diligencias.cat_tipo_informe]
    N_diligencias_cat_tipo_instruccion[diligencias.cat_tipo_instruccion]
    N_diligencias_cat_tipo_notificacion_externa[diligencias.cat_tipo_notificacion_externa]
    N_diligencias_cat_tipo_peritaje[diligencias.cat_tipo_peritaje]
    N_diligencias_detencion[diligencias.detencion]
    N_diligencias_detencion_lugar[diligencias.detencion_lugar]
    N_diligencias_diligencia[diligencias.diligencia]
    N_diligencias_diligencia_lugar[diligencias.diligencia_lugar]
    N_diligencias_informe_policial[diligencias.informe_policial]
    N_diligencias_instruccion_fiscal[diligencias.instruccion_fiscal]
    N_diligencias_notificacion_externa[diligencias.notificacion_externa]
    N_diligencias_orden_arresto[diligencias.orden_arresto]
    N_diligencias_orden_detencion[diligencias.orden_detencion]
    N_diligencias_peritaje[diligencias.peritaje]
    N_diligencias_solicitud_concurrencia_pericial[diligencias.solicitud_concurrencia_pericial]
    N_diligencias_solicitud_concurrencia_perito[diligencias.solicitud_concurrencia_perito]
    N_encargos_encargo[encargos.encargo]
    N_encargos_encargo_denuncia[encargos.encargo_denuncia]
    N_encargos_encargo_orden_judicial[encargos.encargo_orden_judicial]
    N_encargos_encargo_persona_diligencia[encargos.encargo_persona_diligencia]
    N_encargos_orden_judicial[encargos.orden_judicial]
    N_encargos_tarea_encargo[encargos.tarea_encargo]
    N_encargos_tipo_encargo[encargos.tipo_encargo]
    N_encargos_tipo_orden_judicial[encargos.tipo_orden_judicial]
    N_evidencias_cat_institucion[evidencias.cat_institucion]
    N_evidencias_especie[evidencias.especie]
    N_evidencias_evidencia[evidencias.evidencia]
    N_evidencias_incautacion[evidencias.incautacion]
    N_investigacion_cat_circunstancia_modificatoria[investigacion.cat_circunstancia_modificatoria]
    N_investigacion_cat_delito[investigacion.cat_delito]
    N_investigacion_cat_familia_delito[investigacion.cat_familia_delito]
    N_investigacion_cat_forma_contacto[investigacion.cat_forma_contacto]
    N_investigacion_cat_grado_ejecucion[investigacion.cat_grado_ejecucion]
    N_investigacion_cat_grado_participacion[investigacion.cat_grado_participacion]
    N_investigacion_cat_movil[investigacion.cat_movil]
    N_investigacion_cat_punto_acceso[investigacion.cat_punto_acceso]
    N_investigacion_cat_seccion_catalogo[investigacion.cat_seccion_catalogo]
    N_investigacion_cat_transporte_utilizado[investigacion.cat_transporte_utilizado]
    N_investigacion_clasificacion_delito[investigacion.clasificacion_delito]
    N_investigacion_delito_circunstancia[investigacion.delito_circunstancia]
    N_investigacion_delito_imputado[investigacion.delito_imputado]
    N_investigacion_delito_imputado_persona[investigacion.delito_imputado_persona]
    N_investigacion_fenomeno_delictual[investigacion.fenomeno_delictual]
    N_investigacion_hecho[investigacion.hecho]
    N_investigacion_hecho_fenomeno[investigacion.hecho_fenomeno]
    N_investigacion_hecho_lugar[investigacion.hecho_lugar]
    N_investigacion_hecho_persona_rol[investigacion.hecho_persona_rol]
    N_investigacion_protocolo_delito[investigacion.protocolo_delito]
    N_investigacion_subtipo_delito_secuestro[investigacion.subtipo_delito_secuestro]
    N_organizacion_cat_cargo_funcion[organizacion.cat_cargo_funcion]
    N_organizacion_cat_organismo_externo[organizacion.cat_organismo_externo]
    N_organizacion_funcionario[organizacion.funcionario]
    N_organizacion_unidad[organizacion.unidad]
    N_personas_persona[personas.persona]
    N_tareas_bandeja[tareas.bandeja]
    N_tareas_documento[tareas.documento]
    N_tareas_estado_tarea[tareas.estado_tarea]
    N_tareas_tarea[tareas.tarea]
    N_tareas_tarea_archivo_adjunto[tareas.tarea_archivo_adjunto]
    N_tareas_tarea_denuncia[tareas.tarea_denuncia]
    N_tareas_tarea_diligencia[tareas.tarea_diligencia]
    N_tareas_tarea_documento[tareas.tarea_documento]
    N_tareas_tipo_documento[tareas.tipo_documento]
    N_tareas_tipo_estado_tarea[tareas.tipo_estado_tarea]
    N_tareas_tipo_tarea[tareas.tipo_tarea]
    N_tareas_tipo_tarea_tipo_documento[tareas.tipo_tarea_tipo_documento]
    N_tareas_version_documento[tareas.version_documento]
    N_ubicacion_cat_rol_lugar[ubicacion.cat_rol_lugar]
    N_ubicacion_cat_tipo_lugar[ubicacion.cat_tipo_lugar]
    N_ubicacion_lugar[ubicacion.lugar]
    N_analitica_foco_caso -->|analitica.fk_fococaso_caso| N_casos_caso
    N_analitica_reporte_analitico_caso -->|analitica.fk_reptcaso_caso| N_casos_caso
    N_casos_agrupacion_causa_caso -->|casos.fk_agrcasocaso_agrupacion| N_casos_agrupacion_causa
    N_casos_agrupacion_causa_caso -->|casos.fk_agrcasocaso_caso| N_casos_caso
    N_casos_agrupacion_causa_caso -->|casos.fk_agrcasocaso_func| N_organizacion_funcionario
    N_casos_agrupacion_causa -->|casos.fk_agrcausa_aprueba| N_organizacion_funcionario
    N_casos_agrupacion_causa -->|casos.fk_agrcausa_caso| N_casos_caso
    N_casos_agrupacion_causa -->|casos.fk_agrcausa_solicita| N_organizacion_funcionario
    N_casos_asignacion_funcionario -->|casos.fk_asignfunc_cargo| N_organizacion_cat_cargo_funcion
    N_casos_asignacion_funcionario -->|casos.fk_asignfunc_caso| N_casos_caso
    N_casos_asignacion_funcionario -->|casos.fk_asignfunc_func| N_organizacion_funcionario
    N_casos_carpeta -->|casos.fk_carpeta_funcionario| N_organizacion_funcionario
    N_casos_carpeta -->|casos.fk_carpeta_unidad| N_organizacion_unidad
    N_casos_caso -->|casos.fk_caso_carpeta| N_casos_carpeta
    N_casos_caso -->|casos.fk_caso_complejidad| N_casos_cat_complejidad
    N_casos_caso -->|casos.fk_caso_estado| N_casos_cat_estado_caso
    N_casos_caso -->|casos.fk_caso_grupo_operativo| N_casos_cat_grupo_operativo
    N_casos_caso -->|casos.fk_caso_nivel_seguridad| N_casos_cat_nivel_seguridad
    N_casos_caso -->|casos.fk_caso_origen| N_casos_cat_origen_caso
    N_casos_caso_persona_rol -->|casos.fk_caso_persona_rol_defensor| N_organizacion_funcionario
    N_casos_caso -->|casos.fk_caso_prioridad| N_casos_cat_prioridad
    N_casos_caso_persona_rol -->|casos.fk_casoperrol_caso| N_casos_caso
    N_casos_caso_persona_rol -->|casos.fk_casoperrol_persona| N_personas_persona
    N_casos_caso_persona_rol -->|casos.fk_casoperrol_rol| N_casos_cat_tipo_rol_persona
    N_casos_carpeta_colaborador -->|casos.fk_colabcarp_carpeta| N_casos_carpeta
    N_casos_carpeta_colaborador -->|casos.fk_colabcarp_func| N_organizacion_funcionario
    N_casos_carpeta_colaborador -->|casos.fk_colabcarp_invitador| N_organizacion_funcionario
    N_casos_caso_historial_estado -->|casos.fk_histcaso_caso| N_casos_caso
    N_casos_caso_historial_estado -->|casos.fk_histcaso_est_ant| N_casos_cat_estado_caso
    N_casos_caso_historial_estado -->|casos.fk_histcaso_est_nuevo| N_casos_cat_estado_caso
    N_casos_caso_historial_estado -->|casos.fk_histcaso_func| N_organizacion_funcionario
    N_casos_caso_historial_estado -->|casos.fk_historial_clasificacion_delito| N_investigacion_clasificacion_delito
    N_casos_matriz_riesgo -->|casos.fk_matriesgo_aprueba| N_organizacion_funcionario
    N_casos_matriz_riesgo -->|casos.fk_matriesgo_arch| N_archivos_archivo
    N_casos_matriz_riesgo -->|casos.fk_matriesgo_caso| N_casos_caso
    N_casos_matriz_riesgo -->|casos.fk_matriesgo_elabora| N_organizacion_funcionario
    N_casos_caso_referencia_judicial -->|casos.fk_refjud_caso| N_casos_caso
    N_denuncias_cat_detalle_lugar_recepcion_denuncia -->|denuncias.fk_cat_detalle_lugar_recepcion_lugar| N_denuncias_cat_lugar_recepcion_denuncia
    N_denuncias_denuncia_hecho -->|denuncias.fk_denhecho_denuncia| N_denuncias_denuncia
    N_denuncias_denuncia_hecho -->|denuncias.fk_denhecho_hecho| N_investigacion_hecho
    N_denuncias_denuncia_persona_rol -->|denuncias.fk_denperrol_denuncia| N_denuncias_denuncia
    N_denuncias_denuncia_persona_rol -->|denuncias.fk_denperrol_persona| N_personas_persona
    N_denuncias_denuncia_persona_rol -->|denuncias.fk_denperrol_rol| N_casos_cat_tipo_rol_persona
    N_denuncias_denuncia -->|denuncias.fk_denuncia_caso| N_casos_caso
    N_denuncias_denuncia -->|denuncias.fk_denuncia_detalle_lugar_recepcion| N_denuncias_cat_detalle_lugar_recepcion_denuncia
    N_denuncias_denuncia -->|denuncias.fk_denuncia_estado_denuncia| N_denuncias_cat_estado_denuncia
    N_denuncias_denuncia -->|denuncias.fk_denuncia_estado_envio_fiscalia| N_denuncias_cat_estado_envio_fiscalia
    N_denuncias_denuncia -->|denuncias.fk_denuncia_func| N_organizacion_funcionario
    N_denuncias_denuncia -->|denuncias.fk_denuncia_organismo_externo| N_organizacion_cat_organismo_externo
    N_denuncias_denuncia -->|denuncias.fk_denuncia_organismo_fiscalia| N_organizacion_cat_organismo_externo
    N_denuncias_denuncia -->|denuncias.fk_denuncia_tipo| N_denuncias_cat_tipo_denuncia
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_caso| N_casos_caso
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_clasificacion_delito| N_investigacion_clasificacion_delito
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_func| N_organizacion_funcionario
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_lugar| N_ubicacion_lugar
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_programa| N_configuracion_cat_programa_seguridad
    N_denuncias_procedimiento_persona -->|denuncias.fk_procpers_func| N_organizacion_funcionario
    N_denuncias_procedimiento_persona -->|denuncias.fk_procpers_persona| N_personas_persona
    N_denuncias_procedimiento_persona -->|denuncias.fk_procpers_proc| N_denuncias_procedimiento_policial
    N_denuncias_relato -->|denuncias.fk_relato_anterior| N_denuncias_relato
    N_denuncias_relato -->|denuncias.fk_relato_archivo| N_archivos_archivo
    N_denuncias_relato -->|denuncias.fk_relato_declarante| N_personas_persona
    N_denuncias_relato -->|denuncias.fk_relato_denuncia| N_denuncias_denuncia
    N_denuncias_relato -->|denuncias.fk_relato_func| N_organizacion_funcionario
    N_denuncias_relato -->|denuncias.fk_relato_tipo| N_denuncias_cat_tipo_relato
    N_denuncias_pauta_vif -->|denuncias.fk_vif_caso| N_casos_caso
    N_denuncias_pauta_vif -->|denuncias.fk_vif_denuncia| N_denuncias_denuncia
    N_denuncias_pauta_vif -->|denuncias.fk_vif_func| N_organizacion_funcionario
    N_denuncias_pauta_vif -->|denuncias.fk_vif_imputado| N_personas_persona
    N_denuncias_pauta_vif -->|denuncias.fk_vif_victima| N_personas_persona
    N_diligencias_actividad_investigativa -->|diligencias.fk_act_diligencia| N_diligencias_diligencia
    N_diligencias_actividad_investigativa -->|diligencias.fk_act_funcionario| N_organizacion_funcionario
    N_diligencias_detencion -->|diligencias.fk_det_caso| N_casos_caso
    N_diligencias_detencion -->|diligencias.fk_det_dil_caso| N_diligencias_diligencia
    N_diligencias_detencion -->|diligencias.fk_det_func| N_organizacion_funcionario
    N_diligencias_detencion -->|diligencias.fk_det_lugar| N_ubicacion_lugar
    N_diligencias_detencion -->|diligencias.fk_det_persona| N_personas_persona
    N_diligencias_detencion -->|diligencias.fk_det_tipo| N_diligencias_cat_tipo_detencion
    N_diligencias_detencion -->|diligencias.fk_det_unidad| N_organizacion_unidad
    N_diligencias_detencion_lugar -->|diligencias.fk_detlug_det| N_diligencias_detencion
    N_diligencias_detencion_lugar -->|diligencias.fk_detlug_lug| N_ubicacion_lugar
    N_diligencias_detencion_lugar -->|diligencias.fk_detlug_rol| N_ubicacion_cat_rol_lugar
    N_diligencias_detencion_lugar -->|diligencias.fk_detlug_tipo| N_ubicacion_cat_tipo_lugar
    N_diligencias_diligencia -->|diligencias.fk_dil_caso| N_casos_caso
    N_diligencias_diligencia -->|diligencias.fk_dil_est| N_diligencias_cat_estado_diligencia
    N_diligencias_diligencia -->|diligencias.fk_dil_func| N_organizacion_funcionario
    N_diligencias_diligencia -->|diligencias.fk_dil_hecho_caso| N_investigacion_hecho
    N_diligencias_diligencia -->|diligencias.fk_dil_inst_caso| N_diligencias_instruccion_fiscal
    N_diligencias_diligencia -->|diligencias.fk_dil_lugar| N_ubicacion_lugar
    N_diligencias_diligencia -->|diligencias.fk_dil_tipo| N_diligencias_cat_tipo_diligencia
    N_diligencias_diligencia_lugar -->|diligencias.fk_dillug_dil| N_diligencias_diligencia
    N_diligencias_diligencia_lugar -->|diligencias.fk_dillug_lug| N_ubicacion_lugar
    N_diligencias_diligencia_lugar -->|diligencias.fk_dillug_rol| N_ubicacion_cat_rol_lugar
    N_diligencias_diligencia_lugar -->|diligencias.fk_dillug_tipo| N_ubicacion_cat_tipo_lugar
    N_diligencias_informe_policial -->|diligencias.fk_inf_caso| N_casos_caso
    N_diligencias_informe_policial -->|diligencias.fk_inf_dil_caso| N_diligencias_diligencia
    N_diligencias_informe_policial -->|diligencias.fk_inf_func| N_organizacion_funcionario
    N_diligencias_informe_policial -->|diligencias.fk_inf_tipo| N_diligencias_cat_tipo_informe
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_caso| N_casos_caso
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_est| N_diligencias_cat_estado_instruccion
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_nivel| N_archivos_cat_nivel_confidencialidad
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_tipo| N_diligencias_cat_tipo_instruccion
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_unid| N_organizacion_unidad
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instruccion_fiscal_denuncia| N_denuncias_denuncia
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_arch| N_archivos_archivo
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_caso| N_casos_caso
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_est| N_casos_cat_estado_caso
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_fuente| N_diligencias_cat_fuente_observacion_externa
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_func| N_organizacion_funcionario
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_tipo| N_diligencias_cat_tipo_notificacion_externa
    N_diligencias_orden_arresto -->|diligencias.fk_oa_caso| N_casos_caso
    N_diligencias_orden_arresto -->|diligencias.fk_oa_func| N_organizacion_funcionario
    N_diligencias_orden_arresto -->|diligencias.fk_oa_persona| N_personas_persona
    N_diligencias_orden_detencion -->|diligencias.fk_od_caso| N_casos_caso
    N_diligencias_orden_detencion -->|diligencias.fk_od_func| N_organizacion_funcionario
    N_diligencias_orden_detencion -->|diligencias.fk_od_persona| N_personas_persona
    N_diligencias_peritaje -->|diligencias.fk_per_caso| N_casos_caso
    N_diligencias_peritaje -->|diligencias.fk_per_dil_caso| N_diligencias_diligencia
    N_diligencias_peritaje -->|diligencias.fk_per_esp_caso| N_evidencias_especie
    N_diligencias_peritaje -->|diligencias.fk_per_est| N_diligencias_cat_estado_diligencia
    N_diligencias_peritaje -->|diligencias.fk_per_func| N_organizacion_funcionario
    N_diligencias_peritaje -->|diligencias.fk_per_inst| N_evidencias_cat_institucion
    N_diligencias_peritaje -->|diligencias.fk_per_tipo| N_diligencias_cat_tipo_peritaje
    N_diligencias_peritaje -->|diligencias.fk_peritaje_instruccion_fiscal| N_diligencias_instruccion_fiscal
    N_diligencias_peritaje -->|diligencias.fk_peritaje_solicitud_concurrencia| N_diligencias_solicitud_concurrencia_pericial
    N_diligencias_solicitud_concurrencia_pericial -->|diligencias.fk_solper_caso| N_casos_caso
    N_diligencias_solicitud_concurrencia_pericial -->|diligencias.fk_solper_func| N_organizacion_funcionario
    N_diligencias_solicitud_concurrencia_pericial -->|diligencias.fk_solper_instruccion| N_diligencias_instruccion_fiscal
    N_diligencias_solicitud_concurrencia_pericial -->|diligencias.fk_solper_lugar| N_ubicacion_lugar
    N_diligencias_solicitud_concurrencia_perito -->|diligencias.fk_solperito_esp| N_diligencias_cat_especialidad_pericial
    N_diligencias_solicitud_concurrencia_perito -->|diligencias.fk_solperito_func| N_organizacion_funcionario
    N_diligencias_solicitud_concurrencia_perito -->|diligencias.fk_solperito_solicitud| N_diligencias_solicitud_concurrencia_pericial
    N_encargos_encargo_denuncia -->|encargos.fk_encargo_denuncia_denuncia| N_denuncias_denuncia
    N_encargos_encargo_denuncia -->|encargos.fk_encargo_denuncia_encargo| N_encargos_encargo
    N_encargos_encargo_denuncia -->|encargos.fk_encargo_denuncia_persona| N_personas_persona
    N_encargos_encargo_orden_judicial -->|encargos.fk_encargo_orden_judicial_encargo| N_encargos_encargo
    N_encargos_encargo_orden_judicial -->|encargos.fk_encargo_orden_judicial_oj| N_encargos_orden_judicial
    N_encargos_encargo_persona_diligencia -->|encargos.fk_encargo_persona_diligencia_diligencia| N_diligencias_diligencia
    N_encargos_encargo_persona_diligencia -->|encargos.fk_encargo_persona_diligencia_encargo| N_encargos_encargo
    N_encargos_encargo_persona_diligencia -->|encargos.fk_encargo_persona_diligencia_persona| N_personas_persona
    N_encargos_encargo -->|encargos.fk_encargo_tipo| N_encargos_tipo_encargo
    N_encargos_orden_judicial -->|encargos.fk_orden_judicial_persona| N_personas_persona
    N_encargos_orden_judicial -->|encargos.fk_orden_judicial_tipo| N_encargos_tipo_orden_judicial
    N_encargos_tarea_encargo -->|encargos.fk_tarea_encargo_encargo| N_encargos_encargo
    N_encargos_tarea_encargo -->|encargos.fk_tarea_encargo_tarea| N_tareas_tarea
    N_evidencias_especie -->|evidencias.fk_esp_caso| N_casos_caso
    N_evidencias_evidencia -->|evidencias.fk_evi_caso| N_casos_caso
    N_evidencias_evidencia -->|evidencias.fk_evi_dil| N_diligencias_diligencia
    N_evidencias_evidencia -->|evidencias.fk_evi_dil_caso| N_diligencias_diligencia
    N_evidencias_evidencia -->|evidencias.fk_evi_hecho_caso| N_investigacion_hecho
    N_evidencias_incautacion -->|evidencias.fk_incaut_caso| N_casos_caso
    N_evidencias_incautacion -->|evidencias.fk_incaut_diligencia| N_diligencias_diligencia
    N_investigacion_clasificacion_delito -->|investigacion.fk_clasdel_delito| N_investigacion_cat_delito
    N_investigacion_clasificacion_delito -->|investigacion.fk_clasdel_familia| N_investigacion_cat_familia_delito
    N_investigacion_clasificacion_delito -->|investigacion.fk_clasdel_seccion| N_investigacion_cat_seccion_catalogo
    N_investigacion_delito_circunstancia -->|investigacion.fk_delcirc_circ| N_investigacion_cat_circunstancia_modificatoria
    N_investigacion_delito_circunstancia -->|investigacion.fk_delcirc_delito| N_investigacion_delito_imputado
    N_investigacion_delito_imputado -->|investigacion.fk_delimp_caso| N_casos_caso
    N_investigacion_delito_imputado -->|investigacion.fk_delimp_clasificacion| N_investigacion_clasificacion_delito
    N_investigacion_delito_imputado -->|investigacion.fk_delimp_grado| N_investigacion_cat_grado_ejecucion
    N_investigacion_delito_imputado -->|investigacion.fk_delimp_hecho_caso| N_investigacion_hecho
    N_investigacion_delito_imputado -->|investigacion.fk_delimp_movil| N_investigacion_cat_movil
    N_investigacion_delito_imputado_persona -->|investigacion.fk_delper_delito| N_investigacion_delito_imputado
    N_investigacion_delito_imputado_persona -->|investigacion.fk_delper_grado| N_investigacion_cat_grado_participacion
    N_investigacion_delito_imputado_persona -->|investigacion.fk_delper_persona| N_personas_persona
    N_investigacion_hecho -->|investigacion.fk_hecho_caso| N_casos_caso
    N_investigacion_hecho_fenomeno -->|investigacion.fk_hecho_fenomeno_fenomeno| N_investigacion_fenomeno_delictual
    N_investigacion_hecho_fenomeno -->|investigacion.fk_hecho_fenomeno_funcionario| N_organizacion_funcionario
    N_investigacion_hecho_fenomeno -->|investigacion.fk_hecho_fenomeno_hecho| N_investigacion_hecho
    N_investigacion_hecho -->|investigacion.fk_hecho_forma_contacto| N_investigacion_cat_forma_contacto
    N_investigacion_hecho -->|investigacion.fk_hecho_punto_acceso| N_investigacion_cat_punto_acceso
    N_investigacion_hecho -->|investigacion.fk_hecho_transporte| N_investigacion_cat_transporte_utilizado
    N_investigacion_hecho_lugar -->|investigacion.fk_hecholug_hecho| N_investigacion_hecho
    N_investigacion_hecho_lugar -->|investigacion.fk_hecholug_lugar| N_ubicacion_lugar
    N_investigacion_hecho_lugar -->|investigacion.fk_hecholug_rol| N_ubicacion_cat_rol_lugar
    N_investigacion_hecho_lugar -->|investigacion.fk_hecholug_tipo| N_ubicacion_cat_tipo_lugar
    N_investigacion_hecho_persona_rol -->|investigacion.fk_hecoperrol_hecho| N_investigacion_hecho
    N_investigacion_hecho_persona_rol -->|investigacion.fk_hecoperrol_persona| N_personas_persona
    N_investigacion_hecho_persona_rol -->|investigacion.fk_hecoperrol_rol| N_casos_cat_tipo_rol_persona
    N_investigacion_protocolo_delito -->|investigacion.fk_prot_clasificacion| N_investigacion_clasificacion_delito
    N_investigacion_subtipo_delito_secuestro -->|investigacion.fk_subsec_delito| N_investigacion_delito_imputado
    N_investigacion_subtipo_delito_secuestro -->|investigacion.fk_subsec_func| N_organizacion_funcionario
    N_tareas_bandeja -->|tareas.fk_bandeja_funcionario| N_organizacion_funcionario
    N_tareas_bandeja -->|tareas.fk_bandeja_unidad| N_organizacion_unidad
    N_tareas_documento -->|tareas.fk_documento_funcionario_anu| N_organizacion_funcionario
    N_tareas_documento -->|tareas.fk_documento_funcionario_reg| N_organizacion_funcionario
    N_tareas_documento -->|tareas.fk_documento_tipo| N_tareas_tipo_documento
    N_tareas_estado_tarea -->|tareas.fk_estado_funcionario| N_organizacion_funcionario
    N_tareas_estado_tarea -->|tareas.fk_estado_tarea_bandeja| N_tareas_bandeja
    N_tareas_estado_tarea -->|tareas.fk_estado_tarea_bandeja_aprob| N_tareas_bandeja
    N_tareas_estado_tarea -->|tareas.fk_estado_tarea_tarea| N_tareas_tarea
    N_tareas_estado_tarea -->|tareas.fk_estado_tarea_tipo| N_tareas_tipo_estado_tarea
    N_tareas_tarea_archivo_adjunto -->|tareas.fk_tarea_archivo| N_archivos_archivo
    N_tareas_tarea_archivo_adjunto -->|tareas.fk_tarea_archivo_estado| N_tareas_estado_tarea
    N_tareas_tarea_denuncia -->|tareas.fk_tarea_denuncia_den| N_denuncias_denuncia
    N_tareas_tarea_denuncia -->|tareas.fk_tarea_denuncia_tarea| N_tareas_tarea
    N_tareas_tarea -->|tareas.fk_tarea_dependiente| N_tareas_tarea
    N_tareas_tarea_diligencia -->|tareas.fk_tarea_diligencia_dil| N_diligencias_diligencia
    N_tareas_tarea_diligencia -->|tareas.fk_tarea_diligencia_tarea| N_tareas_tarea
    N_tareas_tarea_documento -->|tareas.fk_tarea_documento_doc| N_tareas_documento
    N_tareas_tarea_documento -->|tareas.fk_tarea_documento_estado| N_tareas_estado_tarea
    N_tareas_tarea -->|tareas.fk_tarea_estado_actual| N_tareas_estado_tarea
    N_tareas_tarea -->|tareas.fk_tarea_tipo| N_tareas_tipo_tarea
    N_tareas_tipo_tarea_tipo_documento -->|tareas.fk_tttd_doc| N_tareas_tipo_documento
    N_tareas_tipo_tarea_tipo_documento -->|tareas.fk_tttd_tarea| N_tareas_tipo_tarea
    N_tareas_version_documento -->|tareas.fk_version_archivo_firmado| N_archivos_archivo
    N_tareas_version_documento -->|tareas.fk_version_archivo_visar| N_archivos_archivo
    N_tareas_version_documento -->|tareas.fk_version_documento_doc| N_tareas_documento
    N_tareas_version_documento -->|tareas.fk_version_funcionario| N_organizacion_funcionario
    N_tareas_version_documento -->|tareas.fk_version_funcionario_visa| N_organizacion_funcionario
```

Tablas incluidas: 113
Relaciones incluidas: 210
