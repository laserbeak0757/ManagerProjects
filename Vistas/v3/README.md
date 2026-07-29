# Vistas SIP v3 - Node Edition

Version 3 ejecutable con Node, sin dependencias externas, para construir pantallas BD/UI con presets por dominio y maestro-detalle.

## Que incluye

- Servidor local Node.
- API interna para schema y presets.
- UI de pantallas con secciones form y grid.
- Relacion padre-hijo para detalles.
- Validacion de tipos SQL al simular guardado.
- Presets por dominio para arrancar mas rapido.

## Estructura

- `server.js`: servidor Node que publica la app y los JSON.
- `public/`: interfaz web.
- `data/`: schema y presets versionados.
- `scripts/`: extractor de schema desde `sip-bd-migrations`.

## Como correrlo

```powershell
cd c:\Projects\Vistas\v3
node server.js
```

Luego abrir:

- <http://localhost:3003>

## Flujo recomendado

1. Ejecutar el extractor para refrescar schema real si cambian migraciones.
2. Abrir la app Node.
3. Elegir preset de dominio o cargar schema/pantalla JSON.
4. Ajustar secciones, campos y relacion padre-hijo.
5. Revisar preview y validaciones.
6. Exportar pantalla JSON y versionarla.

## Schema esperado

El servidor expone `/api/schema` y espera el archivo:

- `data/schema.from.sip-bd-migrations.json`

## Presets incluidos

- Denuncias - Registro con detalle
- Diligencias - Bandeja Investigador

## Versionado

- v1: formulario simple.
- v2: maestro-detalle con validaciones.
- v3: Node Edition con presets por dominio.
