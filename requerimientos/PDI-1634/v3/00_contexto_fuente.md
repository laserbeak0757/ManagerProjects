# 00 - Contexto fuente

## Fuente principal

- Jira (solo lectura): https://sonda.atlassian.net/browse/PDI-1634
- ID: PDI-1634
- Titulo visible: PO01.02.03.SF01 Registrar Actividad Policial
- Estado visible: Backlog

## Evidencia visible de descomposicion funcional

Subitems de epica detectados en vista:

1. PDI-1629 - Diligencia - Ingresar a caso - Registrar actividad - Inspeccion S.S
2. PDI-1630 - Levantamiento de evidencia
3. PDI-1631 - Personas Vinculadas
4. PDI-1632 - Individualizacion de denunciados

## Contexto del microservicio

Repositorio objetivo: Proyectos/sip-ms-diligencias

Rutas relacionadas a actividades:

- POST /ms/actividades
- GET /ms/actividades/actividad/{idActividad}/{idUsuario}
- GET /ms/actividades/diligencia/{idDiligencia}/{idUsuario}
- PUT /ms/actividades/{idActividad}/{idUsuario}
- DELETE /ms/actividades/{idActividad}
- DELETE /ms/actividades/actividades/{idDiligencia}

## Contexto de BD verificado

Repositorio de migraciones: Proyectos/sip-bd-migrations

Objetos detectados:

- Tabla: diligencias.actividad_investigativa
- SP: diligencias.crear_actividad_investigativa
- SP: diligencias.obtener_actividad_investigativa
- SP: diligencias.obtener_actividad_investigativa_por_id
- SP: diligencias.actualizar_actividad_investigativa
- SP: diligencias.eliminar_actividad_investigativa_por_id

## Conclusion

Existe base tecnica para implementar la epica sobre el modulo actual de ActividadInvestigativa. El bloqueo principal sigue siendo la falta de descripcion funcional detallada en la epica padre.
