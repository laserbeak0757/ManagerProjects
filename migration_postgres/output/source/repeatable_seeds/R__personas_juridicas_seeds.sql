-- =============================================================================
-- R__personas_juridicas_seeds.sql
-- =============================================================================
-- Tipo:         Repeatable (Flyway). Se reaplica cuando cambia el archivo.
-- Compatible:   SQL Server 2017+
-- Depende de:   V0017__personas_juridicas.sql (crea los catalogos)
--
-- ALCANCE:
--   Seeds idempotentes de los catalogos del esquema personas creados en V0017.
--   Orden de carga (padre -> hijo):
--     1. cat_tipo_persona        (2 filas)
--     2. cat_tipo_nombre         (2 filas)
--     3. cat_tipo_persona_juridica (38 filas)
--     4. cat_tipo_representacion (7 filas)
--     5. cat_actividad_economica (CIIU rev.4 subset, 102 filas)
--
-- IDEMPOTENCIA:
--   MERGE con match por codigo (clave de negocio). Re-ejecucion no duplica
--   ni rompe; actualiza descripcion si cambia.
--
-- POLITICA DE BORRADO:
--   No incluye WHEN NOT MATCHED BY SOURCE THEN DELETE. Preserva filas
--   manuales que algun operador haya agregado.
-- =============================================================================

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


-- =============================================================================
-- 1. cat_tipo_persona  (PADRE - todos los catalogos siguientes son hermanos)
-- =============================================================================
-- Los SPs del esquema personas usan estos IDs como contrato:
--   1 = NATURAL
--   2 = JURIDICA
-- Por eso este catalogo no puede depender del orden actual del IDENTITY. Si
-- una BD de desarrollo ya tiene estos codigos con IDs incorrectos, repararla
-- aparte antes de volver a ejecutar Flyway.

IF EXISTS (
    SELECT 1
    FROM personas.cat_tipo_persona
    WHERE codigo IN (N'NATURAL', N'JURIDICA')
      AND id_tipo_persona NOT IN (1, 2)
)
    THROW 52021, 'cat_tipo_persona contiene NATURAL/JURIDICA fuera de los IDs esperados 1 y 2.', 1;
GO

IF EXISTS (
    SELECT 1
    FROM personas.cat_tipo_persona
    WHERE (id_tipo_persona = 1 AND codigo <> N'NATURAL')
       OR (id_tipo_persona = 2 AND codigo <> N'JURIDICA')
)
    THROW 52022, 'cat_tipo_persona debe mapear 1=NATURAL y 2=JURIDICA.', 1;
GO

SET IDENTITY_INSERT personas.cat_tipo_persona ON;

;WITH src(id_tipo_persona, codigo, descripcion) AS (
    SELECT * FROM (VALUES
        (1, N'NATURAL',  N'Persona natural'),
        (2, N'JURIDICA', N'Persona juridica')
    ) v(id_tipo_persona, codigo, descripcion)
)
MERGE personas.cat_tipo_persona AS tgt
USING src ON tgt.id_tipo_persona = src.id_tipo_persona
WHEN MATCHED AND (
        tgt.codigo <> src.codigo
        OR tgt.descripcion <> src.descripcion
        OR tgt.activo <> 1
    )
    THEN UPDATE
         SET codigo = src.codigo,
             descripcion = src.descripcion,
             activo = 1
WHEN NOT MATCHED BY TARGET
    THEN INSERT (id_tipo_persona, codigo, descripcion, activo)
         VALUES (src.id_tipo_persona, src.codigo, src.descripcion, 1);

SET IDENTITY_INSERT personas.cat_tipo_persona OFF;
GO


-- =============================================================================
-- 2. cat_tipo_nombre
-- =============================================================================
;WITH src(codigo, descripcion) AS (
    SELECT * FROM (VALUES
        (N'RAZON_SOCIAL',    N'Razon social'),
        (N'NOMBRE_FANTASIA', N'Nombre de fantasia')
    ) v(codigo, descripcion)
)
MERGE personas.cat_tipo_nombre AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND tgt.descripcion <> src.descripcion
    THEN UPDATE SET descripcion = src.descripcion
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, descripcion, activo)
         VALUES (src.codigo, src.descripcion, 1);
