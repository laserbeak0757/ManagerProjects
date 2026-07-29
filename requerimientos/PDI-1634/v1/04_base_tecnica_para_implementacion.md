# 04 - Base tecnica preparada para implementacion

## Contexto tecnico actual del repositorio

`NEXO.Diligencias` opera como microservicio de dominio con arquitectura por capas:

- `src/NEXO.Diligencias.Api`
- `src/NEXO.Diligencias.Application`
- `src/NEXO.Diligencias.Domain`
- `src/NEXO.Diligencias.Infrastructure`
- `tests/NEXO.Diligencias.Tests`

Existe una base funcional para Diligencias e Instruccion Fiscal, con contratos y pruebas ya creadas.

## Rutas candidatas de impacto (segun tipo de cambio de PDI-1634)

### Si el ticket impacta Instruccion Fiscal

- API:
  - `src/NEXO.Diligencias.Api/Controllers/InstruccionFiscalController.cs`
  - `src/NEXO.Diligencias.Api/HttpModels/Instruccion/*`
  - `src/NEXO.Diligencias.Api/Mappers/InstruccionFiscalResponseMapper.cs`
- Application:
  - `src/NEXO.Diligencias.Application/Features/Instruccion/Commands/*`
  - `src/NEXO.Diligencias.Application/Features/Instruccion/Queries/*`
  - `src/NEXO.Diligencias.Application/Persistence/Instruccion/IInstruccionFiscalRepository.cs`
- Infrastructure:
  - `src/NEXO.Diligencias.Infrastructure/Persistence/Instruccion/*`

### Si el ticket impacta Diligencias

- API:
  - `src/NEXO.Diligencias.Api/Controllers/DiligenciasController.cs`
  - `src/NEXO.Diligencias.Api/HttpModels/Diligencias/*`
  - `src/NEXO.Diligencias.Api/Mappers/DiligenciaResponseMapper.cs`
- Application:
  - `src/NEXO.Diligencias.Application/Features/Diligencias/Commands/*`
  - `src/NEXO.Diligencias.Application/Features/Diligencias/Queries/*`
  - `src/NEXO.Diligencias.Application/Persistence/Diligencias/IDiligenciasRepository.cs`
- Infrastructure:
  - `src/NEXO.Diligencias.Infrastructure/Persistence/Diligencias/*`

## Base de pruebas ya disponible

- Pruebas de casos de uso existentes en:
  - `tests/NEXO.Diligencias.Tests/Application/*`
- Casos utiles de referencia:
  - `CreateInstruccionFiscalCommandHandlerTests.cs`
  - `UpdateInstruccionFiscalCommandHandlerTests.cs`
  - `GetInstruccionFiscalQueryHandlerTests.cs`
  - `CreateDiligenciaCommandHandlerTests.cs`

## Checklist tecnico para arrancar implementacion

1. Confirmar alcance funcional final de PDI-1634 con negocio.
2. Determinar endpoint/caso de uso exacto a modificar o crear.
3. Definir contrato request/response y error handling esperado.
4. Implementar cambios en `Application` y `Infrastructure` antes de exponer ajuste en `Api`.
5. Agregar/actualizar pruebas unitarias del caso de uso.
6. Actualizar OpenAPI + `docs/api/v1/API.md` + artefacto Postman (si aplica).
7. Ejecutar build y test antes de PR.

## Propuesta de salida para la siguiente etapa

Al pasar a implementacion, el equipo deberia producir:

1. Historia tecnica cerrada (alcance final + criterios de aceptacion).
2. Matriz de impacto por archivo y capa.
3. Pull request con cambios de codigo, pruebas y documentacion.
4. Evidencia de validacion funcional/tecnica adjunta.
