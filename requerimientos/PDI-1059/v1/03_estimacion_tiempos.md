# PDI-1059 - Estimacion de tiempos

## Supuestos

1. Existe tabla/vista identificada para instrucciones.
2. No hay cambios de modelo de datos complejos.
3. El contrato de salida se valida rapidamente con consumidor.

## Estimacion detallada (horas)

1. Analisis schema y query
- Revisar estructura de datos y relaciones: 1.5h
- Diseñar query final y criterios de vigencia: 1.0h
- Subtotal: 2.5h

2. Implementacion en MS/repo
- Implementar acceso a datos y mapeo DTO: 2.0h
- Manejo de escenarios no encontrado/error: 1.0h
- Subtotal: 3.0h

3. Pruebas
- Unitarias de handler/mapeo: 1.5h
- Prueba integracion basica con BD local: 1.5h
- Subtotal: 3.0h

4. QA/documentacion
- Evidencia minima y actualizacion documental: 1.5h
- Subtotal: 1.5h

## Total

- Total base: 10h
- Contingencia recomendada 20%: 2h
- Total planificado: 12h

## Escenarios de calendario

1. Ejecucion continua por 1 dev + apoyo QA
- Duracion estimada: 1.5 a 2 dias habiles.

2. Ejecucion interrumpida por dependencias funcionales
- Duracion estimada: 2 a 3 dias habiles.

## Riesgo de desvio

- Alto si no se define la estructura funcional de "instrucciones".
- Medio si aparecen cambios de contrato no previstos en consumidor.
