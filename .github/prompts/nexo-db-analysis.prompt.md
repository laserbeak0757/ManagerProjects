---
description: "Analiza el esquema real de una base de datos y genera un SQL ordenado a partir de un conjunto de tablas o cambios."
---

# Prompt: NEXO DB Analysis

Objetivo:

Analizar el esquema real de una base de datos y devolver una propuesta SQL segura, ordenada y aplicable a partir de un conjunto de tablas o cambios solicitados.

Input minimo esperado:

- `repo`: repositorio o contexto objetivo.
- `db`: base de datos o stack de migraciones a revisar.
- `objects`: tablas o vistas a analizar.
- `mode`: `analysis`, `sql`, `dependencies` o `all`.

Uso sugerido:

```text
repo: Proyectos/sip-bd-migrations
db: sip_dev
objects: dbo.Persona, dbo.Caso, dbo.Diligencia
mode: all
```

Instrucciones de ejecucion:

1. Leer el README y las instrucciones del repositorio antes de proponer cambios.
2. Revisar el esquema real de la base de datos y no asumir columnas, llaves o relaciones.
3. Identificar primary keys, foreign keys, unique constraints, defaults, nullability e indices.
4. Construir el orden correcto de creacion, alteracion o carga segun dependencias.
5. Generar la consulta o script SQL final listo para aplicar.
6. Si falta contexto critico, pedir solo lo minimo necesario para continuar.
7. Mantener la salida centrada en los objetos pedidos y sus dependencias directas.

Entregables esperados:

- Resumen del esquema relevante.
- Relacion entre tablas y dependencias.
- Orden recomendado de aplicacion.
- SQL final propuesto.
- Observaciones de riesgo o validacion pendiente.

Formato de salida preferido:

- Primero el resumen corto.
- Luego la lista de dependencias.
- Luego el SQL propuesto.
- Luego los riesgos o supuestos.

Reglas:

- Trabajar siempre desde el esquema real.
- No inventar llaves, indices ni constraints.
- Mantener la salida enfocada en las tablas solicitadas.
- Pedir solo la informacion minima faltante si no es posible avanzar.
- Priorizar exactitud sobre amplitud.
- Evitar relleno; si algo no se puede validar, declararlo explicitamente.