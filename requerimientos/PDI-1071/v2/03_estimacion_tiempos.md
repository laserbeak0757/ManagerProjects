# PDI-1071 - Estimacion de tiempos

## Supuestos v2

1. Existe repositorio de actividades asociado a diligencia.
2. Estados de actividad ya normalizados en BD o catalogo.
3. El contrato con detalle opcional por tipo no requiere resolver PDI-1520 en esta iteracion.

## Estimacion por frente (horas)

1. Analisis tecnico y contrato
- Refinamiento final de campos response: 1.5h
- Definicion de filtros/orden/paginacion: 1.0h
- Subtotal: 2.5h

2. Implementacion MS
- Endpoint + handler + repositorio: 3.0h
- Filtros (estado/paginacion) y validaciones: 2.0h
- Autorizacion y manejo de errores: 1.5h
- Subtotal: 6.5h

3. Pruebas
- Unitarias (mapeo, reglas, errores): 2.5h
- Integracion (consulta + orden + filtros): 2.0h
- Subtotal: 4.5h

4. Documentacion
- OpenAPI + ejemplos + evidencia: 1.5h
- Subtotal: 1.5h

## Totales

- Total base: 15h
- Contingencia recomendada 20%: 3h
- Total planificado: 18h

## Calendario esperado

1. Ejecucion continua por 1 dev
- 2 a 3 dias habiles.

2. Ejecucion en paralelo con QA
- 1.5 a 2 dias habiles.

## Sensibilidad

1. +10% si se exige detalle completo variable por tipo en esta misma entrega.
2. +10% a +20% si aparecen reglas de visibilidad complejas por unidad/caso.
