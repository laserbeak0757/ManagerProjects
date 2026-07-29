-- =============================================================================
-- SIP — Migration V0002__nuevo_esquema_auth
-- =============================================================================
-- Versión:      4.0 v2 (incremental sobre V0001__baseline_sip)
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql (esquema organizacion.funcionario)
--
-- ALCANCE:
--   Crea el esquema `auth` con el modelo de identidad, sesiones (refresh
--   tokens), RBAC (roles, perfiles, permisos, niveles de seguridad) y
--   configuración global del sistema de autenticación (auth.parametro).
--
-- FLUJO DE AUTENTICACIÓN/AUTORIZACIÓN:
--   1. Sistema externo entrega: numero_identificacion + token JWT
--   2. SIP busca en personas.persona por número de identificación
--      → obtiene id_persona
--   3. SIP busca en organizacion.funcionario por id_persona
--      → obtiene id_funcionario
--   4. SIP busca en auth.usuario por id_funcionario
--      → obtiene id_usuario y sus perfiles/roles/permisos efectivos
--
-- CONVENCIONES (heredadas del baseline V0001):
--   - PKs nombradas id_<tabla> con IDENTITY(1,1)
--   - Naming de constraints en lowercase (pk_, fk_, uq_, ix_, ck_, ux_)
--   - Tipos: NVARCHAR para texto con posibles caracteres especiales (nombres,
--     descripciones, emails); VARCHAR para identificadores técnicos ASCII
--     (siglas, códigos, hashes, IPs, identificadores AD)
--   - Booleans como SMALLINT + CONSTRAINT ck_<tabla>_<col> CHECK (col IN (0,1))
--   - Timestamps en UTC con DEFAULT SYSUTCDATETIME()
--
-- ESTRUCTURA DEL ARCHIVO:
--   PASO 1 — Esquema
--   PASO 2 — Tablas (sólo CREATE TABLE con PK, UQ, CK; sin FKs)
--   PASO 3 — Índices
--   PASO 4 — Foreign keys internas (intra-esquema auth)
--   PASO 5 — Foreign keys cruzadas (a otros esquemas)
--   PASO 6 — Descripciones (sys.sp_addextendedproperty idempotente)
--
-- DECISIONES PENDIENTES:
--   - auth.perfil.id_usuario_auditoria: presente en el modelo recibido,
--     se mantiene como vino. Su FK NO se declara hasta que se confirme su
--     semántica.
--   - Auditoría general (creado_por/creado_en/modificado_por/modificado_en):
--     no se aplica en esta migration; pendiente para migration transversal.
-- =============================================================================
SET ANSI_NULLS ON;
GO
SET ANSI_WARNINGS ON;
GO
SET ANSI_PADDING ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET CONCAT_NULL_YIELDS_NULL ON;
GO


-- =============================================================================
-- PASO 1 — ESQUEMA
-- =============================================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'auth')
    EXEC('CREATE SCHEMA [auth]');
GO


-- =============================================================================
-- PASO 2 — TABLAS
-- =============================================================================
-- Cada CREATE TABLE incluye sólo la PK, UNIQUE constraints y CHECK constraints.
-- Las FKs (internas y cruzadas) se declaran en pasos posteriores como ALTER
-- TABLE para mantener separadas las preocupaciones.
-- =============================================================================

-- Tabla: auth.usuario
CREATE TABLE [auth].[usuario] (
    id_usuario              INTEGER          IDENTITY(1,1) NOT NULL,
    id_funcionario          INTEGER          NOT NULL,
    username                VARCHAR(100)     NOT NULL,
    activo                  SMALLINT         NOT NULL DEFAULT 1
        CONSTRAINT ck_usuario_activo CHECK (activo IN (0,1)),
    fecha_creacion          DATETIME2(0)     NOT NULL DEFAULT SYSUTCDATETIME(),
    auth_provider           VARCHAR(16)      NOT NULL DEFAULT 'AD'
        CONSTRAINT ck_usuario_auth_provider CHECK (auth_provider IN ('AD','EXTERNO','LOCAL')),
    nombre_mostrar          NVARCHAR(200)    NULL,
    email                   NVARCHAR(256)    NULL,
    dominio                 VARCHAR(64)      NULL,
    upn                     VARCHAR(256)     NULL,
    ad_sid                  VARCHAR(128)     NULL,
    fecha_ultimo_acceso     DATETIME2(0)     NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_username UNIQUE (username),
    CONSTRAINT uq_usuario_funcionario UNIQUE (id_funcionario)
);
GO


