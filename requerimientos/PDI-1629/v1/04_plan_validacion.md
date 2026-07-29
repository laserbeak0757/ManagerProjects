# 04 - Plan de validacion

## Objetivo

Validar que el registro de actividad asociado al ingreso a caso funcione de forma consistente y sin romper el modulo de actividades.

## Criterios funcionales

1. Crear actividad retorna exito con datos correctos.
2. Consultar por id retorna la actividad esperada.
3. Consultar por diligencia retorna lista consistente.
4. Actualizacion conserva trazabilidad.
5. El flujo de ingreso a caso no deja datos incompletos.

## Criterios tecnicos

1. `dotnet build NEXO.Diligencias.sln` exitoso.
2. `dotnet test tests/NEXO.Diligencias.Tests/NEXO.Diligencias.Tests.csproj` exitoso.
3. Cobertura de casos positivos y negativos del flujo.
4. Validaciones de entrada y manejo de error consistentes.

## Casos negativos minimos

1. Falta de idDiligencia.
2. Falta de idFuncionario.
3. Usuario no autenticado.
4. Diligencia inexistente.
5. Datos inconsistentes en resultado/fecha.

## Evidencias

1. Build y test adjuntos.
2. Matriz de casos QA.
3. OpenAPI y guia API actualizadas si aplica.
