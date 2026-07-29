IF NOT EXISTS (SELECT 1 FROM diligencias.cat_tipo_actividad)
BEGIN
INSERT INTO diligencias.cat_tipo_actividad
( 
 codigo, 
 nombre, 
 id_usuario_creador, 
 id_usuario_modificador,
 id_usuario_eliminador, 
 fecha_creacion, 
 fecha_actualizacion, 
 fecha_eliminacion_logica 
)
VALUES
('Concurrencia', 'Concurrencia', null, null, null, null, null, null),
('Solicitud de Apoyo Especializado', 'Solicitud de Apoyo Especializado', null, null, null, null, null, null),
('Orden de Detencion', 'Orden de Detencion', null, null, null, null, null, null)
END

SET IDENTITY_INSERT diligencias.cat_estado_diligencia ON;
MERGE diligencias.cat_estado_diligencia AS target
USING (VALUES
 (1,'ANULADA','Anulada'),
 (2,'BORRADOR','Borrador'),
 (3,'EN_REVISION','En revisiÃ³n'),
 (4,'ENVIADA_A_VISAR','Enviada a visar'),
 (5,'FIRMADA_POR_JEFATURA','Firmada por jefatura'),
 (6,'NOTIFICADA_FISCALIA','Notificada a FiscalÃ­a'),
 (7,'OBSERVADO','Observada')
) AS src (id_estado_diligencia, codigo, nombre)
ON target.id_estado_diligencia = src.id_estado_diligencia
WHEN MATCHED THEN UPDATE SET target.codigo = src.codigo, target.nombre = src.nombre
WHEN NOT MATCHED THEN INSERT (id_estado_diligencia, codigo, nombre) VALUES (src.id_estado_diligencia, src.codigo, src.nombre);
SET IDENTITY_INSERT diligencias.cat_estado_diligencia OFF;


IF NOT EXISTS (SELECT 1 FROM diligencias.cat_tipo_diligencia)
BEGIN
INSERT INTO diligencias.cat_tipo_diligencia
(
 codigo,
 nombre,
 es_primera_diligencia,
 requiere_autorizacion_judicial
)
VALUES
(N'PD', N'Primera diligencia', CAST(1 AS boolean), CAST(0 AS boolean)),
(N'IP', N'InstrucciÃ³n particular', CAST(0 AS boolean), CAST(0 AS boolean)),
(N'OI', N'Orden de investigar', CAST(0 AS boolean), CAST(0 AS boolean))
END

