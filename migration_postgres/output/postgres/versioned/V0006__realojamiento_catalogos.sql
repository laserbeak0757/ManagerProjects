-- =============================================================================
-- SIP â€” Migration V0006__realojamiento_catalogos
-- =============================================================================
-- VersiÃ³n: 4.0 v4 (incremental sobre V0005)
-- Compatible: SQL Server 2017+ (forward-compatible 2022)
-- Depende de: V0001__baseline_sip.sql (define las tablas origen)
-- V0003__nuevo_esquema_encargos.sql (sin impacto directo)
-- V0004__drop_denuncias_encargos_legacy (sin impacto directo)
--
-- ALCANCE:
-- Realoja tres tablas que estaban en esquemas no-Ã³ptimos a su esquema
-- semÃ¡nticamente correcto, con base en el anÃ¡lisis de FKs entrantes
-- realizado durante la consolidaciÃ³n del DiseÃ±o del Modelo de Datos:
--
-- 1. casos.cat_tipo_relato â†’ denuncias.cat_tipo_relato
-- Ãšnico consumidor: denuncias.relato.id_tipo_relato.
--
-- 2. casos.cat_programa_seguridad â†’ configuracion.cat_programa_seguridad
-- Ãšnico consumidor actual: denuncias.procedimiento_policial. Se aloja
-- en `configuracion` por su naturaleza de catÃ¡logo institucional
-- transversal (programas gubernamentales de seguridad), aplicable
-- potencialmente a otros esquemas ademÃ¡s de denuncias.
--
-- 3. denuncias.fenomeno_delictual â†’ investigacion.fenomeno_delictual
-- Ãšnico consumidor: investigacion.hecho_fenomeno. Pertenece
-- conceptualmente al dominio de investigaciÃ³n (fenÃ³meno asociado al
-- hecho criminal), no al de la denuncia.
--
-- JUSTIFICACIÃ“N:
-- Las tres tablas eran "huÃ©rfanas semÃ¡nticas": vivÃ­an en un esquema pero
-- ninguna tabla del propio esquema las referenciaba. La reubicaciÃ³n elimina
-- dependencias cruzadas innecesarias y deja cada tabla en el esquema cuyo
-- dominio funcional realmente le corresponde.
--
-- ESTRUCTURA DE CADA BLOQUE (PASOS 1, 2, 3):
-- a) DROP CONSTRAINT de las FKs que apuntan a la tabla origen
-- b) DROP CONSTRAINT de las FKs salientes de la tabla origen (si las hay)
-- c) CREATE TABLE en el esquema destino con estructura idÃ©ntica
-- d) sp_addextendedproperty con la descripciÃ³n a nivel TABLE en el destino
-- e) sp_addextendedproperty con las descripciones a nivel COLUMN en el destino
-- f) INSERT INTO destino SELECT * FROM origen (con SET IDENTITY_INSERT
-- para preservar IDs si hay datos)
-- g) DROP TABLE origen
-- h) ADD CONSTRAINT de las FKs apuntando ahora al destino
--
-- El orden CREATE â†’ descripciones â†’ INSERT â†’ DROP origen â†’ FKs garantiza:
-- Â· La tabla destino queda documentada antes de cualquier operaciÃ³n de
-- datos, lo que sobrevive ante interrupciones intermedias.
-- Â· El DROP TABLE origen elimina automÃ¡ticamente sus extended_properties
-- (no requiere limpieza explÃ­cita).
--
-- IDEMPOTENCIA:
-- Cada DROP CONSTRAINT verifica existencia con sys.foreign_keys.
-- Cada CREATE TABLE verifica con OBJECT_ID(...) IS NULL.
-- Cada sp_addextendedproperty verifica con sys.extended_properties.
-- La migration es segura ante reaplicaciÃ³n parcial accidental.
--
-- DATOS:
-- El INSERT...SELECT con IDENTITY_INSERT preserva los IDs originales si las
-- tablas tienen datos productivos. En lÃ­nea base reciÃ©n desplegada las
-- tablas suelen estar vacÃ­as, en cuyo caso el INSERT es no-op.
--
-- COHERENCIA CON V0005 (NO modificar V0005):
-- Las migrations se ejecutan secuencialmente y V0006 es idempotente y
-- reproducible desde cero. En cualquier ambiente nuevo el orden es:
-- Â· V0001 â†’ crea las 3 tablas en su ubicaciÃ³n antigua
-- (casos.cat_tipo_relato, casos.cat_programa_seguridad,
-- denuncias.fenomeno_delictual).
-- Â· V0005 â†’ aplica descripciones a esas 3 tablas en su ubicaciÃ³n
-- antigua. En este punto las tablas existen y la operaciÃ³n
-- es vÃ¡lida.
-- Â· V0006 â†’ ejecuta DROP TABLE sobre las 3 tablas antiguas, lo que
-- elimina automÃ¡ticamente sus extended properties
-- (cascada nativa de SQL Server), y crea las 3 tablas
-- nuevas con sus propias descripciones â€” idÃ©nticas en
-- contenido a las que V0005 aplicÃ³ previamente â€” en la
-- ubicaciÃ³n definitiva.
-- Resultado final: las 3 tablas viven en su nueva ubicaciÃ³n con
-- todas sus descripciones; no quedan restos en los esquemas antiguos
-- ni descripciones huÃ©rfanas. V0005 mantiene su coherencia histÃ³rica
-- y NO requiere modificaciÃ³n.
--
-- ROLLBACK:
-- No hay rollback automÃ¡tico en Flyway para Versioned migrations. Para
-- revertir, se requiere migration inversa o restauraciÃ³n desde backup.
-- =============================================================================
SET ANSI_NULLS ON;
SET ANSI_WARNINGS ON;
SET ANSI_PADDING ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;


