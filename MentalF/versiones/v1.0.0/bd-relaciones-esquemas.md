# Mapa Visual: Relaciones entre Esquemas (SIP)

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac

```mermaid
flowchart LR
    N_analitica[analitica]
    N_archivos[archivos]
    N_auth[auth]
    N_casos[casos]
    N_catalogo_bienes[catalogo_bienes]
    N_configuracion[configuracion]
    N_cooperacion_int[cooperacion_int]
    N_dbo[dbo]
    N_denuncias[denuncias]
    N_diligencias[diligencias]
    N_encargos[encargos]
    N_evidencias[evidencias]
    N_investigacion[investigacion]
    N_migracion[migracion]
    N_organizacion[organizacion]
    N_personas[personas]
    N_tareas[tareas]
    N_ubicacion[ubicacion]
    N_vehiculos[vehiculos]
    N_analitica -->|8 FK| N_analitica
    N_analitica -->|1 FK| N_archivos
    N_analitica -->|2 FK| N_casos
    N_analitica -->|8 FK| N_organizacion
    N_archivos -->|4 FK| N_archivos
    N_archivos -->|1 FK| N_organizacion
    N_auth -->|9 FK| N_auth
    N_auth -->|1 FK| N_organizacion
    N_casos -->|1 FK| N_archivos
    N_casos -->|19 FK| N_casos
    N_casos -->|1 FK| N_investigacion
    N_casos -->|13 FK| N_organizacion
    N_casos -->|1 FK| N_personas
    N_catalogo_bienes -->|8 FK| N_catalogo_bienes
    N_configuracion -->|1 FK| N_configuracion
    N_configuracion -->|1 FK| N_ubicacion
    N_cooperacion_int -->|10 FK| N_cooperacion_int
    N_cooperacion_int -->|3 FK| N_organizacion
    N_cooperacion_int -->|1 FK| N_personas
    N_cooperacion_int -->|2 FK| N_ubicacion
    N_denuncias -->|1 FK| N_archivos
    N_denuncias -->|4 FK| N_casos
    N_denuncias -->|1 FK| N_configuracion
    N_denuncias -->|12 FK| N_denuncias
    N_denuncias -->|2 FK| N_investigacion
    N_denuncias -->|7 FK| N_organizacion
    N_denuncias -->|5 FK| N_personas
    N_denuncias -->|1 FK| N_ubicacion
    N_diligencias -->|2 FK| N_archivos
    N_diligencias -->|10 FK| N_casos
    N_diligencias -->|1 FK| N_denuncias
    N_diligencias -->|22 FK| N_diligencias
    N_diligencias -->|2 FK| N_evidencias
    N_diligencias -->|1 FK| N_investigacion
    N_diligencias -->|12 FK| N_organizacion
    N_diligencias -->|3 FK| N_personas
    N_diligencias -->|9 FK| N_ubicacion
    N_encargos -->|1 FK| N_denuncias
    N_encargos -->|1 FK| N_diligencias
    N_encargos -->|7 FK| N_encargos
    N_encargos -->|3 FK| N_personas
    N_encargos -->|1 FK| N_tareas
    N_evidencias -->|3 FK| N_casos
    N_evidencias -->|1 FK| N_catalogo_bienes
    N_evidencias -->|3 FK| N_diligencias
    N_evidencias -->|28 FK| N_evidencias
    N_evidencias -->|1 FK| N_investigacion
    N_evidencias -->|7 FK| N_organizacion
    N_evidencias -->|9 FK| N_ubicacion
    N_evidencias -->|1 FK| N_vehiculos
    N_investigacion -->|3 FK| N_casos
    N_investigacion -->|20 FK| N_investigacion
    N_investigacion -->|2 FK| N_organizacion
    N_investigacion -->|2 FK| N_personas
    N_investigacion -->|3 FK| N_ubicacion
    N_migracion -->|3 FK| N_migracion
    N_migracion -->|5 FK| N_organizacion
    N_migracion -->|2 FK| N_personas
    N_migracion -->|1 FK| N_ubicacion
    N_organizacion -->|8 FK| N_organizacion
    N_organizacion -->|1 FK| N_personas
    N_personas -->|1 FK| N_archivos
    N_personas -->|1 FK| N_organizacion
    N_personas -->|39 FK| N_personas
    N_personas -->|7 FK| N_ubicacion
    N_tareas -->|3 FK| N_archivos
    N_tareas -->|1 FK| N_denuncias
    N_tareas -->|1 FK| N_diligencias
    N_tareas -->|7 FK| N_organizacion
    N_tareas -->|16 FK| N_tareas
    N_ubicacion -->|1 FK| N_organizacion
    N_ubicacion -->|6 FK| N_ubicacion
    N_vehiculos -->|1 FK| N_personas
    N_vehiculos -->|9 FK| N_vehiculos
```

Total tablas detectadas: 230
Total relaciones FK detectadas: 399
