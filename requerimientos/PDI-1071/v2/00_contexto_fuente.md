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
- Fuente principal: Jira (https://sonda.atlassian.net/browse/PDI-1071)
- Fuente complementaria: Jira parent (https://sonda.atlassian.net/browse/PDI-970)

## Hallazgos directos en PDI-1071

1. La descripcion de la subtarea no contiene detalle funcional visible en snapshot.
2. No se observan criterios de aceptacion explicitos en la subtarea.
3. La subtarea se mantiene en estado En curso.

## Hallazgos relevantes en PDI-970 (para contexto funcional)

Historia visible:
- Como Investigador, quiero registrar una actividad investigativa realizada durante una diligencia para documentar actuaciones y resultados.

Reglas visibles:
- RN01: Toda actividad debe registrar un tipo de actividad.
- RN02: El tipo de actividad determina el formulario del cuerpo de la actividad.
- RN03: Una diligencia puede contener multiples actividades investigativas.
- RN04: Las actividades pueden encontrarse en estado Pendiente, Completado o Descartado.

Convencion de cabecera visible para actividad:
- Tipo de actividad
- Fecha inicio
- Hora inicio
- Fecha termino
- Hora termino
- Participantes
- Lugar(es)
- Observacion / Resultado

## Dependencias observadas del flujo asociado

Subtareas relacionadas en parent que impactan la lectura GET:

1. PDI-1517: put actualizar accion.
2. PDI-1518: definicion UIUX de detalle de actividad.
3. PDI-1519: definicion UIUX de detalle de observaciones.
4. PDI-1520: modelado de formularios variables de actividades.
5. PDI-1531: construir endpoints get (combobox/catalogos).

## Implicacion inmediata

Aunque PDI-1071 no trae detalle funcional propio, existe contexto suficiente en el parent para definir un diseno tecnico preliminar robusto del GET, sujeto a validacion final de contrato con PO/analista.
