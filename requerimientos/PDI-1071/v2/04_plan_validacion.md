# PDI-1071 - Plan de validacion

## Objetivo

Validar funcionalidad, seguridad y estabilidad del GET de actividades asociadas a diligencia en ms-diligencias.

## Cobertura funcional minima

1. Diligencia con multiples actividades
- Debe retornar 200 con items ordenados.

2. Diligencia sin actividades
- Debe retornar 200 con items vacio.

3. Filtro por estado
- Pendiente
- Completado
- Descartado

4. Paginacion
- Validar pageNumber/pageSize.
- Validar totalItems y cantidad retornada.

5. Campos de cabecera de actividad
- tipoActividad
- fecha/hora inicio
- fecha/hora termino
- participantes
- lugares
- observacion/resultado

## Cobertura de seguridad

1. Usuario sin permisos de consulta
- Debe retornar 403.

2. Usuario con permisos limitados
- No debe consultar diligencias fuera de su contexto.

## Cobertura tecnica

1. Contrato OpenAPI vs respuesta real.
2. Manejo de errores 400/403/404/500.
3. Orden consistente de resultados.
4. Rendimiento dentro de umbral objetivo.

## Evidencia requerida

1. Requests/responses de casos funcionales y negativos.
2. Resultado de pruebas unitarias e integracion.
3. Evidencia de prueba de autorizacion (no-fuga de datos).
4. Matriz de trazabilidad: regla -> caso -> evidencia.

## Criterio de salida

1. Cobertura completa de casos minimos.
2. Sin defectos criticos o altos.
3. Validacion funcional del consumidor para contrato response.