-- Tabla: auth.perfil
CREATE TABLE [auth].[perfil] (
    id_perfil               INTEGER          IDENTITY(1,1) NOT NULL,
    id_usuario_auditoria    INTEGER          NULL,
    nombre                  NVARCHAR(100)    NOT NULL,
    sigla                   VARCHAR(10)      NOT NULL,
    descripcion             NVARCHAR(500)    NULL,
    CONSTRAINT pk_perfil PRIMARY KEY (id_perfil),
    CONSTRAINT uq_perfil_nombre UNIQUE (nombre),
    CONSTRAINT uq_perfil_sigla UNIQUE (sigla)
);
GO


-- Tabla: auth.rol
CREATE TABLE [auth].[rol] (
    id_rol                  INTEGER          IDENTITY(1,1) NOT NULL,
    nombre                  NVARCHAR(100)    NOT NULL,
    sigla                   VARCHAR(10)      NOT NULL,
    CONSTRAINT pk_rol PRIMARY KEY (id_rol),
    CONSTRAINT uq_rol_nombre UNIQUE (nombre),
    CONSTRAINT uq_rol_sigla UNIQUE (sigla)
);
GO


-- Tabla: auth.nivel_seguridad
CREATE TABLE [auth].[nivel_seguridad] (
    id_nivel_seguridad      INTEGER          IDENTITY(1,1) NOT NULL,
    nivel                   INTEGER          NOT NULL,
    descripcion             NVARCHAR(500)    NULL,
    CONSTRAINT pk_nivel_seguridad PRIMARY KEY (id_nivel_seguridad),
    CONSTRAINT uq_nivel_seguridad_nivel UNIQUE (nivel)
);
GO


-- Tabla: auth.permiso
CREATE TABLE [auth].[permiso] (
    id_permiso              INTEGER          IDENTITY(1,1) NOT NULL,
    codigo_funcion          VARCHAR(10)      NOT NULL,
    nombre                  NVARCHAR(150)    NOT NULL,
    categoria               NVARCHAR(100)    NOT NULL,
    CONSTRAINT pk_permiso PRIMARY KEY (id_permiso),
    CONSTRAINT uq_permiso_codigo_funcion UNIQUE (codigo_funcion)
);
GO


-- Tabla: auth.refresh_token
CREATE TABLE [auth].[refresh_token] (
    id_refresh_token            INTEGER          IDENTITY(1,1) NOT NULL,
    id_usuario                  INTEGER          NOT NULL,
    token_hash                  VARBINARY(32)    NOT NULL,
    fecha_creacion              DATETIME2(0)     NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_expiracion            DATETIME2(0)     NOT NULL,
    fecha_revocacion            DATETIME2(0)     NULL,
    id_refresh_token_reemplazo  INTEGER          NULL,
    ip_creacion                 VARCHAR(64)      NULL,
    user_agent                  NVARCHAR(1000)   NULL,
    CONSTRAINT pk_refresh_token PRIMARY KEY (id_refresh_token)
);
GO


-- Tabla: auth.usuario_perfil
CREATE TABLE [auth].[usuario_perfil] (
    id_usuario              INTEGER          NOT NULL,
    id_perfil               INTEGER          NOT NULL,
    CONSTRAINT pk_usuario_perfil PRIMARY KEY (id_usuario, id_perfil)
);
GO


-- Tabla: auth.perfil_rol
CREATE TABLE [auth].[perfil_rol] (
    id_perfil_rol           INTEGER          IDENTITY(1,1) NOT NULL,
    id_perfil               INTEGER          NOT NULL,
    id_rol                  INTEGER          NOT NULL,
    id_nivel_seguridad      INTEGER          NOT NULL,
    claim_code              VARCHAR(20)      NOT NULL,
    CONSTRAINT pk_perfil_rol PRIMARY KEY (id_perfil_rol),
    CONSTRAINT uq_perfil_rol_claim_code UNIQUE (claim_code),
    CONSTRAINT uq_perfil_rol_combinacion UNIQUE (id_perfil, id_rol, id_nivel_seguridad)
);
GO


