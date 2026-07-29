# Mapa Visual por Esquema: diligencias

Version artefacto: 1.0.0
Generado: 2026-07-28 16:48:04
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: diligencias

```mermaid
flowchart LR
    N_archivos_archivo[archivos.archivo]
    N_archivos_cat_nivel_confidencialidad[archivos.cat_nivel_confidencialidad]
    N_casos_caso[casos.caso]
    N_casos_cat_estado_caso[casos.cat_estado_caso]
    N_denuncias_denuncia[denuncias.denuncia]
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
    N_encargos_encargo_persona_diligencia[encargos.encargo_persona_diligencia]
    N_evidencias_cat_institucion[evidencias.cat_institucion]
    N_evidencias_especie[evidencias.especie]
    N_evidencias_evidencia[evidencias.evidencia]
    N_evidencias_incautacion[evidencias.incautacion]
    N_investigacion_hecho[investigacion.hecho]
    N_organizacion_funcionario[organizacion.funcionario]
    N_organizacion_unidad[organizacion.unidad]
    N_personas_persona[personas.persona]
    N_tareas_tarea_diligencia[tareas.tarea_diligencia]
    N_ubicacion_cat_rol_lugar[ubicacion.cat_rol_lugar]
    N_ubicacion_cat_tipo_lugar[ubicacion.cat_tipo_lugar]
    N_ubicacion_lugar[ubicacion.lugar]
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
    N_encargos_encargo_persona_diligencia -->|encargos.fk_encargo_persona_diligencia_diligencia| N_diligencias_diligencia
    N_evidencias_evidencia -->|evidencias.fk_evi_dil| N_diligencias_diligencia
    N_evidencias_evidencia -->|evidencias.fk_evi_dil_caso| N_diligencias_diligencia
    N_evidencias_incautacion -->|evidencias.fk_incaut_diligencia| N_diligencias_diligencia
    N_tareas_tarea_diligencia -->|tareas.fk_tarea_diligencia_dil| N_diligencias_diligencia
```

Tablas incluidas: 41
Relaciones incluidas: 67
