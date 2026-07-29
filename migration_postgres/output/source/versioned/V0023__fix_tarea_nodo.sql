ALTER TABLE tareas.nodo
DROP CONSTRAINT CK_nodo_version_documento_tipo
GO

ALTER TABLE tareas.nodo
ADD CONSTRAINT CK_nodo_version_documento_tipo
CHECK (
    tipo_valor IN (
        'boolean',
        'array',
        'number',
        'string',
        'object',
        'null'
    )
);
GO