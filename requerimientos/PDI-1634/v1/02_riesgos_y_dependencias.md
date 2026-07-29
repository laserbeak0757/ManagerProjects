# 02 - Riesgos y dependencias

## Riesgos identificados

### Riesgos funcionales

1. Ambiguedad de requerimiento: sin detalle funcional visible del ticket, se puede implementar un comportamiento distinto al esperado.
2. Criterios de aceptacion incompletos: riesgo de retrabajo por cambios tardios en validaciones o respuestas.
3. Regresiones funcionales en endpoints existentes si se reutilizan flujos sin cobertura adecuada.

### Riesgos tecnicos

1. Inconsistencias de contrato HTTP si no se sincroniza `Api` con OpenAPI versionado.
2. Falta de pruebas para caminos negativos puede ocultar errores en validaciones de `Application`.
3. Dependencia de SQL/objetos de base de datos no versionados en este repo puede bloquear pruebas locales.
4. Diferencias entre convenciones actuales del codigo y necesidad del ticket pueden introducir deuda tecnica.

### Riesgos operacionales

1. Configuracion de autenticacion (`Authentication:RequireAuthenticatedUser`) puede alterar ejecucion de pruebas manuales si no se controla por ambiente.
2. Disponibilidad de ambientes o datos semilla puede limitar validacion end-to-end.

## Dependencias tecnicas

1. Capa API:
   - Controladores en `src/NEXO.Diligencias.Api/Controllers`.
   - Contratos HTTP en `src/NEXO.Diligencias.Api/HttpModels`.
2. Capa Application:
   - Features por contexto en `src/NEXO.Diligencias.Application/Features`.
   - Validaciones y casos de uso asociados al flujo afectado.
3. Capa Infrastructure:
   - Repositorios en `src/NEXO.Diligencias.Infrastructure/Persistence`.
   - Conexion SQL en `src/NEXO.Diligencias.Infrastructure/Persistence/Sql`.
4. Contrato:
   - `docs/openapi/v1/openapi.json`
   - `docs/openapi/v1/openapi.yaml`
5. QA:
   - Guia funcional `docs/api/v1/API.md`.
   - Colecciones derivadas en `docs/collections/postman`.

## Dependencias organizacionales

1. Product owner/analista funcional para cerrar reglas de negocio faltantes.
2. Equipo consumidor (web/bff) para validar impactos de contrato.
3. QA para acordar evidencia de aceptacion y pruebas de regresion.
4. Si aplica, equipo de datos para confirmar esquema y objetos SQL requeridos.

## Mitigaciones recomendadas previas a codificacion

1. Sesion corta de refinamiento funcional para cerrar vacios de PDI-1634.
2. Matriz entrada/salida con ejemplos de request/response antes de implementar.
3. Prueba de impacto rapido sobre OpenAPI y consumidores conocidos.
4. Plan de pruebas unitarias y de regresion definido antes del primer commit de feature.
