Param(
    [string]$RepoRoot = "."
)

$ErrorActionPreference = "Stop"

Write-Output "[1/3] Export source"
powershell -ExecutionPolicy Bypass -File "migration_postgres/scripts/01_export_schema_and_seeds.ps1" -RepoRoot $RepoRoot
if ($LASTEXITCODE -ne 0) { throw "Fallo export" }

Write-Output "[2/3] Convert SQL"
powershell -ExecutionPolicy Bypass -File "migration_postgres/scripts/02_convert_sqlserver_to_postgres.ps1" -RepoRoot $RepoRoot
if ($LASTEXITCODE -ne 0) { throw "Fallo conversion" }

Write-Output "[3/3] Validate"
powershell -ExecutionPolicy Bypass -File "migration_postgres/scripts/03_validate_postgres_sql.ps1" -RepoRoot $RepoRoot
if ($LASTEXITCODE -ne 0) { throw "Fallo validacion" }

Write-Output "Proceso completo OK"
