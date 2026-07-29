# Vistas SIP - Versionado de prototipos BD/UI

Herramienta local para alinear diseno y base de datos dentro de Projects/Vistas.

## Estructura por version

- v1: formulario de una tabla (rapido y simple).
- v2: soporte maestro-detalle con validaciones por tipo SQL.
- v3: edition Node con presets por dominio.
- v4: command center local con UI dinamica y snapshots.
- v4.1: command center con selector de temas en vivo (azul-verde y verde-turquesa).

## Readme de cada version

- Ver v1: `Projects/Vistas/v1/README.md`
- Ver v2: `Projects/Vistas/v2/README.md`
- Ver v3: `Projects/Vistas/v3/README.md`
- Ver v4: `Projects/Vistas/v4/README.md`
- Ver v4.1: `Projects/Vistas/v4.1/README.md`

## Integracion con sip-bd-migrations

Ambas versiones incluyen script para extraer schema desde:

- `Projects/Proyectos/sip-bd-migrations/migrations/versioned`

Comando:

```powershell
.\extract-schema-from-sip-migrations.ps1
```

Salida:

- `data/schema.from.sip-bd-migrations.json`

## Recomendacion de uso

1. Usa v1 para formularios simples de una sola tabla.
2. Usa v2 para pantallas con cabecera + detalle y revisiones de payload.
3. Usa v3 cuando quieras Node, presets y un flujo de arranque mas automatico.
4. Usa v4 cuando quieras una experiencia mas ejecutiva, dinamica y orientada al trabajo local diario.
5. Usa v4.1 cuando necesites personalizacion visual por tema con persistencia local.
6. Versiona siempre el JSON exportado de pantalla junto al schema usado.
