# 02 - Diseno funcional tecnico

## Flujo funcional objetivo

1. Usuario autenticado registra actividad policial vinculada a una diligencia.
2. El servicio valida campos minimos y reglas de consistencia.
3. Se persiste actividad en `diligencias.actividad_investigativa` via SP.
4. Se permite consultar por id de actividad y por id de diligencia.
5. Se permite actualizar actividad bajo reglas de negocio.
6. (Pendiente de cierre funcional) eliminar logicamente actividad individual y masiva por diligencia.

## Componentes tecnicos actuales

### API

- `src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs`
- Observacion tecnica:
  - Los endpoints `DELETE` actuales retornan `Ok(true)` sin integracion real a caso de uso/repositorio.

### Application

- Create:
  - `Features/Actividad/Commands/CreateActividadInvestigativa/*`
- Update:
  - `Features/Actividad/Commands/UpdateActividadInvestigativa/*`
- Query:
  - `Features/Actividad/Queries/GetActividadById/*`
  - `Features/Actividad/Queries/GetActividadByIdDiligencia/*`
- Observacion tecnica:
  - Validadores actuales tienen validacion minima y mensajes vacios (`errors.Add("")`), lo que reduce calidad de errores funcionales.

### Infrastructure/SQL

- `Infrastructure/Persistence/Actividad/ActividadInvestigativaRepository.cs`
- `Infrastructure/Persistence/Actividad/ActividadInvestigativaQueries.cs`
- SP asociados:
  - `diligencias.crear_actividad_investigativa`
  - `diligencias.obtener_actividad_investigativa`
  - `diligencias.obtener_actividad_investigativa_por_id`
  - `diligencias.actualizar_actividad_investigativa`

## Diseno propuesto para implementacion futura

1. Endurecer validaciones en comandos Create/Update:
   - `idDiligencia`, `idFuncionario`, `tipoActividad`, `descripcion`, `fechaActividad`, `idUsuario*`.
2. Alinear tipos y mapeos (`es_resultado_negativo`) entre DTO, dominio y SP.
3. Implementar casos de uso reales para DELETE individual y DELETE masivo por diligencia.
4. Unificar criterio de origen de `idUsuario` (ruta/query/contexto autenticado) para evitar inconsistencias.
5. Asegurar mensajes de validacion funcional comprensibles y trazables.

## Dependencias de BD

1. Confirmar firma final de SP para create/update/delete vs contrato API esperado.
2. Verificar constraints vigentes sobre `diligencias.actividad_investigativa` (FKs, checks de bit/tinyint, auditoria).
3. Validar estrategia de soft-delete y campos de auditoria para eliminar individual y masivo.

## Decisiones de arquitectura (mantenimiento)

1. Mantener controlador delgado.
2. Encapsular reglas de aplicacion en `Application`.
3. Mantener acceso a datos en `Infrastructure` por SP.
4. No introducir cambios de estructura fuera del alcance.
