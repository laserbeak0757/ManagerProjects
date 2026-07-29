# 00 - Contexto fuente

## Fuente principal (solo lectura)

- Jira: `https://sonda.atlassian.net/browse/PDI-1634`
- ID: `PDI-1634`
- Titulo visible: `PO01.02.03.SF01 Registrar Actividad Policial`
- Estado visible: `Backlog`
- Tipo visible: Epica

## Hallazgos visibles en Jira

1. La epica contiene actividades secundarias visibles:
   - `PDI-1629`: Diligencia - Ingresar a caso - Registrar actividad - Inspeccion S.S
   - `PDI-1630`: Levantamiento de evidencia
   - `PDI-1631`: Personas Vinculadas
   - `PDI-1632`: Individualizacion de denunciados
2. No se observa descripcion funcional detallada en el campo descripcion de la epica.
3. El porcentaje de avance visible de subtareas es `0%`.

## Contexto tecnico verificado en repositorios

### Microservicio objetivo

- Repositorio: `Proyectos/sip-ms-diligencias`
- Controlador relacionado:
  - `src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs`
- Rutas funcionales relacionadas:
  - `POST /ms/actividades`
  - `GET /ms/actividades/actividad/{idActividad}/{idUsuario}`
  - `GET /ms/actividades/diligencia/{idDiligencia}/{idUsuario}`
  - `PUT /ms/actividades/{idActividad}/{idUsuario}`

### Persistencia/BD asociada

- Repositorio de migraciones: `Proyectos/sip-bd-migrations`
- Tabla base:
  - `diligencias.actividad_investigativa` (baseline y migraciones evolutivas)
- SP detectados en `migrations/repeatable/R__diligencias_programmability.sql`:
  - `diligencias.crear_actividad_investigativa`
  - `diligencias.obtener_actividad_investigativa`
  - `diligencias.obtener_actividad_investigativa_por_id`
  - `diligencias.actualizar_actividad_investigativa`
  - `diligencias.eliminar_actividad_investigativa_por_id`

## Conclusion de contexto

El requerimiento PDI-1634 tiene alineacion nominal directa con el modulo de Actividad Investigativa del microservicio, pero el detalle funcional del negocio no esta explicitado en la epica visible. Por lo tanto, la implementacion debe arrancar con refinamiento funcional obligatorio antes de codificar.
