/* =============================================================================
   V0028 — Consolidacion de columna de auditoria duplicada

   Contexto:
     cooperacion_int.solicitud_interpol tenia de origen [fecha_modificacion]
     (datetime2(7) NULL). V0026 agrego [fecha_actualizacion] por uniformidad
     del patron, dejando dos columnas para el mismo rol (MODIFICACION).
     Es la unica tabla del modelo con ese duplicado.

   Decision: la columna oficial del patron es [fecha_actualizacion].
     1) Se preserva el dato: se copia fecha_modificacion -> fecha_actualizacion
        donde fecha_actualizacion aun esta NULL.
     2) Se elimina [fecha_modificacion].

   Seguridad verificada:
     - Ningun stored procedure / funcion / seed referencia fecha_modificacion.
     - La columna no tiene constraint DEFAULT en el dump (se suelta cualquiera
       de forma defensiva por si el entorno difiere).
     - Las otras fechas de la tabla (fecha_endoso, fecha_cierre) son de negocio
       y NO se tocan.

   PENDIENTE de confirmar fuera de la BD: que la APLICACION no lea/escriba
   fecha_modificacion directamente. Si la usa, ajustar la app antes de aplicar.

   Idempotente. Asume transaccion por-migracion de Flyway. Refuerzo XACT_ABORT.
   ============================================================================= */

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

/* ---------- 1) Preservar el dato: copiar a fecha_actualizacion donde falte ---------- */
IF COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'fecha_modificacion') IS NOT NULL
   AND COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'fecha_actualizacion') IS NOT NULL
BEGIN
    UPDATE cooperacion_int.solicitud_interpol
       SET fecha_actualizacion = fecha_modificacion
     WHERE fecha_actualizacion IS NULL
       AND fecha_modificacion  IS NOT NULL;
END;
GO

/* ---------- 2) Soltar cualquier constraint DEFAULT ligado a fecha_modificacion ---------- */
DECLARE @df sysname;
SELECT @df = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
  ON c.object_id = dc.parent_object_id
 AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'cooperacion_int.solicitud_interpol')
  AND c.name = N'fecha_modificacion';

IF @df IS NOT NULL
    EXEC('ALTER TABLE cooperacion_int.solicitud_interpol DROP CONSTRAINT [' + @df + ']');
GO

/* ---------- 3) Eliminar la columna duplicada ---------- */
IF COL_LENGTH(N'cooperacion_int.solicitud_interpol', N'fecha_modificacion') IS NOT NULL
    ALTER TABLE cooperacion_int.solicitud_interpol DROP COLUMN [fecha_modificacion];
GO
