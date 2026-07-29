---
description: "Genera analisis tecnico completo de un requerimiento Jira y crea paquete versionado por ID en la raiz del workspace."
---

# Prompt simple: Analizar requerimiento Jira

Analiza el siguiente requerimiento Jira y genera documentacion versionada por ID en la raiz de Projects, incluyendo alcance, impacto, estimacion, plan de validacion y diagramas de secuencia PUML.

Reglas operativas obligatorias:

- Jira es solo fuente de lectura. No escribir comentarios ni editar campos.
- Validar contexto tecnico del repositorio objetivo antes de proponer alcance.
- Si aplica, validar dependencias de base de datos y contratos tecnicos asociados.

Input:

- id: PDI-XXXX
- url: https://sonda.atlassian.net/browse/PDI-XXXX
- version: v1

Salida esperada:

1. Crear carpeta: requerimientos/{id}/{version}/
2. Crear archivos:
- 00_contexto_fuente.md
- 01_analisis_alcance_impacto.md
- 02_diseno_funcional_tecnico.md
- 03_estimacion_tiempos.md
- 04_plan_validacion.md
3. Crear diagramas PUML en: requerimientos/{id}/{version}/diagramas/
4. Incluir riesgos, supuestos, dependencias y preguntas abiertas.
5. Preparar base tecnica para etapa de implementacion futura.

Ejemplo de ejecucion:

id: PDI-967
url: https://sonda.atlassian.net/browse/PDI-967
version: v1
