# 05 - Plan de implementacion por tareas

## T1 - Cerrar definicion funcional

- Responsable: PO + lider tecnico
- Salida: criterios de aceptacion finales y reglas de negocio para create/update/delete.

## T2 - Endurecer validaciones de actividad

- Archivos objetivo:
  - src/NEXO.Diligencias.Application/Features/Actividad/Commands/CreateActividadInvestigativa/CreateActividadInvestigativaCommandValidator.cs
  - src/NEXO.Diligencias.Application/Features/Actividad/Commands/UpdateActividadInvestigativa/UpdateActividadInvestigativaCommandValidator.cs
- Salida: validaciones completas y mensajes utiles.

## T3 - Implementar delete real

- Archivos objetivo:
  - src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs
  - src/NEXO.Diligencias.Application/Features/Actividad (nuevos use cases delete)
  - src/NEXO.Diligencias.Application/Persistence/Actividad/IActividadInvestigativaRepository.cs
  - src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaRepository.cs
  - src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaQueries.cs
- Salida: delete individual y masivo con soft-delete operativo.

## T4 - Ajustes de contrato y documentacion

- Archivos objetivo:
  - docs/openapi/v1/openapi.json
  - docs/openapi/v1/openapi.yaml
  - docs/api/v1/API.md
- Salida: contrato y guia QA sincronizados.

## T5 - Pruebas

- Archivos objetivo:
  - tests/NEXO.Diligencias.Tests/Application/*Actividad*.cs
- Salida: cobertura de casos positivos/negativos y no regresion.

## T6 - Cierre de implementacion

- Entregables:
  - Build y test exitosos
  - Evidencia QA
  - Resumen de cambios por capa