GO


-- =============================================================================
-- 3. cat_tipo_persona_juridica
-- =============================================================================
;WITH src(codigo, descripcion) AS (
    SELECT * FROM (VALUES
        (N'SA', N'Sociedad Anónima'),
        (N'SAA', N'Sociedad Anónima Abierta'),
        (N'SAC', N'Sociedad Anónima Cerrada'),
        (N'SRL', N'Sociedad de Responsabilidad Limitada'),
        (N'SPA', N'Sociedad por Acciones'),
        (N'EIRL', N'Empresa Individual de Responsabilidad Limitada'),
        (N'SC', N'Sociedad Colectiva'),
        (N'SCS', N'Sociedad en Comandita Simple'),
        (N'SCPA', N'Sociedad en Comandita por Acciones'),
        (N'SCPA_M', N'Sociedad de Capital e Industria'),
        (N'HOLDING', N'Holding / Sociedad de Inversión'),
        (N'EE', N'Empresa del Estado'),
        (N'SE', N'Sociedad de Economía Mixta'),
        (N'COOP', N'Cooperativa'),
        (N'COOP_AH', N'Cooperativa de Ahorro y Crédito'),
        (N'COOP_TRAB', N'Cooperativa de Trabajo'),
        (N'COOP_VIV', N'Cooperativa de Vivienda'),
        (N'CORP', N'Corporación'),
        (N'FUND', N'Fundación'),
        (N'ONG', N'Organización No Gubernamental'),
        (N'ASOC', N'Asociación Gremial'),
        (N'SIND', N'Sindicato'),
        (N'SIND_EMP', N'Sindicato de Empresa'),
        (N'SIND_INT', N'Sindicato Interempresa'),
        (N'SIND_IND', N'Sindicato de Trabajadores Independientes'),
        (N'CONF', N'Confederación'),
        (N'FED', N'Federación'),
        (N'JVEC', N'Junta de Vecinos'),
        (N'ORG_COM', N'Organización Comunitaria Funcional'),
        (N'MINIST', N'Ministerio'),
        (N'SERV_PUB', N'Servicio Público'),
        (N'MUNI', N'Municipalidad'),
        (N'GOB_REG', N'Gobierno Regional (GORE)'),
        (N'FF_AA', N'Institución de las Fuerzas Armadas o de Orden'),
        (N'CONS_PUB', N'Consejo / Comisión Pública'),
        (N'IGLE', N'Entidad Religiosa'),
        (N'AG', N'Agencia de Sociedad Extranjera'),
        (N'EXT', N'Persona Jurídica Extranjera')
    ) v(codigo, descripcion)
)
MERGE personas.cat_tipo_persona_juridica AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND tgt.descripcion <> src.descripcion
    THEN UPDATE SET descripcion = src.descripcion
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, descripcion, activo)
         VALUES (src.codigo, src.descripcion, 1);
GO


-- =============================================================================
-- 4. cat_tipo_representacion
-- =============================================================================
;WITH src(codigo, descripcion) AS (
    SELECT * FROM (VALUES
        (N'REP_LEGAL', N'Representante Legal'),
        (N'GERENTE_GENERAL', N'Gerente General'),
        (N'APODERADO', N'Apoderado'),
        (N'PRESIDENTE_DIRECTORIO', N'Presidente del Directorio'),
        (N'DIRECTOR', N'Director'),
        (N'ADMINISTRADOR', N'Administrador'),
        (N'SOCIO_ADMINISTRADOR', N'Socio Administrador')
    ) v(codigo, descripcion)
)
MERGE personas.cat_tipo_representacion AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND tgt.descripcion <> src.descripcion
    THEN UPDATE SET descripcion = src.descripcion
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, descripcion, activo)
         VALUES (src.codigo, src.descripcion, 1);
GO


