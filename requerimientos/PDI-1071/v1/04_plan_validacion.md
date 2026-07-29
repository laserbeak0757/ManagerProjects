# PDI-1071 - Plan de validacion

## Objetivo

Validar exactitud, seguridad y estabilidad del endpoint GET de actividades asociadas a diligencia.

## Casos funcionales minimos

1. Diligencia con actividades
- Dado un diligenciaId valido con actividades
- Cuando se consulta
- Entonces retorna 200 con lista ordenada y campos esperados

2. Diligencia sin actividades
- Dado un diligenciaId valido sin actividades
- Cuando se consulta
- Entonces retorna 200 con items vacio

3. Diligencia inexistente
- Dado un diligenciaId inexistente
- Cuando se consulta
- Entonces retorna 404 controlado

4. Parametro invalido
- Dado un diligenciaId invalido
- Cuando se consulta
- Entonces retorna 400 controlado

## Casos de seguridad

1. Usuario sin permiso de consulta
- Debe retornar 403.

2. Intento de consultar diligencia fuera de alcance
- Debe denegar acceso y no exponer datos.

## Casos tecnicos

1. Contrato de respuesta consistente con OpenAPI.
2. Manejo estandar de errores (400/403/404/500).
3. Respuesta dentro del umbral esperado de rendimiento.

## Evidencia requerida

1. Requests/responses de casos positivos y negativos.
2. Resultado de pruebas unitarias e integracion.
3. Registro de validacion de seguridad (403/no-fuga).
4. Trazabilidad caso -> resultado -> evidencia.

## Criterio de salida

1. 100% de casos minimos ejecutados y aprobados.
2. Sin defectos criticos o altos pendientes.
3. Contrato de salida validado por consumidor.
