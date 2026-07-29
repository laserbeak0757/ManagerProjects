# PDI-967 - Estimacion de tiempos

## Supuestos

1. Reutilizacion de endpoints/base de diligencias ya existentes.
2. Sin cambios estructurales mayores de base de datos.
3. Equipo con disponibilidad de Front, BFF y MS en paralelo.
4. Definiciones funcionales pendientes se resuelven en maximo 1 jornada.

## Estimacion por frente (horas)

1. MS Diligencias
- Endpoint bandeja filtrado + paginacion: 12h
- Endpoint filtros (catalogos): 8h
- Pruebas unitarias/integracion basica: 8h
- Ajustes de performance (indices/query tuning inicial): 4h
- Subtotal MS: 32h

2. BFF Diligencias
- Mapeo endpoint bandeja: 8h
- Mapeo endpoint filtros: 6h
- Manejo de errores y contratos: 4h
- Pruebas unitarias: 6h
- Subtotal BFF: 24h

3. Front
- Vista bandeja investigador: 12h
- Filtros y paginacion UI: 10h
- Estados de carga/vacio/error: 4h
- Integracion con BFF y ajustes UX: 8h
- Subtotal Front: 34h

4. QA y documentacion
- Casos de prueba funcionales/regresion: 12h
- Evidencias y cierre documental: 6h
- Subtotal QA/doc: 18h

## Totales

- Total esfuerzo: 108h
- Total con contingencia 20%: 130h

## Proyeccion calendario (referencial)

Escenario 1 (3 personas en paralelo: MS, BFF, Front):
- Duracion estimada: 8 a 10 dias habiles.

Escenario 2 (2 personas con solapamiento parcial):
- Duracion estimada: 12 a 15 dias habiles.

## Camino critico

1. Cerrar regla RN03 (fecha limite).
2. Entregar endpoint MS de bandeja.
3. Integrar mapeo BFF.
4. Validacion E2E con Front y QA.

## Riesgo de desvio

- Alto si PDI-890 y PDI-969 permanecen bloqueantes.
- Medio si la matriz de estados/acciones cambia durante QA.
