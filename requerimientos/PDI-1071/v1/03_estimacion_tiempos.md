# PDI-1071 - Estimacion de tiempos

## Supuestos

1. Endpoint se implementa en MS existente sin cambios estructurales mayores.
2. Modelo de datos de actividades ya existe y es consultable.
3. Definicion funcional pendiente se resuelve antes de cierre.

## Estimacion detallada (horas)

1. Analisis y refinamiento
- Revisar esquema/relaciones de actividades: 1.5h
- Cerrar contrato preliminar y reglas de autorizacion: 1.0h
- Subtotal: 2.5h

2. Implementacion MS
- Endpoint + handler + repositorio: 3.0h
- Validaciones y manejo de errores: 1.0h
- Subtotal: 4.0h

3. Pruebas
- Unitarias de reglas y mapeo: 2.0h
- Integracion basica con BD local/QA: 1.5h
- Subtotal: 3.5h

4. Documentacion y soporte QA
- Ajuste OpenAPI + evidencia: 1.5h
- Subtotal: 1.5h

## Totales

- Total base: 11.5h
- Contingencia recomendada (20%): 2.5h
- Total planificado: 14h

## Escenarios

1. Sin bloqueos de definicion
- Duracion: 1.5 a 2 dias habiles.

2. Con ajustes de contrato o seguridad tardios
- Duracion: 2 a 3 dias habiles.

## Sensibilidad

1. +10% a +20% si se incorpora paginacion obligatoria no prevista.
2. +10% si aparecen reglas de visibilidad por unidad/rol mas complejas.
