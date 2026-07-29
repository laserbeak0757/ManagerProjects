# PDI-1071 - Diseno funcional y tecnico

## Objetivo tecnico

Implementar una lectura robusta de actividades asociadas a una diligencia, con validaciones de entrada, autorizacion y contrato estable para consumo.

## Flujo propuesto

1. Cliente (BFF u otro consumidor) invoca GET por diligenciaId.
2. API MS valida formato de parametros.
3. Capa aplicacion valida permisos del usuario autenticado.
4. Repositorio consulta actividades de la diligencia ordenadas por fecha.
5. Se mapea resultado a DTO de salida.
6. Se responde 200 con lista, 404 si diligencia no existe, 403 sin permisos.

## Contrato sugerido (preliminar)

### Request

- diligenciaId (path, requerido)
- pageNumber (query, opcional, si se define paginacion)
- pageSize (query, opcional, si se define paginacion)

### Response 200

- diligenciaId
- totalItems (si aplica paginacion)
- pageNumber (si aplica paginacion)
- pageSize (si aplica paginacion)
- items[]
  - actividadId
  - tipoActividad
  - descripcion
  - estadoActividad
  - fechaActividad
  - usuarioRegistro

### Response 4xx/5xx

- codigo
- mensaje
- correlationId

## Reglas tecnicas propuestas

1. Validar diligenciaId mayor que 0.
2. Si diligencia no existe: 404.
3. Si existe pero no tiene actividades: 200 con items vacio.
4. Enforce de autorizacion por contexto de usuario/rol.
5. Logging estructurado con correlationId y diligenciaId.

## Persistencia y performance

1. Consulta principal por diligenciaId con orden por fechaActividad.
2. Recomendacion de indice compuesto: (diligencia_id, fecha_actividad desc).
3. Evitar N+1 en joins de catalogos de actividad.

## No funcionales

1. Seguridad: no exponer actividades de diligencias fuera de alcance autorizado.
2. Rendimiento: p95 menor a 500 ms para diligencia con volumen habitual.
3. Observabilidad: trazas por requestId/correlationId y codigo de resultado.

## Criterios de listo tecnico

1. OpenAPI actualizado para el endpoint.
2. Pruebas unitarias de handler y autorizacion.
3. Prueba de integracion de consulta con datos de ejemplo.
4. Evidencia de manejo de casos 200, 403 y 404.
