# Instrucciones de Ejecucion

Esta guia explica como regenerar los artefactos visuales de la version v1.0.0,
incluyendo generacion por esquemas y por dominios.

## 1) Prerrequisitos

- Windows con PowerShell 5.1 o superior.
- Existencia del archivo fuente:
  - c:/Projects/Proyectos/sip-bd-migrations/compare/source.dacpac

## 2) Comandos de ejecucion

### 2.1 Generacion completa (modo all)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope all

### 2.2 Generacion por esquema

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope schema -Schemas denuncias,personas

Ejemplo puntual solicitado (diligencias):

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope schema -Schemas diligencias

### 2.3 Generacion por dominio

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/MentalF/generar-diagrama-bd.ps1" -Scope domain -Domain operativo

## 3) Resultado esperado

Al finalizar en modo all, se actualizan:

- c:/Projects/MentalF/versiones/v1.0.0/bd-relaciones-esquemas.md
- c:/Projects/MentalF/versiones/v1.0.0/bd-relaciones-tablas-core.md

Ademas se generan salidas versionadas:

- c:/Projects/MentalF/versiones/v1.0.0/salida/esquemas/*.md
- c:/Projects/MentalF/versiones/v1.0.0/salida/dominios/*.md
- c:/Projects/MentalF/versiones/v1.0.0/salida/dominios/README.md

Salida esperada en consola (resumen, modo all):

- Generados: mapa agregado, core, carpeta salida/esquemas y carpeta salida/dominios
- Tablas totales: 230
- FK totales: 399
- Tablas core: 179
- FK core: 306

Salida esperada en consola (ejemplos):

- Modo schema:
  - Generado esquema denuncias: ...
  - Generado esquema personas: ...
- Modo domain:
  - Generado dominio operativo: ...

## 4) Verificacion rapida

1. Abrir ambos .md y confirmar que contienen bloque Mermaid.
2. Confirmar metadata en encabezado:
   - Version artefacto
   - Generado
   - Fuente
3. Si se uso modo schema o domain, validar los archivos bajo `salida/`.

## 5) Solucion de problemas

- Error: No se encontro el DACPAC
  - Verificar que exista:
    - c:/Projects/Proyectos/sip-bd-migrations/compare/source.dacpac

- Mermaid no renderiza
  - Revisar que no se haya alterado la sintaxis del bloque:
    - ```mermaid
    - flowchart LR

- Datos desactualizados
  - Regenerar source.dacpac y volver a ejecutar el script.

- Error: Esquema no encontrado en el modelo
  - Revisar nombre exacto del esquema en el modelo.
  - Ejecutar modo all para generar `bd-relaciones-esquemas.md` y ver lista de esquemas.

- Error: Dominio no valido
  - Dominios disponibles:
    - core
    - operativo
    - identidad
    - forense
    - analitica

## 6) Flujo para nueva version

1. Crear nueva carpeta de version, por ejemplo:
   - c:/Projects/MentalF/versiones/v1.0.1
2. Copiar artefactos base desde v1.0.0.
3. Ajustar VERSION.md, CHANGELOG.md y DOCUMENTACION.md.
4. Ejecutar el script de la nueva version.
5. Validar resultado y actualizar README de indice.
