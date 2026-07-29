# Conversion Checklist (Structure + Seeds)

Pre-migracion
- [ ] Congelar alcance: solo versioned + repeatable seeds.
- [ ] Excluir *_programmability.sql en fase inicial.
- [ ] Definir si timestamps seran timestamp o timestamptz.
- [ ] Definir politica de booleans para campos bit/tinyint.

Extraccion
- [ ] Copiar migrations/versioned a folder de trabajo.
- [ ] Copiar migrations/repeatable/*_seeds.sql a folder de trabajo.
- [ ] Mantener orden de versioned por prefijo VXXXX.

Transformacion automatica
- [ ] Remover GO.
- [ ] Remover brackets [ ].
- [ ] Reemplazar tipos segun matriz.
- [ ] Reemplazar IDENTITY(1,1).
- [ ] Reemplazar SYSUTCDATETIME()/GETDATE().
- [ ] Remover ON [PRIMARY] y WITH (...) no compatibles.

Transformacion semiautomatica
- [ ] Revisar CHECK constraints.
- [ ] Revisar indices parciales.
- [ ] Revisar columnas con PERSISTED.
- [ ] Revisar uso de UNIQUEIDENTIFIER.

Seeds
- [ ] Reemplazar MERGE por INSERT ... ON CONFLICT.
- [ ] Revisar defaults de auditoria y fechas.

Validacion
- [ ] Conteo tablas por esquema (source vs target).
- [ ] Conteo PK/FK/indexes (source vs target).
- [ ] Ejecutar carga minima de datos semilla.
- [ ] Probar insercion y borrado en tablas con FK criticas.

Post-fase
- [ ] Documentar gaps para SPs.
- [ ] Planificar fase de programabilidad en PL/pgSQL.