-- Tabla: auth.perfil_rol_permiso
CREATE TABLE [auth].[perfil_rol_permiso] (
    id_perfil_rol_permiso   INTEGER          IDENTITY(1,1) NOT NULL,
    id_perfil_rol           INTEGER          NOT NULL,
    id_permiso              INTEGER          NOT NULL,
    CONSTRAINT pk_perfil_rol_permiso PRIMARY KEY (id_perfil_rol_permiso),
    CONSTRAINT uq_perfil_rol_permiso_combinacion UNIQUE (id_perfil_rol, id_permiso)
);
GO


-- Tabla: auth.parametro
-- Configuración global del sistema de autenticación. Patrón key-value con
-- tipado fuerte: cada parámetro tiene un nombre único en formato
-- namespace.nombre (ej. login.intentos_maximos) y se almacena en la columna
-- que corresponde a su tipo (valor_numerico INTEGER o valor_varchar
-- NVARCHAR). El CHECK ck_parametro_tipo_valor garantiza coherencia.
-- Booleans se modelan con tipo_dato='BOOLEAN' y valor_numerico IN (0,1).
CREATE TABLE [auth].[parametro] (
    id_parametro      INTEGER          IDENTITY(1,1) NOT NULL,
    nombre_parametro  VARCHAR(100)     NOT NULL,
    tipo_dato         VARCHAR(20)      NOT NULL,
    valor_numerico    INTEGER          NULL,
    valor_varchar     NVARCHAR(500)    NULL,
    activo            SMALLINT         NOT NULL DEFAULT 1
        CONSTRAINT ck_parametro_activo CHECK (activo IN (0,1)),
    descripcion       NVARCHAR(500)    NULL,
    CONSTRAINT pk_parametro PRIMARY KEY (id_parametro),
    CONSTRAINT uq_parametro_nombre_parametro UNIQUE (nombre_parametro),
    CONSTRAINT ck_parametro_tipo_dato CHECK (tipo_dato IN ('NUMERICO','VARCHAR','BOOLEAN')),
    CONSTRAINT ck_parametro_tipo_valor CHECK (
        (tipo_dato = 'NUMERICO' AND valor_numerico IS NOT NULL AND valor_varchar IS NULL)
     OR (tipo_dato = 'BOOLEAN'  AND valor_numerico IN (0,1)    AND valor_varchar IS NULL)
     OR (tipo_dato = 'VARCHAR'  AND valor_varchar  IS NOT NULL AND valor_numerico IS NULL)
    )
);
GO


-- =============================================================================
-- PASO 3 — ÍNDICES
-- =============================================================================

-- Búsqueda de tokens activos de un usuario (filtrado: no revocados)
CREATE INDEX [ix_refresh_token_usuario_activos]
    ON [auth].[refresh_token] (id_usuario, fecha_expiracion)
    WHERE fecha_revocacion IS NULL;
GO

-- Búsqueda por hash de token (validación en cada request)
CREATE UNIQUE INDEX [ux_refresh_token_hash]
    ON [auth].[refresh_token] (token_hash);
GO

-- Permisos por categoría (UI de administración)
CREATE INDEX [ix_permiso_categoria]
    ON [auth].[permiso] (categoria);
GO


-- =============================================================================
-- PASO 4 — FOREIGN KEYS INTERNAS (intra-esquema auth)
-- =============================================================================

-- refresh_token.id_usuario → usuario
ALTER TABLE [auth].[refresh_token]
    ADD CONSTRAINT fk_refresh_token_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES [auth].[usuario] (id_usuario);
GO

-- refresh_token.id_refresh_token_reemplazo → refresh_token (auto-FK)
ALTER TABLE [auth].[refresh_token]
    ADD CONSTRAINT fk_refresh_token_reemplazo
    FOREIGN KEY (id_refresh_token_reemplazo)
    REFERENCES [auth].[refresh_token] (id_refresh_token);
