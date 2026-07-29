-- =============================================================================
-- SIP â€” Migration V0004__drop_denuncias_encargos_legacy
-- =============================================================================
-- VersiÃ³n: 4.0 v3 (incremental sobre V0003)
-- Compatible: SQL Server 2017+ (forward-compatible 2022)
-- Depende de: V0001__baseline_sip.sql (define las tablas a dropear)
-- V0003__nuevo_esquema_encargos.sql (esquema reemplazo)
--
-- ALCANCE:
-- Elimina las tablas legacy de encargos del esquema `denuncias` que han
-- sido reemplazadas por el nuevo esquema `encargos` (V0003):
-- - denuncias.encargo_persona (encargos de bÃºsqueda de personas)
-- - denuncias.encargo_suev (encargos de vehÃ­culos vÃ­a SUEV)
--
-- JUSTIFICACIÃ“N:
-- El nuevo esquema `encargos` (V0003) provee un modelo unificado y normalizado
-- para todos los tipos de encargo (personas, vehÃ­culos, armas, otros),
-- centralizando la lÃ³gica que anteriormente estaba duplicada en dos tablas
-- monolÃ­ticas dentro del esquema `denuncias`.
--
-- VERIFICACIONES PREVIAS REALIZADAS:
-- âœ“ 0 FKs entrantes hacia denuncias.encargo_persona
-- âœ“ 0 FKs entrantes hacia denuncias.encargo_suev
-- âœ“ Las tablas se pueden dropear sin orden topolÃ³gico especial
--
-- LO QUE SE BORRA AL HACER DROP TABLE (automÃ¡tico, no requiere DDL explÃ­cito):
-- - Constraints PRIMARY KEY (pk_encargo_persona, pk_encargo_suev)
-- - Constraints UNIQUE (uq_encargo_suev_denuncia)
-- - Constraints CHECK (CHK_encargo_persona_tipo, CHK_encargo_persona_estado)
-- - FKs salientes (a personas, casos, organizacion, vehiculos, denuncias)
-- - Ãndices (ix_encargo_persona_persona)
-- - Descripciones extendidas (1 + 12 = 13 properties)
--
-- COBERTURA EN EL NUEVO MODELO:
-- El V0003 cubre la funcionalidad esencial (cabecera de encargo, tipos,
-- vÃ­nculos con denuncias/diligencias/tareas, Ã³rdenes judiciales). Los campos
-- operativos faltantes (estado, motivo, fechas, n_encargo_nacional, patente,
-- folio_suev, observaciones, vÃ­nculo a vehÃ­culo, etc.) se modelarÃ¡n en una
-- migration posterior segÃºn se confirme el alcance con PDI.
--
-- PENDIENTE REGISTRADO:
-- - Modelar campos faltantes del proceso operativo (V0005 o posterior):
-- Â· Estado y mÃ¡quina de estados del encargo
-- Â· n_encargo_nacional (EUN â€” interface SUEV)
-- Â· Datos especÃ­ficos del encargo de vehÃ­culo (patente, folio_suev)
-- Â· AuditorÃ­a (id_funcionario_registra, fecha_actualizacion, fecha_eliminacion)
-- Â· VÃ­nculo opcional a caso
--
-- IDEMPOTENCIA:
-- Cada DROP usa IF EXISTS para que la migration sea segura ante reaplicaciÃ³n
-- manual (ej: drop accidental + restore + re-migrate).
--
-- ROLLBACK:
-- No hay rollback automÃ¡tico en Flyway para Versioned migrations. Si se
-- requiere recuperar estas tablas, debe restaurarse desde backup o
-- reaplicarse el DDL extraÃ­do de V0001.
-- =============================================================================
SET ANSI_NULLS ON;
SET ANSI_WARNINGS ON;
SET ANSI_PADDING ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;


-- =============================================================================
-- DROP TABLE â€” denuncias.encargo_persona
-- =============================================================================
-- Tabla legacy: encargos de bÃºsqueda de personas con tipos
-- DETENCION/ARRESTO/BUSQUEDA/CITACION. Reemplazada por el modelo unificado
-- del esquema `encargos`.
-- =============================================================================

IF OBJECT_ID('denuncias.encargo_persona', 'U') IS NOT NULL
 DROP TABLE denuncias.encargo_persona;


-- =============================================================================
-- DROP TABLE â€” denuncias.encargo_suev
-- =============================================================================
-- Tabla legacy: encargos vehiculares vÃ­a Sistema Ãšnico de Encargo de VehÃ­culos.
-- Reemplazada por el modelo unificado del esquema `encargos`.
-- =============================================================================

IF OBJECT_ID('denuncias.encargo_suev', 'U') IS NOT NULL
 DROP TABLE denuncias.encargo_suev;


-- =============================================================================
-- FIN â€” V0004__drop_denuncias_encargos_legacy
-- =============================================================================
-- ValidaciÃ³n recomendada (despuÃ©s de ejecutar):
--
-- -- Las tablas no deben existir
-- SELECT name FROM sys.tables
-- WHERE schema_id = SCHEMA_ID('denuncias')
-- AND name IN ('encargo_persona', 'encargo_suev'); -- esperado: 0 filas
--
-- -- Conteo final del esquema denuncias (era 11 tablas en V0001, ahora 9)
-- SELECT COUNT(*) FROM sys.tables
-- WHERE schema_id = SCHEMA_ID('denuncias'); -- esperado: 9
--
-- -- Conteo final del esquema encargos (sin cambios desde V0003)
-- SELECT COUNT(*) FROM sys.tables
-- WHERE schema_id = SCHEMA_ID('encargos'); -- esperado: 8
-- =============================================================================

