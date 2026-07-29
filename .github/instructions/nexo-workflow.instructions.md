---
applyTo: "Proyectos/**"
description: "Use when implementing or modifying NEXO repos (ms, bff, web, migrations). Enforce standards-first workflow and Postman deliverables."
---

# NEXO Local Workflow Guardrails

## Scope

- Applies to repositories under `Proyectos/`.
- Ignore `Proyectos/swagger_docs/` unless the user explicitly asks to edit it.

## Mandatory discovery order

Before proposing or applying changes:

1. Read `README.md` in the target repository.
2. Read `AGENTS.md` and `AGENTS.repository.md` when they exist.
3. Read docs relevant to the task:
   - architecture and API
   - coding and local setup
   - deployment if runtime config changes
   - QA and OpenAPI rules when docs are requested
4. Inspect current project structure and tests.

## Work mode

- Default mode: maintenance.
- Do not reorganize architecture, folders, or namespaces unless explicitly requested.
- Keep controllers thin and preserve current layering conventions.

## Database-first tasks

When the request starts from a SQL object (table, view, procedure):

1. Validate local DB connectivity through the migrations stack.
2. Inspect real schema and columns before coding.
3. Identify read/write use cases and endpoint contracts.
4. Implement in the proper repo (ms or bff) following that repo standards.

## Required deliverables for implementation tasks

- Source code changes.
- Unit tests (new or updated).
- OpenAPI update/validation when HTTP contract changes.
- Documentation updates are always mandatory.
- Documentation updates required by repository rules.
- Postman artifacts for validation:
  - Collection JSON.
  - Environment JSON (local values only, no secrets).
  - Collection must be traceable to OpenAPI in `docs/openapi/`.

## Postman policy

- Treat Postman as an auxiliary validation artifact.
- Do not replace OpenAPI as source of truth.
- Prefer storing under `docs/collections/postman/` when repository has `docs/collections/`.
- Do not commit credentials, tokens, or secrets.

## Completion checklist

Before closing a task:

1. Build and run tests for the target solution.
2. Report what was changed and why.
3. Report which standards were applied.
4. Confirm documentation was updated and list impacted files.
5. List generated Postman files and how to run them.
