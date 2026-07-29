# 04 - Plan de validacion

## Objetivo

Validar que la implementacion de PDI-1634 cumpla reglas funcionales acordadas, mantenga consistencia de datos y no introduzca regresiones en el modulo de diligencias.

## Criterios de validacion funcional

1. Crear actividad policial con datos validos retorna exito y payload consistente.
2. Consultar actividad por id retorna datos esperados y auditables.
3. Consultar actividades por diligencia retorna lista consistente.
4. Actualizar actividad aplica cambios validos y mantiene trazabilidad.
5. Eliminar actividad (individual/masiva) respeta politica de soft-delete acordada.

## Criterios de validacion tecnica

1. Build exitoso:
   - `dotnet build NEXO.Diligencias.sln`
2. Tests exitosos:
   - `dotnet test tests/NEXO.Diligencias.Tests/NEXO.Diligencias.Tests.csproj`
3. Nuevas pruebas unitarias de casos de uso de Actividad creadas/ajustadas.
4. Validaciones de comandos Create/Update cubren casos positivos y negativos.

## Criterios de validacion de contrato

1. OpenAPI actualizado cuando haya cambios de request/response/codigos.
2. `docs/api/v1/API.md` actualizado en seccion de actividad.
3. Coleccion de pruebas (si aplica) actualizada y trazable a OpenAPI.

## Casos negativos minimos

1. Falta de `idDiligencia` o `idFuncionario`.
2. `fechaActividad` invalida o nula segun regla acordada.
3. `idActividad` inexistente en consulta/actualizacion/eliminacion.
4. Usuario no autenticado o sin permisos.
5. Datos inconsistentes de resultado negativo.

## Evidencia esperada para cierre

1. Resultado de build y test adjunto.
2. Lista de archivos modificados por capa.
3. Evidencia de validacion de SP/DB si hubo cambios.
4. Matriz de casos QA ejecutados con estado final.

## Gate de paso a desarrollo

1. Descripcion funcional de Jira completada o reemplazada por minuta de refinamiento validada.
2. Criterios de aceptacion cerrados.
3. Supuestos y riesgos aprobados por lider tecnico/PO.
4. Plan de pruebas acordado con QA.
