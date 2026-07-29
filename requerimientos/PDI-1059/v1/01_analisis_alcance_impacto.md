# PDI-1059 - Analisis de alcance e impacto

## Alcance propuesto (subtarea BD)

1. Definir consulta para obtener instrucciones de diligencia por identificador.
2. Validar tabla(s) origen, joins y campos requeridos.
3. Asegurar performance basica de la consulta (indices si aplica).
4. Entregar contrato tecnico de salida para la capa consumidora.

## Fuera de alcance

1. Cambios de UX o comportamiento Front.
2. Cambios de orquestacion BFF no ligados a este query.
3. Re-diseno integral del dominio diligencias.

## Impacto por componente

1. BD
- Posible creacion o ajuste de indice para lectura por diligenciaId.
- Validacion de consistencia de datos y nulos.

2. MS Diligencias
- Incorporacion/ajuste de repositorio o query handler de lectura.
- Mapeo de datos de instrucciones a DTO de salida.

3. BFF
- Solo impacto si cambia shape del contrato esperado.

4. QA
- Validacion de exactitud del contenido de instrucciones.
- Pruebas de caso no encontrado.

## Riesgos

1. Falta de definicion funcional de "instrucciones" (alto).
2. Ambiguedad de fuente de datos (medio-alto).
3. Posible deuda de indices para consultas repetitivas (medio).

## Mitigaciones

1. Cerrar diccionario de campos minimo antes de codificar.
2. Probar query sobre dataset representativo.
3. Documentar contrato de salida con ejemplo.

## Preguntas abiertas

1. Que campos componen exactamente las instrucciones?
2. Debe retornar historico o solo valor vigente?
3. Debe filtrar por estado de diligencia?
4. Cual es el consumidor principal inmediato (MS/BFF/otro)?

## Semaforo de riesgo

- Riesgo General: Amarillo

Criterios evaluados:

1. Claridad funcional: Rojo (descripcion no visible).
2. Dependencias externas: Amarillo (depende de definicion PDI-969).
3. Complejidad tecnica: Verde-Amarillo (query acotado, sujeto a schema real).
4. Impacto seguridad/datos: Amarillo (validar acceso por caso/diligencia).
5. Incertidumbre reglas de negocio: Amarillo.

Acciones recomendadas:

1. Mini session de refinamiento tecnico-funcional (15-30 min).
2. Congelar campos de salida antes de desarrollo.
3. Agregar casos negativos de no encontrado/permisos.
