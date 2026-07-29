-- =============================================================================
-- SIP — Migration V0004__drop_denuncias_encargos_legacy
-- =============================================================================
-- Versión:      4.0 v3 (incremental sobre V0003)
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0001__baseline_sip.sql (define las tablas a dropear)
--               V0003__nuevo_esquema_encargos.sql (esquema reemplazo)
--
-- ALCANCE:
--   Elimina las tablas legacy de encargos del esquema `denuncias` que han
--   sido reemplazadas por el nuevo esquema `encargos` (V0003):
--     - denuncias.encargo_persona  (encargos de búsqueda de personas)
--     - denuncias.encargo_suev     (encargos de vehículos vía SUEV)
--
-- JUSTIFICACIÓN:
--   El nuevo esquema `encargos` (V0003) provee un modelo unificado y normalizado
--   para todos los tipos de encargo (personas, vehículos, armas, otros),
--   centralizando la lógica que anteriormente estaba duplicada en dos tablas
--   monolíticas dentro del esquema `denuncias`.
--
-- VERIFICACIONES PREVIAS REALIZADAS:
--   ✓ 0 FKs entrantes hacia denuncias.encargo_persona
--   ✓ 0 FKs entrantes hacia denuncias.encargo_suev
--   ✓ Las tablas se pueden dropear sin orden topológico especial
--
-- LO QUE SE BORRA AL HACER DROP TABLE (automático, no requiere DDL explícito):
--   - Constraints PRIMARY KEY (pk_encargo_persona, pk_encargo_suev)
--   - Constraints UNIQUE (uq_encargo_suev_denuncia)
--   - Constraints CHECK (CHK_encargo_persona_tipo, CHK_encargo_persona_estado)
--   - FKs salientes (a personas, casos, organizacion, vehiculos, denuncias)
--   - Índices (ix_encargo_persona_persona)
--   - Descripciones extendidas (1 + 12 = 13 properties)
--
-- COBERTURA EN EL NUEVO MODELO:
--   El V0003 cubre la funcionalidad esencial (cabecera de encargo, tipos,
--   vínculos con denuncias/diligencias/tareas, órdenes judiciales). Los campos
--   operativos faltantes (estado, motivo, fechas, n_encargo_nacional, patente,
--   folio_suev, observaciones, vínculo a vehículo, etc.) se modelarán en una
--   migration posterior según se confirme el alcance con PDI.
--
-- PENDIENTE REGISTRADO:
--   - Modelar campos faltantes del proceso operativo (V0005 o posterior):
--     · Estado y máquina de estados del encargo
--     · n_encargo_nacional (EUN — interface SUEV)
--     · Datos específicos del encargo de vehículo (patente, folio_suev)
--     · Auditoría (id_funcionario_registra, fecha_actualizacion, fecha_eliminacion)
--     · Vínculo opcional a caso
--
-- IDEMPOTENCIA:
--   Cada DROP usa IF EXISTS para que la migration sea segura ante reaplicación
--   manual (ej: drop accidental + restore + re-migrate).
--
-- ROLLBACK:
--   No hay rollback automático en Flyway para Versioned migrations. Si se
--   requiere recuperar estas tablas, debe restaurarse desde backup o
--   reaplicarse el DDL extraído de V0001.
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
-- DROP TABLE — denuncias.encargo_persona
-- =============================================================================
-- Tabla legacy: encargos de búsqueda de personas con tipos
-- DETENCION/ARRESTO/BUSQUEDA/CITACION. Reemplazada por el modelo unificado
-- del esquema `encargos`.
-- =============================================================================

IF OBJECT_ID('[denuncias].[encargo_persona]', 'U') IS NOT NULL
    DROP TABLE [denuncias].[encargo_persona];
GO


-- =============================================================================
-- DROP TABLE — denuncias.encargo_suev
-- =============================================================================
-- Tabla legacy: encargos vehiculares vía Sistema Único de Encargo de Vehículos.
-- Reemplazada por el modelo unificado del esquema `encargos`.
-- =============================================================================

IF OBJECT_ID('[denuncias].[encargo_suev]', 'U') IS NOT NULL
    DROP TABLE [denuncias].[encargo_suev];
GO


-- =============================================================================
-- FIN — V0004__drop_denuncias_encargos_legacy
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--
--   -- Las tablas no deben existir
--   SELECT name FROM sys.tables
--    WHERE schema_id = SCHEMA_ID('denuncias')
--      AND name IN ('encargo_persona', 'encargo_suev');                -- esperado: 0 filas
--
--   -- Conteo final del esquema denuncias (era 11 tablas en V0001, ahora 9)
--   SELECT COUNT(*) FROM sys.tables
--    WHERE schema_id = SCHEMA_ID('denuncias');                          -- esperado: 9
--
--   -- Conteo final del esquema encargos (sin cambios desde V0003)
--   SELECT COUNT(*) FROM sys.tables
--    WHERE schema_id = SCHEMA_ID('encargos');                           -- esperado: 8
-- =============================================================================
