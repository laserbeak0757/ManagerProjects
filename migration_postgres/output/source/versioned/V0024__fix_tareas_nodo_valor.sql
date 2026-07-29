ALTER TABLE tareas.nodo
DROP CONSTRAINT CK_nodo_tipo_vs_valor;

ALTER TABLE tareas.nodo
DROP COLUMN valor_string;

ALTER TABLE tareas.nodo
DROP COLUMN valor_number;

ALTER TABLE tareas.nodo
DROP COLUMN valor_boolean;

ALTER TABLE tareas.nodo
ADD valor NVARCHAR(MAX) NULL;

GO