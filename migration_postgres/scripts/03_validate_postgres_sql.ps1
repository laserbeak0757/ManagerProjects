Param(
    [string]$RepoRoot = ".",
    [string]$SqlRoot = "migration_postgres/output/postgres",
    [string]$ReportRoot = "migration_postgres/output/reports"
)

$ErrorActionPreference = "Stop"

$repo = Resolve-Path $RepoRoot
$sqlBase = Join-Path $repo $SqlRoot
$reportBase = Join-Path $repo $ReportRoot

if (-not (Test-Path $sqlBase)) { throw "No existe SQL convertido: $sqlBase" }
New-Item -ItemType Directory -Force -Path $reportBase | Out-Null

$summary = Join-Path $reportBase "validation_summary.txt"
"Validation summary" | Set-Content -Path $summary -Encoding UTF8
"Generated: $(Get-Date -Format o)" | Add-Content -Path $summary
"" | Add-Content -Path $summary

$checks = @(
    @{ Name = "create_table"; Pattern = '(?i)CREATE\s+TABLE' },
    @{ Name = "alter_table"; Pattern = '(?i)ALTER\s+TABLE' },
    @{ Name = "foreign_key"; Pattern = '(?i)FOREIGN\s+KEY' },
    @{ Name = "create_index"; Pattern = '(?i)CREATE\s+INDEX' },
    @{ Name = "identity_left"; Pattern = '(?i)IDENTITY\s*\(' },
    @{ Name = "go_left"; Pattern = '(?im)^GO$' },
    @{ Name = "brackets_left"; Pattern = '\[|\]' },
    @{ Name = "sysutcdatetime_left"; Pattern = '(?i)SYSUTCDATETIME\s*\(' },
    @{ Name = "sp_addextendedproperty_left"; Pattern = '(?i)sp_addextendedproperty' }
)

$sqlFiles = Get-ChildItem -Path $sqlBase -Filter "*.sql" -Recurse

foreach ($c in $checks) {
    $n = (Select-String -Path $sqlFiles.FullName -Pattern $c.Pattern -AllMatches -ErrorAction SilentlyContinue | Measure-Object).Count
    Add-Content -Path $summary -Value ("{0} => {1}" -f $c.Name, $n)
}

Write-Output "Validacion completada"
Write-Output "Resumen -> $summary"
