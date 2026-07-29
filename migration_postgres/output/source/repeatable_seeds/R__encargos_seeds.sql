-- =============================================================================
-- SIP — Migration R__encargos_seeds
-- =============================================================================
-- Tipo:         Repeatable migration (Flyway)
-- Versión:      4.0 v3
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0003__nuevo_esquema_encargos.sql
--
-- ALCANCE:
--   Carga inicial idempotente de los catálogos del esquema `encargos`:
--     - encargos.tipo_encargo:        4 filas (Persona, Arma, Vehículo, Otro)
--     - encargos.tipo_orden_judicial: 12 filas (tipos del proceso penal chileno)
--   Total: 16 filas
--
-- IDEMPOTENCIA:
--   Cada catálogo se carga vía MERGE matcheando por `nombre` (que es UNIQUE en
--   ambas tablas). Re-ejecutar este script no produce duplicados ni errores.
--   Las filas existentes con el mismo nombre quedan intactas.
--
-- POLÍTICA APLICADA:
--   - WHEN NOT MATCHED BY TARGET THEN INSERT (carga lo nuevo)
--   - WHEN MATCHED THEN UPDATE no se aplica (los catálogos no cambian su nombre
--     una vez cargados; un cambio de nombre rompería el match en re-ejecuciones)
--   - WHEN NOT MATCHED BY SOURCE THEN DELETE NO se aplica (deshabilitado por
--     seguridad — ver el mismo razonamiento en R__auth_seeds.sql)
--
-- TODO PENDIENTE DE VALIDACIÓN CON PDI:
--   - tipo_encargo: confirmar nombres exactos y si "Arma" debiera ser "Armamento"
--     o similar según convención institucional.
--   - tipo_orden_judicial: el catálogo propuesto refleja los tipos estándar del
--     proceso penal chileno (Código Procesal Penal Ley 19.696). Falta confirmar
--     con el equipo legal/jurídico de PDI si:
--       (a) Existe un catálogo oficial PJUD a respetar literalmente
--       (b) Algunos tipos deben subdividirse por modalidad (ej: allanamiento
--           diurno/nocturno, citación común/urgente)
--       (c) Hay tipos institucionales adicionales que la PDI ejecuta y no están
--           en el listado estándar
-- =============================================================================
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


-- =============================================================================
-- SEED — encargos.tipo_encargo
-- =============================================================================
-- Catálogo de tipos de encargo según la descripción documentada en el esquema:
-- "Catálogo de tipos de encargo: personas, armas, vehículos, otros."
-- =============================================================================

MERGE [encargos].[tipo_encargo] AS target
USING (VALUES
    (N'Persona'),
    (N'Arma'),
    (N'Vehículo'),
    (N'Otro')
) AS source (nombre)
ON target.nombre = source.nombre
WHEN NOT MATCHED BY TARGET THEN
    INSERT (nombre)
    VALUES (source.nombre);
GO


-- =============================================================================
-- SEED — encargos.tipo_orden_judicial
-- =============================================================================
-- Catálogo de tipos de orden judicial provenientes del PJUD. Basado en el
-- Código Procesal Penal chileno (Ley 19.696) y la documentación operativa de
-- PDI sobre cumplimiento de órdenes judiciales.
--
-- Categorías representadas:
--   - Cautelares personales: Detención, Aprehensión, Prisión Preventiva, Arraigo
--   - Investigación:         Investigar, Allanamiento
--   - Comparecencia:         Citación, Comparendo
--   - Ejecución:             Conducir
--   - Localización:          Búsqueda y Captura
--   - Cooperación:           Exhorto, Extradición
-- =============================================================================

MERGE [encargos].[tipo_orden_judicial] AS target
USING (VALUES
    (N'Orden de Detención'),
    (N'Orden de Aprehensión'),
    (N'Orden de Prisión Preventiva'),
    (N'Orden de Arraigo'),
    (N'Orden de Investigar'),
    (N'Orden de Allanamiento'),
    (N'Orden de Citación'),
    (N'Orden de Comparendo'),
    (N'Orden de Conducir'),
    (N'Orden de Búsqueda y Captura'),
    (N'Exhorto'),
    (N'Orden de Extradición')
) AS source (nombre)
ON target.nombre = source.nombre
WHEN NOT MATCHED BY TARGET THEN
    INSERT (nombre)
    VALUES (source.nombre);
GO


-- =============================================================================
-- FIN — R__encargos_seeds
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--
--   SELECT COUNT(*) FROM [encargos].[tipo_encargo];           -- esperado: >= 4
--   SELECT COUNT(*) FROM [encargos].[tipo_orden_judicial];    -- esperado: >= 12
--
--   -- Listar el contenido cargado:
--   SELECT id_tipo_encargo, nombre
--     FROM [encargos].[tipo_encargo]
--     ORDER BY id_tipo_encargo;
--
--   SELECT id_tipo_orden_judicial, nombre
--     FROM [encargos].[tipo_orden_judicial]
--     ORDER BY id_tipo_orden_judicial;
-- =============================================================================
