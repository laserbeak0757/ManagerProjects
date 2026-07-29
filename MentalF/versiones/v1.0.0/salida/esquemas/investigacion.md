# Mapa Visual por Esquema: investigacion

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: investigacion

```mermaid
flowchart LR
    N_casos_caso[casos.caso]
    N_casos_caso_historial_estado[casos.caso_historial_estado]
    N_casos_cat_tipo_rol_persona[casos.cat_tipo_rol_persona]
    N_denuncias_denuncia_hecho[denuncias.denuncia_hecho]
    N_denuncias_procedimiento_policial[denuncias.procedimiento_policial]
    N_diligencias_diligencia[diligencias.diligencia]
    N_evidencias_evidencia[evidencias.evidencia]
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
    N_organizacion_funcionario[organizacion.funcionario]
    N_personas_persona[personas.persona]
    N_ubicacion_cat_rol_lugar[ubicacion.cat_rol_lugar]
    N_ubicacion_cat_tipo_lugar[ubicacion.cat_tipo_lugar]
    N_ubicacion_lugar[ubicacion.lugar]
    N_casos_caso_historial_estado -->|casos.fk_historial_clasificacion_delito| N_investigacion_clasificacion_delito
    N_denuncias_denuncia_hecho -->|denuncias.fk_denhecho_hecho| N_investigacion_hecho
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_clasificacion_delito| N_investigacion_clasificacion_delito
    N_diligencias_diligencia -->|diligencias.fk_dil_hecho_caso| N_investigacion_hecho
    N_evidencias_evidencia -->|evidencias.fk_evi_hecho_caso| N_investigacion_hecho
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
```

Tablas incluidas: 33
Relaciones incluidas: 35
