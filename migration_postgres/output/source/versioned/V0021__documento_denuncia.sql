CREATE TABLE tareas.documento_denuncia
(
	id_documento INT PRIMARY KEY,
	id_denuncia INT NOT NULL
)

ALTER TABLE tareas.documento_denuncia
ADD FOREIGN KEY (id_documento) REFERENCES tareas.documento(id_documento)

ALTER TABLE tareas.documento_denuncia
ADD FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia(id_denuncia)

ALTER TABLE tareas.documento_denuncia
ADD CONSTRAINT uq_tareasdocumento_denuncia_id_denuncia UNIQUE (id_denuncia)
GO

CREATE TABLE tareas.nodo
(
id_nodo INT PRIMARY KEY IDENTITY,
id_version_documento INT NOT NULL,
path NVARCHAR(850) NOT NULL,
tipo_valor NVARCHAR(20) NOT NULL,
valor_string NVARCHAR(MAX) NULL,
valor_number DECIMAL(38, 10) NULL,
valor_boolean BIT NULL
)
GO

ALTER TABLE tareas.nodo ADD FOREIGN KEY (id_version_documento) REFERENCES tareas.version_documento(id_version_documento);
ALTER TABLE tareas.nodo ADD CONSTRAINT CK_nodo_version_documento_tipo CHECK (tipo_valor IN ('object', 'string', 'number', 'array', 'boolean'));
ALTER TABLE tareas.nodo ADD CONSTRAINT uq_nodo_version_path UNIQUE (id_version_documento, path);
ALTER TABLE tareas.nodo
ADD CONSTRAINT CK_nodo_tipo_vs_valor
CHECK
(
    (
        tipo_valor = 'string'
        AND valor_number IS NULL
        AND valor_boolean IS NULL
    )
    OR
    (
        tipo_valor = 'number'
        AND valor_string IS NULL
        AND valor_boolean IS NULL
    )
    OR
    (
        tipo_valor = 'boolean'
        AND valor_string IS NULL
        AND valor_number IS NULL
    )
    OR
    (
        tipo_valor IN ('object', 'array')
        AND valor_string IS NULL
        AND valor_number IS NULL
        AND valor_boolean IS NULL
    )
);

GO

CREATE TABLE tareas.evaluacion_comentario
(
id_evaluacion_comentario INT PRIMARY KEY,
nombre NVARCHAR(200) NOT NULL,
activo BIT NOT NULL
)

CREATE TABLE tareas.comentario_documento
(
id_comentario_documento INT PRIMARY KEY IDENTITY,
comentario NVARCHAR(MAX) NOT NULL,
fecha_comentario DATETIME NOT NULL,
id_funcionario INT NOT NULL,
id_evaluacion_comentario INT NOT NULL
)
GO

ALTER TABLE tareas.comentario_documento ADD FOREIGN KEY (id_funcionario) REFERENCES organizacion.funcionario(id_funcionario);
ALTER TABLE tareas.comentario_documento ADD FOREIGN KEY (id_evaluacion_comentario) REFERENCES tareas.evaluacion_comentario(id_evaluacion_comentario);
GO

CREATE TABLE tareas.comentario_documento_nodo
(
id_comentario_documento INT,
id_nodo INT,
PRIMARY KEY
(
id_comentario_documento,
id_nodo
)
)
GO

ALTER TABLE tareas.comentario_documento_nodo ADD FOREIGN KEY (id_comentario_documento) REFERENCES tareas.comentario_documento(id_comentario_documento);
ALTER TABLE tareas.comentario_documento_nodo ADD FOREIGN KEY (id_nodo) REFERENCES tareas.nodo(id_nodo);
GO