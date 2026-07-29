ALTER TABLE tareas.version_documento
ADD hash_datos text NOT NULL

CREATE TABLE tareas.tipo_firma
(
id_tipo_firma INT PRIMARY KEY,
nombre varchar(100) NOT NULL,
activo boolean NOT NULL
)

CREATE TABLE tareas.firma_version_documento
(
id_version_documento INT NOT NULL,
id_persona INT NOT NULL,
id_tipo_firma INT NOT NULL,
fecha DATETIME2 NOT NULL,
PRIMARY KEY
(
id_version_documento,
id_persona,
id_tipo_firma
)
)

ALTER TABLE tareas.firma_version_documento
ADD FOREIGN KEY (id_version_documento) REFERENCES tareas.version_documento(id_version_documento)

ALTER TABLE tareas.firma_version_documento
ADD FOREIGN KEY (id_persona) REFERENCES personas.persona(id_persona)

ALTER TABLE tareas.firma_version_documento
ADD FOREIGN KEY (id_tipo_firma) REFERENCES tareas.tipo_firma(id_tipo_firma)

