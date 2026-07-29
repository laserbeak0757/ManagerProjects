param(
    [int]$Year = (Get-Date).Year,
    [int]$Month = (Get-Date).Month,
    [string]$OutputDir = "c:/Projects/requerimientos/registro-diario/registros"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($Month -lt 1 -or $Month -gt 12) {
    throw "Month debe estar entre 1 y 12."
}

$firstDay = [datetime]::new($Year, $Month, 1)
$lastDay = $firstDay.AddMonths(1).AddDays(-1)

if (-not (Test-Path -LiteralPath $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$monthId = "{0}-{1:00}" -f $Year, $Month
$outputFile = Join-Path $OutputDir ("REGISTRO-{0}.md" -f $monthId)

function Get-MondayStart([datetime]$date) {
    $offset = ([int]$date.DayOfWeek + 6) % 7
    return $date.AddDays(-$offset)
}

function Build-WeekRows([datetime]$startDate, [datetime]$endDate) {
    $rows = @()
    $weekStart = Get-MondayStart $startDate
    $weekNumber = 1

    while ($weekStart -le $endDate) {
        $cells = @()
        for ($i = 0; $i -lt 5; $i++) {
            $d = $weekStart.AddDays($i)
            if ($d.Month -eq $startDate.Month) {
                $cells += ("{0:00}: " -f $d.Day)
            }
            else {
                $cells += "-"
            }
        }

        $rows += "| Semana $weekNumber | $($cells[0]) | $($cells[1]) | $($cells[2]) | $($cells[3]) | $($cells[4]) |"
        $weekStart = $weekStart.AddDays(7)
        $weekNumber++
    }

    return $rows
}

function Build-DailySections([datetime]$startDate, [datetime]$endDate) {
    $lines = @()
    $cursor = $startDate

    while ($cursor -le $endDate) {
        if ($cursor.DayOfWeek -ne [System.DayOfWeek]::Saturday -and $cursor.DayOfWeek -ne [System.DayOfWeek]::Sunday) {
            $dayName = switch ($cursor.DayOfWeek) {
                Monday { "Lunes" }
                Tuesday { "Martes" }
                Wednesday { "Miercoles" }
                Thursday { "Jueves" }
                Friday { "Viernes" }
                default { "Dia" }
            }

            $lines += "### {0:yyyy-MM-dd} ({1})" -f $cursor, $dayName
            $lines += ""
            $lines += "- Actividad:"
            $lines += "- Agente amigable:"
            $lines += "- Agente real:"
            $lines += "- Prompt / entrada:"
            $lines += "- Plan del dia:"
            $lines += "- Realizado:"
            $lines += "- Bloqueos:"
            $lines += "- Siguiente paso:"
            $lines += "- Resumen para daily (1-2 lineas):"
            $lines += ""
        }

        $cursor = $cursor.AddDays(1)
    }

    return $lines
}

$content = @()
$content += "# Registro diario $monthId"
$content += ""
$aliasFile = Join-Path $PSScriptRoot "..\agentes-alias.json"
if (Test-Path -LiteralPath $aliasFile) {
    $aliasMap = Get-Content -LiteralPath $aliasFile -Raw | ConvertFrom-Json
    $content += "## Alias de agentes para registro diario"
    $content += ""
    foreach ($key in $aliasMap.PSObject.Properties.Name) {
        $entry = $aliasMap.$key
        $content += "- $($entry.friendlyName) -> $($entry.agent)"
    }
    $content += ""
}

$content += "## Objetivo del mes"
$content += ""
$content += "- Objetivo 1:"
$content += "- Objetivo 2:"
$content += "- Objetivo 3:"
$content += ""
$content += "## Cuadricula mensual (resumen)"
$content += ""
$content += "| Semana | Lunes | Martes | Miercoles | Jueves | Viernes |"
$content += "|---|---|---|---|---|---|"
$content += Build-WeekRows -startDate $firstDay -endDate $lastDay
$content += ""
$content += "## Detalle diario"
$content += ""
$content += Build-DailySections -startDate $firstDay -endDate $lastDay
$content += "## Cierre semanal"
$content += ""
$content += "### Semana 1"
$content += ""
$content += "- Logros:"
$content += "- Riesgos:"
$content += "- Decisiones:"
$content += "- Pendientes abiertos:"
$content += ""
$content += "### Semana 2"
$content += ""
$content += "- Logros:"
$content += "- Riesgos:"
$content += "- Decisiones:"
$content += "- Pendientes abiertos:"
$content += ""
$content += "### Semana 3"
$content += ""
$content += "- Logros:"
$content += "- Riesgos:"
$content += "- Decisiones:"
$content += "- Pendientes abiertos:"
$content += ""
$content += "### Semana 4"
$content += ""
$content += "- Logros:"
$content += "- Riesgos:"
$content += "- Decisiones:"
$content += "- Pendientes abiertos:"
$content += ""
$content += "### Semana 5"
$content += ""
$content += "- Logros:"
$content += "- Riesgos:"
$content += "- Decisiones:"
$content += "- Pendientes abiertos:"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($outputFile, ($content -join [Environment]::NewLine), $utf8NoBom)

Write-Host "Registro generado: $outputFile"