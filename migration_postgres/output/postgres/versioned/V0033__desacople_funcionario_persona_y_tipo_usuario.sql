/* =============================================================================
 V0033 â€” Desacople funcionario<->persona (secuencia) + id_funcionario nullable
 PDI Chile â€” SIP. SQL Server. Flyway. Sigue a V0032. Requiere V0001..V0032.

 PARTE A: organizacion.funcionario gana identidad propia (secuencia) y su
 vinculo a persona pasa a la columna nullable id_persona (1:1).
 PARTE B: auth.usuario.id_funcionario pasa a NULLABLE (flexibilidad para
 futuros usuarios no asociados a funcionario). NO se modela tipo de
 usuario: los procesos batch se marcan por convencion de aplicacion
 (codigos altos en id_usuario_creador), sin filas de usuario.

 Idempotente. Transaccion por-migracion de Flyway. XACT_ABORT ON.

 Notas de implementacion verificadas contra el repo:
 - FK funcionario->persona se llama fk_func_persona (baseline V0001).
 - auth.usuario.id_funcionario participa en la FK saliente fk_usuario_funcionario
 y en el UNIQUE uq_usuario_funcionario (V0002); ambos deben soltarse antes del
 ALTER COLUMN y reponerse despues (FK recreada; UNIQUE -> indice filtrado).
 ============================================================================= */

SET XACT_ABORT ON;
SET NOCOUNT ON;

/* ===================== PARTE A â€” funcionario ============================== */

/* A1) Soltar la FK shared-PK funcionario -> persona */
IF EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = N'fk_func_persona'
 AND parent_object_id = OBJECT_ID(N'organizacion.funcionario'))
 ALTER TABLE organizacion.funcionario DROP CONSTRAINT fk_func_persona;

/* A2) Agregar id_persona (nullable) */
IF COL_LENGTH(N'organizacion.funcionario', N'id_persona') IS NULL
 ALTER TABLE organizacion.funcionario ADD id_persona INT NULL;

/* A2b) Poblar id_persona con el id_funcionario actual (preserva vinculo historico) */
UPDATE organizacion.funcionario
 SET id_persona = id_funcionario
 WHERE id_persona IS NULL;

/* A3) FK opcional id_persona -> personas.persona */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = N'fk_funcionario_persona'
 AND parent_object_id = OBJECT_ID(N'organizacion.funcionario'))
 ALTER TABLE organizacion.funcionario WITH CHECK
 ADD CONSTRAINT fk_funcionario_persona
 FOREIGN KEY(id_persona) REFERENCES personas.persona(id_persona);

/* A3b) Relacion 1:1 persona<->funcionario: indice unico FILTRADO sobre id_persona.
 Filtrado para permitir varios funcionarios SIN persona (id_persona NULL). */
IF NOT EXISTS (SELECT 1 FROM sys.indexes
 WHERE name = N'ux_funcionario_persona'
 AND object_id = OBJECT_ID(N'organizacion.funcionario'))
 CREATE UNIQUE NONCLUSTERED INDEX ux_funcionario_persona
 ON organizacion.funcionario (id_persona)
 WHERE id_persona IS NOT NULL;

/* A4) SEQUENCE para id_funcionario */
IF NOT EXISTS (SELECT 1 FROM sys.sequences
 WHERE name = N'seq_funcionario' AND schema_id = SCHEMA_ID(N'organizacion'))
 EXEC(N'CREATE SEQUENCE organizacion.seq_funcionario AS INT START WITH 1 INCREMENT BY 1;');

/* A4b) Sembrar la secuencia en MAX(id_funcionario)+1 de ESTA base */
DECLARE @next INT = (SELECT ISNULL(MAX(id_funcionario), 0) + 1 FROM organizacion.funcionario);
DECLARE @sqlSeq varchar(200) =
 N'ALTER SEQUENCE organizacion.seq_funcionario RESTART WITH ' + CAST(@next AS varchar(20)) + N';';
