# 03 - Criterios de validacion

## Criterios funcionales minimos

1. El comportamiento implementado cumple exactamente los criterios de aceptacion acordados para PDI-1634.
2. Se cubren escenarios positivos y negativos definidos en refinamiento.
3. Los codigos HTTP y mensajes de respuesta siguen el patron actual del servicio.
4. No se rompe funcionalidad existente en endpoints del mismo contexto.

## Criterios tecnicos

1. Compila la solucion completa:
   - `dotnet build NEXO.Diligencias.sln`
2. Pruebas ejecutadas y exitosas en proyecto de tests:
   - `dotnet test tests/NEXO.Diligencias.Tests/NEXO.Diligencias.Tests.csproj`
3. Se agregan/ajustan pruebas unitarias de casos de uso impactados.
4. Se mantiene propagacion de `CancellationToken` y estilo de capas actual.

## Criterios de contrato y documentacion

1. OpenAPI actualizado si cambia el contrato HTTP.
2. `docs/api/v1/API.md` actualizado con descripcion y ejemplos del flujo afectado.
3. Si aplica, coleccion Postman actualizada en `docs/collections/postman`.
4. Trazabilidad entre ticket PDI-1634, endpoint y caso de uso documentada.

## Criterios de no regresion

1. Endpoints existentes del modulo afectado responden sin cambios no esperados.
2. Validaciones preexistentes continuan activas.
3. Manejo de excepciones mantiene formato estandar `ApiResponse`.
4. El comportamiento con autenticacion habilitada/deshabilitada se valida segun ambiente.

## Evidencias requeridas para cierre

1. Resultado de build y test adjunto en PR.
2. Lista de archivos modificados por capa (Api/Application/Infrastructure/docs/tests).
3. Dif de OpenAPI (si aplica).
4. Casos de prueba ejecutados por QA (manual o automatizado) con resultado.
