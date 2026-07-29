/* =============================================================================
 V0026 â€” Parte aditiva del patron de auditoria de 6 columnas
 PDI Chile â€” SIP. SQL Server. Flyway.

 Alcance (244 tablas; excluye dbo.flyway_schema_history):
 - No-catalogo (152): id_usuario_creador, id_usuario_modificador,
 id_usuario_eliminador, fecha_creacion, fecha_actualizacion, fecha_eliminacion_logica
 - Catalogos cat_* (92): las 5 anteriores MENOS id_usuario_creador

 Esta pasada: TODO lo que se agrega es NULLABLE (sin DEFAULT en fecha_creacion),
 para no afectar datos existentes ni los seeds. El endurecimiento a NOT NULL
 de id_usuario_creador/fecha_creacion queda para una migracion futura, junto
 con el rediseno de usuarios de proceso.

 - Solo agrega columnas/FKs faltantes (idempotente: COL_LENGTH y sys.foreign_keys).
 - Requiere V0025 aplicada antes (nombres ya renombrados).
 - Asume transaccion por-migracion de Flyway. Refuerzo: SET XACT_ABORT ON.
 - Columnas y FKs en batches separados (GO) por esquema: una FK no puede
 referenciar una columna agregada en el mismo batch.
 ============================================================================= */

SET XACT_ABORT ON;
SET NOCOUNT ON;

/* ============================== ESQUEMA: analitica (9 tablas, +43 col, +26 fk) ============================== */

/* --- analitica: columnas --- */
IF COL_LENGTH(N'analitica.aplicacion_reporte', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.aplicacion_reporte ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.aplicacion_reporte', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.aplicacion_reporte ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.aplicacion_reporte', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.aplicacion_reporte ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.aplicacion_reporte', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.aplicacion_reporte ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'analitica.aplicacion_reporte', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.aplicacion_reporte ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.cat_tipo_reporte', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.cat_tipo_reporte ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.cat_tipo_reporte', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.cat_tipo_reporte ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.cat_tipo_reporte', N'fecha_creacion') IS NULL
 ALTER TABLE analitica.cat_tipo_reporte ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'analitica.cat_tipo_reporte', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.cat_tipo_reporte ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'analitica.cat_tipo_reporte', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.cat_tipo_reporte ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.configuracion_reporte_periodico', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.configuracion_reporte_periodico ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.configuracion_reporte_periodico', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.configuracion_reporte_periodico ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.configuracion_reporte_periodico', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.configuracion_reporte_periodico ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.configuracion_reporte_periodico', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.configuracion_reporte_periodico ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'analitica.configuracion_reporte_periodico', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.configuracion_reporte_periodico ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.foco_caso', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.foco_caso ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.foco_caso', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.foco_caso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.foco_caso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.foco_caso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.foco_caso', N'fecha_creacion') IS NULL
 ALTER TABLE analitica.foco_caso ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'analitica.foco_caso', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.foco_caso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'analitica.foco_caso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.foco_caso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.foco_investigativo', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.foco_investigativo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.foco_investigativo', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.foco_investigativo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.foco_investigativo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.foco_investigativo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.foco_investigativo', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.foco_investigativo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'analitica.foco_investigativo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.foco_investigativo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.matriz_analisis', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.matriz_analisis ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.matriz_analisis', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.matriz_analisis ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.matriz_analisis', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.matriz_analisis ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.matriz_analisis', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.matriz_analisis ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.reporte_analitico', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.reporte_analitico ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.reporte_analitico', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.reporte_analitico ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.reporte_analitico', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.reporte_analitico ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.reporte_analitico', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.reporte_analitico ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.reporte_analitico_caso', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.reporte_analitico_caso ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.reporte_analitico_caso', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.reporte_analitico_caso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.reporte_analitico_caso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.reporte_analitico_caso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.reporte_analitico_caso', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.reporte_analitico_caso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'analitica.reporte_analitico_caso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE analitica.reporte_analitico_caso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'analitica.vinculo_entidad', N'id_usuario_creador') IS NULL
 ALTER TABLE analitica.vinculo_entidad ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'analitica.vinculo_entidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE analitica.vinculo_entidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'analitica.vinculo_entidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE analitica.vinculo_entidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'analitica.vinculo_entidad', N'fecha_actualizacion') IS NULL
 ALTER TABLE analitica.vinculo_entidad ADD fecha_actualizacion timestamp NULL;

/* --- analitica: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_aplicacion_reporte_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.aplicacion_reporte'))
 ALTER TABLE analitica.aplicacion_reporte WITH CHECK ADD CONSTRAINT fk_aplicacion_reporte_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_aplicacion_reporte_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.aplicacion_reporte'))
 ALTER TABLE analitica.aplicacion_reporte WITH CHECK ADD CONSTRAINT fk_aplicacion_reporte_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_aplicacion_reporte_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.aplicacion_reporte'))
 ALTER TABLE analitica.aplicacion_reporte WITH CHECK ADD CONSTRAINT fk_aplicacion_reporte_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_reporte_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.cat_tipo_reporte'))
 ALTER TABLE analitica.cat_tipo_reporte WITH CHECK ADD CONSTRAINT fk_cat_tipo_reporte_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_reporte_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.cat_tipo_reporte'))
 ALTER TABLE analitica.cat_tipo_reporte WITH CHECK ADD CONSTRAINT fk_cat_tipo_reporte_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_configuracion_reporte_periodico_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.configuracion_reporte_periodico'))
 ALTER TABLE analitica.configuracion_reporte_periodico WITH CHECK ADD CONSTRAINT fk_configuracion_reporte_periodico_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_configuracion_reporte_periodico_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.configuracion_reporte_periodico'))
 ALTER TABLE analitica.configuracion_reporte_periodico WITH CHECK ADD CONSTRAINT fk_configuracion_reporte_periodico_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_configuracion_reporte_periodico_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.configuracion_reporte_periodico'))
 ALTER TABLE analitica.configuracion_reporte_periodico WITH CHECK ADD CONSTRAINT fk_configuracion_reporte_periodico_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_foco_caso_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.foco_caso'))
 ALTER TABLE analitica.foco_caso WITH CHECK ADD CONSTRAINT fk_foco_caso_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_foco_caso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.foco_caso'))
 ALTER TABLE analitica.foco_caso WITH CHECK ADD CONSTRAINT fk_foco_caso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_foco_caso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.foco_caso'))
 ALTER TABLE analitica.foco_caso WITH CHECK ADD CONSTRAINT fk_foco_caso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_foco_investigativo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.foco_investigativo'))
 ALTER TABLE analitica.foco_investigativo WITH CHECK ADD CONSTRAINT fk_foco_investigativo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_foco_investigativo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.foco_investigativo'))
 ALTER TABLE analitica.foco_investigativo WITH CHECK ADD CONSTRAINT fk_foco_investigativo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_foco_investigativo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.foco_investigativo'))
 ALTER TABLE analitica.foco_investigativo WITH CHECK ADD CONSTRAINT fk_foco_investigativo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_matriz_analisis_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.matriz_analisis'))
 ALTER TABLE analitica.matriz_analisis WITH CHECK ADD CONSTRAINT fk_matriz_analisis_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_matriz_analisis_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.matriz_analisis'))
 ALTER TABLE analitica.matriz_analisis WITH CHECK ADD CONSTRAINT fk_matriz_analisis_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_matriz_analisis_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.matriz_analisis'))
 ALTER TABLE analitica.matriz_analisis WITH CHECK ADD CONSTRAINT fk_matriz_analisis_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_reporte_analitico_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.reporte_analitico'))
 ALTER TABLE analitica.reporte_analitico WITH CHECK ADD CONSTRAINT fk_reporte_analitico_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_reporte_analitico_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.reporte_analitico'))
 ALTER TABLE analitica.reporte_analitico WITH CHECK ADD CONSTRAINT fk_reporte_analitico_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_reporte_analitico_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.reporte_analitico'))
 ALTER TABLE analitica.reporte_analitico WITH CHECK ADD CONSTRAINT fk_reporte_analitico_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_reporte_analitico_caso_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.reporte_analitico_caso'))
 ALTER TABLE analitica.reporte_analitico_caso WITH CHECK ADD CONSTRAINT fk_reporte_analitico_caso_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_reporte_analitico_caso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.reporte_analitico_caso'))
 ALTER TABLE analitica.reporte_analitico_caso WITH CHECK ADD CONSTRAINT fk_reporte_analitico_caso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_reporte_analitico_caso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.reporte_analitico_caso'))
 ALTER TABLE analitica.reporte_analitico_caso WITH CHECK ADD CONSTRAINT fk_reporte_analitico_caso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_vinculo_entidad_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'analitica.vinculo_entidad'))
 ALTER TABLE analitica.vinculo_entidad WITH CHECK ADD CONSTRAINT fk_vinculo_entidad_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_vinculo_entidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'analitica.vinculo_entidad'))
 ALTER TABLE analitica.vinculo_entidad WITH CHECK ADD CONSTRAINT fk_vinculo_entidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_vinculo_entidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'analitica.vinculo_entidad'))
 ALTER TABLE analitica.vinculo_entidad WITH CHECK ADD CONSTRAINT fk_vinculo_entidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: archivos (4 tablas, +21 col, +10 fk) ============================== */

/* --- archivos: columnas --- */
IF COL_LENGTH(N'archivos.archivo', N'id_usuario_creador') IS NULL
 ALTER TABLE archivos.archivo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'archivos.archivo', N'id_usuario_modificador') IS NULL
 ALTER TABLE archivos.archivo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'archivos.archivo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE archivos.archivo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'archivos.archivo', N'fecha_creacion') IS NULL
 ALTER TABLE archivos.archivo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'archivos.archivo', N'fecha_actualizacion') IS NULL
 ALTER TABLE archivos.archivo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'archivos.archivo_vinculo', N'id_usuario_creador') IS NULL
 ALTER TABLE archivos.archivo_vinculo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'archivos.archivo_vinculo', N'id_usuario_modificador') IS NULL
 ALTER TABLE archivos.archivo_vinculo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'archivos.archivo_vinculo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE archivos.archivo_vinculo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'archivos.archivo_vinculo', N'fecha_creacion') IS NULL
 ALTER TABLE archivos.archivo_vinculo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'archivos.archivo_vinculo', N'fecha_actualizacion') IS NULL
 ALTER TABLE archivos.archivo_vinculo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'archivos.archivo_vinculo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE archivos.archivo_vinculo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'archivos.cat_nivel_confidencialidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE archivos.cat_nivel_confidencialidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'archivos.cat_nivel_confidencialidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE archivos.cat_nivel_confidencialidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'archivos.cat_nivel_confidencialidad', N'fecha_creacion') IS NULL
 ALTER TABLE archivos.cat_nivel_confidencialidad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'archivos.cat_nivel_confidencialidad', N'fecha_actualizacion') IS NULL
 ALTER TABLE archivos.cat_nivel_confidencialidad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'archivos.cat_nivel_confidencialidad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE archivos.cat_nivel_confidencialidad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'archivos.cat_tipo_archivo', N'id_usuario_modificador') IS NULL
 ALTER TABLE archivos.cat_tipo_archivo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'archivos.cat_tipo_archivo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE archivos.cat_tipo_archivo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'archivos.cat_tipo_archivo', N'fecha_creacion') IS NULL
 ALTER TABLE archivos.cat_tipo_archivo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'archivos.cat_tipo_archivo', N'fecha_actualizacion') IS NULL
 ALTER TABLE archivos.cat_tipo_archivo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'archivos.cat_tipo_archivo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE archivos.cat_tipo_archivo ADD fecha_eliminacion_logica timestamp NULL;

/* --- archivos: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_archivo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'archivos.archivo'))
 ALTER TABLE archivos.archivo WITH CHECK ADD CONSTRAINT fk_archivo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_archivo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'archivos.archivo'))
 ALTER TABLE archivos.archivo WITH CHECK ADD CONSTRAINT fk_archivo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_archivo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'archivos.archivo'))
 ALTER TABLE archivos.archivo WITH CHECK ADD CONSTRAINT fk_archivo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_archivo_vinculo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
 ALTER TABLE archivos.archivo_vinculo WITH CHECK ADD CONSTRAINT fk_archivo_vinculo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_archivo_vinculo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
 ALTER TABLE archivos.archivo_vinculo WITH CHECK ADD CONSTRAINT fk_archivo_vinculo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_archivo_vinculo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'archivos.archivo_vinculo'))
 ALTER TABLE archivos.archivo_vinculo WITH CHECK ADD CONSTRAINT fk_archivo_vinculo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_confidencialidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'archivos.cat_nivel_confidencialidad'))
 ALTER TABLE archivos.cat_nivel_confidencialidad WITH CHECK ADD CONSTRAINT fk_cat_nivel_confidencialidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_confidencialidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'archivos.cat_nivel_confidencialidad'))
 ALTER TABLE archivos.cat_nivel_confidencialidad WITH CHECK ADD CONSTRAINT fk_cat_nivel_confidencialidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_archivo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'archivos.cat_tipo_archivo'))
 ALTER TABLE archivos.cat_tipo_archivo WITH CHECK ADD CONSTRAINT fk_cat_tipo_archivo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_archivo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'archivos.cat_tipo_archivo'))
 ALTER TABLE archivos.cat_tipo_archivo WITH CHECK ADD CONSTRAINT fk_cat_tipo_archivo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: auth (10 tablas, +58 col, +30 fk) ============================== */

/* --- auth: columnas --- */
IF COL_LENGTH(N'auth.nivel_seguridad', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.nivel_seguridad ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.nivel_seguridad', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.nivel_seguridad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.nivel_seguridad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.nivel_seguridad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.nivel_seguridad', N'fecha_creacion') IS NULL
 ALTER TABLE auth.nivel_seguridad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.nivel_seguridad', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.nivel_seguridad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.nivel_seguridad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.nivel_seguridad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.parametro', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.parametro ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.parametro', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.parametro ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.parametro', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.parametro ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.parametro', N'fecha_creacion') IS NULL
 ALTER TABLE auth.parametro ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.parametro', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.parametro ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.parametro', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.parametro ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.perfil', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.perfil ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.perfil', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.perfil ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.perfil', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.perfil ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.perfil', N'fecha_creacion') IS NULL
 ALTER TABLE auth.perfil ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.perfil', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.perfil ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.perfil', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.perfil ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.perfil_rol', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.perfil_rol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.perfil_rol', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.perfil_rol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.perfil_rol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.perfil_rol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.perfil_rol', N'fecha_creacion') IS NULL
 ALTER TABLE auth.perfil_rol ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.perfil_rol', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.perfil_rol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.perfil_rol', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.perfil_rol ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.perfil_rol_permiso', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.perfil_rol_permiso ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.perfil_rol_permiso', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.perfil_rol_permiso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.perfil_rol_permiso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.perfil_rol_permiso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.perfil_rol_permiso', N'fecha_creacion') IS NULL
 ALTER TABLE auth.perfil_rol_permiso ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.perfil_rol_permiso', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.perfil_rol_permiso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.perfil_rol_permiso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.perfil_rol_permiso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.permiso', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.permiso ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.permiso', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.permiso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.permiso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.permiso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.permiso', N'fecha_creacion') IS NULL
 ALTER TABLE auth.permiso ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.permiso', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.permiso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.permiso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.permiso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.refresh_token', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.refresh_token ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.refresh_token', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.refresh_token ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.refresh_token', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.refresh_token ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.refresh_token', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.refresh_token ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.refresh_token', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.refresh_token ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.rol', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.rol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.rol', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.rol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.rol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.rol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.rol', N'fecha_creacion') IS NULL
 ALTER TABLE auth.rol ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.rol', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.rol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.rol', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.rol ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.usuario', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.usuario ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.usuario', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.usuario ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.usuario', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.usuario ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.usuario', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.usuario ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.usuario', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.usuario ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'auth.usuario_perfil', N'id_usuario_creador') IS NULL
 ALTER TABLE auth.usuario_perfil ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'auth.usuario_perfil', N'id_usuario_modificador') IS NULL
 ALTER TABLE auth.usuario_perfil ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'auth.usuario_perfil', N'id_usuario_eliminador') IS NULL
 ALTER TABLE auth.usuario_perfil ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'auth.usuario_perfil', N'fecha_creacion') IS NULL
 ALTER TABLE auth.usuario_perfil ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'auth.usuario_perfil', N'fecha_actualizacion') IS NULL
 ALTER TABLE auth.usuario_perfil ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'auth.usuario_perfil', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE auth.usuario_perfil ADD fecha_eliminacion_logica timestamp NULL;

/* --- auth: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nivel_seguridad_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.nivel_seguridad'))
 ALTER TABLE auth.nivel_seguridad WITH CHECK ADD CONSTRAINT fk_nivel_seguridad_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nivel_seguridad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.nivel_seguridad'))
 ALTER TABLE auth.nivel_seguridad WITH CHECK ADD CONSTRAINT fk_nivel_seguridad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nivel_seguridad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.nivel_seguridad'))
 ALTER TABLE auth.nivel_seguridad WITH CHECK ADD CONSTRAINT fk_nivel_seguridad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_parametro_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.parametro'))
 ALTER TABLE auth.parametro WITH CHECK ADD CONSTRAINT fk_parametro_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_parametro_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.parametro'))
 ALTER TABLE auth.parametro WITH CHECK ADD CONSTRAINT fk_parametro_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_parametro_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.parametro'))
 ALTER TABLE auth.parametro WITH CHECK ADD CONSTRAINT fk_parametro_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.perfil'))
 ALTER TABLE auth.perfil WITH CHECK ADD CONSTRAINT fk_perfil_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.perfil'))
 ALTER TABLE auth.perfil WITH CHECK ADD CONSTRAINT fk_perfil_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.perfil'))
 ALTER TABLE auth.perfil WITH CHECK ADD CONSTRAINT fk_perfil_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_rol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.perfil_rol'))
 ALTER TABLE auth.perfil_rol WITH CHECK ADD CONSTRAINT fk_perfil_rol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_rol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.perfil_rol'))
 ALTER TABLE auth.perfil_rol WITH CHECK ADD CONSTRAINT fk_perfil_rol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_rol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.perfil_rol'))
 ALTER TABLE auth.perfil_rol WITH CHECK ADD CONSTRAINT fk_perfil_rol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_rol_permiso_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.perfil_rol_permiso'))
 ALTER TABLE auth.perfil_rol_permiso WITH CHECK ADD CONSTRAINT fk_perfil_rol_permiso_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_rol_permiso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.perfil_rol_permiso'))
 ALTER TABLE auth.perfil_rol_permiso WITH CHECK ADD CONSTRAINT fk_perfil_rol_permiso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_perfil_rol_permiso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.perfil_rol_permiso'))
 ALTER TABLE auth.perfil_rol_permiso WITH CHECK ADD CONSTRAINT fk_perfil_rol_permiso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_permiso_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.permiso'))
 ALTER TABLE auth.permiso WITH CHECK ADD CONSTRAINT fk_permiso_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_permiso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.permiso'))
 ALTER TABLE auth.permiso WITH CHECK ADD CONSTRAINT fk_permiso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_permiso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.permiso'))
 ALTER TABLE auth.permiso WITH CHECK ADD CONSTRAINT fk_permiso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_refresh_token_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.refresh_token'))
 ALTER TABLE auth.refresh_token WITH CHECK ADD CONSTRAINT fk_refresh_token_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_refresh_token_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.refresh_token'))
 ALTER TABLE auth.refresh_token WITH CHECK ADD CONSTRAINT fk_refresh_token_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_refresh_token_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.refresh_token'))
 ALTER TABLE auth.refresh_token WITH CHECK ADD CONSTRAINT fk_refresh_token_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_rol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.rol'))
 ALTER TABLE auth.rol WITH CHECK ADD CONSTRAINT fk_rol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_rol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.rol'))
 ALTER TABLE auth.rol WITH CHECK ADD CONSTRAINT fk_rol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_rol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.rol'))
 ALTER TABLE auth.rol WITH CHECK ADD CONSTRAINT fk_rol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_usuario_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario WITH CHECK ADD CONSTRAINT fk_usuario_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_usuario_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario WITH CHECK ADD CONSTRAINT fk_usuario_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_usuario_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.usuario'))
 ALTER TABLE auth.usuario WITH CHECK ADD CONSTRAINT fk_usuario_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_usuario_perfil_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'auth.usuario_perfil'))
 ALTER TABLE auth.usuario_perfil WITH CHECK ADD CONSTRAINT fk_usuario_perfil_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_usuario_perfil_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'auth.usuario_perfil'))
 ALTER TABLE auth.usuario_perfil WITH CHECK ADD CONSTRAINT fk_usuario_perfil_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_usuario_perfil_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'auth.usuario_perfil'))
 ALTER TABLE auth.usuario_perfil WITH CHECK ADD CONSTRAINT fk_usuario_perfil_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: casos (17 tablas, +87 col, +44 fk) ============================== */