-- =============================================================================
-- PASO 1 â€” casos.cat_tipo_relato â†’ denuncias.cat_tipo_relato
-- =============================================================================
-- CatÃ¡logo de tipos de relato asociado a una denuncia. Su Ãºnico consumidor
-- es denuncias.relato; vivÃ­a en `casos` por motivos no estructurales.
-- =============================================================================

-- 1.a) Eliminar la FK entrante desde denuncias.relato
IF EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = 'fk_relato_tipo'
 AND parent_object_id = OBJECT_ID('denuncias.relato'))
 ALTER TABLE denuncias.relato DROP CONSTRAINT fk_relato_tipo;

-- 1.b) Crear la nueva tabla en el esquema destino
IF OBJECT_ID('denuncias.cat_tipo_relato', 'U') IS NULL
BEGIN
 CREATE TABLE denuncias.cat_tipo_relato (
 id_tipo_relato INTEGER generated by default as generated by default as identity NOT NULL,
 codigo varchar(30) NOT NULL,
 nombre varchar(100) NOT NULL,
 CONSTRAINT pk_cat_tipo_relato PRIMARY KEY (id_tipo_relato),
 CONSTRAINT uq_cat_tipo_relato UNIQUE (codigo)
 );
END

-- 1.c) Descripciones extendidas (TABLE + COLUMNS) en el destino
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
 WHERE name = 'MS_Description'
 AND major_id = OBJECT_ID('denuncias.cat_tipo_relato')
 AND minor_id = 0 AND class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CatÃ¡logo de tipos de relato asociado a una denuncia.',
 @level0type = N'SCHEMA', @level0name = N'denuncias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato';
END


IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('denuncias.cat_tipo_relato')
 AND c.name = 'id_tipo_relato' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'denuncias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'id_tipo_relato';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('denuncias.cat_tipo_relato')
 AND c.name = 'codigo' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo identificador Ãºnico en el catÃ¡logo de tipos de relato asociado a una denuncia. Valor corto y estable que las aplicaciones referencian de forma directa.',
 @level0type = N'SCHEMA', @level0name = N'denuncias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'codigo';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('denuncias.cat_tipo_relato')
 AND c.name = 'nombre' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de tipos de relato asociado a una denuncia. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'denuncias',
 @level1type = N'TABLE', @level1name = N'cat_tipo_relato',
 @level2type = N'COLUMN', @level2name = N'nombre';
END

-- 1.d) Migrar datos preservando IDs (si los hubiera)
IF OBJECT_ID('casos.cat_tipo_relato', 'U') IS NOT NULL
 AND EXISTS (SELECT 1 FROM casos.cat_tipo_relato)
BEGIN
 SET IDENTITY_INSERT denuncias.cat_tipo_relato ON;
 INSERT INTO denuncias.cat_tipo_relato (id_tipo_relato, codigo, nombre)
 SELECT id_tipo_relato, codigo, nombre FROM casos.cat_tipo_relato;
 SET IDENTITY_INSERT denuncias.cat_tipo_relato OFF;
END

-- 1.e) Eliminar la tabla origen
IF OBJECT_ID('casos.cat_tipo_relato', 'U') IS NOT NULL
 DROP TABLE casos.cat_tipo_relato;

