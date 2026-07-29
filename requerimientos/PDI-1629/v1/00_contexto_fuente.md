# 00 - Contexto fuente

## Fuente principal

- Jira (solo lectura): `https://sonda.atlassian.net/browse/PDI-1629`
- ID: `PDI-1629`
- Titulo visible: `Diligencia - Ingresar a caso - Registrar actividad - Inspección S.S`
- Estado visible: `Backlog`

## Hallazgos visibles

1. El ticket esta asociado al flujo de registrar actividad sobre diligencia/caso.
2. No se observa descripcion funcional detallada en la vista visible.
3. El ticket aparece dentro del arbol funcional relacionado con la epica `PDI-1634`.
4. En la vista se observan claves relacionadas en el arbol de Jira, incluyendo `PDI-970` como referencia visible de contexto superior.

## Contexto tecnico verificado en repositorios

### Microservicio objetivo

Repositorio: `Proyectos/sip-ms-diligencias`

Ruta de alta/consulta/actualizacion relacionada:

- `src/NEXO.Diligencias.Api/Controllers/ActividadInvestigativaController.cs`
- `src/NEXO.Diligencias.Application/Features/Actividad/*`
- `src/NEXO.Diligencias.Infrastructure/Persistence/Actividad/*`

### Persistencia asociada

Repositorio de migraciones: `Proyectos/sip-bd-migrations`

Objetos detectados:

- Tabla: `diligencias.actividad_investigativa`
- SP: `diligencias.crear_actividad_investigativa`
- SP: `diligencias.obtener_actividad_investigativa`
- SP: `diligencias.obtener_actividad_investigativa_por_id`
- SP: `diligencias.actualizar_actividad_investigativa`
- SP: `diligencias.eliminar_actividad_investigativa_por_id`

## Conclusion

El requerimiento tiene alineacion directa con el modulo existente de actividad investigativa. El principal vacio sigue siendo la definicion funcional exacta del paso "ingresar a caso / registrar actividad / inspeccion S.S" dentro del flujo operacional.
