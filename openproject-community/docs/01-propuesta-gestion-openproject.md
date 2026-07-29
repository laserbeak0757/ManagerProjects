# Propuesta de Gestion en OpenProject (Portafolio por Agente)

## Objetivo
Organizar el trabajo por agente en subproyectos para mantener trazabilidad, orden operativo y visibilidad ejecutiva.

## Estructura recomendada
1. Proyecto padre: Plataforma Agentes.
2. Subproyectos por agente:
   - NEXO BFF Downstream
   - NEXO DB Analysis
   - NEXO MS From Table
   - NEXO Postman and QA Pack
   - NEXO Requerimiento Analisis
   - Explore
   - FabricAdmin
   - FabricAppDev
   - FabricDataEngineer
   - FabricIQ
   - genpage-planner
   - genpage-entity-builder
   - genpage-page-builder
   - genpage-edit-planner
   - genpage-connector-builder

## Estandar comun para todos los subproyectos
### Tipos de tarea
- Epic
- Feature
- Task
- Bug
- Spike
- Documentacion

### Flujo de estado
- Backlog
- En analisis
- En curso
- En revision
- Validacion
- Listo

### Campos minimos
- Prioridad
- Riesgo
- Entorno
- Requerimiento origen
- Evidencia QA
- Fecha compromiso
- Responsable

## Reglas operativas
1. Todo trabajo nuevo entra como Feature o Bug.
2. Cada Feature debe incluir Definition of Done.
3. Ningun item pasa a Listo sin evidencia de validacion.
4. Todo Bug debe enlazar al item funcional afectado.
5. Toda entrega debe dejar artefactos: evidencia, enlaces, decisiones.

## Vista ejecutiva en el proyecto padre
Crear un tablero consolidado con:
- Carga por agente (items abiertos por estado)
- Bloqueos activos
- Tiempo de ciclo por tipo de trabajo
- Entregas por sprint
- Riesgos altos sin plan de mitigacion

## Cadencia recomendada
- Planeacion semanal por subproyecto (30-45 min)
- Seguimiento diario rapido por equipo (10-15 min)
- Revision quincenal transversal en el proyecto padre
- Cierre de sprint con retro y lecciones aprendidas

## Politica de calidad (DoD minima)
Un item se considera Listo solo si:
- Cumple criterios de aceptacion
- Tiene evidencia funcional o tecnica
- Tiene documentacion minima actualizada
- Tiene impacto y riesgos registrados
- Tiene responsable de soporte o seguimiento

## Implementacion en 60 minutos
1. Crear proyecto padre Plataforma Agentes.
2. Crear los 15 subproyectos.
3. Homologar tipos y flujo.
4. Crear campos minimos.
5. Crear tablero consolidado en el proyecto padre.
6. Crear plantilla de issue Feature y Bug.

## Plantilla rapida de Feature
- Contexto
- Objetivo
- Alcance
- Criterios de aceptacion
- Riesgos
- Evidencia requerida
- Responsable

## Plantilla rapida de Bug
- Comportamiento actual
- Comportamiento esperado
- Pasos de reproduccion
- Severidad
- Causa probable
- Fix propuesto
- Evidencia de correccion
