# Mapa Visual por Esquema: analitica

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: analitica

```mermaid
flowchart LR
    N_analitica_aplicacion_reporte[analitica.aplicacion_reporte]
    N_analitica_cat_tipo_reporte[analitica.cat_tipo_reporte]
    N_analitica_configuracion_reporte_periodico[analitica.configuracion_reporte_periodico]
    N_analitica_foco_caso[analitica.foco_caso]
    N_analitica_foco_investigativo[analitica.foco_investigativo]
    N_analitica_matriz_analisis[analitica.matriz_analisis]
    N_analitica_reporte_analitico[analitica.reporte_analitico]
    N_analitica_reporte_analitico_caso[analitica.reporte_analitico_caso]
    N_analitica_vinculo_entidad[analitica.vinculo_entidad]
    N_archivos_archivo[archivos.archivo]
    N_casos_caso[casos.caso]
    N_organizacion_funcionario[organizacion.funcionario]
    N_organizacion_unidad[organizacion.unidad]
    N_analitica_aplicacion_reporte -->|analitica.fk_aplic_reporte| N_analitica_reporte_analitico
    N_analitica_configuracion_reporte_periodico -->|analitica.fk_confrep_tipo| N_analitica_cat_tipo_reporte
    N_analitica_foco_investigativo -->|analitica.fk_foco_func| N_organizacion_funcionario
    N_analitica_foco_investigativo -->|analitica.fk_foco_reporte| N_analitica_reporte_analitico
    N_analitica_foco_investigativo -->|analitica.fk_foco_unidad| N_organizacion_unidad
    N_analitica_foco_caso -->|analitica.fk_fococaso_caso| N_casos_caso
    N_analitica_foco_caso -->|analitica.fk_fococaso_foco| N_analitica_foco_investigativo
    N_analitica_foco_caso -->|analitica.fk_fococaso_func| N_organizacion_funcionario
    N_analitica_matriz_analisis -->|analitica.fk_matran_func| N_organizacion_funcionario
    N_analitica_matriz_analisis -->|analitica.fk_matran_reporte| N_analitica_reporte_analitico
    N_analitica_reporte_analitico -->|analitica.fk_reporte_aprueba| N_organizacion_funcionario
    N_analitica_reporte_analitico -->|analitica.fk_reporte_archivo| N_archivos_archivo
    N_analitica_reporte_analitico -->|analitica.fk_reporte_autor| N_organizacion_funcionario
    N_analitica_reporte_analitico -->|analitica.fk_reporte_tipo| N_analitica_cat_tipo_reporte
    N_analitica_reporte_analitico -->|analitica.fk_reporte_unidad| N_organizacion_unidad
    N_analitica_reporte_analitico_caso -->|analitica.fk_reptcaso_caso| N_casos_caso
    N_analitica_reporte_analitico_caso -->|analitica.fk_reptcaso_reporte| N_analitica_reporte_analitico
    N_analitica_vinculo_entidad -->|analitica.fk_vincent_func| N_organizacion_funcionario
    N_analitica_vinculo_entidad -->|analitica.fk_vincent_reporte| N_analitica_reporte_analitico
```

Tablas incluidas: 13
Relaciones incluidas: 19
