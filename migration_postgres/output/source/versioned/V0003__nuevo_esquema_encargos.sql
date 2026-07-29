-- =============================================================================
-- SIP — Migration V0003__nuevo_esquema_encargos
-- =============================================================================
-- Versión:      4.0 v3 (incremental sobre V0002)
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql (esquemas personas, denuncias,
--                                        diligencias, tareas)
--
-- ALCANCE:
--   Crea el esquema `encargos` con el modelo de gestión de encargos:
--   personas buscadas, órdenes judiciales del PJUD, presuntas desgracias,
--   y trazabilidad con denuncias, diligencias y tareas.
--
-- MAPEO CON MACROPROCESOS PDI:
--   - PO01 — Investigación Criminal (encargos derivados de denuncias y diligencias)
--   - PO03 — Cooperación Internacional (órdenes judiciales internacionales)
--
-- ESTRUCTURA DEL ARCHIVO:
--   PASO 1 — Esquema
--   PASO 2 — Tablas (sólo PK/UQ/CK; sin FKs)
--   PASO 3 — Índices
--   PASO 4 — Foreign keys internas (intra-esquema encargos)
--   PASO 5 — Foreign keys cruzadas (a otros esquemas)
--   PASO 6 — Descripciones (sys.sp_addextendedproperty idempotente)
--
-- CONVENCIONES APLICADAS (heredadas de V0001 y V0002):
--   - PKs nombradas id_<tabla> con IDENTITY(1,1) cuando son locales
--   - INTEGER para todas las PKs y FKs (no BIGINT — consistente con baseline)
--   - NVARCHAR para texto con caracteres especiales (acentos, ñ)
--   - DATETIME2(7) para timestamps con SYSUTCDATETIME() (UTC)
--   - Naming lowercase con prefijos pk_/fk_/uq_/ix_/ck_
--   - Sin ON DELETE CASCADE (consistencia con V0001/V0002 — bloqueo intencional
--     para forzar limpieza explícita)
--   - Booleans como SMALLINT con CHECK IN (0,1) (no se usa BIT)
--   - Schema/tabla en [brackets]
--   - Sin comando USE (Flyway controla la conexión vía URL JDBC)
--
-- TRADUCCIÓN APLICADA DESDE EL INPUT POSTGRESQL:
--   - BIGINT GENERATED ALWAYS AS IDENTITY → INTEGER IDENTITY(1,1)
--   - BIGINT (FKs cruzadas) → INTEGER (alineado con PKs target del baseline)
--   - TIMESTAMP DEFAULT CURRENT_TIMESTAMP → DATETIME2(7) DEFAULT SYSUTCDATETIME()
--   - VARCHAR → NVARCHAR (texto con acentos)
--   - TEXT → NVARCHAR(MAX)
--   - COMMENT ON → sys.sp_addextendedproperty
--   - ON DELETE CASCADE → eliminado (consistencia)
--
-- DECISIONES DE DISEÑO REGISTRADAS:
--   - Relaciones 1:1 estrictas (encargo↔denuncia, encargo↔diligencia,
--     tarea↔encargo) según diseño actual; pendiente revisión con PDI si en
--     algún caso se requiere N:M.
--   - id_orden_judicial con IDENTITY (id local del SIP, no externo PJUD).
--   - Catálogos tipo_encargo y tipo_orden_judicial con IDENTITY también
--     (id_local autogenerado), las filas se cargan vía R__ posterior.
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

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'encargos')
    EXEC('CREATE SCHEMA [encargos]');
GO


-- =============================================================================
-- PASO 2 — TABLAS
-- =============================================================================

-- Tabla: encargos.tipo_encargo
-- Catálogo de tipos de encargo: personas, armas, vehículos, otros.
CREATE TABLE [encargos].[tipo_encargo] (
    id_tipo_encargo  INTEGER         IDENTITY(1,1) NOT NULL,
    nombre           NVARCHAR(200)   NOT NULL,
    CONSTRAINT pk_tipo_encargo PRIMARY KEY (id_tipo_encargo),
    CONSTRAINT uq_tipo_encargo_nombre UNIQUE (nombre)
);
GO


-- Tabla: encargos.tipo_orden_judicial
-- Catálogo de tipos de orden judicial provenientes del PJUD.
CREATE TABLE [encargos].[tipo_orden_judicial] (
    id_tipo_orden_judicial  INTEGER         IDENTITY(1,1) NOT NULL,
    nombre                  NVARCHAR(150)   NOT NULL,
    CONSTRAINT pk_tipo_orden_judicial PRIMARY KEY (id_tipo_orden_judicial),
    CONSTRAINT uq_tipo_orden_judicial_nombre UNIQUE (nombre)
);
GO


