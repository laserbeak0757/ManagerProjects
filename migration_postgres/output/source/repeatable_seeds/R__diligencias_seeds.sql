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
GO

SET IDENTITY_INSERT diligencias.cat_estado_diligencia ON;
GO
MERGE diligencias.cat_estado_diligencia AS target
USING (VALUES
    (1,'ANULADA','Anulada'),
    (2,'BORRADOR','Borrador'),
    (3,'EN_REVISION','En revisión'),
    (4,'ENVIADA_A_VISAR','Enviada a visar'),
    (5,'FIRMADA_POR_JEFATURA','Firmada por jefatura'),
    (6,'NOTIFICADA_FISCALIA','Notificada a Fiscalía'),
    (7,'OBSERVADO','Observada')
) AS src (id_estado_diligencia, codigo, nombre)
ON target.id_estado_diligencia = src.id_estado_diligencia
WHEN MATCHED THEN UPDATE SET target.codigo = src.codigo, target.nombre = src.nombre
WHEN NOT MATCHED THEN INSERT (id_estado_diligencia, codigo, nombre) VALUES (src.id_estado_diligencia, src.codigo, src.nombre);
GO
SET IDENTITY_INSERT diligencias.cat_estado_diligencia OFF;
GO


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
(N'PD', N'Primera diligencia', CAST(1 AS bit), CAST(0 AS bit)),
(N'IP', N'Instrucción particular', CAST(0 AS bit), CAST(0 AS bit)),
(N'OI', N'Orden de investigar', CAST(0 AS bit), CAST(0 AS bit))
END
GO