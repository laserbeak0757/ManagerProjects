# PDI-1071 - Analisis de alcance e impacto

## Alcance funcional propuesto

1. Exponer en MS un endpoint GET para listar actividades asociadas a una diligencia.
2. Validar que la diligencia exista y que el solicitante tenga permiso de consulta.
3. Retornar actividades con forma de datos consistente para consumo aguas arriba.
4. Manejar escenarios sin actividades sin error tecnico.

## Fuera de alcance

1. Creacion/edicion/eliminacion de actividades.
2. Cambios UI de visualizacion de actividades.
3. Orquestacion BFF fuera del contrato de lectura.
4. Re-diseno del modelo de datos de diligencias.

## Impacto por componente

1. MS (sip-ms-diligencias)
- Nuevo endpoint o ajuste de endpoint existente de consulta.
- Query de lectura por diligenciaId.
- Validaciones de existencia/autorizacion.
- Mapeo a DTO y codigos de respuesta estandar.

2. DB
- Validar tablas y relaciones actividad <-> diligencia.
- Revisar indice por diligenciaId y fecha para lectura ordenada.
- Verificar consistencia de datos historicos (nulos, duplicados).

3. BFF (si aplica)
- Ajuste de cliente downstream hacia MS.
- Mapeo de contrato para Front.

4. Front (si aplica)
- Consumo de lista de actividades y manejo de estados vacio/error.

5. QA
- Casos funcionales de consulta por diligencia.
- Casos de autorizacion y no encontrado.

## Riesgos principales

1. Falta de definicion funcional detallada en ticket (alto).
2. Ambiguedad de contrato de salida (medio-alto).
3. Posible deuda de performance sin indice adecuado (medio).
4. Riesgo de exposicion de datos si no se valida acceso por contexto (alto).

## Mitigaciones

1. Cerrar mini refinamiento tecnico-funcional antes de desarrollo final.
2. Congelar contrato OpenAPI previo a integraciones.
3. Agregar pruebas automatizadas de autorizacion y no-fuga de datos.
4. Validar plan de indices en entorno local/QA.

## Preguntas abiertas

1. Que campos minimos debe incluir cada actividad?
2. Se requiere paginacion o lista completa?
3. El orden por defecto es fechaActividad desc?
4. Que perfiles pueden consultar actividades de cualquier diligencia?
5. Se requiere auditoria de consulta?

## Semaforo de riesgo

- Riesgo general: Amarillo

Criterios:

1. Claridad funcional: Rojo.
2. Dependencias externas: Amarillo.
3. Complejidad tecnica: Verde-Amarillo.
4. Seguridad/datos: Amarillo.
5. Incertidumbre de negocio: Amarillo.
