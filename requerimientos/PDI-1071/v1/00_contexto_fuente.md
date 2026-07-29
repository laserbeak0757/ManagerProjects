# PDI-1071 - Contexto fuente

## Metadatos

- ID: PDI-1071
- Titulo: (ms-diligencia) get actividades asociadas a la diligencia
- Tipo: Subtarea
- Estado observado: En curso
- Prioridad: Media
- Asignado: Gerardo Carlos Quiroz Nancupil
- Estimacion original: 2h
- Tiempo restante: 2h
- Principal: PDI-970 Diligencia - Ingresar a caso - Registrar actividad
- Fecha de corte: 2026-07-28
- Fuente: Jira (https://sonda.atlassian.net/browse/PDI-1071)

## Informacion visible en el ticket

1. La subtarea apunta a capa MS del dominio diligencias.
2. El objetivo inferido por titulo es exponer lectura de actividades asociadas a una diligencia.
3. Los campos visibles de Descripcion y criterios de aceptacion no traen detalle funcional utilizable.

## Implicacion inmediata

Para cerrar implementacion con bajo riesgo se debe confirmar:

1. Campos exactos de actividad a retornar.
2. Orden esperado de actividades (cronologico ascendente o descendente).
3. Reglas de autorizacion (quien puede consultar actividades de una diligencia).
4. Comportamiento para diligencia sin actividades.
5. Contrato final esperado por consumidor (BFF/Front).

## Dependencias observadas

1. Historia padre PDI-970 (Registrar actividad).
2. Integracion esperable con repositorio/tabla de actividades del dominio diligencias.
