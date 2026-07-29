# PDI-967 - Plan de validacion

## Objetivo

Validar cumplimiento funcional, tecnico y de seguridad de la bandeja de diligencias para rol Investigador.

## Cobertura de criterios de aceptacion

1. Visualiza diligencias asignadas.
2. Muestra tipo de diligencia.
3. Muestra origen.
4. Muestra fecha de recepcion.
5. Muestra fecha limite.
6. Muestra estado.
7. Permite gestionar cuando corresponde.

## Casos funcionales minimos

1. Investigador con diligencias
- Debe visualizar solo sus registros.

2. Investigador sin diligencias
- Debe visualizar estado vacio controlado.

3. Filtros
- estado
- fechaDesde/fechaHasta
- tipoDiligencia
- funcionario
- unidad

4. Paginacion
- Validar pageNumber/pageSize.
- Validar totalItems/totalPages.

5. Reglas de accion por estado
- EN_DESARROLLO: gestionar habilitado.
- OBSERVADA: gestionar habilitado.
- Otros: gestionar deshabilitado.

6. Regla RN03
- Validar decreto 2/10/20 con dataset controlado.

## Casos de seguridad

1. Usuario sin rol Investigador no debe acceder a la bandeja.
2. No debe exponer diligencias de otro funcionario por manipulacion de parametros.

## Casos tecnicos

1. Front-BFF-MS devuelven contrato consistente.
2. Manejo de errores HTTP estandarizado (400/401/403/500).
3. Tiempo de respuesta en umbral esperado para consulta paginada.

## Evidencia requerida

1. Evidencia Postman o cliente API de requests/responses.
2. Capturas de UI en estados: carga, vacio, error.
3. Registro de ejecucion de casos y resultados.
4. Trazabilidad criterio -> caso -> evidencia.

## Criterio de salida

1. 100% criterios de aceptacion cubiertos.
2. Sin defectos criticos o altos pendientes.
3. Aprobacion funcional de PO/QA para RN03 y matriz de acciones.