GO

-- usuario_perfil.id_usuario → usuario
ALTER TABLE [auth].[usuario_perfil]
    ADD CONSTRAINT fk_usuario_perfil_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES [auth].[usuario] (id_usuario);
GO

-- usuario_perfil.id_perfil → perfil
ALTER TABLE [auth].[usuario_perfil]
    ADD CONSTRAINT fk_usuario_perfil_perfil
    FOREIGN KEY (id_perfil)
    REFERENCES [auth].[perfil] (id_perfil);
GO

-- perfil_rol.id_perfil → perfil
ALTER TABLE [auth].[perfil_rol]
    ADD CONSTRAINT fk_perfil_rol_perfil
    FOREIGN KEY (id_perfil)
    REFERENCES [auth].[perfil] (id_perfil);
GO

-- perfil_rol.id_rol → rol
ALTER TABLE [auth].[perfil_rol]
    ADD CONSTRAINT fk_perfil_rol_rol
    FOREIGN KEY (id_rol)
    REFERENCES [auth].[rol] (id_rol);
GO

-- perfil_rol.id_nivel_seguridad → nivel_seguridad
ALTER TABLE [auth].[perfil_rol]
    ADD CONSTRAINT fk_perfil_rol_nivel_seguridad
    FOREIGN KEY (id_nivel_seguridad)
    REFERENCES [auth].[nivel_seguridad] (id_nivel_seguridad);
GO

-- perfil_rol_permiso.id_perfil_rol → perfil_rol
ALTER TABLE [auth].[perfil_rol_permiso]
    ADD CONSTRAINT fk_perfil_rol_permiso_perfil_rol
    FOREIGN KEY (id_perfil_rol)
    REFERENCES [auth].[perfil_rol] (id_perfil_rol);
GO

-- perfil_rol_permiso.id_permiso → permiso
ALTER TABLE [auth].[perfil_rol_permiso]
    ADD CONSTRAINT fk_perfil_rol_permiso_permiso
    FOREIGN KEY (id_permiso)
    REFERENCES [auth].[permiso] (id_permiso);
GO


-- =============================================================================
-- PASO 5 — FOREIGN KEYS CRUZADAS (a otros esquemas)
-- =============================================================================

-- usuario.id_funcionario → organizacion.funcionario
ALTER TABLE [auth].[usuario]
    ADD CONSTRAINT fk_usuario_funcionario
    FOREIGN KEY (id_funcionario)
    REFERENCES [organizacion].[funcionario] (id_funcionario);
GO


-- =============================================================================
-- PASO 6 — DESCRIPCIONES
-- =============================================================================
-- Cada bloque es idempotente: actualiza la descripción si existe, la crea
-- si no existe.
-- =============================================================================

-- ----- Esquema -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=SCHEMA_ID(N'auth') AND class=3)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identidad, sesiones (refresh tokens), RBAC (perfiles, roles, niveles de seguridad y permisos) y configuración global de autenticación.',
        @level0type=N'SCHEMA', @level0name=N'auth';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identidad, sesiones (refresh tokens), RBAC (perfiles, roles, niveles de seguridad y permisos) y configuración global de autenticación.',
        @level0type=N'SCHEMA', @level0name=N'auth';
GO


