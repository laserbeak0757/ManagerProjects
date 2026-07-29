---
description: "Implement a microservice requirement starting from a SQL Server table/view, with tests, OpenAPI, docs, and Postman outputs."
---

# Prompt: Implementar MS desde tabla SQL

Objetivo:

Implementar una funcionalidad en un microservicio NEXO a partir de una tabla o vista SQL Server.

Input minimo esperado:

- Repo objetivo (ejemplo: `Proyectos/sip-ms-diligencias`).
- Esquema y tabla/vista (ejemplo: `diligencias.instruccion_fiscal`).
- Operaciones requeridas (ejemplo: listar por id, crear, actualizar estado).
- Contrato HTTP esperado o reglas de negocio conocidas.

Instrucciones de ejecucion:

1. Leer y aplicar `README.md`, `AGENTS.md`, `AGENTS.repository.md` y docs obligatorios del repo.
2. Verificar estructura real de la tabla/vista en BD local.
3. Implementar capa Application, Domain (si aplica), Infrastructure y Api sin romper patrones existentes.
4. Agregar o ajustar pruebas unitarias.
5. Actualizar o validar OpenAPI versionado.
6. Actualizar documentacion requerida por el repo.
7. Generar coleccion Postman y environment local sin secretos.
8. No cerrar la tarea si no queda documentacion actualizada.

Entregables obligatorios:

- Cambios de codigo.
- Pruebas.
- OpenAPI actualizado/validado.
- Documentacion actualizada.
- Archivos Postman (`collection` y `environment`).
- Resumen de validacion ejecutada.
