# Gestion de requerimientos por ID

Esta carpeta centraliza requerimientos funcionales y tecnicos a nivel de workspace.

## Convencion de estructura

Cada requerimiento debe usar la siguiente estructura:

- {ID}/v{N}/

Ejemplo:

- PDI-967/v1/
- PDI-967/v2/

## Reglas de versionado

1. Usar una carpeta por ID de Jira.
2. Usar una subcarpeta por version incremental (v1, v2, v3...).
3. No sobrescribir versiones previas; crear una nueva version cuando cambie alcance, reglas o estimacion.
4. Mantener trazabilidad con fuente Jira y fecha de corte.

## Entregables minimos por version

- 00_contexto_fuente.md
- 01_analisis_alcance_impacto.md
- 02_diseno_funcional_tecnico.md
- 03_estimacion_tiempos.md
- 04_plan_validacion.md
- diagramas/*.puml

## Estado

- Activo desde: 2026-07-28
- Responsable de mantenimiento: equipo de desarrollo
