---
description: "Generate or update Postman collection and local environment from OpenAPI and implemented endpoints for QA/developer validation."
---

# Prompt: Generar Postman de validacion

Objetivo:

Generar artefactos Postman reutilizables para validar endpoints implementados.

Input minimo esperado:

- Repo objetivo.
- Version OpenAPI usada (ejemplo: `docs/openapi/v1/openapi.json`).
- Lista de endpoints a incluir.

Instrucciones de ejecucion:

1. Validar que OpenAPI este actualizado.
2. Generar o actualizar coleccion Postman basada en OpenAPI.
3. Generar o actualizar environment local con variables de host, basePath y token placeholder.
4. Incluir ejemplos de casos exitosos y de error esperado cuando aplique.
5. Guardar artefactos en la ruta de colecciones del repo.
6. Actualizar documentacion de soporte para dejar trazabilidad de la validacion.

Entregables obligatorios:

- `*.postman_collection.json`
- `*.postman_environment.json`
- Documentacion actualizada de validacion.
- Resumen de como ejecutar validaciones.
