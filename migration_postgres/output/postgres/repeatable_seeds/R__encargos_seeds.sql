-- =============================================================================
-- SIP â€” Migration R__encargos_seeds
-- =============================================================================
-- Tipo: Repeatable migration (Flyway)
-- VersiÃ³n: 4.0 v3
-- Compatible: SQL Server 2017+ (forward-compatible 2022)
-- Depende de: V0003__nuevo_esquema_encargos.sql
--
-- ALCANCE:
-- Carga inicial idempotente de los catÃ¡logos del esquema `encargos`:
-- - encargos.tipo_encargo: 4 filas (Persona, Arma, VehÃ­culo, Otro)
-- - encargos.tipo_orden_judicial: 12 filas (tipos del proceso penal chileno)
-- Total: 16 filas
--
-- IDEMPOTENCIA:
-- Cada catÃ¡logo se carga vÃ­a MERGE matcheando por `nombre` (que es UNIQUE en
-- ambas tablas). Re-ejecutar este script no produce duplicados ni errores.
-- Las filas existentes con el mismo nombre quedan intactas.
--
-- POLÃTICA APLICADA:
-- - WHEN NOT MATCHED BY TARGET THEN INSERT (carga lo nuevo)
-- - WHEN MATCHED THEN UPDATE no se aplica (los catÃ¡logos no cambian su nombre
-- una vez cargados; un cambio de nombre romperÃ­a el match en re-ejecuciones)
-- - WHEN NOT MATCHED BY SOURCE THEN DELETE NO se aplica (deshabilitado por
-- seguridad â€” ver el mismo razonamiento en R__auth_seeds.sql)
--
-- TODO PENDIENTE DE VALIDACIÃ“N CON PDI:
-- - tipo_encargo: confirmar nombres exactos y si "Arma" debiera ser "Armamento"
-- o similar segÃºn convenciÃ³n institucional.
-- - tipo_orden_judicial: el catÃ¡logo propuesto refleja los tipos estÃ¡ndar del
-- proceso penal chileno (CÃ³digo Procesal Penal Ley 19.696). Falta confirmar
-- con el equipo legal/jurÃ­dico de PDI si:
-- (a) Existe un catÃ¡logo oficial PJUD a respetar literalmente
-- (b) Algunos tipos deben subdividirse por modalidad (ej: allanamiento
-- diurno/nocturno, citaciÃ³n comÃºn/urgente)
-- (c) Hay tipos institucionales adicionales que la PDI ejecuta y no estÃ¡n
-- en el listado estÃ¡ndar
-- =============================================================================
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;


-- =============================================================================
-- SEED â€” encargos.tipo_encargo
-- =============================================================================
-- CatÃ¡logo de tipos de encargo segÃºn la descripciÃ³n documentada en el esquema:
-- "CatÃ¡logo de tipos de encargo: personas, armas, vehÃ­culos, otros."
-- =============================================================================

MERGE encargos.tipo_encargo AS target
USING (VALUES
 (N'Persona'),
 (N'Arma'),
 (N'VehÃ­culo'),
 (N'Otro')
) AS source (nombre)
ON target.nombre = source.nombre
WHEN NOT MATCHED BY TARGET THEN
 INSERT (nombre)
 VALUES (source.nombre);


-- =============================================================================
-- SEED â€” encargos.tipo_orden_judicial
-- =============================================================================
-- CatÃ¡logo de tipos de orden judicial provenientes del PJUD. Basado en el
-- CÃ³digo Procesal Penal chileno (Ley 19.696) y la documentaciÃ³n operativa de
-- PDI sobre cumplimiento de Ã³rdenes judiciales.
--
-- CategorÃ­as representadas:
-- - Cautelares personales: DetenciÃ³n, AprehensiÃ³n, PrisiÃ³n Preventiva, Arraigo
-- - InvestigaciÃ³n: Investigar, Allanamiento
-- - Comparecencia: CitaciÃ³n, Comparendo
-- - EjecuciÃ³n: Conducir
-- - LocalizaciÃ³n: BÃºsqueda y Captura
-- - CooperaciÃ³n: Exhorto, ExtradiciÃ³n
-- =============================================================================

MERGE encargos.tipo_orden_judicial AS target
USING (VALUES
 (N'Orden de DetenciÃ³n'),
 (N'Orden de AprehensiÃ³n'),
 (N'Orden de PrisiÃ³n Preventiva'),
 (N'Orden de Arraigo'),
 (N'Orden de Investigar'),
 (N'Orden de Allanamiento'),
 (N'Orden de CitaciÃ³n'),
 (N'Orden de Comparendo'),
 (N'Orden de Conducir'),
 (N'Orden de BÃºsqueda y Captura'),
 (N'Exhorto'),
 (N'Orden de ExtradiciÃ³n')
) AS source (nombre)
ON target.nombre = source.nombre
WHEN NOT MATCHED BY TARGET THEN
 INSERT (nombre)
 VALUES (source.nombre);


-- =============================================================================
-- FIN â€” R__encargos_seeds
-- =============================================================================
-- ValidaciÃ³n recomendada (despuÃ©s de ejecutar):
--
-- SELECT COUNT(*) FROM encargos.tipo_encargo; -- esperado: >= 4
-- SELECT COUNT(*) FROM encargos.tipo_orden_judicial; -- esperado: >= 12
--
-- -- Listar el contenido cargado:
-- SELECT id_tipo_encargo, nombre
-- FROM encargos.tipo_encargo
-- ORDER BY id_tipo_encargo;
--
-- SELECT id_tipo_orden_judicial, nombre
-- FROM encargos.tipo_orden_judicial
-- ORDER BY id_tipo_orden_judicial;
-- =============================================================================

