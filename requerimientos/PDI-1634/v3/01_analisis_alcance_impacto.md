# 01 - Analisis de alcance e impacto

## Alcance de implementacion propuesto

1. Registrar actividad policial por diligencia con reglas de validacion minimas obligatorias.
2. Consultar actividad por id y por diligencia con respuesta consistente.
3. Actualizar actividad con reglas claras para campos modificables.
4. Completar eliminacion logica real para actividad individual y masiva por diligencia.

## Fuera de alcance

1. Cambios de arquitectura global de la solucion.
2. Rediseno de API de otros modulos no relacionados a actividad.
3. Cambios de frontend o BFF fuera de este analisis.

## Supuestos explicitados

1. La epica se resuelve sobre capacidad existente de ActividadInvestigativa.
2. El usuario autenticado es obligatorio para ejecutar create/update/delete.
3. El modelo de datos actual de actividad_investigativa se mantiene.
4. Se pueden ajustar SP existentes sin crear nuevas tablas.

## Impacto por componente

- API: medio-alto
- Application: alto
- Infrastructure/Persistence: medio-alto
- BD migraciones: medio
- QA/contrato OpenAPI: medio

## Riesgos principales

1. Ambiguedad funcional del ticket padre puede generar retrabajo.
2. Validadores actuales incompletos y con mensajes vacios.
3. Endpoints DELETE actualmente no integrados a caso de uso.
4. Potencial desalineacion entre contrato API y firma SP para borrado.

## Dependencias

1. Definicion funcional con PO sobre reglas de negocio finales.
2. Confirmacion de reglas de auditoria para eliminacion logica.
3. Alineacion QA para matriz de casos por subitem.

## Vacios funcionales

1. Reglas por tipo de actividad (judicial/especializada/autonoma).
2. Comportamiento esperado para resultados negativos.
3. Regla exacta para borrado logico individual y masivo.
4. Politica de errores de negocio y codigos esperados.

## Semaforo de riesgo

- Riesgo general: Amarillo

Accion para bajar a Verde:

- Cerrar minuta de refinamiento con reglas completas antes de codificar.
