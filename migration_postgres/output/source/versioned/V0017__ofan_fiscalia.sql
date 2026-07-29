CREATE TABLE organizacion.ofan_fiscalia
(
id_organismo_externo INT PRIMARY KEY,
id_unidad INT NOT NULL
)
GO

ALTER TABLE organizacion.ofan_fiscalia
ADD FOREIGN KEY (id_unidad) REFERENCES organizacion.unidad(id_unidad)
GO

ALTER TABLE organizacion.ofan_fiscalia
ADD FOREIGN KEY (id_organismo_externo) REFERENCES organizacion.cat_organismo_externo(id_organismo_externo)
GO

DROP TABLE personas.cat_nacionalidad
GO

ALTER TABLE organizacion.unidad
ALTER COLUMN codigo NVARCHAR(100) NOT NULL
GO