# 03 - Estimacion de tiempos (v2)

## Supuestos para estimar

1. Alcance se limita a `ActividadInvestigativa` en MS.
2. No hay rediseno de esquema de datos; solo ajustes puntuales de SP si aplica.
3. Ambientes y datos de prueba disponibles.
4. Refinamiento funcional se cierra antes de iniciar codificacion.

## Estimacion por frente (horas)

- MS (Api + Application + Infrastructure): 14h
- BD (ajuste/validacion de SP y pruebas SQL): 4h
- QA tecnico + evidencia + no regresion: 6h
- OpenAPI/API docs/Postman: 3h

Total base: 27h

## Contingencia por riesgo

- Riesgo funcional (descripcion incompleta y reglas pendientes): +25%
- Contingencia estimada: 6.75h

Total con contingencia: 33.75h (redondeo operativo: 34h)

## Escenarios de calendario

### Escenario A - Trabajo en paralelo (MS + QA + BD coordinado)

- Duracion estimada: 3 a 4 dias habiles.

### Escenario B - Trabajo secuencial (equipo parcial)

- Duracion estimada: 5 a 6 dias habiles.

## Factores que pueden ampliar plazo

1. Cambios de alcance en reglas de negocio durante implementacion.
2. Necesidad de nuevos SP/ajustes de migraciones no previstos.
3. Hallazgos de regresion en flujos de diligencias relacionados.
4. Aprobaciones tardias de criterios de aceptacion.
