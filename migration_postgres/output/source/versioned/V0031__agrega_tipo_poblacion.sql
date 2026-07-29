CREATE TABLE ubicacion.cat_tipo_poblacion
(
id_tipo_poblacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
descripcion NVARCHAR(50) NOT NULL,
id_usuario_modificador INT NULL,
id_usuario_eliminador INT NULL,
fecha_creacion DATETIME2(7) NULL,
fecha_actualizacion DATETIME2(7) NULL,
fecha_eliminacion_logica DATETIME2(7) NULL
)
GO

ALTER TABLE ubicacion.lugar_base
ADD id_tipo_poblacion INT NULL
GO

ALTER TABLE ubicacion.lugar_base
ADD FOREIGN KEY (id_tipo_poblacion) REFERENCES ubicacion.cat_tipo_poblacion(id_tipo_poblacion)
GO