/* --- casos: columnas --- */
IF COL_LENGTH(N'casos.cat_tipo_rol_persona', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_tipo_rol_persona ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_tipo_rol_persona', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_tipo_rol_persona ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_tipo_rol_persona', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_tipo_rol_persona ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_tipo_rol_persona', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_tipo_rol_persona ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_tipo_rol_persona', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_tipo_rol_persona ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.agrupacion_causa', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.agrupacion_causa ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.agrupacion_causa', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.agrupacion_causa ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.agrupacion_causa', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.agrupacion_causa ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.agrupacion_causa', N'fecha_creacion') IS NULL
 ALTER TABLE casos.agrupacion_causa ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.agrupacion_causa', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.agrupacion_causa ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.agrupacion_causa', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.agrupacion_causa ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.agrupacion_causa_caso', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.agrupacion_causa_caso ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.agrupacion_causa_caso', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.agrupacion_causa_caso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.agrupacion_causa_caso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.agrupacion_causa_caso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.agrupacion_causa_caso', N'fecha_creacion') IS NULL
 ALTER TABLE casos.agrupacion_causa_caso ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.agrupacion_causa_caso', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.agrupacion_causa_caso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.agrupacion_causa_caso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.agrupacion_causa_caso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.asignacion_funcionario', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.asignacion_funcionario ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.asignacion_funcionario', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.asignacion_funcionario ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.asignacion_funcionario', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.asignacion_funcionario ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.asignacion_funcionario', N'fecha_creacion') IS NULL
 ALTER TABLE casos.asignacion_funcionario ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.asignacion_funcionario', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.asignacion_funcionario ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.asignacion_funcionario', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.asignacion_funcionario ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.carpeta', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.carpeta ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.carpeta', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.carpeta ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.carpeta', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.carpeta ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.carpeta', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.carpeta ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.carpeta_colaborador', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.carpeta_colaborador ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.carpeta_colaborador', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.carpeta_colaborador ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.carpeta_colaborador', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.carpeta_colaborador ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.carpeta_colaborador', N'fecha_creacion') IS NULL
 ALTER TABLE casos.carpeta_colaborador ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.carpeta_colaborador', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.carpeta_colaborador ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.carpeta_colaborador', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.carpeta_colaborador ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.caso', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.caso ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.caso', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.caso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.caso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.caso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.caso_historial_estado', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.caso_historial_estado ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.caso_historial_estado', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.caso_historial_estado ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.caso_historial_estado', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.caso_historial_estado ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.caso_historial_estado', N'fecha_creacion') IS NULL
 ALTER TABLE casos.caso_historial_estado ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.caso_historial_estado', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.caso_historial_estado ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.caso_historial_estado', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.caso_historial_estado ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.caso_persona_rol', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.caso_persona_rol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.caso_persona_rol', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.caso_persona_rol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.caso_persona_rol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.caso_persona_rol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.caso_persona_rol', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.caso_persona_rol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.caso_referencia_judicial', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.caso_referencia_judicial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.caso_referencia_judicial', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.caso_referencia_judicial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.caso_referencia_judicial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.caso_referencia_judicial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.caso_referencia_judicial', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.caso_referencia_judicial ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.caso_referencia_judicial', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.caso_referencia_judicial ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.cat_complejidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_complejidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_complejidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_complejidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_complejidad', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_complejidad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_complejidad', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_complejidad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_complejidad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_complejidad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.cat_estado_caso', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_estado_caso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_estado_caso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_estado_caso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_estado_caso', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_estado_caso ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_estado_caso', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_estado_caso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_estado_caso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_estado_caso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.cat_grupo_operativo', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_grupo_operativo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_grupo_operativo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_grupo_operativo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_grupo_operativo', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_grupo_operativo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_grupo_operativo', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_grupo_operativo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_grupo_operativo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_grupo_operativo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.cat_nivel_seguridad', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_nivel_seguridad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_nivel_seguridad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_nivel_seguridad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_nivel_seguridad', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_nivel_seguridad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_nivel_seguridad', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_nivel_seguridad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_nivel_seguridad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_nivel_seguridad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.cat_origen_caso', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_origen_caso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_origen_caso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_origen_caso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_origen_caso', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_origen_caso ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_origen_caso', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_origen_caso ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_origen_caso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_origen_caso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.cat_prioridad', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.cat_prioridad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.cat_prioridad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.cat_prioridad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.cat_prioridad', N'fecha_creacion') IS NULL
 ALTER TABLE casos.cat_prioridad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_prioridad', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.cat_prioridad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.cat_prioridad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.cat_prioridad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'casos.matriz_riesgo', N'id_usuario_creador') IS NULL
 ALTER TABLE casos.matriz_riesgo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'casos.matriz_riesgo', N'id_usuario_modificador') IS NULL
 ALTER TABLE casos.matriz_riesgo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'casos.matriz_riesgo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE casos.matriz_riesgo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'casos.matriz_riesgo', N'fecha_creacion') IS NULL
 ALTER TABLE casos.matriz_riesgo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'casos.matriz_riesgo', N'fecha_actualizacion') IS NULL
 ALTER TABLE casos.matriz_riesgo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'casos.matriz_riesgo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE casos.matriz_riesgo ADD fecha_eliminacion_logica timestamp NULL;

/* --- casos: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_rol_persona_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona WITH CHECK ADD CONSTRAINT fk_cat_tipo_rol_persona_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_rol_persona_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_tipo_rol_persona'))
 ALTER TABLE casos.cat_tipo_rol_persona WITH CHECK ADD CONSTRAINT fk_cat_tipo_rol_persona_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_agrupacion_causa_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.agrupacion_causa'))
 ALTER TABLE casos.agrupacion_causa WITH CHECK ADD CONSTRAINT fk_agrupacion_causa_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_agrupacion_causa_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.agrupacion_causa'))
 ALTER TABLE casos.agrupacion_causa WITH CHECK ADD CONSTRAINT fk_agrupacion_causa_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_agrupacion_causa_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.agrupacion_causa'))
 ALTER TABLE casos.agrupacion_causa WITH CHECK ADD CONSTRAINT fk_agrupacion_causa_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_agrupacion_causa_caso_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.agrupacion_causa_caso'))
 ALTER TABLE casos.agrupacion_causa_caso WITH CHECK ADD CONSTRAINT fk_agrupacion_causa_caso_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_agrupacion_causa_caso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.agrupacion_causa_caso'))
 ALTER TABLE casos.agrupacion_causa_caso WITH CHECK ADD CONSTRAINT fk_agrupacion_causa_caso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_agrupacion_causa_caso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.agrupacion_causa_caso'))
 ALTER TABLE casos.agrupacion_causa_caso WITH CHECK ADD CONSTRAINT fk_agrupacion_causa_caso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_asignacion_funcionario_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.asignacion_funcionario'))
 ALTER TABLE casos.asignacion_funcionario WITH CHECK ADD CONSTRAINT fk_asignacion_funcionario_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_asignacion_funcionario_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.asignacion_funcionario'))
 ALTER TABLE casos.asignacion_funcionario WITH CHECK ADD CONSTRAINT fk_asignacion_funcionario_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_asignacion_funcionario_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.asignacion_funcionario'))
 ALTER TABLE casos.asignacion_funcionario WITH CHECK ADD CONSTRAINT fk_asignacion_funcionario_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_carpeta_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.carpeta'))
 ALTER TABLE casos.carpeta WITH CHECK ADD CONSTRAINT fk_carpeta_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_carpeta_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.carpeta'))
 ALTER TABLE casos.carpeta WITH CHECK ADD CONSTRAINT fk_carpeta_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_carpeta_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.carpeta'))
 ALTER TABLE casos.carpeta WITH CHECK ADD CONSTRAINT fk_carpeta_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_carpeta_colaborador_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.carpeta_colaborador'))
 ALTER TABLE casos.carpeta_colaborador WITH CHECK ADD CONSTRAINT fk_carpeta_colaborador_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_carpeta_colaborador_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.carpeta_colaborador'))
 ALTER TABLE casos.carpeta_colaborador WITH CHECK ADD CONSTRAINT fk_carpeta_colaborador_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_carpeta_colaborador_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.carpeta_colaborador'))
 ALTER TABLE casos.carpeta_colaborador WITH CHECK ADD CONSTRAINT fk_carpeta_colaborador_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.caso'))
 ALTER TABLE casos.caso WITH CHECK ADD CONSTRAINT fk_caso_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.caso'))
 ALTER TABLE casos.caso WITH CHECK ADD CONSTRAINT fk_caso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.caso'))
 ALTER TABLE casos.caso WITH CHECK ADD CONSTRAINT fk_caso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_historial_estado_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.caso_historial_estado'))
 ALTER TABLE casos.caso_historial_estado WITH CHECK ADD CONSTRAINT fk_caso_historial_estado_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_historial_estado_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.caso_historial_estado'))
 ALTER TABLE casos.caso_historial_estado WITH CHECK ADD CONSTRAINT fk_caso_historial_estado_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_historial_estado_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.caso_historial_estado'))
 ALTER TABLE casos.caso_historial_estado WITH CHECK ADD CONSTRAINT fk_caso_historial_estado_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_persona_rol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.caso_persona_rol'))
 ALTER TABLE casos.caso_persona_rol WITH CHECK ADD CONSTRAINT fk_caso_persona_rol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_persona_rol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.caso_persona_rol'))
 ALTER TABLE casos.caso_persona_rol WITH CHECK ADD CONSTRAINT fk_caso_persona_rol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_persona_rol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.caso_persona_rol'))
 ALTER TABLE casos.caso_persona_rol WITH CHECK ADD CONSTRAINT fk_caso_persona_rol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_referencia_judicial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.caso_referencia_judicial'))
 ALTER TABLE casos.caso_referencia_judicial WITH CHECK ADD CONSTRAINT fk_caso_referencia_judicial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_referencia_judicial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.caso_referencia_judicial'))
 ALTER TABLE casos.caso_referencia_judicial WITH CHECK ADD CONSTRAINT fk_caso_referencia_judicial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_caso_referencia_judicial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.caso_referencia_judicial'))
 ALTER TABLE casos.caso_referencia_judicial WITH CHECK ADD CONSTRAINT fk_caso_referencia_judicial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_complejidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_complejidad'))
 ALTER TABLE casos.cat_complejidad WITH CHECK ADD CONSTRAINT fk_cat_complejidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_complejidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_complejidad'))
 ALTER TABLE casos.cat_complejidad WITH CHECK ADD CONSTRAINT fk_cat_complejidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_caso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_estado_caso'))
 ALTER TABLE casos.cat_estado_caso WITH CHECK ADD CONSTRAINT fk_cat_estado_caso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_caso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_estado_caso'))
 ALTER TABLE casos.cat_estado_caso WITH CHECK ADD CONSTRAINT fk_cat_estado_caso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_grupo_operativo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_grupo_operativo'))
 ALTER TABLE casos.cat_grupo_operativo WITH CHECK ADD CONSTRAINT fk_cat_grupo_operativo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_grupo_operativo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_grupo_operativo'))
 ALTER TABLE casos.cat_grupo_operativo WITH CHECK ADD CONSTRAINT fk_cat_grupo_operativo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_seguridad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_nivel_seguridad'))
 ALTER TABLE casos.cat_nivel_seguridad WITH CHECK ADD CONSTRAINT fk_cat_nivel_seguridad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_seguridad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_nivel_seguridad'))
 ALTER TABLE casos.cat_nivel_seguridad WITH CHECK ADD CONSTRAINT fk_cat_nivel_seguridad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_origen_caso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_origen_caso'))
 ALTER TABLE casos.cat_origen_caso WITH CHECK ADD CONSTRAINT fk_cat_origen_caso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_origen_caso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_origen_caso'))
 ALTER TABLE casos.cat_origen_caso WITH CHECK ADD CONSTRAINT fk_cat_origen_caso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_prioridad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.cat_prioridad'))
 ALTER TABLE casos.cat_prioridad WITH CHECK ADD CONSTRAINT fk_cat_prioridad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_prioridad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.cat_prioridad'))
 ALTER TABLE casos.cat_prioridad WITH CHECK ADD CONSTRAINT fk_cat_prioridad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_matriz_riesgo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'casos.matriz_riesgo'))
 ALTER TABLE casos.matriz_riesgo WITH CHECK ADD CONSTRAINT fk_matriz_riesgo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_matriz_riesgo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'casos.matriz_riesgo'))
 ALTER TABLE casos.matriz_riesgo WITH CHECK ADD CONSTRAINT fk_matriz_riesgo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_matriz_riesgo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'casos.matriz_riesgo'))
 ALTER TABLE casos.matriz_riesgo WITH CHECK ADD CONSTRAINT fk_matriz_riesgo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: catalogo_bienes (6 tablas, +32 col, +18 fk) ============================== */

/* --- catalogo_bienes: columnas --- */
IF COL_LENGTH(N'catalogo_bienes.clase', N'id_usuario_creador') IS NULL
 ALTER TABLE catalogo_bienes.clase ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.clase', N'id_usuario_modificador') IS NULL
 ALTER TABLE catalogo_bienes.clase ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.clase', N'id_usuario_eliminador') IS NULL
 ALTER TABLE catalogo_bienes.clase ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.clase', N'fecha_actualizacion') IS NULL
 ALTER TABLE catalogo_bienes.clase ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.clase', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE catalogo_bienes.clase ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.codigo_reemplazado', N'id_usuario_creador') IS NULL
 ALTER TABLE catalogo_bienes.codigo_reemplazado ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.codigo_reemplazado', N'id_usuario_modificador') IS NULL
 ALTER TABLE catalogo_bienes.codigo_reemplazado ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.codigo_reemplazado', N'id_usuario_eliminador') IS NULL
 ALTER TABLE catalogo_bienes.codigo_reemplazado ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.codigo_reemplazado', N'fecha_creacion') IS NULL
 ALTER TABLE catalogo_bienes.codigo_reemplazado ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.codigo_reemplazado', N'fecha_actualizacion') IS NULL
 ALTER TABLE catalogo_bienes.codigo_reemplazado ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.codigo_reemplazado', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE catalogo_bienes.codigo_reemplazado ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.familia', N'id_usuario_creador') IS NULL
 ALTER TABLE catalogo_bienes.familia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.familia', N'id_usuario_modificador') IS NULL
 ALTER TABLE catalogo_bienes.familia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.familia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE catalogo_bienes.familia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.familia', N'fecha_actualizacion') IS NULL
 ALTER TABLE catalogo_bienes.familia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.familia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE catalogo_bienes.familia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.producto', N'id_usuario_creador') IS NULL
 ALTER TABLE catalogo_bienes.producto ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.producto', N'id_usuario_modificador') IS NULL
 ALTER TABLE catalogo_bienes.producto ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.producto', N'id_usuario_eliminador') IS NULL
 ALTER TABLE catalogo_bienes.producto ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.producto', N'fecha_actualizacion') IS NULL
 ALTER TABLE catalogo_bienes.producto ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.producto', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE catalogo_bienes.producto ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.segmento', N'id_usuario_creador') IS NULL
 ALTER TABLE catalogo_bienes.segmento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.segmento', N'id_usuario_modificador') IS NULL
 ALTER TABLE catalogo_bienes.segmento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.segmento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE catalogo_bienes.segmento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.segmento', N'fecha_actualizacion') IS NULL
 ALTER TABLE catalogo_bienes.segmento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.segmento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE catalogo_bienes.segmento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.version_catalogo', N'id_usuario_creador') IS NULL
 ALTER TABLE catalogo_bienes.version_catalogo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.version_catalogo', N'id_usuario_modificador') IS NULL
 ALTER TABLE catalogo_bienes.version_catalogo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.version_catalogo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE catalogo_bienes.version_catalogo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'catalogo_bienes.version_catalogo', N'fecha_creacion') IS NULL
 ALTER TABLE catalogo_bienes.version_catalogo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.version_catalogo', N'fecha_actualizacion') IS NULL
 ALTER TABLE catalogo_bienes.version_catalogo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'catalogo_bienes.version_catalogo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE catalogo_bienes.version_catalogo ADD fecha_eliminacion_logica timestamp NULL;

/* --- catalogo_bienes: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_clase_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.clase'))
 ALTER TABLE catalogo_bienes.clase WITH CHECK ADD CONSTRAINT fk_clase_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_clase_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.clase'))
 ALTER TABLE catalogo_bienes.clase WITH CHECK ADD CONSTRAINT fk_clase_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_clase_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.clase'))
 ALTER TABLE catalogo_bienes.clase WITH CHECK ADD CONSTRAINT fk_clase_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_codigo_reemplazado_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.codigo_reemplazado'))
 ALTER TABLE catalogo_bienes.codigo_reemplazado WITH CHECK ADD CONSTRAINT fk_codigo_reemplazado_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_codigo_reemplazado_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.codigo_reemplazado'))
 ALTER TABLE catalogo_bienes.codigo_reemplazado WITH CHECK ADD CONSTRAINT fk_codigo_reemplazado_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_codigo_reemplazado_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.codigo_reemplazado'))
 ALTER TABLE catalogo_bienes.codigo_reemplazado WITH CHECK ADD CONSTRAINT fk_codigo_reemplazado_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_familia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.familia'))
 ALTER TABLE catalogo_bienes.familia WITH CHECK ADD CONSTRAINT fk_familia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_familia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.familia'))
 ALTER TABLE catalogo_bienes.familia WITH CHECK ADD CONSTRAINT fk_familia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_familia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.familia'))
 ALTER TABLE catalogo_bienes.familia WITH CHECK ADD CONSTRAINT fk_familia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_producto_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.producto'))
 ALTER TABLE catalogo_bienes.producto WITH CHECK ADD CONSTRAINT fk_producto_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_producto_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.producto'))
 ALTER TABLE catalogo_bienes.producto WITH CHECK ADD CONSTRAINT fk_producto_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_producto_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.producto'))
 ALTER TABLE catalogo_bienes.producto WITH CHECK ADD CONSTRAINT fk_producto_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_segmento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.segmento'))
 ALTER TABLE catalogo_bienes.segmento WITH CHECK ADD CONSTRAINT fk_segmento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_segmento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.segmento'))
 ALTER TABLE catalogo_bienes.segmento WITH CHECK ADD CONSTRAINT fk_segmento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_segmento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.segmento'))
 ALTER TABLE catalogo_bienes.segmento WITH CHECK ADD CONSTRAINT fk_segmento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_version_catalogo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.version_catalogo'))
 ALTER TABLE catalogo_bienes.version_catalogo WITH CHECK ADD CONSTRAINT fk_version_catalogo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_version_catalogo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.version_catalogo'))
 ALTER TABLE catalogo_bienes.version_catalogo WITH CHECK ADD CONSTRAINT fk_version_catalogo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_version_catalogo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'catalogo_bienes.version_catalogo'))
 ALTER TABLE catalogo_bienes.version_catalogo WITH CHECK ADD CONSTRAINT fk_version_catalogo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: configuracion (3 tablas, +14 col, +6 fk) ============================== */

/* --- configuracion: columnas --- */
IF COL_LENGTH(N'configuracion.cat_dominio', N'id_usuario_modificador') IS NULL
 ALTER TABLE configuracion.cat_dominio ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'configuracion.cat_dominio', N'id_usuario_eliminador') IS NULL
 ALTER TABLE configuracion.cat_dominio ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'configuracion.cat_dominio', N'fecha_creacion') IS NULL
 ALTER TABLE configuracion.cat_dominio ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_dominio', N'fecha_actualizacion') IS NULL
 ALTER TABLE configuracion.cat_dominio ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_dominio', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE configuracion.cat_dominio ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_elemento_dominio', N'id_usuario_modificador') IS NULL
 ALTER TABLE configuracion.cat_elemento_dominio ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'configuracion.cat_elemento_dominio', N'id_usuario_eliminador') IS NULL
 ALTER TABLE configuracion.cat_elemento_dominio ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'configuracion.cat_elemento_dominio', N'fecha_creacion') IS NULL
 ALTER TABLE configuracion.cat_elemento_dominio ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_elemento_dominio', N'fecha_actualizacion') IS NULL
 ALTER TABLE configuracion.cat_elemento_dominio ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_elemento_dominio', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE configuracion.cat_elemento_dominio ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_programa_seguridad', N'id_usuario_modificador') IS NULL
 ALTER TABLE configuracion.cat_programa_seguridad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'configuracion.cat_programa_seguridad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE configuracion.cat_programa_seguridad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'configuracion.cat_programa_seguridad', N'fecha_actualizacion') IS NULL
 ALTER TABLE configuracion.cat_programa_seguridad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'configuracion.cat_programa_seguridad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE configuracion.cat_programa_seguridad ADD fecha_eliminacion_logica timestamp NULL;

/* --- configuracion: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_dominio_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'configuracion.cat_dominio'))
 ALTER TABLE configuracion.cat_dominio WITH CHECK ADD CONSTRAINT fk_cat_dominio_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_dominio_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'configuracion.cat_dominio'))
 ALTER TABLE configuracion.cat_dominio WITH CHECK ADD CONSTRAINT fk_cat_dominio_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_elemento_dominio_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'configuracion.cat_elemento_dominio'))
 ALTER TABLE configuracion.cat_elemento_dominio WITH CHECK ADD CONSTRAINT fk_cat_elemento_dominio_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_elemento_dominio_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'configuracion.cat_elemento_dominio'))
 ALTER TABLE configuracion.cat_elemento_dominio WITH CHECK ADD CONSTRAINT fk_cat_elemento_dominio_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_programa_seguridad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'configuracion.cat_programa_seguridad'))
 ALTER TABLE configuracion.cat_programa_seguridad WITH CHECK ADD CONSTRAINT fk_cat_programa_seguridad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_programa_seguridad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'configuracion.cat_programa_seguridad'))
 ALTER TABLE configuracion.cat_programa_seguridad WITH CHECK ADD CONSTRAINT fk_cat_programa_seguridad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: cooperacion_int (7 tablas, +28 col, +19 fk) ============================== */