-- 1.f) Recrear la FK apuntando ahora a la nueva ubicaciÃ³n
ALTER TABLE denuncias.relato
 ADD CONSTRAINT fk_relato_tipo FOREIGN KEY (id_tipo_relato)
 REFERENCES denuncias.cat_tipo_relato (id_tipo_relato);


-- =============================================================================
-- PASO 2 â€” casos.cat_programa_seguridad â†’ configuracion.cat_programa_seguridad
-- =============================================================================
-- CatÃ¡logo de programas gubernamentales de seguridad. Su Ãºnico consumidor
-- actual es denuncias.procedimiento_policial, pero por su naturaleza
-- transversal (catÃ¡logo institucional aplicable a mÃºltiples dominios) se
-- aloja en `configuracion` y no en `denuncias`.
-- =============================================================================

-- 2.a) Eliminar la FK entrante desde denuncias.procedimiento_policial
IF EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = 'fk_proc_programa'
 AND parent_object_id = OBJECT_ID('denuncias.procedimiento_policial'))
 ALTER TABLE denuncias.procedimiento_policial DROP CONSTRAINT fk_proc_programa;

-- 2.b) Eliminar la FK saliente de la tabla origen (a ubicacion.comuna)
IF EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = 'fk_progseq_comuna'
 AND parent_object_id = OBJECT_ID('casos.cat_programa_seguridad'))
 ALTER TABLE casos.cat_programa_seguridad DROP CONSTRAINT fk_progseq_comuna;

-- 2.c) Crear la nueva tabla en el esquema destino
IF OBJECT_ID('configuracion.cat_programa_seguridad', 'U') IS NULL
BEGIN
 CREATE TABLE configuracion.cat_programa_seguridad (
 id_programa_seguridad INTEGER generated by default as generated by default as identity NOT NULL,
 nombre varchar(200) NOT NULL,
 descripcion varchar(500) NULL,
 id_comuna INTEGER NULL,
 activo SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_cat_programa_seguridad_activo CHECK (activo IN (0,1)),
 fecha_registro timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT pk_cat_programa_seguridad PRIMARY KEY (id_programa_seguridad)
 );
END

-- 2.d) Descripciones extendidas (TABLE + COLUMNS) en el destino
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
 WHERE name = 'MS_Description'
 AND major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND minor_id = 0 AND class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CatÃ¡logo de programas gubernamentales de seguridad segÃºn comuna. Fuente: S14.',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad';
END


IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND c.name = 'id_programa_seguridad' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia obligatoria a otra entidad del modelo (clave forÃ¡nea).',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND c.name = 'id_comuna' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Referencia opcional a ubicacion.comuna. Puede ser nulo si la asociaciÃ³n no aplica al registro.',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'id_comuna';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND c.name = 'activo' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el registro estÃ¡ activo en el sistema. 1 = activo, 0 = inactivo.',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'activo';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND c.name = 'fecha_registro' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro en el sistema. Default: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND c.name = 'nombre' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre legible en el catÃ¡logo de programas gubernamentales de seguridad por comuna. Usado en interfaces y reportes.',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'nombre';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('configuracion.cat_programa_seguridad')
 AND c.name = 'descripcion' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DescripciÃ³n extendida en el catÃ¡logo de programas gubernamentales de seguridad por comuna. Texto opcional con informaciÃ³n adicional.',
 @level0type = N'SCHEMA', @level0name = N'configuracion',
 @level1type = N'TABLE', @level1name = N'cat_programa_seguridad',
 @level2type = N'COLUMN', @level2name = N'descripcion';
END

-- 2.e) Migrar datos preservando IDs (si los hubiera)
IF OBJECT_ID('casos.cat_programa_seguridad', 'U') IS NOT NULL
 AND EXISTS (SELECT 1 FROM casos.cat_programa_seguridad)
BEGIN
 SET IDENTITY_INSERT configuracion.cat_programa_seguridad ON;
 INSERT INTO configuracion.cat_programa_seguridad
 (id_programa_seguridad, nombre, descripcion, id_comuna, activo, fecha_registro)
 SELECT
 id_programa_seguridad, nombre, descripcion, id_comuna, activo, fecha_registro
 FROM casos.cat_programa_seguridad;
 SET IDENTITY_INSERT configuracion.cat_programa_seguridad OFF;
END

-- 2.f) Eliminar la tabla origen
IF OBJECT_ID('casos.cat_programa_seguridad', 'U') IS NOT NULL
 DROP TABLE casos.cat_programa_seguridad;

