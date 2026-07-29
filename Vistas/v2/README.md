# Vistas SIP v2

Version avanzada con modo maestro-detalle y validacion por tipo SQL.

## Para que sirve

- Diseñar pantallas con multiples secciones.
- Soportar secciones tipo:
  - form (cabecera)
  - grid (detalle)
- Configurar relacion padre-hijo entre secciones.
- Validar payload en base a tipo de datos SQL.
- Exportar definicion de pantalla v2 en JSON.

## Archivos principales

- index.html
- app.js
- styles.css
- data/schema.from.sip-bd-migrations.json
- scripts/extract-schema-from-sip-migrations.ps1

## Uso rapido

1. Generar/actualizar schema real desde sip-bd-migrations:

```powershell
cd c:\Projects\Vistas\v2\scripts
.\extract-schema-from-sip-migrations.ps1
```

1. Abrir la interfaz:

```powershell
cd c:\Projects\Vistas\v2
python -m http.server 8082
```

Abrir: <http://localhost:8082>

1. Flujo recomendado

- Importa schema JSON.
- Define nombre de pantalla.
- Agrega secciones (cabecera y detalle).
- Para detalle, define relacion:
  - seccionPadre
  - campoPadre
  - campoHijo
- Marca campos incluidos, control UI y requeridos.
- Completa datos de prueba en preview.
- Revisa errores de validacion.
- Exporta JSON de pantalla.

## Validaciones incluidas

- Requeridos vacios.
- Tipo numerico invalido para columnas int/decimal/numeric/float.
- Tipo fecha invalido para date/datetime.
- Conversión de checkbox a boolean.

## Estructura JSON v2 (resumen)

```json
{
  "screenName": "Registro Denuncia",
  "sections": [
    {
      "id": "s1",
      "name": "Cabecera",
      "table": "denuncias.denuncia",
      "mode": "form",
      "fields": []
    },
    {
      "id": "s2",
      "name": "Detalle",
      "table": "denuncias.denuncia_persona_rol",
      "mode": "grid",
      "relation": {
        "parentSectionId": "s1",
        "parentField": "id_denuncia",
        "childField": "id_denuncia"
      },
      "fields": []
    }
  ]
}
```

## Cuándo usar v2

- Pantallas con cabecera + grilla detalle.
- Escenarios donde diseño y BD deben validar estructura de payload antes de desarrollo.
- Casos con mayor exigencia de consistencia de tipos.
