# 01 - Analisis de alcance e impacto

## Alcance propuesto

1. Registrar una actividad asociada al ingreso de un caso o diligencia para el flujo de Inspeccion S.S.
2. Mantener trazabilidad de usuario, fecha y diligencia asociada.
3. Consultar la actividad generada cuando el flujo lo requiera.
4. Alinear validaciones y errores al contrato del microservicio.

## Fuera de alcance

1. Redisenar el arbol funcional de Jira.
2. Cambiar la arquitectura del microservicio.
3. Implementar frontend o BFF adicional.
4. Alterar otros dominios no relacionados al registro de actividad.

## Supuestos explicitados

1. PDI-1629 reutiliza la capacidad existente de `ActividadInvestigativa`.
2. El ingreso a caso desemboca en un registro de actividad sobre diligencia.
3. El usuario autenticado es obligatorio para ejecutar el flujo.
4. Se conservan stored procedures y tabla existente salvo ajuste funcional puntual.

## Impacto por componente

- API: medio-alto
- Application: alto
- Infrastructure/Persistence: medio-alto
- BD migraciones: medio
- QA/OpenAPI: medio

## Riesgos principales

1. Descripcion Jira incompleta o ambigua.
2. Validaciones actuales insuficientes para un flujo operacional critico.
3. Posible diferencia entre lo que el negocio espera registrar y lo que el microservicio hoy modela.
4. Riesgo de regresion si se toca el flujo compartido con otras actividades.

## Dependencias

1. Aprobacion funcional para cerrar la semantica del paso "ingresar a caso".
2. Confirmacion de campos requeridos para el registro.
3. QA para validar el flujo de punta a punta.
4. BD si se requiere endurecer reglas o auditoria.

## Vacios funcionales

1. Regla exacta de activacion del registro al ingresar al caso.
2. Campos obligatorios vs opcionales.
3. Mensajes de error esperados.
4. Si la operacion debe crear solo una actividad o mas de una por flujo.
5. Politica de eliminacion o reversion si falla el ingreso.

## Semaforo de riesgo

- Riesgo general: Amarillo

Accion recomendada:

- Cerrar definicion funcional con PO/analista y mapearla a los endpoints existentes antes de codificar.