-- ----- Tabla: usuario -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identidad del usuario en el sistema. Relación 1:1 estricta con organizacion.funcionario: todo usuario es un funcionario y todo funcionario tiene a lo más un usuario.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identidad del usuario en el sistema. Relación 1:1 estricta con organizacion.funcionario: todo usuario es un funcionario y todo funcionario tiene a lo más un usuario.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'id_usuario',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del usuario. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'id_usuario';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del usuario. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'id_usuario';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'id_funcionario',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK a organizacion.funcionario. Obligatoria y única (1:1). Vincula la identidad del usuario con el funcionario PDI.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'id_funcionario';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a organizacion.funcionario. Obligatoria y única (1:1). Vincula la identidad del usuario con el funcionario PDI.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'id_funcionario';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'username',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Nombre de usuario único. ASCII (sAMAccountName de AD o equivalente).',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'username';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre de usuario único. ASCII (sAMAccountName de AD o equivalente).',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'username';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'activo',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Indica si el usuario puede iniciar sesión (1) o está deshabilitado (0). Default 1.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'activo';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si el usuario puede iniciar sesión (1) o está deshabilitado (0). Default 1.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'activo';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'fecha_creacion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC de creación del usuario. Default SYSUTCDATETIME().',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'fecha_creacion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC de creación del usuario. Default SYSUTCDATETIME().',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'fecha_creacion';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'auth_provider',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Origen de autenticación: AD (Active Directory), EXTERNO (otro sistema integrado) o LOCAL (sólo casos especiales). Default AD.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'auth_provider';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Origen de autenticación: AD (Active Directory), EXTERNO (otro sistema integrado) o LOCAL (sólo casos especiales). Default AD.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'auth_provider';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'nombre_mostrar',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Nombre para mostrar en la UI (displayName del directorio). Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'nombre_mostrar';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre para mostrar en la UI (displayName del directorio). Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'nombre_mostrar';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'email',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Correo electrónico institucional del usuario. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'email';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Correo electrónico institucional del usuario. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'email';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'dominio',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Dominio AD/LDAP al que pertenece el usuario (NetBIOS o FQDN). Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'dominio';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Dominio AD/LDAP al que pertenece el usuario (NetBIOS o FQDN). Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'dominio';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'upn',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'User Principal Name (formato user@dominio.fqdn). Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'upn';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'User Principal Name (formato user@dominio.fqdn). Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'upn';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'ad_sid',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Security Identifier de Active Directory. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'ad_sid';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Security Identifier de Active Directory. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'ad_sid';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario'),N'fecha_ultimo_acceso',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC del último login exitoso. Se actualiza por la aplicación.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'fecha_ultimo_acceso';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC del último login exitoso. Se actualiza por la aplicación.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario',
        @level2type=N'COLUMN', @level2name=N'fecha_ultimo_acceso';
GO


-- ----- Tabla: perfil -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Agrupación de alto nivel de roles (ej. Detective, Jefe de Brigada, Operador BIDEMA). Un usuario puede tener uno o más perfiles.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Agrupación de alto nivel de roles (ej. Detective, Jefe de Brigada, Operador BIDEMA). Un usuario puede tener uno o más perfiles.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil'),N'id_perfil',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del perfil. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'id_perfil';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del perfil. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'id_perfil';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil'),N'id_usuario_auditoria',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Columna de auditoría (semántica pendiente de definir). FK aún no declarada.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'id_usuario_auditoria';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Columna de auditoría (semántica pendiente de definir). FK aún no declarada.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'id_usuario_auditoria';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil'),N'nombre',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del perfil. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'nombre';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del perfil. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'nombre';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil'),N'sigla',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Sigla corta del perfil para uso operativo. Única.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'sigla';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Sigla corta del perfil para uso operativo. Única.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'sigla';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil'),N'descripcion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Descripción extendida del perfil. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'descripcion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Descripción extendida del perfil. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil',
        @level2type=N'COLUMN', @level2name=N'descripcion';
GO


-- ----- Tabla: rol -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.rol') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Función específica del sistema (ej. Crear denuncia, Aprobar diligencia). Se asigna a perfiles a través de perfil_rol con un nivel de seguridad.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Función específica del sistema (ej. Crear denuncia, Aprobar diligencia). Se asigna a perfiles a través de perfil_rol con un nivel de seguridad.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.rol'),N'id_rol',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del rol. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol',
        @level2type=N'COLUMN', @level2name=N'id_rol';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del rol. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol',
        @level2type=N'COLUMN', @level2name=N'id_rol';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.rol'),N'nombre',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del rol. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol',
        @level2type=N'COLUMN', @level2name=N'nombre';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del rol. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol',
        @level2type=N'COLUMN', @level2name=N'nombre';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.rol'),N'sigla',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Sigla corta del rol para uso operativo. Única.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol',
        @level2type=N'COLUMN', @level2name=N'sigla';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Sigla corta del rol para uso operativo. Única.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'rol',
        @level2type=N'COLUMN', @level2name=N'sigla';
