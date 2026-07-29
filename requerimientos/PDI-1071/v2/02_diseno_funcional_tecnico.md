# PDI-1071 - Diseno funcional y tecnico

## Objetivo tecnico

Implementar un endpoint GET en ms-diligencias para recuperar actividades asociadas a una diligencia, con contrato estable, seguridad por contexto y soporte de estados del dominio.

## Flujo e2e propuesto

1. Consumidor invoca GET /diligencias/{diligenciaId}/actividades.
2. API valida parametro y contexto autenticado.
3. Handler valida existencia de diligencia.
4. Handler aplica autorizacion por rol/unidad/caso segun reglas vigentes.
5. Repositorio obtiene actividades vinculadas ordenadas.
6. Mapper proyecta metadatos comunes y payload especifico (si aplica).
7. API retorna 200 o codigo controlado de error.

## Contrato sugerido v2

### Request

- diligenciaId (path, requerido)
- pageNumber (query, opcional)
- pageSize (query, opcional)
- estado (query, opcional: Pendiente | Completado | Descartado)

### Response 200

- diligenciaId
- totalItems
- pageNumber
- pageSize
- items[]
  - actividadId
  - tipoActividadId
  - tipoActividadNombre
  - estadoActividad
  - fechaInicio
  - horaInicio
  - fechaTermino
  - horaTermino
  - participantesResumen
  - lugaresResumen
  - observacionResultado
  - detalle (objeto opcional segun tipo)

### Response de error

- 400: parametro invalido
- 403: sin permisos
- 404: diligencia no existe
- 500: error tecnico no controlado

## Reglas operacionalizadas

1. RN03 del parent obliga a devolver lista (0..n) por diligencia.
2. RN04 restringe estadoActividad a Pendiente/Completado/Descartado.
3. Si no hay actividades: 200 con items vacio.
4. detalle debe tratarse como opcional para no romper tipos de actividad variables.

## Persistencia y consultas

1. Consulta principal por diligencia_id.
2. Orden recomendado: fecha_inicio desc, actividad_id desc.
3. Indice recomendado: (diligencia_id, fecha_inicio desc).
4. Si se filtra por estado: evaluar indice adicional (diligencia_id, estado_actividad, fecha_inicio desc).

## No funcionales

1. Seguridad: no exponer actividades de diligencias no autorizadas.
2. Rendimiento objetivo: p95 menor a 500 ms para volumen nominal.
3. Observabilidad: logs con correlationId, diligenciaId, totalItems, duracionMs.
4. Trazabilidad: response incluye identificadores funcionales estables.

## Criterios de listo tecnico

1. OpenAPI de MS actualizado con ejemplos de response.
2. Pruebas unitarias de handler, mapeo y reglas de estado.
3. Prueba integracion para filtros y orden.
4. Evidencia de casos 200/400/403/404.
