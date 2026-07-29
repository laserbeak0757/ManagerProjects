CREATE TABLE organizacion.ofan_fiscalia
(
id_organismo_externo INT PRIMARY KEY,
id_unidad INT NOT NULL
)

ALTER TABLE organizacion.ofan_fiscalia
ADD FOREIGN KEY (id_unidad) REFERENCES organizacion.unidad(id_unidad)

ALTER TABLE organizacion.ofan_fiscalia
ADD FOREIGN KEY (id_organismo_externo) REFERENCES organizacion.cat_organismo_externo(id_organismo_externo)

DROP TABLE personas.cat_nacionalidad

ALTER TABLE organizacion.unidad
ALTER COLUMN codigo varchar(100) NOT NULL

