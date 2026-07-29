ALTER TABLE denuncias.denuncia
DROP CONSTRAINT fk_denuncia_detalle_lugar_recepcion;

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
DROP CONSTRAINT pk_cat_detalle_lugar_recepcion_denuncia;

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
DROP COLUMN id_detalle_lugar_recepcion_denuncia;

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
ADD id_detalle_lugar_recepcion_denuncia INT NOT NULL;

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
ADD CONSTRAINT pk_cat_detalle_lugar_recepcion_denuncia
PRIMARY KEY (id_detalle_lugar_recepcion_denuncia);

ALTER TABLE denuncias.denuncia
ADD CONSTRAINT fk_denuncia_detalle_lugar_recepcion
FOREIGN KEY (id_detalle_lugar_recepcion_denuncia)
REFERENCES denuncias.cat_detalle_lugar_recepcion_denuncia(id_detalle_lugar_recepcion_denuncia);

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
DROP CONSTRAINT df_cat_detalle_lugar_recepcion_denuncia_activo;

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
DROP CONSTRAINT ck_cat_detalle_lugar_recepcion_denuncia_activo;

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
ALTER COLUMN activo boolean NOT NULL;


ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
DROP CONSTRAINT fk_cat_detalle_lugar_recepcion_lugar;

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
DROP CONSTRAINT pk_cat_lugar_recepcion_denuncia;

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
DROP COLUMN id_lugar_recepcion_denuncia;

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
ADD id_lugar_recepcion_denuncia INT NOT NULL;

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
ADD CONSTRAINT pk_cat_lugar_recepcion_denuncia
PRIMARY KEY (id_lugar_recepcion_denuncia);

ALTER TABLE denuncias.cat_detalle_lugar_recepcion_denuncia
ADD CONSTRAINT fk_cat_detalle_lugar_recepcion_lugar
FOREIGN KEY (id_lugar_recepcion_denuncia)
REFERENCES denuncias.cat_lugar_recepcion_denuncia(id_lugar_recepcion_denuncia);

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
DROP CONSTRAINT df_cat_lugar_recepcion_denuncia_activo;

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
DROP CONSTRAINT ck_cat_lugar_recepcion_denuncia_activo;

ALTER TABLE denuncias.cat_lugar_recepcion_denuncia
ALTER COLUMN activo boolean NOT NULL;


ALTER TABLE denuncias.denuncia
ALTER COLUMN id_tipo_denuncia INT NULL;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT df_denuncia_indicador_vif;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT ck_denuncia_indicador_vif;

DROP INDEX ix_denuncia_vif
ON denuncias.denuncia;

ALTER TABLE denuncias.denuncia
ALTER COLUMN indicador_vif boolean NOT NULL;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT df_denuncia_dominio_propiedad;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT ck_denuncia_dominio_propiedad;

ALTER TABLE denuncias.denuncia
ALTER COLUMN dominio_propiedad boolean NOT NULL;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT df_denuncia_es_flagrancia;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT ck_denuncia_es_flagrancia;

ALTER TABLE denuncias.denuncia
ALTER COLUMN es_flagrancia boolean NOT NULL;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT ck_denuncia_puede_reconocer_imputado;

ALTER TABLE denuncias.denuncia
ALTER COLUMN puede_reconocer_imputado boolean NOT NULL;

ALTER TABLE denuncias.denuncia
DROP CONSTRAINT ck_denuncia_teme_por_seguridad;

ALTER TABLE denuncias.denuncia
ALTER COLUMN teme_por_seguridad boolean NOT NULL;

ALTER TABLE denuncias.denuncia
ADD id_organismo_encargado_denuncia INT NULL;

ALTER TABLE denuncias.denuncia
ADD id_organismo_registro_denuncia INT NULL;

ALTER TABLE denuncias.denuncia
ADD id_origen_denuncia INT NULL;


ALTER TABLE investigacion.delito_imputado
DROP CONSTRAINT fk_delimp_grado;

ALTER TABLE investigacion.cat_grado_ejecucion
DROP CONSTRAINT pk_cat_grado_ejecucion;

ALTER TABLE investigacion.cat_grado_ejecucion
DROP COLUMN id_grado_ejecucion;

ALTER TABLE investigacion.cat_grado_ejecucion
ADD id_grado_ejecucion INT NOT NULL;

ALTER TABLE investigacion.cat_grado_ejecucion
ADD CONSTRAINT pk_cat_grado_ejecucion
PRIMARY KEY (id_grado_ejecucion);