/* --- cooperacion_int: columnas --- */
IF COL_LENGTH(N'cooperacion_int.cat_cooperacion_internacional', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.cat_cooperacion_internacional', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.cat_cooperacion_internacional', N'fecha_creacion') IS NULL
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.cat_cooperacion_internacional', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.cat_cooperacion_internacional', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.cat_elemento_cooperacion_internacional', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.cat_elemento_cooperacion_internacional', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.cat_elemento_cooperacion_internacional', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.entidad_interpol', N'id_usuario_creador') IS NULL
 ALTER TABLE cooperacion_int.entidad_interpol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'cooperacion_int.entidad_interpol', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.entidad_interpol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.entidad_interpol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.entidad_interpol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.entidad_interpol', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.entidad_interpol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.estado_solicitud_interpol', N'id_usuario_creador') IS NULL
 ALTER TABLE cooperacion_int.estado_solicitud_interpol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'cooperacion_int.estado_solicitud_interpol', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.estado_solicitud_interpol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.estado_solicitud_interpol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.estado_solicitud_interpol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.estado_solicitud_interpol', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.estado_solicitud_interpol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.motivo_solicitud_interpol', N'id_usuario_creador') IS NULL
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'cooperacion_int.motivo_solicitud_interpol', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.motivo_solicitud_interpol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.motivo_solicitud_interpol', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'id_usuario_creador') IS NULL
 ALTER TABLE cooperacion_int.solicitud_interpol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.solicitud_interpol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.solicitud_interpol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.solicitud_interpol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'cooperacion_int.tipo_consulta_solicitud_interpol', N'id_usuario_creador') IS NULL
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'cooperacion_int.tipo_consulta_solicitud_interpol', N'id_usuario_modificador') IS NULL
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'cooperacion_int.tipo_consulta_solicitud_interpol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'cooperacion_int.tipo_consulta_solicitud_interpol', N'fecha_actualizacion') IS NULL
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol ADD fecha_actualizacion timestamp NULL;

/* --- cooperacion_int: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_cooperacion_internacional_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.cat_cooperacion_internacional'))
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional WITH CHECK ADD CONSTRAINT fk_cat_cooperacion_internacional_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_cooperacion_internacional_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.cat_cooperacion_internacional'))
 ALTER TABLE cooperacion_int.cat_cooperacion_internacional WITH CHECK ADD CONSTRAINT fk_cat_cooperacion_internacional_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_elemento_cooperacion_internacional_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.cat_elemento_cooperacion_internacional'))
 ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional WITH CHECK ADD CONSTRAINT fk_cat_elemento_cooperacion_internacional_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_elemento_cooperacion_internacional_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.cat_elemento_cooperacion_internacional'))
 ALTER TABLE cooperacion_int.cat_elemento_cooperacion_internacional WITH CHECK ADD CONSTRAINT fk_cat_elemento_cooperacion_internacional_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_entidad_interpol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.entidad_interpol'))
 ALTER TABLE cooperacion_int.entidad_interpol WITH CHECK ADD CONSTRAINT fk_entidad_interpol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_entidad_interpol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.entidad_interpol'))
 ALTER TABLE cooperacion_int.entidad_interpol WITH CHECK ADD CONSTRAINT fk_entidad_interpol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_entidad_interpol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.entidad_interpol'))
 ALTER TABLE cooperacion_int.entidad_interpol WITH CHECK ADD CONSTRAINT fk_entidad_interpol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_solicitud_interpol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.estado_solicitud_interpol'))
 ALTER TABLE cooperacion_int.estado_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_estado_solicitud_interpol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_solicitud_interpol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.estado_solicitud_interpol'))
 ALTER TABLE cooperacion_int.estado_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_estado_solicitud_interpol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_solicitud_interpol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.estado_solicitud_interpol'))
 ALTER TABLE cooperacion_int.estado_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_estado_solicitud_interpol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_motivo_solicitud_interpol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.motivo_solicitud_interpol'))
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_motivo_solicitud_interpol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_motivo_solicitud_interpol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.motivo_solicitud_interpol'))
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_motivo_solicitud_interpol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_motivo_solicitud_interpol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.motivo_solicitud_interpol'))
 ALTER TABLE cooperacion_int.motivo_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_motivo_solicitud_interpol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_interpol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
 ALTER TABLE cooperacion_int.solicitud_interpol WITH CHECK ADD CONSTRAINT fk_solicitud_interpol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_interpol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
 ALTER TABLE cooperacion_int.solicitud_interpol WITH CHECK ADD CONSTRAINT fk_solicitud_interpol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_interpol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.solicitud_interpol'))
 ALTER TABLE cooperacion_int.solicitud_interpol WITH CHECK ADD CONSTRAINT fk_solicitud_interpol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_consulta_solicitud_interpol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.tipo_consulta_solicitud_interpol'))
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_tipo_consulta_solicitud_interpol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_consulta_solicitud_interpol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.tipo_consulta_solicitud_interpol'))
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_tipo_consulta_solicitud_interpol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_consulta_solicitud_interpol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'cooperacion_int.tipo_consulta_solicitud_interpol'))
 ALTER TABLE cooperacion_int.tipo_consulta_solicitud_interpol WITH CHECK ADD CONSTRAINT fk_tipo_consulta_solicitud_interpol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: denuncias (12 tablas, +55 col, +32 fk) ============================== */

/* --- denuncias: columnas --- */
IF COL_LENGTH(N'denuncias.denuncia_hecho', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.denuncia_hecho ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia_hecho', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.denuncia_hecho ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia_hecho', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.denuncia_hecho ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia_hecho', N'fecha_creacion') IS NULL
 ALTER TABLE denuncias.denuncia_hecho ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'denuncias.denuncia_hecho', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.denuncia_hecho ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.denuncia_hecho', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.denuncia_hecho ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_estado_denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.cat_estado_denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.cat_estado_denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.cat_estado_denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.cat_estado_denuncia', N'fecha_creacion') IS NULL
 ALTER TABLE denuncias.cat_estado_denuncia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_estado_denuncia', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.cat_estado_denuncia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_estado_denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.cat_estado_denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.denuncia', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.denuncia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.relato', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.relato ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.relato', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.relato ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.relato', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.relato ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_relato', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.cat_tipo_relato ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_relato', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.cat_tipo_relato ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_relato', N'fecha_creacion') IS NULL
 ALTER TABLE denuncias.cat_tipo_relato ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_relato', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.cat_tipo_relato ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_relato', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.cat_tipo_relato ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_estado_envio_fiscalia', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.cat_estado_envio_fiscalia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.cat_estado_envio_fiscalia', N'fecha_creacion') IS NULL
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_estado_envio_fiscalia', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_estado_envio_fiscalia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.cat_estado_envio_fiscalia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.cat_tipo_denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.cat_tipo_denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_denuncia', N'fecha_creacion') IS NULL
 ALTER TABLE denuncias.cat_tipo_denuncia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_denuncia', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.cat_tipo_denuncia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.cat_tipo_denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.cat_tipo_denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.denuncia_persona_rol', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.denuncia_persona_rol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia_persona_rol', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.denuncia_persona_rol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia_persona_rol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.denuncia_persona_rol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.denuncia_persona_rol', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.denuncia_persona_rol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.log_guardar_denuncia', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.log_guardar_denuncia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.log_guardar_denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.log_guardar_denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.log_guardar_denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.log_guardar_denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.log_guardar_denuncia', N'fecha_creacion') IS NULL
 ALTER TABLE denuncias.log_guardar_denuncia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'denuncias.log_guardar_denuncia', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.log_guardar_denuncia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.log_guardar_denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.log_guardar_denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.pauta_vif', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.pauta_vif ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.pauta_vif', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.pauta_vif ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.pauta_vif', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.pauta_vif ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.pauta_vif', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.pauta_vif ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.procedimiento_persona', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.procedimiento_persona ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.procedimiento_persona', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.procedimiento_persona ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.procedimiento_persona', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.procedimiento_persona ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'denuncias.procedimiento_persona', N'fecha_actualizacion') IS NULL
 ALTER TABLE denuncias.procedimiento_persona ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'denuncias.procedimiento_persona', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE denuncias.procedimiento_persona ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'denuncias.procedimiento_policial', N'id_usuario_creador') IS NULL
 ALTER TABLE denuncias.procedimiento_policial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'denuncias.procedimiento_policial', N'id_usuario_modificador') IS NULL
 ALTER TABLE denuncias.procedimiento_policial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'denuncias.procedimiento_policial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE denuncias.procedimiento_policial ADD id_usuario_eliminador INT NULL;

/* --- denuncias: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_hecho_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_hecho'))
 ALTER TABLE denuncias.denuncia_hecho WITH CHECK ADD CONSTRAINT fk_denuncia_hecho_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_hecho_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_hecho'))
 ALTER TABLE denuncias.denuncia_hecho WITH CHECK ADD CONSTRAINT fk_denuncia_hecho_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_hecho_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_hecho'))
 ALTER TABLE denuncias.denuncia_hecho WITH CHECK ADD CONSTRAINT fk_denuncia_hecho_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_estado_denuncia'))
 ALTER TABLE denuncias.cat_estado_denuncia WITH CHECK ADD CONSTRAINT fk_cat_estado_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_estado_denuncia'))
 ALTER TABLE denuncias.cat_estado_denuncia WITH CHECK ADD CONSTRAINT fk_cat_estado_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia'))
 ALTER TABLE denuncias.denuncia WITH CHECK ADD CONSTRAINT fk_denuncia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia'))
 ALTER TABLE denuncias.denuncia WITH CHECK ADD CONSTRAINT fk_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia'))
 ALTER TABLE denuncias.denuncia WITH CHECK ADD CONSTRAINT fk_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relato_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.relato'))
 ALTER TABLE denuncias.relato WITH CHECK ADD CONSTRAINT fk_relato_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relato_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.relato'))
 ALTER TABLE denuncias.relato WITH CHECK ADD CONSTRAINT fk_relato_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relato_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.relato'))
 ALTER TABLE denuncias.relato WITH CHECK ADD CONSTRAINT fk_relato_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relato_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_relato'))
 ALTER TABLE denuncias.cat_tipo_relato WITH CHECK ADD CONSTRAINT fk_cat_tipo_relato_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relato_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_relato'))
 ALTER TABLE denuncias.cat_tipo_relato WITH CHECK ADD CONSTRAINT fk_cat_tipo_relato_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_envio_fiscalia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_estado_envio_fiscalia'))
 ALTER TABLE denuncias.cat_estado_envio_fiscalia WITH CHECK ADD CONSTRAINT fk_cat_estado_envio_fiscalia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_envio_fiscalia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_estado_envio_fiscalia'))
 ALTER TABLE denuncias.cat_estado_envio_fiscalia WITH CHECK ADD CONSTRAINT fk_cat_estado_envio_fiscalia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_denuncia'))
 ALTER TABLE denuncias.cat_tipo_denuncia WITH CHECK ADD CONSTRAINT fk_cat_tipo_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.cat_tipo_denuncia'))
 ALTER TABLE denuncias.cat_tipo_denuncia WITH CHECK ADD CONSTRAINT fk_cat_tipo_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_persona_rol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 ALTER TABLE denuncias.denuncia_persona_rol WITH CHECK ADD CONSTRAINT fk_denuncia_persona_rol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_persona_rol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 ALTER TABLE denuncias.denuncia_persona_rol WITH CHECK ADD CONSTRAINT fk_denuncia_persona_rol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_persona_rol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.denuncia_persona_rol'))
 ALTER TABLE denuncias.denuncia_persona_rol WITH CHECK ADD CONSTRAINT fk_denuncia_persona_rol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_log_guardar_denuncia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.log_guardar_denuncia'))
 ALTER TABLE denuncias.log_guardar_denuncia WITH CHECK ADD CONSTRAINT fk_log_guardar_denuncia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_log_guardar_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.log_guardar_denuncia'))
 ALTER TABLE denuncias.log_guardar_denuncia WITH CHECK ADD CONSTRAINT fk_log_guardar_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_log_guardar_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.log_guardar_denuncia'))
 ALTER TABLE denuncias.log_guardar_denuncia WITH CHECK ADD CONSTRAINT fk_log_guardar_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pauta_vif_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.pauta_vif'))
 ALTER TABLE denuncias.pauta_vif WITH CHECK ADD CONSTRAINT fk_pauta_vif_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pauta_vif_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.pauta_vif'))
 ALTER TABLE denuncias.pauta_vif WITH CHECK ADD CONSTRAINT fk_pauta_vif_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pauta_vif_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.pauta_vif'))
 ALTER TABLE denuncias.pauta_vif WITH CHECK ADD CONSTRAINT fk_pauta_vif_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_procedimiento_persona_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.procedimiento_persona'))
 ALTER TABLE denuncias.procedimiento_persona WITH CHECK ADD CONSTRAINT fk_procedimiento_persona_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_procedimiento_persona_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.procedimiento_persona'))
 ALTER TABLE denuncias.procedimiento_persona WITH CHECK ADD CONSTRAINT fk_procedimiento_persona_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_procedimiento_persona_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.procedimiento_persona'))
 ALTER TABLE denuncias.procedimiento_persona WITH CHECK ADD CONSTRAINT fk_procedimiento_persona_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_procedimiento_policial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'denuncias.procedimiento_policial'))
 ALTER TABLE denuncias.procedimiento_policial WITH CHECK ADD CONSTRAINT fk_procedimiento_policial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_procedimiento_policial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'denuncias.procedimiento_policial'))
 ALTER TABLE denuncias.procedimiento_policial WITH CHECK ADD CONSTRAINT fk_procedimiento_policial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_procedimiento_policial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'denuncias.procedimiento_policial'))
 ALTER TABLE denuncias.procedimiento_policial WITH CHECK ADD CONSTRAINT fk_procedimiento_policial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: diligencias (23 tablas, +101 col, +59 fk) ============================== */

/* --- diligencias: columnas --- */
IF COL_LENGTH(N'diligencias.actividad_investigativa', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.actividad_investigativa ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.actividad_investigativa', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.actividad_investigativa ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.actividad_investigativa', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.actividad_investigativa ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.actividad_investigativa', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.actividad_investigativa ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_especialidad_pericial', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_especialidad_pericial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_especialidad_pericial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_especialidad_pericial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_especialidad_pericial', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_especialidad_pericial ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_especialidad_pericial', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_especialidad_pericial ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_especialidad_pericial', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_especialidad_pericial ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_estado_diligencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_estado_diligencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_estado_diligencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_estado_diligencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_estado_diligencia', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_estado_diligencia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_estado_diligencia', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_estado_diligencia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_estado_diligencia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_estado_diligencia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_estado_instruccion', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_estado_instruccion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_estado_instruccion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_estado_instruccion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_estado_instruccion', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_estado_instruccion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_estado_instruccion', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_estado_instruccion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_estado_instruccion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_estado_instruccion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_fuente_observacion_externa', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_fuente_observacion_externa ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_fuente_observacion_externa', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_fuente_observacion_externa ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_fuente_observacion_externa', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_fuente_observacion_externa ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_fuente_observacion_externa', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_fuente_observacion_externa ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_fuente_observacion_externa', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_fuente_observacion_externa ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_detencion', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_tipo_detencion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_detencion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_tipo_detencion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_detencion', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_detencion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_detencion', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_detencion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_detencion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_tipo_detencion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_diligencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_tipo_diligencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_diligencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_tipo_diligencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_diligencia', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_diligencia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_diligencia', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_diligencia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_diligencia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_tipo_diligencia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_informe', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_tipo_informe ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_informe', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_tipo_informe ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_informe', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_informe ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_informe', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_informe ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_informe', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_tipo_informe ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_instruccion', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_tipo_instruccion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_instruccion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_tipo_instruccion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_instruccion', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_instruccion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_instruccion', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_instruccion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_instruccion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_tipo_instruccion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_notificacion_externa', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_tipo_notificacion_externa ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_notificacion_externa', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_tipo_notificacion_externa ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_notificacion_externa', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_notificacion_externa ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_notificacion_externa', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_notificacion_externa ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_notificacion_externa', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_tipo_notificacion_externa ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_peritaje', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.cat_tipo_peritaje ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_peritaje', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.cat_tipo_peritaje ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_peritaje', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_peritaje ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_peritaje', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.cat_tipo_peritaje ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.cat_tipo_peritaje', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.cat_tipo_peritaje ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.detencion', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.detencion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.detencion', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.detencion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.detencion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.detencion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.detencion', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.detencion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.detencion_lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.detencion_lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.detencion_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.detencion_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.detencion_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.detencion_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.detencion_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.detencion_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.diligencia', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.diligencia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.diligencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.diligencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.diligencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.diligencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.diligencia_lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.diligencia_lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.diligencia_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.diligencia_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.diligencia_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.diligencia_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.diligencia_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.diligencia_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.informe_policial', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.informe_policial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.informe_policial', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.informe_policial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.informe_policial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.informe_policial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.informe_policial', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.informe_policial ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.instruccion_fiscal', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.instruccion_fiscal ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.instruccion_fiscal', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.instruccion_fiscal ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.instruccion_fiscal', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.instruccion_fiscal ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.notificacion_externa', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.notificacion_externa ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.notificacion_externa', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.notificacion_externa ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.notificacion_externa', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.notificacion_externa ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.notificacion_externa', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.notificacion_externa ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.notificacion_externa', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.notificacion_externa ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.orden_arresto', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.orden_arresto ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.orden_arresto', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.orden_arresto ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.orden_arresto', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.orden_arresto ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.orden_detencion', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.orden_detencion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.orden_detencion', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.orden_detencion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.orden_detencion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.orden_detencion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.peritaje', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.peritaje ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.peritaje', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.peritaje ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.peritaje', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.peritaje ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_pericial', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_pericial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_pericial', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_pericial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_pericial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_pericial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_pericial', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_pericial ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_pericial', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_pericial ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_perito', N'id_usuario_creador') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_perito ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_perito', N'id_usuario_modificador') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_perito ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_perito', N'id_usuario_eliminador') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_perito ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_perito', N'fecha_creacion') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_perito ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_perito', N'fecha_actualizacion') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_perito ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'diligencias.solicitud_concurrencia_perito', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE diligencias.solicitud_concurrencia_perito ADD fecha_eliminacion_logica timestamp NULL;

