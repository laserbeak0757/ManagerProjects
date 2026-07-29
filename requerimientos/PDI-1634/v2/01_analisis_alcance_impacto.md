# 01 - Analisis de alcance e impacto

## Alcance funcional propuesto (v2)

1. Cubrir el flujo de registro de actividad policial asociado a diligencias usando la capacidad existente de `ActividadInvestigativa`.
2. Asegurar consistencia de reglas de negocio minimas para alta/consulta/actualizacion.
3. Mantener trazabilidad de auditoria y usuario sobre cada actividad registrada.
4. Ajustar contrato API solo cuando exista regla funcional validada que lo requiera.

## Fuera de alcance

1. Reestructuracion arquitectonica del microservicio.
2. Cambios en modulos no relacionados a actividades investigativas.
3. Automatizaciones Jira o cambios de governance fuera del flujo tecnico.
4. Implementacion de UX frontend (este alcance es backend/ms + contrato).

## Impacto esperado por componente

### MS (sip-ms-diligencias)

- Alto impacto funcional en:
  - `Api/Controllers/ActividadInvestigativaController.cs`
  - `Application/Features/Actividad/*`
  - `Infrastructure/Persistence/Actividad/*`

### DB (sip-bd-migrations)

- Impacto potencial medio:
  - Ajustes de SP existentes o validaciones de integridad.
  - No se detecta necesidad obligatoria de nueva tabla en esta etapa.

### QA/OpenAPI

- Impacto medio:
  - Actualizacion de casos de validacion de actividad.
  - Alineacion OpenAPI + coleccion de pruebas.

### Dependencias interequipos

- Negocio/PO para cerrar reglas faltantes.
- QA para matriz de casos y no regresion.
- Equipo de BD solo si emergen cambios de SP/constraints.

## Supuestos explicitados (v2)

1. PDI-1634 se implementa reutilizando modulo `ActividadInvestigativa` actual.
2. El registro de actividad policial corresponde a una actividad por diligencia.
3. `idUsuario` y contexto autenticado son obligatorios en ejecucion real.
4. Se mantiene estrategia de persistencia por stored procedures en esquema `diligencias`.
5. No hay dependencia obligatoria de otro microservicio para crear actividad, salvo validaciones transversales de identidad/autorizacion.

## Vacios funcionales a cerrar antes de codificar

1. Reglas exactas de obligatoriedad por tipo de actividad (judicial/especializada/autonoma).
2. Reglas para resultado negativo y sus efectos de negocio (solo registro vs acciones adicionales).
3. Comportamiento esperado para eliminacion logica de actividad individual y masiva.
4. Mensajes/codigos de error funcional esperados por negocio.
5. Reglas de autorizacion por perfil o rol operativo.

## Riesgo general

- Semaforo: Amarillo

### Criterios evaluados

1. Claridad funcional: Baja (descripcion Jira incompleta).
2. Dependencias externas: Media (SP y data model existentes, pero con reglas de negocio por cerrar).
3. Complejidad tecnica: Media (flujo existe, requiere endurecer validaciones y borrado).
4. Impacto en datos: Medio (auditoria y consistencia de actividad investigativa).
5. Incertidumbre de reglas: Alta.

### Acciones recomendadas para bajar riesgo

1. Refinamiento funcional corto (30-45 min) con PO/analista + referente tecnico.
2. Definir contrato esperado por caso (create/get/update/delete) con ejemplos de payload.
3. Acordar politica de errores y validaciones de campos obligatorios.
4. Validar cobertura de pruebas antes de merge.
