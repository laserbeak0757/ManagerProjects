/* =============================================================================
   V0034 — Separacion del esquema [tareas] en [tareas] + [documentos]
   PDI Chile — SIP. SQL Server. Flyway.   Sigue a V0033. Requiere V0001..V0033.

   Mueve 9 tablas del subsistema de gestion documental desde [tareas] al nuevo
   esquema [documentos], mediante ALTER SCHEMA ... TRANSFER. El TRANSFER preserva
   automaticamente TODAS las constraints (PK, FK, UQ, DEFAULT, CHECK) e indices;
   no hay que recrear nada. Las 2 FKs que pasan a cruzar la frontera
   (tarea_documento -> documento, tipo_tarea_tipo_documento -> tipo_documento)
   se conservan intactas y siguen validando entre esquemas.

   Tablas que se mueven a [documentos] (9):
     documento, version_documento, tipo_documento, firma_version_documento,
     tipo_firma, comentario_documento, comentario_documento_nodo, nodo,
     documento_denuncia
   Tablas que permanecen en [tareas] (11):
     tarea, tipo_tarea, estado_tarea, tipo_estado_tarea, evaluacion_comentario,
     bandeja, tarea_denuncia, tarea_diligencia, tipo_tarea_tipo_documento,
     tarea_documento, tarea_archivo_adjunto

   Verificado contra el script completo: 0 FKs entrantes externas, 0 vistas,
   0 triggers, 0 synonyms sobre las tablas que se mueven. Los 7 SP/funciones que
   las referencian se actualizan en los repetibles R__ correspondientes (no aqui).

   Idempotente. Transaccion por-migracion de Flyway. XACT_ABORT ON.
   ============================================================================= */

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

/* 1) Crear el esquema documentos (si no existe).
   CREATE SCHEMA debe ser la primera sentencia de su lote. */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'documentos')
    EXEC(N'CREATE SCHEMA documentos AUTHORIZATION dbo;');
GO

/* 2) Mover las tablas a [documentos] (idempotente: solo si aun estan en tareas).
   El orden no afecta: ALTER SCHEMA TRANSFER preserva las FKs aunque las tablas
   relacionadas se muevan en sentencias separadas. */
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'documento')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'documento')
    ALTER SCHEMA documentos TRANSFER tareas.documento;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'version_documento')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'version_documento')
    ALTER SCHEMA documentos TRANSFER tareas.version_documento;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'tipo_documento')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'tipo_documento')
    ALTER SCHEMA documentos TRANSFER tareas.tipo_documento;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'firma_version_documento')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'firma_version_documento')
    ALTER SCHEMA documentos TRANSFER tareas.firma_version_documento;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'tipo_firma')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'tipo_firma')
    ALTER SCHEMA documentos TRANSFER tareas.tipo_firma;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'comentario_documento')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'comentario_documento')
    ALTER SCHEMA documentos TRANSFER tareas.comentario_documento;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'comentario_documento_nodo')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'comentario_documento_nodo')
    ALTER SCHEMA documentos TRANSFER tareas.comentario_documento_nodo;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'nodo')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'nodo')
    ALTER SCHEMA documentos TRANSFER tareas.nodo;
GO
IF  EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'tareas' AND t.name=N'documento_denuncia')
AND NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
            WHERE s.name=N'documentos' AND t.name=N'documento_denuncia')
    ALTER SCHEMA documentos TRANSFER tareas.documento_denuncia;
GO

PRINT 'V0034: completado. 9 tablas movidas de [tareas] a [documentos].';
GO
