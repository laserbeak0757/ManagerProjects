# Migration Postgres Package

Objetivo
- Migrar la estructura de datos desde SQL Server a PostgreSQL, dejando fuera la programabilidad (SP/functions) en una primera fase.

Alcance de esta carpeta
- Inventario tecnico del estado actual.
- Mapeo SQL Server -> PostgreSQL.
- Checklist de conversion.
- Plan de ejecucion por etapas.
- Scripts para exportar, convertir y validar.

Entrada esperada
- Migraciones versionadas en: migrations/versioned
- Seeds repetibles en: migrations/repeatable/*_seeds.sql
- Programabilidad (fuera de alcance inicial): migrations/repeatable/*_programmability.sql

Salida esperada
- SQL convertido a Postgres en: migration_postgres/output/postgres
- Reportes en: migration_postgres/output/reports

Resumen rapido del analisis
- Versioned
  - CREATE TABLE: 275
  - ALTER TABLE: 2767
  - FOREIGN KEY: 1152
  - CREATE INDEX: 95
  - IDENTITY(: 236
  - DATETIME2: 844
  - BIT: 253
  - TINYINT: 17
  - NVARCHAR(: 600
  - VARCHAR(: 616
- Repeatable seeds
  - MERGE: 159
  - INSERT INTO: 683
- Repeatable programmability
  - CREATE PROCEDURE / CREATE OR ALTER PROCEDURE: 150
  - OPENJSON: 10
  - JSON_VALUE: 109
  - TRY_CONVERT: 15
  - SCOPE_IDENTITY(): 27

Como usar
1. Exportar solo estructura + seeds:
   - powershell -ExecutionPolicy Bypass -File migration_postgres/scripts/01_export_schema_and_seeds.ps1
2. Convertir SQL Server -> PostgreSQL:
   - powershell -ExecutionPolicy Bypass -File migration_postgres/scripts/02_convert_sqlserver_to_postgres.ps1
3. Validar conversion:
   - powershell -ExecutionPolicy Bypass -File migration_postgres/scripts/03_validate_postgres_sql.ps1
4. Ejecutar todo en secuencia:
   - powershell -ExecutionPolicy Bypass -File migration_postgres/scripts/run_all.ps1

Notas
- Este paquete no reescribe SPs en PL/pgSQL.
- El foco es estructura y seeds para habilitar una base funcional inicial en Postgres.