/* --- diligencias: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_actividad_investigativa_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.actividad_investigativa'))
 ALTER TABLE diligencias.actividad_investigativa WITH CHECK ADD CONSTRAINT fk_actividad_investigativa_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_actividad_investigativa_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.actividad_investigativa'))
 ALTER TABLE diligencias.actividad_investigativa WITH CHECK ADD CONSTRAINT fk_actividad_investigativa_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_actividad_investigativa_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.actividad_investigativa'))
 ALTER TABLE diligencias.actividad_investigativa WITH CHECK ADD CONSTRAINT fk_actividad_investigativa_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_especialidad_pericial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_especialidad_pericial'))
 ALTER TABLE diligencias.cat_especialidad_pericial WITH CHECK ADD CONSTRAINT fk_cat_especialidad_pericial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_especialidad_pericial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_especialidad_pericial'))
 ALTER TABLE diligencias.cat_especialidad_pericial WITH CHECK ADD CONSTRAINT fk_cat_especialidad_pericial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_diligencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_estado_diligencia'))
 ALTER TABLE diligencias.cat_estado_diligencia WITH CHECK ADD CONSTRAINT fk_cat_estado_diligencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_diligencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_estado_diligencia'))
 ALTER TABLE diligencias.cat_estado_diligencia WITH CHECK ADD CONSTRAINT fk_cat_estado_diligencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_instruccion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_estado_instruccion'))
 ALTER TABLE diligencias.cat_estado_instruccion WITH CHECK ADD CONSTRAINT fk_cat_estado_instruccion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_instruccion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_estado_instruccion'))
 ALTER TABLE diligencias.cat_estado_instruccion WITH CHECK ADD CONSTRAINT fk_cat_estado_instruccion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_fuente_observacion_externa_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_fuente_observacion_externa'))
 ALTER TABLE diligencias.cat_fuente_observacion_externa WITH CHECK ADD CONSTRAINT fk_cat_fuente_observacion_externa_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_fuente_observacion_externa_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_fuente_observacion_externa'))
 ALTER TABLE diligencias.cat_fuente_observacion_externa WITH CHECK ADD CONSTRAINT fk_cat_fuente_observacion_externa_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_detencion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_detencion'))
 ALTER TABLE diligencias.cat_tipo_detencion WITH CHECK ADD CONSTRAINT fk_cat_tipo_detencion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_detencion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_detencion'))
 ALTER TABLE diligencias.cat_tipo_detencion WITH CHECK ADD CONSTRAINT fk_cat_tipo_detencion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_diligencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_diligencia'))
 ALTER TABLE diligencias.cat_tipo_diligencia WITH CHECK ADD CONSTRAINT fk_cat_tipo_diligencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_diligencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_diligencia'))
 ALTER TABLE diligencias.cat_tipo_diligencia WITH CHECK ADD CONSTRAINT fk_cat_tipo_diligencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_informe_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_informe'))
 ALTER TABLE diligencias.cat_tipo_informe WITH CHECK ADD CONSTRAINT fk_cat_tipo_informe_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_informe_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_informe'))
 ALTER TABLE diligencias.cat_tipo_informe WITH CHECK ADD CONSTRAINT fk_cat_tipo_informe_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_instruccion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_instruccion'))
 ALTER TABLE diligencias.cat_tipo_instruccion WITH CHECK ADD CONSTRAINT fk_cat_tipo_instruccion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_instruccion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_instruccion'))
 ALTER TABLE diligencias.cat_tipo_instruccion WITH CHECK ADD CONSTRAINT fk_cat_tipo_instruccion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_notificacion_externa_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_notificacion_externa'))
 ALTER TABLE diligencias.cat_tipo_notificacion_externa WITH CHECK ADD CONSTRAINT fk_cat_tipo_notificacion_externa_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_notificacion_externa_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_notificacion_externa'))
 ALTER TABLE diligencias.cat_tipo_notificacion_externa WITH CHECK ADD CONSTRAINT fk_cat_tipo_notificacion_externa_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_peritaje_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_peritaje'))
 ALTER TABLE diligencias.cat_tipo_peritaje WITH CHECK ADD CONSTRAINT fk_cat_tipo_peritaje_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_peritaje_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.cat_tipo_peritaje'))
 ALTER TABLE diligencias.cat_tipo_peritaje WITH CHECK ADD CONSTRAINT fk_cat_tipo_peritaje_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_detencion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.detencion'))
 ALTER TABLE diligencias.detencion WITH CHECK ADD CONSTRAINT fk_detencion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_detencion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.detencion'))
 ALTER TABLE diligencias.detencion WITH CHECK ADD CONSTRAINT fk_detencion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_detencion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.detencion'))
 ALTER TABLE diligencias.detencion WITH CHECK ADD CONSTRAINT fk_detencion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_detencion_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.detencion_lugar'))
 ALTER TABLE diligencias.detencion_lugar WITH CHECK ADD CONSTRAINT fk_detencion_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_detencion_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.detencion_lugar'))
 ALTER TABLE diligencias.detencion_lugar WITH CHECK ADD CONSTRAINT fk_detencion_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_detencion_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.detencion_lugar'))
 ALTER TABLE diligencias.detencion_lugar WITH CHECK ADD CONSTRAINT fk_detencion_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_diligencia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.diligencia'))
 ALTER TABLE diligencias.diligencia WITH CHECK ADD CONSTRAINT fk_diligencia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_diligencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.diligencia'))
 ALTER TABLE diligencias.diligencia WITH CHECK ADD CONSTRAINT fk_diligencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_diligencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.diligencia'))
 ALTER TABLE diligencias.diligencia WITH CHECK ADD CONSTRAINT fk_diligencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_diligencia_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.diligencia_lugar'))
 ALTER TABLE diligencias.diligencia_lugar WITH CHECK ADD CONSTRAINT fk_diligencia_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_diligencia_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.diligencia_lugar'))
 ALTER TABLE diligencias.diligencia_lugar WITH CHECK ADD CONSTRAINT fk_diligencia_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_diligencia_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.diligencia_lugar'))
 ALTER TABLE diligencias.diligencia_lugar WITH CHECK ADD CONSTRAINT fk_diligencia_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_informe_policial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.informe_policial'))
 ALTER TABLE diligencias.informe_policial WITH CHECK ADD CONSTRAINT fk_informe_policial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_informe_policial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.informe_policial'))
 ALTER TABLE diligencias.informe_policial WITH CHECK ADD CONSTRAINT fk_informe_policial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_informe_policial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.informe_policial'))
 ALTER TABLE diligencias.informe_policial WITH CHECK ADD CONSTRAINT fk_informe_policial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_instruccion_fiscal_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.instruccion_fiscal'))
 ALTER TABLE diligencias.instruccion_fiscal WITH CHECK ADD CONSTRAINT fk_instruccion_fiscal_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_instruccion_fiscal_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.instruccion_fiscal'))
 ALTER TABLE diligencias.instruccion_fiscal WITH CHECK ADD CONSTRAINT fk_instruccion_fiscal_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_instruccion_fiscal_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.instruccion_fiscal'))
 ALTER TABLE diligencias.instruccion_fiscal WITH CHECK ADD CONSTRAINT fk_instruccion_fiscal_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_notificacion_externa_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.notificacion_externa'))
 ALTER TABLE diligencias.notificacion_externa WITH CHECK ADD CONSTRAINT fk_notificacion_externa_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_notificacion_externa_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.notificacion_externa'))
 ALTER TABLE diligencias.notificacion_externa WITH CHECK ADD CONSTRAINT fk_notificacion_externa_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_notificacion_externa_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.notificacion_externa'))
 ALTER TABLE diligencias.notificacion_externa WITH CHECK ADD CONSTRAINT fk_notificacion_externa_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_arresto_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.orden_arresto'))
 ALTER TABLE diligencias.orden_arresto WITH CHECK ADD CONSTRAINT fk_orden_arresto_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_arresto_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.orden_arresto'))
 ALTER TABLE diligencias.orden_arresto WITH CHECK ADD CONSTRAINT fk_orden_arresto_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_arresto_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.orden_arresto'))
 ALTER TABLE diligencias.orden_arresto WITH CHECK ADD CONSTRAINT fk_orden_arresto_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_detencion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.orden_detencion'))
 ALTER TABLE diligencias.orden_detencion WITH CHECK ADD CONSTRAINT fk_orden_detencion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_detencion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.orden_detencion'))
 ALTER TABLE diligencias.orden_detencion WITH CHECK ADD CONSTRAINT fk_orden_detencion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_detencion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.orden_detencion'))
 ALTER TABLE diligencias.orden_detencion WITH CHECK ADD CONSTRAINT fk_orden_detencion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_peritaje_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.peritaje'))
 ALTER TABLE diligencias.peritaje WITH CHECK ADD CONSTRAINT fk_peritaje_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_peritaje_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.peritaje'))
 ALTER TABLE diligencias.peritaje WITH CHECK ADD CONSTRAINT fk_peritaje_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_peritaje_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.peritaje'))
 ALTER TABLE diligencias.peritaje WITH CHECK ADD CONSTRAINT fk_peritaje_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_concurrencia_pericial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.solicitud_concurrencia_pericial'))
 ALTER TABLE diligencias.solicitud_concurrencia_pericial WITH CHECK ADD CONSTRAINT fk_solicitud_concurrencia_pericial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_concurrencia_pericial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.solicitud_concurrencia_pericial'))
 ALTER TABLE diligencias.solicitud_concurrencia_pericial WITH CHECK ADD CONSTRAINT fk_solicitud_concurrencia_pericial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_concurrencia_pericial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.solicitud_concurrencia_pericial'))
 ALTER TABLE diligencias.solicitud_concurrencia_pericial WITH CHECK ADD CONSTRAINT fk_solicitud_concurrencia_pericial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_concurrencia_perito_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'diligencias.solicitud_concurrencia_perito'))
 ALTER TABLE diligencias.solicitud_concurrencia_perito WITH CHECK ADD CONSTRAINT fk_solicitud_concurrencia_perito_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_concurrencia_perito_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'diligencias.solicitud_concurrencia_perito'))
 ALTER TABLE diligencias.solicitud_concurrencia_perito WITH CHECK ADD CONSTRAINT fk_solicitud_concurrencia_perito_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_solicitud_concurrencia_perito_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'diligencias.solicitud_concurrencia_perito'))
 ALTER TABLE diligencias.solicitud_concurrencia_perito WITH CHECK ADD CONSTRAINT fk_solicitud_concurrencia_perito_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: encargos (8 tablas, +47 col, +24 fk) ============================== */

/* --- encargos: columnas --- */
IF COL_LENGTH(N'encargos.encargo', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.encargo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.encargo', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.encargo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.encargo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.encargo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.encargo', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.encargo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.encargo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.encargo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_denuncia', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.encargo_denuncia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.encargo_denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.encargo_denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.encargo_denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.encargo_denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.encargo_denuncia', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.encargo_denuncia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_denuncia', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.encargo_denuncia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.encargo_denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_orden_judicial', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.encargo_orden_judicial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.encargo_orden_judicial', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.encargo_orden_judicial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.encargo_orden_judicial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.encargo_orden_judicial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.encargo_orden_judicial', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.encargo_orden_judicial ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_orden_judicial', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.encargo_orden_judicial ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_orden_judicial', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.encargo_orden_judicial ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_persona_diligencia', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.encargo_persona_diligencia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.encargo_persona_diligencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.encargo_persona_diligencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.encargo_persona_diligencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.encargo_persona_diligencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.encargo_persona_diligencia', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.encargo_persona_diligencia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_persona_diligencia', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.encargo_persona_diligencia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.encargo_persona_diligencia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.encargo_persona_diligencia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.orden_judicial', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.orden_judicial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.orden_judicial', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.orden_judicial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.orden_judicial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.orden_judicial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.orden_judicial', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.orden_judicial ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.orden_judicial', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.orden_judicial ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.tarea_encargo', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.tarea_encargo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.tarea_encargo', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.tarea_encargo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.tarea_encargo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.tarea_encargo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.tarea_encargo', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.tarea_encargo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.tarea_encargo', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.tarea_encargo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.tarea_encargo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.tarea_encargo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.tipo_encargo', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.tipo_encargo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.tipo_encargo', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.tipo_encargo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.tipo_encargo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.tipo_encargo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.tipo_encargo', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.tipo_encargo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.tipo_encargo', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.tipo_encargo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.tipo_encargo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.tipo_encargo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'encargos.tipo_orden_judicial', N'id_usuario_creador') IS NULL
 ALTER TABLE encargos.tipo_orden_judicial ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'encargos.tipo_orden_judicial', N'id_usuario_modificador') IS NULL
 ALTER TABLE encargos.tipo_orden_judicial ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'encargos.tipo_orden_judicial', N'id_usuario_eliminador') IS NULL
 ALTER TABLE encargos.tipo_orden_judicial ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'encargos.tipo_orden_judicial', N'fecha_creacion') IS NULL
 ALTER TABLE encargos.tipo_orden_judicial ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'encargos.tipo_orden_judicial', N'fecha_actualizacion') IS NULL
 ALTER TABLE encargos.tipo_orden_judicial ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'encargos.tipo_orden_judicial', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE encargos.tipo_orden_judicial ADD fecha_eliminacion_logica timestamp NULL;

/* --- encargos: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.encargo'))
 ALTER TABLE encargos.encargo WITH CHECK ADD CONSTRAINT fk_encargo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.encargo'))
 ALTER TABLE encargos.encargo WITH CHECK ADD CONSTRAINT fk_encargo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.encargo'))
 ALTER TABLE encargos.encargo WITH CHECK ADD CONSTRAINT fk_encargo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_denuncia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_denuncia'))
 ALTER TABLE encargos.encargo_denuncia WITH CHECK ADD CONSTRAINT fk_encargo_denuncia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_denuncia'))
 ALTER TABLE encargos.encargo_denuncia WITH CHECK ADD CONSTRAINT fk_encargo_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_denuncia'))
 ALTER TABLE encargos.encargo_denuncia WITH CHECK ADD CONSTRAINT fk_encargo_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_orden_judicial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_orden_judicial'))
 ALTER TABLE encargos.encargo_orden_judicial WITH CHECK ADD CONSTRAINT fk_encargo_orden_judicial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_orden_judicial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_orden_judicial'))
 ALTER TABLE encargos.encargo_orden_judicial WITH CHECK ADD CONSTRAINT fk_encargo_orden_judicial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_orden_judicial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_orden_judicial'))
 ALTER TABLE encargos.encargo_orden_judicial WITH CHECK ADD CONSTRAINT fk_encargo_orden_judicial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_persona_diligencia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_persona_diligencia'))
 ALTER TABLE encargos.encargo_persona_diligencia WITH CHECK ADD CONSTRAINT fk_encargo_persona_diligencia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_persona_diligencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_persona_diligencia'))
 ALTER TABLE encargos.encargo_persona_diligencia WITH CHECK ADD CONSTRAINT fk_encargo_persona_diligencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_encargo_persona_diligencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.encargo_persona_diligencia'))
 ALTER TABLE encargos.encargo_persona_diligencia WITH CHECK ADD CONSTRAINT fk_encargo_persona_diligencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_judicial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.orden_judicial'))
 ALTER TABLE encargos.orden_judicial WITH CHECK ADD CONSTRAINT fk_orden_judicial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_judicial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.orden_judicial'))
 ALTER TABLE encargos.orden_judicial WITH CHECK ADD CONSTRAINT fk_orden_judicial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_orden_judicial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.orden_judicial'))
 ALTER TABLE encargos.orden_judicial WITH CHECK ADD CONSTRAINT fk_orden_judicial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_encargo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.tarea_encargo'))
 ALTER TABLE encargos.tarea_encargo WITH CHECK ADD CONSTRAINT fk_tarea_encargo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_encargo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.tarea_encargo'))
 ALTER TABLE encargos.tarea_encargo WITH CHECK ADD CONSTRAINT fk_tarea_encargo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_encargo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.tarea_encargo'))
 ALTER TABLE encargos.tarea_encargo WITH CHECK ADD CONSTRAINT fk_tarea_encargo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_encargo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.tipo_encargo'))
 ALTER TABLE encargos.tipo_encargo WITH CHECK ADD CONSTRAINT fk_tipo_encargo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_encargo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.tipo_encargo'))
 ALTER TABLE encargos.tipo_encargo WITH CHECK ADD CONSTRAINT fk_tipo_encargo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_encargo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.tipo_encargo'))
 ALTER TABLE encargos.tipo_encargo WITH CHECK ADD CONSTRAINT fk_tipo_encargo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_orden_judicial_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'encargos.tipo_orden_judicial'))
 ALTER TABLE encargos.tipo_orden_judicial WITH CHECK ADD CONSTRAINT fk_tipo_orden_judicial_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_orden_judicial_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'encargos.tipo_orden_judicial'))
 ALTER TABLE encargos.tipo_orden_judicial WITH CHECK ADD CONSTRAINT fk_tipo_orden_judicial_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_orden_judicial_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'encargos.tipo_orden_judicial'))
 ALTER TABLE encargos.tipo_orden_judicial WITH CHECK ADD CONSTRAINT fk_tipo_orden_judicial_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: evidencias (23 tablas, +114 col, +61 fk) ============================== */

/* --- evidencias: columnas --- */
IF COL_LENGTH(N'evidencias.arma', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.arma ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.arma', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.arma ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.arma', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.arma ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.arma', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.arma ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cadena_custodia', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.cadena_custodia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.cadena_custodia', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cadena_custodia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cadena_custodia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cadena_custodia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cadena_custodia', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cadena_custodia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cadena_custodia', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cadena_custodia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cadena_custodia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cadena_custodia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_catalogo_armas', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_catalogo_armas ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_catalogo_armas', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_catalogo_armas ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_catalogo_armas', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_catalogo_armas ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_catalogo_armas', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_catalogo_armas ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_clasificacion_arma', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_clasificacion_arma ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_clasificacion_arma', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_clasificacion_arma ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_clasificacion_arma', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cat_clasificacion_arma ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_clasificacion_arma', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_clasificacion_arma ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_clasificacion_arma', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_clasificacion_arma ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_droga', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_droga ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_droga', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_droga ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_droga', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_droga ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_droga', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_droga ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_estado_especie', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_estado_especie ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_estado_especie', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_estado_especie ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_estado_especie', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cat_estado_especie ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_estado_especie', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_estado_especie ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_estado_especie', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_estado_especie ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_institucion', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_institucion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_institucion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_institucion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_institucion', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cat_institucion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_institucion', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_institucion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_institucion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_institucion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_proposito_transferencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_proposito_transferencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_proposito_transferencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_proposito_transferencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_proposito_transferencia', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cat_proposito_transferencia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_proposito_transferencia', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_proposito_transferencia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_proposito_transferencia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_proposito_transferencia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_custodia', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_tipo_custodia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_custodia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_tipo_custodia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_custodia', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cat_tipo_custodia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_custodia', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_tipo_custodia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_custodia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_tipo_custodia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_extension_especie', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.cat_tipo_extension_especie ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_extension_especie', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.cat_tipo_extension_especie ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_extension_especie', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.cat_tipo_extension_especie ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_extension_especie', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.cat_tipo_extension_especie ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.cat_tipo_extension_especie', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.cat_tipo_extension_especie ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_arma', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_arma ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_arma', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_arma ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_arma', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_arma ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_arma', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_arma ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_arma', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_arma ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_arma', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_arma ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_droga', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_droga ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_droga', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_droga ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_droga', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_droga ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_droga', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_droga ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_droga', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_droga ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_droga', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_droga ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_electronico', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_electronico ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_electronico', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_electronico ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_electronico', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_electronico ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_electronico', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_electronico ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_electronico', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_electronico ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_electronico', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_electronico ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_historial_estado', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_historial_estado ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_historial_estado', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_historial_estado ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_historial_estado', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_historial_estado ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_historial_estado', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_historial_estado ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_historial_estado', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_historial_estado ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_historial_estado', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_historial_estado ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_otras', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_otras ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_otras', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_otras ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_otras', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_otras ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_otras', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_otras ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_otras', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_otras ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_otras', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_otras ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_retencion', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_retencion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_retencion', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_retencion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_retencion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_retencion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_retencion', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_retencion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_retencion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_retencion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_sello', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_sello ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_sello', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_sello ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_sello', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_sello ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_sello', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_sello ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_sello', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_sello ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_sello', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_sello ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_vehiculo', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.especie_vehiculo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.especie_vehiculo', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.especie_vehiculo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.especie_vehiculo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.especie_vehiculo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.especie_vehiculo', N'fecha_creacion') IS NULL
 ALTER TABLE evidencias.especie_vehiculo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_vehiculo', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.especie_vehiculo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.especie_vehiculo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.especie_vehiculo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'evidencias.evidencia', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.evidencia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.evidencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.evidencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.evidencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.evidencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.evidencia_lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.evidencia_lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.evidencia_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.evidencia_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.evidencia_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.evidencia_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.evidencia_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.evidencia_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.incautacion', N'id_usuario_creador') IS NULL
 ALTER TABLE evidencias.incautacion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'evidencias.incautacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE evidencias.incautacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'evidencias.incautacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE evidencias.incautacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'evidencias.incautacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE evidencias.incautacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'evidencias.incautacion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE evidencias.incautacion ADD fecha_eliminacion_logica timestamp NULL;