EXEC sys.sp_executesql @sqlSeq;
PRINT CONCAT('V0033: seq_funcionario reiniciada en ', @next);

/* A5) DEFAULT: conectar la secuencia a id_funcionario */
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints
 WHERE name = N'df_funcionario_id'
 AND parent_object_id = OBJECT_ID(N'organizacion.funcionario'))
 ALTER TABLE organizacion.funcionario
 ADD CONSTRAINT df_funcionario_id
 DEFAULT (NEXT VALUE FOR organizacion.seq_funcionario) FOR id_funcionario;

/* A6) Descripciones */
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
 WHERE major_id = OBJECT_ID(N'organizacion.funcionario')
 AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'organizacion.funcionario'), N'id_funcionario', 'ColumnId')
 AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'PK con identidad propia. El valor se asigna desde la secuencia organizacion.seq_funcionario (via NEXT VALUE FOR en los SP, o por el DEFAULT df_funcionario_id). No asignar valores arbitrarios. Ya no equivale a id_persona.',
 @level0type=N'SCHEMA',@level0name=N'organizacion',@level1type=N'TABLE',@level1name=N'funcionario',@level2type=N'COLUMN',@level2name=N'id_funcionario';

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
 WHERE major_id = OBJECT_ID(N'organizacion.funcionario')
 AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'organizacion.funcionario'), N'id_persona', 'ColumnId')
 AND name = N'MS_Description')
 EXEC sys.sp_addextendedproperty @name=N'MS_Description',
 @value=N'Vinculo OPCIONAL a personas.persona (1:1). NULL si no aplica.',
 @level0type=N'SCHEMA',@level0name=N'organizacion',@level1type=N'TABLE',@level1name=N'funcionario',@level2type=N'COLUMN',@level2name=N'id_persona';

/* ===================== PARTE B â€” auth.usuario.id_funcionario nullable ===== */

/* B1) Soltar la FK SALIENTE fk_usuario_funcionario (bloquea el ALTER COLUMN) */
IF EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = N'fk_usuario_funcionario'
 AND parent_object_id = OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario DROP CONSTRAINT fk_usuario_funcionario;

/* B2) Soltar el UNIQUE total uq_usuario_funcionario (se repone como filtrado) */
IF EXISTS (SELECT 1 FROM sys.key_constraints
 WHERE name = N'uq_usuario_funcionario'
 AND parent_object_id = OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario DROP CONSTRAINT uq_usuario_funcionario;

/* B3) id_funcionario -> NULLABLE */
IF EXISTS (SELECT 1 FROM sys.columns
 WHERE object_id = OBJECT_ID(N'auth.usuario')
 AND name = N'id_funcionario' AND is_nullable = 0)
 ALTER TABLE auth.usuario ALTER COLUMN id_funcionario INT NULL;

/* B4) Recrear la FK saliente a funcionario (sobre columna ya nullable) */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
 WHERE name = N'fk_usuario_funcionario'
 AND parent_object_id = OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario WITH CHECK
 ADD CONSTRAINT fk_usuario_funcionario
 FOREIGN KEY(id_funcionario) REFERENCES organizacion.funcionario(id_funcionario);

/* B5) Reponer unicidad como indice FILTRADO: 1:1 usuario<->funcionario solo entre
 usuarios que tienen funcionario; permite varios usuarios con id_funcionario NULL. */
IF NOT EXISTS (SELECT 1 FROM sys.indexes
 WHERE name = N'ux_usuario_funcionario'
 AND object_id = OBJECT_ID(N'auth.usuario'))
 CREATE UNIQUE NONCLUSTERED INDEX ux_usuario_funcionario
 ON auth.usuario (id_funcionario)
 WHERE id_funcionario IS NOT NULL;

PRINT 'V0033: completado (Parte A funcionario + Parte B id_funcionario nullable).';

