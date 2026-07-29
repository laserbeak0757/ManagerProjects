# Inventory Summary (Structure First)

Fuente analizada
- migrations/versioned
- migrations/repeatable

Conteos principales
- Versioned
  - CREATE TABLE: 275
  - ALTER TABLE: 2767
  - FOREIGN KEY: 1152
  - CREATE INDEX: 95
- Tipos/constructs SQL Server detectados en versioned
  - IDENTITY(: 236
  - UNIQUEIDENTIFIER: 1
  - DATETIME2: 844
  - SYSUTCDATETIME(): 260
  - BIT: 253
  - TINYINT: 17
  - NVARCHAR(: 600
  - VARCHAR(: 616
  - NVARCHAR(MAX): 29
  - PERSISTED: 3
  - ON [PRIMARY]: 17
  - WITH (...): 15
- Repeatable seeds
  - MERGE: 159
  - INSERT INTO: 683
  - GETDATE()/SYSUTCDATETIME(): 1478
- Repeatable programmability (fuera de alcance inicial)
  - CREATE PROCEDURE / CREATE OR ALTER PROCEDURE: 150
  - OPENJSON: 10
  - JSON_VALUE: 109
  - TRY_CONVERT: 15
  - SCOPE_IDENTITY(): 27

Esquemas detectados (CREATE SCHEMA)
- analitica
- archivos
- auth
- casos
- catalogo_bienes
- configuracion
- cooperacion_int
- debe
- denuncias
- diligencias
- documentos
- encargos
- evidencias
- investigacion
- log_tmp
- migracion
- organizacion
- personas
- tareas
- ubicacion
- vehiculos

Distribucion de tablas por esquema (CREATE TABLE)
- personas: 39
- diligencias: 25
- evidencias: 23
- denuncias: 22
- investigacion: 21
- casos: 19
- tareas: 13
- ubicacion: 11
- auth: 10
- organizacion: 9
- analitica: 9
- vehiculos: 8
- encargos: 8
- cooperacion_int: 7
- catalogo_bienes: 6
- migracion: 4
- archivos: 4
- configuracion: 3

Conclusion de portabilidad
- Alta portabilidad para estructura relacional (schemas/tables/PK/FK/indexes).
- Esfuerzo medio en conversion de sintaxis SQL Server.
- SPs y funciones pueden diferirse sin bloquear una primera salida util en Postgres.