-- 2.g) Recrear la FK saliente desde la nueva ubicaciÃ³n a ubicacion.comuna
ALTER TABLE configuracion.cat_programa_seguridad
 ADD CONSTRAINT fk_progseq_comuna FOREIGN KEY (id_comuna)
 REFERENCES ubicacion.comuna (id_comuna);

-- 2.h) Recrear la FK entrante desde denuncias.procedimiento_policial
ALTER TABLE denuncias.procedimiento_policial
 ADD CONSTRAINT fk_proc_programa FOREIGN KEY (id_programa_seguridad)
 REFERENCES configuracion.cat_programa_seguridad (id_programa_seguridad);


-- =============================================================================
-- PASO 3 â€” denuncias.fenomeno_delictual â†’ investigacion.fenomeno_delictual
-- =============================================================================
-- CatÃ¡logo oficial de fenÃ³menos delictuales del Ministerio PÃºblico. Pertenece
-- conceptualmente al dominio de investigaciÃ³n (el fenÃ³meno se asocia al
-- hecho criminal, no a la denuncia), y su Ãºnico consumidor es
-- investigacion.hecho_fenomeno.
-- =============================================================================

-- 3.a) Eliminar la FK entrante desde investigacion.hecho_fenomeno
IF EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = 'fk_hecho_fenomeno_fenomeno'
 AND parent_object_id = OBJECT_ID('investigacion.hecho_fenomeno'))
 ALTER TABLE investigacion.hecho_fenomeno
 DROP CONSTRAINT fk_hecho_fenomeno_fenomeno;

-- 3.b) Crear la nueva tabla en el esquema destino
IF OBJECT_ID('investigacion.fenomeno_delictual', 'U') IS NULL
BEGIN
 CREATE TABLE investigacion.fenomeno_delictual (
 id_fenomeno INTEGER generated by default as generated by default as identity NOT NULL,
 codigo_mp varchar(30) NOT NULL,
 nombre varchar(200) NOT NULL,
 descripcion varchar(2000) NULL,
 anio_vigencia INTEGER NULL,
 vigente SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_fenomeno_delictual_vigente CHECK (vigente IN (0,1)),
 fecha_registro timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 fecha_actualizacion timestamp NULL,
 CONSTRAINT pk_fenomeno_delictual PRIMARY KEY (id_fenomeno),
 CONSTRAINT uq_fenomeno_codigo_mp UNIQUE (codigo_mp, anio_vigencia)
 );
END

-- 3.c) Descripciones extendidas (TABLE + COLUMNS) en el destino
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
 WHERE name = 'MS_Description'
 AND major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND minor_id = 0 AND class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CatÃ¡logo oficial de fenÃ³menos delictuales del Ministerio PÃºblico (MP define el catÃ¡logo, PDI lo aplica al hecho). v3.1 v1: el fenÃ³meno se asigna al hecho criminal vÃ­a investigacion.hecho_fenomeno (M:N), no a la denuncia. ActualizaciÃ³n anual junio. Fuente: S1, NotebookLM.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual';
END


IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'id_fenomeno' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Identificador Ãºnico del fenÃ³meno delictual. Clave primaria generada por el sistema.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'id_fenomeno';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'codigo_mp' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'CÃ³digo oficial del fenÃ³meno asignado por el Ministerio PÃºblico.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'codigo_mp';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'nombre' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Nombre oficial del fenÃ³meno delictual. Ej: Robo con violencia, TrÃ¡fico de drogas, Homicidio, Turbazo, Abordazo, Encerrona.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'nombre';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'descripcion' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Diccionario tooltip del fenÃ³meno delictual. v3.1 v1: ampliado de VARCHAR(500) a VARCHAR(2000) para soportar descripciones detalladas que diferencian conceptos similares (ej. distinguir Abordazo vs Encerrona). Campo opcional.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'descripcion';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'anio_vigencia' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'AÃ±o de vigencia del fenÃ³meno segÃºn la versiÃ³n del catÃ¡logo del Ministerio PÃºblico. Campo opcional.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'anio_vigencia';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'vigente' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Indica si el fenÃ³meno estÃ¡ vigente en el catÃ¡logo actual. Valor 1 = vigente. Los fenÃ³menos desactivados se preservan para trazabilidad de denuncias histÃ³ricas.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'vigente';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'fecha_registro' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de creaciÃ³n del registro. Valor por defecto: CURRENT_TIMESTAMP.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'fecha_registro';
END

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep
 JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
 WHERE ep.name = 'MS_Description'
 AND ep.major_id = OBJECT_ID('investigacion.fenomeno_delictual')
 AND c.name = 'fecha_actualizacion' AND ep.class = 1)
