ALTER TABLE diligencias.cat_tipo_actividad
ADD id_usuario_creador INT NULL
GO

ALTER TABLE diligencias.cat_tipo_actividad
ALTER COLUMN codigo NVARCHAR(100) NOT NULL
GO