-- =============================================================================
-- 5. cat_actividad_economica  (CIIU rev.4 - subset operativo PDI)
-- =============================================================================
;WITH src(codigo, descripcion) AS (
    SELECT * FROM (VALUES
        (N'0111', N'Cultivo de cereales (excepto arroz), legumbres y semillas oleaginosas'),
        (N'0112', N'Cultivo de arroz'),
        (N'0113', N'Cultivo de hortalizas y melones, raíces y tubérculos'),
        (N'0121', N'Cultivo de uva'),
        (N'0130', N'Cultivo de plantas para preparar bebidas'),
        (N'1071', N'Elaboración de productos de panadería y pastelería'),
        (N'1080', N'Elaboración de alimentos preparados para animales'),
        (N'1101', N'Destilación, rectificación y mezcla de bebidas alcohólicas'),
        (N'1102', N'Elaboración de vinos'),
        (N'4711', N'Comercio al por menor en almacenes no especializados con surtido compuesto principalmente de alimentos, bebidas o tabaco'),
        (N'4719', N'Comercio al por menor en almacenes no especializados con surtido no compuesto principalmente de alimentos, bebidas o tabaco'),
        (N'4721', N'Comercio al por menor de alimentos en almacenes especializados'),
        (N'4751', N'Comercio al por menor de productos textiles en almacenes especializados'),
        (N'4771', N'Comercio al por menor de prendas de vestir, calzado y artículos de cuero'),
        (N'4773', N'Comercio al por menor de productos farmacéuticos y médicos'),
        (N'4799', N'Comercio al por menor no realizado en almacenes, puestos de venta o mercados'),
        (N'4921', N'Transporte urbano y suburbano de pasajeros'),
        (N'4922', N'Otras actividades de transporte por vía terrestre de pasajeros'),
        (N'4923', N'Transporte de carga por carretera'),
        (N'5110', N'Transporte aéreo de pasajeros'),
        (N'5120', N'Transporte aéreo de carga'),
        (N'5510', N'Actividades de alojamiento para estancias cortas'),
        (N'5520', N'Actividades de campamentos, parques de vehículos recreativos y parques de caravanas'),
        (N'5610', N'Restaurantes y servicios móviles de comida'),
        (N'5630', N'Expendio de bebidas alcohólicas para el consumo inmediato'),
        (N'5811', N'Edición de libros'),
        (N'5912', N'Actividades de producción de películas cinematográficas, videos y programas de televisión'),
        (N'6010', N'Transmisiones de radio'),
        (N'6020', N'Programación y transmisiones de televisión'),
        (N'6110', N'Actividades de telecomunicaciones alámbricas'),
        (N'6120', N'Actividades de telecomunicaciones inalámbricas'),
        (N'6190', N'Otras actividades de telecomunicaciones'),
        (N'6201', N'Actividades de programación informática'),
        (N'6202', N'Actividades de consultoría de informática y gestión de instalaciones informáticas'),
        (N'6209', N'Otras actividades de tecnología de la información y de informática'),
        (N'6311', N'Procesamiento de datos, hospedaje y actividades conexas'),
        (N'6312', N'Portales Web'),
        (N'6411', N'Banca central'),
        (N'6419', N'Otros tipos de intermediación monetaria'),
        (N'6492', N'Otras actividades de concesión de crédito'),
        (N'6499', N'Otras actividades de servicios financieros, excepto las de seguros y fondos de pensiones'),
        (N'6511', N'Seguros de vida'),
        (N'6512', N'Seguros generales'),
        (N'6810', N'Actividades inmobiliarias realizadas con bienes propios o arrendados'),
        (N'6820', N'Actividades inmobiliarias realizadas a cambio de una retribución o por contrata'),
        (N'6910', N'Actividades jurídicas'),
        (N'6920', N'Actividades de contabilidad, teneduría de libros, auditoría y consultoría fiscal'),
        (N'7010', N'Actividades de oficinas principales'),
        (N'7020', N'Actividades de consultoría de gestión'),
        (N'7110', N'Actividades de arquitectura e ingeniería y actividades conexas de consultoría técnica'),
        (N'7112', N'Actividades de ingeniería y actividades conexas de consultoría técnica'),
        (N'7120', N'Ensayos y análisis técnicos'),
        (N'7210', N'Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería'),
        (N'7220', N'Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades'),
        (N'7310', N'Publicidad'),
        (N'7490', N'Otras actividades profesionales, científicas y técnicas n.c.p.'),
        (N'7711', N'Alquiler y arrendamiento de automóviles y vehículos automotores livianos'),
        (N'7730', N'Alquiler y arrendamiento de otra maquinaria, equipo y bienes tangibles'),
        (N'7810', N'Actividades de agencias de empleo'),
        (N'7820', N'Actividades de agencias de trabajo temporal'),
        (N'8010', N'Actividades de seguridad privada'),
        (N'8020', N'Actividades de servicios de sistemas de seguridad'),
        (N'8030', N'Actividades de investigación'),
        (N'8110', N'Actividades combinadas de apoyo a instalaciones'),
        (N'8299', N'Otras actividades de servicios de apoyo a las empresas n.c.p.'),
        (N'8411', N'Actividades de la administración pública en general'),
        (N'8412', N'Regulación de las actividades de organismos que prestan servicios sanitarios, educativos, culturales y otros servicios sociales, excepto servicios de seguridad social'),
        (N'8413', N'Regulación y facilitación de la actividad económica'),
        (N'8421', N'Relaciones exteriores'),
        (N'8422', N'Actividades de defensa'),
        (N'8423', N'Orden público y actividades de seguridad'),
        (N'8424', N'Actividades de la justicia'),
        (N'8430', N'Actividades de planes de seguridad social de afiliación obligatoria'),
        (N'8510', N'Enseñanza preescolar'),
        (N'8521', N'Enseñanza primaria'),
        (N'8522', N'Enseñanza secundaria de formación general'),
        (N'8523', N'Enseñanza secundaria de formación técnica y profesional'),
        (N'8530', N'Enseñanza superior'),
        (N'8542', N'Enseñanza superior universitaria'),
        (N'8549', N'Otros tipos de enseñanza n.c.p.'),
        (N'8610', N'Actividades de hospitales'),
        (N'8620', N'Actividades de médicos y odontólogos'),
        (N'8690', N'Otras actividades de atención de la salud humana'),
        (N'8710', N'Actividades de atención de enfermería en instituciones'),
        (N'8730', N'Actividades de atención en instituciones para personas mayores y discapacitadas'),
        (N'9000', N'Actividades creativas, artísticas y de entretenimiento'),
        (N'9101', N'Actividades de bibliotecas y archivos'),
        (N'9200', N'Actividades de juegos de azar y apuestas'),
        (N'9311', N'Gestión de instalaciones deportivas'),
        (N'9312', N'Actividades de clubes deportivos'),
        (N'9319', N'Otras actividades deportivas'),
        (N'9321', N'Actividades de parques de atracciones y parques temáticos'),
        (N'9411', N'Actividades de asociaciones empresariales y de empleadores'),
        (N'9412', N'Actividades de asociaciones profesionales'),
        (N'9420', N'Actividades de sindicatos de empleados'),
        (N'9491', N'Actividades de organizaciones religiosas'),
        (N'9492', N'Actividades de organizaciones políticas'),
        (N'9499', N'Actividades de otras asociaciones n.c.p.'),
        (N'9601', N'Lavado y limpieza, incluida la limpieza en seco, de productos textiles y de piel'),
        (N'9609', N'Otras actividades de servicios personales n.c.p.'),
        (N'9700', N'Actividades de los hogares como empleadores de personal doméstico'),
        (N'9900', N'Actividades de organizaciones y órganos extraterritoriales')
    ) v(codigo, descripcion)
)
MERGE personas.cat_actividad_economica AS tgt
USING src ON tgt.codigo = src.codigo
WHEN MATCHED AND tgt.descripcion <> src.descripcion
    THEN UPDATE SET descripcion = src.descripcion
WHEN NOT MATCHED BY TARGET
    THEN INSERT (codigo, descripcion, activo)
         VALUES (src.codigo, src.descripcion, 1);
GO