/* --- evidencias: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_arma_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma WITH CHECK ADD CONSTRAINT fk_arma_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_arma_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma WITH CHECK ADD CONSTRAINT fk_arma_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_arma_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.arma'))
 ALTER TABLE evidencias.arma WITH CHECK ADD CONSTRAINT fk_arma_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cadena_custodia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.cadena_custodia'))
 ALTER TABLE evidencias.cadena_custodia WITH CHECK ADD CONSTRAINT fk_cadena_custodia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cadena_custodia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cadena_custodia'))
 ALTER TABLE evidencias.cadena_custodia WITH CHECK ADD CONSTRAINT fk_cadena_custodia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cadena_custodia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cadena_custodia'))
 ALTER TABLE evidencias.cadena_custodia WITH CHECK ADD CONSTRAINT fk_cadena_custodia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_catalogo_armas_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_catalogo_armas'))
 ALTER TABLE evidencias.cat_catalogo_armas WITH CHECK ADD CONSTRAINT fk_cat_catalogo_armas_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_catalogo_armas_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_catalogo_armas'))
 ALTER TABLE evidencias.cat_catalogo_armas WITH CHECK ADD CONSTRAINT fk_cat_catalogo_armas_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_clasificacion_arma_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_clasificacion_arma'))
 ALTER TABLE evidencias.cat_clasificacion_arma WITH CHECK ADD CONSTRAINT fk_cat_clasificacion_arma_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_clasificacion_arma_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_clasificacion_arma'))
 ALTER TABLE evidencias.cat_clasificacion_arma WITH CHECK ADD CONSTRAINT fk_cat_clasificacion_arma_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_droga_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_droga'))
 ALTER TABLE evidencias.cat_droga WITH CHECK ADD CONSTRAINT fk_cat_droga_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_droga_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_droga'))
 ALTER TABLE evidencias.cat_droga WITH CHECK ADD CONSTRAINT fk_cat_droga_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_especie_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_estado_especie'))
 ALTER TABLE evidencias.cat_estado_especie WITH CHECK ADD CONSTRAINT fk_cat_estado_especie_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_estado_especie_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_estado_especie'))
 ALTER TABLE evidencias.cat_estado_especie WITH CHECK ADD CONSTRAINT fk_cat_estado_especie_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_institucion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_institucion'))
 ALTER TABLE evidencias.cat_institucion WITH CHECK ADD CONSTRAINT fk_cat_institucion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_institucion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_institucion'))
 ALTER TABLE evidencias.cat_institucion WITH CHECK ADD CONSTRAINT fk_cat_institucion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_proposito_transferencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_proposito_transferencia'))
 ALTER TABLE evidencias.cat_proposito_transferencia WITH CHECK ADD CONSTRAINT fk_cat_proposito_transferencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_proposito_transferencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_proposito_transferencia'))
 ALTER TABLE evidencias.cat_proposito_transferencia WITH CHECK ADD CONSTRAINT fk_cat_proposito_transferencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_custodia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_tipo_custodia'))
 ALTER TABLE evidencias.cat_tipo_custodia WITH CHECK ADD CONSTRAINT fk_cat_tipo_custodia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_custodia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_tipo_custodia'))
 ALTER TABLE evidencias.cat_tipo_custodia WITH CHECK ADD CONSTRAINT fk_cat_tipo_custodia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_extension_especie_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_tipo_extension_especie'))
 ALTER TABLE evidencias.cat_tipo_extension_especie WITH CHECK ADD CONSTRAINT fk_cat_tipo_extension_especie_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_extension_especie_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.cat_tipo_extension_especie'))
 ALTER TABLE evidencias.cat_tipo_extension_especie WITH CHECK ADD CONSTRAINT fk_cat_tipo_extension_especie_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie'))
 ALTER TABLE evidencias.especie WITH CHECK ADD CONSTRAINT fk_especie_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie'))
 ALTER TABLE evidencias.especie WITH CHECK ADD CONSTRAINT fk_especie_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie'))
 ALTER TABLE evidencias.especie WITH CHECK ADD CONSTRAINT fk_especie_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_arma_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_arma'))
 ALTER TABLE evidencias.especie_arma WITH CHECK ADD CONSTRAINT fk_especie_arma_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_arma_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_arma'))
 ALTER TABLE evidencias.especie_arma WITH CHECK ADD CONSTRAINT fk_especie_arma_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_arma_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_arma'))
 ALTER TABLE evidencias.especie_arma WITH CHECK ADD CONSTRAINT fk_especie_arma_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_droga_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_droga'))
 ALTER TABLE evidencias.especie_droga WITH CHECK ADD CONSTRAINT fk_especie_droga_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_droga_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_droga'))
 ALTER TABLE evidencias.especie_droga WITH CHECK ADD CONSTRAINT fk_especie_droga_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_droga_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_droga'))
 ALTER TABLE evidencias.especie_droga WITH CHECK ADD CONSTRAINT fk_especie_droga_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_electronico_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_electronico'))
 ALTER TABLE evidencias.especie_electronico WITH CHECK ADD CONSTRAINT fk_especie_electronico_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_electronico_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_electronico'))
 ALTER TABLE evidencias.especie_electronico WITH CHECK ADD CONSTRAINT fk_especie_electronico_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_electronico_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_electronico'))
 ALTER TABLE evidencias.especie_electronico WITH CHECK ADD CONSTRAINT fk_especie_electronico_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_historial_estado_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_historial_estado'))
 ALTER TABLE evidencias.especie_historial_estado WITH CHECK ADD CONSTRAINT fk_especie_historial_estado_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_historial_estado_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_historial_estado'))
 ALTER TABLE evidencias.especie_historial_estado WITH CHECK ADD CONSTRAINT fk_especie_historial_estado_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_historial_estado_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_historial_estado'))
 ALTER TABLE evidencias.especie_historial_estado WITH CHECK ADD CONSTRAINT fk_especie_historial_estado_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_lugar'))
 ALTER TABLE evidencias.especie_lugar WITH CHECK ADD CONSTRAINT fk_especie_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_lugar'))
 ALTER TABLE evidencias.especie_lugar WITH CHECK ADD CONSTRAINT fk_especie_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_lugar'))
 ALTER TABLE evidencias.especie_lugar WITH CHECK ADD CONSTRAINT fk_especie_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_otras_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_otras'))
 ALTER TABLE evidencias.especie_otras WITH CHECK ADD CONSTRAINT fk_especie_otras_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_otras_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_otras'))
 ALTER TABLE evidencias.especie_otras WITH CHECK ADD CONSTRAINT fk_especie_otras_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_otras_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_otras'))
 ALTER TABLE evidencias.especie_otras WITH CHECK ADD CONSTRAINT fk_especie_otras_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_retencion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_retencion'))
 ALTER TABLE evidencias.especie_retencion WITH CHECK ADD CONSTRAINT fk_especie_retencion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_retencion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_retencion'))
 ALTER TABLE evidencias.especie_retencion WITH CHECK ADD CONSTRAINT fk_especie_retencion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_retencion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_retencion'))
 ALTER TABLE evidencias.especie_retencion WITH CHECK ADD CONSTRAINT fk_especie_retencion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_sello_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_sello'))
 ALTER TABLE evidencias.especie_sello WITH CHECK ADD CONSTRAINT fk_especie_sello_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_sello_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_sello'))
 ALTER TABLE evidencias.especie_sello WITH CHECK ADD CONSTRAINT fk_especie_sello_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_sello_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_sello'))
 ALTER TABLE evidencias.especie_sello WITH CHECK ADD CONSTRAINT fk_especie_sello_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_vehiculo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_vehiculo'))
 ALTER TABLE evidencias.especie_vehiculo WITH CHECK ADD CONSTRAINT fk_especie_vehiculo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_vehiculo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_vehiculo'))
 ALTER TABLE evidencias.especie_vehiculo WITH CHECK ADD CONSTRAINT fk_especie_vehiculo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_especie_vehiculo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.especie_vehiculo'))
 ALTER TABLE evidencias.especie_vehiculo WITH CHECK ADD CONSTRAINT fk_especie_vehiculo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evidencia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.evidencia'))
 ALTER TABLE evidencias.evidencia WITH CHECK ADD CONSTRAINT fk_evidencia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evidencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.evidencia'))
 ALTER TABLE evidencias.evidencia WITH CHECK ADD CONSTRAINT fk_evidencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evidencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.evidencia'))
 ALTER TABLE evidencias.evidencia WITH CHECK ADD CONSTRAINT fk_evidencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evidencia_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.evidencia_lugar'))
 ALTER TABLE evidencias.evidencia_lugar WITH CHECK ADD CONSTRAINT fk_evidencia_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evidencia_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.evidencia_lugar'))
 ALTER TABLE evidencias.evidencia_lugar WITH CHECK ADD CONSTRAINT fk_evidencia_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evidencia_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.evidencia_lugar'))
 ALTER TABLE evidencias.evidencia_lugar WITH CHECK ADD CONSTRAINT fk_evidencia_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_incautacion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'evidencias.incautacion'))
 ALTER TABLE evidencias.incautacion WITH CHECK ADD CONSTRAINT fk_incautacion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_incautacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'evidencias.incautacion'))
 ALTER TABLE evidencias.incautacion WITH CHECK ADD CONSTRAINT fk_incautacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_incautacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'evidencias.incautacion'))
 ALTER TABLE evidencias.incautacion WITH CHECK ADD CONSTRAINT fk_incautacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: investigacion (23 tablas, +98 col, +57 fk) ============================== */

/* --- investigacion: columnas --- */
IF COL_LENGTH(N'investigacion.cat_lugar_general_hecho', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_lugar_general_hecho ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_lugar_general_hecho', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_lugar_general_hecho ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_lugar_general_hecho', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_lugar_general_hecho ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_lugar_general_hecho', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_lugar_general_hecho ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_lugar_general_hecho', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_lugar_general_hecho ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_detalle_lugar_general_hecho', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_detalle_lugar_general_hecho', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_detalle_lugar_general_hecho', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_detalle_lugar_general_hecho', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_detalle_lugar_general_hecho', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.hecho', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.hecho ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.hecho', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.hecho ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.hecho', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.hecho ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_forma_contacto', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_forma_contacto ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_forma_contacto', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_forma_contacto ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_forma_contacto', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_forma_contacto ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_punto_acceso', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_punto_acceso ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_punto_acceso', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_punto_acceso ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_punto_acceso', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_punto_acceso ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_transporte_utilizado', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_transporte_utilizado ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_transporte_utilizado', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_transporte_utilizado ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_transporte_utilizado', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_transporte_utilizado ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.hecho_persona_rol', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.hecho_persona_rol ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_persona_rol', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.hecho_persona_rol ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_persona_rol', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.hecho_persona_rol ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_persona_rol', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.hecho_persona_rol ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.clasificacion_delito', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.clasificacion_delito ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.clasificacion_delito', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.clasificacion_delito ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.clasificacion_delito', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.clasificacion_delito ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.clasificacion_delito', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.clasificacion_delito ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.clasificacion_delito', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.clasificacion_delito ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.clasificacion_delito', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.clasificacion_delito ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_seccion_catalogo', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_seccion_catalogo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_seccion_catalogo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_seccion_catalogo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_seccion_catalogo', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_seccion_catalogo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_seccion_catalogo', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_seccion_catalogo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_seccion_catalogo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_seccion_catalogo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_familia_delito', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_familia_delito ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_familia_delito', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_familia_delito ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_familia_delito', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_familia_delito ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_familia_delito', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_familia_delito ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_familia_delito', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_familia_delito ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_delito', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_delito ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_delito', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_delito ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_delito', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_delito ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.delito_imputado', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.delito_imputado ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.delito_imputado', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.delito_imputado ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.delito_imputado', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.delito_imputado ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.hecho_lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.hecho_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.hecho_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.hecho_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.hecho_fenomeno', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.hecho_fenomeno ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_fenomeno', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.hecho_fenomeno ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_fenomeno', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.hecho_fenomeno ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.hecho_fenomeno', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.hecho_fenomeno ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.hecho_fenomeno', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.hecho_fenomeno ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.fenomeno_delictual', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.fenomeno_delictual ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.fenomeno_delictual', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.fenomeno_delictual ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.fenomeno_delictual', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.fenomeno_delictual ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.fenomeno_delictual', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.fenomeno_delictual ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_circunstancia_modificatoria', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_circunstancia_modificatoria ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_circunstancia_modificatoria', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_circunstancia_modificatoria ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_circunstancia_modificatoria', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_circunstancia_modificatoria ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_circunstancia_modificatoria', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_circunstancia_modificatoria ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_circunstancia_modificatoria', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_circunstancia_modificatoria ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_grado_ejecucion', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_grado_ejecucion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_grado_ejecucion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_grado_ejecucion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_grado_ejecucion', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_grado_ejecucion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_grado_ejecucion', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_grado_ejecucion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_grado_ejecucion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_grado_ejecucion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_grado_participacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_grado_participacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_grado_participacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_grado_participacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_grado_participacion', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.cat_grado_participacion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_grado_participacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.cat_grado_participacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_grado_participacion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_grado_participacion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.cat_movil', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.cat_movil ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.cat_movil', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.cat_movil ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.cat_movil', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.cat_movil ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.delito_circunstancia', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.delito_circunstancia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.delito_circunstancia', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.delito_circunstancia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.delito_circunstancia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.delito_circunstancia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.delito_circunstancia', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.delito_circunstancia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.delito_circunstancia', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.delito_circunstancia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.delito_circunstancia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.delito_circunstancia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'investigacion.delito_imputado_persona', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.delito_imputado_persona ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.delito_imputado_persona', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.delito_imputado_persona ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.delito_imputado_persona', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.delito_imputado_persona ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.delito_imputado_persona', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.delito_imputado_persona ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.protocolo_delito', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.protocolo_delito ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.protocolo_delito', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.protocolo_delito ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.protocolo_delito', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.protocolo_delito ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.subtipo_delito_secuestro', N'id_usuario_creador') IS NULL
 ALTER TABLE investigacion.subtipo_delito_secuestro ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'investigacion.subtipo_delito_secuestro', N'id_usuario_modificador') IS NULL
 ALTER TABLE investigacion.subtipo_delito_secuestro ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'investigacion.subtipo_delito_secuestro', N'id_usuario_eliminador') IS NULL
 ALTER TABLE investigacion.subtipo_delito_secuestro ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'investigacion.subtipo_delito_secuestro', N'fecha_creacion') IS NULL
 ALTER TABLE investigacion.subtipo_delito_secuestro ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'investigacion.subtipo_delito_secuestro', N'fecha_actualizacion') IS NULL
 ALTER TABLE investigacion.subtipo_delito_secuestro ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'investigacion.subtipo_delito_secuestro', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE investigacion.subtipo_delito_secuestro ADD fecha_eliminacion_logica timestamp NULL;

/* --- investigacion: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_lugar_general_hecho_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_lugar_general_hecho'))
 ALTER TABLE investigacion.cat_lugar_general_hecho WITH CHECK ADD CONSTRAINT fk_cat_lugar_general_hecho_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_lugar_general_hecho_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_lugar_general_hecho'))
 ALTER TABLE investigacion.cat_lugar_general_hecho WITH CHECK ADD CONSTRAINT fk_cat_lugar_general_hecho_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_detalle_lugar_general_hecho_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'))
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho WITH CHECK ADD CONSTRAINT fk_cat_detalle_lugar_general_hecho_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_detalle_lugar_general_hecho_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_detalle_lugar_general_hecho'))
 ALTER TABLE investigacion.cat_detalle_lugar_general_hecho WITH CHECK ADD CONSTRAINT fk_cat_detalle_lugar_general_hecho_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho'))
 ALTER TABLE investigacion.hecho WITH CHECK ADD CONSTRAINT fk_hecho_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho'))
 ALTER TABLE investigacion.hecho WITH CHECK ADD CONSTRAINT fk_hecho_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho'))
 ALTER TABLE investigacion.hecho WITH CHECK ADD CONSTRAINT fk_hecho_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_forma_contacto_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_forma_contacto'))
 ALTER TABLE investigacion.cat_forma_contacto WITH CHECK ADD CONSTRAINT fk_cat_forma_contacto_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_forma_contacto_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_forma_contacto'))
 ALTER TABLE investigacion.cat_forma_contacto WITH CHECK ADD CONSTRAINT fk_cat_forma_contacto_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_punto_acceso_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_punto_acceso'))
 ALTER TABLE investigacion.cat_punto_acceso WITH CHECK ADD CONSTRAINT fk_cat_punto_acceso_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_punto_acceso_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_punto_acceso'))
 ALTER TABLE investigacion.cat_punto_acceso WITH CHECK ADD CONSTRAINT fk_cat_punto_acceso_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_transporte_utilizado_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_transporte_utilizado'))
 ALTER TABLE investigacion.cat_transporte_utilizado WITH CHECK ADD CONSTRAINT fk_cat_transporte_utilizado_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_transporte_utilizado_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_transporte_utilizado'))
 ALTER TABLE investigacion.cat_transporte_utilizado WITH CHECK ADD CONSTRAINT fk_cat_transporte_utilizado_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_persona_rol_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_persona_rol'))
 ALTER TABLE investigacion.hecho_persona_rol WITH CHECK ADD CONSTRAINT fk_hecho_persona_rol_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_persona_rol_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_persona_rol'))
 ALTER TABLE investigacion.hecho_persona_rol WITH CHECK ADD CONSTRAINT fk_hecho_persona_rol_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_persona_rol_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_persona_rol'))
 ALTER TABLE investigacion.hecho_persona_rol WITH CHECK ADD CONSTRAINT fk_hecho_persona_rol_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_clasificacion_delito_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.clasificacion_delito'))
 ALTER TABLE investigacion.clasificacion_delito WITH CHECK ADD CONSTRAINT fk_clasificacion_delito_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_clasificacion_delito_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.clasificacion_delito'))
 ALTER TABLE investigacion.clasificacion_delito WITH CHECK ADD CONSTRAINT fk_clasificacion_delito_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_clasificacion_delito_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.clasificacion_delito'))
 ALTER TABLE investigacion.clasificacion_delito WITH CHECK ADD CONSTRAINT fk_clasificacion_delito_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_seccion_catalogo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_seccion_catalogo'))
 ALTER TABLE investigacion.cat_seccion_catalogo WITH CHECK ADD CONSTRAINT fk_cat_seccion_catalogo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_seccion_catalogo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_seccion_catalogo'))
 ALTER TABLE investigacion.cat_seccion_catalogo WITH CHECK ADD CONSTRAINT fk_cat_seccion_catalogo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_familia_delito_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_familia_delito'))
 ALTER TABLE investigacion.cat_familia_delito WITH CHECK ADD CONSTRAINT fk_cat_familia_delito_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_familia_delito_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_familia_delito'))
 ALTER TABLE investigacion.cat_familia_delito WITH CHECK ADD CONSTRAINT fk_cat_familia_delito_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_delito_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_delito'))
 ALTER TABLE investigacion.cat_delito WITH CHECK ADD CONSTRAINT fk_cat_delito_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_delito_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_delito'))
 ALTER TABLE investigacion.cat_delito WITH CHECK ADD CONSTRAINT fk_cat_delito_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_imputado_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_imputado'))
 ALTER TABLE investigacion.delito_imputado WITH CHECK ADD CONSTRAINT fk_delito_imputado_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_imputado_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_imputado'))
 ALTER TABLE investigacion.delito_imputado WITH CHECK ADD CONSTRAINT fk_delito_imputado_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_imputado_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_imputado'))
 ALTER TABLE investigacion.delito_imputado WITH CHECK ADD CONSTRAINT fk_delito_imputado_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_lugar'))
 ALTER TABLE investigacion.hecho_lugar WITH CHECK ADD CONSTRAINT fk_hecho_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_lugar'))
 ALTER TABLE investigacion.hecho_lugar WITH CHECK ADD CONSTRAINT fk_hecho_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_lugar'))
 ALTER TABLE investigacion.hecho_lugar WITH CHECK ADD CONSTRAINT fk_hecho_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_fenomeno_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_fenomeno'))
 ALTER TABLE investigacion.hecho_fenomeno WITH CHECK ADD CONSTRAINT fk_hecho_fenomeno_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_fenomeno_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_fenomeno'))
 ALTER TABLE investigacion.hecho_fenomeno WITH CHECK ADD CONSTRAINT fk_hecho_fenomeno_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_hecho_fenomeno_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.hecho_fenomeno'))
 ALTER TABLE investigacion.hecho_fenomeno WITH CHECK ADD CONSTRAINT fk_hecho_fenomeno_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fenomeno_delictual_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.fenomeno_delictual'))
 ALTER TABLE investigacion.fenomeno_delictual WITH CHECK ADD CONSTRAINT fk_fenomeno_delictual_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fenomeno_delictual_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.fenomeno_delictual'))
 ALTER TABLE investigacion.fenomeno_delictual WITH CHECK ADD CONSTRAINT fk_fenomeno_delictual_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fenomeno_delictual_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.fenomeno_delictual'))
 ALTER TABLE investigacion.fenomeno_delictual WITH CHECK ADD CONSTRAINT fk_fenomeno_delictual_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_circunstancia_modificatoria_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_circunstancia_modificatoria'))
 ALTER TABLE investigacion.cat_circunstancia_modificatoria WITH CHECK ADD CONSTRAINT fk_cat_circunstancia_modificatoria_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_circunstancia_modificatoria_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_circunstancia_modificatoria'))
 ALTER TABLE investigacion.cat_circunstancia_modificatoria WITH CHECK ADD CONSTRAINT fk_cat_circunstancia_modificatoria_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_grado_ejecucion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_grado_ejecucion'))
 ALTER TABLE investigacion.cat_grado_ejecucion WITH CHECK ADD CONSTRAINT fk_cat_grado_ejecucion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_grado_ejecucion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_grado_ejecucion'))
 ALTER TABLE investigacion.cat_grado_ejecucion WITH CHECK ADD CONSTRAINT fk_cat_grado_ejecucion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_grado_participacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_grado_participacion'))
 ALTER TABLE investigacion.cat_grado_participacion WITH CHECK ADD CONSTRAINT fk_cat_grado_participacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_grado_participacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_grado_participacion'))
 ALTER TABLE investigacion.cat_grado_participacion WITH CHECK ADD CONSTRAINT fk_cat_grado_participacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_movil_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_movil'))
 ALTER TABLE investigacion.cat_movil WITH CHECK ADD CONSTRAINT fk_cat_movil_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_movil_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.cat_movil'))
 ALTER TABLE investigacion.cat_movil WITH CHECK ADD CONSTRAINT fk_cat_movil_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_circunstancia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_circunstancia'))
 ALTER TABLE investigacion.delito_circunstancia WITH CHECK ADD CONSTRAINT fk_delito_circunstancia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_circunstancia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_circunstancia'))
 ALTER TABLE investigacion.delito_circunstancia WITH CHECK ADD CONSTRAINT fk_delito_circunstancia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_circunstancia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_circunstancia'))
 ALTER TABLE investigacion.delito_circunstancia WITH CHECK ADD CONSTRAINT fk_delito_circunstancia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_imputado_persona_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_imputado_persona'))
 ALTER TABLE investigacion.delito_imputado_persona WITH CHECK ADD CONSTRAINT fk_delito_imputado_persona_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_imputado_persona_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_imputado_persona'))
 ALTER TABLE investigacion.delito_imputado_persona WITH CHECK ADD CONSTRAINT fk_delito_imputado_persona_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_delito_imputado_persona_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.delito_imputado_persona'))
 ALTER TABLE investigacion.delito_imputado_persona WITH CHECK ADD CONSTRAINT fk_delito_imputado_persona_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_protocolo_delito_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.protocolo_delito'))
 ALTER TABLE investigacion.protocolo_delito WITH CHECK ADD CONSTRAINT fk_protocolo_delito_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_protocolo_delito_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.protocolo_delito'))
 ALTER TABLE investigacion.protocolo_delito WITH CHECK ADD CONSTRAINT fk_protocolo_delito_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_protocolo_delito_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.protocolo_delito'))
 ALTER TABLE investigacion.protocolo_delito WITH CHECK ADD CONSTRAINT fk_protocolo_delito_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_subtipo_delito_secuestro_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'investigacion.subtipo_delito_secuestro'))
 ALTER TABLE investigacion.subtipo_delito_secuestro WITH CHECK ADD CONSTRAINT fk_subtipo_delito_secuestro_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_subtipo_delito_secuestro_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'investigacion.subtipo_delito_secuestro'))
 ALTER TABLE investigacion.subtipo_delito_secuestro WITH CHECK ADD CONSTRAINT fk_subtipo_delito_secuestro_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_subtipo_delito_secuestro_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'investigacion.subtipo_delito_secuestro'))
 ALTER TABLE investigacion.subtipo_delito_secuestro WITH CHECK ADD CONSTRAINT fk_subtipo_delito_secuestro_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: migracion (4 tablas, +16 col, +11 fk) ============================== */

