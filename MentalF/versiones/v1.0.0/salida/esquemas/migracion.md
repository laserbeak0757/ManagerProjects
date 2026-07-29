# Mapa Visual por Esquema: migracion

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: migracion

```mermaid
flowchart LR
    N_migracion_cat_tipo_infraccion_migratoria[migracion.cat_tipo_infraccion_migratoria]
    N_migracion_denuncia_administrativa_migratoria[migracion.denuncia_administrativa_migratoria]
    N_migracion_expulsion[migracion.expulsion]
    N_migracion_fiscalizacion_planificada[migracion.fiscalizacion_planificada]
    N_organizacion_funcionario[organizacion.funcionario]
    N_organizacion_unidad[organizacion.unidad]
    N_personas_persona[personas.persona]
    N_ubicacion_pais[ubicacion.pais]
    N_migracion_denuncia_administrativa_migratoria -->|migracion.fk_dam_fiscalizacion| N_migracion_fiscalizacion_planificada
    N_migracion_denuncia_administrativa_migratoria -->|migracion.fk_denmig_func| N_organizacion_funcionario
    N_migracion_denuncia_administrativa_migratoria -->|migracion.fk_denmig_infraccion| N_migracion_cat_tipo_infraccion_migratoria
    N_migracion_denuncia_administrativa_migratoria -->|migracion.fk_denmig_persona| N_personas_persona
    N_migracion_denuncia_administrativa_migratoria -->|migracion.fk_denmig_unidad| N_organizacion_unidad
    N_migracion_expulsion -->|migracion.fk_exp_denuncia_mig| N_migracion_denuncia_administrativa_migratoria
    N_migracion_expulsion -->|migracion.fk_exp_func| N_organizacion_funcionario
    N_migracion_expulsion -->|migracion.fk_exp_pais| N_ubicacion_pais
    N_migracion_expulsion -->|migracion.fk_exp_persona| N_personas_persona
    N_migracion_fiscalizacion_planificada -->|migracion.fk_fisc_func| N_organizacion_funcionario
    N_migracion_fiscalizacion_planificada -->|migracion.fk_fisc_unidad| N_organizacion_unidad
```

Tablas incluidas: 8
Relaciones incluidas: 11
