# Workspace of reference projects and artifacts

Esta carpeta centraliza requerimientos funcionales y tecnicos a nivel de workspace.

## Indice

- [Convencion de estructura](#convencion-de-estructura)
- [Reglas de versionado](#reglas-de-versionado)
- [Entregables minimos por version](#entregables-minimos-por-version)
- [Como funciona el analisis de requerimientos](#como-funciona-el-analisis-de-requerimientos)
- [Flujo operativo (paso a paso)](#flujo-operativo-paso-a-paso)
- [Que debe incluir cada entregable](#que-debe-incluir-cada-entregable)
- [Criterio de salida del analisis](#criterio-de-salida-del-analisis)
- [Ejemplo rapido](#ejemplo-rapido)
- [Estado](#estado)

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

## Como funciona el analisis de requerimientos

El analisis se trabaja por iteraciones versionadas dentro de cada ID (por ejemplo: PDI-1071/v1).

### Flujo operativo (paso a paso)

1. Crear carpeta de trabajo del requerimiento: {ID}/v{N}/.
2. Registrar la fuente y contexto en 00_contexto_fuente.md (Jira, alcance inicial, fecha de corte, responsables).
3. Documentar alcance, impacto, vacios y supuestos en 01_analisis_alcance_impacto.md.
4. Definir diseno funcional y tecnico en 02_diseno_funcional_tecnico.md (flujo, datos, contratos y dependencias).
5. Estimar tiempos y riesgos en 03_estimacion_tiempos.md.
6. Definir validacion funcional/tecnica en 04_plan_validacion.md.
7. Si aplica, anexar diagramas en diagramas/*.puml.
8. Cerrar la version cuando exista consenso tecnico-funcional; si cambia el alcance, crear nueva version (v2, v3...).

### Que debe incluir cada entregable

- 00_contexto_fuente.md: referencia Jira/PDI, problema, objetivo, actores y restricciones.
- 01_analisis_alcance_impacto.md: in-scope, out-of-scope, impacto en MS/BFF/BD, supuestos y preguntas abiertas.
- 02_diseno_funcional_tecnico.md: propuesta de solucion, contratos API o SQL, reglas de negocio, dependencias.
- 03_estimacion_tiempos.md: esfuerzo por tarea, riesgos, bloqueadores y orden sugerido de ejecucion.
- 04_plan_validacion.md: casos de prueba, criterios de aceptacion, evidencias esperadas (OpenAPI/Postman/reportes).
- diagramas/*.puml: secuencias, componentes o modelo de datos cuando agregue claridad tecnica.

### Criterio de salida del analisis

Un analisis se considera listo para implementar cuando:

1. El alcance y los supuestos estan explicitados.
2. Existe diseno tecnico suficiente para construir sin ambiguedad.
3. La estimacion y riesgos estan acordados.
4. El plan de validacion define que se probara y con que evidencia.

### Ejemplo rapido

Para PDI-1071:

1. Crear carpeta PDI-1071/v1.
2. Completar los 5 archivos base y diagramas necesarios.
3. Pasar a implementacion en el repo objetivo con referencia a esta version del analisis.

## Estado

- Activo desde: 2026-07-28
- Responsable de mantenimiento: equipo de desarrollo
