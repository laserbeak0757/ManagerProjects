# Mapa Visual por Esquema: personas

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: personas

```mermaid
flowchart LR
    N_archivos_archivo[archivos.archivo]
    N_casos_caso_persona_rol[casos.caso_persona_rol]
    N_cooperacion_int_solicitud_interpol[cooperacion_int.solicitud_interpol]
    N_denuncias_denuncia_persona_rol[denuncias.denuncia_persona_rol]
    N_denuncias_pauta_vif[denuncias.pauta_vif]
    N_denuncias_procedimiento_persona[denuncias.procedimiento_persona]
    N_denuncias_relato[denuncias.relato]
    N_diligencias_detencion[diligencias.detencion]
    N_diligencias_orden_arresto[diligencias.orden_arresto]
    N_diligencias_orden_detencion[diligencias.orden_detencion]
    N_encargos_encargo_denuncia[encargos.encargo_denuncia]
    N_encargos_encargo_persona_diligencia[encargos.encargo_persona_diligencia]
    N_encargos_orden_judicial[encargos.orden_judicial]
    N_investigacion_delito_imputado_persona[investigacion.delito_imputado_persona]
    N_investigacion_hecho_persona_rol[investigacion.hecho_persona_rol]
    N_migracion_denuncia_administrativa_migratoria[migracion.denuncia_administrativa_migratoria]
    N_migracion_expulsion[migracion.expulsion]
    N_organizacion_funcionario[organizacion.funcionario]
    N_personas_alias[personas.alias]
    N_personas_anotacion[personas.anotacion]
    N_personas_cat_color_cabello[personas.cat_color_cabello]
    N_personas_cat_color_ojos[personas.cat_color_ojos]
    N_personas_cat_color_piel[personas.cat_color_piel]
    N_personas_cat_complexion[personas.cat_complexion]
    N_personas_cat_forma_rostro[personas.cat_forma_rostro]
    N_personas_cat_genero[personas.cat_genero]
    N_personas_cat_nacionalidad[personas.cat_nacionalidad]
    N_personas_cat_nivel_escolaridad[personas.cat_nivel_escolaridad]
    N_personas_cat_ocupacion[personas.cat_ocupacion]
    N_personas_cat_sexo[personas.cat_sexo]
    N_personas_cat_tipo_anotacion[personas.cat_tipo_anotacion]
    N_personas_cat_tipo_biometrico[personas.cat_tipo_biometrico]
    N_personas_cat_tipo_cabello[personas.cat_tipo_cabello]
    N_personas_cat_tipo_documento[personas.cat_tipo_documento]
    N_personas_cat_tipo_estado_civil[personas.cat_tipo_estado_civil]
    N_personas_cat_tipo_fotografia[personas.cat_tipo_fotografia]
    N_personas_cat_tipo_rasgo_distintivo[personas.cat_tipo_rasgo_distintivo]
    N_personas_cat_tipo_red_social[personas.cat_tipo_red_social]
    N_personas_cat_tipo_relacion[personas.cat_tipo_relacion]
    N_personas_cat_tipo_telefono[personas.cat_tipo_telefono]
    N_personas_cat_ubicacion_corporal[personas.cat_ubicacion_corporal]
    N_personas_contacto_otro[personas.contacto_otro]
    N_personas_correo[personas.correo]
    N_personas_descripcion_fisica[personas.descripcion_fisica]
    N_personas_empleo[personas.empleo]
    N_personas_escolaridad[personas.escolaridad]
    N_personas_estado_civil[personas.estado_civil]
    N_personas_fotografia[personas.fotografia]
    N_personas_identificacion[personas.identificacion]
    N_personas_nombre[personas.nombre]
    N_personas_persona[personas.persona]
    N_personas_persona_lugar[personas.persona_lugar]
    N_personas_rasgo_distintivo[personas.rasgo_distintivo]
    N_personas_red_social[personas.red_social]
    N_personas_referencia_biometrica[personas.referencia_biometrica]
    N_personas_relacion[personas.relacion]
    N_personas_telefono[personas.telefono]
    N_ubicacion_cat_rol_lugar[ubicacion.cat_rol_lugar]
    N_ubicacion_cat_tipo_lugar[ubicacion.cat_tipo_lugar]
    N_ubicacion_comuna[ubicacion.comuna]
    N_ubicacion_lugar[ubicacion.lugar]
    N_ubicacion_pais[ubicacion.pais]
    N_vehiculos_persona_vehiculo[vehiculos.persona_vehiculo]
    N_casos_caso_persona_rol -->|casos.fk_casoperrol_persona| N_personas_persona
    N_cooperacion_int_solicitud_interpol -->|cooperacion_int.fk_sol_persona| N_personas_persona
    N_denuncias_denuncia_persona_rol -->|denuncias.fk_denperrol_persona| N_personas_persona
    N_denuncias_procedimiento_persona -->|denuncias.fk_procpers_persona| N_personas_persona
    N_denuncias_relato -->|denuncias.fk_relato_declarante| N_personas_persona
    N_denuncias_pauta_vif -->|denuncias.fk_vif_imputado| N_personas_persona
    N_denuncias_pauta_vif -->|denuncias.fk_vif_victima| N_personas_persona
    N_diligencias_detencion -->|diligencias.fk_det_persona| N_personas_persona
    N_diligencias_orden_arresto -->|diligencias.fk_oa_persona| N_personas_persona
    N_diligencias_orden_detencion -->|diligencias.fk_od_persona| N_personas_persona
    N_encargos_encargo_denuncia -->|encargos.fk_encargo_denuncia_persona| N_personas_persona
    N_encargos_encargo_persona_diligencia -->|encargos.fk_encargo_persona_diligencia_persona| N_personas_persona
    N_encargos_orden_judicial -->|encargos.fk_orden_judicial_persona| N_personas_persona
    N_investigacion_delito_imputado_persona -->|investigacion.fk_delper_persona| N_personas_persona
    N_investigacion_hecho_persona_rol -->|investigacion.fk_hecoperrol_persona| N_personas_persona
    N_migracion_denuncia_administrativa_migratoria -->|migracion.fk_denmig_persona| N_personas_persona
    N_migracion_expulsion -->|migracion.fk_exp_persona| N_personas_persona
    N_organizacion_funcionario -->|organizacion.fk_func_persona| N_personas_persona
    N_personas_alias -->|personas.fk_alias_persona| N_personas_persona
    N_personas_anotacion -->|personas.fk_anotacion_funcionario| N_organizacion_funcionario
    N_personas_anotacion -->|personas.fk_anotacion_persona| N_personas_persona
    N_personas_anotacion -->|personas.fk_anotacion_tipo| N_personas_cat_tipo_anotacion
    N_personas_referencia_biometrica -->|personas.fk_biometrica_persona| N_personas_persona
    N_personas_referencia_biometrica -->|personas.fk_biometrica_tipo| N_personas_cat_tipo_biometrico
    N_personas_contacto_otro -->|personas.fk_contacto_otro_persona| N_personas_persona
    N_personas_correo -->|personas.fk_correo_persona| N_personas_persona
    N_personas_descripcion_fisica -->|personas.fk_descfis_cabello| N_personas_cat_color_cabello
    N_personas_descripcion_fisica -->|personas.fk_descfis_complexion| N_personas_cat_complexion
    N_personas_descripcion_fisica -->|personas.fk_descfis_ojos| N_personas_cat_color_ojos
    N_personas_descripcion_fisica -->|personas.fk_descfis_persona| N_personas_persona
    N_personas_descripcion_fisica -->|personas.fk_descfis_piel| N_personas_cat_color_piel
    N_personas_descripcion_fisica -->|personas.fk_descfis_rostro| N_personas_cat_forma_rostro
    N_personas_descripcion_fisica -->|personas.fk_descfis_tcabello| N_personas_cat_tipo_cabello
    N_personas_empleo -->|personas.fk_empleo_lugar| N_ubicacion_lugar
    N_personas_empleo -->|personas.fk_empleo_ocupacion| N_personas_cat_ocupacion
    N_personas_empleo -->|personas.fk_empleo_persona| N_personas_persona
    N_personas_escolaridad -->|personas.fk_escolaridad_nivel| N_personas_cat_nivel_escolaridad
    N_personas_escolaridad -->|personas.fk_escolaridad_persona| N_personas_persona
    N_personas_estado_civil -->|personas.fk_estcivil_persona| N_personas_persona
    N_personas_estado_civil -->|personas.fk_estcivil_tipo| N_personas_cat_tipo_estado_civil
    N_personas_fotografia -->|personas.fk_foto_archivo| N_archivos_archivo
    N_personas_fotografia -->|personas.fk_foto_persona| N_personas_persona
    N_personas_fotografia -->|personas.fk_foto_tipo| N_personas_cat_tipo_fotografia
    N_personas_identificacion -->|personas.fk_ident_pais| N_ubicacion_pais
    N_personas_identificacion -->|personas.fk_ident_persona| N_personas_persona
    N_personas_identificacion -->|personas.fk_ident_tipo| N_personas_cat_tipo_documento
    N_personas_nombre -->|personas.fk_nombre_persona| N_personas_persona
    N_personas_persona_lugar -->|personas.fk_perlug_lugar| N_ubicacion_lugar
    N_personas_persona_lugar -->|personas.fk_perlug_persona| N_personas_persona
    N_personas_persona_lugar -->|personas.fk_perlug_rol| N_ubicacion_cat_rol_lugar
    N_personas_persona_lugar -->|personas.fk_perlug_tipo| N_ubicacion_cat_tipo_lugar
    N_personas_persona -->|personas.fk_persona_comuna_nac| N_ubicacion_comuna
    N_personas_persona -->|personas.fk_persona_genero| N_personas_cat_genero
    N_personas_persona -->|personas.fk_persona_pais| N_ubicacion_pais
    N_personas_persona -->|personas.fk_persona_sexo| N_personas_cat_sexo
    N_personas_rasgo_distintivo -->|personas.fk_rasgo_foto| N_personas_fotografia
    N_personas_rasgo_distintivo -->|personas.fk_rasgo_persona| N_personas_persona
    N_personas_rasgo_distintivo -->|personas.fk_rasgo_tipo| N_personas_cat_tipo_rasgo_distintivo
    N_personas_rasgo_distintivo -->|personas.fk_rasgo_ubicacion| N_personas_cat_ubicacion_corporal
    N_personas_red_social -->|personas.fk_red_social_persona| N_personas_persona
    N_personas_red_social -->|personas.fk_red_social_tipo| N_personas_cat_tipo_red_social
    N_personas_relacion -->|personas.fk_relacion_destino| N_personas_persona
    N_personas_relacion -->|personas.fk_relacion_origen| N_personas_persona
    N_personas_relacion -->|personas.fk_relacion_tipo| N_personas_cat_tipo_relacion
    N_personas_telefono -->|personas.fk_telefono_persona| N_personas_persona
    N_personas_telefono -->|personas.fk_telefono_tipo| N_personas_cat_tipo_telefono
    N_vehiculos_persona_vehiculo -->|vehiculos.fk_perveh_persona| N_personas_persona
```

Tablas incluidas: 63
Relaciones incluidas: 67
