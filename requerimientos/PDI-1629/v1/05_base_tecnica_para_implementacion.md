# 05 - Base tecnica para implementacion

## Puntos de entrada sugeridos

- `src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs`
- `src/NEXO.Diligencias.Application/Features/Actividad/Commands/CreateActividadInvestigativa/*`
- `src/NEXO.Diligencias.Application/Features/Actividad/Commands/UpdateActividadInvestigativa/*`
- `src/NEXO.Diligencias.Application/Persistence/Actividad/IActividadInvestigativaRepository.cs`
- `src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaRepository.cs`
- `src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaQueries.cs`

## Checklist tecnico

1. Confirmar definicion funcional del paso.
2. Mapear request/response esperado.
3. Endurecer validaciones.
4. Ajustar SP si el flujo requiere un contrato especial.
5. Agregar pruebas unitarias.
6. Actualizar OpenAPI y docs de apoyo.

## Proxima etapa

Con el alcance cerrado, este paquete puede convertirse en backlog de implementacion por tareas tecnicas y luego en PR con pruebas y documentacion.