/* --- migracion: columnas --- */
IF COL_LENGTH(N'migracion.cat_tipo_infraccion_migratoria', N'id_usuario_modificador') IS NULL
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'migracion.cat_tipo_infraccion_migratoria', N'id_usuario_eliminador') IS NULL
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'migracion.cat_tipo_infraccion_migratoria', N'fecha_creacion') IS NULL
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'migracion.cat_tipo_infraccion_migratoria', N'fecha_actualizacion') IS NULL
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'migracion.cat_tipo_infraccion_migratoria', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'migracion.denuncia_administrativa_migratoria', N'id_usuario_creador') IS NULL
 ALTER TABLE migracion.denuncia_administrativa_migratoria ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'migracion.denuncia_administrativa_migratoria', N'id_usuario_modificador') IS NULL
 ALTER TABLE migracion.denuncia_administrativa_migratoria ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'migracion.denuncia_administrativa_migratoria', N'id_usuario_eliminador') IS NULL
 ALTER TABLE migracion.denuncia_administrativa_migratoria ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'migracion.denuncia_administrativa_migratoria', N'fecha_actualizacion') IS NULL
 ALTER TABLE migracion.denuncia_administrativa_migratoria ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'migracion.denuncia_administrativa_migratoria', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE migracion.denuncia_administrativa_migratoria ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'migracion.expulsion', N'id_usuario_creador') IS NULL
 ALTER TABLE migracion.expulsion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'migracion.expulsion', N'id_usuario_modificador') IS NULL
 ALTER TABLE migracion.expulsion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'migracion.expulsion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE migracion.expulsion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'migracion.fiscalizacion_planificada', N'id_usuario_creador') IS NULL
 ALTER TABLE migracion.fiscalizacion_planificada ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'migracion.fiscalizacion_planificada', N'id_usuario_modificador') IS NULL
 ALTER TABLE migracion.fiscalizacion_planificada ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'migracion.fiscalizacion_planificada', N'id_usuario_eliminador') IS NULL
 ALTER TABLE migracion.fiscalizacion_planificada ADD id_usuario_eliminador INT NULL;

/* --- migracion: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_infraccion_migratoria_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'migracion.cat_tipo_infraccion_migratoria'))
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria WITH CHECK ADD CONSTRAINT fk_cat_tipo_infraccion_migratoria_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_infraccion_migratoria_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'migracion.cat_tipo_infraccion_migratoria'))
 ALTER TABLE migracion.cat_tipo_infraccion_migratoria WITH CHECK ADD CONSTRAINT fk_cat_tipo_infraccion_migratoria_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_administrativa_migratoria_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'migracion.denuncia_administrativa_migratoria'))
 ALTER TABLE migracion.denuncia_administrativa_migratoria WITH CHECK ADD CONSTRAINT fk_denuncia_administrativa_migratoria_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_administrativa_migratoria_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'migracion.denuncia_administrativa_migratoria'))
 ALTER TABLE migracion.denuncia_administrativa_migratoria WITH CHECK ADD CONSTRAINT fk_denuncia_administrativa_migratoria_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_denuncia_administrativa_migratoria_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'migracion.denuncia_administrativa_migratoria'))
 ALTER TABLE migracion.denuncia_administrativa_migratoria WITH CHECK ADD CONSTRAINT fk_denuncia_administrativa_migratoria_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_expulsion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'migracion.expulsion'))
 ALTER TABLE migracion.expulsion WITH CHECK ADD CONSTRAINT fk_expulsion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_expulsion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'migracion.expulsion'))
 ALTER TABLE migracion.expulsion WITH CHECK ADD CONSTRAINT fk_expulsion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_expulsion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'migracion.expulsion'))
 ALTER TABLE migracion.expulsion WITH CHECK ADD CONSTRAINT fk_expulsion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fiscalizacion_planificada_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'migracion.fiscalizacion_planificada'))
 ALTER TABLE migracion.fiscalizacion_planificada WITH CHECK ADD CONSTRAINT fk_fiscalizacion_planificada_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fiscalizacion_planificada_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'migracion.fiscalizacion_planificada'))
 ALTER TABLE migracion.fiscalizacion_planificada WITH CHECK ADD CONSTRAINT fk_fiscalizacion_planificada_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fiscalizacion_planificada_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'migracion.fiscalizacion_planificada'))
 ALTER TABLE migracion.fiscalizacion_planificada WITH CHECK ADD CONSTRAINT fk_fiscalizacion_planificada_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: organizacion (10 tablas, +47 col, +24 fk) ============================== */

/* --- organizacion: columnas --- */
IF COL_LENGTH(N'organizacion.unidad', N'id_usuario_creador') IS NULL
 ALTER TABLE organizacion.unidad ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'organizacion.unidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.unidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.unidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.unidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.unidad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.unidad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_organismo_externo', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.cat_organismo_externo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.cat_organismo_externo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.cat_organismo_externo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.cat_organismo_externo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.cat_organismo_externo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_organismo', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.cat_tipo_organismo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_organismo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.cat_tipo_organismo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_organismo', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.cat_tipo_organismo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_organismo', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.cat_tipo_organismo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_organismo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.cat_tipo_organismo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_cargo_funcion', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.cat_cargo_funcion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.cat_cargo_funcion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.cat_cargo_funcion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.cat_cargo_funcion', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.cat_cargo_funcion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_cargo_funcion', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.cat_cargo_funcion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_cargo_funcion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.cat_cargo_funcion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_nivel_organismo', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.cat_nivel_organismo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.cat_nivel_organismo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.cat_nivel_organismo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.cat_nivel_organismo', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.cat_nivel_organismo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_nivel_organismo', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.cat_nivel_organismo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_nivel_organismo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.cat_nivel_organismo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_relacion_unidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.cat_tipo_relacion_unidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_relacion_unidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.cat_tipo_relacion_unidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_relacion_unidad', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.cat_tipo_relacion_unidad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_relacion_unidad', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.cat_tipo_relacion_unidad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_relacion_unidad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.cat_tipo_relacion_unidad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_unidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.cat_tipo_unidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_unidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.cat_tipo_unidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_unidad', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.cat_tipo_unidad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_unidad', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.cat_tipo_unidad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.cat_tipo_unidad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.cat_tipo_unidad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.funcionario', N'id_usuario_creador') IS NULL
 ALTER TABLE organizacion.funcionario ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'organizacion.funcionario', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.funcionario ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.funcionario', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.funcionario ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.ofan_fiscalia', N'id_usuario_creador') IS NULL
 ALTER TABLE organizacion.ofan_fiscalia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'organizacion.ofan_fiscalia', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.ofan_fiscalia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.ofan_fiscalia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.ofan_fiscalia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.ofan_fiscalia', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.ofan_fiscalia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.ofan_fiscalia', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.ofan_fiscalia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.ofan_fiscalia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.ofan_fiscalia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'organizacion.relacion_unidad', N'id_usuario_creador') IS NULL
 ALTER TABLE organizacion.relacion_unidad ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'organizacion.relacion_unidad', N'id_usuario_modificador') IS NULL
 ALTER TABLE organizacion.relacion_unidad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'organizacion.relacion_unidad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE organizacion.relacion_unidad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'organizacion.relacion_unidad', N'fecha_creacion') IS NULL
 ALTER TABLE organizacion.relacion_unidad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'organizacion.relacion_unidad', N'fecha_actualizacion') IS NULL
 ALTER TABLE organizacion.relacion_unidad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'organizacion.relacion_unidad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE organizacion.relacion_unidad ADD fecha_eliminacion_logica timestamp NULL;

/* --- organizacion: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_unidad_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'organizacion.unidad'))
 ALTER TABLE organizacion.unidad WITH CHECK ADD CONSTRAINT fk_unidad_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_unidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.unidad'))
 ALTER TABLE organizacion.unidad WITH CHECK ADD CONSTRAINT fk_unidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_unidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.unidad'))
 ALTER TABLE organizacion.unidad WITH CHECK ADD CONSTRAINT fk_unidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_organismo_externo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_organismo_externo'))
 ALTER TABLE organizacion.cat_organismo_externo WITH CHECK ADD CONSTRAINT fk_cat_organismo_externo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_organismo_externo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_organismo_externo'))
 ALTER TABLE organizacion.cat_organismo_externo WITH CHECK ADD CONSTRAINT fk_cat_organismo_externo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_organismo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_tipo_organismo'))
 ALTER TABLE organizacion.cat_tipo_organismo WITH CHECK ADD CONSTRAINT fk_cat_tipo_organismo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_organismo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_tipo_organismo'))
 ALTER TABLE organizacion.cat_tipo_organismo WITH CHECK ADD CONSTRAINT fk_cat_tipo_organismo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_cargo_funcion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_cargo_funcion'))
 ALTER TABLE organizacion.cat_cargo_funcion WITH CHECK ADD CONSTRAINT fk_cat_cargo_funcion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_cargo_funcion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_cargo_funcion'))
 ALTER TABLE organizacion.cat_cargo_funcion WITH CHECK ADD CONSTRAINT fk_cat_cargo_funcion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_organismo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_nivel_organismo'))
 ALTER TABLE organizacion.cat_nivel_organismo WITH CHECK ADD CONSTRAINT fk_cat_nivel_organismo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_organismo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_nivel_organismo'))
 ALTER TABLE organizacion.cat_nivel_organismo WITH CHECK ADD CONSTRAINT fk_cat_nivel_organismo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relacion_unidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_tipo_relacion_unidad'))
 ALTER TABLE organizacion.cat_tipo_relacion_unidad WITH CHECK ADD CONSTRAINT fk_cat_tipo_relacion_unidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relacion_unidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_tipo_relacion_unidad'))
 ALTER TABLE organizacion.cat_tipo_relacion_unidad WITH CHECK ADD CONSTRAINT fk_cat_tipo_relacion_unidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_unidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_tipo_unidad'))
 ALTER TABLE organizacion.cat_tipo_unidad WITH CHECK ADD CONSTRAINT fk_cat_tipo_unidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_unidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.cat_tipo_unidad'))
 ALTER TABLE organizacion.cat_tipo_unidad WITH CHECK ADD CONSTRAINT fk_cat_tipo_unidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_funcionario_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'organizacion.funcionario'))
 ALTER TABLE organizacion.funcionario WITH CHECK ADD CONSTRAINT fk_funcionario_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_funcionario_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.funcionario'))
 ALTER TABLE organizacion.funcionario WITH CHECK ADD CONSTRAINT fk_funcionario_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_funcionario_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.funcionario'))
 ALTER TABLE organizacion.funcionario WITH CHECK ADD CONSTRAINT fk_funcionario_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_ofan_fiscalia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'organizacion.ofan_fiscalia'))
 ALTER TABLE organizacion.ofan_fiscalia WITH CHECK ADD CONSTRAINT fk_ofan_fiscalia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_ofan_fiscalia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.ofan_fiscalia'))
 ALTER TABLE organizacion.ofan_fiscalia WITH CHECK ADD CONSTRAINT fk_ofan_fiscalia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_ofan_fiscalia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.ofan_fiscalia'))
 ALTER TABLE organizacion.ofan_fiscalia WITH CHECK ADD CONSTRAINT fk_ofan_fiscalia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relacion_unidad_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'organizacion.relacion_unidad'))
 ALTER TABLE organizacion.relacion_unidad WITH CHECK ADD CONSTRAINT fk_relacion_unidad_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relacion_unidad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'organizacion.relacion_unidad'))
 ALTER TABLE organizacion.relacion_unidad WITH CHECK ADD CONSTRAINT fk_relacion_unidad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relacion_unidad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'organizacion.relacion_unidad'))
 ALTER TABLE organizacion.relacion_unidad WITH CHECK ADD CONSTRAINT fk_relacion_unidad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: personas (48 tablas, +211 col, +119 fk) ============================== */

/* --- personas: columnas --- */
IF COL_LENGTH(N'personas.nombre', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.nombre ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.nombre', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.nombre ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.nombre', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.nombre ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.nombre', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.nombre ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_documento', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_documento ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_documento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.identificacion', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.identificacion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.identificacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.identificacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.identificacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.identificacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.identificacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.identificacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.alias', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.alias ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.alias', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.alias ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.alias', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.alias ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.alias', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.alias ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.anotacion', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.anotacion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.anotacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.anotacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.anotacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.anotacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.anotacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.anotacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_actividad_economica', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_actividad_economica ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_actividad_economica', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_actividad_economica ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_actividad_economica', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_actividad_economica ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_actividad_economica', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_actividad_economica ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_actividad_economica', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_actividad_economica ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_cabello', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_color_cabello ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_color_cabello', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_color_cabello ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_color_cabello', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_color_cabello ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_cabello', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_color_cabello ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_cabello', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_color_cabello ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_ojos', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_color_ojos ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_color_ojos', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_color_ojos ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_color_ojos', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_color_ojos ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_ojos', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_color_ojos ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_ojos', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_color_ojos ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_piel', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_color_piel ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_color_piel', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_color_piel ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_color_piel', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_color_piel ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_piel', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_color_piel ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_color_piel', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_color_piel ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_complexion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_complexion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_complexion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_complexion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_complexion', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_complexion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_complexion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_complexion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_complexion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_complexion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_forma_rostro', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_forma_rostro ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_forma_rostro', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_forma_rostro ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_forma_rostro', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_forma_rostro ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_forma_rostro', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_forma_rostro ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_forma_rostro', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_forma_rostro ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_genero', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_genero ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_genero', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_genero ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_genero', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_genero ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_genero', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_genero ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_genero', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_genero ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_nivel_escolaridad', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_nivel_escolaridad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_nivel_escolaridad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_nivel_escolaridad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_nivel_escolaridad', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_nivel_escolaridad ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_nivel_escolaridad', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_nivel_escolaridad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_nivel_escolaridad', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_nivel_escolaridad ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_ocupacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_ocupacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_ocupacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_ocupacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_ocupacion', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_ocupacion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_ocupacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_ocupacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_ocupacion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_ocupacion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_sexo', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_sexo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_sexo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_sexo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_sexo', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_sexo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_sexo', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_sexo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_sexo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_sexo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_anotacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_anotacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_anotacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_anotacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_anotacion', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_anotacion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_anotacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_anotacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_anotacion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_anotacion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_biometrico', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_biometrico ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_biometrico', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_biometrico ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_biometrico', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_biometrico ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_biometrico', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_biometrico ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_biometrico', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_biometrico ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_cabello', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_cabello ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_cabello', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_cabello ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_cabello', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_cabello ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_cabello', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_cabello ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_cabello', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_cabello ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_estado_civil', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_estado_civil ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_estado_civil', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_estado_civil ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_estado_civil', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_estado_civil ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_estado_civil', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_estado_civil ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_estado_civil', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_estado_civil ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_fotografia', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_fotografia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_fotografia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_fotografia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_fotografia', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_fotografia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_fotografia', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_fotografia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_fotografia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_fotografia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_nombre', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_nombre ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_nombre', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_nombre ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_nombre', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_nombre ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_nombre', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_nombre ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_nombre', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_nombre ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_persona ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_persona ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_persona ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_persona ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_persona ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona_juridica', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_persona_juridica ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona_juridica', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_persona_juridica ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona_juridica', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_persona_juridica ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona_juridica', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_persona_juridica ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_persona_juridica', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_persona_juridica ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_rasgo_distintivo', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_rasgo_distintivo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_rasgo_distintivo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_rasgo_distintivo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_rasgo_distintivo', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_rasgo_distintivo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_rasgo_distintivo', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_rasgo_distintivo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_rasgo_distintivo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_rasgo_distintivo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_red_social', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_red_social ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_red_social', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_red_social ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_red_social', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_red_social ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_red_social', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_red_social ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_red_social', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_red_social ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_relacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_relacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_relacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_relacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_relacion', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_relacion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_relacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_relacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_relacion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_relacion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_representacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_representacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_representacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_representacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_representacion', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_representacion ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_representacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_representacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_representacion', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_representacion ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_telefono', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_tipo_telefono ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_telefono', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_tipo_telefono ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_tipo_telefono', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_tipo_telefono ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_telefono', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_tipo_telefono ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_tipo_telefono', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_tipo_telefono ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.cat_ubicacion_corporal', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.cat_ubicacion_corporal ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.cat_ubicacion_corporal', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.cat_ubicacion_corporal ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.cat_ubicacion_corporal', N'fecha_creacion') IS NULL
 ALTER TABLE personas.cat_ubicacion_corporal ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_ubicacion_corporal', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.cat_ubicacion_corporal ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.cat_ubicacion_corporal', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE personas.cat_ubicacion_corporal ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'personas.contacto_otro', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.contacto_otro ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.contacto_otro', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.contacto_otro ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.contacto_otro', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.contacto_otro ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.contacto_otro', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.contacto_otro ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.correo', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.correo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.correo', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.correo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.correo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.correo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.correo', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.correo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.descripcion_fisica', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.descripcion_fisica ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.descripcion_fisica', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.descripcion_fisica ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.descripcion_fisica', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.descripcion_fisica ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.descripcion_fisica', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.descripcion_fisica ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.empleo', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.empleo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.empleo', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.empleo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.empleo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.empleo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.empleo', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.empleo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.escolaridad', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.escolaridad ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.escolaridad', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.escolaridad ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.escolaridad', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.escolaridad ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.escolaridad', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.escolaridad ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.estado_civil', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.estado_civil ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.estado_civil', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.estado_civil ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.estado_civil', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.estado_civil ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.estado_civil', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.estado_civil ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.fotografia', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.fotografia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.fotografia', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.fotografia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.fotografia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.fotografia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.fotografia', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.fotografia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.persona', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.persona ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.persona', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.persona ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.persona', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.persona ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.persona_juridica', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.persona_juridica ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.persona_juridica', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.persona_juridica ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.persona_juridica', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.persona_juridica ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.persona_lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.persona_lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.persona_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.persona_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.persona_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.persona_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.persona_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.persona_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.persona_natural', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.persona_natural ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.persona_natural', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.persona_natural ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.persona_natural', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.persona_natural ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.pj_actividad_economica', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.pj_actividad_economica ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.pj_actividad_economica', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.pj_actividad_economica ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.pj_actividad_economica', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.pj_actividad_economica ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.pj_nombre', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.pj_nombre ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.pj_nombre', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.pj_nombre ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.pj_nombre', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.pj_nombre ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.pj_representante_legal', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.pj_representante_legal ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.pj_representante_legal', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.pj_representante_legal ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.pj_representante_legal', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.pj_representante_legal ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.rasgo_distintivo', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.rasgo_distintivo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.rasgo_distintivo', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.rasgo_distintivo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.rasgo_distintivo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.rasgo_distintivo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.rasgo_distintivo', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.rasgo_distintivo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.red_social', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.red_social ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.red_social', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.red_social ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.red_social', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.red_social ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.red_social', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.red_social ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.referencia_biometrica', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.referencia_biometrica ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.referencia_biometrica', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.referencia_biometrica ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.referencia_biometrica', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.referencia_biometrica ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.referencia_biometrica', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.referencia_biometrica ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.relacion', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.relacion ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.relacion', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.relacion ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.relacion', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.relacion ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.relacion', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.relacion ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'personas.telefono', N'id_usuario_creador') IS NULL
 ALTER TABLE personas.telefono ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'personas.telefono', N'id_usuario_modificador') IS NULL
 ALTER TABLE personas.telefono ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'personas.telefono', N'id_usuario_eliminador') IS NULL
 ALTER TABLE personas.telefono ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'personas.telefono', N'fecha_actualizacion') IS NULL
 ALTER TABLE personas.telefono ADD fecha_actualizacion timestamp NULL;

