# Vistas SIP v4.1 - Command Center

Version 4.1 ejecutable con Node y una interfaz local profesional, dinamica y orientada a exploracion rapida de schema, presets y maestro-detalle.

## Que incluye

- Servidor local Node sin dependencias externas.
- API interna para schema, presets y estado de la app.
- Interfaz tipo command center con catalogo, compositor y preview vivo.
- Selector de tema en vivo (Azul-Verde Ejecutivo y Verde-Turquesa Claro).
- Templates de color inspirados en ColorsWall (referencia 8xbet).
- Busqueda dinamica por tabla o campo.
- Creacion rapida de pantallas desde la tabla activa.
- Soporte de maestro-detalle con relacion padre-hijo.
- Snapshots locales para guardar y recuperar pantallas.
- Exportacion del JSON de pantalla para versionarlo.

## Estructura

- `server.js`: servidor Node que publica la app y los JSON.
- `public/`: interfaz web.
- `data/`: presets y schema versionado.
- `scripts/`: extractor de schema desde `sip-bd-migrations`.

## Como correrlo

```powershell
cd c:\Projects\Vistas\v4.1
node server.js
```

Luego abrir:

- <http://localhost:3005>

## Flujo recomendado

1. Cargar la pantalla inicial con un preset o con una tabla activa.
2. Buscar una tabla o campo y fijar la tabla de trabajo.
3. Agregar secciones tipo formulario o detalle.
4. Revisar el preview vivo y la validacion del payload.
5. Guardar snapshots cuando quieras conservar una variante.
6. Exportar el JSON final de pantalla.

## Schema esperado

La app expone `/api/schema` y prioriza este archivo:

- `data/schema.from.sip-bd-migrations.json`

Si aun no existe en v4.1, el servidor reutiliza el schema versionado disponible en `v3` para arrancar sin friccion.

## Presets incluidos

- Denuncias - Registro con detalle
- Diligencias - Bandeja Investigador

## Temas visuales (templates)

La v4.1 incluye temas conmutables desde la cabecera y persistencia local.

- Azul-Verde Ejecutivo: foco corporativo frio para uso continuo.
- Verde-Turquesa Claro: variante suave con alto contraste funcional.
- 8xbet Clasico (claro): inspirado en la paleta `#ffffff #50a0dc #28508c #f0f0f0`.
- 8xbet Slate (profundo): derivado del mismo set con soporte `#64a0dc` y `#3c508c`.

Referencia usada como plantilla:

- [8xbet en ColorsWall](https://colorswall.com/es/palette/575702)

## Versionado

- v1: formulario simple.
- v2: maestro-detalle con validaciones.
- v3: Node Edition con presets por dominio.
- v4: Command Center local con UI dinamica y snapshots.
- v4.1: Command Center local con temas visuales conmutables y persistentes.
