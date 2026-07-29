# PDI-967 - Estimacion de tiempos

## Parametros usados

- foco: e2e
- estimacionDetalle: true
- semaforoRiesgo: true

## Supuestos

1. Se reutilizan componentes existentes de diligencias.
2. No hay cambios mayores de modelo relacional.
3. Las dependencias PDI-890/PDI-969 se destraban durante la ejecucion.
4. RN03 se cierra funcionalmente en maximo 1 jornada.

## Estimacion por frente (horas)

1. MS
- Consulta bandeja con filtros y paginacion: 12h
- Endpoint filtros/catologos: 8h
- Reglas RN03/RN04/RN05 + pruebas: 10h
- Ajuste inicial de performance en consultas: 4h
- Subtotal MS: 34h

2. BFF
- Mapeo endpoint bandeja: 8h
- Mapeo endpoint filtros: 6h
- Manejo de errores y adaptacion contrato UI: 6h
- Pruebas unitarias de mapeo: 6h
- Subtotal BFF: 26h

3. Front
- Vista bandeja investigador: 12h
- Filtros y paginacion: 10h
- Estados de carga/vacio/error: 4h
- Integracion e2e y ajustes UX: 10h
- Subtotal Front: 36h

4. QA y documentacion
- Casuistica funcional y regresion: 12h
- Pruebas de seguridad de acceso por rol: 4h
- Evidencia y cierre documental: 6h
- Subtotal QA/Documentacion: 22h

## Totales

- Total base: 118h
- Contingencia recomendada: 20% (24h)
- Total planificado: 142h

## Escenarios de calendario

1. Equipo en paralelo (MS + BFF + Front + QA en solapamiento)
- Duracion estimada: 9 a 11 dias habiles.

2. Equipo parcial (2 perfiles con menor solapamiento)
- Duracion estimada: 13 a 16 dias habiles.

## Camino critico

1. Cierre RN03.
2. Entrega estable MS de bandeja.
3. Alineacion de contrato BFF con Front.
4. Validacion e2e y regresion QA.

## Sensibilidad de la estimacion

- Riesgo de +10% a +20% si se mantienen bloqueos de dependencias.
- Riesgo de +5% si cambia matriz de estados/acciones en etapa QA.
