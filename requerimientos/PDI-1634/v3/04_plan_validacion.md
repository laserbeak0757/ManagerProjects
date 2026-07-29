# 04 - Plan de validacion

## Objetivo

Asegurar cumplimiento funcional del registro de actividad policial sin regresion en flujos de diligencias.

## Criterios funcionales

1. Create actividad retorna 201 y datos consistentes.
2. Get por id retorna actividad correcta.
3. Get por diligencia retorna lista consistente.
4. Update aplica cambios y conserva trazabilidad.
5. Delete individual/masivo aplica eliminacion logica segun regla.

## Criterios tecnicos

1. dotnet build NEXO.Diligencias.sln exitoso.
2. dotnet test tests/NEXO.Diligencias.Tests/NEXO.Diligencias.Tests.csproj exitoso.
3. Cobertura de pruebas para casos positivos y negativos de actividad.

## Casos negativos minimos

1. Falta de campos obligatorios.
2. idActividad inexistente.
3. idDiligencia inexistente para busqueda/borrado.
4. Usuario no autenticado o invalido.
5. Inconsistencia en resultado negativo.

## Contrato y evidencias

1. OpenAPI actualizado si cambia contrato.
2. docs/api/v1/API.md actualizado para actividades.
3. Evidencia de build/test y matriz QA adjunta en PR.
