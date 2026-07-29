# Mapa Visual por Esquema: casos

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: casos

```mermaid
flowchart LR
    N_analitica_foco_caso[analitica.foco_caso]
    N_analitica_reporte_analitico_caso[analitica.reporte_analitico_caso]
    N_archivos_archivo[archivos.archivo]
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
    N_denuncias_denuncia[denuncias.denuncia]
    N_denuncias_denuncia_persona_rol[denuncias.denuncia_persona_rol]
    N_denuncias_pauta_vif[denuncias.pauta_vif]
    N_denuncias_procedimiento_policial[denuncias.procedimiento_policial]
    N_diligencias_detencion[diligencias.detencion]
    N_diligencias_diligencia[diligencias.diligencia]
    N_diligencias_informe_policial[diligencias.informe_policial]
    N_diligencias_instruccion_fiscal[diligencias.instruccion_fiscal]
    N_diligencias_notificacion_externa[diligencias.notificacion_externa]
    N_diligencias_orden_arresto[diligencias.orden_arresto]
    N_diligencias_orden_detencion[diligencias.orden_detencion]
    N_diligencias_peritaje[diligencias.peritaje]
    N_diligencias_solicitud_concurrencia_pericial[diligencias.solicitud_concurrencia_pericial]
    N_evidencias_especie[evidencias.especie]
    N_evidencias_evidencia[evidencias.evidencia]
    N_evidencias_incautacion[evidencias.incautacion]
    N_investigacion_clasificacion_delito[investigacion.clasificacion_delito]
    N_investigacion_delito_imputado[investigacion.delito_imputado]
    N_investigacion_hecho[investigacion.hecho]
    N_investigacion_hecho_persona_rol[investigacion.hecho_persona_rol]
    N_organizacion_cat_cargo_funcion[organizacion.cat_cargo_funcion]
    N_organizacion_funcionario[organizacion.funcionario]
    N_organizacion_unidad[organizacion.unidad]
    N_personas_persona[personas.persona]
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
    N_denuncias_denuncia_persona_rol -->|denuncias.fk_denperrol_rol| N_casos_cat_tipo_rol_persona
    N_denuncias_denuncia -->|denuncias.fk_denuncia_caso| N_casos_caso
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_caso| N_casos_caso
    N_denuncias_pauta_vif -->|denuncias.fk_vif_caso| N_casos_caso
    N_diligencias_detencion -->|diligencias.fk_det_caso| N_casos_caso
    N_diligencias_diligencia -->|diligencias.fk_dil_caso| N_casos_caso
    N_diligencias_informe_policial -->|diligencias.fk_inf_caso| N_casos_caso
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_caso| N_casos_caso
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_caso| N_casos_caso
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_est| N_casos_cat_estado_caso
    N_diligencias_orden_arresto -->|diligencias.fk_oa_caso| N_casos_caso
    N_diligencias_orden_detencion -->|diligencias.fk_od_caso| N_casos_caso
    N_diligencias_peritaje -->|diligencias.fk_per_caso| N_casos_caso
    N_diligencias_solicitud_concurrencia_pericial -->|diligencias.fk_solper_caso| N_casos_caso
    N_evidencias_especie -->|evidencias.fk_esp_caso| N_casos_caso
    N_evidencias_evidencia -->|evidencias.fk_evi_caso| N_casos_caso
    N_evidencias_incautacion -->|evidencias.fk_incaut_caso| N_casos_caso
    N_investigacion_delito_imputado -->|investigacion.fk_delimp_caso| N_casos_caso
    N_investigacion_hecho -->|investigacion.fk_hecho_caso| N_casos_caso
    N_investigacion_hecho_persona_rol -->|investigacion.fk_hecoperrol_rol| N_casos_cat_tipo_rol_persona
```

Tablas incluidas: 44
Relaciones incluidas: 57
