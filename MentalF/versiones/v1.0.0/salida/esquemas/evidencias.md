# Mapa Visual por Esquema: evidencias

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: evidencias

```mermaid
flowchart LR
    N_casos_caso[casos.caso]
    N_catalogo_bienes_producto[catalogo_bienes.producto]
    N_diligencias_diligencia[diligencias.diligencia]
    N_diligencias_peritaje[diligencias.peritaje]
    N_evidencias_arma[evidencias.arma]
    N_evidencias_cadena_custodia[evidencias.cadena_custodia]
    N_evidencias_cat_catalogo_armas[evidencias.cat_catalogo_armas]
    N_evidencias_cat_clasificacion_arma[evidencias.cat_clasificacion_arma]
    N_evidencias_cat_droga[evidencias.cat_droga]
    N_evidencias_cat_estado_especie[evidencias.cat_estado_especie]
    N_evidencias_cat_institucion[evidencias.cat_institucion]
    N_evidencias_cat_proposito_transferencia[evidencias.cat_proposito_transferencia]
    N_evidencias_cat_tipo_custodia[evidencias.cat_tipo_custodia]
    N_evidencias_cat_tipo_extension_especie[evidencias.cat_tipo_extension_especie]
    N_evidencias_especie[evidencias.especie]
    N_evidencias_especie_arma[evidencias.especie_arma]
    N_evidencias_especie_droga[evidencias.especie_droga]
    N_evidencias_especie_electronico[evidencias.especie_electronico]
    N_evidencias_especie_historial_estado[evidencias.especie_historial_estado]
    N_evidencias_especie_lugar[evidencias.especie_lugar]
    N_evidencias_especie_otras[evidencias.especie_otras]
    N_evidencias_especie_retencion[evidencias.especie_retencion]
    N_evidencias_especie_sello[evidencias.especie_sello]
    N_evidencias_especie_vehiculo[evidencias.especie_vehiculo]
    N_evidencias_evidencia[evidencias.evidencia]
    N_evidencias_evidencia_lugar[evidencias.evidencia_lugar]
    N_evidencias_incautacion[evidencias.incautacion]
    N_investigacion_hecho[investigacion.hecho]
    N_organizacion_funcionario[organizacion.funcionario]
    N_ubicacion_cat_rol_lugar[ubicacion.cat_rol_lugar]
    N_ubicacion_cat_tipo_lugar[ubicacion.cat_tipo_lugar]
    N_ubicacion_lugar[ubicacion.lugar]
    N_ubicacion_region[ubicacion.region]
    N_vehiculos_vehiculo[vehiculos.vehiculo]
    N_diligencias_peritaje -->|diligencias.fk_per_esp_caso| N_evidencias_especie
    N_diligencias_peritaje -->|diligencias.fk_per_inst| N_evidencias_cat_institucion
    N_evidencias_arma -->|evidencias.fk_arma_catalogo| N_evidencias_cat_catalogo_armas
    N_evidencias_arma -->|evidencias.fk_arma_clasificacion| N_evidencias_cat_clasificacion_arma
    N_evidencias_especie_arma -->|evidencias.fk_arma_especie| N_evidencias_especie
    N_evidencias_cadena_custodia -->|evidencias.fk_cc_especie| N_evidencias_especie
    N_evidencias_cadena_custodia -->|evidencias.fk_cc_func_dest| N_organizacion_funcionario
    N_evidencias_cadena_custodia -->|evidencias.fk_cc_func_orig| N_organizacion_funcionario
    N_evidencias_cadena_custodia -->|evidencias.fk_cc_inst_dest| N_evidencias_cat_institucion
    N_evidencias_cadena_custodia -->|evidencias.fk_cc_inst_orig| N_evidencias_cat_institucion
    N_evidencias_cadena_custodia -->|evidencias.fk_cc_proposito| N_evidencias_cat_proposito_transferencia
    N_evidencias_especie_droga -->|evidencias.fk_droga_especie| N_evidencias_especie
    N_evidencias_especie_electronico -->|evidencias.fk_elec_especie| N_evidencias_especie
    N_evidencias_especie -->|evidencias.fk_esp_caso| N_casos_caso
    N_evidencias_especie -->|evidencias.fk_esp_custodia| N_evidencias_cat_tipo_custodia
    N_evidencias_especie -->|evidencias.fk_esp_estado| N_evidencias_cat_estado_especie
    N_evidencias_especie -->|evidencias.fk_esp_evi_caso| N_evidencias_evidencia
    N_evidencias_especie -->|evidencias.fk_esp_tipo_extension| N_evidencias_cat_tipo_extension_especie
    N_evidencias_especie_arma -->|evidencias.fk_especie_arma_arma| N_evidencias_arma
    N_evidencias_especie_arma -->|evidencias.fk_especie_arma_catalogo| N_evidencias_cat_catalogo_armas
    N_evidencias_especie_arma -->|evidencias.fk_especie_arma_clasificacion| N_evidencias_cat_clasificacion_arma
    N_evidencias_especie_droga -->|evidencias.fk_especie_droga_cat| N_evidencias_cat_droga
    N_evidencias_especie -->|evidencias.fk_especie_producto| N_catalogo_bienes_producto
    N_evidencias_especie_historial_estado -->|evidencias.fk_esphist_esp| N_evidencias_especie
    N_evidencias_especie_historial_estado -->|evidencias.fk_esphist_est_ant| N_evidencias_cat_estado_especie
    N_evidencias_especie_historial_estado -->|evidencias.fk_esphist_est_nvo| N_evidencias_cat_estado_especie
    N_evidencias_especie_historial_estado -->|evidencias.fk_esphist_func| N_organizacion_funcionario
    N_evidencias_especie_lugar -->|evidencias.fk_esplug_esp| N_evidencias_especie
    N_evidencias_especie_lugar -->|evidencias.fk_esplug_lug| N_ubicacion_lugar
    N_evidencias_especie_lugar -->|evidencias.fk_esplug_rol| N_ubicacion_cat_rol_lugar
    N_evidencias_especie_lugar -->|evidencias.fk_esplug_tipo| N_ubicacion_cat_tipo_lugar
    N_evidencias_especie_vehiculo -->|evidencias.fk_esveh_especie| N_evidencias_especie
    N_evidencias_especie_vehiculo -->|evidencias.fk_esveh_vehiculo| N_vehiculos_vehiculo
    N_evidencias_evidencia -->|evidencias.fk_evi_caso| N_casos_caso
    N_evidencias_evidencia -->|evidencias.fk_evi_dil| N_diligencias_diligencia
    N_evidencias_evidencia -->|evidencias.fk_evi_dil_caso| N_diligencias_diligencia
    N_evidencias_evidencia -->|evidencias.fk_evi_func| N_organizacion_funcionario
    N_evidencias_evidencia -->|evidencias.fk_evi_hecho_caso| N_investigacion_hecho
    N_evidencias_evidencia -->|evidencias.fk_evi_incautacion| N_evidencias_incautacion
    N_evidencias_evidencia -->|evidencias.fk_evi_lugar| N_ubicacion_lugar
    N_evidencias_evidencia_lugar -->|evidencias.fk_evilug_evi| N_evidencias_evidencia
    N_evidencias_evidencia_lugar -->|evidencias.fk_evilug_lug| N_ubicacion_lugar
    N_evidencias_evidencia_lugar -->|evidencias.fk_evilug_rol| N_ubicacion_cat_rol_lugar
    N_evidencias_evidencia_lugar -->|evidencias.fk_evilug_tipo| N_ubicacion_cat_tipo_lugar
    N_evidencias_incautacion -->|evidencias.fk_incaut_caso| N_casos_caso
    N_evidencias_incautacion -->|evidencias.fk_incaut_diligencia| N_diligencias_diligencia
    N_evidencias_incautacion -->|evidencias.fk_incaut_func| N_organizacion_funcionario
    N_evidencias_incautacion -->|evidencias.fk_incaut_func_incautacion| N_organizacion_funcionario
    N_evidencias_incautacion -->|evidencias.fk_incaut_lugar| N_ubicacion_lugar
    N_evidencias_incautacion -->|evidencias.fk_incautacion_region| N_ubicacion_region
    N_evidencias_especie_otras -->|evidencias.fk_otras_especie| N_evidencias_especie
    N_evidencias_especie_retencion -->|evidencias.fk_ret_especie| N_evidencias_especie
    N_evidencias_especie_sello -->|evidencias.fk_sello_especie| N_evidencias_especie
    N_evidencias_especie_sello -->|evidencias.fk_sello_func| N_organizacion_funcionario
    N_evidencias_especie_sello -->|evidencias.fk_sello_inst| N_evidencias_cat_institucion
```

Tablas incluidas: 34
Relaciones incluidas: 55
