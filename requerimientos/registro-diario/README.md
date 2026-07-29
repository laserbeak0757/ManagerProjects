# Herramienta de registro diario

Esta carpeta contiene una herramienta simple para llevar registro diario con formato de cuadricula calendario y detalle por dia.

## Objetivo

- Tener un resumen visual rapido del mes.
- Documentar avances, bloqueos y siguiente paso por cada dia habil.
- Facilitar la preparacion de dailys y cierres semanales.

## Contenido

- TEMPLATE_REGISTRO_MENSUAL.md
- scripts/generar-registro-mensual.ps1

## Uso rapido

1. Abrir PowerShell en la raiz del workspace.
2. Ejecutar:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/requerimientos/registro-diario/scripts/generar-registro-mensual.ps1"
```

3. Se crea un archivo en requerimientos/registro-diario/registros con nombre:

- REGISTRO-YYYY-MM.md

4. Completar cada dia:

- Cuadricula mensual (resumen rapido por dia).
- Detalle diario (plan, realizado, bloqueos, siguiente paso, resumen para daily).

## Parametros opcionales

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:/Projects/requerimientos/registro-diario/scripts/generar-registro-mensual.ps1" -Year 2026 -Month 7
```

## Recomendacion de rutina

1. Iniciar jornada: llenar "Plan del dia".
2. Cierre de jornada: completar "Realizado", "Bloqueos" y "Resumen para daily".
3. Viernes: usar los 5 resumenes diarios para reporte semanal del equipo.