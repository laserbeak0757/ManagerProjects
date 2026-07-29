# PDI-1071 - Analisis de alcance e impacto

## Alcance funcional v2

1. Exponer en MS un GET de actividades asociadas a una diligencia.
2. Retornar una lista consistente con los estados de actividad definidos: Pendiente, Completado, Descartado.
3. Incluir datos minimos de cabecera de actividad para trazabilidad operativa.
4. Garantizar control de acceso para evitar consulta de diligencias fuera de alcance.

## Fuera de alcance

1. Registro/edicion de actividad (pertenece a flujos POST/PUT).
2. Diseno UIUX del detalle (subtareas de parent).
3. Definicion final de formularios variables por tipo de actividad (PDI-1520).
4. Catalogos auxiliares no disponibles en MS (si no estan cerrados en PDI-1531).

## Impacto por componente

1. MS (sip-ms-diligencias)
- Endpoint GET por diligenciaId.
- Query de lectura y orden de actividades.
- Mapeo DTO de salida con estados normalizados.
- Validaciones de autorizacion y respuesta sin fuga de datos.

2. DB
- Verificacion de entidades actividad y relacion con diligencia.
- Indices por diligenciaId y fechaActividad.
- Validacion de integridad de estados.

3. BFF
- Alineacion de contrato de lista de actividades.
- Normalizacion de errores 400/403/404/500.

4. Front
- Consumo de lista de actividades.
- Manejo de listas vacias y render de estado.

5. QA
- Casos por estado Pendiente/Completado/Descartado.
- Casos de autorizacion y no encontrado.
- Casos de consistencia de orden.

## Riesgos principales

1. Contrato incompleto por ausencia de descripcion en subtarea (alto).
2. Variabilidad de estructura por tipo de actividad (medio-alto).
3. Dependencia de catalogos/get auxiliares aun en backlog (medio).
4. Riesgo de sobreexposicion de datos si no se asegura filtro de contexto (alto).

## Mitigaciones

1. Basar contrato minimo en cabecera comun del parent y definir extension opcional.
2. Separar metadatos comunes de payload especifico por tipo.
3. Versionar OpenAPI y acordar response examples con consumidor.
4. Prueba obligatoria de aislamiento de datos por perfil.

## Semaforo de riesgo

- Riesgo general: Amarillo

Criterios:

1. Claridad funcional: Amarillo.
2. Dependencias externas: Amarillo.
3. Complejidad tecnica: Verde-Amarillo.
4. Seguridad/datos: Amarillo.
5. Incertidumbre de negocio: Amarillo.

## Preguntas abiertas

1. GET debe incluir solo cabecera o tambien cuerpo variable por tipo?
2. Se requiere paginacion obligatoria o lista completa?
3. Orden por defecto: fechaInicio desc?
4. Se debe incluir historial de cambios de estado por actividad?