/* --- personas: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nombre_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.nombre'))
 ALTER TABLE personas.nombre WITH CHECK ADD CONSTRAINT fk_nombre_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nombre_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.nombre'))
 ALTER TABLE personas.nombre WITH CHECK ADD CONSTRAINT fk_nombre_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nombre_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.nombre'))
 ALTER TABLE personas.nombre WITH CHECK ADD CONSTRAINT fk_nombre_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_documento'))
 ALTER TABLE personas.cat_tipo_documento WITH CHECK ADD CONSTRAINT fk_cat_tipo_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_documento'))
 ALTER TABLE personas.cat_tipo_documento WITH CHECK ADD CONSTRAINT fk_cat_tipo_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_identificacion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.identificacion'))
 ALTER TABLE personas.identificacion WITH CHECK ADD CONSTRAINT fk_identificacion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_identificacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.identificacion'))
 ALTER TABLE personas.identificacion WITH CHECK ADD CONSTRAINT fk_identificacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_identificacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.identificacion'))
 ALTER TABLE personas.identificacion WITH CHECK ADD CONSTRAINT fk_identificacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_alias_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.alias'))
 ALTER TABLE personas.alias WITH CHECK ADD CONSTRAINT fk_alias_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_alias_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.alias'))
 ALTER TABLE personas.alias WITH CHECK ADD CONSTRAINT fk_alias_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_alias_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.alias'))
 ALTER TABLE personas.alias WITH CHECK ADD CONSTRAINT fk_alias_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_anotacion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.anotacion'))
 ALTER TABLE personas.anotacion WITH CHECK ADD CONSTRAINT fk_anotacion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_anotacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.anotacion'))
 ALTER TABLE personas.anotacion WITH CHECK ADD CONSTRAINT fk_anotacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_anotacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.anotacion'))
 ALTER TABLE personas.anotacion WITH CHECK ADD CONSTRAINT fk_anotacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_actividad_economica_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_actividad_economica'))
 ALTER TABLE personas.cat_actividad_economica WITH CHECK ADD CONSTRAINT fk_cat_actividad_economica_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_actividad_economica_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_actividad_economica'))
 ALTER TABLE personas.cat_actividad_economica WITH CHECK ADD CONSTRAINT fk_cat_actividad_economica_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_cabello_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_color_cabello'))
 ALTER TABLE personas.cat_color_cabello WITH CHECK ADD CONSTRAINT fk_cat_color_cabello_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_cabello_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_color_cabello'))
 ALTER TABLE personas.cat_color_cabello WITH CHECK ADD CONSTRAINT fk_cat_color_cabello_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_ojos_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_color_ojos'))
 ALTER TABLE personas.cat_color_ojos WITH CHECK ADD CONSTRAINT fk_cat_color_ojos_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_ojos_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_color_ojos'))
 ALTER TABLE personas.cat_color_ojos WITH CHECK ADD CONSTRAINT fk_cat_color_ojos_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_piel_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_color_piel'))
 ALTER TABLE personas.cat_color_piel WITH CHECK ADD CONSTRAINT fk_cat_color_piel_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_piel_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_color_piel'))
 ALTER TABLE personas.cat_color_piel WITH CHECK ADD CONSTRAINT fk_cat_color_piel_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_complexion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_complexion'))
 ALTER TABLE personas.cat_complexion WITH CHECK ADD CONSTRAINT fk_cat_complexion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_complexion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_complexion'))
 ALTER TABLE personas.cat_complexion WITH CHECK ADD CONSTRAINT fk_cat_complexion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_forma_rostro_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_forma_rostro'))
 ALTER TABLE personas.cat_forma_rostro WITH CHECK ADD CONSTRAINT fk_cat_forma_rostro_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_forma_rostro_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_forma_rostro'))
 ALTER TABLE personas.cat_forma_rostro WITH CHECK ADD CONSTRAINT fk_cat_forma_rostro_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_genero_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_genero'))
 ALTER TABLE personas.cat_genero WITH CHECK ADD CONSTRAINT fk_cat_genero_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_genero_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_genero'))
 ALTER TABLE personas.cat_genero WITH CHECK ADD CONSTRAINT fk_cat_genero_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_escolaridad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_nivel_escolaridad'))
 ALTER TABLE personas.cat_nivel_escolaridad WITH CHECK ADD CONSTRAINT fk_cat_nivel_escolaridad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_nivel_escolaridad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_nivel_escolaridad'))
 ALTER TABLE personas.cat_nivel_escolaridad WITH CHECK ADD CONSTRAINT fk_cat_nivel_escolaridad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_ocupacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_ocupacion'))
 ALTER TABLE personas.cat_ocupacion WITH CHECK ADD CONSTRAINT fk_cat_ocupacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_ocupacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_ocupacion'))
 ALTER TABLE personas.cat_ocupacion WITH CHECK ADD CONSTRAINT fk_cat_ocupacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_sexo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_sexo'))
 ALTER TABLE personas.cat_sexo WITH CHECK ADD CONSTRAINT fk_cat_sexo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_sexo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_sexo'))
 ALTER TABLE personas.cat_sexo WITH CHECK ADD CONSTRAINT fk_cat_sexo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_anotacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_anotacion'))
 ALTER TABLE personas.cat_tipo_anotacion WITH CHECK ADD CONSTRAINT fk_cat_tipo_anotacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_anotacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_anotacion'))
 ALTER TABLE personas.cat_tipo_anotacion WITH CHECK ADD CONSTRAINT fk_cat_tipo_anotacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_biometrico_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_biometrico'))
 ALTER TABLE personas.cat_tipo_biometrico WITH CHECK ADD CONSTRAINT fk_cat_tipo_biometrico_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_biometrico_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_biometrico'))
 ALTER TABLE personas.cat_tipo_biometrico WITH CHECK ADD CONSTRAINT fk_cat_tipo_biometrico_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_cabello_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_cabello'))
 ALTER TABLE personas.cat_tipo_cabello WITH CHECK ADD CONSTRAINT fk_cat_tipo_cabello_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_cabello_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_cabello'))
 ALTER TABLE personas.cat_tipo_cabello WITH CHECK ADD CONSTRAINT fk_cat_tipo_cabello_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_estado_civil_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_estado_civil'))
 ALTER TABLE personas.cat_tipo_estado_civil WITH CHECK ADD CONSTRAINT fk_cat_tipo_estado_civil_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_estado_civil_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_estado_civil'))
 ALTER TABLE personas.cat_tipo_estado_civil WITH CHECK ADD CONSTRAINT fk_cat_tipo_estado_civil_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_fotografia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_fotografia'))
 ALTER TABLE personas.cat_tipo_fotografia WITH CHECK ADD CONSTRAINT fk_cat_tipo_fotografia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_fotografia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_fotografia'))
 ALTER TABLE personas.cat_tipo_fotografia WITH CHECK ADD CONSTRAINT fk_cat_tipo_fotografia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_nombre_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_nombre'))
 ALTER TABLE personas.cat_tipo_nombre WITH CHECK ADD CONSTRAINT fk_cat_tipo_nombre_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_nombre_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_nombre'))
 ALTER TABLE personas.cat_tipo_nombre WITH CHECK ADD CONSTRAINT fk_cat_tipo_nombre_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_persona_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_persona'))
 ALTER TABLE personas.cat_tipo_persona WITH CHECK ADD CONSTRAINT fk_cat_tipo_persona_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_persona_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_persona'))
 ALTER TABLE personas.cat_tipo_persona WITH CHECK ADD CONSTRAINT fk_cat_tipo_persona_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_persona_juridica_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_persona_juridica'))
 ALTER TABLE personas.cat_tipo_persona_juridica WITH CHECK ADD CONSTRAINT fk_cat_tipo_persona_juridica_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_persona_juridica_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_persona_juridica'))
 ALTER TABLE personas.cat_tipo_persona_juridica WITH CHECK ADD CONSTRAINT fk_cat_tipo_persona_juridica_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_rasgo_distintivo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_rasgo_distintivo'))
 ALTER TABLE personas.cat_tipo_rasgo_distintivo WITH CHECK ADD CONSTRAINT fk_cat_tipo_rasgo_distintivo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_rasgo_distintivo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_rasgo_distintivo'))
 ALTER TABLE personas.cat_tipo_rasgo_distintivo WITH CHECK ADD CONSTRAINT fk_cat_tipo_rasgo_distintivo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_red_social_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_red_social'))
 ALTER TABLE personas.cat_tipo_red_social WITH CHECK ADD CONSTRAINT fk_cat_tipo_red_social_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_red_social_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_red_social'))
 ALTER TABLE personas.cat_tipo_red_social WITH CHECK ADD CONSTRAINT fk_cat_tipo_red_social_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_relacion'))
 ALTER TABLE personas.cat_tipo_relacion WITH CHECK ADD CONSTRAINT fk_cat_tipo_relacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_relacion'))
 ALTER TABLE personas.cat_tipo_relacion WITH CHECK ADD CONSTRAINT fk_cat_tipo_relacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_representacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_representacion'))
 ALTER TABLE personas.cat_tipo_representacion WITH CHECK ADD CONSTRAINT fk_cat_tipo_representacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_representacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_representacion'))
 ALTER TABLE personas.cat_tipo_representacion WITH CHECK ADD CONSTRAINT fk_cat_tipo_representacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_telefono_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_telefono'))
 ALTER TABLE personas.cat_tipo_telefono WITH CHECK ADD CONSTRAINT fk_cat_tipo_telefono_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_telefono_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_tipo_telefono'))
 ALTER TABLE personas.cat_tipo_telefono WITH CHECK ADD CONSTRAINT fk_cat_tipo_telefono_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_ubicacion_corporal_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.cat_ubicacion_corporal'))
 ALTER TABLE personas.cat_ubicacion_corporal WITH CHECK ADD CONSTRAINT fk_cat_ubicacion_corporal_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_ubicacion_corporal_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.cat_ubicacion_corporal'))
 ALTER TABLE personas.cat_ubicacion_corporal WITH CHECK ADD CONSTRAINT fk_cat_ubicacion_corporal_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_contacto_otro_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.contacto_otro'))
 ALTER TABLE personas.contacto_otro WITH CHECK ADD CONSTRAINT fk_contacto_otro_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_contacto_otro_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.contacto_otro'))
 ALTER TABLE personas.contacto_otro WITH CHECK ADD CONSTRAINT fk_contacto_otro_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_contacto_otro_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.contacto_otro'))
 ALTER TABLE personas.contacto_otro WITH CHECK ADD CONSTRAINT fk_contacto_otro_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_correo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.correo'))
 ALTER TABLE personas.correo WITH CHECK ADD CONSTRAINT fk_correo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_correo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.correo'))
 ALTER TABLE personas.correo WITH CHECK ADD CONSTRAINT fk_correo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_correo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.correo'))
 ALTER TABLE personas.correo WITH CHECK ADD CONSTRAINT fk_correo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_descripcion_fisica_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.descripcion_fisica'))
 ALTER TABLE personas.descripcion_fisica WITH CHECK ADD CONSTRAINT fk_descripcion_fisica_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_descripcion_fisica_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.descripcion_fisica'))
 ALTER TABLE personas.descripcion_fisica WITH CHECK ADD CONSTRAINT fk_descripcion_fisica_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_descripcion_fisica_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.descripcion_fisica'))
 ALTER TABLE personas.descripcion_fisica WITH CHECK ADD CONSTRAINT fk_descripcion_fisica_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_empleo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.empleo'))
 ALTER TABLE personas.empleo WITH CHECK ADD CONSTRAINT fk_empleo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_empleo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.empleo'))
 ALTER TABLE personas.empleo WITH CHECK ADD CONSTRAINT fk_empleo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_empleo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.empleo'))
 ALTER TABLE personas.empleo WITH CHECK ADD CONSTRAINT fk_empleo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_escolaridad_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.escolaridad'))
 ALTER TABLE personas.escolaridad WITH CHECK ADD CONSTRAINT fk_escolaridad_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_escolaridad_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.escolaridad'))
 ALTER TABLE personas.escolaridad WITH CHECK ADD CONSTRAINT fk_escolaridad_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_escolaridad_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.escolaridad'))
 ALTER TABLE personas.escolaridad WITH CHECK ADD CONSTRAINT fk_escolaridad_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_civil_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.estado_civil'))
 ALTER TABLE personas.estado_civil WITH CHECK ADD CONSTRAINT fk_estado_civil_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_civil_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.estado_civil'))
 ALTER TABLE personas.estado_civil WITH CHECK ADD CONSTRAINT fk_estado_civil_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_civil_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.estado_civil'))
 ALTER TABLE personas.estado_civil WITH CHECK ADD CONSTRAINT fk_estado_civil_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fotografia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.fotografia'))
 ALTER TABLE personas.fotografia WITH CHECK ADD CONSTRAINT fk_fotografia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fotografia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.fotografia'))
 ALTER TABLE personas.fotografia WITH CHECK ADD CONSTRAINT fk_fotografia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_fotografia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.fotografia'))
 ALTER TABLE personas.fotografia WITH CHECK ADD CONSTRAINT fk_fotografia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.persona'))
 ALTER TABLE personas.persona WITH CHECK ADD CONSTRAINT fk_persona_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.persona'))
 ALTER TABLE personas.persona WITH CHECK ADD CONSTRAINT fk_persona_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.persona'))
 ALTER TABLE personas.persona WITH CHECK ADD CONSTRAINT fk_persona_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_juridica_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.persona_juridica'))
 ALTER TABLE personas.persona_juridica WITH CHECK ADD CONSTRAINT fk_persona_juridica_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_juridica_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.persona_juridica'))
 ALTER TABLE personas.persona_juridica WITH CHECK ADD CONSTRAINT fk_persona_juridica_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_juridica_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.persona_juridica'))
 ALTER TABLE personas.persona_juridica WITH CHECK ADD CONSTRAINT fk_persona_juridica_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.persona_lugar'))
 ALTER TABLE personas.persona_lugar WITH CHECK ADD CONSTRAINT fk_persona_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.persona_lugar'))
 ALTER TABLE personas.persona_lugar WITH CHECK ADD CONSTRAINT fk_persona_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.persona_lugar'))
 ALTER TABLE personas.persona_lugar WITH CHECK ADD CONSTRAINT fk_persona_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_natural_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.persona_natural'))
 ALTER TABLE personas.persona_natural WITH CHECK ADD CONSTRAINT fk_persona_natural_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_natural_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.persona_natural'))
 ALTER TABLE personas.persona_natural WITH CHECK ADD CONSTRAINT fk_persona_natural_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_natural_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.persona_natural'))
 ALTER TABLE personas.persona_natural WITH CHECK ADD CONSTRAINT fk_persona_natural_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_actividad_economica_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.pj_actividad_economica'))
 ALTER TABLE personas.pj_actividad_economica WITH CHECK ADD CONSTRAINT fk_pj_actividad_economica_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_actividad_economica_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.pj_actividad_economica'))
 ALTER TABLE personas.pj_actividad_economica WITH CHECK ADD CONSTRAINT fk_pj_actividad_economica_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_actividad_economica_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.pj_actividad_economica'))
 ALTER TABLE personas.pj_actividad_economica WITH CHECK ADD CONSTRAINT fk_pj_actividad_economica_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_nombre_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.pj_nombre'))
 ALTER TABLE personas.pj_nombre WITH CHECK ADD CONSTRAINT fk_pj_nombre_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_nombre_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.pj_nombre'))
 ALTER TABLE personas.pj_nombre WITH CHECK ADD CONSTRAINT fk_pj_nombre_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_nombre_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.pj_nombre'))
 ALTER TABLE personas.pj_nombre WITH CHECK ADD CONSTRAINT fk_pj_nombre_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_representante_legal_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.pj_representante_legal'))
 ALTER TABLE personas.pj_representante_legal WITH CHECK ADD CONSTRAINT fk_pj_representante_legal_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_representante_legal_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.pj_representante_legal'))
 ALTER TABLE personas.pj_representante_legal WITH CHECK ADD CONSTRAINT fk_pj_representante_legal_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pj_representante_legal_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.pj_representante_legal'))
 ALTER TABLE personas.pj_representante_legal WITH CHECK ADD CONSTRAINT fk_pj_representante_legal_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_rasgo_distintivo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.rasgo_distintivo'))
 ALTER TABLE personas.rasgo_distintivo WITH CHECK ADD CONSTRAINT fk_rasgo_distintivo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_rasgo_distintivo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.rasgo_distintivo'))
 ALTER TABLE personas.rasgo_distintivo WITH CHECK ADD CONSTRAINT fk_rasgo_distintivo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_rasgo_distintivo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.rasgo_distintivo'))
 ALTER TABLE personas.rasgo_distintivo WITH CHECK ADD CONSTRAINT fk_rasgo_distintivo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_red_social_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.red_social'))
 ALTER TABLE personas.red_social WITH CHECK ADD CONSTRAINT fk_red_social_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_red_social_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.red_social'))
 ALTER TABLE personas.red_social WITH CHECK ADD CONSTRAINT fk_red_social_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_red_social_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.red_social'))
 ALTER TABLE personas.red_social WITH CHECK ADD CONSTRAINT fk_red_social_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_referencia_biometrica_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.referencia_biometrica'))
 ALTER TABLE personas.referencia_biometrica WITH CHECK ADD CONSTRAINT fk_referencia_biometrica_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_referencia_biometrica_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.referencia_biometrica'))
 ALTER TABLE personas.referencia_biometrica WITH CHECK ADD CONSTRAINT fk_referencia_biometrica_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_referencia_biometrica_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.referencia_biometrica'))
 ALTER TABLE personas.referencia_biometrica WITH CHECK ADD CONSTRAINT fk_referencia_biometrica_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relacion_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.relacion'))
 ALTER TABLE personas.relacion WITH CHECK ADD CONSTRAINT fk_relacion_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relacion_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.relacion'))
 ALTER TABLE personas.relacion WITH CHECK ADD CONSTRAINT fk_relacion_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_relacion_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.relacion'))
 ALTER TABLE personas.relacion WITH CHECK ADD CONSTRAINT fk_relacion_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_telefono_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'personas.telefono'))
 ALTER TABLE personas.telefono WITH CHECK ADD CONSTRAINT fk_telefono_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_telefono_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'personas.telefono'))
 ALTER TABLE personas.telefono WITH CHECK ADD CONSTRAINT fk_telefono_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_telefono_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'personas.telefono'))
 ALTER TABLE personas.telefono WITH CHECK ADD CONSTRAINT fk_telefono_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: tareas (18 tablas, +107 col, +54 fk) ============================== */

/* --- tareas: columnas --- */
IF COL_LENGTH(N'tareas.bandeja', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.bandeja ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.bandeja', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.bandeja ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.bandeja', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.bandeja ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.bandeja', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.bandeja ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.bandeja', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.bandeja ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.bandeja', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.bandeja ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.comentario_documento', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.comentario_documento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.comentario_documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.comentario_documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.comentario_documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.comentario_documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.comentario_documento', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.comentario_documento ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.comentario_documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.comentario_documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.comentario_documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.comentario_documento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.comentario_documento_nodo', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.comentario_documento_nodo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.comentario_documento_nodo', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.comentario_documento_nodo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.comentario_documento_nodo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.comentario_documento_nodo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.comentario_documento_nodo', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.comentario_documento_nodo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.comentario_documento_nodo', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.comentario_documento_nodo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.comentario_documento_nodo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.comentario_documento_nodo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.documento', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.documento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.documento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.documento_denuncia', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.documento_denuncia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.documento_denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.documento_denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.documento_denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.documento_denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.documento_denuncia', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.documento_denuncia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.documento_denuncia', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.documento_denuncia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.documento_denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.documento_denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.estado_tarea', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.estado_tarea ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.estado_tarea', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.estado_tarea ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.estado_tarea', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.estado_tarea ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.estado_tarea', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.estado_tarea ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.estado_tarea', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.estado_tarea ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.estado_tarea', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.estado_tarea ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.evaluacion_comentario', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.evaluacion_comentario ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.evaluacion_comentario', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.evaluacion_comentario ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.evaluacion_comentario', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.evaluacion_comentario ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.evaluacion_comentario', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.evaluacion_comentario ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.evaluacion_comentario', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.evaluacion_comentario ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.evaluacion_comentario', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.evaluacion_comentario ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.nodo', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.nodo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.nodo', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.nodo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.nodo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.nodo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.nodo', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.nodo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.nodo', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.nodo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.nodo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.nodo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tarea', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tarea ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tarea', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tarea ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tarea', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tarea ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tarea', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tarea ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tarea ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tarea ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_archivo_adjunto', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tarea_archivo_adjunto ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tarea_archivo_adjunto', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tarea_archivo_adjunto ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tarea_archivo_adjunto', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tarea_archivo_adjunto ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tarea_archivo_adjunto', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tarea_archivo_adjunto ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_archivo_adjunto', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tarea_archivo_adjunto ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_archivo_adjunto', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tarea_archivo_adjunto ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_denuncia', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tarea_denuncia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tarea_denuncia', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tarea_denuncia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tarea_denuncia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tarea_denuncia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tarea_denuncia', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tarea_denuncia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_denuncia', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tarea_denuncia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_denuncia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tarea_denuncia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_diligencia', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tarea_diligencia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tarea_diligencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tarea_diligencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tarea_diligencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tarea_diligencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tarea_diligencia', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tarea_diligencia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_diligencia', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tarea_diligencia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_diligencia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tarea_diligencia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_documento', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tarea_documento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tarea_documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tarea_documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tarea_documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tarea_documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tarea_documento', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tarea_documento ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tarea_documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tarea_documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tarea_documento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_documento', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tipo_documento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tipo_documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tipo_documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tipo_documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tipo_documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tipo_documento', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tipo_documento ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tipo_documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tipo_documento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_estado_tarea', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tipo_estado_tarea ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tipo_estado_tarea', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tipo_estado_tarea ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tipo_estado_tarea', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tipo_estado_tarea ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tipo_estado_tarea', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tipo_estado_tarea ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_estado_tarea', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tipo_estado_tarea ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_estado_tarea', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tipo_estado_tarea ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_tarea', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tipo_tarea ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tipo_tarea', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tipo_tarea ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tipo_tarea', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tipo_tarea ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tipo_tarea', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tipo_tarea ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_tarea', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tipo_tarea ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_tarea', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tipo_tarea ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_tarea_tipo_documento', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.tipo_tarea_tipo_documento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.tipo_tarea_tipo_documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.tipo_tarea_tipo_documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.tipo_tarea_tipo_documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.tipo_tarea_tipo_documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.tipo_tarea_tipo_documento', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.tipo_tarea_tipo_documento ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_tarea_tipo_documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.tipo_tarea_tipo_documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.tipo_tarea_tipo_documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.tipo_tarea_tipo_documento ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'tareas.version_documento', N'id_usuario_creador') IS NULL
 ALTER TABLE tareas.version_documento ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'tareas.version_documento', N'id_usuario_modificador') IS NULL
 ALTER TABLE tareas.version_documento ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'tareas.version_documento', N'id_usuario_eliminador') IS NULL
 ALTER TABLE tareas.version_documento ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'tareas.version_documento', N'fecha_creacion') IS NULL
 ALTER TABLE tareas.version_documento ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'tareas.version_documento', N'fecha_actualizacion') IS NULL
 ALTER TABLE tareas.version_documento ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'tareas.version_documento', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE tareas.version_documento ADD fecha_eliminacion_logica timestamp NULL;

