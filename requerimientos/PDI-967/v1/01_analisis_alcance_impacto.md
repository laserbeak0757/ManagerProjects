# PDI-967 - Analisis de alcance e impacto

## Alcance funcional

1. Exponer una bandeja de diligencias para rol Investigador filtrada por asignacion.
2. Mostrar informacion minima por fila: tipo, origen, fecha de recepcion, fecha limite, estado.
3. Habilitar accion Gestionar segun estado de diligencia y rol.
4. Respetar reglas de calculo de fecha limite por decreto.
5. Soportar filtros operativos de bandeja (estado, fecha, tipo, funcionario, unidad) y paginacion.

## Fuera de alcance sugerido

1. Cambios de modelo de seguridad transversal que impacten otros roles no mencionados.
2. Re-diseno del flujo de negocio de diligencias fuera de estados ya convenidos.
3. Integraciones nuevas no declaradas (ticket marca N/A).

## Componentes impactados

1. Front (sip-web-portal):
- Vista de bandeja.
- Filtros.
- Estados de carga, vacio y error.
- Navegacion a Gestionar diligencia.

2. BFF (nexo-bff-diligencias):
- Endpoint de bandeja (mapeo/contrato con front).
- Endpoint de filtros disponibles.
- Transformacion de respuesta para UI.

3. MS Diligencias (sip-ms-diligencias o equivalente):
- Consulta de bandeja por funcionario.
- Consulta de catalogos/filtros (estados, funcionarios, unidad, tipo).
- Paginacion y ordenamiento.

## Impacto tecnico

- Seguridad/autorizacion:
  - Validar que el backend derive identity del token y no desde payload libre.
  - Evitar fuga de datos entre investigadores.

- Datos y performance:
  - Necesidad de indices por funcionario, estado y fecha.
  - Riesgo de latencia si filtros se ejecutan sin paginacion server-side.

- Contrato API:
  - Riesgo de desalineacion de nombres de campos entre MS/BFF/Front.
  - OpenAPI debe reflejar shape final de filtros y pagina.

- UX/negocio:
  - Reglas de habilitacion de Gestionar por estado deben ser deterministicas.
  - Fecha limite debe ser consistente con decreto para evitar errores operativos.

## Riesgos

1. Regla RN03 sin definicion tecnica exacta de calendario (habiles/corridos, zona horaria, hora corte).
2. Inconsistencia de estado en front si no se normaliza catalogo de estados.
3. Dependencia funcional bloqueada por PDI-890/PDI-969.
4. Story grande (51 pts) con multiples subtareas en distinto estado.

## Mitigaciones propuestas

1. Definir contrato de fecha limite por escrito antes de codificar.
2. Publicar tabla de transicion estado -> acciones permitidas.
3. Validar integracion end-to-end MS -> BFF -> Front en ambiente local y QA.
4. Mantener matriz de trazabilidad requisito -> endpoint -> prueba.

## Impacto QA

1. Casos positivos:
- Investigador con diligencias.
- Investigador sin diligencias.
- Gestionar habilitado para estados permitidos.

2. Casos negativos:
- Usuario sin rol.
- Intento de gestionar estado no permitido.
- Filtros sin resultados.

3. No funcionales:
- Paginacion estable.
- Tiempo de respuesta aceptable en consultas filtradas.
