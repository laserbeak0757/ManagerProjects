# Mapa Visual por Esquema: archivos

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: archivos

```mermaid
flowchart LR
    N_analitica_reporte_analitico[analitica.reporte_analitico]
    N_archivos_archivo[archivos.archivo]
    N_archivos_archivo_vinculo[archivos.archivo_vinculo]
    N_archivos_cat_nivel_confidencialidad[archivos.cat_nivel_confidencialidad]
    N_archivos_cat_tipo_archivo[archivos.cat_tipo_archivo]
    N_casos_matriz_riesgo[casos.matriz_riesgo]
    N_denuncias_relato[denuncias.relato]
    N_diligencias_instruccion_fiscal[diligencias.instruccion_fiscal]
    N_diligencias_notificacion_externa[diligencias.notificacion_externa]
    N_organizacion_funcionario[organizacion.funcionario]
    N_personas_fotografia[personas.fotografia]
    N_tareas_tarea_archivo_adjunto[tareas.tarea_archivo_adjunto]
    N_tareas_version_documento[tareas.version_documento]
    N_analitica_reporte_analitico -->|analitica.fk_reporte_archivo| N_archivos_archivo
    N_archivos_archivo -->|archivos.fk_archivo_funcionario| N_organizacion_funcionario
    N_archivos_archivo -->|archivos.fk_archivo_nivel| N_archivos_cat_nivel_confidencialidad
    N_archivos_archivo -->|archivos.fk_archivo_tipo| N_archivos_cat_tipo_archivo
    N_archivos_archivo -->|archivos.fk_archivo_version| N_archivos_archivo
    N_archivos_archivo_vinculo -->|archivos.fk_vinculo_archivo| N_archivos_archivo
    N_casos_matriz_riesgo -->|casos.fk_matriesgo_arch| N_archivos_archivo
    N_denuncias_relato -->|denuncias.fk_relato_archivo| N_archivos_archivo
    N_diligencias_instruccion_fiscal -->|diligencias.fk_instfisc_nivel| N_archivos_cat_nivel_confidencialidad
    N_diligencias_notificacion_externa -->|diligencias.fk_notif_arch| N_archivos_archivo
    N_personas_fotografia -->|personas.fk_foto_archivo| N_archivos_archivo
    N_tareas_tarea_archivo_adjunto -->|tareas.fk_tarea_archivo| N_archivos_archivo
    N_tareas_version_documento -->|tareas.fk_version_archivo_firmado| N_archivos_archivo
    N_tareas_version_documento -->|tareas.fk_version_archivo_visar| N_archivos_archivo
```

Tablas incluidas: 13
Relaciones incluidas: 14
