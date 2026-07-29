# Mapa Visual por Esquema: tareas

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: tareas

```mermaid
flowchart LR
    N_archivos_archivo[archivos.archivo]
    N_denuncias_denuncia[denuncias.denuncia]
    N_diligencias_diligencia[diligencias.diligencia]
    N_encargos_tarea_encargo[encargos.tarea_encargo]
    N_organizacion_funcionario[organizacion.funcionario]
    N_organizacion_unidad[organizacion.unidad]
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
    N_encargos_tarea_encargo -->|encargos.fk_tarea_encargo_tarea| N_tareas_tarea
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

Tablas incluidas: 19
Relaciones incluidas: 29
