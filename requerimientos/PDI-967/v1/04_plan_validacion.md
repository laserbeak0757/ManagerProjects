# PDI-967 - Plan de validacion

## Objetivo

Validar que la bandeja de diligencias para Investigador cumpla reglas funcionales, contrato API y comportamiento UX esperado.

## Matriz de pruebas funcionales (minima)

1. Visualizacion de bandeja
- Dado un investigador con diligencias asignadas
- Cuando consulta la bandeja
- Entonces visualiza solo sus diligencias

2. Columnas obligatorias
- Verificar tipo, origen, fecha recepcion, fecha limite, estado.

3. Regla RN03 fecha limite
- Casos con decreto de 2, 10 y 20 dias.
- Validar resultado esperado segun definicion oficial de calendario.

4. Regla RN04 edicion
- EN_DESARROLLO: permite gestionar.
- OBSERVADA: permite gestionar.
- Otros estados: no permite gestionar.

5. Filtros
- Estado
- Fecha desde/hasta
- Tipo diligencia
- Funcionario
- Unidad

6. Paginacion
- pageNumber y pageSize.
- consistencia totalItems/totalPages.

7. Estados de UI
- Cargando.
- Sin datos.
- Error tecnico (timeout/500).

## Pruebas de seguridad

1. Usuario sin rol Investigador no debe ver bandeja autorizada.
2. No debe ser posible consultar diligencias de otro funcionario sin permiso.

## Pruebas de integracion

1. Front -> BFF contrato vigente.
2. BFF -> MS contrato vigente.
3. Manejo uniforme de errores y codigos HTTP.

## Evidencias esperadas

1. Request/response de API en Postman.
2. Capturas de estados UI.
3. Registro de casos aprobados/rechazados.
4. Referencia de OpenAPI validada.

## Criterio de salida

Se considera listo para cierre cuando:

1. 100% de criterios de aceptacion del ticket quedan cubiertos.
2. No hay defectos criticos ni altos abiertos.
3. Existe evidencia de pruebas E2E y regresion minima.