/* --- tareas: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_bandeja_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.bandeja'))
 ALTER TABLE tareas.bandeja WITH CHECK ADD CONSTRAINT fk_bandeja_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_bandeja_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.bandeja'))
 ALTER TABLE tareas.bandeja WITH CHECK ADD CONSTRAINT fk_bandeja_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_bandeja_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.bandeja'))
 ALTER TABLE tareas.bandeja WITH CHECK ADD CONSTRAINT fk_bandeja_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comentario_documento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.comentario_documento'))
 ALTER TABLE tareas.comentario_documento WITH CHECK ADD CONSTRAINT fk_comentario_documento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comentario_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.comentario_documento'))
 ALTER TABLE tareas.comentario_documento WITH CHECK ADD CONSTRAINT fk_comentario_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comentario_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.comentario_documento'))
 ALTER TABLE tareas.comentario_documento WITH CHECK ADD CONSTRAINT fk_comentario_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comentario_documento_nodo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.comentario_documento_nodo'))
 ALTER TABLE tareas.comentario_documento_nodo WITH CHECK ADD CONSTRAINT fk_comentario_documento_nodo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comentario_documento_nodo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.comentario_documento_nodo'))
 ALTER TABLE tareas.comentario_documento_nodo WITH CHECK ADD CONSTRAINT fk_comentario_documento_nodo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comentario_documento_nodo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.comentario_documento_nodo'))
 ALTER TABLE tareas.comentario_documento_nodo WITH CHECK ADD CONSTRAINT fk_comentario_documento_nodo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_documento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.documento'))
 ALTER TABLE tareas.documento WITH CHECK ADD CONSTRAINT fk_documento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.documento'))
 ALTER TABLE tareas.documento WITH CHECK ADD CONSTRAINT fk_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.documento'))
 ALTER TABLE tareas.documento WITH CHECK ADD CONSTRAINT fk_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_documento_denuncia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.documento_denuncia'))
 ALTER TABLE tareas.documento_denuncia WITH CHECK ADD CONSTRAINT fk_documento_denuncia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_documento_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.documento_denuncia'))
 ALTER TABLE tareas.documento_denuncia WITH CHECK ADD CONSTRAINT fk_documento_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_documento_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.documento_denuncia'))
 ALTER TABLE tareas.documento_denuncia WITH CHECK ADD CONSTRAINT fk_documento_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_tarea_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.estado_tarea'))
 ALTER TABLE tareas.estado_tarea WITH CHECK ADD CONSTRAINT fk_estado_tarea_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_tarea_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.estado_tarea'))
 ALTER TABLE tareas.estado_tarea WITH CHECK ADD CONSTRAINT fk_estado_tarea_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_estado_tarea_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.estado_tarea'))
 ALTER TABLE tareas.estado_tarea WITH CHECK ADD CONSTRAINT fk_estado_tarea_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evaluacion_comentario_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.evaluacion_comentario'))
 ALTER TABLE tareas.evaluacion_comentario WITH CHECK ADD CONSTRAINT fk_evaluacion_comentario_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evaluacion_comentario_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.evaluacion_comentario'))
 ALTER TABLE tareas.evaluacion_comentario WITH CHECK ADD CONSTRAINT fk_evaluacion_comentario_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_evaluacion_comentario_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.evaluacion_comentario'))
 ALTER TABLE tareas.evaluacion_comentario WITH CHECK ADD CONSTRAINT fk_evaluacion_comentario_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nodo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.nodo'))
 ALTER TABLE tareas.nodo WITH CHECK ADD CONSTRAINT fk_nodo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nodo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.nodo'))
 ALTER TABLE tareas.nodo WITH CHECK ADD CONSTRAINT fk_nodo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_nodo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.nodo'))
 ALTER TABLE tareas.nodo WITH CHECK ADD CONSTRAINT fk_nodo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tarea'))
 ALTER TABLE tareas.tarea WITH CHECK ADD CONSTRAINT fk_tarea_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tarea'))
 ALTER TABLE tareas.tarea WITH CHECK ADD CONSTRAINT fk_tarea_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tarea'))
 ALTER TABLE tareas.tarea WITH CHECK ADD CONSTRAINT fk_tarea_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_archivo_adjunto_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_archivo_adjunto'))
 ALTER TABLE tareas.tarea_archivo_adjunto WITH CHECK ADD CONSTRAINT fk_tarea_archivo_adjunto_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_archivo_adjunto_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_archivo_adjunto'))
 ALTER TABLE tareas.tarea_archivo_adjunto WITH CHECK ADD CONSTRAINT fk_tarea_archivo_adjunto_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_archivo_adjunto_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_archivo_adjunto'))
 ALTER TABLE tareas.tarea_archivo_adjunto WITH CHECK ADD CONSTRAINT fk_tarea_archivo_adjunto_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_denuncia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_denuncia'))
 ALTER TABLE tareas.tarea_denuncia WITH CHECK ADD CONSTRAINT fk_tarea_denuncia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_denuncia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_denuncia'))
 ALTER TABLE tareas.tarea_denuncia WITH CHECK ADD CONSTRAINT fk_tarea_denuncia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_denuncia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_denuncia'))
 ALTER TABLE tareas.tarea_denuncia WITH CHECK ADD CONSTRAINT fk_tarea_denuncia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_diligencia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_diligencia'))
 ALTER TABLE tareas.tarea_diligencia WITH CHECK ADD CONSTRAINT fk_tarea_diligencia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_diligencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_diligencia'))
 ALTER TABLE tareas.tarea_diligencia WITH CHECK ADD CONSTRAINT fk_tarea_diligencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_diligencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_diligencia'))
 ALTER TABLE tareas.tarea_diligencia WITH CHECK ADD CONSTRAINT fk_tarea_diligencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_documento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_documento'))
 ALTER TABLE tareas.tarea_documento WITH CHECK ADD CONSTRAINT fk_tarea_documento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_documento'))
 ALTER TABLE tareas.tarea_documento WITH CHECK ADD CONSTRAINT fk_tarea_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tarea_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tarea_documento'))
 ALTER TABLE tareas.tarea_documento WITH CHECK ADD CONSTRAINT fk_tarea_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_documento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_documento'))
 ALTER TABLE tareas.tipo_documento WITH CHECK ADD CONSTRAINT fk_tipo_documento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_documento'))
 ALTER TABLE tareas.tipo_documento WITH CHECK ADD CONSTRAINT fk_tipo_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_documento'))
 ALTER TABLE tareas.tipo_documento WITH CHECK ADD CONSTRAINT fk_tipo_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_estado_tarea_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_estado_tarea'))
 ALTER TABLE tareas.tipo_estado_tarea WITH CHECK ADD CONSTRAINT fk_tipo_estado_tarea_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_estado_tarea_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_estado_tarea'))
 ALTER TABLE tareas.tipo_estado_tarea WITH CHECK ADD CONSTRAINT fk_tipo_estado_tarea_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_estado_tarea_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_estado_tarea'))
 ALTER TABLE tareas.tipo_estado_tarea WITH CHECK ADD CONSTRAINT fk_tipo_estado_tarea_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_tarea_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_tarea'))
 ALTER TABLE tareas.tipo_tarea WITH CHECK ADD CONSTRAINT fk_tipo_tarea_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_tarea_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_tarea'))
 ALTER TABLE tareas.tipo_tarea WITH CHECK ADD CONSTRAINT fk_tipo_tarea_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_tarea_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_tarea'))
 ALTER TABLE tareas.tipo_tarea WITH CHECK ADD CONSTRAINT fk_tipo_tarea_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_tarea_tipo_documento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_tarea_tipo_documento'))
 ALTER TABLE tareas.tipo_tarea_tipo_documento WITH CHECK ADD CONSTRAINT fk_tipo_tarea_tipo_documento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_tarea_tipo_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_tarea_tipo_documento'))
 ALTER TABLE tareas.tipo_tarea_tipo_documento WITH CHECK ADD CONSTRAINT fk_tipo_tarea_tipo_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_tipo_tarea_tipo_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.tipo_tarea_tipo_documento'))
 ALTER TABLE tareas.tipo_tarea_tipo_documento WITH CHECK ADD CONSTRAINT fk_tipo_tarea_tipo_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_version_documento_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'tareas.version_documento'))
 ALTER TABLE tareas.version_documento WITH CHECK ADD CONSTRAINT fk_version_documento_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_version_documento_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'tareas.version_documento'))
 ALTER TABLE tareas.version_documento WITH CHECK ADD CONSTRAINT fk_version_documento_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_version_documento_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'tareas.version_documento'))
 ALTER TABLE tareas.version_documento WITH CHECK ADD CONSTRAINT fk_version_documento_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: ubicacion (11 tablas, +55 col, +28 fk) ============================== */

/* --- ubicacion: columnas --- */
IF COL_LENGTH(N'ubicacion.pais', N'id_usuario_creador') IS NULL
 ALTER TABLE ubicacion.pais ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'ubicacion.pais', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.pais ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.pais', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.pais ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.pais', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.pais ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.pais', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.pais ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.pais', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.pais ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.lugar_base', N'id_usuario_creador') IS NULL
 ALTER TABLE ubicacion.lugar_base ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'ubicacion.lugar_base', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.lugar_base ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.lugar_base', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.lugar_base ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.lugar_base', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.lugar_base ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.lugar', N'id_usuario_creador') IS NULL
 ALTER TABLE ubicacion.lugar ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'ubicacion.lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_rol_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.cat_rol_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_rol_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.cat_rol_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_rol_lugar', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.cat_rol_lugar ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_rol_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.cat_rol_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_rol_lugar', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.cat_rol_lugar ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_calle', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_calle ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_calle', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_calle ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_calle', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_calle ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_calle', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_calle ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_calle', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.cat_tipo_calle ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_lugar', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_lugar ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_lugar', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_lugar ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_lugar', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_lugar ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_lugar', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_lugar ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_lugar', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.cat_tipo_lugar ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_residencia', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_residencia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_residencia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_residencia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_residencia', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_residencia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_residencia', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_residencia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_residencia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.cat_tipo_residencia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_subdivision', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_subdivision ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_subdivision', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.cat_tipo_subdivision ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_subdivision', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.cat_tipo_subdivision ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.cat_tipo_subdivision', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.cat_tipo_subdivision ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.comuna', N'id_usuario_creador') IS NULL
 ALTER TABLE ubicacion.comuna ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'ubicacion.comuna', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.comuna ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.comuna', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.comuna ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.comuna', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.comuna ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.comuna', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.comuna ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.comuna', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.comuna ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.provincia', N'id_usuario_creador') IS NULL
 ALTER TABLE ubicacion.provincia ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'ubicacion.provincia', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.provincia ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.provincia', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.provincia ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.provincia', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.provincia ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.provincia', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.provincia ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.provincia', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.provincia ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'ubicacion.region', N'id_usuario_creador') IS NULL
 ALTER TABLE ubicacion.region ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'ubicacion.region', N'id_usuario_modificador') IS NULL
 ALTER TABLE ubicacion.region ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'ubicacion.region', N'id_usuario_eliminador') IS NULL
 ALTER TABLE ubicacion.region ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'ubicacion.region', N'fecha_creacion') IS NULL
 ALTER TABLE ubicacion.region ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.region', N'fecha_actualizacion') IS NULL
 ALTER TABLE ubicacion.region ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'ubicacion.region', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE ubicacion.region ADD fecha_eliminacion_logica timestamp NULL;

/* --- ubicacion: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pais_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'ubicacion.pais'))
 ALTER TABLE ubicacion.pais WITH CHECK ADD CONSTRAINT fk_pais_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pais_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.pais'))
 ALTER TABLE ubicacion.pais WITH CHECK ADD CONSTRAINT fk_pais_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_pais_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.pais'))
 ALTER TABLE ubicacion.pais WITH CHECK ADD CONSTRAINT fk_pais_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_lugar_base_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'ubicacion.lugar_base'))
 ALTER TABLE ubicacion.lugar_base WITH CHECK ADD CONSTRAINT fk_lugar_base_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_lugar_base_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.lugar_base'))
 ALTER TABLE ubicacion.lugar_base WITH CHECK ADD CONSTRAINT fk_lugar_base_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_lugar_base_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.lugar_base'))
 ALTER TABLE ubicacion.lugar_base WITH CHECK ADD CONSTRAINT fk_lugar_base_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_lugar_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'ubicacion.lugar'))
 ALTER TABLE ubicacion.lugar WITH CHECK ADD CONSTRAINT fk_lugar_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.lugar'))
 ALTER TABLE ubicacion.lugar WITH CHECK ADD CONSTRAINT fk_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.lugar'))
 ALTER TABLE ubicacion.lugar WITH CHECK ADD CONSTRAINT fk_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_rol_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_rol_lugar'))
 ALTER TABLE ubicacion.cat_rol_lugar WITH CHECK ADD CONSTRAINT fk_cat_rol_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_rol_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_rol_lugar'))
 ALTER TABLE ubicacion.cat_rol_lugar WITH CHECK ADD CONSTRAINT fk_cat_rol_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_calle_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_calle'))
 ALTER TABLE ubicacion.cat_tipo_calle WITH CHECK ADD CONSTRAINT fk_cat_tipo_calle_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_calle_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_calle'))
 ALTER TABLE ubicacion.cat_tipo_calle WITH CHECK ADD CONSTRAINT fk_cat_tipo_calle_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_lugar_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_lugar'))
 ALTER TABLE ubicacion.cat_tipo_lugar WITH CHECK ADD CONSTRAINT fk_cat_tipo_lugar_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_lugar_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_lugar'))
 ALTER TABLE ubicacion.cat_tipo_lugar WITH CHECK ADD CONSTRAINT fk_cat_tipo_lugar_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_residencia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_residencia'))
 ALTER TABLE ubicacion.cat_tipo_residencia WITH CHECK ADD CONSTRAINT fk_cat_tipo_residencia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_residencia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_residencia'))
 ALTER TABLE ubicacion.cat_tipo_residencia WITH CHECK ADD CONSTRAINT fk_cat_tipo_residencia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_subdivision_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_subdivision'))
 ALTER TABLE ubicacion.cat_tipo_subdivision WITH CHECK ADD CONSTRAINT fk_cat_tipo_subdivision_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_subdivision_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.cat_tipo_subdivision'))
 ALTER TABLE ubicacion.cat_tipo_subdivision WITH CHECK ADD CONSTRAINT fk_cat_tipo_subdivision_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comuna_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'ubicacion.comuna'))
 ALTER TABLE ubicacion.comuna WITH CHECK ADD CONSTRAINT fk_comuna_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comuna_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.comuna'))
 ALTER TABLE ubicacion.comuna WITH CHECK ADD CONSTRAINT fk_comuna_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_comuna_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.comuna'))
 ALTER TABLE ubicacion.comuna WITH CHECK ADD CONSTRAINT fk_comuna_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_provincia_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'ubicacion.provincia'))
 ALTER TABLE ubicacion.provincia WITH CHECK ADD CONSTRAINT fk_provincia_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_provincia_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.provincia'))
 ALTER TABLE ubicacion.provincia WITH CHECK ADD CONSTRAINT fk_provincia_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_provincia_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.provincia'))
 ALTER TABLE ubicacion.provincia WITH CHECK ADD CONSTRAINT fk_provincia_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_region_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'ubicacion.region'))
 ALTER TABLE ubicacion.region WITH CHECK ADD CONSTRAINT fk_region_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_region_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'ubicacion.region'))
 ALTER TABLE ubicacion.region WITH CHECK ADD CONSTRAINT fk_region_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_region_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'ubicacion.region'))
 ALTER TABLE ubicacion.region WITH CHECK ADD CONSTRAINT fk_region_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

/* ============================== ESQUEMA: vehiculos (8 tablas, +37 col, +18 fk) ============================== */

/* --- vehiculos: columnas --- */
IF COL_LENGTH(N'vehiculos.cat_color', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.cat_color ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_color', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.cat_color ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_color', N'fecha_creacion') IS NULL
 ALTER TABLE vehiculos.cat_color ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_color', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.cat_color ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_color', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE vehiculos.cat_color ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_marca', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.cat_marca ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_marca', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.cat_marca ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_marca', N'fecha_creacion') IS NULL
 ALTER TABLE vehiculos.cat_marca ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_marca', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.cat_marca ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_marca', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE vehiculos.cat_marca ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_modelo', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.cat_modelo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_modelo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.cat_modelo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_modelo', N'fecha_creacion') IS NULL
 ALTER TABLE vehiculos.cat_modelo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_modelo', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.cat_modelo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_modelo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE vehiculos.cat_modelo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.cat_tipo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.cat_tipo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo', N'fecha_creacion') IS NULL
 ALTER TABLE vehiculos.cat_tipo ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.cat_tipo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE vehiculos.cat_tipo ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo_relacion_persona', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.cat_tipo_relacion_persona ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo_relacion_persona', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.cat_tipo_relacion_persona ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo_relacion_persona', N'fecha_creacion') IS NULL
 ALTER TABLE vehiculos.cat_tipo_relacion_persona ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo_relacion_persona', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.cat_tipo_relacion_persona ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_tipo_relacion_persona', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE vehiculos.cat_tipo_relacion_persona ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_version', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.cat_version ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_version', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.cat_version ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.cat_version', N'fecha_creacion') IS NULL
 ALTER TABLE vehiculos.cat_version ADD fecha_creacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_version', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.cat_version ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.cat_version', N'fecha_eliminacion_logica') IS NULL
 ALTER TABLE vehiculos.cat_version ADD fecha_eliminacion_logica timestamp NULL;
IF COL_LENGTH(N'vehiculos.persona_vehiculo', N'id_usuario_creador') IS NULL
 ALTER TABLE vehiculos.persona_vehiculo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'vehiculos.persona_vehiculo', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.persona_vehiculo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.persona_vehiculo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.persona_vehiculo ADD id_usuario_eliminador INT NULL;
IF COL_LENGTH(N'vehiculos.persona_vehiculo', N'fecha_actualizacion') IS NULL
 ALTER TABLE vehiculos.persona_vehiculo ADD fecha_actualizacion timestamp NULL;
IF COL_LENGTH(N'vehiculos.vehiculo', N'id_usuario_creador') IS NULL
 ALTER TABLE vehiculos.vehiculo ADD id_usuario_creador INT NULL;
IF COL_LENGTH(N'vehiculos.vehiculo', N'id_usuario_modificador') IS NULL
 ALTER TABLE vehiculos.vehiculo ADD id_usuario_modificador INT NULL;
IF COL_LENGTH(N'vehiculos.vehiculo', N'id_usuario_eliminador') IS NULL
 ALTER TABLE vehiculos.vehiculo ADD id_usuario_eliminador INT NULL;

/* --- vehiculos: FKs a auth.usuario(id_usuario) --- */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_color'))
 ALTER TABLE vehiculos.cat_color WITH CHECK ADD CONSTRAINT fk_cat_color_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_color_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_color'))
 ALTER TABLE vehiculos.cat_color WITH CHECK ADD CONSTRAINT fk_cat_color_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_marca_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_marca'))
 ALTER TABLE vehiculos.cat_marca WITH CHECK ADD CONSTRAINT fk_cat_marca_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_marca_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_marca'))
 ALTER TABLE vehiculos.cat_marca WITH CHECK ADD CONSTRAINT fk_cat_marca_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_modelo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_modelo'))
 ALTER TABLE vehiculos.cat_modelo WITH CHECK ADD CONSTRAINT fk_cat_modelo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_modelo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_modelo'))
 ALTER TABLE vehiculos.cat_modelo WITH CHECK ADD CONSTRAINT fk_cat_modelo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_tipo'))
 ALTER TABLE vehiculos.cat_tipo WITH CHECK ADD CONSTRAINT fk_cat_tipo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_tipo'))
 ALTER TABLE vehiculos.cat_tipo WITH CHECK ADD CONSTRAINT fk_cat_tipo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relacion_persona_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_tipo_relacion_persona'))
 ALTER TABLE vehiculos.cat_tipo_relacion_persona WITH CHECK ADD CONSTRAINT fk_cat_tipo_relacion_persona_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_tipo_relacion_persona_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_tipo_relacion_persona'))
 ALTER TABLE vehiculos.cat_tipo_relacion_persona WITH CHECK ADD CONSTRAINT fk_cat_tipo_relacion_persona_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_version_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_version'))
 ALTER TABLE vehiculos.cat_version WITH CHECK ADD CONSTRAINT fk_cat_version_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_cat_version_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.cat_version'))
 ALTER TABLE vehiculos.cat_version WITH CHECK ADD CONSTRAINT fk_cat_version_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_vehiculo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'vehiculos.persona_vehiculo'))
 ALTER TABLE vehiculos.persona_vehiculo WITH CHECK ADD CONSTRAINT fk_persona_vehiculo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_vehiculo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.persona_vehiculo'))
 ALTER TABLE vehiculos.persona_vehiculo WITH CHECK ADD CONSTRAINT fk_persona_vehiculo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_persona_vehiculo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.persona_vehiculo'))
 ALTER TABLE vehiculos.persona_vehiculo WITH CHECK ADD CONSTRAINT fk_persona_vehiculo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_vehiculo_id_usuario_creador' AND parent_object_id = OBJECT_ID(N'vehiculos.vehiculo'))
 ALTER TABLE vehiculos.vehiculo WITH CHECK ADD CONSTRAINT fk_vehiculo_id_usuario_creador FOREIGN KEY(id_usuario_creador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_vehiculo_id_usuario_modificador' AND parent_object_id = OBJECT_ID(N'vehiculos.vehiculo'))
 ALTER TABLE vehiculos.vehiculo WITH CHECK ADD CONSTRAINT fk_vehiculo_id_usuario_modificador FOREIGN KEY(id_usuario_modificador) REFERENCES auth.usuario(id_usuario);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'fk_vehiculo_id_usuario_eliminador' AND parent_object_id = OBJECT_ID(N'vehiculos.vehiculo'))
 ALTER TABLE vehiculos.vehiculo WITH CHECK ADD CONSTRAINT fk_vehiculo_id_usuario_eliminador FOREIGN KEY(id_usuario_eliminador) REFERENCES auth.usuario(id_usuario);

