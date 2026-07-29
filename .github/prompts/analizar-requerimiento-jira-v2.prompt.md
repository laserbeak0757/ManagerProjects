---
description: "Analiza un requerimiento Jira y genera paquete versionado con alcance, impacto, estimacion por frente y semaforo de riesgo."
---

# Prompt v2: Analizar requerimiento Jira (completo)

Analiza el requerimiento Jira indicado y genera documentacion versionada por ID en la raiz de Projects.

## Input

- id: PDI-XXXX
- url: https://sonda.atlassian.net/browse/PDI-XXXX
- version: v1
- foco (opcional): front | bff | ms | e2e
- estimacionDetalle (opcional): true | false
- semaforoRiesgo (opcional): true | false

## Salida esperada

1. Crear carpeta: requerimientos/{id}/{version}/
2. Crear archivos obligatorios:
- 00_contexto_fuente.md
- 01_analisis_alcance_impacto.md
- 02_diseno_funcional_tecnico.md
- 03_estimacion_tiempos.md
- 04_plan_validacion.md
3. Crear carpeta de diagramas: requerimientos/{id}/{version}/diagramas/
4. Crear minimo 2 diagramas de secuencia PUML:
- 01_consulta_principal.puml
- 02_flujo_accion_critica.puml
5. Incluir en documentos:
- alcance y fuera de alcance
- impacto por componente (Front/BFF/MS/DB/QA)
- riesgos, supuestos, dependencias y preguntas abiertas
- criterios de aceptacion trazables

## Reglas de estimacion

Si estimacionDetalle=true:

- desglosar horas por frente:
  - MS
  - BFF
  - Front
  - QA/Documentacion
- agregar contingencia de riesgo (% y total)
- entregar 2 escenarios de calendario:
  - equipo en paralelo
  - equipo parcial

## Semaforo de riesgo

Si semaforoRiesgo=true, agregar al final de 01_analisis_alcance_impacto.md:

- Riesgo General: Verde | Amarillo | Rojo
- Criterios evaluados:
  - claridad funcional
  - dependencias externas
  - complejidad tecnica
  - impacto en seguridad/datos
  - incertidumbre de reglas de negocio
- Accion recomendada por cada riesgo Amarillo/Rojo.

## Formato de entrega al usuario

1. Resumen ejecutivo (5-10 lineas).
2. Lista de archivos generados.
3. Riesgos principales y decisiones pendientes.
4. Proximo paso recomendado.

## Ejemplo de ejecucion

id: PDI-967
url: https://sonda.atlassian.net/browse/PDI-967
version: v2
foco: e2e
estimacionDetalle: true
semaforoRiesgo: true