ALTER TABLE investigacion.delito_imputado
ADD CONSTRAINT fk_delimp_grado
FOREIGN KEY (id_grado_ejecucion)
REFERENCES investigacion.cat_grado_ejecucion(id_grado_ejecucion);


ALTER TABLE investigacion.delito_imputado
ALTER COLUMN folio varchar(30) NULL;

ALTER TABLE investigacion.delito_imputado
ALTER COLUMN id_caso INT NULL;

ALTER TABLE investigacion.delito_imputado
DROP CONSTRAINT df_delito_imputado_contexto_vif;

ALTER TABLE investigacion.delito_imputado
DROP CONSTRAINT ck_delito_imputado_contexto_vif;

ALTER TABLE investigacion.delito_imputado
ALTER COLUMN contexto_vif boolean NOT NULL;

ALTER TABLE investigacion.delito_imputado
DROP CONSTRAINT df_delito_imputado_es_delito_principal;

ALTER TABLE investigacion.delito_imputado
DROP CONSTRAINT ck_delito_imputado_es_delito_principal;

ALTER TABLE investigacion.delito_imputado
ALTER COLUMN es_delito_principal boolean NOT NULL;


ALTER TABLE organizacion.unidad
DROP CONSTRAINT fk_unidad_tipo

ALTER TABLE organizacion.cat_tipo_unidad
DROP CONSTRAINT pk_cat_tipo_unidad;

ALTER TABLE organizacion.cat_tipo_unidad
DROP COLUMN id_tipo_unidad;

ALTER TABLE organizacion.cat_tipo_unidad
ADD id_tipo_unidad INT NOT NULL;

ALTER TABLE organizacion.cat_tipo_unidad
ADD CONSTRAINT pk_cat_tipo_unidad
PRIMARY KEY (id_tipo_unidad);

ALTER TABLE organizacion.unidad
ADD CONSTRAINT fk_unidad_tipo
FOREIGN KEY (id_tipo_unidad)
REFERENCES organizacion.cat_tipo_unidad(id_tipo_unidad);


ALTER TABLE analitica.foco_investigativo
DROP CONSTRAINT fk_foco_unidad

ALTER TABLE casos.carpeta
DROP CONSTRAINT fk_carpeta_unidad

ALTER TABLE analitica.reporte_analitico
DROP CONSTRAINT fk_reporte_unidad

ALTER TABLE organizacion.funcionario
DROP CONSTRAINT fk_func_unidad

ALTER TABLE organizacion.relacion_unidad
DROP CONSTRAINT fk_relunidad_padre

ALTER TABLE organizacion.relacion_unidad
DROP CONSTRAINT fk_relunidad_hija

ALTER TABLE migracion.fiscalizacion_planificada
DROP CONSTRAINT fk_fisc_unidad

ALTER TABLE migracion.denuncia_administrativa_migratoria
DROP CONSTRAINT fk_denmig_unidad

ALTER TABLE tareas.bandeja
DROP CONSTRAINT fk_bandeja_unidad

ALTER TABLE diligencias.detencion
DROP CONSTRAINT fk_det_unidad

ALTER TABLE diligencias.instruccion_fiscal
DROP CONSTRAINT fk_instfisc_unid

--------------------------------------------------------------------------------

ALTER TABLE organizacion.unidad
DROP CONSTRAINT pk_unidad;

ALTER TABLE organizacion.unidad
DROP COLUMN id_unidad;

ALTER TABLE organizacion.unidad
ADD id_unidad INT NOT NULL;

ALTER TABLE organizacion.unidad
ADD CONSTRAINT pk_unidad
PRIMARY KEY (id_unidad);

ALTER TABLE organizacion.unidad
DROP CONSTRAINT df_unidad_es_lacrim;

ALTER TABLE organizacion.unidad
DROP CONSTRAINT ck_unidad_es_lacrim;

ALTER TABLE organizacion.unidad
ALTER COLUMN es_lacrim boolean NOT NULL;

ALTER TABLE analitica.foco_investigativo
ADD CONSTRAINT fk_foco_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE casos.carpeta
ADD CONSTRAINT fk_carpeta_unidad
FOREIGN KEY (id_unidad_responsable)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE analitica.reporte_analitico
ADD CONSTRAINT fk_reporte_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE organizacion.funcionario
ADD CONSTRAINT fk_func_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE organizacion.relacion_unidad
ADD CONSTRAINT fk_relunidad_padre
FOREIGN KEY (id_unidad_padre)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE organizacion.relacion_unidad
ADD CONSTRAINT fk_relunidad_hija
FOREIGN KEY (id_unidad_hija)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE migracion.fiscalizacion_planificada
ADD CONSTRAINT fk_fisc_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE migracion.denuncia_administrativa_migratoria
ADD CONSTRAINT fk_denmig_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE tareas.bandeja
ADD CONSTRAINT fk_bandeja_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE diligencias.detencion
ADD CONSTRAINT fk_det_unidad
FOREIGN KEY (id_unidad)
REFERENCES organizacion.unidad(id_unidad);

