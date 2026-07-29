# PDI-1071 - Paquete documental v2

## Alcance de esta version

Version de refinamiento tecnico con trazabilidad explicita al ticket padre PDI-970, incorporando reglas de negocio visibles en Jira y dependencias activas del flujo de actividades.

## Inputs aplicados

- id: PDI-1071
- url: https://sonda.atlassian.net/browse/PDI-1071
- parent: https://sonda.atlassian.net/browse/PDI-970
- version: v2
- foco: ms-diligencias
- fechaCorte: 2026-07-28

## Contenido

1. 00_contexto_fuente.md
2. 01_analisis_alcance_impacto.md
3. 02_diseno_funcional_tecnico.md
4. 03_estimacion_tiempos.md
5. 04_plan_validacion.md
6. diagramas/01_consulta_actividades_por_diligencia.puml
7. diagramas/02_secuencia_autorizacion_y_estados.puml

## Cambios respecto a v1

1. Se incorporan reglas RN01-RN04 desde la historia padre PDI-970.
2. Se precisa el dominio de salida de estados de actividad: Pendiente, Completado, Descartado.
3. Se agrega trazabilidad de dependencias con subtareas activas del flujo (PDI-1517, PDI-1518, PDI-1519, PDI-1520, PDI-1531).
4. Se ajusta estimacion y plan de validacion considerando formularios variables por tipo de actividad.
