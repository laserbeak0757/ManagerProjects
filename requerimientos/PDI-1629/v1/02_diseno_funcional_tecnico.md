# 02 - Diseno funcional tecnico

## Mapa tecnico actual

### API

- `src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs`

### Application

- `src/NEXO.Diligencias.Application/Features/Actividad/Commands/CreateActividadInvestigativa/*`
- `src/NEXO.Diligencias.Application/Features/Actividad/Commands/UpdateActividadInvestigativa/*`
- `src/NEXO.Diligencias.Application/Features/Actividad/Queries/GetActividadById/*`
- `src/NEXO.Diligencias.Application/Features/Actividad/Queries/GetActividadByIdDiligencia/*`

### Infrastructure

- `src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaRepository.cs`
- `src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaQueries.cs`

## Hallazgos tecnicos relevantes

1. El flujo base de actividad ya existe y es reutilizable.
2. Los validadores actuales son minimos y requieren endurecimiento.
3. El DELETE actual en controlador no tiene implementacion real.
4. La persistencia ya tiene SP para crear, consultar y actualizar actividades.

## Diseno propuesto

1. Registrar actividad al ingreso a caso reutilizando el comando de create.
2. Validar obligatorios de manera explicita en Application.
3. Mantener un contrato de respuesta estable y trazable para QA.
4. Definir si el flujo debe invocar create unico o encadenar mas de una accion.

## Dependencias de BD

1. Verificar si el SP de create cubre el escenario exacto de Inspeccion S.S.
2. Revisar auditoria y llaves foraneas para actividad_investigativa.
3. Confirmar si el flujo requiere ajustes de borrado logico o solo alta/consulta.
