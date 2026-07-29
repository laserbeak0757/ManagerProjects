param(
  [string]$MigrationsPath = "..\..\..\Proyectos\sip-bd-migrations\migrations\versioned",
  [string]$OutputPath = "..\data\schema.from.sip-bd-migrations.json"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$resolvedMigrations = Resolve-Path (Join-Path $scriptDir $MigrationsPath)
$resolvedOutput = Join-Path $scriptDir $OutputPath

$tables = @{}
$bracketColumnRegex = [regex]'^\[(?<name>[^\]]+)\]\s+\[(?<type>[^\]]+)\](?<rest>.*)$'
$plainColumnRegex = [regex]'^(?<name>[a-zA-Z0-9_]+)\s+(?<type>[a-zA-Z0-9_]+)(?<rest>.*)$'

function Add-TableFromMatch {
  param([System.Text.RegularExpressions.Match]$regexMatch)

  $schemaName = $regexMatch.Groups["schema"].Value
  $tableName = $regexMatch.Groups["table"].Value
  $body = $regexMatch.Groups["body"].Value

  if (-not $schemaName -or -not $tableName) {
    return
  }

  $fields = @()
  $lines = $body -split "`n"

  foreach ($line in $lines) {
    $trim = $line.Trim().TrimEnd(",")
    if ($trim -eq "") { continue }
    if ($trim -match "^(CONSTRAINT|PRIMARY\s+KEY|UNIQUE|FOREIGN\s+KEY|CHECK)\b") { continue }

    $bracketHit = $bracketColumnRegex.Match($trim)
    $plainHit = $plainColumnRegex.Match($trim)

    if ($bracketHit.Success) {
      $colName = $bracketHit.Groups["name"].Value
      $colType = $bracketHit.Groups["type"].Value
      $rest = $bracketHit.Groups["rest"].Value
      $nullable = -not ($rest -match "NOT\s+NULL")

      $fields += [PSCustomObject]@{
        name = $colName
        type = $colType
        nullable = $nullable
      }
    } elseif ($plainHit.Success) {
      $colName = $plainHit.Groups["name"].Value
      $colType = $plainHit.Groups["type"].Value
      $rest = $plainHit.Groups["rest"].Value
      $nullable = -not ($rest -match "NOT\s+NULL")

      $fields += [PSCustomObject]@{
        name = $colName
        type = $colType
        nullable = $nullable
      }
    }
  }

  if ($fields.Count -eq 0) {
    return
  }

  $key = "$schemaName.$tableName"
  $tables[$key] = [PSCustomObject]@{
    schema = $schemaName
    name = $tableName
    fields = $fields
  }
}

$createTableRegex = New-Object System.Text.RegularExpressions.Regex(
  "CREATE\s+TABLE\s+\[(?<schema>[^\]]+)\]\.\[(?<table>[^\]]+)\]\s*\((?<body>.*?)\)\s*(?:ON\s+\[|;)",
  [System.Text.RegularExpressions.RegexOptions]"IgnoreCase, Singleline"
)

Get-ChildItem -Path $resolvedMigrations -Filter "V*.sql" |
  Sort-Object Name |
  ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    $currentHit = $createTableRegex.Match($content)
    while ($currentHit.Success) {
      Add-TableFromMatch -regexMatch $currentHit
      $currentHit = $currentHit.NextMatch()
    }
  }

$result = [PSCustomObject]@{
  source = "sip-bd-migrations"
  generatedAt = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")
  migrationsPath = (Resolve-Path $resolvedMigrations).Path
  tableCount = $tables.Count
  tables = @($tables.Values | Sort-Object { "$($_.schema).$($_.name)" })
}

$outputDir = Split-Path -Parent $resolvedOutput
if (-not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$result | ConvertTo-Json -Depth 8 | Set-Content -Path $resolvedOutput -Encoding UTF8
Write-Host "Schema exportado en: $resolvedOutput"
Write-Host "Tablas detectadas: $($tables.Count)"