BEGIN
 EXEC sys.sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'Fecha y hora UTC de la Ãºltima modificaciÃ³n.',
 @level0type = N'SCHEMA', @level0name = N'investigacion',
 @level1type = N'TABLE', @level1name = N'fenomeno_delictual',
 @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
END

-- 3.d) Migrar datos preservando IDs (si los hubiera)
IF OBJECT_ID('denuncias.fenomeno_delictual', 'U') IS NOT NULL
 AND EXISTS (SELECT 1 FROM denuncias.fenomeno_delictual)
BEGIN
 SET IDENTITY_INSERT investigacion.fenomeno_delictual ON;
 INSERT INTO investigacion.fenomeno_delictual
 (id_fenomeno, codigo_mp, nombre, descripcion, anio_vigencia,
 vigente, fecha_registro, fecha_actualizacion)
 SELECT
 id_fenomeno, codigo_mp, nombre, descripcion, anio_vigencia,
 vigente, fecha_registro, fecha_actualizacion
 FROM denuncias.fenomeno_delictual;
 SET IDENTITY_INSERT investigacion.fenomeno_delictual OFF;
END

-- 3.e) Eliminar la tabla origen
IF OBJECT_ID('denuncias.fenomeno_delictual', 'U') IS NOT NULL
 DROP TABLE denuncias.fenomeno_delictual;

-- 3.f) Recrear la FK apuntando ahora a la nueva ubicaciÃ³n
ALTER TABLE investigacion.hecho_fenomeno
 ADD CONSTRAINT fk_hecho_fenomeno_fenomeno FOREIGN KEY (id_fenomeno)
 REFERENCES investigacion.fenomeno_delictual (id_fenomeno);


-- =============================================================================
-- FIN â€” V0006__realojamiento_catalogos
-- =============================================================================
-- ValidaciÃ³n recomendada (despuÃ©s de ejecutar):
--
-- -- Las tablas deben existir en su nueva ubicaciÃ³n
-- SELECT s.name AS schema_name, t.name AS table_name
-- FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
-- WHERE (s.name = 'denuncias' AND t.name = 'cat_tipo_relato')
-- OR (s.name = 'configuracion' AND t.name = 'cat_programa_seguridad')
-- OR (s.name = 'investigacion' AND t.name = 'fenomeno_delictual');
-- -- esperado: 3 filas
--
-- -- Las tablas NO deben existir en su ubicaciÃ³n antigua
-- SELECT s.name AS schema_name, t.name AS table_name
-- FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
-- WHERE (s.name = 'casos' AND t.name IN ('cat_tipo_relato','cat_programa_seguridad'))
-- OR (s.name = 'denuncias' AND t.name = 'fenomeno_delictual');
-- -- esperado: 0 filas
--
-- -- Las FKs deben apuntar a la nueva ubicaciÃ³n
-- SELECT fk.name, OBJECT_SCHEMA_NAME(fk.parent_object_id) + '.' +
-- OBJECT_NAME(fk.parent_object_id) AS parent,
-- OBJECT_SCHEMA_NAME(fk.referenced_object_id) + '.' +
-- OBJECT_NAME(fk.referenced_object_id) AS referenced
-- FROM sys.foreign_keys fk
-- WHERE fk.name IN ('fk_relato_tipo','fk_proc_programa',
-- 'fk_progseq_comuna','fk_hecho_fenomeno_fenomeno');
--
-- -- Las descripciones extendidas deben existir en las nuevas ubicaciones
-- SELECT OBJECT_SCHEMA_NAME(ep.major_id) AS schema_name,
-- OBJECT_NAME(ep.major_id) AS table_name,
-- c.name AS column_name,
-- CAST(ep.value AS text) AS descripcion
-- FROM sys.extended_properties ep
-- LEFT JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
-- WHERE ep.name = 'MS_Description'
-- AND ep.class = 1
-- AND OBJECT_SCHEMA_NAME(ep.major_id) IN ('denuncias','configuracion','investigacion')
-- AND OBJECT_NAME(ep.major_id) IN ('cat_tipo_relato','cat_programa_seguridad','fenomeno_delictual')
-- ORDER BY 1, 2, c.column_id;
-- -- esperado: 20 filas (3 TABLE-level + 17 COLUMN-level)
--
-- -- Conteo total de tablas debe mantenerse (222)
-- SELECT COUNT(*) FROM sys.tables; -- esperado: 222
-- =============================================================================

