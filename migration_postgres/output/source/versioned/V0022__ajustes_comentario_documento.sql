ALTER TABLE tareas.comentario_documento
ADD id_version_documento INT NOT NULL

ALTER TABLE tareas.comentario_documento
ADD FOREIGN KEY (id_version_documento) REFERENCES tareas.version_documento(id_version_documento)

GO