GO


-- ----- Tabla: nivel_seguridad -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.nivel_seguridad') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Califica el alcance/profundidad con que un perfil tiene un rol asignado. Permite gradar permisos sin multiplicar roles.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Califica el alcance/profundidad con que un perfil tiene un rol asignado. Permite gradar permisos sin multiplicar roles.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.nivel_seguridad')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.nivel_seguridad'),N'id_nivel_seguridad',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad',
        @level2type=N'COLUMN', @level2name=N'id_nivel_seguridad';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad',
        @level2type=N'COLUMN', @level2name=N'id_nivel_seguridad';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.nivel_seguridad')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.nivel_seguridad'),N'nivel',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Valor numérico del nivel. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad',
        @level2type=N'COLUMN', @level2name=N'nivel';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor numérico del nivel. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad',
        @level2type=N'COLUMN', @level2name=N'nivel';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.nivel_seguridad')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.nivel_seguridad'),N'descripcion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Descripción del alcance del nivel. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad',
        @level2type=N'COLUMN', @level2name=N'descripcion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Descripción del alcance del nivel. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'nivel_seguridad',
        @level2type=N'COLUMN', @level2name=N'descripcion';
GO


-- ----- Tabla: permiso -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.permiso') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Acción atómica del sistema (ej. denuncia.crear, caso.aprobar). Es lo que finalmente el código consulta para autorizar operaciones.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Acción atómica del sistema (ej. denuncia.crear, caso.aprobar). Es lo que finalmente el código consulta para autorizar operaciones.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.permiso'),N'id_permiso',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del permiso. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'id_permiso';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del permiso. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'id_permiso';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.permiso'),N'codigo_funcion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Código corto del permiso usado por el código de la aplicación. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'codigo_funcion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Código corto del permiso usado por el código de la aplicación. Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'codigo_funcion';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.permiso'),N'nombre',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del permiso para mostrar en la UI de administración.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'nombre';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre descriptivo del permiso para mostrar en la UI de administración.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'nombre';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.permiso'),N'categoria',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Categoría del permiso para agrupar en la UI de administración.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'categoria';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Categoría del permiso para agrupar en la UI de administración.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'permiso',
        @level2type=N'COLUMN', @level2name=N'categoria';
GO


-- ----- Tabla: refresh_token -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Gestión de refresh tokens del usuario. Token guardado como hash SHA-256 (32 bytes). Soporta rotación: cuando un token se reemplaza, se referencia al nuevo en id_refresh_token_reemplazo.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Gestión de refresh tokens del usuario. Token guardado como hash SHA-256 (32 bytes). Soporta rotación: cuando un token se reemplaza, se referencia al nuevo en id_refresh_token_reemplazo.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'id_refresh_token',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del token. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'id_refresh_token';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del token. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'id_refresh_token';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'id_usuario',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al usuario propietario del token.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'id_usuario';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al usuario propietario del token.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'id_usuario';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'token_hash',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Hash SHA-256 del refresh token (32 bytes). El token plano nunca se almacena.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'token_hash';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Hash SHA-256 del refresh token (32 bytes). El token plano nunca se almacena.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'token_hash';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'fecha_creacion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC de emisión del token. Default SYSUTCDATETIME().',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'fecha_creacion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC de emisión del token. Default SYSUTCDATETIME().',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'fecha_creacion';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'fecha_expiracion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC en que el token expira y deja de ser válido.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'fecha_expiracion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC en que el token expira y deja de ser válido.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'fecha_expiracion';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'fecha_revocacion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC en que el token fue revocado (logout, rotación, compromiso). NULL = token activo.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'fecha_revocacion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Timestamp UTC en que el token fue revocado (logout, rotación, compromiso). NULL = token activo.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'fecha_revocacion';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'id_refresh_token_reemplazo',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Auto-FK al token que reemplazó a éste en una rotación. Permite trazar la cadena de refresh.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'id_refresh_token_reemplazo';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Auto-FK al token que reemplazó a éste en una rotación. Permite trazar la cadena de refresh.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'id_refresh_token_reemplazo';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'ip_creacion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'IP de origen donde se emitió el token (IPv4 o IPv6). Para auditoría de sesiones.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'ip_creacion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'IP de origen donde se emitió el token (IPv4 o IPv6). Para auditoría de sesiones.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'ip_creacion';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.refresh_token')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.refresh_token'),N'user_agent',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'User-Agent del cliente que emitió el token. Para auditoría de sesiones.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'user_agent';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'User-Agent del cliente que emitió el token. Para auditoría de sesiones.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'refresh_token',
        @level2type=N'COLUMN', @level2name=N'user_agent';
