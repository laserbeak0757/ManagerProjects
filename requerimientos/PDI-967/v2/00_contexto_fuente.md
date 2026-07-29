# PDI-967 - Contexto fuente

## Metadatos

- ID: PDI-967
- Titulo: Diligencia - Bandeja Diligencias rol Investigador
- Tipo: Historia de usuario
- Estado observado: Backlog
- Story Points: 51
- Fecha de corte: 2026-07-28
- Fuente: Jira (https://sonda.atlassian.net/browse/PDI-967)

## Historia de usuario

Como Investigador
Quiero visualizar y gestionar las diligencias asignadas
Para ejecutar oportunamente las actividades encomendadas dentro de los plazos establecidos.

## Reglas de negocio identificadas

- RN01: El investigador solo visualiza las diligencias asignadas a el.
- RN02: Las diligencias deben visualizar su estado actual.
- RN03: La fecha limite se calcula segun el decreto asociado (2, 10 o 20 dias).
- RN04: Solo las diligencias en estado En Desarrollo y Observadas pueden ser editadas por el investigador.
- RN05: Las acciones disponibles dependen del estado de la diligencia.

## Criterios de aceptacion identificados

- Visualiza las diligencias asignadas.
- Muestra el tipo de diligencia.
- Muestra el origen.
- Muestra la fecha de recepcion.
- Muestra la fecha limite.
- Muestra el estado.
- Permite gestionar una diligencia cuando corresponde.

## Dependencias relevantes

- Dependencia declarada: Denuncia - Endoso de Primera Diligencia.
- Vinculada: PDI-969 (Diligencia - Ingresar a caso - Revisar antecedentes).
- Bloqueador declarado: PDI-890 (Diligencia - Endoso de Diligencia).

## Observaciones

- El ticket incluye nota de pendiente de actualizacion de pantallas en escenarios.
- Existen subtareas de MS, BFF y Front en distintos estados (Backlog/En curso/Finalizada).
