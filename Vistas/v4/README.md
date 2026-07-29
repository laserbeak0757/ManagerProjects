# Vistas SIP v4 - Command Center

Version 4 ejecutable con Node y una interfaz local mas profesional, dinamica y orientada a exploracion rapida de schema, presets y maestro-detalle.

## Que incluye

- Servidor local Node sin dependencias externas.
- API interna para schema, presets y estado de la app.
- Interfaz tipo command center con catalogo, compositor y preview vivo.
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
cd c:\Projects\Vistas\v4
node server.js
```

Luego abrir:

- <http://localhost:3004>

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

Si aun no existe en v4, el servidor reutiliza el schema versionado disponible en `v3` para arrancar sin friccion.

## Presets incluidos

- Denuncias - Registro con detalle
- Diligencias - Bandeja Investigador

## Versionado

- v1: formulario simple.
- v2: maestro-detalle con validaciones.
- v3: Node Edition con presets por dominio.
- v4: Command Center local con UI dinamica y snapshots.