-- Tabla: encargos.encargo
-- Cabecera de todos los encargos del sistema con su vigencia.
CREATE TABLE [encargos].[encargo] (
    id_encargo       INTEGER          IDENTITY(1,1) NOT NULL,
    id_tipo_encargo  INTEGER          NOT NULL,
    fecha_inicio     DATETIME2(7)     NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_fin        DATETIME2(7)     NULL,
    CONSTRAINT pk_encargo PRIMARY KEY (id_encargo),
    CONSTRAINT ck_encargo_fechas CHECK (
        fecha_fin IS NULL OR fecha_fin >= fecha_inicio
    )
);
GO


-- Tabla: encargos.orden_judicial
-- Órdenes judiciales provenientes del PJUD, asociables a encargos.
-- id_orden_judicial es local (SIP), no se respeta el id externo del PJUD.
CREATE TABLE [encargos].[orden_judicial] (
    id_orden_judicial       INTEGER         IDENTITY(1,1) NOT NULL,
    id_tipo_orden_judicial  INTEGER         NOT NULL,
    id_persona_buscada      INTEGER         NOT NULL,
    fecha_registro          DATETIME2(7)    NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion             NVARCHAR(MAX)   NULL,
    CONSTRAINT pk_orden_judicial PRIMARY KEY (id_orden_judicial)
);
GO


-- Tabla: encargos.encargo_denuncia
-- Asocia denuncia de presunta desgracia con su encargo (relación 1:1).
CREATE TABLE [encargos].[encargo_denuncia] (
    id_encargo            INTEGER NOT NULL,
    id_denuncia           INTEGER NOT NULL,
    id_persona_buscada    INTEGER NOT NULL,
    CONSTRAINT pk_encargo_denuncia PRIMARY KEY (id_encargo),
    CONSTRAINT uq_encargo_denuncia_denuncia UNIQUE (id_denuncia)
);
GO


-- Tabla: encargos.encargo_orden_judicial
-- Relación N:M entre encargos y órdenes judiciales.
CREATE TABLE [encargos].[encargo_orden_judicial] (
    id_encargo         INTEGER NOT NULL,
    id_orden_judicial  INTEGER NOT NULL,
    CONSTRAINT pk_encargo_orden_judicial PRIMARY KEY (id_encargo, id_orden_judicial)
);
GO


-- Tabla: encargos.encargo_persona_diligencia
-- Asocia diligencia con encargo (relación 1:1, diligencia opcional).
CREATE TABLE [encargos].[encargo_persona_diligencia] (
    id_encargo            INTEGER NOT NULL,
    id_diligencia         INTEGER NULL,
    id_persona_buscada    INTEGER NOT NULL,
    CONSTRAINT pk_encargo_persona_diligencia PRIMARY KEY (id_encargo)
);
GO


-- Tabla: encargos.tarea_encargo
-- Tareas que crean o gestionan encargos (relación 1:1: una tarea = un encargo).
-- id_tarea es INTEGER para coincidir con el tipo declarado en tareas.tarea.id_tarea
-- (INT IDENTITY(1,1)). Mantener tipos coincidentes es requisito de SQL Server
-- para crear la FK fk_tarea_encargo_tarea (Msg 1778 si difieren).
CREATE TABLE [encargos].[tarea_encargo] (
    id_tarea     INTEGER NOT NULL,
    id_encargo   INTEGER NOT NULL,
    CONSTRAINT pk_tarea_encargo PRIMARY KEY (id_tarea)
);
GO


-- =============================================================================
-- PASO 3 — ÍNDICES
-- =============================================================================

CREATE INDEX [ix_encargo_tipo]
    ON [encargos].[encargo] (id_tipo_encargo);
GO

CREATE INDEX [ix_encargo_vigencia]
    ON [encargos].[encargo] (fecha_inicio, fecha_fin);
GO

CREATE INDEX [ix_orden_judicial_tipo]
    ON [encargos].[orden_judicial] (id_tipo_orden_judicial);
GO

CREATE INDEX [ix_orden_judicial_persona]
    ON [encargos].[orden_judicial] (id_persona_buscada);
GO

CREATE INDEX [ix_encargo_denuncia_persona]
    ON [encargos].[encargo_denuncia] (id_persona_buscada);
GO

CREATE INDEX [ix_encargo_orden_judicial_oj]
    ON [encargos].[encargo_orden_judicial] (id_orden_judicial);
GO

CREATE INDEX [ix_encargo_persona_diligencia_persona]
    ON [encargos].[encargo_persona_diligencia] (id_persona_buscada);
GO

