# 02 - Diseno funcional tecnico

## Mapa tecnico actual

API:

- src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs

Application:

- src/NEXO.Diligencias.Application/Features/Actividad/Commands/CreateActividadInvestigativa/*
- src/NEXO.Diligencias.Application/Features/Actividad/Commands/UpdateActividadInvestigativa/*
- src/NEXO.Diligencias.Application/Features/Actividad/Queries/GetActividadById/*
- src/NEXO.Diligencias.Application/Features/Actividad/Queries/GetActividadByIdDiligencia/*
- src/NEXO.Diligencias.Application/Persistence/Actividad/IActividadInvestigativaRepository.cs

Infrastructure:

- src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaRepository.cs
- src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/ActividadInvestigativaQueries.cs

## Hallazgos tecnicos relevantes

1. Los DELETE de controlador retornan Ok(true) sin logica real.
2. Los validadores Create/Update contienen validacion minima.
3. Existen SP para create/get/getById/update/delete ya versionados en migraciones.

## Propuesta tecnica de implementacion

1. Endurecer validaciones en comandos Create/Update:
   - idDiligencia
   - idFuncionario
   - tipoActividad
   - descripcion
   - fechaActividad
   - ids de usuario segun operacion
2. Implementar casos de uso y repositorio para delete por id y delete por diligencia.
3. Homologar errores de validacion con mensajes utiles para API.
4. Alinear contrato OpenAPI de actividades con reglas finales.

## Consideraciones de datos

1. Mantener soft-delete por fecha_eliminacion_logica e id_usuario_eliminador.
2. Revisar coherencia de tipos para es_resultado_negativo entre DTO, dominio y SP.
3. Verificar constraints y FK existentes antes de ajustar SP.