GO


-- ----- Tabla: usuario_perfil -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario_perfil') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Asignación N:M entre usuarios y perfiles. PK compuesta sin IDENTITY.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario_perfil';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Asignación N:M entre usuarios y perfiles. PK compuesta sin IDENTITY.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario_perfil';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario_perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario_perfil'),N'id_usuario',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al usuario. Parte de la PK compuesta.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario_perfil',
        @level2type=N'COLUMN', @level2name=N'id_usuario';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al usuario. Parte de la PK compuesta.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario_perfil',
        @level2type=N'COLUMN', @level2name=N'id_usuario';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.usuario_perfil')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.usuario_perfil'),N'id_perfil',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al perfil. Parte de la PK compuesta.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario_perfil',
        @level2type=N'COLUMN', @level2name=N'id_perfil';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al perfil. Parte de la PK compuesta.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'usuario_perfil',
        @level2type=N'COLUMN', @level2name=N'id_perfil';
GO


-- ----- Tabla: perfil_rol -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Asignación de un rol a un perfil con un nivel de seguridad específico. El claim_code es el identificador estable que viaja en el JWT.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Asignación de un rol a un perfil con un nivel de seguridad específico. El claim_code es el identificador estable que viaja en el JWT.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol'),N'id_perfil_rol',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la asignación. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_perfil_rol';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la asignación. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_perfil_rol';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol'),N'id_perfil',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al perfil.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_perfil';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al perfil.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_perfil';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol'),N'id_rol',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al rol.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_rol';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al rol.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_rol';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol'),N'id_nivel_seguridad',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al nivel de seguridad con que se asigna el rol al perfil.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_nivel_seguridad';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al nivel de seguridad con que se asigna el rol al perfil.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'id_nivel_seguridad';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol'),N'claim_code',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador estable que viaja en el JWT (ej. DET_NIVEL_2). Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'claim_code';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador estable que viaja en el JWT (ej. DET_NIVEL_2). Único.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol',
        @level2type=N'COLUMN', @level2name=N'claim_code';
GO


-- ----- Tabla: perfil_rol_permiso -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol_permiso') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Asignación de permisos a la combinación perfil-rol-nivel. Es la tabla que finalmente determina qué puede hacer un usuario en el sistema.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Asignación de permisos a la combinación perfil-rol-nivel. Es la tabla que finalmente determina qué puede hacer un usuario en el sistema.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol_permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol_permiso'),N'id_perfil_rol_permiso',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la asignación. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso',
        @level2type=N'COLUMN', @level2name=N'id_perfil_rol_permiso';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único de la asignación. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso',
        @level2type=N'COLUMN', @level2name=N'id_perfil_rol_permiso';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol_permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol_permiso'),N'id_perfil_rol',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK a perfil_rol (combinación perfil-rol-nivel).',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso',
        @level2type=N'COLUMN', @level2name=N'id_perfil_rol';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK a perfil_rol (combinación perfil-rol-nivel).',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso',
        @level2type=N'COLUMN', @level2name=N'id_perfil_rol';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.perfil_rol_permiso')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.perfil_rol_permiso'),N'id_permiso',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'FK al permiso otorgado.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso',
        @level2type=N'COLUMN', @level2name=N'id_permiso';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'FK al permiso otorgado.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'perfil_rol_permiso',
        @level2type=N'COLUMN', @level2name=N'id_permiso';
GO


