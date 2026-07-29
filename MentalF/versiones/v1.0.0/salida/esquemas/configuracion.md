# Mapa Visual por Esquema: configuracion

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: configuracion

```mermaid
flowchart LR
    N_configuracion_cat_dominio[configuracion.cat_dominio]
    N_configuracion_cat_elemento_dominio[configuracion.cat_elemento_dominio]
    N_configuracion_cat_programa_seguridad[configuracion.cat_programa_seguridad]
    N_denuncias_procedimiento_policial[denuncias.procedimiento_policial]
    N_ubicacion_comuna[ubicacion.comuna]
    N_configuracion_cat_elemento_dominio -->|configuracion.fk_elemento_dominio| N_configuracion_cat_dominio
    N_configuracion_cat_programa_seguridad -->|configuracion.fk_progseq_comuna| N_ubicacion_comuna
    N_denuncias_procedimiento_policial -->|denuncias.fk_proc_programa| N_configuracion_cat_programa_seguridad
```

Tablas incluidas: 5
Relaciones incluidas: 3
