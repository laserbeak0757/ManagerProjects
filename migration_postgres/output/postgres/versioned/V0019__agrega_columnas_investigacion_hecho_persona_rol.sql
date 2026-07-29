ALTER TABLE investigacion.hecho_persona_rol
ADD puede_reconocer_imputado boolean NULL

ALTER TABLE investigacion.hecho_persona_rol
ADD teme_por_seguridad boolean NULL

ALTER TABLE investigacion.hecho_persona_rol
ADD aporta_datos_utiles boolean NULL

ALTER TABLE denuncias.denuncia
DROP COLUMN puede_reconocer_imputado

ALTER TABLE denuncias.denuncia
DROP COLUMN teme_por_seguridad

ALTER TABLE denuncias.denuncia
DROP COLUMN id_organismo_encargado_denuncia

ALTER TABLE denuncias.denuncia
ADD id_tipo_organismo_encargado INT NULL

ALTER TABLE denuncias.denuncia
ADD FOREIGN KEY (id_tipo_organismo_encargado) REFERENCES organizacion.cat_tipo_organismo(id_tipo_organismo)

ALTER TABLE denuncias.denuncia
DROP COLUMN id_organismo_registro_denuncia

ALTER TABLE denuncias.denuncia
ADD id_unidad_registro INT NULL

ALTER TABLE denuncias.denuncia
ADD FOREIGN KEY (id_unidad_registro) REFERENCES organizacion.unidad(id_unidad)

