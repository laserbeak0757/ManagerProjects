# PDI-967 - Diseno funcional y tecnico

## Objetivo tecnico

Implementar una bandeja de diligencias para rol Investigador con filtros, paginacion y reglas de habilitacion de acciones, asegurando consistencia entre MS, BFF y Front.

## Propuesta de flujo (alto nivel)

1. Front solicita bandeja con filtros/pagina.
2. BFF valida entrada y reenvia al MS de diligencias.
3. MS consulta datos por funcionario autenticado y aplica filtros.
4. MS calcula o expone fecha limite segun decreto.
5. BFF adapta respuesta a contrato UI.
6. Front renderiza tabla y disponibilidad de acciones.

## Contrato sugerido de lectura de bandeja

### Request (query params)

- pageNumber
- pageSize
- estado (opcional)
- fechaDesde (opcional)
- fechaHasta (opcional)
- tipoDiligencia (opcional)
- funcionarioId (opcional si se resuelve desde token)
- unidadOrigen (opcional)

### Response (shape sugerido)

- totalItems
- totalPages
- pageNumber
- pageSize
- items[]:
  - diligenciaId
  - tipoDiligencia
  - origen
  - fechaRecepcion
  - fechaLimite
  - estado
  - puedeGestionar (boolean)
  - accionesDisponibles[]

## Reglas de negocio operacionalizadas

1. RN01:
- En MS: filtrar por funcionario autenticado.
- En BFF: no permitir override inseguro de funcionario si no esta autorizado.

2. RN02:
- Exponer estado normalizado (codigo + descripcion opcional).

3. RN03:
- Calculo de fecha limite:
  - fechaLimite = fechaRecepcion + diasPorDecreto
  - diasPorDecreto en {2, 10, 20}
- Punto abierto:
  - confirmar si dias habiles o corridos.

4. RN04:
- puedeGestionar = true solo si estado in [EN_DESARROLLO, OBSERVADA].

5. RN05:
- accionesDisponibles definidas por matriz de estado.

## Matriz sugerida de acciones por estado

- EN_DESARROLLO: Gestionar, Actualizar avance, Adjuntar antecedentes.
- OBSERVADA: Gestionar, Corregir observaciones, Reenviar.
- OTROS: Sin accion de gestion para investigador.

## Consideraciones de seguridad

1. Derivar identidad/rol desde token validado.
2. Registrar trazabilidad de consultas y acciones.
3. Evitar exposicion de diligencias de terceros.

## Consideraciones de observabilidad

1. Logging estructurado con correlationId.
2. Metricas sugeridas:
- latencia p95 endpoint bandeja
- tasa de errores por endpoint
- cantidad de resultados por consulta

## Criterios de listo para desarrollo

1. Contrato OpenAPI acordado.
2. Definicion formal de calculo de fecha limite.
3. Estados y acciones permitidas cerradas con negocio.
4. Datos de prueba disponibles en QA/local.
