-- =============================================================================
-- V0036__catalogo_errores.sql
-- Esquema configuracion y tablas del catálogo de errores (DDL, run-once).
-- Esquema : configuracion (creado si no existe)
-- Tablas : configuracion.cat_error_categoria
-- configuracion.cat_error_catalogo
-- El SEED (8 categorías + 118 códigos) va en R__configuracion_seeds.sql.
-- El helper resolver_mensaje_error va en R__configuracion_programmability.sql.
-- (El esquema log_tmp y log_error se crean en V0035.)
-- =============================================================================
SET NOCOUNT ON;

-- Esquema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'configuracion')
 EXEC ('CREATE SCHEMA configuracion;');
-- cat_error_categoria (8 categorías; id 500-507)
IF OBJECT_ID(N'configuracion.cat_error_categoria', N'U') IS NULL
BEGIN
 CREATE TABLE configuracion.cat_error_categoria (
 id_categoria INT NOT NULL
 CONSTRAINT PK_cat_error_categoria PRIMARY KEY,
 nombre_categoria VARCHAR(30) NOT NULL
 CONSTRAINT UQ_cat_error_categoria_nombre UNIQUE,
 descripcion varchar(200) NOT NULL,
 registrar_log boolean NOT NULL
 CONSTRAINT DF_cat_error_categoria_registrar_log DEFAULT (0),
 vigente boolean NOT NULL
 CONSTRAINT DF_cat_error_categoria_vigente DEFAULT (1)
 );
END
-- cat_error_catalogo (códigos; esquema_owner NULL = transversal)
IF OBJECT_ID(N'configuracion.cat_error_catalogo', N'U') IS NULL
BEGIN
 CREATE TABLE configuracion.cat_error_catalogo (
 id_cat_error_catalogo INT NOT NULL
 CONSTRAINT PK_cat_error_catalogo PRIMARY KEY
 CONSTRAINT CK_cat_error_catalogo_codigo CHECK (id_cat_error_catalogo >= 50001),
 esquema_owner SYSNAME NULL,
 id_categoria INT NOT NULL,
 nombre_corto VARCHAR(60) NOT NULL,
 mensaje_base varchar(500) NOT NULL,
 registrar_log_si_categoria_habilitada boolean NOT NULL
 CONSTRAINT DF_cat_error_catalogo_reg_log DEFAULT (0),
 vigente boolean NOT NULL
 CONSTRAINT DF_cat_error_catalogo_vigente DEFAULT (1),
 CONSTRAINT FK_cat_error_catalogo_categoria
 FOREIGN KEY (id_categoria)
 REFERENCES configuracion.cat_error_categoria (id_categoria),
 CONSTRAINT UQ_cat_error_catalogo_nombre UNIQUE (esquema_owner, nombre_corto)
 );
 CREATE INDEX IX_cat_error_catalogo_categoria
 ON configuracion.cat_error_catalogo (id_categoria);
END

