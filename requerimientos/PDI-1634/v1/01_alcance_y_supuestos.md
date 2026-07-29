# 01 - Alcance y supuestos

## Objetivo de implementacion (a confirmar con negocio)

Implementar el ajuste funcional solicitado por PDI-1634 dentro del microservicio `NEXO.Diligencias`, respetando la arquitectura por capas y el contrato OpenAPI versionado.

## Alcance inicial propuesto

1. Analizar el requerimiento funcional definitivo de PDI-1634 y mapearlo a un flujo del dominio Diligencias.
2. Implementar cambios minimos necesarios en capas `Api`, `Application` e `Infrastructure`.
3. Mantener compatibilidad de contratos existentes salvo que el ticket exija cambio de contrato.
4. Agregar o ajustar pruebas unitarias de casos de uso afectados.
5. Actualizar OpenAPI y documentacion funcional en `docs/api/v1/API.md`.

## Fuera de alcance en esta etapa

1. Cambios masivos de arquitectura o reorganizacion de carpetas.
2. Refactor transversal no relacionado al ticket.
3. Cambios en pipelines, infraestructura de despliegue o observabilidad global (salvo impacto directo del requerimiento).
4. Cambios en otros microservicios NEXO fuera de contratos acordados.

## Supuestos explicitados

1. PDI-1634 impacta una capacidad ya existente del dominio Diligencias (no un modulo totalmente nuevo).
2. El repositorio objetivo para implementar es solo `Proyectos/sip-ms-diligencias`.
3. Se mantendra la convencion de controlador delgado + caso de uso en `Application` + repositorio en `Infrastructure`.
4. Se utilizara SQL Server y persistencia existente en `Infrastructure/Persistence/*`.
5. Se requiere trazabilidad de contrato via `docs/openapi/v1/openapi.json` y `docs/openapi/v1/openapi.yaml`.

## Vacios funcionales pendientes de cierre antes de desarrollo

1. Criterio de negocio exacto de PDI-1634 (entrada/salida esperada, reglas y restricciones).
2. Actor principal, permisos y contexto de uso (investigador, fiscal, sistema interno, etc.).
3. Reglas de validacion de campos y comportamiento ante datos incompletos o inconsistentes.
4. Politica de error esperada por negocio (mensajes, codigos y condiciones).
5. Confirmacion de compatibilidad hacia consumidores actuales (web/bff/otros).

## Definicion de listo para pasar a desarrollo (DoR)

1. Historia PDI-1634 con descripcion funcional completa y criterios de aceptacion verificables.
2. Contrato de entrada/salida definido (nuevo o ajuste al actual).
3. Dependencias externas confirmadas (tablas, procedimientos, servicios).
4. Casos borde y reglas negativas acordados.
5. Aprobacion tecnica de alcance y riesgo por lider de celula.