ALTER TABLE diligencias.instruccion_fiscal
ADD CONSTRAINT fk_instfisc_unid
FOREIGN KEY (id_unidad_destinataria)
REFERENCES organizacion.unidad(id_unidad);


ALTER TABLE investigacion.hecho_lugar
DROP CONSTRAINT fk_hecholug_rol

ALTER TABLE personas.persona_lugar
DROP CONSTRAINT fk_perlug_rol

ALTER TABLE evidencias.especie_lugar
DROP CONSTRAINT fk_esplug_rol

ALTER TABLE evidencias.evidencia_lugar
DROP CONSTRAINT fk_evilug_rol

ALTER TABLE diligencias.detencion_lugar
DROP CONSTRAINT fk_detlug_rol

ALTER TABLE diligencias.diligencia_lugar
DROP CONSTRAINT fk_dillug_rol
-------------------------------------------------------------
ALTER TABLE ubicacion.cat_rol_lugar
DROP CONSTRAINT pk_cat_rol_lugar;

ALTER TABLE ubicacion.cat_rol_lugar
DROP COLUMN id_rol_lugar;

ALTER TABLE ubicacion.cat_rol_lugar
ADD id_rol_lugar INT NOT NULL;

ALTER TABLE ubicacion.cat_rol_lugar
ADD CONSTRAINT pk_cat_rol_lugar
PRIMARY KEY (id_rol_lugar);

ALTER TABLE investigacion.hecho_lugar
ADD CONSTRAINT fk_hecholug_rol
FOREIGN KEY (id_rol_lugar)
REFERENCES ubicacion.cat_rol_lugar(id_rol_lugar);

ALTER TABLE personas.persona_lugar
ADD CONSTRAINT fk_perlug_rol
FOREIGN KEY (id_rol_lugar)
REFERENCES ubicacion.cat_rol_lugar(id_rol_lugar);

ALTER TABLE evidencias.especie_lugar
ADD CONSTRAINT fk_esplug_rol
FOREIGN KEY (id_rol_lugar)
REFERENCES ubicacion.cat_rol_lugar(id_rol_lugar);

ALTER TABLE evidencias.evidencia_lugar
ADD CONSTRAINT fk_evilug_rol
FOREIGN KEY (id_rol_lugar)
REFERENCES ubicacion.cat_rol_lugar(id_rol_lugar);

ALTER TABLE diligencias.detencion_lugar
ADD CONSTRAINT fk_detlug_rol
FOREIGN KEY (id_rol_lugar)
REFERENCES ubicacion.cat_rol_lugar(id_rol_lugar);

ALTER TABLE diligencias.diligencia_lugar
ADD CONSTRAINT fk_dillug_rol
FOREIGN KEY (id_rol_lugar)
REFERENCES ubicacion.cat_rol_lugar(id_rol_lugar);


ALTER TABLE ubicacion.lugar
DROP CONSTRAINT fk_lugar_tipo_subdivision
---------------------------------------------------------------
ALTER TABLE ubicacion.cat_tipo_subdivision
DROP CONSTRAINT pk_cat_tipo_subdivision;

ALTER TABLE ubicacion.cat_tipo_subdivision
DROP COLUMN id_tipo_subdivision;

ALTER TABLE ubicacion.cat_tipo_subdivision
ADD id_tipo_subdivision INT NOT NULL;

ALTER TABLE ubicacion.cat_tipo_subdivision
ADD CONSTRAINT pk_cat_tipo_subdivision
PRIMARY KEY (id_tipo_subdivision);

ALTER TABLE ubicacion.lugar
ADD CONSTRAINT fk_lugar_tipo_subdivision
FOREIGN KEY (id_tipo_subdivision)
REFERENCES ubicacion.cat_tipo_subdivision(id_tipo_subdivision);


ALTER TABLE ubicacion.lugar_base
DROP CONSTRAINT ck_lugar_base_direccion_exacta;

ALTER TABLE ubicacion.lugar_base
ALTER COLUMN direccion_exacta boolean NOT NULL;

