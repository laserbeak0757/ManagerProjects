/* =============================================================================
 V0037 â€” Desacople nivel de confidencialidad: de archivo hacia archivo_vinculo
 PDI Chile â€” SIP. SQL Server. Flyway.

 El nivel de confidencialidad depende del contexto de uso del archivo,
 no del archivo fÃ­sico en sÃ­. Un mismo archivo puede tener distinto nivel segÃºn
 la entidad a la que estÃ¡ vinculado.

 Ejemplo:
 archivo 100 vinculado a denuncia 123 -> Reservado
 archivo 100 vinculado a diligencia 456 -> Secreto

 Cambios
 - Agrega id_nivel_confidencialidad a archivos.archivo_vinculo.
 - Migra datos existentes: copia el nivel del archivo hacia sus vÃ­nculos.
 - Crea FK hacia archivos.cat_nivel_confidencialidad.
 - Deja archivo.id_nivel_confidencialidad intacto (deprecated, no utilizado
 por lÃ³gica nueva). No se elimina para no romper ambientes existentes.

 Idempotente. TransacciÃ³n por migraciÃ³n de Flyway. XACT_ABORT ON.

 ============================================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON;
SET NOCOUNT ON;


/* 1) Agrega id_nivel_confidencialidad a archivo_vinculo */
IF COL_LENGTH(N'archivos.archivo_vinculo', N'id_nivel_confidencialidad') IS NULL
 ALTER TABLE archivos.archivo_vinculo
 ADD id_nivel_confidencialidad INT NULL;


/* 2) Migrar datos existentes: copiar nivel del archivo hacia sus vÃ­nculos
 Solo para vÃ­nculos que aÃºn no tienen nivel asignado y cuyo archivo sÃ­ lo tiene */
UPDATE av
 SET av.id_nivel_confidencialidad = a.id_nivel_confidencialidad
 FROM archivos.archivo_vinculo av
 INNER JOIN archivos.archivo a ON a.id_archivo = av.id_archivo
 WHERE av.id_nivel_confidencialidad IS NULL
 AND a.id_nivel_confidencialidad IS NOT NULL;


/* 3) Crear FK hacia cat_nivel_confidencialidad */
IF NOT EXISTS ( SELECT 1 FROM sys.foreign_keys
 WHERE name = N'fk_archivo_vinculo_nivel_confidencialidad'
 AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
 ALTER TABLE archivos.archivo_vinculo WITH CHECK
 ADD CONSTRAINT fk_archivo_vinculo_nivel_confidencialidad
 FOREIGN KEY (id_nivel_confidencialidad)
 REFERENCES archivos.cat_nivel_confidencialidad (id_nivel);


/* 4) Marcar archivo.id_nivel_confidencialidad como deprecated en el catÃ¡logo */
IF NOT EXISTS ( SELECT 1 FROM sys.extended_properties
 WHERE major_id = OBJECT_ID(N'archivos.archivo')
 AND minor_id = ( SELECT column_id FROM sys.columns
 WHERE object_id = OBJECT_ID(N'archivos.archivo')
 AND name = N'id_nivel_confidencialidad')
 AND name = N'MS_Description')
 EXEC sp_addextendedproperty
 @name = N'MS_Description',
 @value = N'DEPRECATED â€” Usar archivo_vinculo.id_nivel_confidencialidad. Columna conservada por compatibilidad.',
 @level0type = N'SCHEMA', @level0name = N'archivos',
 @level1type = N'TABLE', @level1name = N'archivo',
 @level2type = N'COLUMN', @level2name = N'id_nivel_confidencialidad';


PRINT 'V0037: completado (id_nivel_confidencialidad migrado a archivo_vinculo).';

