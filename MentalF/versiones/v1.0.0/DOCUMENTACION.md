# Documentacion Tecnica

## 1. Objetivo

Centralizar artefactos visuales y de proceso para sip-bd-migrations, con una forma reproducible de regenerar diagramas de base de datos.

## 2. Artefactos incluidos

- mapa-mental-sip-bd-migrations.md
- vista-operacion.md
- vista-desarrollo.md
- vista-revision-pr.md
- flowchart-integral-sip-bd-migrations.md
- bd-relaciones-esquemas.md
- bd-relaciones-tablas-core.md
- generar-diagrama-bd.ps1
- VERSION.md
- CHANGELOG.md
- INSTRUCCIONES-EJECUCION.md

## 3. Fuente de datos para diagramas de BD

- Origen: Proyectos/sip-bd-migrations/compare/source.dacpac
- Extraccion temporal: Projects/MentalF/.tmp_dacpac
- Archivo clave interno: model.xml

## 4. Proceso de regeneracion

1. Asegurar que source.dacpac este actualizado.
2. Ejecutar:
   powershell -NoProfile -ExecutionPolicy Bypass -File c:/Projects/MentalF/versiones/v1.0.0/generar-diagrama-bd.ps1
3. Verificar salida:
   - bd-relaciones-esquemas.md
   - bd-relaciones-tablas-core.md
4. Actualizar VERSION.md y CHANGELOG.md si cambia alcance o contenido.

Opciones de alcance del script:

- `-Scope all`: genera todo (agregado, core, por esquema y por dominio).
- `-Scope schema -Schemas <lista>`: genera archivos para esquemas puntuales.
- `-Scope domain -Domain <nombre>`: genera archivo para un dominio predefinido.

Dominios predefinidos:

- core
- operativo
- identidad
- forense
- analitica

Referencia operativa detallada:

- INSTRUCCIONES-EJECUCION.md

## 5. Convencion de versionado

Se usa SemVer:

- MAJOR: cambios incompatibles en estructura o uso de artefactos.
- MINOR: nuevos diagramas, nuevas vistas o mejoras compatibles.
- PATCH: correcciones menores de contenido, formato o metadata.

Adicionalmente, el almacenamiento se hace por subcarpetas:

- `Projects/MentalF/versiones/vX.Y.Z/`
- Cada version contiene sus propios artefactos y su script de regeneracion.

## 6. Criterios de calidad

- Los diagramas deben compilar en render Mermaid.
- La fuente declarada debe existir y ser trazable.
- Todo cambio de alcance debe reflejarse en CHANGELOG y VERSION.

## 7. Limitaciones conocidas

- El modelo corresponde a un snapshot del DACPAC, no a una base viva.
- El diagrama core puede verse cargado por volumen de relaciones.
- No se infieren cardinalidades semanticas avanzadas; se representan relaciones FK.