CREATE INDEX [ix_encargo_persona_diligencia_diligencia]
    ON [encargos].[encargo_persona_diligencia] (id_diligencia);
GO

CREATE INDEX [ix_tarea_encargo_encargo]
    ON [encargos].[tarea_encargo] (id_encargo);
GO


-- =============================================================================
-- PASO 4 — FOREIGN KEYS INTERNAS (intra-esquema encargos)
-- =============================================================================

ALTER TABLE [encargos].[encargo]
    ADD CONSTRAINT fk_encargo_tipo
    FOREIGN KEY (id_tipo_encargo)
    REFERENCES [encargos].[tipo_encargo] (id_tipo_encargo);
GO

ALTER TABLE [encargos].[orden_judicial]
    ADD CONSTRAINT fk_orden_judicial_tipo
    FOREIGN KEY (id_tipo_orden_judicial)
    REFERENCES [encargos].[tipo_orden_judicial] (id_tipo_orden_judicial);
GO

ALTER TABLE [encargos].[encargo_denuncia]
    ADD CONSTRAINT fk_encargo_denuncia_encargo
    FOREIGN KEY (id_encargo)
    REFERENCES [encargos].[encargo] (id_encargo);
GO

ALTER TABLE [encargos].[encargo_orden_judicial]
    ADD CONSTRAINT fk_encargo_orden_judicial_encargo
    FOREIGN KEY (id_encargo)
    REFERENCES [encargos].[encargo] (id_encargo);
GO

ALTER TABLE [encargos].[encargo_orden_judicial]
    ADD CONSTRAINT fk_encargo_orden_judicial_oj
    FOREIGN KEY (id_orden_judicial)
    REFERENCES [encargos].[orden_judicial] (id_orden_judicial);
GO

ALTER TABLE [encargos].[encargo_persona_diligencia]
    ADD CONSTRAINT fk_encargo_persona_diligencia_encargo
    FOREIGN KEY (id_encargo)
    REFERENCES [encargos].[encargo] (id_encargo);
GO

ALTER TABLE [encargos].[tarea_encargo]
    ADD CONSTRAINT fk_tarea_encargo_encargo
    FOREIGN KEY (id_encargo)
    REFERENCES [encargos].[encargo] (id_encargo);
GO


-- =============================================================================
-- PASO 5 — FOREIGN KEYS CRUZADAS (a otros esquemas)
-- =============================================================================

ALTER TABLE [encargos].[orden_judicial]
    ADD CONSTRAINT fk_orden_judicial_persona
    FOREIGN KEY (id_persona_buscada)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [encargos].[encargo_denuncia]
    ADD CONSTRAINT fk_encargo_denuncia_denuncia
    FOREIGN KEY (id_denuncia)
    REFERENCES [denuncias].[denuncia] (id_denuncia);
GO

ALTER TABLE [encargos].[encargo_denuncia]
    ADD CONSTRAINT fk_encargo_denuncia_persona
    FOREIGN KEY (id_persona_buscada)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [encargos].[encargo_persona_diligencia]
    ADD CONSTRAINT fk_encargo_persona_diligencia_diligencia
    FOREIGN KEY (id_diligencia)
    REFERENCES [diligencias].[diligencia] (id_diligencia);
GO

ALTER TABLE [encargos].[encargo_persona_diligencia]
    ADD CONSTRAINT fk_encargo_persona_diligencia_persona
    FOREIGN KEY (id_persona_buscada)
    REFERENCES [personas].[persona] (id_persona);
GO

ALTER TABLE [encargos].[tarea_encargo]
    ADD CONSTRAINT fk_tarea_encargo_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES [tareas].[tarea] (id_tarea);
GO


-- =============================================================================
-- PASO 6 — DESCRIPCIONES
-- =============================================================================
-- Cada bloque es idempotente: actualiza la descripción si existe, la crea
-- si no existe.
-- =============================================================================

-- ----- Esquema -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=SCHEMA_ID(N'encargos') AND class=3)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Gestión de encargos: personas buscadas, órdenes judiciales del PJUD, presuntas desgracias. Cruza con denuncias, diligencias y tareas. Soporta los macroprocesos PO01 (Investigación Criminal) y PO03 (Cooperación Internacional).',
        @level0type=N'SCHEMA', @level0name=N'encargos';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Gestión de encargos: personas buscadas, órdenes judiciales del PJUD, presuntas desgracias. Cruza con denuncias, diligencias y tareas. Soporta los macroprocesos PO01 (Investigación Criminal) y PO03 (Cooperación Internacional).',
        @level0type=N'SCHEMA', @level0name=N'encargos';
GO