-- ----- Tabla: parametro -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Configuración global del sistema de autenticación. Patrón key-value con tipado fuerte: cada parámetro tiene un nombre único (ej. login.intentos_maximos) y se almacena en la columna que corresponde a su tipo (valor_numerico o valor_varchar). El CHECK ck_parametro_tipo_valor garantiza coherencia tipo-valor.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Configuración global del sistema de autenticación. Patrón key-value con tipado fuerte: cada parámetro tiene un nombre único (ej. login.intentos_maximos) y se almacena en la columna que corresponde a su tipo (valor_numerico o valor_varchar). El CHECK ck_parametro_tipo_valor garantiza coherencia tipo-valor.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'id_parametro',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del parámetro. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'id_parametro';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Identificador único del parámetro. Clave primaria autoincremental.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'id_parametro';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'nombre_parametro',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Nombre único del parámetro en formato namespace.nombre (ej. login.intentos_maximos, login.tiempo_espera_seg, login.reintentos_activado). Es el identificador estable que la aplicación consulta.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'nombre_parametro';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Nombre único del parámetro en formato namespace.nombre (ej. login.intentos_maximos, login.tiempo_espera_seg, login.reintentos_activado). Es el identificador estable que la aplicación consulta.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'nombre_parametro';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'tipo_dato',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Discriminador que indica qué columna contiene el valor. Valores permitidos: NUMERICO (valor_numerico), VARCHAR (valor_varchar), BOOLEAN (valor_numerico restringido a 0/1).',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'tipo_dato';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Discriminador que indica qué columna contiene el valor. Valores permitidos: NUMERICO (valor_numerico), VARCHAR (valor_varchar), BOOLEAN (valor_numerico restringido a 0/1).',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'tipo_dato';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'valor_numerico',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Valor del parámetro cuando tipo_dato es NUMERICO o BOOLEAN. NULL si tipo_dato es VARCHAR.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'valor_numerico';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor del parámetro cuando tipo_dato es NUMERICO o BOOLEAN. NULL si tipo_dato es VARCHAR.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'valor_numerico';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'valor_varchar',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Valor del parámetro cuando tipo_dato es VARCHAR. NULL si tipo_dato es NUMERICO o BOOLEAN.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'valor_varchar';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Valor del parámetro cuando tipo_dato es VARCHAR. NULL si tipo_dato es NUMERICO o BOOLEAN.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'valor_varchar';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'activo',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Indica si el parámetro está vigente (1) o desactivado (0). Permite deshabilitar parámetros sin perder su valor histórico. Default 1.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'activo';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Indica si el parámetro está vigente (1) o desactivado (0). Permite deshabilitar parámetros sin perder su valor histórico. Default 1.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'activo';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('auth.parametro')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('auth.parametro'),N'descripcion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Descripción humana del parámetro para la UI de administración. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'descripcion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Descripción humana del parámetro para la UI de administración. Opcional.',
        @level0type=N'SCHEMA', @level0name=N'auth', @level1type=N'TABLE', @level1name=N'parametro',
        @level2type=N'COLUMN', @level2name=N'descripcion';
GO


-- =============================================================================
-- FIN — V0002__nuevo_esquema_auth
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--   SELECT COUNT(*) FROM sys.tables
--    WHERE schema_id = SCHEMA_ID('auth');                  -- esperado: 10
--   SELECT COUNT(*) FROM sys.foreign_keys fk
--     JOIN sys.tables t ON fk.parent_object_id = t.object_id
--    WHERE t.schema_id = SCHEMA_ID('auth');                -- esperado: 10
--   SELECT COUNT(*) FROM sys.indexes i
--     JOIN sys.tables t ON i.object_id = t.object_id
--    WHERE t.schema_id = SCHEMA_ID('auth')
--      AND i.is_primary_key = 0 AND i.is_unique_constraint = 0
--      AND i.type_desc = 'NONCLUSTERED';                        -- esperado: 3
--   SELECT COUNT(*) FROM sys.extended_properties ep
--     JOIN sys.objects o ON ep.major_id = o.object_id
--    WHERE ep.name = 'MS_Description'
--      AND o.schema_id = SCHEMA_ID('auth');                -- esperado: ~54
-- =============================================================================
