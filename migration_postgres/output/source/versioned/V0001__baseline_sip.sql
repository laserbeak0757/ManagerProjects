-- =============================================================================
-- SIP — Modelo SQL Server 2017 v4.0 v1 (16 esquemas, 206 tablas, 375 FKs)
-- =============================================================================
-- Generado desde: SIP_v3.1_v3.sql (PostgreSQL 17.9)
-- Fuente del piloto validado: SIP_v4.0_PILOTO.sql (esquemas casos + investigacion)
--
-- ALCANCE v4.0 v1:
--   Modelo completo SIP — todos los esquemas, todas las tablas, todas las FKs
--   (incluyendo las 28 FKs cruzadas que el piloto omitió por estar fuera de su
--   alcance). Total FKs: 375 (170 inline cruzadas + 205 inline intra-esquema,
--   redistribuidas según orden topológico).
--
-- DECISIONES DE TRADUCCIÓN (heredadas del piloto v4.0):
--   - Naming: lowercase preservado (consistente con v3.1 v3)
--   - Tipos:
--       TIMESTAMPTZ  → DATETIME2(7)              [precisión 100ns, sin zona]
--       VARCHAR(N)   → NVARCHAR(N)               [UTF-16 nativo SQL Server]
--       TEXT         → NVARCHAR(MAX)
--       SMALLINT     → SMALLINT                  [equivalente directo]
--       INTEGER      → INTEGER                   [equivalente directo]
--       BIGINT       → BIGINT                    [equivalente directo]
--       NUMERIC(p,s) → DECIMAL(p,s)
--       DATE         → DATE
--   - Defaults:
--       NOW() AT TIME ZONE 'UTC'                 → SYSUTCDATETIME()
--       CURRENT_TIMESTAMP                        → SYSUTCDATETIME()
--       (NOW() AT TIME ZONE 'America/Santiago')::DATE
--                                                → CAST(SYSDATETIMEOFFSET()
--                                                  AT TIME ZONE 'Pacific SA Standard Time'
--                                                  AS DATE)
--   - Identidad:
--       GENERATED ALWAYS AS IDENTITY → IDENTITY(1,1)
--   - UNIQUE NULLS NOT DISTINCT (PostgreSQL ≥15) → UNIQUE
--       Razón: SQL Server con UNIQUE estándar trata NULLs como iguales,
--       comportamiento equivalente a NULLS NOT DISTINCT de PG.
--   - Índices únicos parciales (CREATE UNIQUE INDEX ... WHERE ...) →
--       Filtered Index de SQL Server 2008+ (sintaxis idéntica).
--   - COMMENT ON ... IS '...' → sys.sp_addextendedproperty con MS_Description
--   - Collation ICU es_ci_ai → Modern_Spanish_CI_AI a nivel BD (no por columna).
--
-- ZONA HORARIA:
--   Todos los timestamps se almacenan en UTC (igual que el modelo PG v3.1 v3).
--   La conversión a hora local Chile se hace en aplicación / vistas / reportes.
--   Esto evita inconsistencias por DST (cambio de hora octubre/abril en Chile).
--
-- ORDEN DE EJECUCIÓN:
--   PASO 1: Esquemas
--   PASO 2: Tablas (orden topológico — FKs intra-esquema declaradas inline
--           sólo si la tabla referenciada ya fue creada)
--   PASO 3: FKs diferidas (ALTER TABLE) — incluye todas las cruzadas y las
--           que rompen ciclos topológicos
--   PASO 4: Índices (incluye índices únicos parciales y covering con INCLUDE)
--   PASO 5: Descripciones (sys.sp_addextendedproperty)
--
-- PRERREQUISITO:
--   CREATE DATABASE [SIP] COLLATE Modern_Spanish_CI_AI;
--   GO
--   USE [SIP];
--   GO
-- =============================================================================

-- =============================================================================
-- PASO 1 — ESQUEMAS
-- =============================================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'analitica')
    EXEC('CREATE SCHEMA [analitica]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'archivos')
    EXEC('CREATE SCHEMA [archivos]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'casos')
    EXEC('CREATE SCHEMA [casos]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'catalogo_bienes')
    EXEC('CREATE SCHEMA [catalogo_bienes]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'configuracion')
    EXEC('CREATE SCHEMA [configuracion]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'cooperacion_int')
    EXEC('CREATE SCHEMA [cooperacion_int]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'denuncias')
    EXEC('CREATE SCHEMA [denuncias]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'diligencias')
    EXEC('CREATE SCHEMA [diligencias]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'evidencias')
    EXEC('CREATE SCHEMA [evidencias]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'investigacion')
    EXEC('CREATE SCHEMA [investigacion]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'migracion')
    EXEC('CREATE SCHEMA [migracion]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'organizacion')
    EXEC('CREATE SCHEMA [organizacion]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'personas')
    EXEC('CREATE SCHEMA [personas]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'tareas')
    EXEC('CREATE SCHEMA [tareas]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'ubicacion')
    EXEC('CREATE SCHEMA [ubicacion]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'vehiculos')
    EXEC('CREATE SCHEMA [vehiculos]');
GO


-- =============================================================================
-- PASO 2 — TABLAS (orden topológico)
-- =============================================================================


-- ----- Esquema: configuracion -----

-- Tabla: configuracion.cat_dominio
CREATE TABLE [configuracion].[cat_dominio] (
    id_dominio INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(50) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    CONSTRAINT pk_cat_dominio PRIMARY KEY (id_dominio),
    CONSTRAINT uq_cat_dominio_codigo UNIQUE (codigo)
);
GO


-- ----- Esquema: tareas -----

-- Tabla: tareas.tipo_tarea
CREATE TABLE [tareas].[tipo_tarea] (
    id_tipo_tarea INTEGER NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    requiere_aprobacion SMALLINT NOT NULL DEFAULT 0
 CONSTRAINT ck_tipo_tarea_requiere_aprobacion CHECK (requiere_aprobacion IN (0,1)),
    permite_adjuntar_archivos SMALLINT NOT NULL DEFAULT 0
 CONSTRAINT ck_tipo_tarea_permite_adjuntar_archivos CHECK (permite_adjuntar_archivos IN (0,1)),
    CONSTRAINT pk_tipo_tarea PRIMARY KEY (id_tipo_tarea),
    CONSTRAINT uq_tipo_tarea_nombre UNIQUE (nombre)
);
GO

-- Tabla: tareas.tipo_estado_tarea
CREATE TABLE [tareas].[tipo_estado_tarea] (
    id_tipo_estado_tarea INTEGER NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_tipo_estado_tarea PRIMARY KEY (id_tipo_estado_tarea),
    CONSTRAINT uq_tipo_estado_tarea_nombre UNIQUE (nombre)
);
GO

-- Tabla: tareas.tipo_documento
CREATE TABLE [tareas].[tipo_documento] (
    id_tipo_documento INTEGER NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    vigente SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_tipo_documento_vigente CHECK (vigente IN (0,1)),
    CONSTRAINT pk_tipo_documento PRIMARY KEY (id_tipo_documento),
    CONSTRAINT uq_tipo_documento_nombre UNIQUE (nombre)
);
GO

-- Tabla: tareas.bandeja
CREATE TABLE [tareas].[bandeja] (
    id_bandeja INT IDENTITY(1,1) NOT NULL,
    id_unidad INTEGER NULL,
    id_funcionario INTEGER NULL,
    CONSTRAINT pk_bandeja PRIMARY KEY (id_bandeja),
    CONSTRAINT ck_bandeja_un_solo_propietario CHECK ( (id_unidad IS NOT NULL AND id_funcionario IS NULL) OR (id_unidad IS NULL AND id_funcionario IS NOT NULL) )
);
GO


-- ----- Esquema: ubicacion -----

-- Tabla: ubicacion.cat_tipo_calle
CREATE TABLE [ubicacion].[cat_tipo_calle] (
    id_tipo_calle INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_calle PRIMARY KEY (id_tipo_calle)
);
GO

-- Tabla: ubicacion.cat_tipo_residencia
CREATE TABLE [ubicacion].[cat_tipo_residencia] (
    id_tipo_residencia INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_residencia PRIMARY KEY (id_tipo_residencia)
);
GO

-- Tabla: ubicacion.cat_tipo_lugar
CREATE TABLE [ubicacion].[cat_tipo_lugar] (
    id_tipo_lugar INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_lugar PRIMARY KEY (id_tipo_lugar),
    CONSTRAINT uq_cat_tipo_lugar_codigo UNIQUE (codigo)
);
GO

-- Tabla: ubicacion.cat_rol_lugar
CREATE TABLE [ubicacion].[cat_rol_lugar] (
    id_rol_lugar INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_rol_lugar PRIMARY KEY (id_rol_lugar),
    CONSTRAINT uq_cat_rol_lugar_codigo UNIQUE (codigo)
);
GO

-- Tabla: ubicacion.pais
CREATE TABLE [ubicacion].[pais] (
    id_pais INTEGER NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    codigo_iso_alpha_3 NCHAR(3) NOT NULL,
    codigo_iso_alpha_2 NCHAR(2) NOT NULL,
    CONSTRAINT pk_pais PRIMARY KEY (id_pais),
    CONSTRAINT uq_pais_iso UNIQUE (codigo_iso_alpha_3)
);
GO

-- Tabla: ubicacion.cat_tipo_subdivision
CREATE TABLE [ubicacion].[cat_tipo_subdivision] (
    id_tipo_subdivision INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_tipo_subdivision_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_cat_tipo_subdivision PRIMARY KEY (id_tipo_subdivision),
    CONSTRAINT uq_cat_tipo_subdivision_codigo UNIQUE (codigo)
);
GO


-- ----- Esquema: organizacion -----

-- Tabla: organizacion.cat_tipo_relacion_unidad
CREATE TABLE [organizacion].[cat_tipo_relacion_unidad] (
    id_tipo_relacion_unidad INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_rel_unidad PRIMARY KEY (id_tipo_relacion_unidad),
    CONSTRAINT uq_cat_tipo_rel_unidad_codigo UNIQUE (codigo)
);
GO

-- Tabla: organizacion.cat_cargo_funcion
CREATE TABLE [organizacion].[cat_cargo_funcion] (
    id_cargo_funcion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_cargo_funcion PRIMARY KEY (id_cargo_funcion),
    CONSTRAINT uq_cat_cargo_codigo UNIQUE (codigo)
);
GO

-- Tabla: organizacion.cat_tipo_unidad
CREATE TABLE [organizacion].[cat_tipo_unidad] (
    id_tipo_unidad INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_unidad PRIMARY KEY (id_tipo_unidad),
    CONSTRAINT uq_cat_tipo_unidad_codigo UNIQUE (codigo)
);
GO

-- Tabla: organizacion.cat_organismo_externo
CREATE TABLE [organizacion].[cat_organismo_externo] (
    id_organismo_externo INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    tipo_organismo NVARCHAR(30) NOT NULL,
    nivel NVARCHAR(20) NOT NULL DEFAULT 'NACIONAL',
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_organismo_externo_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_organismo_externo PRIMARY KEY (id_organismo_externo),
    CONSTRAINT uq_cat_organismo_externo_codigo UNIQUE (codigo)
);
GO


-- ----- Esquema: personas -----

-- Tabla: personas.cat_genero
CREATE TABLE [personas].[cat_genero] (
    id_genero INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_genero PRIMARY KEY (id_genero)
);
GO

-- Tabla: personas.cat_nacionalidad
CREATE TABLE [personas].[cat_nacionalidad] (
    id_nacionalidad INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    codigo_iso_alpha_3 NCHAR(3) NOT NULL,
    codigo_iso_alpha_2 NCHAR(2) NOT NULL,
    CONSTRAINT pk_cat_nacionalidad PRIMARY KEY (id_nacionalidad)
);
GO

-- Tabla: personas.cat_tipo_documento
CREATE TABLE [personas].[cat_tipo_documento] (
    id_tipo_documento INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_documento PRIMARY KEY (id_tipo_documento)
);
GO

-- Tabla: personas.cat_tipo_telefono
CREATE TABLE [personas].[cat_tipo_telefono] (
    id_tipo_telefono INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_telefono PRIMARY KEY (id_tipo_telefono)
);
GO

-- Tabla: personas.cat_tipo_red_social
CREATE TABLE [personas].[cat_tipo_red_social] (
    id_tipo_red_social INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_red_social PRIMARY KEY (id_tipo_red_social)
);
GO

-- Tabla: personas.cat_tipo_relacion
CREATE TABLE [personas].[cat_tipo_relacion] (
    id_tipo_relacion INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    es_bidireccional SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_relacion_es_bidireccional CHECK (es_bidireccional IN (0,1)),
    CONSTRAINT pk_cat_tipo_relacion PRIMARY KEY (id_tipo_relacion)
);
GO

-- Tabla: personas.cat_nivel_escolaridad
CREATE TABLE [personas].[cat_nivel_escolaridad] (
    id_nivel_escolaridad INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    orden INTEGER NOT NULL,
    CONSTRAINT pk_cat_nivel_escolaridad PRIMARY KEY (id_nivel_escolaridad)
);
GO

-- Tabla: personas.cat_ocupacion
CREATE TABLE [personas].[cat_ocupacion] (
    id_ocupacion INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    codigo_sii NVARCHAR(10) NULL,
    CONSTRAINT pk_cat_ocupacion PRIMARY KEY (id_ocupacion)
);
GO

-- Tabla: personas.cat_tipo_estado_civil
CREATE TABLE [personas].[cat_tipo_estado_civil] (
    id_tipo_estado_civil INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_estado_civil PRIMARY KEY (id_tipo_estado_civil)
);
GO

-- Tabla: personas.cat_tipo_anotacion
CREATE TABLE [personas].[cat_tipo_anotacion] (
    id_tipo_anotacion INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_anotacion PRIMARY KEY (id_tipo_anotacion)
);
GO

-- Tabla: personas.cat_tipo_fotografia
CREATE TABLE [personas].[cat_tipo_fotografia] (
    id_tipo_fotografia INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_fotografia PRIMARY KEY (id_tipo_fotografia)
);
GO

-- Tabla: personas.cat_complexion
CREATE TABLE [personas].[cat_complexion] (
    id_complexion INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_complexion PRIMARY KEY (id_complexion)
);
GO

-- Tabla: personas.cat_color_piel
CREATE TABLE [personas].[cat_color_piel] (
    id_color_piel INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_color_piel PRIMARY KEY (id_color_piel)
);
GO

-- Tabla: personas.cat_color_ojos
CREATE TABLE [personas].[cat_color_ojos] (
    id_color_ojos INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_color_ojos PRIMARY KEY (id_color_ojos)
);
GO

-- Tabla: personas.cat_color_cabello
CREATE TABLE [personas].[cat_color_cabello] (
    id_color_cabello INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_color_cabello PRIMARY KEY (id_color_cabello)
);
GO

-- Tabla: personas.cat_tipo_cabello
CREATE TABLE [personas].[cat_tipo_cabello] (
    id_tipo_cabello INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_cabello PRIMARY KEY (id_tipo_cabello)
);
GO

-- Tabla: personas.cat_forma_rostro
CREATE TABLE [personas].[cat_forma_rostro] (
    id_forma_rostro INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_forma_rostro PRIMARY KEY (id_forma_rostro)
);
GO

-- Tabla: personas.cat_tipo_rasgo_distintivo
CREATE TABLE [personas].[cat_tipo_rasgo_distintivo] (
    id_tipo_rasgo INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_rasgo PRIMARY KEY (id_tipo_rasgo)
);
GO

-- Tabla: personas.cat_ubicacion_corporal
CREATE TABLE [personas].[cat_ubicacion_corporal] (
    id_ubicacion_corporal INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_ubicacion_corporal PRIMARY KEY (id_ubicacion_corporal)
);
GO

-- Tabla: personas.cat_tipo_biometrico
CREATE TABLE [personas].[cat_tipo_biometrico] (
    id_tipo_biometrico INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_tipo_biometrico PRIMARY KEY (id_tipo_biometrico)
);
GO

-- Tabla: personas.cat_sexo
CREATE TABLE [personas].[cat_sexo] (
    id_sexo INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_sexo PRIMARY KEY (id_sexo)
);
GO


-- ----- Esquema: vehiculos -----

-- Tabla: vehiculos.cat_tipo
CREATE TABLE [vehiculos].[cat_tipo] (
    id_tipo_vehiculo INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_veh_cat_tipo PRIMARY KEY (id_tipo_vehiculo)
);
GO

-- Tabla: vehiculos.cat_color
CREATE TABLE [vehiculos].[cat_color] (
    id_color INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    codigo_hex NVARCHAR(7) NULL,
    CONSTRAINT pk_veh_cat_color PRIMARY KEY (id_color)
);
GO

-- Tabla: vehiculos.cat_tipo_relacion_persona
CREATE TABLE [vehiculos].[cat_tipo_relacion_persona] (
    id_tipo_relacion_vehiculo INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_veh_cat_tipo_rel PRIMARY KEY (id_tipo_relacion_vehiculo)
);
GO

-- Tabla: vehiculos.cat_marca
CREATE TABLE [vehiculos].[cat_marca] (
    id_marca INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_veh_cat_marca PRIMARY KEY (id_marca)
);
GO


-- ----- Esquema: archivos -----

-- Tabla: archivos.cat_tipo_archivo
CREATE TABLE [archivos].[cat_tipo_archivo] (
    id_tipo_archivo INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    es_multimedia SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_archivo_es_multimedia CHECK (es_multimedia IN (0,1)),
    tamanio_max_mb INTEGER NULL,
    CONSTRAINT pk_cat_tipo_archivo PRIMARY KEY (id_tipo_archivo),
    CONSTRAINT uq_cat_tipo_archivo_codigo UNIQUE (codigo)
);
GO

-- Tabla: archivos.cat_nivel_confidencialidad
CREATE TABLE [archivos].[cat_nivel_confidencialidad] (
    id_nivel INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_cat_nivel_confidencialidad PRIMARY KEY (id_nivel),
    CONSTRAINT uq_cat_nivel_codigo UNIQUE (codigo)
);
GO


-- ----- Esquema: casos -----

-- Tabla: casos.cat_estado_caso
CREATE TABLE [casos].[cat_estado_caso] (
    id_estado_caso INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    es_terminal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_estado_caso_es_terminal CHECK (es_terminal IN (0,1)),
    CONSTRAINT pk_cat_estado_caso PRIMARY KEY (id_estado_caso),
    CONSTRAINT uq_cat_estado_caso UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_prioridad
CREATE TABLE [casos].[cat_prioridad] (
    id_prioridad INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    orden INTEGER NOT NULL,
    color NVARCHAR(7) NULL,
    CONSTRAINT pk_cat_prioridad PRIMARY KEY (id_prioridad),
    CONSTRAINT uq_cat_prioridad UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_complejidad
CREATE TABLE [casos].[cat_complejidad] (
    id_complejidad INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_complejidad PRIMARY KEY (id_complejidad),
    CONSTRAINT uq_cat_complejidad UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_tipo_rol_persona
CREATE TABLE [casos].[cat_tipo_rol_persona] (
    id_tipo_rol_persona INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    requiere_telefono SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_telefono CHECK (requiere_telefono IN (0,1)),
    requiere_correo SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_correo CHECK (requiere_correo IN (0,1)),
    requiere_domicilio SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_domicilio CHECK (requiere_domicilio IN (0,1)),
    requiere_identificacion SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_identificacion CHECK (requiere_identificacion IN (0,1)),
    requiere_fecha_nacimiento SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_fecha_nacimiento CHECK (requiere_fecha_nacimiento IN (0,1)),
    requiere_ocupacion SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_ocupacion CHECK (requiere_ocupacion IN (0,1)),
    requiere_estado_civil SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_rol_persona_requiere_estado_civil CHECK (requiere_estado_civil IN (0,1)),
    CONSTRAINT pk_cat_tipo_rol PRIMARY KEY (id_tipo_rol_persona),
    CONSTRAINT uq_cat_tipo_rol UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_tipo_relato
CREATE TABLE [casos].[cat_tipo_relato] (
    id_tipo_relato INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_relato PRIMARY KEY (id_tipo_relato),
    CONSTRAINT uq_cat_tipo_relato UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_origen_caso
CREATE TABLE [casos].[cat_origen_caso] (
    id_origen_caso INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_origen_caso PRIMARY KEY (id_origen_caso),
    CONSTRAINT uq_cat_origen_caso UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_nivel_seguridad
CREATE TABLE [casos].[cat_nivel_seguridad] (
    id_nivel_seguridad INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    bloquea_busqueda_externa SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_nivel_seguridad_bloquea_busqueda_externa CHECK (bloquea_busqueda_externa IN (0,1)),
    orden INTEGER NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_nivel_seguridad_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_nivel_seguridad PRIMARY KEY (id_nivel_seguridad),
    CONSTRAINT uq_cat_nivel_seguridad_codigo UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_grupo_operativo
CREATE TABLE [casos].[cat_grupo_operativo] (
    id_grupo_operativo INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_grupo_operativo_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_grupo_operativo PRIMARY KEY (id_grupo_operativo),
    CONSTRAINT uq_cat_grupo_operativo_codigo UNIQUE (codigo)
);
GO

-- Tabla: casos.cat_programa_seguridad
CREATE TABLE [casos].[cat_programa_seguridad] (
    id_programa_seguridad INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(500) NULL,
    id_comuna INTEGER NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_programa_seguridad_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_cat_programa_seguridad PRIMARY KEY (id_programa_seguridad)
);
GO

-- Tabla: casos.carpeta
CREATE TABLE [casos].[carpeta] (
    id_carpeta INTEGER IDENTITY(1,1) NOT NULL,
    folio NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(300) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    id_unidad_responsable INTEGER NOT NULL,
    id_funcionario_creador INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_carpeta PRIMARY KEY (id_carpeta),
    CONSTRAINT uq_carpeta_folio UNIQUE (folio)
);
GO


-- ----- Esquema: investigacion -----

-- Tabla: investigacion.cat_seccion_catalogo
CREATE TABLE [investigacion].[cat_seccion_catalogo] (
    id_seccion_catalogo INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(20) NOT NULL,
    descripcion NVARCHAR(200) NULL,
    CONSTRAINT pk_cat_seccion_catalogo PRIMARY KEY (id_seccion_catalogo),
    CONSTRAINT uq_cat_seccion_catalogo UNIQUE (nombre)
);
GO

-- Tabla: investigacion.cat_familia_delito
CREATE TABLE [investigacion].[cat_familia_delito] (
    id_familia_delito INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    CONSTRAINT pk_cat_familia_delito PRIMARY KEY (id_familia_delito),
    CONSTRAINT uq_cat_familia_delito UNIQUE (nombre)
);
GO

-- Tabla: investigacion.cat_delito
CREATE TABLE [investigacion].[cat_delito] (
    id_delito INTEGER IDENTITY(1,1) NOT NULL,
    codigo_capj INTEGER NOT NULL,
    nombre NVARCHAR(300) NOT NULL,
    cuerpo_legal NVARCHAR(200) NULL,
    articulo_legal NVARCHAR(100) NULL,
    requiere_peritaje_adn SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_delito_requiere_peritaje_adn CHECK (requiere_peritaje_adn IN (0,1)),
    vigente SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_delito_vigente CHECK (vigente IN (0,1)),
    fecha_inicio_vigencia DATE NULL,
    fecha_fin_vigencia DATE NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_delito PRIMARY KEY (id_delito),
    CONSTRAINT uq_cat_delito_codigo UNIQUE (codigo_capj)
);
GO

-- Tabla: investigacion.cat_grado_participacion
CREATE TABLE [investigacion].[cat_grado_participacion] (
    id_grado_participacion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    articulo_cp NVARCHAR(20) NULL,
    CONSTRAINT pk_cat_grado_participacion PRIMARY KEY (id_grado_participacion),
    CONSTRAINT uq_cat_grado_part UNIQUE (codigo)
);
GO

-- Tabla: investigacion.cat_grado_ejecucion
CREATE TABLE [investigacion].[cat_grado_ejecucion] (
    id_grado_ejecucion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_grado_ejecucion PRIMARY KEY (id_grado_ejecucion),
    CONSTRAINT uq_cat_grado_ejec UNIQUE (codigo)
);
GO

-- Tabla: investigacion.cat_circunstancia_modificatoria
CREATE TABLE [investigacion].[cat_circunstancia_modificatoria] (
    id_circunstancia INTEGER IDENTITY(1,1) NOT NULL,
    tipo NVARCHAR(20) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(300) NOT NULL,
    articulo_cp NVARCHAR(50) NULL,
    CONSTRAINT pk_cat_circunstancia PRIMARY KEY (id_circunstancia),
    CONSTRAINT uq_cat_circunstancia UNIQUE (codigo)
);
GO

-- Tabla: investigacion.cat_forma_contacto
CREATE TABLE [investigacion].[cat_forma_contacto] (
    id_forma_contacto INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    vigente SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_cat_forma_contacto_vigente CHECK (vigente IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_forma_contacto PRIMARY KEY (id_forma_contacto),
    CONSTRAINT uq_cat_forma_contacto_codigo UNIQUE (codigo)
);
GO

-- Tabla: investigacion.cat_punto_acceso
CREATE TABLE [investigacion].[cat_punto_acceso] (
    id_punto_acceso INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    vigente SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_cat_punto_acceso_vigente CHECK (vigente IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_punto_acceso PRIMARY KEY (id_punto_acceso),
    CONSTRAINT uq_cat_punto_acceso_codigo UNIQUE (codigo)
);
GO

-- Tabla: investigacion.cat_transporte_utilizado
CREATE TABLE [investigacion].[cat_transporte_utilizado] (
    id_transporte INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    vigente SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_cat_transporte_utilizado_vigente CHECK (vigente IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_transporte_utilizado PRIMARY KEY (id_transporte),
    CONSTRAINT uq_cat_transporte_utilizado_codigo UNIQUE (codigo)
);
GO

-- Tabla: investigacion.cat_movil
CREATE TABLE [investigacion].[cat_movil] (
    id_movil INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    aplica_homicidio SMALLINT NOT NULL DEFAULT 0
 CONSTRAINT ck_cat_movil_aplica_homicidio CHECK (aplica_homicidio IN (0,1)),
    aplica_secuestro SMALLINT NOT NULL DEFAULT 0
 CONSTRAINT ck_cat_movil_aplica_secuestro CHECK (aplica_secuestro IN (0,1)),
    vigente SMALLINT NOT NULL DEFAULT 1
 CONSTRAINT ck_cat_movil_vigente CHECK (vigente IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_movil PRIMARY KEY (id_movil),
    CONSTRAINT uq_cat_movil_codigo UNIQUE (codigo)
);
GO


-- ----- Esquema: denuncias -----

-- Tabla: denuncias.cat_tipo_denuncia
CREATE TABLE [denuncias].[cat_tipo_denuncia] (
    id_tipo_denuncia INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_tipo_denuncia_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_tipo_denuncia PRIMARY KEY (id_tipo_denuncia),
    CONSTRAINT uq_cat_tipo_denuncia_codigo UNIQUE (codigo)
);
GO

-- Tabla: denuncias.fenomeno_delictual
CREATE TABLE [denuncias].[fenomeno_delictual] (
    id_fenomeno INTEGER IDENTITY(1,1) NOT NULL,
    codigo_mp NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    anio_vigencia INTEGER NULL,
    vigente SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_fenomeno_delictual_vigente CHECK (vigente IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_fenomeno_delictual PRIMARY KEY (id_fenomeno),
    CONSTRAINT uq_fenomeno_codigo_mp UNIQUE (codigo_mp, anio_vigencia)
);
GO

-- Tabla: denuncias.procedimiento_policial
CREATE TABLE [denuncias].[procedimiento_policial] (
    id_procedimiento INTEGER IDENTITY(1,1) NOT NULL,
    folio_bitacora NVARCHAR(50) NOT NULL,
    folio_externo NVARCHAR(50) NULL,
    id_caso INTEGER NULL,
    id_clasificacion_delito_principal INTEGER NULL,
    id_lugar INTEGER NULL,
    tipo_procedimiento NVARCHAR(50) NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'CREADO',
    id_fiscalia INTEGER NULL,
    id_fiscal INTEGER NULL,
    id_funcionario_responsable INTEGER NOT NULL,
    id_programa_seguridad INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_procedimiento_policial PRIMARY KEY (id_procedimiento),
    CONSTRAINT uq_procedimiento_folio UNIQUE (folio_bitacora)
);
GO

-- Tabla: denuncias.encargo_persona
CREATE TABLE [denuncias].[encargo_persona] (
    id_encargo_persona INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_caso INTEGER NULL,
    tipo_encargo NVARCHAR(20) NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    motivo NVARCHAR(500) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    n_encargo_nacional NVARCHAR(50) NULL,
    id_funcionario_registra INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_encargo_persona PRIMARY KEY (id_encargo_persona),
    CONSTRAINT CHK_encargo_persona_tipo CHECK (tipo_encargo IN ('DETENCION','ARRESTO','BUSQUEDA','CITACION')),
    CONSTRAINT CHK_encargo_persona_estado CHECK (estado IN ('ACTIVO','CANCELADO','CUMPLIDO'))
);
GO


-- ----- Esquema: diligencias -----

-- Tabla: diligencias.cat_estado_diligencia
CREATE TABLE [diligencias].[cat_estado_diligencia] (
    id_estado_diligencia INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_estado_dil PRIMARY KEY (id_estado_diligencia),
    CONSTRAINT uq_cat_estado_dil UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_tipo_instruccion
CREATE TABLE [diligencias].[cat_tipo_instruccion] (
    id_tipo_instruccion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_inst PRIMARY KEY (id_tipo_instruccion),
    CONSTRAINT uq_cat_tipo_inst UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_estado_instruccion
CREATE TABLE [diligencias].[cat_estado_instruccion] (
    id_estado_instruccion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_estado_inst PRIMARY KEY (id_estado_instruccion),
    CONSTRAINT uq_cat_estado_inst UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_tipo_detencion
CREATE TABLE [diligencias].[cat_tipo_detencion] (
    id_tipo_detencion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_det PRIMARY KEY (id_tipo_detencion),
    CONSTRAINT uq_cat_tipo_det UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_tipo_peritaje
CREATE TABLE [diligencias].[cat_tipo_peritaje] (
    id_tipo_peritaje INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_per PRIMARY KEY (id_tipo_peritaje),
    CONSTRAINT uq_cat_tipo_per UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_tipo_informe
CREATE TABLE [diligencias].[cat_tipo_informe] (
    id_tipo_informe INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_inf PRIMARY KEY (id_tipo_informe),
    CONSTRAINT uq_cat_tipo_inf UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_tipo_notificacion_externa
CREATE TABLE [diligencias].[cat_tipo_notificacion_externa] (
    id_tipo_notificacion_externa INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    actualiza_estado_caso SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_notificacion_externa_actualiza_estado_caso CHECK (actualiza_estado_caso IN (0,1)),
    CONSTRAINT pk_cat_tipo_notif PRIMARY KEY (id_tipo_notificacion_externa),
    CONSTRAINT uq_cat_tipo_notif UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_fuente_observacion_externa
CREATE TABLE [diligencias].[cat_fuente_observacion_externa] (
    id_fuente_observacion_externa INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_fuente_obs PRIMARY KEY (id_fuente_observacion_externa),
    CONSTRAINT uq_cat_fuente_obs UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_tipo_diligencia
CREATE TABLE [diligencias].[cat_tipo_diligencia] (
    id_tipo_diligencia INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    es_primera_diligencia SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_diligencia_es_primera_diligencia CHECK (es_primera_diligencia IN (0,1)),
    requiere_autorizacion_judicial SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_diligencia_requiere_autorizacion_judicial CHECK (requiere_autorizacion_judicial IN (0,1)),
    CONSTRAINT pk_cat_tipo_dil PRIMARY KEY (id_tipo_diligencia),
    CONSTRAINT uq_cat_tipo_dil_codigo UNIQUE (codigo)
);
GO

-- Tabla: diligencias.cat_especialidad_pericial
CREATE TABLE [diligencias].[cat_especialidad_pericial] (
    id_especialidad_pericial INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    unidad_lacrim NVARCHAR(200) NULL,
    descripcion NVARCHAR(300) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_especialidad_pericial_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_especialidad_pericial PRIMARY KEY (id_especialidad_pericial),
    CONSTRAINT uq_cat_esp_pericial_codigo UNIQUE (codigo)
);
GO

-- Tabla: diligencias.orden_detencion
CREATE TABLE [diligencias].[orden_detencion] (
    id_orden_detencion INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    tipo NVARCHAR(20) NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'VIGENTE',
    motivo NVARCHAR(500) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    es_secreta SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_orden_detencion_es_secreta CHECK (es_secreta IN (0,1)),
    id_funcionario_registra INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_orden_detencion PRIMARY KEY (id_orden_detencion),
    CONSTRAINT CHK_od_tipo CHECK (tipo IN ('DIRECTA','INVESTIGATIVA'))
);
GO

-- Tabla: diligencias.orden_arresto
CREATE TABLE [diligencias].[orden_arresto] (
    id_orden_arresto INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'VIGENTE',
    motivo NVARCHAR(500) NOT NULL,
    fecha_emision DATE NOT NULL,
    comprobante_pago NVARCHAR(100) NULL,
    monto_deuda DECIMAL(12,2) NULL,
    id_funcionario_registra INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_orden_arresto PRIMARY KEY (id_orden_arresto)
);
GO


-- ----- Esquema: catalogo_bienes -----

-- Tabla: catalogo_bienes.version_catalogo
CREATE TABLE [catalogo_bienes].[version_catalogo] (
    id_version INTEGER IDENTITY(1,1) NOT NULL,
    codigo_version NVARCHAR(10) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    fecha_carga DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    es_vigente SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_version_catalogo_es_vigente CHECK (es_vigente IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    CONSTRAINT pk_version_catalogo PRIMARY KEY (id_version),
    CONSTRAINT uq_version_catalogo UNIQUE (codigo_version)
);
GO


-- ----- Esquema: evidencias -----

-- Tabla: evidencias.cat_estado_especie
CREATE TABLE [evidencias].[cat_estado_especie] (
    id_estado_especie INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    es_salida_definitiva SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_estado_especie_es_salida_definitiva CHECK (es_salida_definitiva IN (0,1)),
    CONSTRAINT pk_cat_estado_especie PRIMARY KEY (id_estado_especie),
    CONSTRAINT uq_cat_estado_especie UNIQUE (codigo)
);
GO

-- Tabla: evidencias.cat_tipo_custodia
CREATE TABLE [evidencias].[cat_tipo_custodia] (
    id_tipo_custodia INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_tipo_custodia PRIMARY KEY (id_tipo_custodia),
    CONSTRAINT uq_cat_tipo_custodia UNIQUE (codigo)
);
GO

-- Tabla: evidencias.cat_institucion
CREATE TABLE [evidencias].[cat_institucion] (
    id_institucion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    CONSTRAINT pk_cat_institucion PRIMARY KEY (id_institucion),
    CONSTRAINT uq_cat_institucion UNIQUE (codigo)
);
GO

-- Tabla: evidencias.cat_proposito_transferencia
CREATE TABLE [evidencias].[cat_proposito_transferencia] (
    id_proposito INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_cat_proposito PRIMARY KEY (id_proposito),
    CONSTRAINT uq_cat_proposito UNIQUE (codigo)
);
GO

-- Tabla: evidencias.cat_tipo_extension_especie
CREATE TABLE [evidencias].[cat_tipo_extension_especie] (
    id_tipo_extension_especie INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    requiere_extension SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_cat_tipo_extension_especie_requiere_extension CHECK (requiere_extension IN (0,1)),
    CONSTRAINT pk_cat_tipo_extension_especie PRIMARY KEY (id_tipo_extension_especie),
    CONSTRAINT uq_cat_tipo_extension_especie UNIQUE (codigo)
);
GO

-- Tabla: evidencias.cat_clasificacion_arma
CREATE TABLE [evidencias].[cat_clasificacion_arma] (
    id_clasificacion_arma INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_clasificacion_arma_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_clasificacion_arma PRIMARY KEY (id_clasificacion_arma),
    CONSTRAINT uq_cat_clasarma_codigo UNIQUE (codigo)
);
GO

-- Tabla: evidencias.cat_catalogo_armas
CREATE TABLE [evidencias].[cat_catalogo_armas] (
    id_catalogo_arma INTEGER IDENTITY(1,1) NOT NULL,
    familia NVARCHAR(100) NOT NULL,
    tipo_arma NVARCHAR(100) NOT NULL,
    marca NVARCHAR(100) NULL,
    modelo NVARCHAR(100) NULL,
    calibre NVARCHAR(50) NULL,
    pais_fabricante NVARCHAR(100) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_catalogo_armas_activo CHECK (activo IN (0,1)),
    dgmn_ref NVARCHAR(50) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_cat_catalogo_armas PRIMARY KEY (id_catalogo_arma)
);
GO

-- Tabla: evidencias.cat_droga
CREATE TABLE [evidencias].[cat_droga] (
    id_droga INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    alias NVARCHAR(200) NULL,
    unidad_medida NVARCHAR(50) NOT NULL,
    categoria_legal NVARCHAR(100) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_droga_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_cat_droga PRIMARY KEY (id_droga),
    CONSTRAINT uq_cat_droga_nombre UNIQUE (nombre)
);
GO

-- Tabla: evidencias.incautacion
CREATE TABLE [evidencias].[incautacion] (
    id_incautacion INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_diligencia INTEGER NULL,
    id_lugar INTEGER NULL,
    fecha_incautacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_responsable INTEGER NOT NULL,
    id_funcionario_incautacion INTEGER NULL,
    acta_generada SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_incautacion_acta_generada CHECK (acta_generada IN (0,1)),
    numero_acta NVARCHAR(50) NULL,
    observaciones NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_region_incautacion INTEGER NULL,
    CONSTRAINT pk_incautacion PRIMARY KEY (id_incautacion)
);
GO


-- ----- Esquema: migracion -----

-- Tabla: migracion.cat_tipo_infraccion_migratoria
CREATE TABLE [migracion].[cat_tipo_infraccion_migratoria] (
    id_tipo_infraccion INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(500) NULL,
    base_legal NVARCHAR(200) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_tipo_infraccion_migratoria_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_tipo_infraccion_mig PRIMARY KEY (id_tipo_infraccion),
    CONSTRAINT uq_cat_infraccion_mig_codigo UNIQUE (codigo)
);
GO

-- Tabla: migracion.fiscalizacion_planificada
CREATE TABLE [migracion].[fiscalizacion_planificada] (
    id_fiscalizacion INTEGER IDENTITY(1,1) NOT NULL,
    id_unidad INTEGER NOT NULL,
    descripcion NVARCHAR(500) NOT NULL,
    fecha_planificacion DATE NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'PLANIFICADA',
    id_funcionario_responsable INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_fiscalizacion_planificada PRIMARY KEY (id_fiscalizacion)
);
GO


-- ----- Esquema: cooperacion_int -----

-- Tabla: cooperacion_int.cat_cooperacion_internacional
CREATE TABLE [cooperacion_int].[cat_cooperacion_internacional] (
    id_cat_cooperacion_internacional INTEGER NOT NULL,
    codigo NVARCHAR(50) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    CONSTRAINT pk_cat_cooperacion_internacional PRIMARY KEY (id_cat_cooperacion_internacional),
    CONSTRAINT uq_cat_cooperacion_internacional_codigo UNIQUE (codigo)
);
GO

-- Tabla: cooperacion_int.estado_solicitud_interpol
CREATE TABLE [cooperacion_int].[estado_solicitud_interpol] (
    id_estado_solicitud INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_estado_solicitud_interpol_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_estado_solicitud_interpol PRIMARY KEY (id_estado_solicitud),
    CONSTRAINT uq_estado_solicitud_nombre UNIQUE (nombre)
);
GO

-- Tabla: cooperacion_int.entidad_interpol
CREATE TABLE [cooperacion_int].[entidad_interpol] (
    id_entidad INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    es_pdi SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_entidad_interpol_es_pdi CHECK (es_pdi IN (0,1)),
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_entidad_interpol_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_entidad_interpol PRIMARY KEY (id_entidad)
);
GO


-- ----- Esquema: analitica -----

-- Tabla: analitica.cat_tipo_reporte
CREATE TABLE [analitica].[cat_tipo_reporte] (
    id_tipo_reporte INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_tipo_reporte_activo CHECK (activo IN (0,1)),
    CONSTRAINT pk_cat_tipo_reporte PRIMARY KEY (id_tipo_reporte),
    CONSTRAINT uq_cat_tipo_reporte_codigo UNIQUE (codigo)
);
GO


-- ----- Esquema: configuracion -----

-- Tabla: configuracion.cat_elemento_dominio
CREATE TABLE [configuracion].[cat_elemento_dominio] (
    id_elemento_dominio INTEGER IDENTITY(1,1) NOT NULL,
    id_dominio INTEGER NOT NULL,
    codigo NVARCHAR(50) NOT NULL,
    etiqueta NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    orden INTEGER NOT NULL DEFAULT 0,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_elemento_dominio_activo CHECK (activo IN (0,1)),
    valor_int INTEGER NULL,
    valor_nvarchar NVARCHAR(200) NULL,
    CONSTRAINT pk_cat_elemento_dominio PRIMARY KEY (id_elemento_dominio),
    CONSTRAINT uq_cat_elemento_dominio_cod UNIQUE (id_dominio, codigo),
    CONSTRAINT fk_elemento_dominio FOREIGN KEY (id_dominio) REFERENCES configuracion.cat_dominio (id_dominio)
);
GO


-- ----- Esquema: tareas -----

-- Tabla: tareas.tarea
CREATE TABLE [tareas].[tarea] (
    id_tarea INT IDENTITY(1,1) NOT NULL,
    id_tipo_tarea INTEGER NOT NULL,
    id_estado_tarea_actual INT NULL,
    id_tarea_dependiente INT NULL,
    CONSTRAINT pk_tarea PRIMARY KEY (id_tarea),
    CONSTRAINT fk_tarea_tipo FOREIGN KEY (id_tipo_tarea) REFERENCES tareas.tipo_tarea(id_tipo_tarea),
    CONSTRAINT fk_tarea_dependiente FOREIGN KEY (id_tarea_dependiente) REFERENCES tareas.tarea(id_tarea)
);
GO

-- Tabla: tareas.documento
CREATE TABLE [tareas].[documento] (
    id_documento INT IDENTITY(1,1) NOT NULL,
    id_tipo_documento INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_registro INTEGER NOT NULL,
    fecha_anulacion DATETIME2(7) NULL,
    id_funcionario_anulacion INTEGER NULL,
    CONSTRAINT pk_documento PRIMARY KEY (id_documento),
    CONSTRAINT fk_documento_tipo FOREIGN KEY (id_tipo_documento) REFERENCES tareas.tipo_documento(id_tipo_documento)
);
GO

-- Tabla: tareas.tipo_tarea_tipo_documento
CREATE TABLE [tareas].[tipo_tarea_tipo_documento] (
    id_tipo_tarea INTEGER NOT NULL,
    id_tipo_documento INTEGER NOT NULL,
    CONSTRAINT pk_tipo_tarea_tipo_documento PRIMARY KEY (id_tipo_tarea, id_tipo_documento),
    CONSTRAINT fk_tttd_tarea FOREIGN KEY (id_tipo_tarea) REFERENCES tareas.tipo_tarea(id_tipo_tarea),
    CONSTRAINT fk_tttd_doc FOREIGN KEY (id_tipo_documento) REFERENCES tareas.tipo_documento(id_tipo_documento)
);
GO


-- ----- Esquema: ubicacion -----

-- Tabla: ubicacion.region
CREATE TABLE [ubicacion].[region] (
    id_region INTEGER NOT NULL,
    id_pais INTEGER NOT NULL,
    descripcion NVARCHAR(200) NOT NULL,
    orden INTEGER NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY (id_region),
    CONSTRAINT fk_region_pais FOREIGN KEY (id_pais) REFERENCES ubicacion.pais (id_pais)
);
GO


-- ----- Esquema: organizacion -----

-- Tabla: organizacion.unidad
CREATE TABLE [organizacion].[unidad] (
    id_unidad INTEGER IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    acronimo NVARCHAR(20) NULL,
    id_tipo_unidad INTEGER NOT NULL,
    especialidad_delictual NVARCHAR(200) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    es_lacrim SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_unidad_es_lacrim CHECK (es_lacrim IN (0,1)),
    ambito_geografico NVARCHAR(20) NULL DEFAULT 'REGIONAL',
    CONSTRAINT pk_unidad PRIMARY KEY (id_unidad),
    CONSTRAINT uq_unidad_codigo UNIQUE (codigo),
    CONSTRAINT fk_unidad_tipo FOREIGN KEY (id_tipo_unidad) REFERENCES organizacion.cat_tipo_unidad (id_tipo_unidad)
);
GO


-- ----- Esquema: personas -----

-- Tabla: personas.persona
CREATE TABLE [personas].[persona] (
    id_persona INTEGER IDENTITY(1,1) NOT NULL,
    fecha_nacimiento DATE NULL,
    fecha_defuncion DATE NULL,
    id_sexo INTEGER NULL,
    id_genero INTEGER NULL,
    id_pais_nacionalidad INTEGER NULL,
    id_comuna_nacimiento INTEGER NULL,
    es_identificable SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_persona_es_identificable CHECK (es_identificable IN (0,1)),
    domicilio_extranjero SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_persona_domicilio_extranjero CHECK (domicilio_extranjero IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_persona PRIMARY KEY (id_persona),
    CONSTRAINT fk_persona_sexo FOREIGN KEY (id_sexo) REFERENCES personas.cat_sexo (id_sexo),
    CONSTRAINT fk_persona_genero FOREIGN KEY (id_genero) REFERENCES personas.cat_genero (id_genero)
);
GO


-- ----- Esquema: vehiculos -----

-- Tabla: vehiculos.cat_modelo
CREATE TABLE [vehiculos].[cat_modelo] (
    id_modelo INTEGER IDENTITY(1,1) NOT NULL,
    id_marca INTEGER NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_veh_cat_modelo PRIMARY KEY (id_modelo),
    CONSTRAINT fk_modelo_marca FOREIGN KEY (id_marca) REFERENCES vehiculos.cat_marca (id_marca)
);
GO


-- ----- Esquema: archivos -----

-- Tabla: archivos.archivo
CREATE TABLE [archivos].[archivo] (
    id_archivo INTEGER IDENTITY(1,1) NOT NULL,
    nombre_original NVARCHAR(300) NOT NULL,
    nombre_almacenado NVARCHAR(300) NOT NULL,
    ruta NVARCHAR(500) NOT NULL,
    mime_type NVARCHAR(100) NOT NULL,
    extension NVARCHAR(10) NULL,
    tamano_bytes BIGINT NULL,
    hash_sha256 NVARCHAR(64) NULL,
    id_tipo_archivo INTEGER NOT NULL,
    id_nivel_confidencialidad INTEGER NULL,
    id_funcionario_carga INTEGER NOT NULL,
    origen NVARCHAR(50) NULL,
    id_archivo_version_anterior INTEGER NULL,
    numero_version INTEGER NOT NULL DEFAULT 1,
    fecha_carga DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    motivo_eliminacion NVARCHAR(500) NULL,
    CONSTRAINT pk_archivo PRIMARY KEY (id_archivo),
    CONSTRAINT fk_archivo_tipo FOREIGN KEY (id_tipo_archivo) REFERENCES archivos.cat_tipo_archivo (id_tipo_archivo),
    CONSTRAINT fk_archivo_nivel FOREIGN KEY (id_nivel_confidencialidad) REFERENCES archivos.cat_nivel_confidencialidad (id_nivel),
    CONSTRAINT fk_archivo_version FOREIGN KEY (id_archivo_version_anterior) REFERENCES archivos.archivo (id_archivo)
);
GO


-- ----- Esquema: casos -----

-- Tabla: casos.carpeta_colaborador
CREATE TABLE [casos].[carpeta_colaborador] (
    id_carpeta_colaborador INTEGER IDENTITY(1,1) NOT NULL,
    id_carpeta INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    rol NVARCHAR(50) NOT NULL DEFAULT 'COLABORADOR',
    id_funcionario_invitador INTEGER NULL,
    fecha_ingreso DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_salida DATETIME2(7) NULL,
    CONSTRAINT pk_carpeta_colaborador PRIMARY KEY (id_carpeta_colaborador),
    CONSTRAINT fk_colabcarp_carpeta FOREIGN KEY (id_carpeta) REFERENCES casos.carpeta (id_carpeta),
    CONSTRAINT uq_carpeta_colaborador UNIQUE (id_carpeta, id_funcionario, fecha_ingreso)
);
GO

-- Tabla: casos.caso
CREATE TABLE [casos].[caso] (
    id_caso INTEGER IDENTITY(1,1) NOT NULL,
    folio NVARCHAR(30) NOT NULL,
    id_carpeta INTEGER NOT NULL,
    ruc NVARCHAR(15) NULL,
    ric NVARCHAR(30) NULL,
    bitacora_web_ref NVARCHAR(50) NULL,
    id_estado_caso INTEGER NOT NULL,
    id_origen_caso INTEGER NOT NULL,
    id_prioridad INTEGER NULL,
    id_complejidad INTEGER NULL,
    titulo NVARCHAR(300) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    fecha_apertura DATE NOT NULL,
    fecha_cierre DATE NULL,
    fecha_formalizacion DATE NULL,
    fecha_plazo_investigacion DATE NULL,
    fecha_resultado DATE NULL,
    resultado_caso NVARCHAR(100) NULL,
    notas_fiscalia NVARCHAR(4000) NULL,
    fecha_ultima_consulta_siau DATE NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    id_nivel_seguridad INTEGER NULL,
    id_grupo_operativo INTEGER NULL,
    fecha_endoso DATETIME2(7) NULL,
    fecha_plazo_gestion_interna DATE NULL,
    contexto_etiqueta NVARCHAR(100) NULL,
    tipo_resultado_admin NVARCHAR(30) NULL,
    folio_brain NVARCHAR(50) NULL,
    CONSTRAINT pk_caso PRIMARY KEY (id_caso),
    CONSTRAINT uq_caso_folio UNIQUE (folio),
    CONSTRAINT fk_caso_carpeta FOREIGN KEY (id_carpeta) REFERENCES casos.carpeta (id_carpeta),
    CONSTRAINT fk_caso_estado FOREIGN KEY (id_estado_caso) REFERENCES casos.cat_estado_caso (id_estado_caso),
    CONSTRAINT fk_caso_origen FOREIGN KEY (id_origen_caso) REFERENCES casos.cat_origen_caso (id_origen_caso),
    CONSTRAINT fk_caso_prioridad FOREIGN KEY (id_prioridad) REFERENCES casos.cat_prioridad (id_prioridad),
    CONSTRAINT fk_caso_complejidad FOREIGN KEY (id_complejidad) REFERENCES casos.cat_complejidad (id_complejidad),
    CONSTRAINT fk_caso_nivel_seguridad FOREIGN KEY (id_nivel_seguridad) REFERENCES casos.cat_nivel_seguridad (id_nivel_seguridad),
    CONSTRAINT fk_caso_grupo_operativo FOREIGN KEY (id_grupo_operativo) REFERENCES casos.cat_grupo_operativo (id_grupo_operativo)
);
GO


-- ----- Esquema: investigacion -----

-- Tabla: investigacion.clasificacion_delito
CREATE TABLE [investigacion].[clasificacion_delito] (
    id_clasificacion_delito INTEGER IDENTITY(1,1) NOT NULL,
    id_delito INTEGER NOT NULL,
    id_seccion_catalogo INTEGER NOT NULL,
    id_familia_delito INTEGER NOT NULL,
    CONSTRAINT pk_clasificacion_delito PRIMARY KEY (id_clasificacion_delito),
    CONSTRAINT uq_clasificacion_delito UNIQUE (id_delito, id_seccion_catalogo),
    CONSTRAINT fk_clasdel_delito FOREIGN KEY (id_delito) REFERENCES investigacion.cat_delito (id_delito),
    CONSTRAINT fk_clasdel_seccion FOREIGN KEY (id_seccion_catalogo) REFERENCES investigacion.cat_seccion_catalogo (id_seccion_catalogo),
    CONSTRAINT fk_clasdel_familia FOREIGN KEY (id_familia_delito) REFERENCES investigacion.cat_familia_delito (id_familia_delito)
);
GO

-- Tabla: investigacion.hecho
CREATE TABLE [investigacion].[hecho] (
    id_hecho INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NULL,
    descripcion NVARCHAR(MAX) NOT NULL,
    fecha_ocurrencia DATETIME2(7) NULL,
    fecha_ocurrencia_aproximada SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_hecho_fecha_ocurrencia_aproximada CHECK (fecha_ocurrencia_aproximada IN (0,1)),
    hora_ocurrencia_ajustada SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_hecho_hora_ocurrencia_ajustada CHECK (hora_ocurrencia_ajustada IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    tipo_declaracion NVARCHAR(30) NULL,
    id_forma_contacto INTEGER NULL,
    id_punto_acceso INTEGER NULL,
    id_transporte INTEGER NULL,
    CONSTRAINT pk_hecho PRIMARY KEY (id_hecho),
    CONSTRAINT uq_hecho_caso UNIQUE (id_hecho, id_caso),
    CONSTRAINT fk_hecho_forma_contacto FOREIGN KEY (id_forma_contacto) REFERENCES investigacion.cat_forma_contacto (id_forma_contacto),
    CONSTRAINT fk_hecho_punto_acceso FOREIGN KEY (id_punto_acceso) REFERENCES investigacion.cat_punto_acceso (id_punto_acceso),
    CONSTRAINT fk_hecho_transporte FOREIGN KEY (id_transporte) REFERENCES investigacion.cat_transporte_utilizado (id_transporte)
);
GO


-- ----- Esquema: denuncias -----

-- Tabla: denuncias.denuncia
CREATE TABLE [denuncias].[denuncia] (
    id_denuncia INTEGER IDENTITY(1,1) NOT NULL,
    folio NVARCHAR(30) NOT NULL,
    folio_externo NVARCHAR(50) NULL,
    id_organismo_origen_externo INTEGER NULL,
    id_caso INTEGER NULL,
    fecha_denuncia DATETIME2(7) NOT NULL,
    canal_recepcion NVARCHAR(50) NOT NULL,
    lugar_ingreso NVARCHAR(200) NULL,
    id_funcionario_receptor INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    id_tipo_denuncia INTEGER NOT NULL,
    estado_denuncia NVARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
    indicador_vif SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_denuncia_indicador_vif CHECK (indicador_vif IN (0,1)),
    dominio_propiedad SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_denuncia_dominio_propiedad CHECK (dominio_propiedad IN (0,1)),
    observaciones NVARCHAR(4000) NULL,
    prefolio NVARCHAR(50) NULL,
    fecha_envio_fiscalia DATETIME2(7) NULL,
    estado_envio_fiscalia NVARCHAR(20) NULL DEFAULT 'PENDIENTE',
    estado_borrador NVARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
    es_flagrancia SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_denuncia_es_flagrancia CHECK (es_flagrancia IN (0,1)),
    fecha_detencion_previa DATETIME2(7) NULL,
    fecha_envio_mp DATETIME2(7) NULL,
    CONSTRAINT pk_denuncia PRIMARY KEY (id_denuncia),
    CONSTRAINT uq_denuncia_folio UNIQUE (folio),
    CONSTRAINT fk_denuncia_tipo FOREIGN KEY (id_tipo_denuncia) REFERENCES denuncias.cat_tipo_denuncia (id_tipo_denuncia),
    CONSTRAINT ck_denuncia_folio_externo_consistente CHECK ( (folio_externo IS NULL AND id_organismo_origen_externo IS NULL) OR (folio_externo IS NOT NULL AND id_organismo_origen_externo IS NOT NULL) )
);
GO

-- Tabla: denuncias.procedimiento_persona
CREATE TABLE [denuncias].[procedimiento_persona] (
    id_procedimiento_persona INTEGER IDENTITY(1,1) NOT NULL,
    id_procedimiento INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    condicion NVARCHAR(20) NOT NULL,
    es_menor_edad SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_procedimiento_persona_es_menor_edad CHECK (es_menor_edad IN (0,1)),
    id_funcionario_registra INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    observaciones NVARCHAR(500) NULL,
    CONSTRAINT pk_procedimiento_persona PRIMARY KEY (id_procedimiento_persona),
    CONSTRAINT uq_proc_persona UNIQUE (id_procedimiento, id_persona, condicion),
    CONSTRAINT fk_procpers_proc FOREIGN KEY (id_procedimiento) REFERENCES denuncias.procedimiento_policial (id_procedimiento)
);
GO


-- ----- Esquema: diligencias -----

-- Tabla: diligencias.instruccion_fiscal
CREATE TABLE [diligencias].[instruccion_fiscal] (
    id_instruccion_fiscal INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    folio_externo NVARCHAR(50) NULL,
    id_tipo_instruccion INTEGER NOT NULL,
    id_estado INTEGER NOT NULL,
    id_unidad_destinataria INTEGER NULL,
    emitida_por NVARCHAR(200) NULL,
    fecha_emision DATE NOT NULL,
    fecha_recepcion DATE NULL,
    fecha_vencimiento DATE NULL,
    resumen NVARCHAR(4000) NOT NULL,
    id_nivel_confidencialidad INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    es_orden_verbal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_instruccion_fiscal_es_orden_verbal CHECK (es_orden_verbal IN (0,1)),
    nombre_juez_verbal NVARCHAR(200) NULL,
    es_secreto SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_instruccion_fiscal_es_secreto CHECK (es_secreto IN (0,1)),
    id_denuncia INTEGER NULL,
    CONSTRAINT pk_instruccion_fiscal PRIMARY KEY (id_instruccion_fiscal),
    CONSTRAINT fk_instfisc_tipo FOREIGN KEY (id_tipo_instruccion) REFERENCES diligencias.cat_tipo_instruccion (id_tipo_instruccion),
    CONSTRAINT fk_instfisc_est FOREIGN KEY (id_estado) REFERENCES diligencias.cat_estado_instruccion (id_estado_instruccion),
    CONSTRAINT uq_instruccion_caso UNIQUE (id_instruccion_fiscal, id_caso),
    CONSTRAINT uq_instruccion_fiscal_folio_externo UNIQUE (folio_externo)
);
GO

-- Tabla: diligencias.notificacion_externa
CREATE TABLE [diligencias].[notificacion_externa] (
    id_notificacion_externa INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_tipo_notificacion_externa INTEGER NOT NULL,
    id_fuente_observacion_externa INTEGER NOT NULL,
    organismo_emisor NVARCHAR(200) NULL,
    tribunal NVARCHAR(200) NULL,
    referencia_externa NVARCHAR(50) NULL,
    fecha_evento DATETIME2(7) NOT NULL,
    fecha_observacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    resumen NVARCHAR(4000) NOT NULL,
    id_estado_caso_resultante INTEGER NULL,
    id_funcionario_registra INTEGER NOT NULL,
    id_archivo INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_notif_externa PRIMARY KEY (id_notificacion_externa),
    CONSTRAINT fk_notif_tipo FOREIGN KEY (id_tipo_notificacion_externa) REFERENCES diligencias.cat_tipo_notificacion_externa (id_tipo_notificacion_externa),
    CONSTRAINT fk_notif_fuente FOREIGN KEY (id_fuente_observacion_externa) REFERENCES diligencias.cat_fuente_observacion_externa (id_fuente_observacion_externa)
);
GO


-- ----- Esquema: catalogo_bienes -----

-- Tabla: catalogo_bienes.segmento
CREATE TABLE [catalogo_bienes].[segmento] (
    id_segmento INTEGER IDENTITY(1,1) NOT NULL,
    id_version INTEGER NOT NULL,
    codigo NCHAR(2) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_segmento_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_segmento PRIMARY KEY (id_segmento),
    CONSTRAINT uq_segmento_codigo_version UNIQUE (codigo, id_version),
    CONSTRAINT fk_segmento_version FOREIGN KEY (id_version) REFERENCES catalogo_bienes.version_catalogo (id_version)
);
GO

-- Tabla: catalogo_bienes.codigo_reemplazado
CREATE TABLE [catalogo_bienes].[codigo_reemplazado] (
    codigo_anterior NVARCHAR(8) NOT NULL,
    codigo_nuevo NVARCHAR(8) NOT NULL,
    id_version_cambio INTEGER NOT NULL,
    nivel AS (CASE LEN(codigo_anterior)
 WHEN 2 THEN 'S'
 WHEN 4 THEN 'F'
 WHEN 6 THEN 'C'
 WHEN 8 THEN 'P'
 END) PERSISTED,
    CONSTRAINT pk_codigo_reemplazado PRIMARY KEY (codigo_anterior, codigo_nuevo),
    CONSTRAINT fk_codigo_reemplazado_version FOREIGN KEY (id_version_cambio) REFERENCES catalogo_bienes.version_catalogo (id_version),
    CONSTRAINT ck_codigo_reemplazado_longitud CHECK (LEN(codigo_anterior) = LEN(codigo_nuevo)),
    CONSTRAINT ck_codigo_reemplazado_longitud_valida CHECK (LEN(codigo_anterior) IN (2, 4, 6, 8))
);
GO


-- ----- Esquema: evidencias -----

-- Tabla: evidencias.arma
CREATE TABLE [evidencias].[arma] (
    id_arma INTEGER IDENTITY(1,1) NOT NULL,
    numero_serie NVARCHAR(100) NULL,
    codigo_dgmn NVARCHAR(50) NULL,
    id_catalogo_arma INTEGER NULL,
    id_clasificacion_arma INTEGER NULL,
    inscrita SMALLINT NULL CONSTRAINT ck_arma_inscrita CHECK (inscrita IN (0,1)),
    pais_fabricante NVARCHAR(100) NULL,
    estado_conservacion NVARCHAR(50) NULL,
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    origen_recuperacion NVARCHAR(50) NULL,
    estado_legal NVARCHAR(30) NULL,
    es_mencionada SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_arma_es_mencionada CHECK (es_mencionada IN (0,1)),
    familia_arma NVARCHAR(30) NULL,
    tiene_capacidad_disparo_real SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_arma_tiene_capacidad_disparo_real CHECK (tiene_capacidad_disparo_real IN (0,1)),
    fuente_datos NVARCHAR(20) NULL DEFAULT 'OFICIAL',
    tipo_registro NVARCHAR(20) NOT NULL DEFAULT 'EVIDENCIA',
    mundo_registro NVARCHAR(10) NOT NULL DEFAULT 'MUNDO1',
    CONSTRAINT pk_arma PRIMARY KEY (id_arma),
    CONSTRAINT uq_arma_serie UNIQUE (numero_serie),
    CONSTRAINT fk_arma_clasificacion FOREIGN KEY (id_clasificacion_arma) REFERENCES evidencias.cat_clasificacion_arma (id_clasificacion_arma),
    CONSTRAINT fk_arma_catalogo FOREIGN KEY (id_catalogo_arma) REFERENCES evidencias.cat_catalogo_armas (id_catalogo_arma)
);
GO

-- Tabla: evidencias.evidencia
CREATE TABLE [evidencias].[evidencia] (
    id_evidencia INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_hecho INTEGER NULL,
    id_diligencia INTEGER NULL,
    descripcion NVARCHAR(2000) NOT NULL,
    id_lugar_hallazgo INTEGER NULL,
    fecha_hallazgo DATETIME2(7) NULL,
    fecha_incautacion DATETIME2(7) NULL,
    id_funcionario_incautador INTEGER NULL,
    acta_incautacion_ref NVARCHAR(100) NULL,
    bitacora_web_ref NVARCHAR(50) NULL,
    observaciones NVARCHAR(2000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    id_incautacion INTEGER NULL,
    nue NVARCHAR(50) NULL,
    fecha_fijacion DATETIME2(7) NULL,
    CONSTRAINT pk_evidencia PRIMARY KEY (id_evidencia),
    CONSTRAINT uq_evidencia_caso UNIQUE (id_evidencia, id_caso),
    CONSTRAINT fk_evi_incautacion FOREIGN KEY (id_incautacion) REFERENCES evidencias.incautacion (id_incautacion)
);
GO


-- ----- Esquema: migracion -----

-- Tabla: migracion.denuncia_administrativa_migratoria
CREATE TABLE [migracion].[denuncia_administrativa_migratoria] (
    id_denuncia_mig INTEGER IDENTITY(1,1) NOT NULL,
    folio NVARCHAR(30) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_infraccion INTEGER NOT NULL,
    descripcion_infraccion NVARCHAR(2000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    generada_en_ausencia SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_denuncia_administrativa_migratoria_generada_en_ausencia CHECK (generada_en_ausencia IN (0,1)),
    estado NVARCHAR(20) NOT NULL DEFAULT 'REGISTRADA',
    fecha_envio_sermig DATETIME2(7) NULL,
    sermig_ref NVARCHAR(50) NULL,
    id_funcionario INTEGER NOT NULL,
    id_unidad INTEGER NULL,
    observaciones NVARCHAR(1000) NULL,
    fecha_salida_fisica DATETIME2(7) NULL,
    id_fiscalizacion INTEGER NULL,
    CONSTRAINT pk_denuncia_mig PRIMARY KEY (id_denuncia_mig),
    CONSTRAINT uq_denuncia_mig_folio UNIQUE (folio),
    CONSTRAINT fk_denmig_infraccion FOREIGN KEY (id_tipo_infraccion) REFERENCES migracion.cat_tipo_infraccion_migratoria (id_tipo_infraccion),
    CONSTRAINT fk_dam_fiscalizacion FOREIGN KEY (id_fiscalizacion) REFERENCES migracion.fiscalizacion_planificada (id_fiscalizacion)
);
GO


-- ----- Esquema: cooperacion_int -----

-- Tabla: cooperacion_int.cat_elemento_cooperacion_internacional
CREATE TABLE [cooperacion_int].[cat_elemento_cooperacion_internacional] (
    id_cat_elemento_cooperacion_internacional INTEGER IDENTITY(1,1) NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    id_cat_cooperacion_internacional INTEGER NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_cat_elemento_cooperacion_internacional_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_cat_elemento_cooperacion_internacional PRIMARY KEY (id_cat_elemento_cooperacion_internacional),
    CONSTRAINT fk_cat_cooperacion_internacional FOREIGN KEY (id_cat_cooperacion_internacional) REFERENCES cooperacion_int.cat_cooperacion_internacional (id_cat_cooperacion_internacional)
);
GO


-- ----- Esquema: analitica -----

-- Tabla: analitica.reporte_analitico
CREATE TABLE [analitica].[reporte_analitico] (
    id_reporte INTEGER IDENTITY(1,1) NOT NULL,
    folio NVARCHAR(30) NOT NULL,
    correlativo_anual INTEGER NOT NULL,
    anio INTEGER NOT NULL,
    id_tipo_reporte INTEGER NOT NULL,
    id_funcionario_autor INTEGER NOT NULL,
    id_unidad INTEGER NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
    estado_revision NVARCHAR(20) NULL,
    motivo_rechazo NVARCHAR(500) NULL,
    fecha_elaboracion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_aprobacion DATETIME2(7) NULL,
    fecha_envio DATETIME2(7) NULL,
    destinatario NVARCHAR(300) NULL,
    id_archivo INTEGER NULL,
    id_funcionario_aprueba INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    metodologia NVARCHAR(2000) NULL,
    sugerencia_agrupacion_rucs NVARCHAR(500) NULL,
    tipo_destinatario NVARCHAR(20) NULL DEFAULT 'INVESTIGATIVO',
    CONSTRAINT pk_reporte_analitico PRIMARY KEY (id_reporte),
    CONSTRAINT uq_reporte_analitico_folio UNIQUE (folio),
    CONSTRAINT uq_reporte_correlativo_anio UNIQUE (correlativo_anual, anio),
    CONSTRAINT fk_reporte_tipo FOREIGN KEY (id_tipo_reporte) REFERENCES analitica.cat_tipo_reporte (id_tipo_reporte)
);
GO

-- Tabla: analitica.configuracion_reporte_periodico
CREATE TABLE [analitica].[configuracion_reporte_periodico] (
    id_configuracion INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    id_tipo_reporte INTEGER NOT NULL,
    frecuencia NVARCHAR(20) NOT NULL,
    destinatario_externo NVARCHAR(200) NULL,
    organismo NVARCHAR(200) NULL,
    formato_salida NVARCHAR(20) NOT NULL DEFAULT 'PDF',
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_configuracion_reporte_periodico_activo CHECK (activo IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_config_reporte_periodico PRIMARY KEY (id_configuracion),
    CONSTRAINT fk_confrep_tipo FOREIGN KEY (id_tipo_reporte) REFERENCES analitica.cat_tipo_reporte (id_tipo_reporte)
);
GO


-- ----- Esquema: tareas -----

-- Tabla: tareas.estado_tarea
CREATE TABLE [tareas].[estado_tarea] (
    id_estado_tarea INT IDENTITY(1,1) NOT NULL,
    id_tarea INT NOT NULL,
    id_tipo_estado_tarea INTEGER NOT NULL,
    fecha_estado DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_estado INTEGER NULL,
    id_bandeja INT NOT NULL,
    id_bandeja_aprobacion INT NULL,
    comentario NVARCHAR(MAX) NULL,
    fecha_limite_respuesta DATETIME2(7) NULL,
    CONSTRAINT pk_estado_tarea PRIMARY KEY (id_estado_tarea),
    CONSTRAINT fk_estado_tarea_tarea FOREIGN KEY (id_tarea) REFERENCES tareas.tarea(id_tarea) ON DELETE CASCADE,
    CONSTRAINT fk_estado_tarea_tipo FOREIGN KEY (id_tipo_estado_tarea) REFERENCES tareas.tipo_estado_tarea(id_tipo_estado_tarea),
    CONSTRAINT fk_estado_tarea_bandeja FOREIGN KEY (id_bandeja) REFERENCES tareas.bandeja(id_bandeja),
    CONSTRAINT fk_estado_tarea_bandeja_aprob FOREIGN KEY (id_bandeja_aprobacion) REFERENCES tareas.bandeja(id_bandeja)
);
GO

-- Tabla: tareas.version_documento
CREATE TABLE [tareas].[version_documento] (
    id_version_documento INT IDENTITY(1,1) NOT NULL,
    id_documento INT NOT NULL,
    fecha_version DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_version INTEGER NOT NULL,
    id_archivo_por_visar INTEGER NULL,
    id_funcionario_visado INTEGER NULL,
    comentario_visado NVARCHAR(MAX) NULL,
    fecha_visado DATETIME2(7) NULL,
    id_archivo_firmado INTEGER NULL,
    fecha_firmado DATETIME2(7) NULL,
    CONSTRAINT pk_version_documento PRIMARY KEY (id_version_documento),
    CONSTRAINT fk_version_documento_doc FOREIGN KEY (id_documento) REFERENCES tareas.documento(id_documento) ON DELETE CASCADE
);
GO

-- Tabla: tareas.tarea_denuncia
CREATE TABLE [tareas].[tarea_denuncia] (
    id_tarea INT NOT NULL,
    id_denuncia INTEGER NOT NULL,
    CONSTRAINT pk_tarea_denuncia PRIMARY KEY (id_tarea),
    CONSTRAINT uq_tarea_denuncia_denuncia UNIQUE (id_denuncia),
    CONSTRAINT fk_tarea_denuncia_tarea FOREIGN KEY (id_tarea) REFERENCES tareas.tarea(id_tarea)
);
GO

-- Tabla: tareas.tarea_diligencia
CREATE TABLE [tareas].[tarea_diligencia] (
    id_tarea INT NOT NULL,
    id_diligencia INTEGER NOT NULL,
    CONSTRAINT pk_tarea_diligencia PRIMARY KEY (id_tarea),
    CONSTRAINT uq_tarea_diligencia_diligencia UNIQUE (id_diligencia),
    CONSTRAINT fk_tarea_diligencia_tarea FOREIGN KEY (id_tarea) REFERENCES tareas.tarea(id_tarea)
);
GO


-- ----- Esquema: ubicacion -----

-- Tabla: ubicacion.provincia
CREATE TABLE [ubicacion].[provincia] (
    id_provincia INTEGER NOT NULL,
    id_region INTEGER NOT NULL,
    descripcion NVARCHAR(200) NOT NULL,
    CONSTRAINT pk_provincia PRIMARY KEY (id_provincia),
    CONSTRAINT fk_provincia_region FOREIGN KEY (id_region) REFERENCES ubicacion.region (id_region)
);
GO


-- ----- Esquema: organizacion -----

-- Tabla: organizacion.relacion_unidad
CREATE TABLE [organizacion].[relacion_unidad] (
    id_relacion_unidad INTEGER IDENTITY(1,1) NOT NULL,
    id_unidad_hija INTEGER NOT NULL,
    id_unidad_padre INTEGER NOT NULL,
    id_tipo_relacion INTEGER NOT NULL,
    vigente_desde DATE NOT NULL,
    vigente_hasta DATE NULL,
    CONSTRAINT pk_relacion_unidad PRIMARY KEY (id_relacion_unidad),
    CONSTRAINT fk_relunidad_hija FOREIGN KEY (id_unidad_hija) REFERENCES organizacion.unidad (id_unidad),
    CONSTRAINT fk_relunidad_padre FOREIGN KEY (id_unidad_padre) REFERENCES organizacion.unidad (id_unidad),
    CONSTRAINT fk_relunidad_tipo FOREIGN KEY (id_tipo_relacion) REFERENCES organizacion.cat_tipo_relacion_unidad (id_tipo_relacion_unidad),
    CONSTRAINT uq_relunidad UNIQUE (id_unidad_hija, id_unidad_padre, id_tipo_relacion, vigente_desde)
);
GO

-- Tabla: organizacion.funcionario
CREATE TABLE [organizacion].[funcionario] (
    id_funcionario INTEGER NOT NULL,
    ad_object_id NVARCHAR(36) NULL,
    ad_sam_account NVARCHAR(50) NULL,
    ad_email NVARCHAR(200) NULL,
    id_unidad INTEGER NULL,
    id_cargo_funcion INTEGER NULL,
    numero_placa NVARCHAR(20) NULL,
    fecha_ultima_sync DATETIME2(7) NULL,
    sync_estado NVARCHAR(20) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_funcionario PRIMARY KEY (id_funcionario),
    CONSTRAINT fk_func_unidad FOREIGN KEY (id_unidad) REFERENCES organizacion.unidad (id_unidad),
    CONSTRAINT fk_func_cargo FOREIGN KEY (id_cargo_funcion) REFERENCES organizacion.cat_cargo_funcion (id_cargo_funcion)
);
GO


-- ----- Esquema: personas -----

-- Tabla: personas.nombre
CREATE TABLE [personas].[nombre] (
    id_nombre INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    nombre_principal NVARCHAR(100) NOT NULL,
    nombre_secundario NVARCHAR(100) NULL,
    nombre_extra NVARCHAR(100) NULL,
    apellido_paterno NVARCHAR(100) NULL,
    apellido_materno NVARCHAR(100) NULL,
    es_nombre_supuesto SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_nombre_es_nombre_supuesto CHECK (es_nombre_supuesto IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_nombre PRIMARY KEY (id_nombre),
    CONSTRAINT fk_nombre_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona)
);
GO

-- Tabla: personas.alias
CREATE TABLE [personas].[alias] (
    id_alias INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    alias NVARCHAR(100) NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_alias PRIMARY KEY (id_alias),
    CONSTRAINT fk_alias_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona)
);
GO

-- Tabla: personas.identificacion
CREATE TABLE [personas].[identificacion] (
    id_identificacion INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_documento INTEGER NOT NULL,
    numero_documento NVARCHAR(30) NOT NULL,
    digito_verificador NCHAR(1) NULL,
    id_pais_emisor INTEGER NULL,
    fecha_emision DATE NULL,
    fecha_vencimiento DATE NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_identificacion_es_principal CHECK (es_principal IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    es_temporal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_identificacion_es_temporal CHECK (es_temporal IN (0,1)),
    CONSTRAINT pk_identificacion PRIMARY KEY (id_identificacion),
    CONSTRAINT fk_ident_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_ident_tipo FOREIGN KEY (id_tipo_documento) REFERENCES personas.cat_tipo_documento (id_tipo_documento)
);
GO

-- Tabla: personas.telefono
CREATE TABLE [personas].[telefono] (
    id_telefono INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_telefono INTEGER NOT NULL,
    codigo_area NVARCHAR(5) NULL,
    numero NVARCHAR(20) NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_telefono_es_principal CHECK (es_principal IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_telefono PRIMARY KEY (id_telefono),
    CONSTRAINT fk_telefono_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_telefono_tipo FOREIGN KEY (id_tipo_telefono) REFERENCES personas.cat_tipo_telefono (id_tipo_telefono)
);
GO

-- Tabla: personas.correo
CREATE TABLE [personas].[correo] (
    id_correo INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    correo NVARCHAR(200) NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_correo_es_principal CHECK (es_principal IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_correo PRIMARY KEY (id_correo),
    CONSTRAINT fk_correo_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona)
);
GO

-- Tabla: personas.red_social
CREATE TABLE [personas].[red_social] (
    id_red_social INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_red_social INTEGER NOT NULL,
    usuario_nick NVARCHAR(100) NOT NULL,
    link_url NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_red_social PRIMARY KEY (id_red_social),
    CONSTRAINT fk_red_social_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_red_social_tipo FOREIGN KEY (id_tipo_red_social) REFERENCES personas.cat_tipo_red_social (id_tipo_red_social)
);
GO

-- Tabla: personas.contacto_otro
CREATE TABLE [personas].[contacto_otro] (
    id_contacto_otro INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    tipo_contacto NVARCHAR(100) NOT NULL,
    valor NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(500) NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_contacto_otro_es_principal CHECK (es_principal IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_contacto_otro PRIMARY KEY (id_contacto_otro),
    CONSTRAINT fk_contacto_otro_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona)
);
GO

-- Tabla: personas.empleo
CREATE TABLE [personas].[empleo] (
    id_empleo INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_ocupacion INTEGER NULL,
    descripcion_cargo NVARCHAR(200) NULL,
    empleador_nombre NVARCHAR(200) NULL,
    empleador_rut NVARCHAR(12) NULL,
    id_lugar_trabajo INTEGER NULL,
    es_actual SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_empleo_es_actual CHECK (es_actual IN (0,1)),
    fecha_inicio DATE NULL,
    fecha_fin DATE NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_empleo PRIMARY KEY (id_empleo),
    CONSTRAINT fk_empleo_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_empleo_ocupacion FOREIGN KEY (id_ocupacion) REFERENCES personas.cat_ocupacion (id_ocupacion)
);
GO

-- Tabla: personas.persona_lugar
CREATE TABLE [personas].[persona_lugar] (
    id_persona_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_lugar INTEGER NOT NULL,
    id_tipo_lugar INTEGER NULL,
    id_rol_lugar INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_persona_lugar_es_principal CHECK (es_principal IN (0,1)),
    vigente_desde DATE NULL,
    vigente_hasta DATE NULL,
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_persona_lugar PRIMARY KEY (id_persona_lugar),
    CONSTRAINT fk_perlug_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT uq_persona_lugar_rol UNIQUE (id_persona, id_lugar, id_rol_lugar, vigente_desde)
);
GO

-- Tabla: personas.relacion
CREATE TABLE [personas].[relacion] (
    id_relacion INTEGER IDENTITY(1,1) NOT NULL,
    id_persona_origen INTEGER NOT NULL,
    id_persona_destino INTEGER NOT NULL,
    id_tipo_relacion INTEGER NOT NULL,
    nota NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_relacion PRIMARY KEY (id_relacion),
    CONSTRAINT fk_relacion_origen FOREIGN KEY (id_persona_origen) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_relacion_destino FOREIGN KEY (id_persona_destino) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_relacion_tipo FOREIGN KEY (id_tipo_relacion) REFERENCES personas.cat_tipo_relacion (id_tipo_relacion)
);
GO

-- Tabla: personas.escolaridad
CREATE TABLE [personas].[escolaridad] (
    id_escolaridad INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_nivel_escolaridad INTEGER NOT NULL,
    establecimiento NVARCHAR(200) NULL,
    year_registro INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_escolaridad PRIMARY KEY (id_escolaridad),
    CONSTRAINT fk_escolaridad_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_escolaridad_nivel FOREIGN KEY (id_nivel_escolaridad) REFERENCES personas.cat_nivel_escolaridad (id_nivel_escolaridad)
);
GO

-- Tabla: personas.estado_civil
CREATE TABLE [personas].[estado_civil] (
    id_estado_civil_persona INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_estado_civil INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_estado_civil PRIMARY KEY (id_estado_civil_persona),
    CONSTRAINT fk_estcivil_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_estcivil_tipo FOREIGN KEY (id_tipo_estado_civil) REFERENCES personas.cat_tipo_estado_civil (id_tipo_estado_civil)
);
GO

-- Tabla: personas.fotografia
CREATE TABLE [personas].[fotografia] (
    id_fotografia INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_archivo INTEGER NOT NULL,
    id_tipo_fotografia INTEGER NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_fotografia_es_principal CHECK (es_principal IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_fotografia PRIMARY KEY (id_fotografia),
    CONSTRAINT fk_foto_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_foto_tipo FOREIGN KEY (id_tipo_fotografia) REFERENCES personas.cat_tipo_fotografia (id_tipo_fotografia)
);
GO

-- Tabla: personas.anotacion
CREATE TABLE [personas].[anotacion] (
    id_anotacion INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    id_tipo_anotacion INTEGER NOT NULL,
    contenido NVARCHAR(4000) NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_anotacion PRIMARY KEY (id_anotacion),
    CONSTRAINT fk_anotacion_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_anotacion_tipo FOREIGN KEY (id_tipo_anotacion) REFERENCES personas.cat_tipo_anotacion (id_tipo_anotacion)
);
GO

-- Tabla: personas.descripcion_fisica
CREATE TABLE [personas].[descripcion_fisica] (
    id_descripcion_fisica INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    estatura_cm INTEGER NULL,
    peso_kg DECIMAL(5,1) NULL,
    id_complexion INTEGER NULL,
    id_color_piel INTEGER NULL,
    id_color_ojos INTEGER NULL,
    id_color_cabello INTEGER NULL,
    id_tipo_cabello INTEGER NULL,
    id_forma_rostro INTEGER NULL,
    observaciones NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_descripcion_fisica PRIMARY KEY (id_descripcion_fisica),
    CONSTRAINT fk_descfis_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_descfis_complexion FOREIGN KEY (id_complexion) REFERENCES personas.cat_complexion (id_complexion),
    CONSTRAINT fk_descfis_piel FOREIGN KEY (id_color_piel) REFERENCES personas.cat_color_piel (id_color_piel),
    CONSTRAINT fk_descfis_ojos FOREIGN KEY (id_color_ojos) REFERENCES personas.cat_color_ojos (id_color_ojos),
    CONSTRAINT fk_descfis_cabello FOREIGN KEY (id_color_cabello) REFERENCES personas.cat_color_cabello (id_color_cabello),
    CONSTRAINT fk_descfis_tcabello FOREIGN KEY (id_tipo_cabello) REFERENCES personas.cat_tipo_cabello (id_tipo_cabello),
    CONSTRAINT fk_descfis_rostro FOREIGN KEY (id_forma_rostro) REFERENCES personas.cat_forma_rostro (id_forma_rostro)
);
GO

-- Tabla: personas.referencia_biometrica
CREATE TABLE [personas].[referencia_biometrica] (
    id_referencia_biometrica INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_biometrico INTEGER NOT NULL,
    referencia_externa NVARCHAR(100) NOT NULL,
    sistema_origen NVARCHAR(100) NOT NULL,
    fecha_captura DATE NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_ref_biometrica PRIMARY KEY (id_referencia_biometrica),
    CONSTRAINT fk_biometrica_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_biometrica_tipo FOREIGN KEY (id_tipo_biometrico) REFERENCES personas.cat_tipo_biometrico (id_tipo_biometrico)
);
GO


-- ----- Esquema: vehiculos -----

-- Tabla: vehiculos.cat_version
CREATE TABLE [vehiculos].[cat_version] (
    id_version INTEGER IDENTITY(1,1) NOT NULL,
    id_modelo INTEGER NOT NULL,
    descripcion NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_veh_cat_version PRIMARY KEY (id_version),
    CONSTRAINT fk_version_modelo FOREIGN KEY (id_modelo) REFERENCES vehiculos.cat_modelo (id_modelo)
);
GO


-- ----- Esquema: archivos -----

-- Tabla: archivos.archivo_vinculo
CREATE TABLE [archivos].[archivo_vinculo] (
    id_vinculo INTEGER IDENTITY(1,1) NOT NULL,
    id_archivo INTEGER NOT NULL,
    esquema NVARCHAR(10) NOT NULL,
    entidad NVARCHAR(50) NOT NULL,
    id_entidad INTEGER NOT NULL,
    rol_archivo NVARCHAR(50) NULL,
    fecha_vinculo DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_archivo_vinculo PRIMARY KEY (id_vinculo),
    CONSTRAINT fk_vinculo_archivo FOREIGN KEY (id_archivo) REFERENCES archivos.archivo (id_archivo),
    CONSTRAINT uq_vinculo_archivo_entidad UNIQUE (id_archivo, esquema, entidad, id_entidad)
);
GO


-- ----- Esquema: casos -----

-- Tabla: casos.caso_historial_estado
CREATE TABLE [casos].[caso_historial_estado] (
    id_historial INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_estado_anterior INTEGER NULL,
    id_estado_nuevo INTEGER NOT NULL,
    id_funcionario_cambio INTEGER NOT NULL,
    motivo NVARCHAR(1000) NULL,
    fecha_cambio DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_clasificacion_delito_anterior INTEGER NULL,
    CONSTRAINT pk_caso_historial PRIMARY KEY (id_historial),
    CONSTRAINT fk_histcaso_caso FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso),
    CONSTRAINT fk_histcaso_est_ant FOREIGN KEY (id_estado_anterior) REFERENCES casos.cat_estado_caso (id_estado_caso),
    CONSTRAINT fk_histcaso_est_nuevo FOREIGN KEY (id_estado_nuevo) REFERENCES casos.cat_estado_caso (id_estado_caso)
);
GO

-- Tabla: casos.caso_referencia_judicial
CREATE TABLE [casos].[caso_referencia_judicial] (
    id_referencia INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    tipo_referencia NVARCHAR(10) NOT NULL,
    valor NVARCHAR(30) NOT NULL,
    tribunal NVARCHAR(200) NULL,
    fecha_asignacion DATE NULL,
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_caso_ref_judicial PRIMARY KEY (id_referencia),
    CONSTRAINT fk_refjud_caso FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso),
    CONSTRAINT uq_ref_judicial UNIQUE (tipo_referencia, valor, tribunal)
);
GO

-- Tabla: casos.asignacion_funcionario
CREATE TABLE [casos].[asignacion_funcionario] (
    id_asignacion INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    id_cargo_funcion INTEGER NULL,
    fecha_asignacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_desasignacion DATETIME2(7) NULL,
    motivo_desasignacion NVARCHAR(500) NULL,
    CONSTRAINT pk_asignacion_func PRIMARY KEY (id_asignacion),
    CONSTRAINT fk_asignfunc_caso FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso),
    CONSTRAINT uq_asignacion_func UNIQUE (id_caso, id_funcionario, fecha_asignacion)
);
GO

-- Tabla: casos.caso_persona_rol
CREATE TABLE [casos].[caso_persona_rol] (
    id_caso_persona_rol INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_rol_persona INTEGER NOT NULL,
    fecha_asignacion DATE NOT NULL,
    fecha_retiro DATE NULL,
    observaciones NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    id_defensor INTEGER NULL,
    CONSTRAINT pk_caso_persona_rol PRIMARY KEY (id_caso_persona_rol),
    CONSTRAINT fk_casoperrol_caso FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso),
    CONSTRAINT fk_casoperrol_rol FOREIGN KEY (id_tipo_rol_persona) REFERENCES casos.cat_tipo_rol_persona (id_tipo_rol_persona),
    CONSTRAINT uq_caso_persona_rol UNIQUE (id_caso, id_persona, id_tipo_rol_persona, fecha_asignacion)
);
GO

-- Tabla: casos.agrupacion_causa
CREATE TABLE [casos].[agrupacion_causa] (
    id_agrupacion_causa INTEGER IDENTITY(1,1) NOT NULL,
    id_caso_principal INTEGER NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'SOLICITADA',
    id_funcionario_solicita INTEGER NOT NULL,
    id_funcionario_aprueba INTEGER NULL,
    fecha_solicitud DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_aprobacion DATETIME2(7) NULL,
    motivo NVARCHAR(500) NULL,
    observaciones NVARCHAR(1000) NULL,
    ruc_principal NVARCHAR(50) NULL,
    CONSTRAINT pk_agrupacion_causa PRIMARY KEY (id_agrupacion_causa),
    CONSTRAINT uq_agrupacion_causa_principal UNIQUE (id_caso_principal),
    CONSTRAINT fk_agrcausa_caso FOREIGN KEY (id_caso_principal) REFERENCES casos.caso (id_caso)
);
GO

-- Tabla: casos.matriz_riesgo
CREATE TABLE [casos].[matriz_riesgo] (
    id_matriz_riesgo INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    descripcion_riesgo NVARCHAR(2000) NOT NULL,
    nivel_riesgo NVARCHAR(20) NOT NULL,
    medidas_mitigacion NVARCHAR(2000) NULL,
    recursos_requeridos NVARCHAR(1000) NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'ELABORADA',
    id_funcionario_elabora INTEGER NOT NULL,
    id_funcionario_aprueba INTEGER NULL,
    fecha_elaboracion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_aprobacion DATETIME2(7) NULL,
    fecha_ejecucion DATETIME2(7) NULL,
    id_archivo_adjunto INTEGER NULL,
    CONSTRAINT pk_matriz_riesgo PRIMARY KEY (id_matriz_riesgo),
    CONSTRAINT fk_matriesgo_caso FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso)
);
GO


-- ----- Esquema: investigacion -----

-- Tabla: investigacion.delito_imputado
CREATE TABLE [investigacion].[delito_imputado] (
    id_delito_imputado INTEGER IDENTITY(1,1) NOT NULL,
    folio NVARCHAR(30) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_hecho INTEGER NULL,
    id_clasificacion_delito INTEGER NOT NULL,
    id_grado_ejecucion INTEGER NOT NULL,
    contexto_vif SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_delito_imputado_contexto_vif CHECK (contexto_vif IN (0,1)),
    relato NVARCHAR(MAX) NOT NULL,
    fecha_imputacion DATE NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    es_delito_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_delito_imputado_es_delito_principal CHECK (es_delito_principal IN (0,1)),
    id_delito_padre INTEGER NULL,
    id_movil INTEGER NULL,
    CONSTRAINT pk_delito_imputado PRIMARY KEY (id_delito_imputado),
    CONSTRAINT uq_delito_imputado_folio UNIQUE (folio),
    CONSTRAINT fk_delimp_clasificacion FOREIGN KEY (id_clasificacion_delito) REFERENCES investigacion.clasificacion_delito (id_clasificacion_delito),
    CONSTRAINT fk_delimp_grado FOREIGN KEY (id_grado_ejecucion) REFERENCES investigacion.cat_grado_ejecucion (id_grado_ejecucion),
    CONSTRAINT fk_delimp_hecho_caso FOREIGN KEY (id_hecho, id_caso) REFERENCES investigacion.hecho (id_hecho, id_caso),
    CONSTRAINT fk_delimp_movil FOREIGN KEY (id_movil) REFERENCES investigacion.cat_movil (id_movil)
);
GO

-- Tabla: investigacion.hecho_lugar
CREATE TABLE [investigacion].[hecho_lugar] (
    id_hecho_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_hecho INTEGER NOT NULL,
    id_lugar INTEGER NOT NULL,
    id_tipo_lugar INTEGER NULL,
    id_rol_lugar INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_hecho_lugar_es_principal CHECK (es_principal IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_hecho_lugar PRIMARY KEY (id_hecho_lugar),
    CONSTRAINT fk_hecholug_hecho FOREIGN KEY (id_hecho) REFERENCES investigacion.hecho (id_hecho),
    CONSTRAINT uq_hecho_lugar_rol UNIQUE (id_hecho, id_lugar, id_rol_lugar)
);
GO

-- Tabla: investigacion.hecho_persona_rol
CREATE TABLE [investigacion].[hecho_persona_rol] (
    id_hecho_persona_rol INTEGER IDENTITY(1,1) NOT NULL,
    id_hecho INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_rol_persona INTEGER NOT NULL,
    fecha_asignacion DATE NOT NULL DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Pacific SA Standard Time' AS DATE),
    descripcion_participacion NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_hecho_persona_rol PRIMARY KEY (id_hecho_persona_rol),
    CONSTRAINT fk_hecoperrol_hecho FOREIGN KEY (id_hecho) REFERENCES investigacion.hecho (id_hecho),
    CONSTRAINT uq_hecho_persona_rol UNIQUE (id_hecho, id_persona, id_tipo_rol_persona, fecha_asignacion)
);
GO

-- Tabla: investigacion.protocolo_delito
CREATE TABLE [investigacion].[protocolo_delito] (
    id_protocolo INTEGER IDENTITY(1,1) NOT NULL,
    id_clasificacion_delito INTEGER NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    acciones_minimas NVARCHAR(4000) NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_protocolo_delito_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_protocolo_delito PRIMARY KEY (id_protocolo),
    CONSTRAINT uq_protocolo_delito UNIQUE (id_clasificacion_delito),
    CONSTRAINT fk_prot_clasificacion FOREIGN KEY (id_clasificacion_delito) REFERENCES investigacion.clasificacion_delito (id_clasificacion_delito)
);
GO

-- Tabla: investigacion.hecho_fenomeno
CREATE TABLE [investigacion].[hecho_fenomeno] (
    id_hecho_fenomeno INTEGER IDENTITY(1,1) NOT NULL,
    id_hecho INTEGER NOT NULL,
    id_fenomeno INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0
 CONSTRAINT ck_hecho_fenomeno_es_principal CHECK (es_principal IN (0,1)),
    fecha_asignacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_asigna INTEGER NULL,
    observaciones NVARCHAR(500) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_hecho_fenomeno PRIMARY KEY (id_hecho_fenomeno),
    CONSTRAINT uq_hecho_fenomeno_combo UNIQUE (id_hecho, id_fenomeno),
    CONSTRAINT fk_hecho_fenomeno_hecho FOREIGN KEY (id_hecho) REFERENCES investigacion.hecho (id_hecho)
);
GO


-- ----- Esquema: denuncias -----

-- Tabla: denuncias.denuncia_hecho
CREATE TABLE [denuncias].[denuncia_hecho] (
    id_denuncia_hecho INTEGER IDENTITY(1,1) NOT NULL,
    id_denuncia INTEGER NOT NULL,
    id_hecho INTEGER NOT NULL,
    CONSTRAINT pk_denuncia_hecho PRIMARY KEY (id_denuncia_hecho),
    CONSTRAINT fk_denhecho_denuncia FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia (id_denuncia),
    CONSTRAINT uq_denuncia_hecho UNIQUE (id_denuncia, id_hecho)
);
GO

-- Tabla: denuncias.relato
CREATE TABLE [denuncias].[relato] (
    id_relato INTEGER IDENTITY(1,1) NOT NULL,
    id_denuncia INTEGER NOT NULL,
    id_tipo_relato INTEGER NOT NULL,
    resumen NVARCHAR(4000) NULL,
    id_archivo INTEGER NULL,
    id_funcionario_receptor INTEGER NOT NULL,
    declarante_es_denunciante SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_relato_declarante_es_denunciante CHECK (declarante_es_denunciante IN (0,1)),
    id_persona_declarante INTEGER NULL,
    numero_version INTEGER NOT NULL DEFAULT 1,
    id_relato_version_anterior INTEGER NULL,
    fecha_declaracion DATETIME2(7) NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_relato PRIMARY KEY (id_relato),
    CONSTRAINT fk_relato_denuncia FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia (id_denuncia),
    CONSTRAINT fk_relato_anterior FOREIGN KEY (id_relato_version_anterior) REFERENCES denuncias.relato (id_relato)
);
GO

-- Tabla: denuncias.denuncia_persona_rol
CREATE TABLE [denuncias].[denuncia_persona_rol] (
    id_denuncia_persona_rol INTEGER IDENTITY(1,1) NOT NULL,
    id_denuncia INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_rol_persona INTEGER NOT NULL,
    es_declarante SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_denuncia_persona_rol_es_declarante CHECK (es_declarante IN (0,1)),
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_denuncia_persona_rol_es_principal CHECK (es_principal IN (0,1)),
    fecha_asignacion DATE NOT NULL DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Pacific SA Standard Time' AS DATE),
    fecha_retiro DATE NULL,
    observaciones NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_denuncia_persona_rol PRIMARY KEY (id_denuncia_persona_rol),
    CONSTRAINT fk_denperrol_denuncia FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia (id_denuncia),
    CONSTRAINT uq_denuncia_persona_rol UNIQUE (id_denuncia, id_persona, id_tipo_rol_persona, fecha_asignacion)
);
GO

-- Tabla: denuncias.encargo_suev
CREATE TABLE [denuncias].[encargo_suev] (
    id_encargo_suev INTEGER IDENTITY(1,1) NOT NULL,
    id_denuncia INTEGER NOT NULL,
    id_vehiculo INTEGER NULL,
    patente NVARCHAR(20) NOT NULL,
    n_encargo_nacional NVARCHAR(50) NULL,
    folio_suev NVARCHAR(50) NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_cancelacion DATETIME2(7) NULL,
    id_funcionario_registra INTEGER NULL,
    observaciones NVARCHAR(500) NULL,
    CONSTRAINT pk_encargo_suev PRIMARY KEY (id_encargo_suev),
    CONSTRAINT uq_encargo_suev_denuncia UNIQUE (id_denuncia),
    CONSTRAINT fk_suev_denuncia FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia (id_denuncia)
);
GO

-- Tabla: denuncias.pauta_vif
CREATE TABLE [denuncias].[pauta_vif] (
    id_pauta_vif INTEGER IDENTITY(1,1) NOT NULL,
    id_denuncia INTEGER NULL,
    id_caso INTEGER NULL,
    id_persona_imputado INTEGER NULL,
    id_persona_victima INTEGER NULL,
    vinculo_agresor NVARCHAR(100) NOT NULL,
    tiene_lesiones_visibles SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_pauta_vif_tiene_lesiones_visibles CHECK (tiene_lesiones_visibles IN (0,1)),
    medidas_proteccion NVARCHAR(500) NULL,
    georreferencia_arcgis NVARCHAR(200) NULL,
    firma_apercibimiento_art26 SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_pauta_vif_firma_apercibimiento_art26 CHECK (firma_apercibimiento_art26 IN (0,1)),
    observaciones NVARCHAR(2000) NULL,
    id_funcionario_registra INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_pauta_vif PRIMARY KEY (id_pauta_vif),
    CONSTRAINT fk_vif_denuncia FOREIGN KEY (id_denuncia) REFERENCES denuncias.denuncia (id_denuncia)
);
GO


-- ----- Esquema: diligencias -----

-- Tabla: diligencias.diligencia
CREATE TABLE [diligencias].[diligencia] (
    id_diligencia INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_hecho INTEGER NULL,
    id_instruccion_fiscal INTEGER NULL,
    id_tipo_diligencia INTEGER NOT NULL,
    id_estado INTEGER NOT NULL,
    id_funcionario_responsable INTEGER NOT NULL,
    id_lugar INTEGER NULL,
    descripcion NVARCHAR(MAX) NULL,
    resultado NVARCHAR(MAX) NULL,
    fecha_encomendada DATE NOT NULL,
    fecha_plazo DATE NULL,
    fecha_ejecucion DATE NULL,
    autorizacion_judicial_ref NVARCHAR(100) NULL,
    fecha_autorizacion_judicial DATE NULL,
    bitacora_web_ref NVARCHAR(50) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    fecha_envio_fiscalia DATETIME2(7) NULL,
    es_origen_institucional SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_diligencia_es_origen_institucional CHECK (es_origen_institucional IN (0,1)),
    autoriza_descerrajamiento SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_diligencia_autoriza_descerrajamiento CHECK (autoriza_descerrajamiento IN (0,1)),
    horario_autorizado NVARCHAR(50) NULL,
    es_bitacora SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_diligencia_es_bitacora CHECK (es_bitacora IN (0,1)),
    CONSTRAINT pk_diligencia PRIMARY KEY (id_diligencia),
    CONSTRAINT fk_dil_tipo FOREIGN KEY (id_tipo_diligencia) REFERENCES diligencias.cat_tipo_diligencia (id_tipo_diligencia),
    CONSTRAINT fk_dil_est FOREIGN KEY (id_estado) REFERENCES diligencias.cat_estado_diligencia (id_estado_diligencia),
    CONSTRAINT uq_diligencia_caso UNIQUE (id_diligencia, id_caso),
    CONSTRAINT fk_dil_inst_caso FOREIGN KEY (id_instruccion_fiscal, id_caso) REFERENCES diligencias.instruccion_fiscal (id_instruccion_fiscal, id_caso)
);
GO

-- Tabla: diligencias.solicitud_concurrencia_pericial
CREATE TABLE [diligencias].[solicitud_concurrencia_pericial] (
    id_solicitud_pericial INTEGER IDENTITY(1,1) NOT NULL,
    folio_solicitud NVARCHAR(30) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_instruccion_fiscal INTEGER NULL,
    id_funcionario_solicitante INTEGER NOT NULL,
    id_lugar INTEGER NULL,
    especialidad_requerida NVARCHAR(200) NULL,
    fecha_solicitud DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    estado NVARCHAR(20) NOT NULL DEFAULT 'REGISTRADA',
    observaciones NVARCHAR(1000) NULL,
    fecha_actualizacion DATETIME2(7) NULL,
    cantidad_especies INTEGER NULL,
    telefono_oficial_solicitante NVARCHAR(20) NULL,
    es_homicidio SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_solicitud_concurrencia_pericial_es_homicidio CHECK (es_homicidio IN (0,1)),
    CONSTRAINT pk_solicitud_pericial PRIMARY KEY (id_solicitud_pericial),
    CONSTRAINT uq_solicitud_pericial_folio UNIQUE (folio_solicitud),
    CONSTRAINT fk_solper_instruccion FOREIGN KEY (id_instruccion_fiscal) REFERENCES diligencias.instruccion_fiscal (id_instruccion_fiscal)
);
GO


-- ----- Esquema: catalogo_bienes -----

-- Tabla: catalogo_bienes.familia
CREATE TABLE [catalogo_bienes].[familia] (
    id_familia INTEGER IDENTITY(1,1) NOT NULL,
    id_version INTEGER NOT NULL,
    id_segmento INTEGER NOT NULL,
    codigo NCHAR(4) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_familia_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_familia PRIMARY KEY (id_familia),
    CONSTRAINT uq_familia_codigo_version UNIQUE (codigo, id_version),
    CONSTRAINT fk_familia_version FOREIGN KEY (id_version) REFERENCES catalogo_bienes.version_catalogo (id_version),
    CONSTRAINT fk_familia_segmento FOREIGN KEY (id_segmento) REFERENCES catalogo_bienes.segmento (id_segmento)
);
GO


-- ----- Esquema: evidencias -----

-- Tabla: evidencias.evidencia_lugar
CREATE TABLE [evidencias].[evidencia_lugar] (
    id_evidencia_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_evidencia INTEGER NOT NULL,
    id_lugar INTEGER NOT NULL,
    id_tipo_lugar INTEGER NULL,
    id_rol_lugar INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_evidencia_lugar_es_principal CHECK (es_principal IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_evi_lugar PRIMARY KEY (id_evidencia_lugar),
    CONSTRAINT fk_evilug_evi FOREIGN KEY (id_evidencia) REFERENCES evidencias.evidencia (id_evidencia),
    CONSTRAINT uq_evi_lugar_rol UNIQUE (id_evidencia, id_lugar, id_rol_lugar)
);
GO

-- Tabla: evidencias.especie
CREATE TABLE [evidencias].[especie] (
    id_especie INTEGER IDENTITY(1,1) NOT NULL,
    id_evidencia INTEGER NOT NULL,
    id_caso INTEGER NOT NULL,
    nue NVARCHAR(30) NOT NULL,
    rue NVARCHAR(30) NULL,
    id_producto INTEGER NULL,
    id_tipo_extension_especie INTEGER NOT NULL,
    id_estado_especie INTEGER NOT NULL,
    id_tipo_custodia INTEGER NULL,
    custodio_institucion NVARCHAR(200) NULL,
    descripcion NVARCHAR(2000) NOT NULL,
    cantidad INTEGER DEFAULT 1,
    valor_estimado DECIMAL(18,2) NULL,
    numero_serie NVARCHAR(100) NULL,
    registro_fotografico SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_especie_registro_fotografico CHECK (registro_fotografico IN (0,1)),
    observaciones NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    nue_padre NVARCHAR(50) NULL,
    unidad_medida NVARCHAR(20) NULL,
    CONSTRAINT pk_especie PRIMARY KEY (id_especie),
    CONSTRAINT fk_esp_tipo_extension FOREIGN KEY (id_tipo_extension_especie) REFERENCES evidencias.cat_tipo_extension_especie (id_tipo_extension_especie),
    CONSTRAINT fk_esp_estado FOREIGN KEY (id_estado_especie) REFERENCES evidencias.cat_estado_especie (id_estado_especie),
    CONSTRAINT fk_esp_custodia FOREIGN KEY (id_tipo_custodia) REFERENCES evidencias.cat_tipo_custodia (id_tipo_custodia),
    CONSTRAINT uq_especie_caso UNIQUE (id_especie, id_caso),
    CONSTRAINT fk_esp_evi_caso FOREIGN KEY (id_evidencia, id_caso) REFERENCES evidencias.evidencia (id_evidencia, id_caso)
);
GO


-- ----- Esquema: migracion -----

-- Tabla: migracion.expulsion
CREATE TABLE [migracion].[expulsion] (
    id_expulsion INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_denuncia_mig INTEGER NULL,
    tipo NVARCHAR(20) NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'INICIADA',
    fecha_notificacion DATE NULL,
    plazo_apelacion_dias INTEGER NULL,
    fecha_vencimiento_apelacion DATE NULL,
    prohibicion_ingreso_anos INTEGER NULL,
    fecha_salida_fisica DATETIME2(7) NULL,
    pais_destino INTEGER NULL,
    id_funcionario_registra INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_expulsion PRIMARY KEY (id_expulsion),
    CONSTRAINT fk_exp_denuncia_mig FOREIGN KEY (id_denuncia_mig) REFERENCES migracion.denuncia_administrativa_migratoria (id_denuncia_mig),
    CONSTRAINT CHK_exp_tipo CHECK (tipo IN ('JUDICIAL','ADMINISTRATIVA'))
);
GO


-- ----- Esquema: cooperacion_int -----

-- Tabla: cooperacion_int.solicitud_interpol
CREATE TABLE [cooperacion_int].[solicitud_interpol] (
    id_solicitud INTEGER IDENTITY(1,1) NOT NULL,
    numero_endoso INTEGER NOT NULL,
    anio INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_calidad_persona INTEGER NOT NULL,
    id_estado_solicitud INTEGER NOT NULL,
    id_medio_solicitud INTEGER NOT NULL,
    id_entidad_solicitante INTEGER NOT NULL,
    id_entidad_receptora INTEGER NOT NULL,
    id_pais_emisor INTEGER NOT NULL,
    id_pais_receptor INTEGER NOT NULL,
    entidad_solicitante_otro NVARCHAR(255) NULL,
    entidad_receptora_otro NVARCHAR(255) NULL,
    observaciones NVARCHAR(500) NULL,
    id_funcionario_endosador INTEGER NOT NULL,
    fecha_endoso DATETIME2(7) NOT NULL,
    tiene_huella_dactilar SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_solicitud_interpol_tiene_huella_dactilar CHECK (tiene_huella_dactilar IN (0,1)),
    sip_ref NVARCHAR(50) NULL,
    id_caso INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_modificacion DATETIME2(7) NULL,
    fecha_cierre DATETIME2(7) NULL,
    id_funcionario_cierra INTEGER NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    id_funcionario_registro INTEGER NOT NULL,
    bloquear_edicion_origen SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_solicitud_interpol_bloquear_edicion_origen CHECK (bloquear_edicion_origen IN (0,1)),
    id_tipo_documento_referencia INTEGER NULL,
    nivel_restriccion_interpol NVARCHAR(20) NULL DEFAULT 'NORMAL',
    CONSTRAINT pk_solicitud_interpol PRIMARY KEY (id_solicitud),
    CONSTRAINT uq_solicitud_endoso_anio UNIQUE (numero_endoso, anio),
    CONSTRAINT fk_sol_calidad_persona FOREIGN KEY (id_calidad_persona) REFERENCES cooperacion_int.cat_elemento_cooperacion_internacional (id_cat_elemento_cooperacion_internacional),
    CONSTRAINT fk_sol_estado FOREIGN KEY (id_estado_solicitud) REFERENCES cooperacion_int.estado_solicitud_interpol (id_estado_solicitud),
    CONSTRAINT fk_sol_medio FOREIGN KEY (id_medio_solicitud) REFERENCES cooperacion_int.cat_elemento_cooperacion_internacional (id_cat_elemento_cooperacion_internacional),
    CONSTRAINT fk_sol_entidad_solicitante FOREIGN KEY (id_entidad_solicitante) REFERENCES cooperacion_int.entidad_interpol (id_entidad),
    CONSTRAINT fk_sol_entidad_receptora FOREIGN KEY (id_entidad_receptora) REFERENCES cooperacion_int.entidad_interpol (id_entidad)
);
GO


-- ----- Esquema: analitica -----

-- Tabla: analitica.foco_investigativo
CREATE TABLE [analitica].[foco_investigativo] (
    id_foco INTEGER IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(2000) NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'EN_EVALUACION',
    id_funcionario_creador INTEGER NOT NULL,
    id_unidad INTEGER NOT NULL,
    id_reporte_origen INTEGER NULL,
    fecha_creacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_aprobacion DATETIME2(7) NULL,
    fecha_cierre DATETIME2(7) NULL,
    observaciones NVARCHAR(1000) NULL,
    CONSTRAINT pk_foco_investigativo PRIMARY KEY (id_foco),
    CONSTRAINT fk_foco_reporte FOREIGN KEY (id_reporte_origen) REFERENCES analitica.reporte_analitico (id_reporte)
);
GO

-- Tabla: analitica.vinculo_entidad
CREATE TABLE [analitica].[vinculo_entidad] (
    id_vinculo INTEGER IDENTITY(1,1) NOT NULL,
    tipo_entidad_origen NVARCHAR(50) NOT NULL,
    id_entidad_origen INTEGER NOT NULL,
    tipo_entidad_destino NVARCHAR(50) NOT NULL,
    id_entidad_destino INTEGER NOT NULL,
    tipo_vinculo NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(500) NULL,
    id_reporte INTEGER NULL,
    id_funcionario_registra INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_vinculo_entidad PRIMARY KEY (id_vinculo),
    CONSTRAINT fk_vincent_reporte FOREIGN KEY (id_reporte) REFERENCES analitica.reporte_analitico (id_reporte)
);
GO

-- Tabla: analitica.matriz_analisis
CREATE TABLE [analitica].[matriz_analisis] (
    id_matriz_analisis INTEGER IDENTITY(1,1) NOT NULL,
    id_reporte INTEGER NOT NULL,
    descripcion NVARCHAR(500) NOT NULL,
    datos_analizados NVARCHAR(4000) NULL,
    metodologia NVARCHAR(500) NULL,
    id_funcionario_registra INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_matriz_analisis PRIMARY KEY (id_matriz_analisis),
    CONSTRAINT fk_matran_reporte FOREIGN KEY (id_reporte) REFERENCES analitica.reporte_analitico (id_reporte)
);
GO

-- Tabla: analitica.reporte_analitico_caso
CREATE TABLE [analitica].[reporte_analitico_caso] (
    id_reporte_caso INTEGER IDENTITY(1,1) NOT NULL,
    id_reporte INTEGER NOT NULL,
    id_caso INTEGER NOT NULL,
    tipo_vinculo NVARCHAR(100) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_reporte_caso PRIMARY KEY (id_reporte_caso),
    CONSTRAINT uq_reporte_caso UNIQUE (id_reporte, id_caso),
    CONSTRAINT fk_reptcaso_reporte FOREIGN KEY (id_reporte) REFERENCES analitica.reporte_analitico (id_reporte)
);
GO

-- Tabla: analitica.aplicacion_reporte
CREATE TABLE [analitica].[aplicacion_reporte] (
    id_aplicacion_reporte INTEGER IDENTITY(1,1) NOT NULL,
    id_reporte INTEGER NOT NULL,
    nombre_aplicacion NVARCHAR(100) NOT NULL,
    version NVARCHAR(20) NULL,
    proposito NVARCHAR(200) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_aplicacion_reporte PRIMARY KEY (id_aplicacion_reporte),
    CONSTRAINT fk_aplic_reporte FOREIGN KEY (id_reporte) REFERENCES analitica.reporte_analitico (id_reporte)
);
GO


-- ----- Esquema: tareas -----

-- Tabla: tareas.tarea_documento
CREATE TABLE [tareas].[tarea_documento] (
    id_documento INT NOT NULL,
    id_estado_tarea INT NOT NULL,
    CONSTRAINT pk_tarea_documento PRIMARY KEY (id_documento, id_estado_tarea),
    CONSTRAINT fk_tarea_documento_doc FOREIGN KEY (id_documento) REFERENCES tareas.documento(id_documento),
    CONSTRAINT fk_tarea_documento_estado FOREIGN KEY (id_estado_tarea) REFERENCES tareas.estado_tarea(id_estado_tarea)
);
GO

-- Tabla: tareas.tarea_archivo_adjunto
CREATE TABLE [tareas].[tarea_archivo_adjunto] (
    id_archivo INTEGER NOT NULL,
    id_estado_tarea INT NOT NULL,
    CONSTRAINT pk_tarea_archivo_adjunto PRIMARY KEY (id_archivo, id_estado_tarea),
    CONSTRAINT fk_tarea_archivo_estado FOREIGN KEY (id_estado_tarea) REFERENCES tareas.estado_tarea(id_estado_tarea)
);
GO


-- ----- Esquema: ubicacion -----

-- Tabla: ubicacion.comuna
CREATE TABLE [ubicacion].[comuna] (
    id_comuna INTEGER NOT NULL,
    id_provincia INTEGER NOT NULL,
    descripcion NVARCHAR(200) NOT NULL,
    costera INTEGER NULL,
    CONSTRAINT pk_comuna PRIMARY KEY (id_comuna),
    CONSTRAINT fk_comuna_provincia FOREIGN KEY (id_provincia) REFERENCES ubicacion.provincia (id_provincia)
);
GO


-- ----- Esquema: personas -----

-- Tabla: personas.rasgo_distintivo
CREATE TABLE [personas].[rasgo_distintivo] (
    id_rasgo INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_rasgo INTEGER NOT NULL,
    id_ubicacion_corporal INTEGER NOT NULL,
    descripcion NVARCHAR(500) NOT NULL,
    id_fotografia INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_rasgo_distintivo PRIMARY KEY (id_rasgo),
    CONSTRAINT fk_rasgo_persona FOREIGN KEY (id_persona) REFERENCES personas.persona (id_persona),
    CONSTRAINT fk_rasgo_tipo FOREIGN KEY (id_tipo_rasgo) REFERENCES personas.cat_tipo_rasgo_distintivo (id_tipo_rasgo),
    CONSTRAINT fk_rasgo_ubicacion FOREIGN KEY (id_ubicacion_corporal) REFERENCES personas.cat_ubicacion_corporal (id_ubicacion_corporal),
    CONSTRAINT fk_rasgo_foto FOREIGN KEY (id_fotografia) REFERENCES personas.fotografia (id_fotografia)
);
GO


-- ----- Esquema: vehiculos -----

-- Tabla: vehiculos.vehiculo
CREATE TABLE [vehiculos].[vehiculo] (
    id_vehiculo INTEGER IDENTITY(1,1) NOT NULL,
    patente NVARCHAR(10) NULL,
    vin NVARCHAR(17) NULL,
    numero_motor NVARCHAR(50) NULL,
    numero_chasis NVARCHAR(50) NULL,
    id_tipo_vehiculo INTEGER NULL,
    id_marca INTEGER NULL,
    id_modelo INTEGER NULL,
    id_version INTEGER NULL,
    anio INTEGER NULL,
    id_color INTEGER NULL,
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    nacionalidad_patente NVARCHAR(10) NULL DEFAULT 'NACIONAL',
    CONSTRAINT pk_vehiculo PRIMARY KEY (id_vehiculo),
    CONSTRAINT fk_veh_tipo FOREIGN KEY (id_tipo_vehiculo) REFERENCES vehiculos.cat_tipo (id_tipo_vehiculo),
    CONSTRAINT fk_veh_marca FOREIGN KEY (id_marca) REFERENCES vehiculos.cat_marca (id_marca),
    CONSTRAINT fk_veh_modelo FOREIGN KEY (id_modelo) REFERENCES vehiculos.cat_modelo (id_modelo),
    CONSTRAINT fk_veh_version FOREIGN KEY (id_version) REFERENCES vehiculos.cat_version (id_version),
    CONSTRAINT fk_veh_color FOREIGN KEY (id_color) REFERENCES vehiculos.cat_color (id_color)
);
GO


-- ----- Esquema: casos -----

-- Tabla: casos.agrupacion_causa_caso
CREATE TABLE [casos].[agrupacion_causa_caso] (
    id_agrupacion_causa_caso INTEGER IDENTITY(1,1) NOT NULL,
    id_agrupacion_causa INTEGER NOT NULL,
    id_caso INTEGER NOT NULL,
    fecha_incorporacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_registra INTEGER NULL,
    CONSTRAINT pk_agrupacion_causa_caso PRIMARY KEY (id_agrupacion_causa_caso),
    CONSTRAINT uq_agrcausa_caso UNIQUE (id_agrupacion_causa, id_caso),
    CONSTRAINT fk_agrcasocaso_agrupacion FOREIGN KEY (id_agrupacion_causa) REFERENCES casos.agrupacion_causa (id_agrupacion_causa),
    CONSTRAINT fk_agrcasocaso_caso FOREIGN KEY (id_caso) REFERENCES casos.caso (id_caso)
);
GO


-- ----- Esquema: investigacion -----

-- Tabla: investigacion.delito_circunstancia
CREATE TABLE [investigacion].[delito_circunstancia] (
    id_delito_circunstancia INTEGER IDENTITY(1,1) NOT NULL,
    id_delito_imputado INTEGER NOT NULL,
    id_circunstancia INTEGER NOT NULL,
    observaciones NVARCHAR(500) NULL,
    CONSTRAINT pk_delito_circunstancia PRIMARY KEY (id_delito_circunstancia),
    CONSTRAINT fk_delcirc_delito FOREIGN KEY (id_delito_imputado) REFERENCES investigacion.delito_imputado (id_delito_imputado),
    CONSTRAINT fk_delcirc_circ FOREIGN KEY (id_circunstancia) REFERENCES investigacion.cat_circunstancia_modificatoria (id_circunstancia),
    CONSTRAINT uq_delito_circunstancia UNIQUE (id_delito_imputado, id_circunstancia)
);
GO

-- Tabla: investigacion.delito_imputado_persona
CREATE TABLE [investigacion].[delito_imputado_persona] (
    id_delito_persona INTEGER IDENTITY(1,1) NOT NULL,
    id_delito_imputado INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_grado_participacion INTEGER NOT NULL,
    fecha_vinculacion DATE NULL,
    observaciones NVARCHAR(1000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_delito_persona PRIMARY KEY (id_delito_persona),
    CONSTRAINT fk_delper_delito FOREIGN KEY (id_delito_imputado) REFERENCES investigacion.delito_imputado (id_delito_imputado),
    CONSTRAINT fk_delper_grado FOREIGN KEY (id_grado_participacion) REFERENCES investigacion.cat_grado_participacion (id_grado_participacion),
    CONSTRAINT uq_delito_persona UNIQUE (id_delito_imputado, id_persona, id_grado_participacion)
);
GO

-- Tabla: investigacion.subtipo_delito_secuestro
CREATE TABLE [investigacion].[subtipo_delito_secuestro] (
    id_subtipo_secuestro INTEGER IDENTITY(1,1) NOT NULL,
    id_delito_imputado INTEGER NOT NULL,
    tipo_secuestro NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(300) NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'EN_EVALUACION',
    fecha_clasificacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    id_funcionario_clasifica INTEGER NULL,
    CONSTRAINT pk_subtipo_secuestro PRIMARY KEY (id_subtipo_secuestro),
    CONSTRAINT uq_subtipo_secuestro UNIQUE (id_delito_imputado),
    CONSTRAINT fk_subsec_delito FOREIGN KEY (id_delito_imputado) REFERENCES investigacion.delito_imputado (id_delito_imputado)
);
GO


-- ----- Esquema: diligencias -----

-- Tabla: diligencias.peritaje
CREATE TABLE [diligencias].[peritaje] (
    id_peritaje INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_especie INTEGER NULL,
    id_tipo_peritaje INTEGER NOT NULL,
    id_institucion_ejecutora INTEGER NOT NULL,
    id_funcionario_solicitante INTEGER NULL,
    id_diligencia INTEGER NULL,
    fecha_solicitud DATE NOT NULL,
    fecha_recepcion_lab DATE NULL,
    fecha_emision_informe DATE NULL,
    numero_informe_pericial NVARCHAR(50) NULL,
    resultado_resumen NVARCHAR(4000) NULL,
    id_estado INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    id_solicitud_concurrencia INTEGER NULL,
    id_instruccion_fiscal INTEGER NULL,
    CONSTRAINT pk_peritaje PRIMARY KEY (id_peritaje),
    CONSTRAINT fk_per_tipo FOREIGN KEY (id_tipo_peritaje) REFERENCES diligencias.cat_tipo_peritaje (id_tipo_peritaje),
    CONSTRAINT fk_per_est FOREIGN KEY (id_estado) REFERENCES diligencias.cat_estado_diligencia (id_estado_diligencia),
    CONSTRAINT fk_per_dil_caso FOREIGN KEY (id_diligencia, id_caso) REFERENCES diligencias.diligencia (id_diligencia, id_caso),
    CONSTRAINT fk_peritaje_solicitud_concurrencia FOREIGN KEY (id_solicitud_concurrencia) REFERENCES diligencias.solicitud_concurrencia_pericial (id_solicitud_pericial),
    CONSTRAINT fk_peritaje_instruccion_fiscal FOREIGN KEY (id_instruccion_fiscal) REFERENCES diligencias.instruccion_fiscal (id_instruccion_fiscal),
    CONSTRAINT uq_peritaje_numero_informe UNIQUE (numero_informe_pericial)
);
GO

-- Tabla: diligencias.diligencia_lugar
CREATE TABLE [diligencias].[diligencia_lugar] (
    id_diligencia_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_diligencia INTEGER NOT NULL,
    id_lugar INTEGER NOT NULL,
    id_tipo_lugar INTEGER NULL,
    id_rol_lugar INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_diligencia_lugar_es_principal CHECK (es_principal IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_dil_lugar PRIMARY KEY (id_diligencia_lugar),
    CONSTRAINT fk_dillug_dil FOREIGN KEY (id_diligencia) REFERENCES diligencias.diligencia (id_diligencia),
    CONSTRAINT uq_dil_lugar_rol UNIQUE (id_diligencia, id_lugar, id_rol_lugar)
);
GO

-- Tabla: diligencias.informe_policial
CREATE TABLE [diligencias].[informe_policial] (
    id_informe INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_diligencia INTEGER NULL,
    id_tipo_informe INTEGER NOT NULL,
    numero_informe NVARCHAR(30) NULL,
    id_funcionario_autor INTEGER NOT NULL,
    fecha_elaboracion DATE NOT NULL,
    resumen NVARCHAR(4000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    estado_informe NVARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
    CONSTRAINT pk_informe_policial PRIMARY KEY (id_informe),
    CONSTRAINT fk_inf_tipo FOREIGN KEY (id_tipo_informe) REFERENCES diligencias.cat_tipo_informe (id_tipo_informe),
    CONSTRAINT fk_inf_dil_caso FOREIGN KEY (id_diligencia, id_caso) REFERENCES diligencias.diligencia (id_diligencia, id_caso)
);
GO

-- Tabla: diligencias.detencion
CREATE TABLE [diligencias].[detencion] (
    id_detencion INTEGER IDENTITY(1,1) NOT NULL,
    id_caso INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tipo_detencion INTEGER NOT NULL,
    id_funcionario_detentor INTEGER NOT NULL,
    id_unidad INTEGER NOT NULL,
    id_lugar INTEGER NULL,
    fecha_hora_detencion DATETIME2(7) NOT NULL,
    fecha_hora_puesta_disposicion DATETIME2(7) NULL,
    motivo NVARCHAR(2000) NOT NULL,
    id_diligencia INTEGER NULL,
    observaciones NVARCHAR(2000) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    alerta_extranjero SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_detencion_alerta_extranjero CHECK (alerta_extranjero IN (0,1)),
    CONSTRAINT pk_detencion PRIMARY KEY (id_detencion),
    CONSTRAINT fk_det_tipo FOREIGN KEY (id_tipo_detencion) REFERENCES diligencias.cat_tipo_detencion (id_tipo_detencion),
    CONSTRAINT uq_detencion_caso UNIQUE (id_detencion, id_caso),
    CONSTRAINT fk_det_dil_caso FOREIGN KEY (id_diligencia, id_caso) REFERENCES diligencias.diligencia (id_diligencia, id_caso)
);
GO

-- Tabla: diligencias.solicitud_concurrencia_perito
CREATE TABLE [diligencias].[solicitud_concurrencia_perito] (
    id_solicitud_perito INTEGER IDENTITY(1,1) NOT NULL,
    id_solicitud_pericial INTEGER NOT NULL,
    id_funcionario_perito INTEGER NOT NULL,
    id_especialidad_pericial INTEGER NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'ASIGNADO',
    fecha_asignacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_inicio DATETIME2(7) NULL,
    fecha_fin DATETIME2(7) NULL,
    observaciones NVARCHAR(500) NULL,
    CONSTRAINT pk_solicitud_perito PRIMARY KEY (id_solicitud_perito),
    CONSTRAINT uq_solicitud_perito UNIQUE (id_solicitud_pericial, id_funcionario_perito),
    CONSTRAINT fk_solperito_solicitud FOREIGN KEY (id_solicitud_pericial) REFERENCES diligencias.solicitud_concurrencia_pericial (id_solicitud_pericial),
    CONSTRAINT fk_solperito_esp FOREIGN KEY (id_especialidad_pericial) REFERENCES diligencias.cat_especialidad_pericial (id_especialidad_pericial)
);
GO

-- Tabla: diligencias.actividad_investigativa
CREATE TABLE [diligencias].[actividad_investigativa] (
    id_actividad INTEGER IDENTITY(1,1) NOT NULL,
    id_diligencia INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    tipo_actividad NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(MAX) NOT NULL,
    resultado NVARCHAR(MAX) NULL,
    es_resultado_negativo SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_actividad_investigativa_es_resultado_negativo CHECK (es_resultado_negativo IN (0,1)),
    fecha_actividad DATETIME2(7) NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_actividad_investigativa PRIMARY KEY (id_actividad),
    CONSTRAINT fk_act_diligencia FOREIGN KEY (id_diligencia) REFERENCES diligencias.diligencia (id_diligencia)
);
GO


-- ----- Esquema: catalogo_bienes -----

-- Tabla: catalogo_bienes.clase
CREATE TABLE [catalogo_bienes].[clase] (
    id_clase INTEGER IDENTITY(1,1) NOT NULL,
    id_version INTEGER NOT NULL,
    id_familia INTEGER NOT NULL,
    codigo NCHAR(6) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_clase_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_clase PRIMARY KEY (id_clase),
    CONSTRAINT uq_clase_codigo_version UNIQUE (codigo, id_version),
    CONSTRAINT fk_clase_version FOREIGN KEY (id_version) REFERENCES catalogo_bienes.version_catalogo (id_version),
    CONSTRAINT fk_clase_familia FOREIGN KEY (id_familia) REFERENCES catalogo_bienes.familia (id_familia)
);
GO


-- ----- Esquema: evidencias -----

-- Tabla: evidencias.especie_lugar
CREATE TABLE [evidencias].[especie_lugar] (
    id_especie_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_especie INTEGER NOT NULL,
    id_lugar INTEGER NOT NULL,
    id_tipo_lugar INTEGER NULL,
    id_rol_lugar INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_especie_lugar_es_principal CHECK (es_principal IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_especie_lugar PRIMARY KEY (id_especie_lugar),
    CONSTRAINT fk_esplug_esp FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie),
    CONSTRAINT uq_esp_lugar_rol UNIQUE (id_especie, id_lugar, id_rol_lugar)
);
GO

-- Tabla: evidencias.especie_arma
CREATE TABLE [evidencias].[especie_arma] (
    id_especie INTEGER NOT NULL,
    id_arma INTEGER NULL,
    id_clasificacion_arma INTEGER NULL,
    id_catalogo_arma INTEGER NULL,
    dgmn_ref NVARCHAR(50) NULL,
    CONSTRAINT pk_especie_arma PRIMARY KEY (id_especie),
    CONSTRAINT fk_arma_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie),
    CONSTRAINT fk_especie_arma_arma FOREIGN KEY (id_arma) REFERENCES evidencias.arma (id_arma),
    CONSTRAINT fk_especie_arma_clasificacion FOREIGN KEY (id_clasificacion_arma) REFERENCES evidencias.cat_clasificacion_arma (id_clasificacion_arma),
    CONSTRAINT fk_especie_arma_catalogo FOREIGN KEY (id_catalogo_arma) REFERENCES evidencias.cat_catalogo_armas (id_catalogo_arma)
);
GO

-- Tabla: evidencias.especie_droga
CREATE TABLE [evidencias].[especie_droga] (
    id_especie INTEGER NOT NULL,
    sustancia NVARCHAR(100) NOT NULL,
    peso_bruto_gr DECIMAL(12,4) NULL,
    peso_neto_gr DECIMAL(12,4) NULL,
    pureza_porcentaje DECIMAL(5,2) NULL,
    composicion NVARCHAR(500) NULL,
    informe_toxicologico_ref NVARCHAR(200) NULL,
    peligrosidad NVARCHAR(200) NULL,
    id_droga INTEGER NULL,
    es_orientativo SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_especie_droga_es_orientativo CHECK (es_orientativo IN (0,1)),
    resultado_instrumental NVARCHAR(100) NULL,
    CONSTRAINT pk_especie_droga PRIMARY KEY (id_especie),
    CONSTRAINT fk_droga_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie),
    CONSTRAINT fk_especie_droga_cat FOREIGN KEY (id_droga) REFERENCES evidencias.cat_droga (id_droga)
);
GO

-- Tabla: evidencias.especie_vehiculo
CREATE TABLE [evidencias].[especie_vehiculo] (
    id_especie INTEGER NOT NULL,
    patente NVARCHAR(10) NULL,
    id_vehiculo INTEGER NULL,
    marca NVARCHAR(100) NULL,
    modelo NVARCHAR(100) NULL,
    anio INTEGER NULL,
    color NVARCHAR(50) NULL,
    numero_motor NVARCHAR(100) NULL,
    numero_chasis NVARCHAR(100) NULL,
    CONSTRAINT pk_especie_vehiculo PRIMARY KEY (id_especie),
    CONSTRAINT fk_esveh_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie)
);
GO

-- Tabla: evidencias.especie_electronico
CREATE TABLE [evidencias].[especie_electronico] (
    id_especie INTEGER NOT NULL,
    tipo_dispositivo NVARCHAR(50) NOT NULL,
    marca NVARCHAR(100) NULL,
    modelo NVARCHAR(100) NULL,
    numero_serie NVARCHAR(100) NULL,
    imei NVARCHAR(20) NULL,
    mac_address NVARCHAR(20) NULL,
    capacidad_almacenamiento NVARCHAR(50) NULL,
    CONSTRAINT pk_especie_electronico PRIMARY KEY (id_especie),
    CONSTRAINT fk_elec_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie)
);
GO

-- Tabla: evidencias.especie_otras
CREATE TABLE [evidencias].[especie_otras] (
    id_especie INTEGER NOT NULL,
    categoria NVARCHAR(100) NULL,
    descripcion_detallada NVARCHAR(2000) NULL,
    denominacion NVARCHAR(200) NULL,
    valor_nominal DECIMAL(18,2) NULL,
    moneda NVARCHAR(10) NULL,
    observaciones NVARCHAR(1000) NULL,
    CONSTRAINT pk_especie_otras PRIMARY KEY (id_especie),
    CONSTRAINT fk_otras_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie)
);
GO

-- Tabla: evidencias.cadena_custodia
CREATE TABLE [evidencias].[cadena_custodia] (
    id_cadena INTEGER IDENTITY(1,1) NOT NULL,
    id_especie INTEGER NOT NULL,
    numero_eslabon INTEGER NULL,
    id_institucion_origen INTEGER NOT NULL,
    nombre_funcionario_origen NVARCHAR(200) NOT NULL,
    run_funcionario_origen NVARCHAR(12) NULL,
    id_funcionario_pdi_origen INTEGER NULL,
    id_institucion_destino INTEGER NOT NULL,
    nombre_funcionario_destino NVARCHAR(200) NOT NULL,
    run_funcionario_destino NVARCHAR(12) NULL,
    id_funcionario_pdi_destino INTEGER NULL,
    id_proposito INTEGER NOT NULL,
    ubicacion_destino NVARCHAR(200) NULL,
    condicion_especie NVARCHAR(500) NULL,
    sello_intacto SMALLINT NULL CONSTRAINT ck_cadena_custodia_sello_intacto CHECK (sello_intacto IN (0,1)),
    sello_numero NVARCHAR(50) NULL,
    firma_referencia NVARCHAR(200) NULL,
    fecha_transferencia DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    observaciones NVARCHAR(1000) NULL,
    declaracion_entregante NVARCHAR(1000) NULL,
    id_bodega INTEGER NULL,
    estado_custodia NVARCHAR(30) NOT NULL DEFAULT 'EN_TRANSITO',
    CONSTRAINT pk_cadena_custodia PRIMARY KEY (id_cadena),
    CONSTRAINT fk_cc_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie),
    CONSTRAINT fk_cc_inst_orig FOREIGN KEY (id_institucion_origen) REFERENCES evidencias.cat_institucion (id_institucion),
    CONSTRAINT fk_cc_inst_dest FOREIGN KEY (id_institucion_destino) REFERENCES evidencias.cat_institucion (id_institucion),
    CONSTRAINT fk_cc_proposito FOREIGN KEY (id_proposito) REFERENCES evidencias.cat_proposito_transferencia (id_proposito)
);
GO

-- Tabla: evidencias.especie_sello
CREATE TABLE [evidencias].[especie_sello] (
    id_sello INTEGER IDENTITY(1,1) NOT NULL,
    id_especie INTEGER NOT NULL,
    accion NVARCHAR(20) NOT NULL,
    numero_sello NVARCHAR(50) NOT NULL,
    id_institucion INTEGER NOT NULL,
    nombre_funcionario NVARCHAR(200) NOT NULL,
    run_funcionario NVARCHAR(12) NULL,
    id_funcionario_pdi INTEGER NULL,
    motivo NVARCHAR(500) NOT NULL,
    fecha_accion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_especie_sello PRIMARY KEY (id_sello),
    CONSTRAINT fk_sello_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie),
    CONSTRAINT fk_sello_inst FOREIGN KEY (id_institucion) REFERENCES evidencias.cat_institucion (id_institucion)
);
GO

-- Tabla: evidencias.especie_historial_estado
CREATE TABLE [evidencias].[especie_historial_estado] (
    id_historial INTEGER IDENTITY(1,1) NOT NULL,
    id_especie INTEGER NOT NULL,
    id_estado_anterior INTEGER NULL,
    id_estado_nuevo INTEGER NOT NULL,
    id_funcionario_cambio INTEGER NOT NULL,
    motivo NVARCHAR(1000) NULL,
    fecha_cambio DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_esp_historial PRIMARY KEY (id_historial),
    CONSTRAINT fk_esphist_esp FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie),
    CONSTRAINT fk_esphist_est_ant FOREIGN KEY (id_estado_anterior) REFERENCES evidencias.cat_estado_especie (id_estado_especie),
    CONSTRAINT fk_esphist_est_nvo FOREIGN KEY (id_estado_nuevo) REFERENCES evidencias.cat_estado_especie (id_estado_especie)
);
GO

-- Tabla: evidencias.especie_retencion
CREATE TABLE [evidencias].[especie_retencion] (
    id_retencion INTEGER IDENTITY(1,1) NOT NULL,
    id_especie INTEGER NOT NULL,
    motivo_retencion NVARCHAR(500) NOT NULL,
    fecha_retencion_hasta DATE NULL,
    base_legal NVARCHAR(200) NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_especie_retencion PRIMARY KEY (id_retencion),
    CONSTRAINT fk_ret_especie FOREIGN KEY (id_especie) REFERENCES evidencias.especie (id_especie)
);
GO


-- ----- Esquema: cooperacion_int -----

-- Tabla: cooperacion_int.tipo_consulta_solicitud_interpol
CREATE TABLE [cooperacion_int].[tipo_consulta_solicitud_interpol] (
    id_tipo_consulta_solicitud INTEGER IDENTITY(1,1) NOT NULL,
    id_solicitud INTEGER NOT NULL,
    id_cat_elemento_cooperacion_internacional INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_tipo_consulta_solicitud PRIMARY KEY (id_tipo_consulta_solicitud),
    CONSTRAINT uq_tipo_consulta_sol UNIQUE (id_solicitud, id_cat_elemento_cooperacion_internacional),
    CONSTRAINT fk_tipo_consulta_sol FOREIGN KEY (id_solicitud) REFERENCES cooperacion_int.solicitud_interpol (id_solicitud),
    CONSTRAINT fk_tipo_consulta_cat FOREIGN KEY (id_cat_elemento_cooperacion_internacional) REFERENCES cooperacion_int.cat_elemento_cooperacion_internacional (id_cat_elemento_cooperacion_internacional)
);
GO

-- Tabla: cooperacion_int.motivo_solicitud_interpol
CREATE TABLE [cooperacion_int].[motivo_solicitud_interpol] (
    id_motivo_solicitud INTEGER IDENTITY(1,1) NOT NULL,
    id_solicitud INTEGER NOT NULL,
    id_cat_elemento_cooperacion_internacional INTEGER NOT NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_motivo_solicitud PRIMARY KEY (id_motivo_solicitud),
    CONSTRAINT uq_motivo_sol UNIQUE (id_solicitud, id_cat_elemento_cooperacion_internacional),
    CONSTRAINT fk_motivo_sol FOREIGN KEY (id_solicitud) REFERENCES cooperacion_int.solicitud_interpol (id_solicitud),
    CONSTRAINT fk_motivo_cat FOREIGN KEY (id_cat_elemento_cooperacion_internacional) REFERENCES cooperacion_int.cat_elemento_cooperacion_internacional (id_cat_elemento_cooperacion_internacional)
);
GO


-- ----- Esquema: analitica -----

-- Tabla: analitica.foco_caso
CREATE TABLE [analitica].[foco_caso] (
    id_foco_caso INTEGER IDENTITY(1,1) NOT NULL,
    id_foco INTEGER NOT NULL,
    id_caso INTEGER NOT NULL,
    es_caso_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_foco_caso_es_caso_principal CHECK (es_caso_principal IN (0,1)),
    fecha_vinculacion DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    motivo NVARCHAR(500) NULL,
    id_funcionario_registra INTEGER NULL,
    CONSTRAINT pk_foco_caso PRIMARY KEY (id_foco_caso),
    CONSTRAINT uq_foco_caso UNIQUE (id_foco, id_caso),
    CONSTRAINT fk_fococaso_foco FOREIGN KEY (id_foco) REFERENCES analitica.foco_investigativo (id_foco)
);
GO


-- ----- Esquema: ubicacion -----

-- Tabla: ubicacion.lugar_base
CREATE TABLE [ubicacion].[lugar_base] (
    id_lugar_base INTEGER IDENTITY(1,1) NOT NULL,
    calle NVARCHAR(200) NULL,
    numero NVARCHAR(20) NULL,
    block NVARCHAR(20) NULL,
    departamento NVARCHAR(20) NULL,
    nombre_lugar NVARCHAR(200) NULL,
    id_comuna INTEGER NULL,
    latitud DECIMAL(10,7) NULL,
    longitud DECIMAL(10,7) NULL,
    referencia NVARCHAR(500) NULL,
    arcgis_ref NVARCHAR(100) NULL,
    origen_geocodificacion NVARCHAR(10) NULL,
    id_funcionario_registro INTEGER NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    CONSTRAINT pk_lugar_base PRIMARY KEY (id_lugar_base),
    CONSTRAINT fk_lugar_base_comuna FOREIGN KEY (id_comuna) REFERENCES ubicacion.comuna (id_comuna),
    CONSTRAINT ck_lugar_base_origen_geocodificacion CHECK ( origen_geocodificacion IS NULL OR origen_geocodificacion IN ('ARCGIS', 'MANUAL') )
);
GO


-- ----- Esquema: vehiculos -----

-- Tabla: vehiculos.persona_vehiculo
CREATE TABLE [vehiculos].[persona_vehiculo] (
    id_persona_vehiculo INTEGER IDENTITY(1,1) NOT NULL,
    id_persona INTEGER NOT NULL,
    id_vehiculo INTEGER NOT NULL,
    id_tipo_relacion_vehiculo INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_persona_vehiculo_es_principal CHECK (es_principal IN (0,1)),
    fecha_inicio DATE NOT NULL DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Pacific SA Standard Time' AS DATE),
    fecha_fin DATE NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_persona_vehiculo PRIMARY KEY (id_persona_vehiculo),
    CONSTRAINT fk_perveh_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculos.vehiculo (id_vehiculo),
    CONSTRAINT fk_perveh_tipo FOREIGN KEY (id_tipo_relacion_vehiculo) REFERENCES vehiculos.cat_tipo_relacion_persona (id_tipo_relacion_vehiculo),
    CONSTRAINT uq_persona_vehiculo_rel UNIQUE (id_persona, id_vehiculo, id_tipo_relacion_vehiculo, fecha_inicio)
);
GO


-- ----- Esquema: diligencias -----

-- Tabla: diligencias.detencion_lugar
CREATE TABLE [diligencias].[detencion_lugar] (
    id_detencion_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_detencion INTEGER NOT NULL,
    id_lugar INTEGER NOT NULL,
    id_tipo_lugar INTEGER NULL,
    id_rol_lugar INTEGER NOT NULL,
    es_principal SMALLINT NOT NULL DEFAULT 0 CONSTRAINT ck_detencion_lugar_es_principal CHECK (es_principal IN (0,1)),
    observaciones NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_det_lugar PRIMARY KEY (id_detencion_lugar),
    CONSTRAINT fk_detlug_det FOREIGN KEY (id_detencion) REFERENCES diligencias.detencion (id_detencion),
    CONSTRAINT uq_det_lugar_rol UNIQUE (id_detencion, id_lugar, id_rol_lugar)
);
GO


-- ----- Esquema: catalogo_bienes -----

-- Tabla: catalogo_bienes.producto
CREATE TABLE [catalogo_bienes].[producto] (
    id_producto INTEGER IDENTITY(1,1) NOT NULL,
    id_version INTEGER NOT NULL,
    id_clase INTEGER NOT NULL,
    codigo NCHAR(8) NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    activo SMALLINT NOT NULL DEFAULT 1 CONSTRAINT ck_producto_activo CHECK (activo IN (0,1)),
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_producto PRIMARY KEY (id_producto),
    CONSTRAINT uq_producto_codigo_version UNIQUE (codigo, id_version),
    CONSTRAINT fk_producto_version FOREIGN KEY (id_version) REFERENCES catalogo_bienes.version_catalogo (id_version),
    CONSTRAINT fk_producto_clase FOREIGN KEY (id_clase) REFERENCES catalogo_bienes.clase (id_clase)
);
GO


-- ----- Esquema: ubicacion -----

-- Tabla: ubicacion.lugar
CREATE TABLE [ubicacion].[lugar] (
    id_lugar INTEGER IDENTITY(1,1) NOT NULL,
    id_lugar_base INTEGER NOT NULL,
    id_tipo_subdivision INTEGER NOT NULL,
    piso NVARCHAR(10) NULL,
    numero_subdivision NVARCHAR(50) NULL,
    descripcion NVARCHAR(500) NULL,
    fecha_registro DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_actualizacion DATETIME2(7) NULL,
    fecha_eliminacion DATETIME2(7) NULL,
    CONSTRAINT pk_lugar PRIMARY KEY (id_lugar),
    CONSTRAINT fk_lugar_base FOREIGN KEY (id_lugar_base) REFERENCES ubicacion.lugar_base (id_lugar_base),
    CONSTRAINT fk_lugar_tipo_subdivision FOREIGN KEY (id_tipo_subdivision) REFERENCES ubicacion.cat_tipo_subdivision (id_tipo_subdivision)
);
GO


-- =============================================================================
-- PASO 3 — FOREIGN KEYS DIFERIDAS (cruzadas + ciclos topológicos)
-- =============================================================================

-- ----- FKs declaradas como ALTER en fuente PostgreSQL -----

-- FKs hacia/desde tareas
ALTER TABLE [tareas].[tarea]
    ADD CONSTRAINT fk_tarea_estado_actual FOREIGN KEY (id_estado_tarea_actual)
    REFERENCES [tareas].[estado_tarea] (id_estado_tarea);
GO

ALTER TABLE [tareas].[bandeja]
    ADD CONSTRAINT fk_bandeja_unidad FOREIGN KEY (id_unidad)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [tareas].[bandeja]
    ADD CONSTRAINT fk_bandeja_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [tareas].[estado_tarea]
    ADD CONSTRAINT fk_estado_funcionario FOREIGN KEY (id_funcionario_estado)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [tareas].[documento]
    ADD CONSTRAINT fk_documento_funcionario_reg FOREIGN KEY (id_funcionario_registro)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [tareas].[documento]
    ADD CONSTRAINT fk_documento_funcionario_anu FOREIGN KEY (id_funcionario_anulacion)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [tareas].[version_documento]
    ADD CONSTRAINT fk_version_funcionario FOREIGN KEY (id_funcionario_version)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [tareas].[version_documento]
    ADD CONSTRAINT fk_version_funcionario_visa FOREIGN KEY (id_funcionario_visado)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [tareas].[version_documento]
    ADD CONSTRAINT fk_version_archivo_visar FOREIGN KEY (id_archivo_por_visar)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [tareas].[version_documento]
    ADD CONSTRAINT fk_version_archivo_firmado FOREIGN KEY (id_archivo_firmado)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [tareas].[tarea_archivo_adjunto]
    ADD CONSTRAINT fk_tarea_archivo FOREIGN KEY (id_archivo)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [tareas].[tarea_denuncia]
    ADD CONSTRAINT fk_tarea_denuncia_den FOREIGN KEY (id_denuncia)
    REFERENCES [denuncias].[denuncia] (id_denuncia);
GO

ALTER TABLE [tareas].[tarea_diligencia]
    ADD CONSTRAINT fk_tarea_diligencia_dil FOREIGN KEY (id_diligencia)
    REFERENCES [diligencias].[diligencia] (id_diligencia);
GO

-- FKs hacia/desde ubicacion
ALTER TABLE [ubicacion].[lugar_base]
    ADD CONSTRAINT fk_lugar_base_funcionario_registro FOREIGN KEY (id_funcionario_registro)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde organizacion
ALTER TABLE [organizacion].[funcionario]
    ADD CONSTRAINT fk_func_persona FOREIGN KEY (id_funcionario)
    REFERENCES [personas].[persona] (id_persona);
GO

-- FKs hacia/desde personas
ALTER TABLE [personas].[persona]
    ADD CONSTRAINT fk_persona_pais FOREIGN KEY (id_pais_nacionalidad)
    REFERENCES [ubicacion].[pais] (id_pais);
GO

ALTER TABLE [personas].[persona]
    ADD CONSTRAINT fk_persona_comuna_nac FOREIGN KEY (id_comuna_nacimiento)
    REFERENCES [ubicacion].[comuna] (id_comuna);
GO

ALTER TABLE [personas].[identificacion]
    ADD CONSTRAINT fk_ident_pais FOREIGN KEY (id_pais_emisor)
    REFERENCES [ubicacion].[pais] (id_pais);
GO

ALTER TABLE [personas].[empleo]
    ADD CONSTRAINT fk_empleo_lugar FOREIGN KEY (id_lugar_trabajo)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [personas].[persona_lugar]
    ADD CONSTRAINT fk_perlug_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [personas].[persona_lugar]
    ADD CONSTRAINT fk_perlug_tipo FOREIGN KEY (id_tipo_lugar)
    REFERENCES [ubicacion].[cat_tipo_lugar] (id_tipo_lugar);
GO

ALTER TABLE [personas].[persona_lugar]
    ADD CONSTRAINT fk_perlug_rol FOREIGN KEY (id_rol_lugar)
    REFERENCES [ubicacion].[cat_rol_lugar] (id_rol_lugar);
GO

ALTER TABLE [personas].[fotografia]
    ADD CONSTRAINT fk_foto_archivo FOREIGN KEY (id_archivo)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [personas].[anotacion]
    ADD CONSTRAINT fk_anotacion_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde vehiculos
ALTER TABLE [vehiculos].[persona_vehiculo]
    ADD CONSTRAINT fk_perveh_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

-- FKs hacia/desde archivos
ALTER TABLE [archivos].[archivo]
    ADD CONSTRAINT fk_archivo_funcionario FOREIGN KEY (id_funcionario_carga)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde casos
ALTER TABLE [casos].[caso_historial_estado]
    ADD CONSTRAINT fk_historial_clasificacion_delito FOREIGN KEY (id_clasificacion_delito_anterior)
    REFERENCES [investigacion].[clasificacion_delito] (id_clasificacion_delito);
GO

ALTER TABLE [casos].[caso_persona_rol]
    ADD CONSTRAINT fk_caso_persona_rol_defensor FOREIGN KEY (id_defensor)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[cat_programa_seguridad]
    ADD CONSTRAINT fk_progseq_comuna FOREIGN KEY (id_comuna)
    REFERENCES [ubicacion].[comuna] (id_comuna);
GO

ALTER TABLE [casos].[carpeta]
    ADD CONSTRAINT fk_carpeta_unidad FOREIGN KEY (id_unidad_responsable)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [casos].[carpeta]
    ADD CONSTRAINT fk_carpeta_funcionario FOREIGN KEY (id_funcionario_creador)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[carpeta_colaborador]
    ADD CONSTRAINT fk_colabcarp_func FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[carpeta_colaborador]
    ADD CONSTRAINT fk_colabcarp_invitador FOREIGN KEY (id_funcionario_invitador)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[asignacion_funcionario]
    ADD CONSTRAINT fk_asignfunc_cargo FOREIGN KEY (id_cargo_funcion)
    REFERENCES [organizacion].[cat_cargo_funcion] (id_cargo_funcion);
GO

ALTER TABLE [casos].[caso_persona_rol]
    ADD CONSTRAINT fk_casoperrol_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [casos].[agrupacion_causa]
    ADD CONSTRAINT fk_agrcausa_solicita FOREIGN KEY (id_funcionario_solicita)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[agrupacion_causa]
    ADD CONSTRAINT fk_agrcausa_aprueba FOREIGN KEY (id_funcionario_aprueba)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[matriz_riesgo]
    ADD CONSTRAINT fk_matriesgo_elabora FOREIGN KEY (id_funcionario_elabora)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[matriz_riesgo]
    ADD CONSTRAINT fk_matriesgo_aprueba FOREIGN KEY (id_funcionario_aprueba)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[matriz_riesgo]
    ADD CONSTRAINT fk_matriesgo_arch FOREIGN KEY (id_archivo_adjunto)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [casos].[agrupacion_causa_caso]
    ADD CONSTRAINT fk_agrcasocaso_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[caso_historial_estado]
    ADD CONSTRAINT fk_histcaso_func FOREIGN KEY (id_funcionario_cambio)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [casos].[asignacion_funcionario]
    ADD CONSTRAINT fk_asignfunc_func FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde investigacion
ALTER TABLE [investigacion].[hecho_lugar]
    ADD CONSTRAINT fk_hecholug_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [investigacion].[delito_imputado_persona]
    ADD CONSTRAINT fk_delper_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [investigacion].[hecho_persona_rol]
    ADD CONSTRAINT fk_hecoperrol_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [investigacion].[subtipo_delito_secuestro]
    ADD CONSTRAINT fk_subsec_func FOREIGN KEY (id_funcionario_clasifica)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [investigacion].[hecho]
    ADD CONSTRAINT fk_hecho_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [investigacion].[delito_imputado]
    ADD CONSTRAINT fk_delimp_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [investigacion].[hecho_lugar]
    ADD CONSTRAINT fk_hecholug_tipo FOREIGN KEY (id_tipo_lugar)
    REFERENCES [ubicacion].[cat_tipo_lugar] (id_tipo_lugar);
GO

ALTER TABLE [investigacion].[hecho_lugar]
    ADD CONSTRAINT fk_hecholug_rol FOREIGN KEY (id_rol_lugar)
    REFERENCES [ubicacion].[cat_rol_lugar] (id_rol_lugar);
GO

ALTER TABLE [investigacion].[hecho_persona_rol]
    ADD CONSTRAINT fk_hecoperrol_rol FOREIGN KEY (id_tipo_rol_persona)
    REFERENCES [casos].[cat_tipo_rol_persona] (id_tipo_rol_persona);
GO

ALTER TABLE [investigacion].[hecho_fenomeno]
    ADD CONSTRAINT fk_hecho_fenomeno_fenomeno FOREIGN KEY (id_fenomeno)
    REFERENCES [denuncias].[fenomeno_delictual] (id_fenomeno);
GO

ALTER TABLE [investigacion].[hecho_fenomeno]
    ADD CONSTRAINT fk_hecho_fenomeno_funcionario FOREIGN KEY (id_funcionario_asigna)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde denuncias
ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT fk_denuncia_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT fk_denuncia_func FOREIGN KEY (id_funcionario_receptor)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT fk_denuncia_organismo_externo FOREIGN KEY (id_organismo_origen_externo)
    REFERENCES [organizacion].[cat_organismo_externo] (id_organismo_externo);
GO

ALTER TABLE [denuncias].[procedimiento_policial]
    ADD CONSTRAINT fk_proc_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [denuncias].[procedimiento_policial]
    ADD CONSTRAINT fk_proc_clasificacion_delito FOREIGN KEY (id_clasificacion_delito_principal)
    REFERENCES [investigacion].[clasificacion_delito] (id_clasificacion_delito);
GO

ALTER TABLE [denuncias].[procedimiento_policial]
    ADD CONSTRAINT fk_proc_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [denuncias].[procedimiento_policial]
    ADD CONSTRAINT fk_proc_func FOREIGN KEY (id_funcionario_responsable)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [denuncias].[procedimiento_policial]
    ADD CONSTRAINT fk_proc_programa FOREIGN KEY (id_programa_seguridad)
    REFERENCES [casos].[cat_programa_seguridad] (id_programa_seguridad);
GO

ALTER TABLE [denuncias].[relato]
    ADD CONSTRAINT fk_relato_declarante FOREIGN KEY (id_persona_declarante)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [denuncias].[encargo_suev]
    ADD CONSTRAINT fk_suev_vehiculo FOREIGN KEY (id_vehiculo)
    REFERENCES [vehiculos].[vehiculo] (id_vehiculo);
GO

ALTER TABLE [denuncias].[encargo_suev]
    ADD CONSTRAINT fk_suev_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [denuncias].[pauta_vif]
    ADD CONSTRAINT fk_vif_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [denuncias].[pauta_vif]
    ADD CONSTRAINT fk_vif_imputado FOREIGN KEY (id_persona_imputado)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [denuncias].[pauta_vif]
    ADD CONSTRAINT fk_vif_victima FOREIGN KEY (id_persona_victima)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [denuncias].[pauta_vif]
    ADD CONSTRAINT fk_vif_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [denuncias].[procedimiento_persona]
    ADD CONSTRAINT fk_procpers_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [denuncias].[procedimiento_persona]
    ADD CONSTRAINT fk_procpers_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [denuncias].[denuncia_hecho]
    ADD CONSTRAINT fk_denhecho_hecho FOREIGN KEY (id_hecho)
    REFERENCES [investigacion].[hecho] (id_hecho);
GO

ALTER TABLE [denuncias].[relato]
    ADD CONSTRAINT fk_relato_tipo FOREIGN KEY (id_tipo_relato)
    REFERENCES [casos].[cat_tipo_relato] (id_tipo_relato);
GO

ALTER TABLE [denuncias].[relato]
    ADD CONSTRAINT fk_relato_archivo FOREIGN KEY (id_archivo)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [denuncias].[relato]
    ADD CONSTRAINT fk_relato_func FOREIGN KEY (id_funcionario_receptor)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [denuncias].[denuncia_persona_rol]
    ADD CONSTRAINT fk_denperrol_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [denuncias].[denuncia_persona_rol]
    ADD CONSTRAINT fk_denperrol_rol FOREIGN KEY (id_tipo_rol_persona)
    REFERENCES [casos].[cat_tipo_rol_persona] (id_tipo_rol_persona);
GO

ALTER TABLE [denuncias].[encargo_persona]
    ADD CONSTRAINT fk_encargo_persona_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [denuncias].[encargo_persona]
    ADD CONSTRAINT fk_encargo_persona_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [denuncias].[encargo_persona]
    ADD CONSTRAINT fk_encargo_persona_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde diligencias
ALTER TABLE [diligencias].[diligencia]
    ADD CONSTRAINT fk_dil_hecho_caso FOREIGN KEY (id_hecho, id_caso)
    REFERENCES [investigacion].[hecho] (id_hecho, id_caso);
GO

ALTER TABLE [diligencias].[peritaje]
    ADD CONSTRAINT fk_per_esp_caso FOREIGN KEY (id_especie, id_caso)
    REFERENCES [evidencias].[especie] (id_especie, id_caso);
GO

ALTER TABLE [diligencias].[instruccion_fiscal]
    ADD CONSTRAINT fk_instruccion_fiscal_denuncia FOREIGN KEY (id_denuncia)
    REFERENCES [denuncias].[denuncia] (id_denuncia);
GO

ALTER TABLE [diligencias].[instruccion_fiscal]
    ADD CONSTRAINT fk_instfisc_nivel FOREIGN KEY (id_nivel_confidencialidad)
    REFERENCES [archivos].[cat_nivel_confidencialidad] (id_nivel);
GO

ALTER TABLE [diligencias].[diligencia]
    ADD CONSTRAINT fk_dil_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [diligencias].[solicitud_concurrencia_pericial]
    ADD CONSTRAINT fk_solper_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[solicitud_concurrencia_pericial]
    ADD CONSTRAINT fk_solper_func FOREIGN KEY (id_funcionario_solicitante)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[solicitud_concurrencia_pericial]
    ADD CONSTRAINT fk_solper_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [diligencias].[diligencia_lugar]
    ADD CONSTRAINT fk_dillug_tipo FOREIGN KEY (id_tipo_lugar)
    REFERENCES [ubicacion].[cat_tipo_lugar] (id_tipo_lugar);
GO

ALTER TABLE [diligencias].[solicitud_concurrencia_perito]
    ADD CONSTRAINT fk_solperito_func FOREIGN KEY (id_funcionario_perito)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[detencion_lugar]
    ADD CONSTRAINT fk_detlug_tipo FOREIGN KEY (id_tipo_lugar)
    REFERENCES [ubicacion].[cat_tipo_lugar] (id_tipo_lugar);
GO

ALTER TABLE [diligencias].[detencion]
    ADD CONSTRAINT fk_det_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [diligencias].[instruccion_fiscal]
    ADD CONSTRAINT fk_instfisc_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[instruccion_fiscal]
    ADD CONSTRAINT fk_instfisc_unid FOREIGN KEY (id_unidad_destinataria)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [diligencias].[notificacion_externa]
    ADD CONSTRAINT fk_notif_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[notificacion_externa]
    ADD CONSTRAINT fk_notif_est FOREIGN KEY (id_estado_caso_resultante)
    REFERENCES [casos].[cat_estado_caso] (id_estado_caso);
GO

ALTER TABLE [diligencias].[notificacion_externa]
    ADD CONSTRAINT fk_notif_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[notificacion_externa]
    ADD CONSTRAINT fk_notif_arch FOREIGN KEY (id_archivo)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [diligencias].[diligencia]
    ADD CONSTRAINT fk_dil_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[diligencia]
    ADD CONSTRAINT fk_dil_func FOREIGN KEY (id_funcionario_responsable)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[peritaje]
    ADD CONSTRAINT fk_per_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[peritaje]
    ADD CONSTRAINT fk_per_inst FOREIGN KEY (id_institucion_ejecutora)
    REFERENCES [evidencias].[cat_institucion] (id_institucion);
GO

ALTER TABLE [diligencias].[peritaje]
    ADD CONSTRAINT fk_per_func FOREIGN KEY (id_funcionario_solicitante)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[diligencia_lugar]
    ADD CONSTRAINT fk_dillug_lug FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [diligencias].[diligencia_lugar]
    ADD CONSTRAINT fk_dillug_rol FOREIGN KEY (id_rol_lugar)
    REFERENCES [ubicacion].[cat_rol_lugar] (id_rol_lugar);
GO

ALTER TABLE [diligencias].[informe_policial]
    ADD CONSTRAINT fk_inf_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[informe_policial]
    ADD CONSTRAINT fk_inf_func FOREIGN KEY (id_funcionario_autor)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[detencion]
    ADD CONSTRAINT fk_det_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[detencion]
    ADD CONSTRAINT fk_det_func FOREIGN KEY (id_funcionario_detentor)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[detencion]
    ADD CONSTRAINT fk_det_unidad FOREIGN KEY (id_unidad)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [diligencias].[detencion]
    ADD CONSTRAINT fk_det_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [diligencias].[detencion_lugar]
    ADD CONSTRAINT fk_detlug_lug FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [diligencias].[detencion_lugar]
    ADD CONSTRAINT fk_detlug_rol FOREIGN KEY (id_rol_lugar)
    REFERENCES [ubicacion].[cat_rol_lugar] (id_rol_lugar);
GO

ALTER TABLE [diligencias].[orden_detencion]
    ADD CONSTRAINT fk_od_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[orden_detencion]
    ADD CONSTRAINT fk_od_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [diligencias].[orden_detencion]
    ADD CONSTRAINT fk_od_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[orden_arresto]
    ADD CONSTRAINT fk_oa_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [diligencias].[orden_arresto]
    ADD CONSTRAINT fk_oa_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [diligencias].[orden_arresto]
    ADD CONSTRAINT fk_oa_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [diligencias].[actividad_investigativa]
    ADD CONSTRAINT fk_act_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde evidencias
ALTER TABLE [evidencias].[evidencia]
    ADD CONSTRAINT fk_evi_hecho_caso FOREIGN KEY (id_hecho, id_caso)
    REFERENCES [investigacion].[hecho] (id_hecho, id_caso);
GO

ALTER TABLE [evidencias].[evidencia]
    ADD CONSTRAINT fk_evi_dil_caso FOREIGN KEY (id_diligencia, id_caso)
    REFERENCES [diligencias].[diligencia] (id_diligencia, id_caso);
GO

ALTER TABLE [evidencias].[incautacion]
    ADD CONSTRAINT fk_incautacion_region FOREIGN KEY (id_region_incautacion)
    REFERENCES [ubicacion].[region] (id_region);
GO

ALTER TABLE [evidencias].[evidencia]
    ADD CONSTRAINT fk_evi_lugar FOREIGN KEY (id_lugar_hallazgo)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [evidencias].[incautacion]
    ADD CONSTRAINT fk_incaut_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [evidencias].[incautacion]
    ADD CONSTRAINT fk_incaut_diligencia FOREIGN KEY (id_diligencia)
    REFERENCES [diligencias].[diligencia] (id_diligencia);
GO

ALTER TABLE [evidencias].[incautacion]
    ADD CONSTRAINT fk_incaut_lugar FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [evidencias].[incautacion]
    ADD CONSTRAINT fk_incaut_func FOREIGN KEY (id_funcionario_responsable)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [evidencias].[incautacion]
    ADD CONSTRAINT fk_incaut_func_incautacion FOREIGN KEY (id_funcionario_incautacion)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [evidencias].[evidencia_lugar]
    ADD CONSTRAINT fk_evilug_tipo FOREIGN KEY (id_tipo_lugar)
    REFERENCES [ubicacion].[cat_tipo_lugar] (id_tipo_lugar);
GO

ALTER TABLE [evidencias].[especie_lugar]
    ADD CONSTRAINT fk_esplug_tipo FOREIGN KEY (id_tipo_lugar)
    REFERENCES [ubicacion].[cat_tipo_lugar] (id_tipo_lugar);
GO

ALTER TABLE [evidencias].[especie_vehiculo]
    ADD CONSTRAINT fk_esveh_vehiculo FOREIGN KEY (id_vehiculo)
    REFERENCES [vehiculos].[vehiculo] (id_vehiculo);
GO

ALTER TABLE [evidencias].[evidencia]
    ADD CONSTRAINT fk_evi_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [evidencias].[evidencia]
    ADD CONSTRAINT fk_evi_dil FOREIGN KEY (id_diligencia)
    REFERENCES [diligencias].[diligencia] (id_diligencia);
GO

ALTER TABLE [evidencias].[evidencia]
    ADD CONSTRAINT fk_evi_func FOREIGN KEY (id_funcionario_incautador)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [evidencias].[evidencia_lugar]
    ADD CONSTRAINT fk_evilug_lug FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [evidencias].[evidencia_lugar]
    ADD CONSTRAINT fk_evilug_rol FOREIGN KEY (id_rol_lugar)
    REFERENCES [ubicacion].[cat_rol_lugar] (id_rol_lugar);
GO

ALTER TABLE [evidencias].[especie]
    ADD CONSTRAINT fk_esp_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [evidencias].[especie]
    ADD CONSTRAINT fk_especie_producto FOREIGN KEY (id_producto)
    REFERENCES [catalogo_bienes].[producto] (id_producto);
GO

ALTER TABLE [evidencias].[especie_lugar]
    ADD CONSTRAINT fk_esplug_lug FOREIGN KEY (id_lugar)
    REFERENCES [ubicacion].[lugar] (id_lugar);
GO

ALTER TABLE [evidencias].[especie_lugar]
    ADD CONSTRAINT fk_esplug_rol FOREIGN KEY (id_rol_lugar)
    REFERENCES [ubicacion].[cat_rol_lugar] (id_rol_lugar);
GO

ALTER TABLE [evidencias].[cadena_custodia]
    ADD CONSTRAINT fk_cc_func_orig FOREIGN KEY (id_funcionario_pdi_origen)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [evidencias].[cadena_custodia]
    ADD CONSTRAINT fk_cc_func_dest FOREIGN KEY (id_funcionario_pdi_destino)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [evidencias].[especie_sello]
    ADD CONSTRAINT fk_sello_func FOREIGN KEY (id_funcionario_pdi)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [evidencias].[especie_historial_estado]
    ADD CONSTRAINT fk_esphist_func FOREIGN KEY (id_funcionario_cambio)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde migracion
ALTER TABLE [migracion].[denuncia_administrativa_migratoria]
    ADD CONSTRAINT fk_denmig_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [migracion].[denuncia_administrativa_migratoria]
    ADD CONSTRAINT fk_denmig_func FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [migracion].[denuncia_administrativa_migratoria]
    ADD CONSTRAINT fk_denmig_unidad FOREIGN KEY (id_unidad)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [migracion].[expulsion]
    ADD CONSTRAINT fk_exp_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [migracion].[expulsion]
    ADD CONSTRAINT fk_exp_pais FOREIGN KEY (pais_destino)
    REFERENCES [ubicacion].[pais] (id_pais);
GO

ALTER TABLE [migracion].[expulsion]
    ADD CONSTRAINT fk_exp_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [migracion].[fiscalizacion_planificada]
    ADD CONSTRAINT fk_fisc_unidad FOREIGN KEY (id_unidad)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [migracion].[fiscalizacion_planificada]
    ADD CONSTRAINT fk_fisc_func FOREIGN KEY (id_funcionario_responsable)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

-- FKs hacia/desde cooperacion_int
ALTER TABLE [cooperacion_int].[solicitud_interpol]
    ADD CONSTRAINT fk_sol_persona FOREIGN KEY (id_persona)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [cooperacion_int].[solicitud_interpol]
    ADD CONSTRAINT fk_sol_endosador FOREIGN KEY (id_funcionario_endosador)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [cooperacion_int].[solicitud_interpol]
    ADD CONSTRAINT fk_sol_func_registro FOREIGN KEY (id_funcionario_registro)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [cooperacion_int].[solicitud_interpol]
    ADD CONSTRAINT fk_sol_func_cierra FOREIGN KEY (id_funcionario_cierra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [cooperacion_int].[solicitud_interpol]
    ADD CONSTRAINT fk_sol_pais_emisor FOREIGN KEY (id_pais_emisor)
    REFERENCES [ubicacion].[pais] (id_pais);
GO

ALTER TABLE [cooperacion_int].[solicitud_interpol]
    ADD CONSTRAINT fk_sol_pais_receptor FOREIGN KEY (id_pais_receptor)
    REFERENCES [ubicacion].[pais] (id_pais);
GO

-- FKs hacia/desde analitica
ALTER TABLE [analitica].[reporte_analitico]
    ADD CONSTRAINT fk_reporte_autor FOREIGN KEY (id_funcionario_autor)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [analitica].[reporte_analitico]
    ADD CONSTRAINT fk_reporte_unidad FOREIGN KEY (id_unidad)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [analitica].[reporte_analitico]
    ADD CONSTRAINT fk_reporte_aprueba FOREIGN KEY (id_funcionario_aprueba)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [analitica].[reporte_analitico]
    ADD CONSTRAINT fk_reporte_archivo FOREIGN KEY (id_archivo)
    REFERENCES [archivos].[archivo] (id_archivo);
GO

ALTER TABLE [analitica].[foco_investigativo]
    ADD CONSTRAINT fk_foco_func FOREIGN KEY (id_funcionario_creador)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [analitica].[foco_investigativo]
    ADD CONSTRAINT fk_foco_unidad FOREIGN KEY (id_unidad)
    REFERENCES [organizacion].[unidad] (id_unidad);
GO

ALTER TABLE [analitica].[vinculo_entidad]
    ADD CONSTRAINT fk_vincent_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [analitica].[matriz_analisis]
    ADD CONSTRAINT fk_matran_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO

ALTER TABLE [analitica].[reporte_analitico_caso]
    ADD CONSTRAINT fk_reptcaso_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [analitica].[foco_caso]
    ADD CONSTRAINT fk_fococaso_caso FOREIGN KEY (id_caso)
    REFERENCES [casos].[caso] (id_caso);
GO

ALTER TABLE [analitica].[foco_caso]
    ADD CONSTRAINT fk_fococaso_func FOREIGN KEY (id_funcionario_registra)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO


-- =============================================================================
-- PASO 4 — ÍNDICES
-- =============================================================================


-- ----- Índices: configuracion -----
CREATE INDEX [ix_cat_elemento_dominio_id_dominio] ON [configuracion].[cat_elemento_dominio] (id_dominio);
GO

CREATE INDEX [ix_cat_elemento_dominio_activo] ON [configuracion].[cat_elemento_dominio] (id_dominio, activo);
GO


-- ----- Índices: tareas -----
CREATE INDEX [ix_tarea_tipo] ON [tareas].[tarea] (id_tipo_tarea);
GO

CREATE INDEX [ix_tarea_dependiente] ON [tareas].[tarea] (id_tarea_dependiente);
GO

CREATE INDEX [ix_tarea_estado_actual] ON [tareas].[tarea] (id_estado_tarea_actual);
GO

CREATE INDEX [ix_estado_tarea_tarea] ON [tareas].[estado_tarea] (id_tarea);
GO

CREATE INDEX [ix_estado_tarea_fecha] ON [tareas].[estado_tarea] (fecha_estado);
GO

CREATE INDEX [ix_estado_tarea_bandeja] ON [tareas].[estado_tarea] (id_bandeja);
GO

CREATE INDEX [ix_documento_tipo] ON [tareas].[documento] (id_tipo_documento);
GO

CREATE INDEX [ix_version_documento_doc] ON [tareas].[version_documento] (id_documento);
GO

CREATE INDEX [ix_tarea_documento_estado] ON [tareas].[tarea_documento] (id_estado_tarea);
GO


-- ----- Índices: ubicacion -----
CREATE INDEX [ix_lugar_base_comuna] ON [ubicacion].[lugar_base] (id_comuna) WHERE id_comuna IS NOT NULL;
GO

CREATE INDEX [ix_lugar_base_coordenadas] ON [ubicacion].[lugar_base] (latitud, longitud) WHERE latitud IS NOT NULL AND longitud IS NOT NULL;
GO

CREATE INDEX [ix_lugar_base_arcgis_ref] ON [ubicacion].[lugar_base] (arcgis_ref) WHERE arcgis_ref IS NOT NULL;
GO

CREATE INDEX [ix_lugar_id_lugar_base] ON [ubicacion].[lugar] (id_lugar_base);
GO

CREATE INDEX [ix_lugar_tipo_subdivision] ON [ubicacion].[lugar] (id_lugar_base, id_tipo_subdivision);
GO

CREATE INDEX [ix_lugar_piso] ON [ubicacion].[lugar] (id_lugar_base, piso) WHERE piso IS NOT NULL;
GO


-- ----- Índices: organizacion -----
CREATE UNIQUE INDEX [ux_func_ad_object] ON [organizacion].[funcionario] (ad_object_id) WHERE ad_object_id IS NOT NULL;
GO

CREATE UNIQUE INDEX [ux_func_sam] ON [organizacion].[funcionario] (ad_sam_account) WHERE ad_sam_account IS NOT NULL;
GO

CREATE UNIQUE INDEX [ux_func_placa] ON [organizacion].[funcionario] (numero_placa) WHERE numero_placa IS NOT NULL;
GO


-- ----- Índices: personas -----
CREATE UNIQUE INDEX [ux_ident_doc_activo] ON [personas].[identificacion] (id_tipo_documento, numero_documento, id_pais_emisor) WHERE fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_ident_principal_activo] ON [personas].[identificacion] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_telefono_principal_activo] ON [personas].[telefono] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_correo_principal_activo] ON [personas].[correo] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_persona_lugar_principal_activo] ON [personas].[persona_lugar] (id_persona, id_rol_lugar) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_foto_principal_activa] ON [personas].[fotografia] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO


-- ----- Índices: vehiculos -----
CREATE UNIQUE INDEX [ux_vehiculo_patente] ON [vehiculos].[vehiculo] (patente) WHERE patente IS NOT NULL AND fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_vehiculo_vin] ON [vehiculos].[vehiculo] (vin) WHERE vin IS NOT NULL AND fecha_eliminacion IS NULL;
GO

CREATE UNIQUE INDEX [ux_perveh_principal_activo] ON [vehiculos].[persona_vehiculo] (id_persona) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO


-- ----- Índices: casos -----
CREATE UNIQUE INDEX [ux_caso_ruc] ON [casos].[caso] (ruc) WHERE ruc IS NOT NULL;
GO

CREATE INDEX [ix_caso_nivel_grupo] ON [casos].[caso] (id_nivel_seguridad, id_grupo_operativo);
GO

CREATE INDEX [ix_historial_clasificacion_delito] ON [casos].[caso_historial_estado] (id_clasificacion_delito_anterior);
GO


-- ----- Índices: investigacion -----
CREATE INDEX [ix_clasificacion_delito_delito] ON [investigacion].[clasificacion_delito] (id_delito);
GO

CREATE INDEX [ix_clasificacion_delito_seccion] ON [investigacion].[clasificacion_delito] (id_seccion_catalogo);
GO

CREATE INDEX [ix_clasificacion_delito_familia] ON [investigacion].[clasificacion_delito] (id_familia_delito);
GO

CREATE INDEX [ix_delito_imputado_clasificacion] ON [investigacion].[delito_imputado] (id_clasificacion_delito);
GO

CREATE INDEX [ix_protocolo_delito_clasificacion] ON [investigacion].[protocolo_delito] (id_clasificacion_delito);
GO

CREATE INDEX [ix_hecho_forma_contacto] ON [investigacion].[hecho] (id_forma_contacto) WHERE id_forma_contacto IS NOT NULL;
GO

CREATE INDEX [ix_hecho_punto_acceso] ON [investigacion].[hecho] (id_punto_acceso) WHERE id_punto_acceso IS NOT NULL;
GO

CREATE INDEX [ix_hecho_transporte] ON [investigacion].[hecho] (id_transporte) WHERE id_transporte IS NOT NULL;
GO

CREATE INDEX [ix_hecho_fenomeno_hecho] ON [investigacion].[hecho_fenomeno] (id_hecho);
GO

CREATE INDEX [ix_hecho_fenomeno_fenomeno] ON [investigacion].[hecho_fenomeno] (id_fenomeno);
GO

CREATE INDEX [ix_delimp_movil] ON [investigacion].[delito_imputado] (id_movil) WHERE id_movil IS NOT NULL;
GO

CREATE UNIQUE INDEX [ux_hecho_lugar_principal_activo] ON [investigacion].[hecho_lugar] (id_hecho) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO


-- ----- Índices: denuncias -----
CREATE INDEX [ix_procedimiento_caso] ON [denuncias].[procedimiento_policial] (id_caso) WHERE id_caso IS NOT NULL;
GO

CREATE UNIQUE INDEX [ux_denperrol_principal_activo] ON [denuncias].[denuncia_persona_rol] (id_denuncia) WHERE es_principal = 1 AND fecha_eliminacion IS NULL;
GO

CREATE INDEX [ix_fenomeno_delictual_vigente] ON [denuncias].[fenomeno_delictual] (anio_vigencia, vigente);
GO

CREATE INDEX [ix_pauta_vif_denuncia] ON [denuncias].[pauta_vif] (id_denuncia) WHERE id_denuncia IS NOT NULL;
GO

CREATE INDEX [ix_pauta_vif_caso] ON [denuncias].[pauta_vif] (id_caso) WHERE id_caso IS NOT NULL;
GO

CREATE INDEX [ix_denuncia_estado] ON [denuncias].[denuncia] (estado_denuncia, fecha_denuncia);
GO

CREATE INDEX [ix_denuncia_vif] ON [denuncias].[denuncia] (indicador_vif) WHERE indicador_vif = 1;
GO

CREATE INDEX [ix_encargo_persona_persona] ON [denuncias].[encargo_persona] (id_persona, estado);
GO

CREATE INDEX [ix_proc_clasificacion_delito] ON [denuncias].[procedimiento_policial] (id_clasificacion_delito_principal);
GO


-- ----- Índices: diligencias -----
CREATE INDEX [ix_notif_caso_fecha] ON [diligencias].[notificacion_externa] (id_caso, fecha_evento);
GO

CREATE INDEX [ix_notif_tipo_fecha] ON [diligencias].[notificacion_externa] (id_tipo_notificacion_externa, fecha_evento);
GO

CREATE INDEX [ix_solicitud_pericial_caso] ON [diligencias].[solicitud_concurrencia_pericial] (id_caso, estado);
GO

CREATE UNIQUE INDEX [ux_informe_numero] ON [diligencias].[informe_policial] (numero_informe) WHERE numero_informe IS NOT NULL;
GO

CREATE INDEX [ix_actividad_investigativa_diligencia] ON [diligencias].[actividad_investigativa] (id_diligencia);
GO


-- ----- Índices: catalogo_bienes -----
CREATE UNIQUE INDEX [uq_version_catalogo_vigente] ON [catalogo_bienes].[version_catalogo] (es_vigente) WHERE es_vigente = 1;
GO

CREATE INDEX [ix_segmento_nombre] ON [catalogo_bienes].[segmento] (nombre) INCLUDE (codigo, id_version, activo);
GO

CREATE INDEX [ix_familia_segmento] ON [catalogo_bienes].[familia] (id_segmento, id_version) INCLUDE (codigo, nombre, activo);
GO

CREATE INDEX [ix_familia_nombre] ON [catalogo_bienes].[familia] (nombre) INCLUDE (codigo, id_version, activo);
GO

CREATE INDEX [ix_clase_familia] ON [catalogo_bienes].[clase] (id_familia, id_version) INCLUDE (codigo, nombre, activo);
GO

CREATE INDEX [ix_clase_nombre] ON [catalogo_bienes].[clase] (nombre) INCLUDE (codigo, id_version, activo);
GO

CREATE INDEX [ix_producto_clase] ON [catalogo_bienes].[producto] (id_clase, id_version) INCLUDE (codigo, nombre, activo);
GO

CREATE INDEX [ix_producto_nombre] ON [catalogo_bienes].[producto] (nombre) INCLUDE (codigo, id_version, activo);
GO

CREATE INDEX [ix_producto_codigo] ON [catalogo_bienes].[producto] (codigo, id_version) INCLUDE (nombre, activo, id_clase);
GO

CREATE INDEX [ix_codigo_reemplazado_anterior] ON [catalogo_bienes].[codigo_reemplazado] (codigo_anterior) INCLUDE (codigo_nuevo, id_version_cambio);
GO

CREATE INDEX [ix_codigo_reemplazado_nuevo] ON [catalogo_bienes].[codigo_reemplazado] (codigo_nuevo) INCLUDE (codigo_anterior, id_version_cambio);
GO

CREATE INDEX [ix_codigo_reemplazado_nivel] ON [catalogo_bienes].[codigo_reemplazado] (nivel) INCLUDE (codigo_anterior, codigo_nuevo, id_version_cambio);
GO


-- ----- Índices: evidencias -----
CREATE INDEX [ix_cat_catalogo_armas_familia] ON [evidencias].[cat_catalogo_armas] (familia, tipo_arma);
GO

CREATE UNIQUE INDEX [ux_especie_rue] ON [evidencias].[especie] (rue) WHERE rue IS NOT NULL;
GO


-- ----- Índices: migracion -----
CREATE INDEX [ix_denuncia_mig_persona] ON [migracion].[denuncia_administrativa_migratoria] (id_persona, fecha_registro DESC);
GO

CREATE INDEX [ix_denuncia_mig_estado] ON [migracion].[denuncia_administrativa_migratoria] (estado, fecha_registro);
GO

CREATE INDEX [ix_denuncia_mig_sermig] ON [migracion].[denuncia_administrativa_migratoria] (sermig_ref) WHERE sermig_ref IS NOT NULL;
GO


-- ----- Índices: cooperacion_int -----
CREATE INDEX [ix_solicitud_interpol_anio_estado] ON [cooperacion_int].[solicitud_interpol] (anio, id_estado_solicitud);
GO

CREATE INDEX [ix_solicitud_interpol_persona] ON [cooperacion_int].[solicitud_interpol] (id_persona);
GO


-- ----- Índices: analitica -----
CREATE INDEX [ix_reporte_analitico_anio] ON [analitica].[reporte_analitico] (anio, estado);
GO

CREATE INDEX [ix_vinculo_entidad_origen] ON [analitica].[vinculo_entidad] (tipo_entidad_origen, id_entidad_origen);
GO

CREATE INDEX [ix_vinculo_entidad_destino] ON [analitica].[vinculo_entidad] (tipo_entidad_destino, id_entidad_destino);
GO

CREATE INDEX [ix_reporte_tipo_anio] ON [analitica].[reporte_analitico] (id_tipo_reporte, anio, estado);
GO

CREATE INDEX [ix_foco_estado] ON [analitica].[foco_investigativo] (estado, fecha_creacion DESC);
GO


-- =============================================================================
-- PASO 5 — DESCRIPCIONES (Extended Properties)
-- =============================================================================

-- ----- Descripciones de esquemas -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Configuración del sistema: dominios genéricos y elementos de catálogo transversales.',
    @level0type = N'SCHEMA', @level0name = N'configuracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Geografía y Lugares. Entidades geográficas: países, regiones, provincias, comunas y lugares unificados (POLE).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Organización interna PDI: unidades, funcionarios y cargos. Fuente: Active Directory.',
    @level0type = N'SCHEMA', @level0name = N'organizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona natural: identificación, morfología, contacto, antecedentes y vínculos. Patrón POLE (Person).',
    @level0type = N'SCHEMA', @level0name = N'personas';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Vehículos: catálogos de marca, modelo, color y relaciones persona-vehículo. Patrón POLE (Object).',
    @level0type = N'SCHEMA', @level0name = N'vehiculos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivos y documentos digitales centralizados. Todo archivo adjunto del sistema referencia este esquema.',
    @level0type = N'SCHEMA', @level0name = N'archivos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Casos — Case Manager: carpetas investigativas, casos, historial de estados, asignaciones y agrupación de causas. Subdominio de PO01.',
    @level0type = N'SCHEMA', @level0name = N'casos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Investigación Criminal — Hechos delictuales, delitos imputados, grados de participación y ejecución. Subdominio de PO01.',
    @level0type = N'SCHEMA', @level0name = N'investigacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncias — Punto de entrada al proceso investigativo: denuncias, relatos, hechos, fenómenos delictuales, procedimientos y VIF. Subdominio de PO01.',
    @level0type = N'SCHEMA', @level0name = N'denuncias';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencias y Actuaciones: instrucciones fiscales, detenidos, peritajes, informes policiales y notificaciones externas.',
    @level0type = N'SCHEMA', @level0name = N'diligencias';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo UNSPSC para clasificación de bienes incautados. Modelo jerárquico de 4 niveles: segmento (2 chars) → familia (4 chars) → clase (6 chars) → producto (8 chars). Cada versión del catálogo se carga completa para preservar trazabilidad histórica.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Evidencia física: incautaciones, especies, extensiones por tipo (arma/droga/electrónico/vehículo/otro) y cadena de custodia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Control Migratorio (PO02): denuncias administrativas por infracción a la Ley de Extranjería. Envío obligatorio a SERMIG.',
    @level0type = N'SCHEMA', @level0name = N'migracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cooperación Internacional — Cardex INTERPOL y gestión de requerimientos internacionales. Subdominio de PO03.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Análisis e Inteligencia Policial (PO04/OFAN): reportes analíticos, focos investigativos y vínculos entre entidades.',
    @level0type = N'SCHEMA', @level0name = N'analitica';
GO


-- ----- Descripciones: configuracion -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo genérico de dominios del sistema. Agrupa valores reutilizables: SEXO, COLOR_PELO, ESTADO_CIVIL, etc.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_dominio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del dominio. Clave primaria autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_dominio',
    @level2type = N'COLUMN', @level2name = N'id_dominio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código único del dominio en mayúsculas. Ejemplos: SEXO, COLOR_PELO.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_dominio',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible del dominio. Ejemplos: Sexo, Color de pelo.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_dominio',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del propósito del dominio. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_dominio',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valores de cada dominio. Cada fila es un elemento válido: Masculino/Femenino para SEXO.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del elemento. Clave primaria autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'id_elemento_dominio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Dominio al que pertenece el elemento. FK a configuracion.cat_dominio.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'id_dominio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código único dentro del dominio. Ejemplos: M, F para SEXO.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Texto legible en formularios. Ejemplos: Masculino, Femenino.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'etiqueta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción extendida para tooltips. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Orden de presentación en selectores. Valor por defecto 0.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'orden';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = disponible. 0 = inactivo, se conserva para históricos.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valor entero opcional. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'valor_int';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valor texto Unicode opcional. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'configuracion',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_dominio',
    @level2type = N'COLUMN', @level2name = N'valor_nvarchar';
GO


-- ----- Descripciones: tareas -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Las tareas que requieren acción se dejan en la bandeja respectiva',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'bandeja';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Dependiendo del tipo de tarea se ofrecen acciones y asociaciones',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_tarea';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cabecera de una tarea',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados de tarea',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_estado_tarea';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Histórico de estados de una tarea',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'estado_tarea';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipos documentales: denuncia, OI, PD, IP, etc',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tipo_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena todas las versiones hasta visado definitivo',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'version_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación entre estado de tarea y documentos',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivos adjuntos asociados a estados de tarea',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_archivo_adjunto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación 1 a 1 entre tarea y denuncia',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación 1 a 1 entre tarea y diligencia',
    @level0type = N'SCHEMA', @level0name = N'tareas',
    @level1type = N'TABLE',  @level1name = N'tarea_diligencia';
GO


-- ----- Descripciones: ubicacion -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de países. Fuente: ISO 3166-1. Código ISO 2 y 3 letras.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'pais';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del país. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'pais',
    @level2type = N'COLUMN', @level2name = N'id_pais';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial del país en español. Ej: Chile, Argentina, Estados Unidos.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'pais',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de regiones de Chile según división político-administrativa vigente.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'region';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la región. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'region',
    @level2type = N'COLUMN', @level2name = N'id_region';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País al que pertenece la región. FK a ubicacion.pais. En el sistema corresponde siempre a Chile, pero el modelo permite extensión futura.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'region',
    @level2type = N'COLUMN', @level2name = N'id_pais';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial de la región. Ej: Región Metropolitana de Santiago, Región de Valparaíso.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'region',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de provincias de Chile. Dependiente de región.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'provincia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la provincia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'provincia',
    @level2type = N'COLUMN', @level2name = N'id_provincia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Región a la que pertenece la provincia. FK a ubicacion.region.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'provincia',
    @level2type = N'COLUMN', @level2name = N'id_region';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial de la provincia. Ej: Santiago, Cordillera, Maipo.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'provincia',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de comunas de Chile. Dependiente de provincia. Código INE.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'comuna';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la comuna. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'comuna',
    @level2type = N'COLUMN', @level2name = N'id_comuna';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Provincia a la que pertenece la comuna. FK a ubicacion.provincia.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'comuna',
    @level2type = N'COLUMN', @level2name = N'id_provincia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial de la comuna. Ej: Santiago, Las Condes, Pudahuel.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'comuna',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la comuna es costera.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'comuna',
    @level2type = N'COLUMN', @level2name = N'costera';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de vía (calle, avenida, pasaje, etc.).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_calle';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de calle. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_calle',
    @level2type = N'COLUMN', @level2name = N'id_tipo_calle';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de vía. Ej: Calle, Avenida, Pasaje, Autopista, Camino, Población.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_calle',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de residencia (casa, departamento, etc.).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_residencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de residencia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_residencia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_residencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de residencia. Ej: Casa, Departamento, Parcela, Local comercial, Hostal, Pensión.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_residencia',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de lugar para eventos (sitio del suceso, cuartel, etc.).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código interno abreviado del tipo de lugar. Ej: SS (sitio del suceso), CRT (cuartel), AER (aeropuerto). Usado para filtros y reportería estadística.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_lugar',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del tipo de lugar. Ej: Sitio del suceso, Cuartel PDI, Aeropuerto, Terminal de buses, Domicilio particular, Espacio público, Vía internet.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_lugar',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de roles de un lugar respecto a una entidad (domicilio, lugar del hecho, etc.).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del rol de lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_rol_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código interno abreviado del rol. Ej: DOM (domicilio), LH (lugar del hecho), LT (lugar de trabajo), LDET (lugar de detención), LINC (lugar de incautación).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_rol_lugar',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del rol. Ej: Domicilio particular, Lugar del hecho, Lugar de trabajo, Lugar de detención, Lugar de incautación, Sitio del suceso principal.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_rol_lugar',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Subdivisión física de un lugar_base (predio/edificio/terreno). Cada fila representa una unidad específica dentro del predio (habitación, celda, oficina, local, bodega, piso completo, etc.) o la subdivisión comodín GENERAL cuando no se conoce precisión. La aplicación garantiza que cada lugar_base tenga al menos una fila en esta tabla. Todas las tablas hijas de otros esquemas referencian lugar.id_lugar (no lugar_base directamente); la dirección y coordenadas se obtienen mediante JOIN: lugar → lugar_base.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la subdivisión de lugar. Clave primaria generada por el sistema. Se preserva como PK desde v22 para no romper las FKs de tablas hijas en otros esquemas.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Predio al que pertenece esta subdivisión. FK a ubicacion.lugar_base. Múltiples filas de lugar pueden compartir el mismo id_lugar_base (habitaciones distintas del mismo hotel, oficinas distintas del mismo edificio).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar_base';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de subdivisión. FK a ubicacion.cat_tipo_subdivision. Valor por defecto en la fila comodín es GENERAL (predio completo sin precisión específica).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_subdivision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Piso de la subdivisión dentro del predio. Formato libre para soportar nomenclaturas regionales: números (3, 15), subterráneos (-1, -2, SS), planta baja (PB), mezzanine (3M). NULL si no aplica (casa de un nivel, sitio eriazo, subdivisión sin piso relevante). Ortogonal al tipo de subdivisión: una HABITACION, OFICINA o CELDA puede estar en cualquier piso.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'piso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número o identificador de la subdivisión específica. Ej: ''302'' (habitación), ''Módulo B - Celda 45'' (celda), ''Local B-7'' (local comercial), ''E-145'' (estacionamiento). NULL cuando se trata del predio completo (id_tipo_subdivision = GENERAL) o cuando se quiere representar un piso completo sin precisión de habitación.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'numero_subdivision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción libre de la subdivisión para agregar contexto (ej: ''habitación doble con vista a la calle'', ''celda compartida de 4 plazas'', ''local en galería subterránea''). Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha UTC de baja lógica de la subdivisión (soft-delete). NULL si está activa.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Predio, edificio o terreno como entidad geográfica normalizada. Contiene datos de dirección, coordenadas WGS84 e integración con ArcGIS. Cada lugar_base puede tener una o más subdivisiones en la tabla ubicacion.lugar (al menos la fila GENERAL por defecto, y opcionalmente habitaciones/celdas/oficinas específicas). Reemplaza la estructura anterior de la tabla lugar (v22 y anteriores).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la vía pública. Ej: Teatinos, Avenida Providencia. Campo opcional para lugares sin dirección formal.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'calle';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Numeración de la vía pública. Acepta formatos alfanuméricos para casos como S/N, 1234-A o intersecciones. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'numero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de block o torre en conjuntos habitacionales o edificios con múltiples accesos. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'block';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número o identificador de unidad interior: departamento, oficina, local. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'departamento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre propio del lugar cuando corresponde a un sitio identificable sin dirección exacta. Ej: Aeropuerto Arturo Merino Benítez, Terminal Alameda, Fundo El Pino. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'nombre_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Comuna donde se ubica el lugar. FK a ubicacion.comuna. Campo opcional para lugares sin comuna definible.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'id_comuna';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Coordenada geográfica de latitud en formato decimal WGS84 con precisión de 7 decimales. Ej: -33.4372700. Requerida para integración con el visor territorial GIS.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'latitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Coordenada geográfica de longitud en formato decimal WGS84 con precisión de 7 decimales. Ej: -70.6506300. Requerida para integración con el visor territorial GIS.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'longitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción libre de referencia para ubicar el lugar cuando la dirección formal es insuficiente. Ej: Frente al supermercado, portón azul; Sector norte del parque.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'referencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que registró el lugar en el sistema. FK a organizacion.funcionario. Permite trazabilidad del ingreso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se creó el registro del lugar. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación del registro. Se actualiza al corregir coordenadas o datos de dirección.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del predio. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'id_lugar_base';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro en ArcGIS (si fue geocodificado automáticamente). Habilita integración bidireccional con el visor territorial: desde SIP se puede volver a ArcGIS para recuperar geometría completa o actualizar el punto. NULL si el predio no fue geocodificado mediante ArcGIS.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'arcgis_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Origen de las coordenadas del predio. Valores: ARCGIS (normalizado por el visor territorial, alta confiabilidad ~1 m) o MANUAL (ingresado manualmente por el usuario, aproximación). Crítico para OFAN al analizar puntos espaciales — permite distinguir coordenadas confiables de ruido. NULL si no aplica (por ejemplo, lugar sin coordenadas).',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'lugar_base',
    @level2type = N'COLUMN', @level2name = N'origen_geocodificacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de subdivisión dentro de un predio (lugar_base). Clasifica la naturaleza física de cada fila de ubicacion.lugar: habitación, celda, oficina, local comercial, bodega, etc. El valor GENERAL representa el predio completo sin subdivisión específica y es la fila comodín que la aplicación crea por defecto al registrar un lugar_base. Datos semilla pendientes de validación con PDI.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de subdivisión. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision',
    @level2type = N'COLUMN', @level2name = N'id_tipo_subdivision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código corto del tipo de subdivisión. Único. Ej: GENERAL, HABITACION, DEPARTAMENTO, OFICINA, LOCAL, BODEGA, CELDA, SALA, SUITE, OTRO.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre legible del tipo de subdivisión. Ej: Habitación, Celda, Oficina, Local comercial.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción amplia del tipo de subdivisión y casos de uso típicos en procedimientos PDI.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = tipo disponible en UI para clasificación nueva. 0 = tipo deprecado, solo se conserva para integridad histórica de registros existentes.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha UTC en que se creó el tipo de subdivisión en el catálogo.',
    @level0type = N'SCHEMA', @level0name = N'ubicacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_subdivision',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO


-- ----- Descripciones: organizacion -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de unidades policiales (departamento, brigada, jefatura, etc.).',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de unidad. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_unidad',
    @level2type = N'COLUMN', @level2name = N'id_tipo_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del tipo. Ej: BRI, JN, PREF, DEPTO.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_unidad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre completo del tipo de unidad.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_unidad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de relación entre unidades.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de relación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relacion_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del tipo de relación. Ej: JER, FUNC, SUP.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de relación entre unidades.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de cargos y funciones de funcionarios PDI.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_cargo_funcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del cargo o función. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_cargo_funcion',
    @level2type = N'COLUMN', @level2name = N'id_cargo_funcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del cargo. Ej: INS, COM, JB, ANA.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_cargo_funcion',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial del cargo o función.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_cargo_funcion',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidades organizacionales de la PDI. Fuente: Active Directory. v2.0: es_lacrim.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la unidad en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código interno de la unidad según nomenclatura institucional PDI. Ej: BRICRI, BRIGADA-HC, OFAN.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial de la unidad. Ej: Brigada de Investigación Criminal, Jefatura Nacional de Homicidios.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Sigla o acrónimo de uso habitual de la unidad. Ej: BRICRI, OFAN, LACRIM. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'acronimo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de unidad según su naturaleza organizacional. FK a organizacion.cat_tipo_unidad. Ej: brigada, jefatura, departamento, laboratorio.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'id_tipo_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especialidad investigativa de la unidad cuando corresponde a una brigada especializada. Ej: Homicidios, Antinarcóticos, Cibercrimen, Delitos Sexuales. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'especialidad_delictual';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última actualización, incluyendo sincronizaciones desde Active Directory.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Ámbito operativo. REGIONAL = analista OFAN regional · NACIONAL = analista OFAN nacional. S12/RN14.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'unidad',
    @level2type = N'COLUMN', @level2name = N'ambito_geografico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relaciones jerárquicas y funcionales entre unidades.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la relación entre unidades. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'id_relacion_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad dependiente o subordinada en la relación. FK a organizacion.unidad.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'id_unidad_hija';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad superior o de la que depende la unidad hija. FK a organizacion.unidad.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'id_unidad_padre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de vínculo entre las unidades. FK a organizacion.cat_tipo_relacion_unidad.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de inicio de vigencia de la relación. Refleja cambios en la estructura organizacional PDI.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'vigente_desde';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de término de vigencia de la relación. Nulo si la relación está actualmente vigente.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'relacion_unidad',
    @level2type = N'COLUMN', @level2name = N'vigente_hasta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionarios PDI sincronizados con Active Directory. v2.0.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del funcionario. No es IDENTITY — hereda el valor de personas.persona.id_persona. La aplicación crea primero la persona y luego inserta el funcionario con el mismo id.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del objeto en Active Directory (ObjectGUID). Formato UUID de 36 caracteres. Clave de sincronización primaria entre el sistema y el directorio institucional. Campo opcional durante la carga inicial.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'ad_object_id';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de cuenta SAM (sAMAccountName) del funcionario en Active Directory. Corresponde al nombre de usuario de red institucional. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'ad_sam_account';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Correo electrónico institucional del funcionario sincronizado desde Active Directory. Puede diferir del correo personal registrado en personas.correo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'ad_email';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad PDI a la que pertenece actualmente el funcionario. FK a organizacion.unidad. Se actualiza en cada sincronización con Active Directory. Campo opcional durante estados de transición.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cargo o función que desempeña el funcionario dentro de la PDI. FK a organizacion.cat_cargo_funcion. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'id_cargo_funcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de placa institucional del funcionario PDI. Identificador físico único que porta el funcionario en su credencial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'numero_placa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última sincronización exitosa desde Active Directory. Permite detectar funcionarios con datos desactualizados.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'fecha_ultima_sync';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual de la sincronización con Active Directory. Valores: SINCRONIZADO (datos actualizados), PENDIENTE (sincronización en cola), ERROR (falla en última sincronización), DESVINCULADO (cuenta eliminada o desactivada en AD).',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'sync_estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación, ya sea por sincronización AD o edición manual.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del funcionario (soft-delete). Se activa cuando la cuenta es desvinculada de Active Directory.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'funcionario',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de organismos externos a PDI que pueden ser origen o destino de trazabilidad documental en SIP. Complementa campos folio_externo y otros identificadores que apuntan a entidades fuera de PDI. Ejemplos: Carabineros de Chile, Ministerio Público, Gendarmería, Tribunales de Justicia, SML, DGAC. Se ubica en el esquema organizacion por simetría con organizacion.unidad (entidades internas PDI). Pendiente consolidación futura: podría complementarse con los textos libres actualmente presentes en instruccion_fiscal.emitida_por, notificacion_externa.organismo_emisor, especie.custodio_institucion y reporte_analitico.organismo.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del organismo externo. Clave primaria autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'id_organismo_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código corto del organismo. Único. Ej: CARAB, MP, GENCHI, TRIB, SML, DGAC, PDI_EXT. Usado para integración con sistemas externos.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial del organismo. Ej: Carabineros de Chile, Ministerio Público de Chile, Servicio Médico Legal.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación funcional del organismo. Valores: POLICIA | FISCALIA | TRIBUNAL | LABORATORIO | AGENCIA_GOB | INT_INTERNACIONAL | OTRO. Permite filtrar por tipo según contexto de uso (ej: tipo=POLICIA para denuncias transferidas).',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'tipo_organismo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Alcance territorial del organismo. Valores: NACIONAL | REGIONAL | INTERNACIONAL. Default NACIONAL.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'nivel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = organismo vigente, disponible para selección en SIP. 0 = organismo deshabilitado (por disolución, fusión o cambio administrativo). CHECK IN (0,1).',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación del registro.',
    @level0type = N'SCHEMA', @level0name = N'organizacion',
    @level1type = N'TABLE',  @level1name = N'cat_organismo_externo',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO


-- ----- Descripciones: personas -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de sexo biológico registral: MASCULINO, FEMENINO, INDETERMINADO.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_sexo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del sexo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_sexo',
    @level2type = N'COLUMN', @level2name = N'id_sexo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del sexo registral. Valores fijos: MASCULINO, FEMENINO, INDETERMINADO.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_sexo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de identidad de género. Independiente del sexo registral.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_genero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del género. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_genero',
    @level2type = N'COLUMN', @level2name = N'id_genero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la identidad de género.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_genero',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de nacionalidades. Fuente: ISO 3166-1.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nacionalidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial de la nacionalidad en español.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nacionalidad',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de documento de identificación (RUN, pasaporte, DNI extranjero, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de documento. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_documento',
    @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de documento de identificación.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_documento',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de teléfono (celular, fijo, trabajo, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de teléfono. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_telefono',
    @level2type = N'COLUMN', @level2name = N'id_tipo_telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de teléfono. Ej: celular, fijo domicilio, fijo trabajo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_telefono',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de plataformas de redes sociales.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_red_social';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de red social. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_red_social',
    @level2type = N'COLUMN', @level2name = N'id_tipo_red_social';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la plataforma. Ej: Facebook, Instagram, TikTok, Telegram, WhatsApp.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_red_social',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de relación interpersonal (cónyuge, hermano, amigo, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de relación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de vínculo interpersonal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la relación aplica automáticamente en ambos sentidos al registrarla. Valor 1 = bidireccional. Ej: cónyuge es bidireccional, padre de no lo es.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion',
    @level2type = N'COLUMN', @level2name = N'es_bidireccional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de niveles de escolaridad.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_escolaridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del nivel de escolaridad. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_escolaridad',
    @level2type = N'COLUMN', @level2name = N'id_nivel_escolaridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del nivel educacional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_escolaridad',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valor numérico para ordenar los niveles de menor a mayor en la interfaz del sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_escolaridad',
    @level2type = N'COLUMN', @level2name = N'orden';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de ocupaciones o actividades laborales.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ocupacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la ocupación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ocupacion',
    @level2type = N'COLUMN', @level2name = N'id_ocupacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la ocupación o actividad laboral.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ocupacion',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de actividad económica del SII asociado a la ocupación. Campo opcional, para interoperabilidad con registros tributarios.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ocupacion',
    @level2type = N'COLUMN', @level2name = N'codigo_sii';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados civiles.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_estado_civil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del estado civil. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_estado_civil',
    @level2type = N'COLUMN', @level2name = N'id_tipo_estado_civil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del estado civil. Ej: Soltero, Casado, Conviviente civil, Divorciado, Viudo, Separado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_estado_civil',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de anotación policial (prontuario, denuncia previa, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_anotacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de anotación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_anotacion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_anotacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de anotación policial.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_anotacion',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de fotografía de persona (frontal, perfil, cuerpo entero, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_fotografia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de fotografía. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_fotografia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_fotografia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de fotografía. Ej: frontal, perfil izquierdo, perfil derecho, cuerpo entero.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_fotografia',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de complexiones físicas (delgado, normal, robusto, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_complexion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la complexión. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_complexion',
    @level2type = N'COLUMN', @level2name = N'id_complexion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la complexión física. Ej: delgado, normal, robusto, obeso.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_complexion',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de colores de piel para descripción física.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_piel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del color de piel. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_piel',
    @level2type = N'COLUMN', @level2name = N'id_color_piel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la tonalidad de piel.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_piel',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de colores de ojos.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_ojos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del color de ojos. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_ojos',
    @level2type = N'COLUMN', @level2name = N'id_color_ojos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del color de ojos.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_ojos',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de colores de cabello.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_cabello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del color de cabello. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_cabello',
    @level2type = N'COLUMN', @level2name = N'id_color_cabello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del color de cabello.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_color_cabello',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de cabello (liso, ondulado, rizado, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_cabello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de cabello. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_cabello',
    @level2type = N'COLUMN', @level2name = N'id_tipo_cabello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo o textura de cabello. Ej: liso, ondulado, rizado, afro, calvo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_cabello',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de formas de rostro para descripción física.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_forma_rostro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la forma de rostro. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_forma_rostro',
    @level2type = N'COLUMN', @level2name = N'id_forma_rostro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la forma de rostro. Ej: ovalado, redondo, cuadrado, triangular, alargado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_forma_rostro',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de rasgos distintivos (cicatriz, tatuaje, lunar, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rasgo_distintivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de rasgo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_rasgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de rasgo distintivo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de ubicaciones corporales para rasgos distintivos.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ubicacion_corporal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la ubicación corporal. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ubicacion_corporal',
    @level2type = N'COLUMN', @level2name = N'id_ubicacion_corporal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la zona corporal. Ej: brazo derecho, cuello, espalda, rostro.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_ubicacion_corporal',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de datos biométricos (huella dactilar, iris, etc.).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_biometrico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo biométrico. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_biometrico',
    @level2type = N'COLUMN', @level2name = N'id_tipo_biometrico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de dato biométrico.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_biometrico',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad central POLE (Person). Ficha única de persona. Incluye sexo, género, nacionalidad y flag persona NN. Soft-delete.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la persona en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de nacimiento de la persona. Opcional — puede ser desconocida en personas NN o extranjeras sin documento.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'fecha_nacimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de defunción de la persona. Se registra cuando existe constancia oficial del fallecimiento. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'fecha_defuncion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Sexo biológico registral de la persona. FK a personas.cat_sexo. Valores: MASCULINO, FEMENINO, INDETERMINADO.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'id_sexo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identidad de género de la persona, independiente del sexo registral. FK a personas.cat_genero.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'id_genero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País de nacionalidad de la persona. FK a ubicacion.pais.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'id_pais_nacionalidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Comuna de nacimiento de la persona dentro del territorio nacional. FK a ubicacion.comuna. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'id_comuna_nacimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la persona ha sido formalmente identificada. Valor 0 = persona NN (no identificada), registrada con datos parciales o descripción física. Valor 1 = persona identificada con documento válido.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'es_identificable';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el domicilio principal de la persona se encuentra fuera del territorio nacional. Valor 1 = domicilio en el extranjero. Relevante para procesos de extradición y cooperación internacional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'domicilio_extranjero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación de los datos de la persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete). Un registro con valor en este campo se considera inactivo pero se preserva para trazabilidad histórica.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombres de la persona. Una persona puede tener múltiples nombres históricos.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de nombre. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'id_nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que corresponde este nombre. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Primer nombre de la persona. Campo obligatorio.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'nombre_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Segundo nombre de la persona. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'nombre_secundario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombres adicionales en caso de tener más de dos. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'nombre_extra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Apellido paterno de la persona. Campo opcional — puede ser desconocido en personas NN o extranjeras con un solo apellido.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'apellido_paterno';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Apellido materno de la persona. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'apellido_materno';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este nombre es un nombre supuesto o bajo el que opera la persona, distinto al nombre legal. Valor 1 = nombre supuesto.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'es_nombre_supuesto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del nombre. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del nombre (soft-delete). Permite mantener historial de cambios.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'nombre',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Apodos o alias utilizados en contexto policial.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'alias';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del alias. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'alias',
    @level2type = N'COLUMN', @level2name = N'id_alias';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que corresponde el alias. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'alias',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Apodo, sobrenombre o alias registrado. Ej: El Chico, Pantera.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'alias',
    @level2type = N'COLUMN', @level2name = N'alias';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del alias. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'alias',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del alias (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'alias',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Documentos de identificación de la persona. Soporte multi-documento y multi-país con vigencia.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del documento de identificación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'id_identificacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que pertenece el documento. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de documento de identificación. FK a personas.cat_tipo_documento. Ej: RUN, pasaporte, DNI extranjero.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número del documento de identificación sin dígito verificador. Ej: 12345678.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'numero_documento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Dígito verificador del documento. Aplica principalmente al RUN chileno. Ej: K, 5. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'digito_verificador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País que emitió el documento. FK a ubicacion.pais. Obligatorio para documentos extranjeros. Campo opcional para RUN chileno.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'id_pais_emisor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de emisión del documento. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'fecha_emision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de vencimiento del documento. Relevante para pasaportes y documentos temporales. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el documento de identificación principal de la persona. Solo puede existir un documento principal activo por persona. Valor 1 = documento principal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del documento. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del documento (soft-delete). Permite mantener historial de documentos anteriores.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = identificación temporal para migrante sin documento oficial válido. S7/RN08.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'identificacion',
    @level2type = N'COLUMN', @level2name = N'es_temporal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Teléfonos de contacto. Marca teléfono principal con índice único filtrado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro telefónico. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'id_telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que pertenece el teléfono. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de teléfono. FK a personas.cat_tipo_telefono. Ej: celular, fijo, trabajo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'id_tipo_telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de área o código de país para teléfonos internacionales. Ej: +56, 2. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'codigo_area';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número telefónico sin código de área.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'numero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el teléfono principal de contacto. Solo puede haber un teléfono principal activo por persona. Valor 1 = teléfono principal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del teléfono. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'telefono',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Correos electrónicos. Marca correo principal con índice único filtrado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de correo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo',
    @level2type = N'COLUMN', @level2name = N'id_correo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que pertenece el correo. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Dirección de correo electrónico.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo',
    @level2type = N'COLUMN', @level2name = N'correo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el correo principal de la persona. Solo puede haber un correo principal activo por persona. Valor 1 = correo principal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del correo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'correo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Perfiles en redes sociales de la persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del perfil. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'id_red_social';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona propietaria del perfil. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Plataforma de red social. FK a personas.cat_tipo_red_social. Ej: Facebook, Instagram, TikTok, Telegram.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'id_tipo_red_social';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de usuario o nick en la plataforma.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'usuario_nick';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'URL del perfil en la plataforma, si está disponible. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'link_url';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del perfil. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'red_social',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Otros medios de contacto no estructurados.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de contacto. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'id_contacto_otro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona asociada al medio de contacto. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción libre del tipo de medio de contacto. Ej: Dirección IP, Cuenta bancaria, Wallet Bitcoin, Número WhatsApp.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'tipo_contacto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valor del medio de contacto. Ej: 192.168.1.1, 0-00123456-0.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'valor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Contexto o detalle adicional del medio de contacto. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el medio de contacto principal del tipo registrado. Valor 1 = principal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del contacto. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'contacto_otro',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Historial de empleos y ocupaciones.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de empleo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'id_empleo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona empleada. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Ocupación o actividad laboral según catálogo. FK a personas.cat_ocupacion. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'id_ocupacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción libre del cargo o función específica. Ej: Vendedor ambulante, Contador general. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'descripcion_cargo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre o razón social del empleador. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'empleador_nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'RUT del empleador para personas jurídicas o naturales con actividad comercial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'empleador_rut';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Dirección del lugar de trabajo. FK a ubicacion.lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'id_lugar_trabajo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este empleo está vigente al momento del registro. Valor 1 = empleo actual. Valor por defecto: 1.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'es_actual';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de inicio del empleo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'fecha_inicio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de término del empleo. Nulo si el empleo está vigente.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'fecha_fin';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del empleo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'empleo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación POLE persona-lugar con rol (domicilio, trabajo, frecuentado).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo persona-lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'id_persona_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona vinculada al lugar. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar geográfico vinculado. FK a ubicacion.lugar.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de lugar según su naturaleza física. FK a ubicacion.cat_tipo_lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol que cumple el lugar respecto a la persona. FK a ubicacion.cat_rol_lugar. Ej: domicilio particular, domicilio laboral, lugar frecuentado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el lugar principal para el rol indicado. Solo puede haber un lugar principal activo por persona y rol. Valor 1 = lugar principal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha desde la que la persona tiene vínculo con este lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'vigente_desde';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha hasta la que la persona tuvo vínculo con este lugar. Nulo si el vínculo está vigente.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'vigente_hasta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información complementaria sobre el vínculo persona-lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del vínculo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'persona_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relaciones interpersonales entre personas.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la relación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'id_relacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona desde la que se establece la relación. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'id_persona_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona hacia la que se establece la relación. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'id_persona_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de vínculo interpersonal. FK a personas.cat_tipo_relacion. Ej: cónyuge, hermano, socio, cómplice conocido.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Observaciones adicionales sobre el vínculo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'nota';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro de la relación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'relacion',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Historial de escolaridad de la persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de escolaridad. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'id_escolaridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que corresponde el registro. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel de escolaridad alcanzado. FK a personas.cat_nivel_escolaridad.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'id_nivel_escolaridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del establecimiento educacional. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'establecimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Año al que corresponde el nivel de escolaridad registrado. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'year_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'escolaridad',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado civil actual e historial de la persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'estado_civil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de estado civil. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'estado_civil',
    @level2type = N'COLUMN', @level2name = N'id_estado_civil_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que corresponde. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'estado_civil',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado civil de la persona. FK a personas.cat_tipo_estado_civil. Ej: Soltero, Casado, Divorciado, Viudo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'estado_civil',
    @level2type = N'COLUMN', @level2name = N'id_tipo_estado_civil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del estado civil. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'estado_civil',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro. Permite mantener historial de cambios de estado civil.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'estado_civil',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fotografías de la persona. Marca foto principal con índice único filtrado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de fotografía. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'id_fotografia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona fotografiada. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivo de imagen almacenado en el sistema centralizado. FK a archivos.archivo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de fotografía. FK a personas.cat_tipo_fotografia. Ej: frontal, perfil izquierdo, perfil derecho, cuerpo entero. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_fotografia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si esta es la fotografía principal de la persona, la que se muestra por defecto en la ficha. Solo puede existir una foto principal activa por persona. Valor 1 = foto principal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro de la fotografía. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'fotografia',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Anotaciones policiales sobre la persona (prontuario, antecedentes).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la anotación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'id_anotacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona sobre la que se registra la anotación. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que registra la anotación. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de anotación policial. FK a personas.cat_tipo_anotacion. Ej: prontuario, denuncia previa, alerta de peligrosidad.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_anotacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Texto libre con el contenido de la anotación. Máximo 4000 caracteres.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'contenido';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro de la anotación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica de la anotación (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'anotacion',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción física completa (complexión, piel, ojos, cabello).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de descripción física. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_descripcion_fisica';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona descrita. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estatura de la persona en centímetros. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'estatura_cm';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Peso de la persona en kilogramos con un decimal. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'peso_kg';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Complexión física de la persona. FK a personas.cat_complexion. Ej: delgado, normal, robusto.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_complexion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Color de piel de la persona. FK a personas.cat_color_piel.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_color_piel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Color de ojos de la persona. FK a personas.cat_color_ojos.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_color_ojos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Color de cabello de la persona. FK a personas.cat_color_cabello.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_color_cabello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo o textura de cabello. FK a personas.cat_tipo_cabello. Ej: liso, ondulado, rizado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_tipo_cabello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Forma del rostro de la persona. FK a personas.cat_forma_rostro. Ej: ovalado, redondo, cuadrado.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'id_forma_rostro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Observaciones adicionales de descripción física no cubiertas por los campos estructurados.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'descripcion_fisica',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rasgos físicos distintivos con ubicación corporal.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del rasgo distintivo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'id_rasgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona que presenta el rasgo. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de rasgo distintivo. FK a personas.cat_tipo_rasgo_distintivo. Ej: cicatriz, tatuaje, lunar, marca de nacimiento.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_rasgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Zona del cuerpo donde se ubica el rasgo. FK a personas.cat_ubicacion_corporal. Ej: brazo derecho, cuello, espalda.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'id_ubicacion_corporal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción detallada del rasgo. Ej: Tatuaje de águila en antebrazo izquierdo, aproximadamente 10 cm.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fotografía que documenta el rasgo. FK a personas.fotografia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'id_fotografia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del rasgo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'rasgo_distintivo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Datos biométricos. Referencia a sistema ABIS externo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la referencia biométrica. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'id_referencia_biometrica';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona a la que corresponde la referencia biométrica. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de dato biométrico referenciado. FK a personas.cat_tipo_biometrico. Ej: huella dactilar, iris, reconocimiento facial.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'id_tipo_biometrico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro biométrico en el sistema externo ABIS. Clave de búsqueda para cotejo.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'referencia_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del sistema externo que contiene el dato biométrico. Ej: ABIS-PDI, SIVIGE, Registro Civil.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'sistema_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que fue capturado el dato biométrico. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'fecha_captura';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro de la referencia. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'personas',
    @level1type = N'TABLE',  @level1name = N'referencia_biometrica',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO


-- ----- Descripciones: vehiculos -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de marcas de vehículos.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_marca';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la marca. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_marca',
    @level2type = N'COLUMN', @level2name = N'id_marca';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial de la marca fabricante. Ej: Toyota, Chevrolet, Honda, Mercedes-Benz.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_marca',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de modelos de vehículos por marca.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del modelo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_modelo',
    @level2type = N'COLUMN', @level2name = N'id_modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca a la que pertenece el modelo. FK a vehiculos.cat_marca.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_modelo',
    @level2type = N'COLUMN', @level2name = N'id_marca';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del modelo. Ej: Corolla, Spark, Civic.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_modelo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de versiones/variantes de modelos.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la versión. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_version',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Modelo al que pertenece la versión. FK a vehiculos.cat_modelo.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_version',
    @level2type = N'COLUMN', @level2name = N'id_modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la versión o variante. Ej: 1.6 GLi Manual, 2.0 TDI 4x4.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_version',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de vehículo (sedán, camioneta, moto, etc.).',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de vehículo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de vehículo. Ej: Sedán, Hatchback, Camioneta, SUV, Motocicleta, Bus, Camión, Furgón.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de colores de vehículos.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_color';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del color. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_color',
    @level2type = N'COLUMN', @level2name = N'id_color';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del color. Ej: Blanco, Negro, Rojo, Gris Plata.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_color',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de color hexadecimal para representación visual. Ej: #FFFFFF. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_color',
    @level2type = N'COLUMN', @level2name = N'codigo_hex';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de relación persona-vehículo (propietario, conductor, etc.).',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de relación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_persona',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relacion_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de vínculo persona-vehículo. Ej: Propietario, Conductor habitual, Arrendatario, Usuario ocasional, Conductor al momento del hecho.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relacion_persona',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad POLE de vehículo. Patente, VIN, colores, año y estado. Soft-delete.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vehículo en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Placa Patente Única (PPU) del vehículo. Identificador visible para control vehicular en vía pública. Acepta formatos antiguos (dos letras + cuatro dígitos) y nuevos (cuatro letras + dos dígitos). Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'patente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Vehicle Identification Number (VIN). Número de identificación vehicular internacional de 17 caracteres. Identificador global único establecido por el fabricante. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'vin';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número identificador del motor del vehículo. Requerido por el SUEV como especie en casos de robo o hurto de motor. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'numero_motor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número identificador del chasis del vehículo. Estructura principal requerida por el SUEV para generar un encargo vehicular por sustracción. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'numero_chasis';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo o categoría del vehículo. FK a vehiculos.cat_tipo. Ej: sedán, camioneta, motocicleta, bus, camión. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca del fabricante del vehículo. FK a vehiculos.cat_marca. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_marca';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Modelo del vehículo según la marca. FK a vehiculos.cat_modelo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión o variante específica del modelo. FK a vehiculos.cat_version. Ej: 1.6 GLi, 2.0 TDI. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Año de fabricación o año modelo del vehículo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'anio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Color principal del vehículo. FK a vehiculos.cat_color. Dato requerido por el SUEV al momento del encargo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_color';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional relevante del vehículo. Ej: Vehículo con patente clonada, Presenta daños en carrocería delantera. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación del registro.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete). Preserva el historial para trazabilidad investigativa.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nacionalidad patente. NACIONAL / EXTRANJERA. Define flujo de registro y validación PPU. S14/RN04.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'vehiculo',
    @level2type = N'COLUMN', @level2name = N'nacionalidad_patente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación persona-vehículo con tipo y vigencia.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la relación persona-vehículo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_persona_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona vinculada al vehículo. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Vehículo vinculado a la persona. FK a vehiculos.vehiculo.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de vínculo entre la persona y el vehículo. FK a vehiculos.cat_tipo_relacion_persona. Ej: propietario, conductor habitual, arrendatario.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relacion_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si esta es la relación principal de la persona con el vehículo para el tipo indicado. Valor 1 = relación principal.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se inició el vínculo entre la persona y el vehículo. Valor por defecto: fecha de registro.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_inicio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que terminó el vínculo. Nulo si la relación está vigente. Permite mantener historial de propietarios anteriores.',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_fin';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de registro del vínculo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'vehiculos',
    @level1type = N'TABLE',  @level1name = N'persona_vehiculo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO


-- ----- Descripciones: archivos -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de archivo admitidos. Controla extensiones, MIME types y límite de tamaño. v2.0: es_multimedia, tamanio_max_mb.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de archivo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del tipo. Ej: PDF, IMG, VIDEO, AUDIO, PLANILLA.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de archivo. Ej: Documento PDF, Imagen, Video, Audio, Planilla.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_archivo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de niveles de confidencialidad de archivos adjuntos.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_confidencialidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del nivel de confidencialidad. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_confidencialidad',
    @level2type = N'COLUMN', @level2name = N'id_nivel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del nivel. Ej: P, R, S.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_confidencialidad',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del nivel. Ej: Público, Reservado, Secreto.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_confidencialidad',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Repositorio centralizado de archivos. Todo archivo adjunto referencia esta tabla. Gestiona almacenamiento, MIME type y hash SHA-256.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del archivo en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre original del archivo tal como fue cargado por el funcionario o generado por el sistema. Ej: Informe_Pericial_NUE_12345.pdf.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'nombre_original';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre con el que el archivo queda almacenado en el repositorio físico. Generado por el sistema para evitar colisiones.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'nombre_almacenado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Ruta o referencia de ubicación del archivo en el sistema de almacenamiento. Puede corresponder a ruta de sistema de archivos, clave en almacenamiento de objetos u otro sistema de storage.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'ruta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo MIME del archivo según estándar IANA. Ej: application/pdf, image/jpeg, video/mp4. Utilizado para validación y renderizado correcto.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'mime_type';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Extensión del archivo sin punto. Ej: pdf, jpg, mp4. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'extension';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tamaño del archivo en bytes. Permite controlar límites de carga definidos en archivos.cat_tipo_archivo.tamanio_max_mb. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'tamano_bytes';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hash SHA-256 del contenido del archivo en hexadecimal. Garantiza la integridad del archivo y permite detectar alteraciones. Clave para la cadena de custodia digital de documentos e informes periciales. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'hash_sha256';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de archivo según catálogo institucional. FK a archivos.cat_tipo_archivo. Determina reglas de validación, límite de tamaño y si es contenido multimedia.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_tipo_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel de confidencialidad del archivo. FK a archivos.cat_nivel_confidencialidad. Controla el acceso según el modelo de seguridad P-R-S. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_nivel_confidencialidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que realizó la carga del archivo. FK a organizacion.funcionario. Requerido para trazabilidad de custodia documental.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_carga';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Mecanismo por el que ingresó el archivo al sistema. Valores: SCANNER (digitalización física), CAMARA (captura directa), UPLOAD_MANUAL (carga manual), SISTEMA_EXTERNO (generado o recibido desde sistema externo). Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia a la versión anterior del archivo cuando este es una actualización. FK a archivos.archivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'id_archivo_version_anterior';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de versión del archivo. Inicia en 1 y se incrementa con cada nueva versión.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'numero_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el archivo fue cargado. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_carga';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del archivo (soft-delete). Conserva el registro para trazabilidad de cadena de custodia.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del motivo por el que el archivo fue dado de baja. Requerido para auditoría. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo',
    @level2type = N'COLUMN', @level2name = N'motivo_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tabla polimórfica que vincula un archivo a cualquier entidad del sistema con rol diferenciado.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo archivo-entidad. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_vinculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivo vinculado. FK a archivos.archivo.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del esquema de base de datos al que pertenece la entidad vinculada. Valores permitidos: per, inv, dil, evi, organizacion. Componente del identificador polimórfico.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'esquema';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la tabla a la que pertenece la entidad vinculada. Ej: denuncia, caso, peritaje, evidencia, persona. Componente del identificador polimórfico.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'entidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador (PK) del registro específico al que se vincula el archivo dentro de la tabla indicada en entidad.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'id_entidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol que cumple el archivo en el contexto de la entidad vinculada. Valores: PORTADA, ANEXO, EVIDENCIA_FOTO, RELATO, INFORME, DECRETO. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'rol_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se estableció el vínculo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'archivos',
    @level1type = N'TABLE',  @level1name = N'archivo_vinculo',
    @level2type = N'COLUMN', @level2name = N'fecha_vinculo';
GO


-- ----- Descripciones: casos -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de orígenes del caso (denuncia presencial, parte policial, derivación SITAD, etc.).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_origen_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados del caso (activo, cerrado, archivado, etc.).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_estado_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de niveles de prioridad del caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_prioridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de niveles de complejidad investigativa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_complejidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de roles de persona en caso, denuncia o hecho (víctima, imputado, testigo, denunciante, adulto responsable, etc.). Incluye flags de obligatoriedad de datos que la aplicación valida al asignar el rol en denuncia_persona_rol / hecho_persona_rol / caso_persona_rol: requiere_telefono, requiere_correo, requiere_domicilio, requiere_identificacion, requiere_fecha_nacimiento, requiere_ocupacion, requiere_estado_civil. Consolidada desde v20: las reglas de obligatoriedad antes expresadas en persona.telefono_obligatorio (S13/RN02) migran aquí por rol.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga al menos un registro activo en personas.telefono. S13/RN02 (antes en persona.telefono_obligatorio).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga al menos un registro activo en personas.correo. S13/RN02.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_correo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga al menos un registro activo en personas.persona_lugar. Relevante para notificaciones y para georreferenciación en Pauta VIF.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_domicilio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga una identificación en personas.identificacion. Típicamente exigido para víctima/imputado (RF09, RF19).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_identificacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga fecha_nacimiento registrada. Crítico para detectar minoría de edad y gatillar protocolo Ley 21.057.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_fecha_nacimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga al menos un registro en personas.empleo. Relevante para análisis de móvil económico del imputado.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_ocupacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = al asignar este rol, la aplicación debe validar que la persona tenga estado civil registrado en personas.estado_civil. Relevante para evaluar vínculo en Pauta VIF (Ley 20.066).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_rol_persona',
    @level2type = N'COLUMN', @level2name = N'requiere_estado_civil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de relato asociado a una denuncia.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_relato';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Carpeta investigativa que agrupa uno o más casos. Unidad de trabajo del investigador.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la carpeta. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'id_carpeta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio único de la carpeta generado por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'folio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo de la carpeta asignado por el investigador creador.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del alcance o propósito de la carpeta investigativa. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad PDI responsable de la carpeta. FK a organizacion.unidad.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'id_unidad_responsable';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que creó la carpeta. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_creador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionarios colaboradores asignados a una carpeta investigativa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de colaboración. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'id_carpeta_colaborador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Carpeta a la que se otorga acceso. FK a casos.carpeta.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'id_carpeta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario colaborador con acceso a la carpeta. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol del funcionario en la carpeta. Valor por defecto: COLABORADOR. Puede tomar valores como COLABORADOR, REVISOR, SUPERVISOR.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que otorgó el acceso al colaborador. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_invitador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el colaborador obtuvo acceso a la carpeta. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'fecha_ingreso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el colaborador dejó de tener acceso. Nulo si el acceso está vigente.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'carpeta_colaborador',
    @level2type = N'COLUMN', @level2name = N'fecha_salida';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad central del Case Manager. RUC, estado, fechas y vínculos con fiscalía. Soft-delete. v2.0: id_nivel_seguridad, id_grupo_operativo, fecha_endoso, fecha_plazo_gestion_interna (RN24).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del caso en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio interno del caso generado por el sistema. Identificador previo o complementario al RUC.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'folio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Carpeta investigativa a la que pertenece el caso. FK a casos.carpeta.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_carpeta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol Único de Causa asignado por el Ministerio Público. Identificador oficial del caso ante la fiscalía. Campo opcional — nulo mientras no se ha generado el RUC.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'ruc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registro de Investigación Criminal. Número interno PDI complementario al RUC. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'ric';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al registro correspondiente en el sistema Bitácora Web de la Fiscalía. Permite trazabilidad entre el sistema y el sistema externo de fiscalía. Campo opcional — pendiente decisión de negocio (#16).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'bitacora_web_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual del caso en el ciclo investigativo. FK a casos.cat_estado_caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_estado_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Origen por el que se inició el caso. FK a casos.cat_origen_caso. Ej: denuncia presencial, parte policial, iniciativa propia, derivación SITAD.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_origen_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel de prioridad asignado al caso para gestión de recursos investigativos. FK a casos.cat_prioridad. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_prioridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel de complejidad investigativa del caso. FK a casos.cat_complejidad. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'id_complejidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Título descriptivo del caso. Redactado por el investigador para identificar rápidamente el caso en listados y reportes.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'titulo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción narrativa del caso con antecedentes generales. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de apertura formal del caso en el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_apertura';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de cierre del caso. Nulo mientras el caso está activo.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_cierre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se formalizó el caso ante la fiscalía. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_formalizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha límite establecida para el desarrollo de la investigación según instrucción fiscal o normativa. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_plazo_investigacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se obtuvo el resultado definitivo del caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_resultado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del resultado final del caso. Ej: FORMALIZADO, SOBRESEÍDO, ARCHIVO PROVISIONAL. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'resultado_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Notas o instrucciones adicionales recibidas desde fiscalía, no estructuradas como instrucciones particulares formales. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'notas_fiscalia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de la última consulta al Sistema de Información de Apoyo a la Unidad (SIAU) para verificar el estado del caso ante el Ministerio Público. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_ultima_consulta_siau';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del caso (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Etiqueta dinámica del caso para categorización operativa. Ej: Mundial, Incendios, Foco. S3/RN22.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'contexto_etiqueta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resultado administrativo cierre. Valores: CON_RESULTADO / SIN_RESULTADO / CONTINUACION / SIN_DELITO. S9/RN12.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'tipo_resultado_admin';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio del procedimiento en BRAIN. Se registra en campo En Trámite para visibilidad en PDF. S14/RN01.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso',
    @level2type = N'COLUMN', @level2name = N'folio_brain';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'APPEND-ONLY. Historial de cambios de estado del caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de cambio de estado. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_historial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso cuyo estado cambió. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado en el que se encontraba el caso antes del cambio. FK a casos.cat_estado_caso. Nulo en el primer registro de estado.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_estado_anterior';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nuevo estado al que transicionó el caso. FK a casos.cat_estado_caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_estado_nuevo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que realizó el cambio de estado. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_cambio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Motivo o justificación del cambio de estado. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'motivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC del cambio de estado. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'fecha_cambio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación del delito que tenía el caso antes del cambio. FK a investigacion.clasificacion_delito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito_anterior';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencias judiciales del caso (ROL, RIT, RIC).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la referencia judicial. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'id_referencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que corresponde la referencia. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de referencia judicial. Valores: ROL (número de rol del tribunal), RIT (Registro de Ingreso al Tribunal), RIC (Registro de Imputado en Causa).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'tipo_referencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número o código de la referencia judicial.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'valor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tribunal al que corresponde la referencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'tribunal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que fue asignada la referencia judicial al caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre la referencia judicial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_referencia_judicial',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Personas relacionadas al caso con rol y vigencia.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo caso-persona-rol. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_caso_persona_rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que se vincula la persona. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona vinculada al caso. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol de la persona en el caso. FK a casos.cat_tipo_rol_persona. Ej: víctima, imputado, testigo, denunciante.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que la persona fue vinculada al caso en este rol.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que la persona fue retirada del caso en este rol. Nulo si la vinculación está vigente.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_retiro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre el vínculo de la persona con el caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Defensor asignado cuando el sujeto es menor sin adulto responsable. FK a funcionario. S13/RN08.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'caso_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_defensor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Asignación de investigador responsable al caso con historial.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la asignación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'id_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que se asigna el investigador. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario asignado como investigador responsable del caso. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cargo o función que desempeña el funcionario en el contexto de la asignación. FK a organizacion.cat_cargo_funcion. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'id_cargo_funcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el funcionario fue asignado al caso. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el funcionario dejó de ser responsable del caso. Nulo si la asignación está vigente.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'fecha_desasignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Motivo por el que el funcionario fue desasignado del caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'asignacion_funcionario',
    @level2type = N'COLUMN', @level2name = N'motivo_desasignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de niveles de seguridad del caso. Secreto bloquea consultas externas por RUT. Fuente: S3.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_nivel_seguridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de grupos operativos para clasificación estadística. Fuente: S3. Valores: MT-0, Focos, Especial.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_grupo_operativo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de programas gubernamentales de seguridad según comuna. Fuente: S14.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'cat_programa_seguridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Agrupación de múltiples RUC bajo un RUC principal. RUC más antiguo como principal. Fuente: S3.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la agrupación de causa. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'id_agrupacion_causa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso cuyo RUC actúa como principal en la agrupación. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'id_caso_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado de la agrupación. Valores: SOLICITADA, APROBADA, RECHAZADA, VIGENTE, DISUELTA. Valor por defecto: SOLICITADA.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que solicitó la agrupación. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_solicita';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario de jefatura que aprobó la agrupación. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_aprueba';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se solicitó la agrupación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'fecha_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de aprobación de la agrupación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'fecha_aprobacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fundamento de la solicitud de agrupación de causas. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'motivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre la agrupación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'RUC del caso más antiguo que actúa como contenedor de causas agrupadas. S3/RN31.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa',
    @level2type = N'COLUMN', @level2name = N'ruc_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Casos secundarios de una agrupación. N RUC → 1 RUC principal. Fuente: S3.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo agrupación-caso secundario. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa_caso',
    @level2type = N'COLUMN', @level2name = N'id_agrupacion_causa_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Agrupación de causa a la que se incorpora el caso. FK a casos.agrupacion_causa.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa_caso',
    @level2type = N'COLUMN', @level2name = N'id_agrupacion_causa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso secundario incorporado a la agrupación. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa_caso',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el caso fue incorporado a la agrupación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa_caso',
    @level2type = N'COLUMN', @level2name = N'fecha_incorporacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que registró la incorporación del caso a la agrupación. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'agrupacion_causa_caso',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Matriz de riesgos operacional PO01.11. Distinta de analitica.matriz_analisis. Se adjunta al informe policial.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la matriz de riesgo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'id_matriz_riesgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que corresponde la matriz de riesgo. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción detallada del riesgo operacional identificado en la investigación.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'descripcion_riesgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel de criticidad del riesgo. Ej: BAJO, MEDIO, ALTO, CRÍTICO.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'nivel_riesgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de las medidas propuestas para mitigar el riesgo identificado. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'medidas_mitigacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Recursos humanos, técnicos o materiales necesarios para ejecutar las medidas de mitigación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'recursos_requeridos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado de la matriz de riesgo. Valores: ELABORADA, APROBADA, EN_EJECUCION, CERRADA. Valor por defecto: ELABORADA.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que elaboró la matriz. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_elabora';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario de jefatura que aprobó la matriz. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_aprueba';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de elaboración de la matriz. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'fecha_elaboracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de aprobación de la matriz. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'fecha_aprobacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de inicio de ejecución de las medidas de mitigación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'fecha_ejecucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivo adjunto de la matriz de riesgo en formato documento. FK a archivos.archivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'casos',
    @level1type = N'TABLE',  @level1name = N'matriz_riesgo',
    @level2type = N'COLUMN', @level2name = N'id_archivo_adjunto';
GO


-- ----- Descripciones: investigacion -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de grados de participación criminal (autor, cómplice, encubridor).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_participacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de grados de ejecución del delito (tentativa, frustrado, consumado).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_grado_ejecucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de circunstancias modificatorias de responsabilidad (agravantes, atenuantes).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_circunstancia_modificatoria';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho delictual específico dentro del caso.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del hecho delictual. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece el hecho. FK a casos.caso. Actualmente nulo permitido — pendiente decisión de negocio (#23).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción narrativa del hecho delictual.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que ocurrió el hecho. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'fecha_ocurrencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la fecha de ocurrencia es aproximada. Valor 1 = fecha aproximada.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'fecha_ocurrencia_aproximada';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la hora de ocurrencia fue ajustada de 00:00 a 00:01 por regla de negocio S13/RN04. Valor 1 = ajustada. v3.1 v2: movida desde denuncias.denuncia.hora_hecho_ajustada (era atributo del hecho, no de la denuncia).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'hora_ocurrencia_ajustada';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo declaración. Valores: FORMAL / EMPADRONAMIENTO (sujeto en sitio sin declaración formal). S9/RN06.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'tipo_declaracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Forma de contacto/abordaje del modus operandi. FK a investigacion.cat_forma_contacto. Atributo del hecho capturado en pantalla PNTW02.01 sección 1 - Relato de los hechos.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'id_forma_contacto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Punto de acceso utilizado por el imputado en el modus operandi. FK a investigacion.cat_punto_acceso. Atributo del hecho capturado en pantalla PNTW02.01 sección 1 - Relato de los hechos.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'id_punto_acceso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Transporte utilizado en el modus operandi. FK a investigacion.cat_transporte_utilizado. Atributo del hecho capturado en pantalla PNTW02.01 sección 1 - Relato de los hechos.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho',
    @level2type = N'COLUMN', @level2name = N'id_transporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación hecho-lugar (sitio del suceso, etc.).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo hecho-lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'id_hecho_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho al que se vincula el lugar. FK a investigacion.hecho.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar geográfico vinculado al hecho. FK a ubicacion.lugar.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de lugar según su naturaleza. FK a ubicacion.cat_tipo_lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol del lugar en el contexto del hecho. FK a ubicacion.cat_rol_lugar. Ej: sitio del suceso, lugar de fuga, lugar de hallazgo.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el lugar principal del hecho. Valor 1 = lugar principal. v3.1 v2: regla "solo un principal activo por hecho" garantizada por índice único parcial ux_hecho_lugar_principal_activo (RN16.2/RN22.2 del documento de diseño SIP).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre el vínculo hecho-lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito imputado dentro del hecho. Incluye grado de ejecución.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del delito imputado. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_delito_imputado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio del delito imputado generado por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'folio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso en el que se imputa el delito. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho específico al que corresponde el delito imputado. FK a investigacion.hecho. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación del delito imputado. FK a investigacion.clasificacion_delito.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Grado de ejecución del delito. FK a investigacion.cat_grado_ejecucion. Ej: tentativa, frustrado, consumado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_grado_ejecucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el delito ocurrió en contexto de Violencia Intrafamiliar. Valor 1 = contexto VIF. RN de S3 y S13.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'contexto_vif';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción narrativa del delito imputado con el contexto específico del hecho.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'relato';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se formalizó la imputación del delito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'fecha_imputacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = delito de mayor envergadura jurídica en el caso. Solo uno por caso. S14/RN02.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'es_delito_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito principal al que se subordina este sub-delito. Ej: Homicidio → Ley de Drogas. S14/RN03.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_delito_padre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Móvil del delito imputado (clasificación analítica). FK a investigacion.cat_movil. Aplica principalmente a homicidios y secuestros. Se asigna al tipificar el delito a un imputado en un hecho. Permite generar dashboards y estadísticas reales sobre fenómenos delictuales (NotebookLM).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado',
    @level2type = N'COLUMN', @level2name = N'id_movil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Imputación de delito a persona con grado de participación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la imputación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'id_delito_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito imputado al que se vincula la persona. FK a investigacion.delito_imputado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'id_delito_imputado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona imputada. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Grado de participación criminal de la persona en el delito. FK a investigacion.cat_grado_participacion. Ej: autor, cómplice, encubridor.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'id_grado_participacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se estableció la vinculación de la persona al delito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'fecha_vinculacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la participación de la persona en el delito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_imputado_persona',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Circunstancias modificatorias de un delito imputado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_circunstancia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de circunstancia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_circunstancia',
    @level2type = N'COLUMN', @level2name = N'id_delito_circunstancia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito imputado al que aplica la circunstancia modificatoria. FK a investigacion.delito_imputado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_circunstancia',
    @level2type = N'COLUMN', @level2name = N'id_delito_imputado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Circunstancia modificatoria de responsabilidad. FK a investigacion.cat_circunstancia_modificatoria.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_circunstancia',
    @level2type = N'COLUMN', @level2name = N'id_circunstancia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del contexto en que concurre la circunstancia modificatoria en el delito específico. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'delito_circunstancia',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Personas relacionadas al hecho con rol.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo hecho-persona-rol. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_hecho_persona_rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho al que se vincula la persona. FK a investigacion.hecho.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona vinculada al hecho. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol de la persona en el hecho. FK a casos.cat_tipo_rol_persona.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se registró la vinculación de la persona al hecho. Valor por defecto: fecha local Chile (America/Santiago) al momento de inserción.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción narrativa de cómo participó la persona en el hecho. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'descripcion_participacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación de secuestro según tipología BIPE. Solo cuando delito es secuestro. Fuente: S9.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la clasificación de secuestro. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'id_subtipo_secuestro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito imputado de tipo secuestro al que aplica la clasificación. FK a investigacion.delito_imputado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'id_delito_imputado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Subtipo de secuestro según tipología BIPE. Ej: EXPRESS, EXTORSIVO, VIRTUAL, POLÍTICO.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'tipo_secuestro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del contexto y características específicas del secuestro clasificado. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado de la clasificación. Valores: EN_EVALUACION, CONFIRMADO, DESCARTADO. Valor por defecto: EN_EVALUACION.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se realizó la clasificación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'fecha_clasificacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario especializado que realizó la clasificación. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'subtipo_delito_secuestro',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_clasifica';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Plan táctico parametrizado por tipo de delito. Define acciones mínimas sugeridas al iniciar investigación. S4/RN24.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'protocolo_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Secciones del catálogo Fiscalía: GENERAL (Sección I) y VIF (Sección II Ley 20.066). Define el contexto de clasificación de los delitos. Codificación Penal diciembre 2025.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_seccion_catalogo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la sección. Clave primaria autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_seccion_catalogo',
    @level2type = N'COLUMN', @level2name = N'id_seccion_catalogo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la sección. Valores: GENERAL, VIF.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_seccion_catalogo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la sección y su marco legal.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_seccion_catalogo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación del catálogo Fiscalía: vincula cada código de delito con su familia y sección (GENERAL o VIF). PK surrogate id_clasificacion_delito. UNIQUE(id_delito, id_seccion_catalogo) garantiza que un delito no aparezca dos veces en la misma sección. Tabla padre de delito_imputado, protocolo_delito, caso_historial_estado y procedimiento_policial.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'clasificacion_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la clasificación. Clave primaria surrogate autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'clasificacion_delito',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito clasificado. FK a investigacion.cat_delito.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'clasificacion_delito',
    @level2type = N'COLUMN', @level2name = N'id_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Sección del catálogo a la que pertenece esta clasificación. FK a cat_seccion_catalogo.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'clasificacion_delito',
    @level2type = N'COLUMN', @level2name = N'id_seccion_catalogo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Familia a la que pertenece el delito en esta clasificación. FK a cat_familia_delito.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'clasificacion_delito',
    @level2type = N'COLUMN', @level2name = N'id_familia_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Familias del catálogo Fiscalía. Nombre único. 32 familias únicas. Codificación Penal diciembre 2025.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_familia_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la familia. Clave primaria autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_familia_delito',
    @level2type = N'COLUMN', @level2name = N'id_familia_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre único de la familia de delitos según catálogo Fiscalía.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_familia_delito',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Maestro de códigos CAPJ del catálogo Fiscalía. Un registro por código. Enriquecimiento SIP: cuerpo_legal, articulo_legal, requiere_peritaje_adn. Codificación Penal diciembre 2025.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del delito. Clave primaria autoincremental.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'id_delito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código numérico CAPJ único por delito. Definido por Comisión Interinstitucional. Actualización semestral/anual.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'codigo_capj';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = requiere peritaje de ADN como parte del protocolo de investigación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'requiere_peritaje_adn';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = vigente en sistemas institucionales. 0 = no vigente, se mantiene para registros históricos.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_delito',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO


-- ----- Descripciones: denuncias -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de denuncia. Pendiente decisión de negocio PDI — candidatos: Regular, Flagrante, Concurrencia. S1.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de denuncia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_denuncia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del tipo de denuncia. Ej: REGULAR, FLAGRANTE, CONCURRENCIA.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_denuncia',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tipo de denuncia.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_denuncia',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el tipo está vigente. Valor 1 = activo.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_denuncia',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia policial. v3.1 v1: id_fenomeno_delictual ELIMINADO — fenómeno se modela a nivel de hecho en investigacion.hecho_fenomeno (M:N). v2.0: estado_denuncia, indicador_vif, dominio_propiedad, observaciones.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la denuncia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio interno PDI generado automáticamente por el sistema al categorizar el delito (hito PO01.01.01 Registrar Denuncia). Identifica la denuncia durante todo su ciclo de vida, incluso antes de firma y antes de notificación a Fiscalía. NO es el RUC de Fiscalía (ver casos.caso.ruc) ni el folio del organismo emisor cuando la denuncia llega transferida (ver denuncias.denuncia.folio_externo). Formato: numeración secuencial nacional PDI. RN04 — S1.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'folio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio asignado por el organismo emisor original cuando la denuncia se recibe ya iniciada en otro organismo (Carabineros u otra policía) y se reinscribe en SIP. Es NULL cuando la denuncia nace directamente en PDI. Trazabilidad del número original del otro organismo. NO confundir con folio (folio interno PDI) ni con casos.caso.ruc (folio Fiscalía). Debe acompañarse de id_organismo_origen_externo (ambos NULL o ambos NOT NULL, ver CK_denuncia_folio_externo_consistente).',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'folio_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Organismo que originó la denuncia cuando llega transferida desde fuera de PDI. FK a organizacion.cat_organismo_externo. Típicamente apunta a un organismo con tipo_organismo = POLICIA (Carabineros) o FISCALIA (Ministerio Público). Es NULL cuando la denuncia nace directamente en PDI. Debe mantener consistencia con folio_externo por CK_denuncia_folio_externo_consistente: ambos NULL o ambos NOT NULL.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'id_organismo_origen_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece la denuncia una vez generado el RUC. FK a casos.caso. Nulo mientras la denuncia no tiene RUC asociado.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que se recepcionó formalmente la denuncia en la unidad PDI.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'fecha_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Canal por el que ingresó la denuncia. Ej: PRESENCIAL, TELEFÓNICO, WEB, DERIVACIÓN.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'canal_recepcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del lugar donde se recepcionó la denuncia. Ej: nombre de la unidad o cuartel PDI. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'lugar_ingreso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que recepcionó la denuncia. FK a organizacion.funcionario. Campo opcional — puede completarse en diferido.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_receptor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación del registro.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de denuncia. FK a denuncias.cat_tipo_denuncia. NULL hasta decisión de negocio PDI — cambiar a NOT NULL al confirmar tipos. Candidatos: REGULAR, FLAGRANTE, CONCURRENCIA.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'GUID de borrador generado antes del folio definitivo. S1/RN05.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'prefolio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora de envío a Fiscalía. Plazo legal 24h desde registro. S1/RN11.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'fecha_envio_fiscalia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado envío a Fiscalía. Valores: PENDIENTE / ENVIADO / PRORROGADO. S1/RN11.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'estado_envio_fiscalia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del formulario. Valores: BORRADOR / COMPLETA / VISADA. S1/RN27.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'estado_borrador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = caso de flagrancia. Inversión de flujo: detención puede preceder a denuncia. S2/RN20.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'es_flagrancia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hora detención en flagrancia. Puede preceder a la denuncia formal. S2/RN20.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'fecha_detencion_previa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha envío al Ministerio Público. Plazo legal 24h. S12/RN03.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia',
    @level2type = N'COLUMN', @level2name = N'fecha_envio_mp';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relato narrativo asociado a la denuncia.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del relato. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_relato';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia a la que corresponde el relato. FK a denuncias.denuncia.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de relato según su naturaleza. FK a casos.cat_tipo_relato. Ej: declaración víctima, declaración testigo, relato funcionario.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_tipo_relato';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resumen textual del relato. Campo opcional cuando el relato está íntegramente en archivo adjunto.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'resumen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivo de audio, video o documento que contiene el relato completo. FK a archivos.archivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que recepcionó y registró el relato. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_receptor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si quien declara es el mismo denunciante. Valor 1 = declarante es denunciante. Valor 0 = declarante es otra persona.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'declarante_es_denunciante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona que realizó la declaración cuando no es el denunciante. FK a personas.persona. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_persona_declarante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de versión del relato. Inicia en 1. Se incrementa cuando el declarante rectifica o amplía su declaración.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'numero_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relato que este registro reemplaza o amplía. FK a denuncias.relato. Nulo en la versión inicial.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'id_relato_version_anterior';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que se realizó la declaración.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'fecha_declaracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'relato',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación denuncia-hecho. Una denuncia puede involucrar múltiples hechos.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo denuncia-hecho. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_hecho',
    @level2type = N'COLUMN', @level2name = N'id_denuncia_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia vinculada al hecho. FK a denuncias.denuncia.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_hecho',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho vinculado a la denuncia. FK a investigacion.hecho.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_hecho',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Personas relacionadas a la denuncia con rol.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo denuncia-persona-rol. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_denuncia_persona_rol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia a la que se vincula la persona. FK a denuncias.denuncia.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona vinculada a la denuncia. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol de la persona en la denuncia. FK a casos.cat_tipo_rol_persona. Ej: víctima, imputado, testigo, denunciante.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'id_tipo_rol_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la persona realizó una declaración formal en el marco de la denuncia. Valor 1 = declarante.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'es_declarante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si esta es la persona principal para el rol indicado en la denuncia. Valor 1 = persona principal.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que la persona fue vinculada a la denuncia en este rol. Valor por defecto: fecha local Chile (America/Santiago) al momento de inserción.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que la persona fue retirada de la denuncia en este rol. Nulo si la vinculación está vigente.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_retiro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre la participación de la persona en la denuncia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'denuncia_persona_rol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo oficial de fenómenos delictuales del Ministerio Público (MP define el catálogo, PDI lo aplica al hecho). v3.1 v1: el fenómeno se asigna al hecho criminal vía investigacion.hecho_fenomeno (M:N), no a la denuncia. Actualización anual junio. Fuente: S1, NotebookLM.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del fenómeno delictual. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'id_fenomeno';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código oficial del fenómeno asignado por el Ministerio Público.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'codigo_mp';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre oficial del fenómeno delictual. Ej: Robo con violencia, Tráfico de drogas, Homicidio, Turbazo, Abordazo, Encerrona.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diccionario tooltip del fenómeno delictual. v3.1 v1: ampliado de VARCHAR(500) a VARCHAR(2000) para soportar descripciones detalladas que diferencian conceptos similares (ej. distinguir Abordazo vs Encerrona). Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Año de vigencia del fenómeno según la versión del catálogo del Ministerio Público. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'anio_vigencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el fenómeno está vigente en el catálogo actual. Valor 1 = vigente. Los fenómenos desactivados se preservan para trazabilidad de denuncias históricas.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'fenomeno_delictual',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Vehículo sustraído en SUEV. 0..1 por denuncia. Número único nacional. Fuente: S1.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del encargo SUEV en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'id_encargo_suev';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia que origina el encargo vehicular. FK a denuncias.denuncia.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Vehículo encargado, si fue previamente registrado en el sistema. FK a vehiculos.vehiculo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'id_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Placa patente única (PPU) del vehículo encargado. Obligatorio para generar el encargo en SUEV.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'patente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de Encargo Único Nacional (EUN) asignado por la plataforma SUEV al confirmar el encargo. Campo opcional — nulo mientras el encargo no ha sido confirmado por SUEV.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'n_encargo_nacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio interno generado por SUEV al iniciar el registro del encargo, previo a la asignación del EUN. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'folio_suev';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual del encargo vehicular. Valores esperados: ACTIVO, SOLUCIONADO, CANCELADO. Valor por defecto: ACTIVO.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de cancelación del encargo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'fecha_cancelacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que registró el encargo. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre el encargo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_suev',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Formulario VIF. Vínculo agresor obligatorio. GIS ArcGIS. Firma Acta Art.26. Fuente: S3/S13.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la pauta VIF. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'id_pauta_vif';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia asociada a la pauta VIF. FK a denuncias.denuncia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso asociado a la pauta VIF. FK a casos.caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona imputada como agresor en el contexto VIF. FK a personas.persona. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'id_persona_imputado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona víctima en el contexto VIF. FK a personas.persona. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'id_persona_victima';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de vínculo entre el agresor y la víctima. Obligatorio para la pauta VIF. Ej: cónyuge, conviviente, ex conviviente, hijo, padre.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'vinculo_agresor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la víctima presenta lesiones físicas visibles al momento del registro. Valor 1 = presenta lesiones visibles.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'tiene_lesiones_visibles';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de las medidas de protección adoptadas o solicitadas en favor de la víctima. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'medidas_proteccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia de georeferenciación del lugar del hecho VIF compatible con el visor GIS. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'georreferencia_arcgis';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el imputado firmó el apercibimiento establecido en el Art. 26 de la Ley 20.066 de VIF. Valor 1 = firmó.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'firma_apercibimiento_art26';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales relevantes para la pauta VIF. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que completó el formulario VIF. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'pauta_vif',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad raíz del flujo de flagrancia PO01.08. Folio bitácora PDI vs folio externo. Fuente: S14.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del procedimiento policial. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_procedimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio de bitácora PDI asignado al procedimiento. Identificador interno de trazabilidad.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'folio_bitacora';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio externo asignado por otro organismo (Carabineros, Fiscalía). Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'folio_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso asociado al procedimiento, si ya fue generado el RUC. FK a casos.caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Delito principal que motiva el procedimiento policial. FK a investigacion.cat_delito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_delito_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar donde se desarrolló el procedimiento. FK a ubicacion.lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de procedimiento policial. Ej: FLAGRANCIA, CONTROL_IDENTIDAD, DETENCIÓN.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'tipo_procedimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del procedimiento. Valores: CREADO, EN_PROCESO, CERRADO. Valor por defecto: CREADO.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la fiscalía receptora del procedimiento. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_fiscalia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador del fiscal a cargo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_fiscal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI responsable del procedimiento. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Programa gubernamental de seguridad en el contexto del cual se ejecutó el procedimiento. FK a casos.cat_programa_seguridad. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'id_programa_seguridad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_policial',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Participación de persona en procedimiento con condición. Fuente: S14.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo procedimiento-persona. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'id_procedimiento_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Procedimiento policial al que se vincula la persona. FK a denuncias.procedimiento_policial.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'id_procedimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona participante en el procedimiento. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Condición de la persona en el procedimiento. Ej: DETENIDO, CONTROLADO, TESTIGO, VÍCTIMA, IMPUTADO_LIBRE.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'condicion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la persona es menor de 18 años al momento del procedimiento. Valor 1 = menor de edad. Determina el protocolo de actuación aplicable.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'es_menor_edad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que registró la participación de la persona. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la participación de la persona en el procedimiento. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'procedimiento_persona',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Encargos de búsqueda de personas. Consulta automática al identificar persona en el sistema. RF05/RF18/S1.RN25.',
    @level0type = N'SCHEMA', @level0name = N'denuncias',
    @level1type = N'TABLE',  @level1name = N'encargo_persona';
GO


-- ----- Descripciones: diligencias -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de diligencia policial.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados de diligencia.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de instrucción fiscal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_instruccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados de instrucción fiscal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_instruccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de detención (flagrancia, orden judicial, etc.).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de peritaje (balístico, dactilar, bioquímico, etc.).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_peritaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de informe policial (primeras diligencias, final, etc.).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_informe';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de notificación externa recibida.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_notificacion_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de fuentes de notificaciones externas (tribunal, fiscalía, etc.).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_fuente_observacion_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Instrucciones del fiscal al investigador dentro de un caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la instrucción fiscal. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_instruccion_fiscal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que corresponde la instrucción. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio o número de referencia asignado por fiscalía a la instrucción. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'folio_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de instrucción fiscal. FK a diligencias.cat_tipo_instruccion. Ej: instrucción particular, orden de investigar, requerimiento de antecedentes.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_tipo_instruccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual de la instrucción. FK a diligencias.cat_estado_instruccion. Ej: RECIBIDA, EN_EJECUCIÓN, CUMPLIDA, VENCIDA.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad PDI destinataria de la instrucción. FK a organizacion.unidad. Campo opcional — puede derivarse a distinta unidad de la que recibe.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_unidad_destinataria';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del fiscal o entidad que emitió la instrucción. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'emitida_por';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que fue emitida la instrucción por fiscalía.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'fecha_emision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que la unidad PDI recibió formalmente la instrucción. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'fecha_recepcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha límite para el cumplimiento de la instrucción según lo establecido por fiscalía. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resumen del contenido de la instrucción y las diligencias ordenadas.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'resumen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel de confidencialidad de la instrucción. FK a archivos.cat_nivel_confidencialidad. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_nivel_confidencialidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = orden verbal de juez sin documento físico. Obligatorio: nombre juez, hora, folio verbal. S2/RN26.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'es_orden_verbal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del juez que emite la orden verbal. Obligatorio si es_orden_verbal = 1. S2/RN26.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'nombre_juez_verbal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = instrucción bajo secreto investigativo. Oculta en búsquedas generales. S2/RN27.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'es_secreto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia origen que motiva la instrucción fiscal. FK a denuncias.denuncia. Campo opcional. S3/RN19.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'instruccion_fiscal',
    @level2type = N'COLUMN', @level2name = N'id_denuncia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Actuación policial dentro de un caso. Soft-delete.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la diligencia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece la diligencia. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho específico al que se asocia la diligencia. FK a investigacion.hecho. Campo opcional — una diligencia puede estar vinculada al caso sin hecho específico.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Instrucción fiscal que origina la diligencia. FK a diligencias.instruccion_fiscal. Campo opcional — nulo cuando la diligencia es por iniciativa del investigador.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_instruccion_fiscal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de actuación policial. FK a diligencias.cat_tipo_diligencia. Determina si es primera diligencia y si requiere autorización judicial previa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_tipo_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual de la diligencia. FK a diligencias.cat_estado_diligencia. Ej: PENDIENTE, EN_PROCESO, FINALIZADA.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI responsable de ejecutar la diligencia. FK a organizacion.funcionario. S2 establece que la asignación se realiza mediante RUT del funcionario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar principal donde se ejecuta la diligencia. FK a ubicacion.lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la diligencia encomendada y su objetivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resultado o informe narrativo de la diligencia una vez ejecutada. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'resultado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que fue encomendada la diligencia al funcionario responsable.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_encomendada';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha límite para la ejecución de la diligencia. Campo opcional — corresponde al SLA de 48 horas o al plazo indicado por instrucción fiscal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_plazo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que la diligencia fue efectivamente ejecutada. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_ejecucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia a la resolución judicial que autoriza la diligencia cuando requiere autorización previa. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'autorizacion_judicial_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de la resolución judicial de autorización. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_autorizacion_judicial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al registro en el sistema Bitácora Web de la Fiscalía cuando la diligencia fue notificada por esa vía. Campo opcional — pendiente decisión de negocio (#16).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'bitacora_web_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha notificación formal de la diligencia a Fiscalía. S2/RN03.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'fecha_envio_fiscalia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = origen PDI (institucional) · 0 = origen Fiscalía. S2/RN19.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'es_origen_institucional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = diligencia autoriza descerrajamiento. S2/RN25.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'autoriza_descerrajamiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rango horario autorizado para ejecutar la diligencia. Ej: 06:00-22:00. S2/RN25.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'horario_autorizado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = registro de bitácora de actividad interna · 0 = diligencia formal. S9/RN14.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia',
    @level2type = N'COLUMN', @level2name = N'es_bitacora';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación diligencia-lugar geográfico.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo diligencia-lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_diligencia_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencia a la que se vincula el lugar. FK a diligencias.diligencia.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar geográfico vinculado. FK a ubicacion.lugar.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de lugar según su naturaleza. FK a ubicacion.cat_tipo_lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol del lugar en el contexto de la diligencia. FK a ubicacion.cat_rol_lugar. Ej: lugar de ejecución, domicilio allanado, lugar de encuentro.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el lugar principal de la diligencia. Valor 1 = lugar principal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre el vínculo diligencia-lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'diligencia_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registro de detención de personas en el marco de una diligencia.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de detención. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso en cuyo marco se produjo la detención. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona detenida. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de detención. FK a diligencias.cat_tipo_detencion. Ej: flagrancia, orden judicial, orden de detención.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_tipo_detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que efectuó la detención. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_detentor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad PDI bajo cuya responsabilidad queda el detenido. FK a organizacion.unidad.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar donde se produjo la detención. FK a ubicacion.lugar. Campo opcional — el detalle de lugar se gestiona también en diligencias.detencion_lugar.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora exacta en que se efectuó la detención.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_hora_detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que el detenido fue puesto a disposición del tribunal o fiscalía competente. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_hora_puesta_disposicion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de los antecedentes y fundamentos legales de la detención.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'motivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencia en el contexto de la cual se produjo la detención. FK a diligencias.diligencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre la detención. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = detenido es extranjero. Genera notificación automática a unidad migratoria. S7/RN16.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion',
    @level2type = N'COLUMN', @level2name = N'alerta_extranjero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar donde ocurrió la detención.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo detención-lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'id_detencion_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Detención a la que se vincula el lugar. FK a diligencias.detencion.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'id_detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar geográfico vinculado. FK a ubicacion.lugar.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de lugar según su naturaleza. FK a ubicacion.cat_tipo_lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol del lugar en el contexto de la detención. FK a ubicacion.cat_rol_lugar. Ej: lugar de detención, lugar de traslado, lugar de custodia.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el lugar principal de la detención. Valor 1 = lugar principal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre el vínculo detención-lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'detencion_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Solicitud y resultado de peritaje. v2.0: id_solicitud_concurrencia.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del peritaje. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_peritaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece el peritaje. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie o evidencia objeto del peritaje. FK a evidencia.especie. Campo opcional — puede existir peritaje sin especie registrada en casos de flagrancia (S6 — RN14).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de peritaje solicitado. FK a diligencias.cat_tipo_peritaje. Ej: balístico, dactilar, bioquímico, fotográfico, planimetría.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_tipo_peritaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad institucional que ejecuta el peritaje. FK a organizacion.unidad. Típicamente una sección del LACRIM.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_institucion_ejecutora';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que solicitó el peritaje. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_solicitante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencia en cuyo marco se solicita el peritaje. FK a diligencias.diligencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que se solicitó el peritaje.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'fecha_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que el laboratorio o sección pericial recibió la especie o solicitud. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'fecha_recepcion_lab';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que fue emitido el informe pericial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'fecha_emision_informe';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número del informe pericial generado automáticamente por el sistema. S6 — RN30. Campo opcional hasta la emisión formal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'numero_informe_pericial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resumen de los resultados del peritaje. Campo opcional — el informe completo se adjunta como archivo en archivos.archivo.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'resultado_resumen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del peritaje en su ciclo de vida. FK a diligencias.cat_estado_diligencia. Ej: SOLICITADO, EN_PROCESO, FINALIZADO.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'OI o IP que origina el peritaje. FK a diligencias.instruccion_fiscal. Campo opcional. S6/RN01.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'peritaje',
    @level2type = N'COLUMN', @level2name = N'id_instruccion_fiscal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Informe policial generado en el caso. v2.0: estado_informe.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del informe policial. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'id_informe';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece el informe. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencia específica a la que está asociado el informe. FK a diligencias.diligencia. Campo opcional — un informe puede referirse a múltiples diligencias.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de informe policial. FK a diligencias.cat_tipo_informe. Ej: primeras diligencias, final, complementario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'id_tipo_informe';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número correlativo del informe asignado por el sistema. Campo opcional en estados previos a la generación formal.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'numero_informe';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI autor del informe. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_autor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha en que fue elaborado el informe.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'fecha_elaboracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resumen del contenido del informe. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'resumen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'informe_policial',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'APPEND-ONLY. Notificaciones recibidas de organismos externos. Distinta de notificaciones internas al usuario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la notificación externa. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_notificacion_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que corresponde la notificación. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de notificación recibida. FK a diligencias.cat_tipo_notificacion_externa.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_tipo_notificacion_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fuente institucional que emitió la notificación. FK a diligencias.cat_fuente_observacion_externa. Ej: tribunal, fiscalía, Ministerio Público.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_fuente_observacion_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del organismo emisor de la notificación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'organismo_emisor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tribunal cuando la notificación proviene de sede judicial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'tribunal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número o referencia asignada por el organismo externo a la notificación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'referencia_externa';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora del evento o resolución que genera la notificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'fecha_evento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que la notificación fue registrada en el sistema. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'fecha_observacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resumen del contenido de la notificación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'resumen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado al que debe transicionar el caso como consecuencia de esta notificación. FK a casos.cat_estado_caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_estado_caso_resultante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que registró la notificación en el sistema. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Documento adjunto de la notificación recibida. FK a archivos.archivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'notificacion_externa',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de especialidades periciales del LACRIM. Fuente: S6.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'cat_especialidad_pericial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Solicitud formal de concurrencia de peritos. Múltiples peritos posibles. Fuente: S6/RN02.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la solicitud de concurrencia pericial. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'id_solicitud_pericial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio único de la solicitud generado por el sistema. S6 — RN30 establece que el número de informe pericial debe generarse automáticamente.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'folio_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que corresponde la solicitud. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Instrucción fiscal que origina la solicitud pericial. FK a diligencias.instruccion_fiscal. Campo opcional — S6 — RN01 establece que la gestión pericial se origina desde una Orden de Investigar o Instrucción Particular.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'id_instruccion_fiscal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Oficial investigador que realiza la solicitud. FK a organizacion.funcionario. S6 — RN28 establece que el teléfono del oficial solicitante es dato crítico para coordinación.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_solicitante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar al que deben concurrir los peritos. FK a ubicacion.lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción libre de las especialidades periciales requeridas cuando aún no se han asignado peritos específicos. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'especialidad_requerida';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la solicitud. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'fecha_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado de la solicitud. Valores: REGISTRADA, ASIGNADA, EN_PROCESO, FINALIZADA, CANCELADA. Valor por defecto: REGISTRADA.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la solicitud de concurrencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación del estado de la solicitud.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cantidad total de especies levantadas en la concurrencia. S6/RN17.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'cantidad_especies';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Teléfono contacto oficial solicitante. Obligatorio para coordinación llegada al sitio. S6/RN28.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'telefono_oficial_solicitante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = concurrencia en homicidio. Requiere cartilla de concurrencia específica. S9/RN07.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_pericial',
    @level2type = N'COLUMN', @level2name = N'es_homicidio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Asignación de perito a solicitud. Cada uno genera informe independiente. Fuente: S6.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la asignación de perito. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'id_solicitud_perito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Solicitud de concurrencia a la que se asigna el perito. FK a diligencias.solicitud_concurrencia_pericial.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'id_solicitud_pericial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario perito asignado. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_perito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especialidad pericial con la que concurre el perito. FK a diligencias.cat_especialidad_pericial.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'id_especialidad_pericial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del perito en la concurrencia. Valores: ASIGNADO, EN_CAMINO, EN_SITIO, FINALIZADO. Valor por defecto: ASIGNADO.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de asignación del perito a la solicitud. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el perito inició la actuación pericial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'fecha_inicio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el perito finalizó la actuación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'fecha_fin';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la asignación o actuación del perito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'solicitud_concurrencia_perito',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Órdenes de detención. Plazo legal 10 días. Tipos: DIRECTA (facultad directa) / INVESTIGATIVA (proceso PDI). S2/RN11/RN24.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_detencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Órdenes de arresto civil. Permite registro de comprobante de pago para liberación inmediata. S2/RN28.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'orden_arresto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Bitácora de actividades investigativas por diligencia. Registra pasos intermedios incluyendo resultados negativos. S4/RN14 · S9/RN14.',
    @level0type = N'SCHEMA', @level0name = N'diligencias',
    @level1type = N'TABLE',  @level1name = N'actividad_investigativa';
GO


-- ----- Descripciones: catalogo_bienes -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Metadato administrativo de cada versión UNSPSC publicada y cargada en SIP. Solo una versión puede estar vigente a la vez (índice filtrado uq_version_catalogo_vigente).',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador interno de la versión. PK con IDENTITY. Referenciado por todas las tablas jerárquicas (segmento, familia, clase, producto) y por codigo_reemplazado.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de la versión UNSPSC en formato ''vNN.MMDD''. Ej: v26.0801 = versión 26 publicada el 1 de agosto. Único por versión.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo',
    @level2type = N'COLUMN', @level2name = N'codigo_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha oficial de publicación de la versión UNSPSC por el organismo GS1.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo',
    @level2type = N'COLUMN', @level2name = N'fecha_publicacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que esta versión fue cargada en SIP. Auditoría del ETL.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo',
    @level2type = N'COLUMN', @level2name = N'fecha_carga';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si esta versión es la actualmente vigente. 1 = vigente, 0 = histórica. Solo una fila puede tener es_vigente = 1 (enforced por índice filtrado).',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo',
    @level2type = N'COLUMN', @level2name = N'es_vigente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Notas administrativas sobre la carga de esta versión. Opcional.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'version_catalogo',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel 1 de la jerarquía UNSPSC. Código de 2 dígitos. ~60 segmentos por versión. Agrupa familias relacionadas a un dominio amplio (ej: 46 = Equipo de defensa y seguridad).',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador interno del segmento. PK con IDENTITY. Referenciado por familia.id_segmento.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento',
    @level2type = N'COLUMN', @level2name = N'id_segmento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión UNSPSC a la que pertenece este segmento. FK a version_catalogo.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código UNSPSC del segmento. CHAR(2), dos dígitos. Único por versión. Ej: 46.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del segmento UNSPSC. Ej: Equipo de defensa, orden público, seguridad pública, vigilancia y seguridad.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el segmento está vigente en su versión. 1 = activo, 0 = obsoleto pero preservado por trazabilidad histórica.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de inserción del registro en la BD. Auditoría del ETL.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'segmento',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel 2 de la jerarquía UNSPSC. Código de 4 dígitos (los primeros 2 = segmento padre). ~500 familias por versión. Ej: 4617 = Equipo y armas de seguridad, control y protección personal.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador interno de la familia. PK con IDENTITY. Referenciado por clase.id_familia.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'id_familia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión UNSPSC a la que pertenece esta familia. FK a version_catalogo.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Segmento padre de esta familia. FK a segmento.id_segmento. El ETL valida que los primeros 2 dígitos del código de familia coincidan con el código del segmento padre.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'id_segmento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código UNSPSC de la familia. CHAR(4), cuatro dígitos. Único por versión. Los primeros 2 dígitos corresponden al segmento padre.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo de la familia UNSPSC.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la familia está vigente en su versión. 1 = activo, 0 = obsoleto pero preservado por trazabilidad histórica.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de inserción del registro en la BD. Auditoría del ETL.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'familia',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel 3 de la jerarquía UNSPSC. Código de 6 dígitos (los primeros 4 = familia padre). ~5.000 clases por versión. Ej: 461715 = Ropa y accesorios de protección corporal.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador interno de la clase. PK con IDENTITY. Referenciado por producto.id_clase.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'id_clase';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión UNSPSC a la que pertenece esta clase. FK a version_catalogo.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Familia padre de esta clase. FK a familia.id_familia. El ETL valida que los primeros 4 dígitos del código de clase coincidan con el código de la familia padre.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'id_familia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código UNSPSC de la clase. CHAR(6), seis dígitos. Único por versión. Los primeros 4 dígitos corresponden a la familia padre.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo de la clase UNSPSC.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la clase está vigente en su versión. 1 = activo, 0 = obsoleto pero preservado por trazabilidad histórica.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de inserción del registro en la BD. Auditoría del ETL.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'clase',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel 4 de la jerarquía UNSPSC. Código de 8 dígitos (los primeros 6 = clase padre). ~60.000 productos por versión. Tabla destino de evidencia.especie.id_producto para clasificar bienes incautados. Incluye productos oficiales UNSPSC y productos comodín locales (sufijo ''99'') para bienes que no tienen producto específico.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador interno del producto. PK con IDENTITY. Clave para la FK histórica desde evidencia.especie. Al cargar una nueva versión UNSPSC se genera un nuevo id_producto aunque el código sea el mismo — esto preserva la clasificación histórica exacta de cada especie.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'id_producto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión UNSPSC a la que pertenece este producto. FK a version_catalogo.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'id_version';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clase padre de este producto. FK a clase.id_clase. El ETL valida que los primeros 6 dígitos del código de producto coincidan con el código de la clase padre.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'id_clase';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código UNSPSC del producto. CHAR(8), ocho dígitos. Único por versión. Los primeros 6 dígitos corresponden a la clase padre. Productos con sufijo ''99'' son comodines locales SIP, no oficiales UNSPSC.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del producto UNSPSC.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el producto está vigente en su versión. 1 = activo, 0 = obsoleto pero preservado por trazabilidad histórica.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de inserción del registro en la BD. Auditoría del ETL.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'producto',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Auditoría de reclasificaciones UNSPSC entre versiones. Registra cuando un código oficial fue reemplazado por otro. La columna nivel es computada PERSISTED y se deriva de LEN(codigo_anterior).',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'codigo_reemplazado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código UNSPSC que fue reemplazado. Parte de la clave primaria. Longitud (2, 4, 6, 8) determina el nivel.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'codigo_reemplazado',
    @level2type = N'COLUMN', @level2name = N'codigo_anterior';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código UNSPSC que reemplaza al anterior. Debe tener la misma longitud que codigo_anterior (CK).',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'codigo_reemplazado',
    @level2type = N'COLUMN', @level2name = N'codigo_nuevo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Versión UNSPSC en la cual se registró este reemplazo. FK a version_catalogo.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'codigo_reemplazado',
    @level2type = N'COLUMN', @level2name = N'id_version_cambio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nivel jerárquico del código reemplazado. Columna computada PERSISTED derivada de LEN(codigo_anterior): 2→S (segmento), 4→F (familia), 6→C (clase), 8→P (producto). No admite INSERT/UPDATE explícito.',
    @level0type = N'SCHEMA', @level0name = N'catalogo_bienes',
    @level1type = N'TABLE',  @level1name = N'codigo_reemplazado',
    @level2type = N'COLUMN', @level2name = N'nivel';
GO


-- ----- Descripciones: evidencias -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de especie incautada (arma, droga, dinero, electrónico, vehículo, etc.).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_extension_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados de la especie (activa, liberada, destruida, etc.).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_estado_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de custodia de evidencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_custodia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de instituciones ejecutoras de peritajes (LACRIM, SML, etc.).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_institucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de propósitos de transferencia de evidencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_proposito_transferencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Evidencia recopilada. NUE (Número Único de Evidencia). Vinculada a caso, hecho y diligencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la evidencia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_evidencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece la evidencia. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho específico al que se asocia la evidencia. FK a investigacion.hecho. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencia en cuyo marco fue recopilada la evidencia. FK a diligencias.diligencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la evidencia recopilada, su naturaleza y contexto de hallazgo.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar donde fue encontrada o recolectada la evidencia. FK a ubicacion.lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_lugar_hallazgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que fue hallada la evidencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'fecha_hallazgo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que fue formalmente incautada la evidencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'fecha_incautacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que realizó la incautación. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_incautador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al número de acta de incautación cuando fue generada en documento físico o externo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'acta_incautacion_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al registro en el sistema Bitácora Web de la Fiscalía cuando la incautación fue notificada por esa vía. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'bitacora_web_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la evidencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Evento formal de incautación al que pertenece esta evidencia. FK a evidencia.incautacion. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'id_incautacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número Único de Evidencia. Identificador externo asignado por Fiscalía. S4/RN10.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'nue';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora de fijación fotográfica en el lugar antes del levantamiento. S4/RN16.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia',
    @level2type = N'COLUMN', @level2name = N'fecha_fijacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación evidencia-lugar (dónde fue encontrada/recolectada).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo evidencia-lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_evidencia_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Evidencia vinculada al lugar. FK a evidencia.evidencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_evidencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar geográfico vinculado. FK a ubicacion.lugar.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de lugar según su naturaleza. FK a ubicacion.cat_tipo_lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol del lugar respecto a la evidencia. FK a ubicacion.cat_rol_lugar. Ej: lugar de hallazgo, lugar de recolección, lugar de almacenamiento.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el lugar principal asociado a la evidencia. Valor 1 = lugar principal.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre el vínculo evidencia-lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'evidencia_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie física incautada. RUE (Registro Único de Especie). Vinculada a evidencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la especie. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Evidencia a la que pertenece la especie. FK a evidencia.evidencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_evidencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso al que pertenece la especie. FK a casos.caso. Permite consultas directas sin navegar por evidencia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número Único de Evidencia (NUE) asignado a la especie. Identificador operacional utilizado por peritos e investigadores para referenciar la especie en informes y actas. S6 — RN05.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'nue';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registro Único de Especie (RUE). Identificador institucional permanente de la especie en el sistema. Campo opcional en etapas previas a la formalización.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'rue';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación UNSPSC del bien incautado. FK a catalogo_bienes.producto. NULL = especie no clasificada. El IDENTITY de producto preserva la clasificación histórica exacta al momento de la incautación — aunque el catálogo cambie de versión, la especie conserva el registro del producto usado originalmente. Si el bien no corresponde a un producto UNSPSC específico, se clasifica a un producto comodín local (sufijo ''99'') dentro de su clase.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_producto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de especie incautada. FK a evidencia.cat_tipo_extension_especie. Determina qué tabla de extensión aplica. Ej: ARMA, DROGA, ELECTRÓNICO, VEHÍCULO, OTRO.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_tipo_extension_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual de la especie en el sistema. FK a evidencia.cat_estado_especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_estado_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de custodia actual de la especie. FK a evidencia.cat_tipo_custodia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'id_tipo_custodia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la institución que tiene actualmente la custodia física de la especie. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'custodio_institucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la especie incluyendo características físicas observables, estado de conservación y contexto de hallazgo.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Cantidad de unidades de la especie. Valor por defecto: 1. S8 — RN17 establece que debe registrarse la cantidad total de especies levantadas.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'cantidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valor estimado de la especie en pesos chilenos. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'valor_estimado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de serie de la especie cuando aplica a nivel general. Para armas y electrónicos se registra adicionalmente en la tabla de extensión correspondiente. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'numero_serie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la especie cuenta con registro fotográfico en el sistema. Valor 1 = tiene fotografías adjuntas.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'registro_fotografico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la especie. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del registro (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'NUE de la evidencia padre cuando la especie es subdivisión de otra. S4/RN19 · S6/RN06.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'nue_padre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad de medida. Valores: KG / G / L / ML / UNIDAD / M / M2. S8/RN02.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie',
    @level2type = N'COLUMN', @level2name = N'unidad_medida';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar asociado a la especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo especie-lugar. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'id_especie_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie vinculada al lugar. FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar geográfico vinculado. FK a ubicacion.lugar.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de lugar según su naturaleza. FK a ubicacion.cat_tipo_lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'id_tipo_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol del lugar respecto a la especie. FK a ubicacion.cat_rol_lugar. Ej: lugar de hallazgo, lugar de incautación, bodega de custodia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'id_rol_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el lugar principal asociado a la especie. Valor 1 = lugar principal.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Información adicional sobre el vínculo especie-lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_lugar',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Detalle de especie tipo arma. v2.0: id_clasificacion_arma, id_catalogo_arma, dgmn_ref.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la especie, compartido con evidencia.especie. PK y FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_arma',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Arma identificada a la que corresponde esta especie. FK a evidencia.arma. Campo opcional — nulo cuando el arma no ha sido identificada en el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_arma',
    @level2type = N'COLUMN', @level2name = N'id_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Detalle de especie tipo droga. v2.0: id_droga FK a catálogo normalizado.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la especie, compartido con evidencia.especie. PK y FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la sustancia según la identificación en terreno o análisis inicial, antes de confirmación pericial.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'sustancia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Peso bruto de la sustancia incautada en gramos, incluyendo envase. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'peso_bruto_gr';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Peso neto de la sustancia sin envase, confirmado por análisis pericial. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'peso_neto_gr';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Porcentaje de pureza de la sustancia determinado por análisis toxicológico. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'pureza_porcentaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la composición química de la sustancia cuando el análisis pericial identifica componentes múltiples. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'composicion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al número de informe toxicológico que confirma la composición y pureza de la sustancia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'informe_toxicologico_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación o descripción del nivel de peligrosidad de la sustancia para su manejo y almacenamiento. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'peligrosidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = registro orientativo basado en prueba instrumental de campo (Fourier/Infrarrojo). S8/RN22.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'es_orientativo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resultado prueba Fourier/Infrarrojo de campo. Solo aplica si es_orientativo = 1. S8/RN22.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_droga',
    @level2type = N'COLUMN', @level2name = N'resultado_instrumental';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Detalle de especie tipo vehículo. id_vehiculo FK opcional a vehiculos.vehiculo cuando el vehículo está identificado.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la especie, compartido con evidencia.especie. PK y FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Placa Patente Única (PPU) del vehículo incautado. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'patente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registro único del vehículo en el sistema cuando está identificado. FK a vehiculos.vehiculo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'id_vehiculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca del vehículo, registrada en texto libre cuando no está vinculado a vehiculos.vehiculo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'marca';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Modelo del vehículo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Año de fabricación del vehículo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'anio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Color del vehículo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'color';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de motor del vehículo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'numero_motor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de chasis del vehículo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_vehiculo',
    @level2type = N'COLUMN', @level2name = N'numero_chasis';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Detalle de especie tipo electrónico (celular, computador) con IMEI y número de serie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la especie, compartido con evidencia.especie. PK y FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de dispositivo electrónico. Ej: celular, computador, tableta, pendrive, disco duro, GPS.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'tipo_dispositivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Marca del dispositivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'marca';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Modelo del dispositivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de serie del dispositivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'numero_serie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número IMEI del dispositivo móvil. Identificador único internacional del equipo. Campo opcional — aplica a celulares y tabletas con conectividad móvil.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'imei';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Dirección MAC del dispositivo. Campo opcional — aplica a dispositivos con conectividad de red.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'mac_address';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Capacidad de almacenamiento del dispositivo. Ej: 128 GB, 1 TB. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_electronico',
    @level2type = N'COLUMN', @level2name = N'capacidad_almacenamiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'APPEND-ONLY. Registro de cada transferencia de custodia de la especie. Estado BODEGA_TRANSITORIA incluido.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del eslabón de cadena de custodia. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_cadena';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie cuya custodia se transfiere. FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número correlativo del eslabón dentro de la cadena de custodia de la especie. Permite visualizar la secuencia completa de traspasos. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'numero_eslabon';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Institución que entrega la custodia. FK a evidencia.cat_institucion.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_institucion_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre completo del funcionario que entrega la custodia. Se registra como texto libre para soportar funcionarios de instituciones externas sin registro en el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'nombre_funcionario_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'RUN del funcionario que entrega la custodia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'run_funcionario_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'FK al registro de funcionario PDI que entrega cuando pertenece a la institución. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_pdi_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Institución que recibe la custodia. FK a evidencia.cat_institucion.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_institucion_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre completo del funcionario que recibe la custodia.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'nombre_funcionario_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'RUN del funcionario que recibe la custodia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'run_funcionario_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'FK al registro de funcionario PDI que recibe cuando pertenece a la institución. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_pdi_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Propósito del traspaso de custodia. FK a evidencia.cat_proposito_transferencia. Ej: PERITAJE, TRASLADO_BODEGA, ENTREGA_TRIBUNAL, DESTRUCCION.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_proposito';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del lugar físico de destino de la especie. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'ubicacion_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del estado físico de la especie al momento del traspaso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'condicion_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el sello de la especie se encontraba intacto al momento del traspaso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'sello_intacto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número del sello de seguridad aplicado a la especie al momento del traspaso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'sello_numero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia a la firma o constancia del traspaso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'firma_referencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC del traspaso de custodia. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'fecha_transferencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre el traspaso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Declaración de quien entrega la evidencia en el eslabón de custodia. S4/RN12.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'declaracion_entregante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de bodega de almacenamiento. Campo libre hasta definir catálogo de bodegas. S6/RN08.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'id_bodega';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado custodia. Valores: EN_TRANSITO / SALA_CUSTODIA / BODEGA / SECCION_TECNICA / ENTREGADA. S6/RN08.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cadena_custodia',
    @level2type = N'COLUMN', @level2name = N'estado_custodia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'APPEND-ONLY. Registro de sellos aplicados a la especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de sello. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'id_sello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie a la que se aplica o retira el sello. FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Acción realizada sobre el sello. Valores: APLICADO, RETIRADO, VERIFICADO.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'accion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número identificador del sello de seguridad.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'numero_sello';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Institución bajo cuya responsabilidad se realiza la acción sobre el sello. FK a evidencia.cat_institucion.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'id_institucion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre completo del funcionario que realiza la acción sobre el sello.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'nombre_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'RUN del funcionario que realiza la acción. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'run_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'FK al registro de funcionario PDI cuando pertenece a la institución. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_pdi';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Justificación de la acción sobre el sello. Obligatorio en retiro de sello.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'motivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la acción sobre el sello. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_sello',
    @level2type = N'COLUMN', @level2name = N'fecha_accion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'APPEND-ONLY. Historial de cambios de estado de la especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de cambio de estado. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_historial';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie cuyo estado cambió. FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado previo de la especie. FK a evidencia.cat_estado_especie. Nulo en el primer registro de estado.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_estado_anterior';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nuevo estado de la especie. FK a evidencia.cat_estado_especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_estado_nuevo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que realizó el cambio de estado. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_cambio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Justificación del cambio de estado. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'motivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC del cambio de estado. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_historial_estado',
    @level2type = N'COLUMN', @level2name = N'fecha_cambio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registro de retenciones temporales de especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del registro de retención. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion',
    @level2type = N'COLUMN', @level2name = N'id_retencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Especie retenida. FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del motivo que origina la retención temporal de la especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion',
    @level2type = N'COLUMN', @level2name = N'motivo_retencion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha hasta la que se extiende la retención. Nulo si la retención es indefinida hasta nueva resolución.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion',
    @level2type = N'COLUMN', @level2name = N'fecha_retencion_hasta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Norma, resolución o instrucción que fundamenta la retención. Ej: Art. 187 CPP, Instrucción Fiscal N° 123/2026.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion',
    @level2type = N'COLUMN', @level2name = N'base_legal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_retencion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificaciones normativas de arma: Convencional, Hechiza, Fogueo, Fantasía. Fuente: S8/S10.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_clasificacion_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo homologado de armas de fuego. Autocompletar desde DGMN por N° serie. Fuente: S10.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_catalogo_armas';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo normativo de sustancias controladas. Fuente: S8/RN03.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'cat_droga';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Evento formal de decomiso. Genera acta. Asociada al sitio del suceso. Fuente: S8.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del evento de incautación. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_incautacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso en el que se produce la incautación. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Diligencia en cuyo marco se realiza la incautación. FK a diligencias.diligencia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_diligencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Lugar donde se realizó la incautación, típicamente el sitio del suceso. FK a ubicacion.lugar. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_lugar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que se realizó la incautación. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'fecha_incautacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI responsable del procedimiento de incautación. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_responsable';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que materializó físicamente la incautación. FK a organizacion.funcionario. Campo opcional — puede diferir del responsable.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_incautacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si fue generada el acta formal de incautación. Valor 1 = acta generada.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'acta_generada';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número del acta de incautación generada. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'numero_acta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre el evento de incautación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Región donde ocurrió la incautación. Puede diferir de la región de la unidad. S10/RN13.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'incautacion',
    @level2type = N'COLUMN', @level2name = N'id_region_incautacion';
GO


-- ----- Descripciones: migracion -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de infracciones a la Ley de Extranjería con base legal. Fuente: S7/PO02.02.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de infracción migratoria. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_tipo_infraccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado de la infracción migratoria. Ej: ING_IREG, PERM_VEN, COND_IMP.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la infracción migratoria. Ej: Ingreso irregular al territorio nacional, Permanencia con permiso vencido.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del supuesto de hecho que configura la infracción migratoria. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Artículo y cuerpo legal de la Ley de Extranjería que tipifica la infracción. Ej: Art. 68 Ley 21.325. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria',
    @level2type = N'COLUMN', @level2name = N'base_legal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la infracción está vigente en el catálogo. Valor 1 = vigente.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_infraccion_migratoria',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denuncia por infracción Ley de Extranjería. Envío SERMIG obligatorio. sermig_ref. Fuente: S7/RN01-02.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la denuncia migratoria. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_denuncia_mig';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio único de la denuncia migratoria generado por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'folio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona extranjera a la que se imputa la infracción migratoria. FK a personas.persona. Soporta personas con identificación temporal en caso de extranjeros en situación irregular (S7 — RN08 y RN28).',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de infracción a la Ley de Extranjería. FK a migracion.cat_tipo_infraccion_migratoria. S7 — RN04 establece que una denuncia puede registrar múltiples infracciones seleccionadas desde el catálogo.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_tipo_infraccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción narrativa de los hechos constitutivos de la infracción migratoria. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'descripcion_infraccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la denuncia fue generada sin la presencia física del extranjero infractor. Valor 1 = generada en ausencia. S7 — RN03 y RN17.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'generada_en_ausencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado de la denuncia migratoria en su ciclo administrativo. Valores esperados: REGISTRADA, ENVIADA_SERMIG, PROCESADA, CERRADA. Valor por defecto: REGISTRADA.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que la denuncia fue enviada al SERMIG. S7 — RN02 establece que el envío es obligatorio. Campo opcional hasta completar el envío.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'fecha_envio_sermig';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia o número de seguimiento asignado por el SERMIG al recibir la denuncia. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'sermig_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que registró la denuncia. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_funcionario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad PDI que registró la denuncia. FK a organizacion.unidad. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la denuncia migratoria. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora salida física del extranjero en frontera o aeropuerto. Cierra el seguimiento. S7/RN26.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'fecha_salida_fisica';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fiscalización planificada que originó esta DAM. FK a fiscalizacion_planificada. Campo opcional. S7/RN06.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'denuncia_administrativa_migratoria',
    @level2type = N'COLUMN', @level2name = N'id_fiscalizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Proceso de expulsión migratoria. JUDICIAL: prohibición 10 años. ADMINISTRATIVA: prohibición 25 años. S7/RN09-13.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'expulsion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fiscalizaciones planificadas como actividades organizadas. Una fiscalización puede generar múltiples DAMs. S7/RN05/06.',
    @level0type = N'SCHEMA', @level0name = N'migracion',
    @level1type = N'TABLE',  @level1name = N'fiscalizacion_planificada';
GO


-- ----- Descripciones: cooperacion_int -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo maestro de tipos de registro INTERPOL no mutable. Clasifica los valores de cat_elemento_cooperacion_internacional. Ej: Motivo de búsqueda, Calidad persona, Delito, Medio de solicitud. IDs fijos (sin IDENTITY). Fuente: interpol_tables_v1_1.sql · S5.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de registro INTERPOL. Clave primaria. Valor fijo asignado por seed (sin IDENTITY).',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'id_cat_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código inmutable del tipo de registro. Único. Ej: CALIDAD_PERSONA, MOTIVO_BUSQUEDA, MEDIO_SOLICITUD, TIPO_CONSULTA.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tipo de registro. Ej: Motivo de búsqueda, Calidad persona, Delito, Medio de solicitud.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de registro INTERPOL.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de valores del dominio INTERPOL clasificados por tipo. Contiene valores para calidad de persona, motivos de búsqueda, medios y tipos de consulta. Relacionado a cat_cooperacion_internacional por id_cat_cooperacion_internacional. Fuente: interpol_tables_v1_1.sql · S5.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del elemento del catálogo INTERPOL. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'id_cat_elemento_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del valor del catálogo. Ej: Robo de vehículo, Detenido, Carta formal, Consulta antecedentes.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de registro al que pertenece este elemento. FK a cooperacion_int.cat_cooperacion_internacional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'id_cat_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el elemento está activo. 1 = activo · 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica. NULL = registro activo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'cat_elemento_cooperacion_internacional',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de estados de la solicitud INTERPOL. Formaliza como catálogo el campo estado VARCHAR de v2.2. Ej: Pendiente, Trabajada, Cerrada, Rechazada. Fuente: S5 · RN04.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'estado_solicitud_interpol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del estado de solicitud. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'estado_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_estado_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del estado. Único. Ej: Pendiente, Trabajada, Cerrada, Rechazada.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'estado_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el estado está activo. 1 = activo · 0 = inactivo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'estado_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'estado_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica. NULL = registro activo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'estado_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidades asociadas a INTERPOL que pueden enviar o recibir solicitudes. Flag es_pdi distingue entidades PDI de entidades extranjeras. El país asociado se registra a nivel de solicitud (id_pais_emisor / id_pais_receptor). Fuente: S5 · RN06 · interpol_tables_v1_1.sql.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la entidad INTERPOL. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol',
    @level2type = N'COLUMN', @level2name = N'id_entidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la entidad INTERPOL. Ej: OCN Santiago, FBI, Europol.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la entidad pertenece a la PDI. 1 = entidad PDI · 0 = entidad extranjera.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol',
    @level2type = N'COLUMN', @level2name = N'es_pdi';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la entidad está activa. 1 = activa · 0 = inactiva.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica. NULL = registro activo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'entidad_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registro central de solicitudes de cooperación INTERPOL. Reemplaza cardex_interpol de v2.2. numero_endoso único por año (RN03 S5). Incluye entidades, calidad de persona, medio, huella dactilar y referencia al sistema SIP. Fuente: interpol_tables_v1_1.sql · S5 · RN01-RN15.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la solicitud INTERPOL. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número correlativo de endoso. Único por año junto con anio. RN03 S5.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'numero_endoso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Año al que pertenece el numero_endoso. Forma clave única compuesta con numero_endoso.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'anio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Persona sobre la cual se realiza la solicitud. FK a personas.persona.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Rol o estado de la persona en la solicitud. FK a cat_elemento_cooperacion_internacional (tipo: Calidad persona). Ej: Detenido, Prófugo, Desaparecido.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_calidad_persona';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado actual de la solicitud. FK a cooperacion_int.estado_solicitud_interpol.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_estado_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Medio por el que se recibió la solicitud. FK a cat_elemento_cooperacion_internacional (tipo: Medio solicitud). Ej: Carta formal, Fax, Correo electrónico.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_medio_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad INTERPOL que origina la solicitud. FK a cooperacion_int.entidad_interpol.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_entidad_solicitante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Entidad INTERPOL que recibe la solicitud. FK a cooperacion_int.entidad_interpol.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_entidad_receptora';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País de origen de la solicitud. FK a ubicacion.pais.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_pais_emisor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País receptor de la solicitud. FK a ubicacion.pais.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_pais_receptor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre libre de la entidad solicitante cuando no está en el catálogo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'entidad_solicitante_otro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre libre de la entidad receptora cuando no está en el catálogo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'entidad_receptora_otro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Observaciones generales de la solicitud. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que endosa la solicitud. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_endosador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora en que se comenzó a trabajar la solicitud luego de ser recibida.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_endoso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la persona tiene huella dactilar registrada. 1 = sí · 0 = no.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'tiene_huella_dactilar';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al registro correspondiente en el sistema SIP. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'sip_ref';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso investigativo asociado a la solicitud. FK a casos.caso. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de última modificación del registro. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_modificacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de cierre formal de la solicitud. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_cierre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que cerró la solicitud. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_cierra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica. NULL = solicitud activa.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario PDI que registró la solicitud en el sistema. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = solicitud extranjera, origen no editable en el sistema. S5/RN05.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'bloquear_edicion_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de documento de referencia asociado a la solicitud Interpol. S5/RN07.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_tipo_documento_referencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Restricción legal almacenamiento Interpol. Valores: NORMAL / RESTRINGIDO. S5/RN13.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'nivel_restriccion_interpol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clase de solicitud que se realiza en una solicitud INTERPOL. Permite múltiples tipos por solicitud. Ej: consulta de antecedentes, difundir fotografía, solicitar detención. Fuente: S5 · interpol_tables_v1_1.sql.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'tipo_consulta_solicitud_interpol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de consulta de la solicitud. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'tipo_consulta_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_tipo_consulta_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Solicitud INTERPOL a la que pertenece el tipo de consulta. FK a cooperacion_int.solicitud_interpol.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'tipo_consulta_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de consulta. FK a cooperacion_int.cat_elemento_cooperacion_internacional (tipo: Tipo consulta).',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'tipo_consulta_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_cat_elemento_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'tipo_consulta_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica. NULL = registro activo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'tipo_consulta_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Motivos por los que la persona está siendo investigada en una solicitud INTERPOL. Permite múltiples motivos por solicitud. Ej: terrorismo, robo, tráfico de drogas. Fuente: S5 · interpol_tables_v1_1.sql.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'motivo_solicitud_interpol';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del motivo de la solicitud. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'motivo_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_motivo_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Solicitud INTERPOL a la que pertenece el motivo. FK a cooperacion_int.solicitud_interpol.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'motivo_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_solicitud';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Motivo de búsqueda. FK a cooperacion_int.cat_elemento_cooperacion_internacional (tipo: Motivo búsqueda). Ej: terrorismo, robo, tráfico de drogas.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'motivo_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'id_cat_elemento_cooperacion_internacional';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'motivo_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de eliminación lógica. NULL = registro activo.',
    @level0type = N'SCHEMA', @level0name = N'cooperacion_int',
    @level1type = N'TABLE',  @level1name = N'motivo_solicitud_interpol',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO


-- ----- Descripciones: analitica -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de tipos de reporte analítico OFAN: Analítico, BRIMINREL, Estadístico, Foco.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de reporte. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_reporte',
    @level2type = N'COLUMN', @level2name = N'id_tipo_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código abreviado del tipo de reporte. Ej: ANA, BRIMINREL, EST, FOCO.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_reporte',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tipo de reporte analítico.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_reporte',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del propósito y contenido del tipo de reporte. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_reporte',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el tipo de reporte está vigente. Valor 1 = activo.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'cat_tipo_reporte',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Producto analítico OFAN con correlativo anual único. Flujo de aprobación con motivo de rechazo. Fuente: S11.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del reporte analítico. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'id_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Folio único del reporte generado por el sistema. Incluye el correlativo anual y el año.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'folio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número correlativo del reporte dentro del año. Se reinicia en 1 cada año calendario. S11 — RN05.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'correlativo_anual';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Año al que corresponde el correlativo.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'anio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de reporte analítico. FK a analitica.cat_tipo_reporte. Ej: ANALÍTICO, BRIMINREL, ESTADÍSTICO, FOCO.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'id_tipo_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Analista que elaboró el reporte. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_autor';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad OFAN responsable del reporte. FK a organizacion.unidad.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del reporte en su ciclo de elaboración y aprobación. Valores: BORRADOR, EN_REVISION, APROBADO, RECHAZADO, ENVIADO. Valor por defecto: BORRADOR.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado interno de la revisión cuando el reporte está en proceso de visación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'estado_revision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Motivo por el que jefatura rechazó el reporte y lo devolvió al analista para correcciones. Campo opcional — nulo cuando no ha sido rechazado.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'motivo_rechazo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de inicio de elaboración del reporte. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'fecha_elaboracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de aprobación del reporte por jefatura. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'fecha_aprobacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC en que el reporte fue enviado al destinatario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'fecha_envio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre o descripción del destinatario del reporte. S11 — RN12 establece que el sistema diferencia entre destinatarios investigativos y administrativos. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'destinatario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Archivo PDF del reporte finalizado. FK a archivos.archivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'id_archivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario de jefatura que aprobó el reporte. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_aprueba';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción metodológica del análisis. Obligatoria cuando el reporte incluye patrones criminales. S11/RN03.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'metodologia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'RUCs sugeridos para agrupación formal de causas vinculadas. S11/RN10.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'sugerencia_agrupacion_rucs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo destinatario. INVESTIGATIVO = detalle táctico · ADMINISTRATIVO = gestión jefatura. S11/RN12.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico',
    @level2type = N'COLUMN', @level2name = N'tipo_destinatario';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación reporte analítico-casos. Fuente: S11.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo reporte-caso. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico_caso',
    @level2type = N'COLUMN', @level2name = N'id_reporte_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Reporte analítico que referencia el caso. FK a analitica.reporte_analitico.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico_caso',
    @level2type = N'COLUMN', @level2name = N'id_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso analizado o referenciado en el reporte. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico_caso',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de relación entre el reporte y el caso. Ej: CASO_PRINCIPAL, CASO_REFERENCIADO, CASO_COMPARATIVO. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico_caso',
    @level2type = N'COLUMN', @level2name = N'tipo_vinculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del vínculo. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'reporte_analitico_caso',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Agrupación de casos con patrones comunes. Propone foco al MP. Fuente: S11.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del foco investigativo. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'id_foco';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del foco investigativo asignado por el analista.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de los patrones criminales comunes que fundamentan el foco y los casos involucrados. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado del foco investigativo. Valores: EN_EVALUACION, APROBADO, PROPUESTO_MP, ACTIVO, CERRADO. Valor por defecto: EN_EVALUACION.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'estado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Analista que creó el foco investigativo. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_creador';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unidad OFAN responsable del foco. FK a organizacion.unidad.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'id_unidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Reporte analítico que originó la identificación del foco. FK a analitica.reporte_analitico. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'id_reporte_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del foco. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de aprobación del foco por jefatura. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'fecha_aprobacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de cierre del foco investigativo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'fecha_cierre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre el foco investigativo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_investigativo',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relación foco investigativo-casos. Fuente: S11.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo foco-caso. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'id_foco_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foco investigativo al que se incorpora el caso. FK a analitica.foco_investigativo.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'id_foco';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Caso incorporado al foco investigativo. FK a casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'id_caso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el caso principal o de referencia del foco. Valor 1 = caso principal.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'es_caso_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de incorporación del caso al foco. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'fecha_vinculacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del patrón o criterio por el que el caso fue incorporado al foco. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'motivo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Analista que registró la incorporación del caso al foco. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'foco_caso',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Vínculos entre entidades para análisis de redes criminales I2. Fuente: S11.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del vínculo entre entidades. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'id_vinculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de entidad que origina el vínculo. Corresponde al nombre de la tabla del sistema. Ej: personas.persona, vehiculos.vehiculo, casos.caso.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'tipo_entidad_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la entidad origen dentro de su tabla.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'id_entidad_origen';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de entidad de destino del vínculo. Corresponde al nombre de la tabla del sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'tipo_entidad_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la entidad destino dentro de su tabla.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'id_entidad_destino';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del tipo de relación entre las entidades. Ej: COMUNICA_CON, PROPIETARIO_DE, ASOCIADO_A, CÓMPLICE_EN, VINCULADO_FINANCIERAMENTE.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'tipo_vinculo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción analítica del vínculo y su relevancia en la investigación. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Reporte analítico en cuyo contexto fue identificado el vínculo. FK a analitica.reporte_analitico. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'id_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Analista que registró el vínculo. FK a organizacion.funcionario.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica del vínculo (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'vinculo_entidad',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estructura de análisis de información asociada a reporte. Distinta de casos.matriz_riesgo. Fuente: S11.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la matriz de análisis. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'id_matriz_analisis';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Reporte analítico al que pertenece esta matriz. FK a analitica.reporte_analitico.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'id_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del objetivo y alcance del análisis realizado.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de las fuentes de datos, entidades y períodos analizados. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'datos_analizados';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción de la metodología analítica aplicada, incluyendo las aplicaciones utilizadas durante el proceso. Ej: análisis de redes I2, análisis geoespacial, análisis temporal. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'metodologia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Analista que registró la matriz. FK a organizacion.funcionario. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_registra';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'matriz_analisis',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Destinatarios y frecuencias de reportes estadísticos periódicos PO04.03.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la configuración. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'id_configuracion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre descriptivo del reporte periódico configurado.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo de reporte asociado a esta configuración. FK a analitica.cat_tipo_reporte.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'id_tipo_reporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Frecuencia de generación del reporte. Valores esperados: DIARIA, SEMANAL, MENSUAL, TRIMESTRAL, ANUAL.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'frecuencia';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del destinatario externo al que se envía el reporte. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'destinatario_externo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del organismo receptor del reporte periódico. Ej: Ministerio del Interior, Subsecretaría de Prevención del Delito. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'organismo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Formato en que se genera el reporte. Valores: PDF, XLSX, CSV. Valor por defecto: PDF. S11 — RN11 establece que los informes estadísticos deben poder exportarse como snapshot en PDF.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'formato_salida';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si la configuración está activa y generará reportes periódicos. Valor 1 = activo.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'activo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la configuración del reporte periódico. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación de la configuración. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'configuracion_reporte_periodico',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Aplicaciones utilizadas en la elaboración del reporte analítico. Ej: i2, BRAIN, Excel. S11/RN06.',
    @level0type = N'SCHEMA', @level0name = N'analitica',
    @level1type = N'TABLE',  @level1name = N'aplicacion_reporte';
GO


-- ----- Descripciones: investigacion -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de formas de contacto/abordaje en el modus operandi. Atributo del hecho criminal capturado en pantalla PNTW02.01 sección 1 - Relato de los hechos. Diccionario tooltip estandarizado para evitar interpretaciones subjetivas. Fuente: NotebookLM, sesiones Discovery PDI.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la forma de contacto. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'id_forma_contacto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código corto del valor. Ej: INTIMIDACION, ENGANIO, ACERCAMIENTO_FISICO, VIA_DIGITAL, DISTRACCION.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre visible del valor. Ej: Intimidación, Engaño, Acercamiento físico, Vía digital, Distracción.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tooltip explicativo del concepto para diccionario de Modus Operandi. Permite distinguir conceptos similares y estandarizar criterios entre investigadores.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el valor está activo en el catálogo. Valor 1 = vigente. Los valores desactivados se preservan para trazabilidad de hechos históricos.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_forma_contacto',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de puntos de acceso utilizados por el imputado en el modus operandi. Atributo del hecho criminal capturado en pantalla PNTW02.01 sección 1 - Relato de los hechos. Fuente: NotebookLM, sesiones Discovery PDI.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del punto de acceso. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'id_punto_acceso';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código corto del valor. Ej: PUERTA_PRINCIPAL, VENTANA, PATIO_TRASERO, FORZADO, VIA_PUBLICA.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre visible del valor. Ej: Puerta principal, Ventana, Patio trasero, Forzado, Sin acceso (vía pública).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tooltip explicativo del concepto para diccionario de Modus Operandi.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el valor está activo en el catálogo. Valor 1 = vigente.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_punto_acceso',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de transporte utilizado en el modus operandi. Atributo del hecho criminal capturado en pantalla PNTW02.01 sección 1 - Relato de los hechos. Fuente: NotebookLM, sesiones Discovery PDI.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del transporte. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'id_transporte';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código corto del valor. Ej: A_PIE, AUTO, MOTO, BICICLETA, TRANSPORTE_PUBLICO, CAMION.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre visible del valor. Ej: A pie, Auto, Moto, Bicicleta, Transporte público, Camión.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tooltip explicativo del concepto para diccionario de Modus Operandi.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el valor está activo en el catálogo. Valor 1 = vigente.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_transporte_utilizado',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Catálogo de móviles para clasificación analítica del delito imputado. Atributo del delito tipificado a un imputado en un caso/hecho. Fuentes: glosarios BIPE (secuestros) y Brigada de Homicidios (homicidios). Aplica especialmente a delitos contra las personas que requieren clasificación parametrizada del móvil. Fuente: NotebookLM.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del móvil. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'id_movil';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código corto del valor. Ej: PASIONAL, AJUSTE_CUENTAS, VIF, CRIMEN_ODIO, EXTORSIVO, EXPRES, FAMILIAR, DOMESTICO.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'codigo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre visible del móvil. Homicidios: Pasional, Ajuste de cuentas, VIF, Crimen de odio. Secuestros: Extorsivo, Exprés, Familiar, Doméstico, Otros fines.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'nombre';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tooltip explicativo del móvil para diccionario de especialidad. Permite estandarizar el criterio entre investigadores.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este móvil aplica a clasificación de homicidios (Brigada de Homicidios). Valor 1 = sí. Permite filtrar el dropdown de móvil según tipo de delito imputado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'aplica_homicidio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este móvil aplica a clasificación de secuestros (BIPE). Valor 1 = sí. Permite filtrar el dropdown de móvil según tipo de delito imputado.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'aplica_secuestro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el móvil está activo en el catálogo. Valor 1 = vigente.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'vigente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'cat_movil',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Asociación M:N entre hechos y fenómenos delictuales. v3.1 v1: el fenómeno se asigna al hecho criminal (no a la denuncia), reflejando que el fenómeno describe la mecánica del hecho. Permite que un hecho sea clasificado bajo múltiples fenómenos sugeridos por el analista, con uno marcado como principal. Capturado en pantalla PNTW02.01 sección 3 - Fenómeno delictual asociado (botón Agregar fenómeno repetible). Fuente: NotebookLM.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la asociación hecho-fenómeno. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'id_hecho_fenomeno';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Hecho criminal al que se asocia el fenómeno. FK a investigacion.hecho.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'id_hecho';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fenómeno delictual del catálogo MP asociado al hecho. FK cruzada a denuncias.fenomeno_delictual. El catálogo es definido por el Ministerio Público y aplicado por la PDI.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'id_fenomeno';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si este es el fenómeno principal entre los asociados al hecho. Valor 1 = principal. Solo uno puede marcarse como principal por hecho (lógica de aplicación). Usado para reportería y conexión de casos por fenómeno principal.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'es_principal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de asignación del fenómeno al hecho. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'fecha_asignacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Funcionario que asignó el fenómeno al hecho. FK cruzada a organizacion.funcionario. Campo opcional. Permite trazabilidad del análisis criminal.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'id_funcionario_asigna';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Justificación del analista para la asignación del fenómeno. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha de baja lógica de la asignación (soft-delete).',
    @level0type = N'SCHEMA', @level0name = N'investigacion',
    @level1type = N'TABLE',  @level1name = N'hecho_fenomeno',
    @level2type = N'COLUMN', @level2name = N'fecha_eliminacion';
GO


-- ----- Descripciones: evidencias -----

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del arma en el sistema. Clave primaria generada por el sistema.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'id_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Número de serie del arma gravado por el fabricante. Identificador físico principal. Campo opcional — puede ser desconocido o estar borrado.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'numero_serie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de registro del arma en la Dirección General de Movilización Nacional (DGMN). Permite verificar inscripción y propietario legal. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'codigo_dgmn';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Referencia al catálogo homologado de armas de fuego. FK a evidencia.cat_catalogo_armas. Permite autocompletar atributos desde el catálogo DGMN mediante número de serie (S10). Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'id_catalogo_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Clasificación normativa del arma. FK a evidencia.cat_clasificacion_arma. Ej: Convencional, Hechiza, Fogueo, Fantasía.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'id_clasificacion_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indica si el arma está inscrita en el registro de la DGMN. Valor 1 = inscrita. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'inscrita';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País de fabricación del arma. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'pais_fabricante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado físico de conservación del arma. Ej: bueno, regular, deteriorado, inutilizable. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'estado_conservacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre el arma. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de creación del registro. Valor por defecto: SYSUTCDATETIME().',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'fecha_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fecha y hora UTC de la última modificación.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Origen recuperación. Valores: ALLANAMIENTO / INCAUTACION / HALLAZGO / ENTREGA_VOLUNTARIA. S10/RN06.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'origen_recuperacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Estado legal DGMN. Valores: INSCRITA / ROBADA / PERDIDA / NO_INSCRITA / DESCONOCIDO. S10/RN07.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'estado_legal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = arma solo mencionada en denuncia sin NUE · 0 = evidencia física con NUE. S10/RN09.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'es_mencionada';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Familia oficial. Valores: CONVENCIONAL / FOGUEO / HECHIZA_ARTESANAL / FANTASIA. S10/RN15.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'familia_arma';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'1 = arma con capacidad real de disparo. 0 = juguete u objeto no funcional. S10/RN16.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'tiene_capacidad_disparo_real';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Fuente datos. Valores: OFICIAL / PERITO / MANUAL. Perito prevalece sobre oficial. S10/RN17.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'fuente_datos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Tipo registro. EVIDENCIA = con NUE (física) · MENCIONADA = sin NUE (solo referenciada). S10/RN20.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'tipo_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'MUNDO1 = denuncia/mencionada · MUNDO2 = investigación/evidencia. S10/RN21.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'arma',
    @level2type = N'COLUMN', @level2name = N'mundo_registro';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador de la especie, compartido con evidencia.especie. PK y FK a evidencia.especie.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'id_especie';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Categoría genérica de la especie. Valores orientativos: DOCUMENTO, DINERO, JOYA, OTRO. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'categoria';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción detallada de la especie con todas sus características relevantes. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'descripcion_detallada';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Denominación específica de la especie. Ej: moneda, billete, tipo de documento, tipo de joya. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'denominacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Valor nominal de la especie en la moneda indicada. Aplica principalmente a dinero en efectivo. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'valor_nominal';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de moneda ISO 4217 del valor nominal. Ej: CLP, USD, EUR. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'moneda';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Antecedentes adicionales sobre la especie. Campo opcional.',
    @level0type = N'SCHEMA', @level0name = N'evidencias',
    @level1type = N'TABLE',  @level1name = N'especie_otras',
    @level2type = N'COLUMN', @level2name = N'observaciones';
GO


-- =============================================================================
-- FIN — SIP v4.0 v1 (modelo completo)
-- =============================================================================
-- Validación recomendada (después de ejecutar el script en SQL Server 2017):
--   SELECT COUNT(*) FROM sys.schemas WHERE schema_id > 4 AND name <> 'dbo';
--                                                              -- esperado: 16
--   SELECT COUNT(*) FROM sys.tables;                           -- esperado: 206
--   SELECT COUNT(*) FROM sys.foreign_keys;                     -- esperado: 375
--   SELECT COUNT(*) FROM sys.indexes WHERE is_unique = 1
--          AND has_filter = 1;                                 -- esperado: 18
--   SELECT COUNT(*) FROM sys.indexes WHERE is_primary_key = 0
--          AND is_unique_constraint = 0
--          AND type_desc = 'NONCLUSTERED';                     -- esperado: 82
--   SELECT COUNT(*) FROM sys.extended_properties
--          WHERE name = 'MS_Description';                      -- esperado: 1426
-- =============================================================================
