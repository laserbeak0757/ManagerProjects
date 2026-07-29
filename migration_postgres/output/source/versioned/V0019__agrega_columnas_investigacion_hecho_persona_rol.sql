ALTER TABLE investigacion.hecho_persona_rol
ADD puede_reconocer_imputado BIT NULL
GO

ALTER TABLE investigacion.hecho_persona_rol
ADD teme_por_seguridad BIT NULL
GO

ALTER TABLE investigacion.hecho_persona_rol
ADD aporta_datos_utiles BIT NULL
GO

ALTER TABLE denuncias.denuncia
DROP COLUMN puede_reconocer_imputado
GO

ALTER TABLE denuncias.denuncia
DROP COLUMN teme_por_seguridad
GO

ALTER TABLE denuncias.denuncia
DROP COLUMN id_organismo_encargado_denuncia
GO

ALTER TABLE denuncias.denuncia
ADD id_tipo_organismo_encargado INT NULL
GO

ALTER TABLE denuncias.denuncia
ADD FOREIGN KEY (id_tipo_organismo_encargado) REFERENCES organizacion.cat_tipo_organismo(id_tipo_organismo)
GO

ALTER TABLE denuncias.denuncia
DROP COLUMN id_organismo_registro_denuncia
GO

ALTER TABLE denuncias.denuncia
ADD id_unidad_registro INT NULL
GO

ALTER TABLE denuncias.denuncia
ADD FOREIGN KEY (id_unidad_registro) REFERENCES organizacion.unidad(id_unidad)
GO