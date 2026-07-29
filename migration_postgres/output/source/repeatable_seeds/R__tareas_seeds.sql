IF NOT EXISTS (SELECT 1 FROM documentos.tipo_documento)
BEGIN
INSERT INTO documentos.tipo_documento
(
id_tipo_documento,
nombre,
vigente
)
VALUES
(1, 'DENUNCIA', 1)
END

IF NOT EXISTS
(
	SELECT 1
	FROM tareas.evaluacion_comentario
)
BEGIN
	INSERT INTO tareas.evaluacion_comentario
	(
		id_evaluacion_comentario,
		nombre,
		activo
	)
	VALUES
	(1, 'regular', 1),
	(2, 'insuficiante', 1)
END
GO

IF NOT EXISTS
(
	SELECT 1
	FROM documentos.tipo_firma WITH(NOLOCK)
)
BEGIN
	INSERT INTO documentos.tipo_firma
	(
		id_tipo_firma,
		nombre,
		activo
	)
	VALUES
	(
		1,
		'CHECK_SIMPLE',
		1
	)
END
GO