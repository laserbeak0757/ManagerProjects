# PDI-967 - Analisis de alcance e impacto

## Alcance funcional

1. Exponer bandeja de diligencias para rol Investigador con filtro por asignacion.
2. Mostrar por fila: tipo, origen, fecha de recepcion, fecha limite y estado.
3. Habilitar accion Gestionar segun estado permitido.
4. Soportar filtros por estado, fecha, tipo, funcionario y unidad.
5. Soportar paginacion server-side.

## Fuera de alcance

1. Reglas de otros roles no descritos en el ticket.
2. Re-diseno integral del ciclo de estados de diligencia.
3. Integraciones nuevas fuera del dominio actual (ticket indica N/A).

## Impacto por componente

1. Front (sip-web-portal)
- Construccion/ajuste de vista bandeja.
- Integracion con endpoint de consulta y filtros.
- Estados de carga, vacio y error.
- Habilitacion/deshabilitacion de acciones segun estado.

2. BFF (nexo-bff-diligencias)
- Mapeo y orquestacion de endpoint de bandeja.
- Mapeo de endpoint de filtros.
- Normalizacion de errores y contrato de salida para UI.

3. MS (sip-ms-diligencias)
- Consulta de diligencias por funcionario.
- Aplicacion de filtros y paginacion.
- Regla RN03 de fecha limite por decreto.
- Regla RN04/RN05 para acciones permitidas.

4. DB
- Validar disponibilidad de campos de filtro (estado, tipo, unidad, funcionario, fechas).
- Revisar indices de soporte para consulta paginada.
- Riesgo de performance si faltan indices compuestos por funcionario + estado + fecha.

5. QA
- Cobertura de criterios de aceptacion y reglas RN01-RN05.
- Pruebas de autorizacion por rol.
- Validacion e2e Front-BFF-MS.

## Riesgos principales

1. Ambiguedad en RN03: dias habiles vs corridos, zona horaria, hora de corte.
2. Dependencias funcionales abiertas (PDI-890 y PDI-969).
3. Posible desalineacion de contrato entre MS/BFF/Front.
4. Alto volumen de subtareas en diferente madurez.

## Mitigaciones

1. Definir especificacion tecnica de fecha limite antes de cierre tecnico.
2. Publicar matriz oficial estado -> acciones por rol.
3. Versionar OpenAPI y validar mapeo BFF con pruebas de contrato.
4. Ejecutar smoke e2e previo a QA formal.

## Preguntas abiertas

1. El calculo de fecha limite aplica dias habiles o corridos?
2. El origen OFAN/unidad viene normalizado o requiere transformacion?
3. El filtro por funcionario debe ser visible para Investigador o solo para perfiles de jefatura?
4. La accion Gestionar requiere trazabilidad de auditoria obligatoria?

## Decisiones pendientes

1. Congelar catalogo de estados permitidos para accion Gestionar.
2. Confirmar comportamiento exacto de paginacion (tamanos permitidos y orden por defecto).
3. Confirmar SLA objetivo de tiempo de respuesta para bandeja.

## Semaforo de riesgo

- Riesgo General: Amarillo

Criterios evaluados:

1. Claridad funcional: Amarillo
- Existen reglas claras, pero RN03 tiene ambiguedad tecnica.

2. Dependencias externas: Rojo
- Hay bloqueos declarados en PDI-890/PDI-969 que pueden frenar cierre e2e.

3. Complejidad tecnica: Amarillo
- Flujo es conocido, pero requiere coordinacion de tres capas y reglas de estado.

4. Impacto en seguridad/datos: Amarillo
- Alto riesgo si no se fuerza filtro por identity en backend.

5. Incertidumbre de reglas de negocio: Amarillo
- Matriz final de acciones por estado aun requiere cierre.

Acciones recomendadas por riesgo Amarillo/Rojo:

1. Generar decision log con PO/QA para RN03 y estados permitidos.
2. Coordinar plan de desbloqueo de dependencias con responsables de PDI-890/PDI-969.
3. Agregar prueba automatizada de no-fuga de datos entre investigadores.
