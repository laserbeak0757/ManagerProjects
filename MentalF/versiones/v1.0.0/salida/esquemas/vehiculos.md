# Mapa Visual por Esquema: vehiculos

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: vehiculos

```mermaid
flowchart LR
    N_evidencias_especie_vehiculo[evidencias.especie_vehiculo]
    N_personas_persona[personas.persona]
    N_vehiculos_cat_color[vehiculos.cat_color]
    N_vehiculos_cat_marca[vehiculos.cat_marca]
    N_vehiculos_cat_modelo[vehiculos.cat_modelo]
    N_vehiculos_cat_tipo[vehiculos.cat_tipo]
    N_vehiculos_cat_tipo_relacion_persona[vehiculos.cat_tipo_relacion_persona]
    N_vehiculos_cat_version[vehiculos.cat_version]
    N_vehiculos_persona_vehiculo[vehiculos.persona_vehiculo]
    N_vehiculos_vehiculo[vehiculos.vehiculo]
    N_evidencias_especie_vehiculo -->|evidencias.fk_esveh_vehiculo| N_vehiculos_vehiculo
    N_vehiculos_cat_modelo -->|vehiculos.fk_modelo_marca| N_vehiculos_cat_marca
    N_vehiculos_persona_vehiculo -->|vehiculos.fk_perveh_persona| N_personas_persona
    N_vehiculos_persona_vehiculo -->|vehiculos.fk_perveh_tipo| N_vehiculos_cat_tipo_relacion_persona
    N_vehiculos_persona_vehiculo -->|vehiculos.fk_perveh_vehiculo| N_vehiculos_vehiculo
    N_vehiculos_vehiculo -->|vehiculos.fk_veh_color| N_vehiculos_cat_color
    N_vehiculos_vehiculo -->|vehiculos.fk_veh_marca| N_vehiculos_cat_marca
    N_vehiculos_vehiculo -->|vehiculos.fk_veh_modelo| N_vehiculos_cat_modelo
    N_vehiculos_vehiculo -->|vehiculos.fk_veh_tipo| N_vehiculos_cat_tipo
    N_vehiculos_vehiculo -->|vehiculos.fk_veh_version| N_vehiculos_cat_version
    N_vehiculos_cat_version -->|vehiculos.fk_version_modelo| N_vehiculos_cat_modelo
```

Tablas incluidas: 10
Relaciones incluidas: 11
