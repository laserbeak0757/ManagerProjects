# Mapa Visual por Esquema: denuncias

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: denuncias

```mermaid
flowchart LR
    N_archivos_archivo[archivos.archivo]
    N_casos_caso[casos.caso]
    N_casos_cat_tipo_rol_persona[casos.cat_tipo_rol_persona]
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
    N_diligencias_instruccion_fiscal[diligencias.instruccion_fiscal]
    N_encargos_encargo_denuncia[encargos.encargo_denuncia]
    N_investigacion_clasificacion_delito[investigacion.clasificacion_delito]
    N_investigacion_hecho[investigacion.hecho]
    N_organizacion_cat_organismo_externo[organizacion.cat_organismo_externo]
    N_organizacion_funcionario[organizacion.funcionario]
    N_personas_persona[personas.persona]
    N_tareas_tarea_denuncia[tareas.tarea_denuncia]
    N_ubicacion_lugar[ubicacion.lugar]
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
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instruccion_fiscal_denuncia| N_denuncias_denuncia
    N_encargos_encargo_denuncia -->|encargos.fk_encargo_denuncia_denuncia| N_denuncias_denuncia
    N_tareas_tarea_denuncia -->|tareas.fk_tarea_denuncia_den| N_denuncias_denuncia
```

Tablas incluidas: 27
Relaciones incluidas: 36
