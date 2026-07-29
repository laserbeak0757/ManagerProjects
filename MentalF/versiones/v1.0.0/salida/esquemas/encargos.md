# Mapa Visual por Esquema: encargos

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: encargos

```mermaid
flowchart LR
    N_denuncias_denuncia[denuncias.denuncia]
    N_diligencias_diligencia[diligencias.diligencia]
    N_encargos_encargo[encargos.encargo]
    N_encargos_encargo_denuncia[encargos.encargo_denuncia]
    N_encargos_encargo_orden_judicial[encargos.encargo_orden_judicial]
    N_encargos_encargo_persona_diligencia[encargos.encargo_persona_diligencia]
    N_encargos_orden_judicial[encargos.orden_judicial]
    N_encargos_tarea_encargo[encargos.tarea_encargo]
    N_encargos_tipo_encargo[encargos.tipo_encargo]
    N_encargos_tipo_orden_judicial[encargos.tipo_orden_judicial]
    N_personas_persona[personas.persona]
    N_tareas_tarea[tareas.tarea]
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
```

Tablas incluidas: 12
Relaciones incluidas: 13
