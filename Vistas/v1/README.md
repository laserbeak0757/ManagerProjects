# Vistas SIP v1

Version inicial del constructor BD -> UI.

## Para que sirve

- Cargar schema JSON de tablas.
- Seleccionar una tabla.
- Mapear campos a controles de formulario.
- Ver preview en vivo.
- Exportar definicion de pantalla en JSON.

## Archivos principales

- index.html
- app.js
- styles.css
- data/schema.from.sip-bd-migrations.json
- scripts/extract-schema-from-sip-migrations.ps1

## Uso rapido

1. Generar schema real desde sip-bd-migrations:

```powershell
cd c:\Projects\Vistas\v1\scripts
.\extract-schema-from-sip-migrations.ps1
```

1. Abrir la interfaz:

- Opcion simple: abrir index.html en navegador.
- Opcion recomendada:

```powershell
cd c:\Projects\Vistas\v1
python -m http.server 8081
```

Abrir: <http://localhost:8081>

1. Flujo de trabajo

- Importa schema JSON.
- Elige tabla.
- Ajusta mapeo de campos.
- Revisa preview.
- Exporta JSON de pantalla.

## Formato de salida

```json
{
  "screenName": "Persona - Registro Base",
  "table": "personas.persona",
  "elements": [
    { "id": "nombres", "label": "Nombres", "control": "text", "bind": "nombres", "required": true }
  ]
}
```

## Cuándo usar v1

- Formularios simples de una sola tabla.
- Prototipos rapidos.
- Casos sin detalle hijo o grillas relacionadas.
