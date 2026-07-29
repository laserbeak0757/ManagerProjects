# Execution Instructions

Directorio de trabajo para artefactos de mapa mental del repositorio sip-bd-migrations.

## Estructura de versionado

- Se versiona por subcarpetas dentro de `versiones/`.
- Cada entrega nueva se guarda en una carpeta propia: `vX.Y.Z`.
- La carpeta raiz actua como indice y no guarda artefactos finales.

## Contenido

- `versiones/v1.0.0/`: primera entrega completa.
- `.tmp_dacpac/`: extraccion temporal del DACPAC (soporte de generacion).
- `versiones/v1.0.0/INSTRUCCIONES-EJECUCION.md`: guia operativa paso a paso.

## Objetivo

Centralizar una vista estructurada de:

- Arquitectura tecnica del repositorio.
- Flujo de trabajo de migraciones.
- Criterios de calidad y revision.
- Riesgos y controles operativos.

## Versionado

- Version actual: `v1.0.0`
- Convencion: SemVer (MAJOR.MINOR.PATCH)
- Regla: todo artefacto nuevo debe quedar bajo una nueva carpeta `versiones/vX.Y.Z`.

## Mantenimiento

Ruta estatica de ejecucion (wrapper):

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope all

Generar solo esquema diligencias:

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope schema -Schemas diligencias

Generar todas:

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope all

Guia detallada de ejecucion:

c:/Projects/MentalF/versiones/v1.0.0/INSTRUCCIONES-EJECUCION.md
