# PDI-967 - Diseno funcional y tecnico

## Objetivo tecnico

Implementar una bandeja de diligencias para Investigador que sea consistente en MS, BFF y Front, con filtros, paginacion y reglas de accion por estado.

## Arquitectura funcional (foco e2e)

1. Front consume endpoint BFF de bandeja.
2. BFF valida parametros y token, luego orquesta consulta al MS.
3. MS aplica reglas RN01-RN05 y devuelve resultado paginado.
4. BFF adapta contrato para la UI.
5. Front renderiza datos y acciones disponibles.

## Contrato sugerido de consulta bandeja

### Request

- pageNumber
- pageSize
- estado (opcional)
- fechaDesde (opcional)
- fechaHasta (opcional)
- tipoDiligencia (opcional)
- funcionarioId (opcional, sujeto a permisos)
- unidadOrigen (opcional)

### Response

- totalItems
- totalPages
- pageNumber
- pageSize
- items[]
  - diligenciaId
  - tipoDiligencia
  - origen
  - fechaRecepcion
  - fechaLimite
  - estado
  - puedeGestionar
  - accionesDisponibles[]

## Reglas operacionalizadas

1. RN01
- El filtro principal debe resolverse con identity del token.

2. RN02
- Estado en respuesta debe provenir de catalogo normalizado.

3. RN03
- fechaLimite = fechaRecepcion + diasDecreto (2, 10, 20)
- Pendiente: confirmar habiles/corridos.

4. RN04
- puedeGestionar=true solo para EN_DESARROLLO y OBSERVADA.

5. RN05
- accionesDisponibles se define por matriz de estado.

## Requerimientos no funcionales

1. Seguridad
- No exponer diligencias de terceros.
- Trazabilidad con correlationId.

2. Rendimiento
- Respuesta objetivo p95 menor a 800 ms para consultas paginadas tipicas.

3. Observabilidad
- Logs estructurados por requestId, funcionarioId, filtros aplicados y tiempo de respuesta.

## Criterios de listo tecnico

1. OpenAPI actualizado en MS y BFF si cambia contrato.
2. Casos unitarios de reglas RN03 y RN04 cubiertos.
3. Validacion e2e con datos de prueba en QA/local.
