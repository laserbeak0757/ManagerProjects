-- casos.cat_tipo_rol_persona
-- Estrategia: MERGE por PK id_tipo_rol_persona + IDENTITY_INSERT (repetible, no duplica ni pierde datos).
SET IDENTITY_INSERT casos.cat_tipo_rol_persona ON;
MERGE casos.cat_tipo_rol_persona AS target
USING (VALUES
 (1, N'DENUNCIANTE', N'Denunciante', 0, 0, 0, 0, 0, 0, 0),
 (2, N'DENYVIC', N'Denunciante y vÃ­ctima', 0, 0, 0, 0, 0, 0, 0),
 (3, N'VICTIMA', N'VÃ­ctima', 0, 0, 0, 0, 0, 0, 0),
 (4, N'TESTIGO', N'Testigo', 0, 0, 0, 0, 0, 0, 0),
 (5, N'IMPUTADO', N'Imputado', 0, 0, 0, 0, 0, 0, 0),
 (6, N'VICTIMA_NNA', N'VÃ­ctima NiÃ±o(a) y Adolescente', 0, 0, 0, 0, 0, 0, 0),
 (7, N'ACOMPANANTE_NNA', N'AcompaÃ±ante', 0, 0, 0, 0, 0, 0, 0),
 (8, N'AGRESOR_NNA', N'Agresor (identificado espontÃ¡neamente)', 0, 0, 0, 0, 0, 0, 0),
 (9, N'ADULTO_PROTECTOR_NNA', N'Adulto protector', 0, 0, 0, 0, 0, 0, 0)
) AS src (id_tipo_rol_persona, codigo, nombre, requiere_telefono, requiere_correo, requiere_domicilio, requiere_identificacion, requiere_fecha_nacimiento, requiere_ocupacion, requiere_estado_civil)
ON target.id_tipo_rol_persona = src.id_tipo_rol_persona
WHEN MATCHED THEN UPDATE SET
 target.codigo = src.codigo,
 target.nombre = src.nombre,
 target.requiere_telefono = src.requiere_telefono,
 target.requiere_correo = src.requiere_correo,
 target.requiere_domicilio = src.requiere_domicilio,
 target.requiere_identificacion = src.requiere_identificacion,
 target.requiere_fecha_nacimiento = src.requiere_fecha_nacimiento,
 target.requiere_ocupacion = src.requiere_ocupacion,
 target.requiere_estado_civil = src.requiere_estado_civil
WHEN NOT MATCHED THEN INSERT (id_tipo_rol_persona, codigo, nombre, requiere_telefono, requiere_correo, requiere_domicilio, requiere_identificacion, requiere_fecha_nacimiento, requiere_ocupacion, requiere_estado_civil)
 VALUES (src.id_tipo_rol_persona, src.codigo, src.nombre, src.requiere_telefono, src.requiere_correo, src.requiere_domicilio, src.requiere_identificacion, src.requiere_fecha_nacimiento, src.requiere_ocupacion, src.requiere_estado_civil);
SET IDENTITY_INSERT casos.cat_tipo_rol_persona OFF;

IF NOT EXISTS (SELECT 1 FROM casos.cat_estado_caso)
BEGIN
INSERT INTO casos.cat_estado_caso
(
codigo,
nombre,
es_terminal
)
VALUES
('ABIERTO', 'Abierto', 0),
('CERRADO', 'Cerrado', 1)
END

IF NOT EXISTS (SELECT 1 FROM casos.cat_origen_caso)
BEGIN
INSERT INTO casos.cat_origen_caso
(
codigo,
nombre
)
VALUES
('DENUNCIA_PRESENCIAL', 'Denuncia presencial'),
('PARTE_POLICIAL', 'Parte policial'),
('DERIVACION', 'DerivaciÃ³n')
END