-- ----- Tabla: tipo_encargo -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.tipo_encargo') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de tipos de encargo: personas, armas, vehículos, otros.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'tipo_encargo';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de tipos de encargo: personas, armas, vehículos, otros.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'tipo_encargo';
GO


-- ----- Tabla: tipo_orden_judicial -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.tipo_orden_judicial') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de tipos de orden judicial provenientes del PJUD.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'tipo_orden_judicial';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Catálogo de tipos de orden judicial provenientes del PJUD.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'tipo_orden_judicial';
GO


-- ----- Tabla: encargo -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.encargo') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Cabecera de todos los encargos del sistema con su vigencia.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Cabecera de todos los encargos del sistema con su vigencia.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.encargo')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('encargos.encargo'),N'fecha_inicio',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Inicio de vigencia del encargo (UTC).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo',
        @level2type=N'COLUMN', @level2name=N'fecha_inicio';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Inicio de vigencia del encargo (UTC).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo',
        @level2type=N'COLUMN', @level2name=N'fecha_inicio';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.encargo')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('encargos.encargo'),N'fecha_fin',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Fin de vigencia del encargo (UTC). NULL si está vigente.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo',
        @level2type=N'COLUMN', @level2name=N'fecha_fin';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Fin de vigencia del encargo (UTC). NULL si está vigente.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo',
        @level2type=N'COLUMN', @level2name=N'fecha_fin';
GO


-- ----- Tabla: orden_judicial -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.orden_judicial') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Órdenes judiciales provenientes del PJUD. id_orden_judicial es local (autogenerado en SIP), no se respeta el id externo del PJUD.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'orden_judicial';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Órdenes judiciales provenientes del PJUD. id_orden_judicial es local (autogenerado en SIP), no se respeta el id externo del PJUD.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'orden_judicial';
GO

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.orden_judicial')
             AND minor_id=COLUMNPROPERTY(OBJECT_ID('encargos.orden_judicial'),N'descripcion',N'COLUMN'))
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Facultades, modalidad horaria y condiciones de la orden judicial.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'orden_judicial',
        @level2type=N'COLUMN', @level2name=N'descripcion';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Facultades, modalidad horaria y condiciones de la orden judicial.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'orden_judicial',
        @level2type=N'COLUMN', @level2name=N'descripcion';
GO


-- ----- Tabla: encargo_denuncia -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.encargo_denuncia') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Asocia denuncia de presunta desgracia con su encargo (relación 1:1).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo_denuncia';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Asocia denuncia de presunta desgracia con su encargo (relación 1:1).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo_denuncia';
GO


-- ----- Tabla: encargo_orden_judicial -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.encargo_orden_judicial') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Relación N:M entre encargos y órdenes judiciales.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo_orden_judicial';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Relación N:M entre encargos y órdenes judiciales.',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo_orden_judicial';
GO


-- ----- Tabla: encargo_persona_diligencia -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.encargo_persona_diligencia') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Asocia diligencia con encargo (relación 1:1, diligencia opcional).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo_persona_diligencia';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Asocia diligencia con encargo (relación 1:1, diligencia opcional).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'encargo_persona_diligencia';
GO


-- ----- Tabla: tarea_encargo -----

IF EXISTS (SELECT 1 FROM sys.extended_properties
           WHERE name=N'MS_Description' AND major_id=OBJECT_ID('encargos.tarea_encargo') AND minor_id=0 AND class=1)
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description',
        @value=N'Tareas que crean o gestionan encargos (relación 1:1: una tarea = un encargo).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'tarea_encargo';
ELSE
    EXEC sys.sp_addextendedproperty @name=N'MS_Description',
        @value=N'Tareas que crean o gestionan encargos (relación 1:1: una tarea = un encargo).',
        @level0type=N'SCHEMA', @level0name=N'encargos', @level1type=N'TABLE', @level1name=N'tarea_encargo';
GO


-- =============================================================================
-- FIN — V0003__nuevo_esquema_encargos
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--   SELECT COUNT(*) FROM sys.tables
--    WHERE schema_id = SCHEMA_ID('encargos');                  -- esperado: 8
--   SELECT COUNT(*) FROM sys.foreign_keys fk
--     JOIN sys.tables t ON fk.parent_object_id = t.object_id
--    WHERE t.schema_id = SCHEMA_ID('encargos');                -- esperado: 13
--   SELECT COUNT(*) FROM sys.indexes i
--     JOIN sys.tables t ON i.object_id = t.object_id
--    WHERE t.schema_id = SCHEMA_ID('encargos')
--      AND i.is_primary_key = 0 AND i.is_unique_constraint = 0
--      AND i.type_desc = 'NONCLUSTERED';                       -- esperado: 9
-- =============================================================================
