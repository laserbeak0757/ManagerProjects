Param(
    [string]$RepoRoot = ".",
    [string]$OutRoot = "migration_postgres/output/source"
)

$ErrorActionPreference = "Stop"

$repo = Resolve-Path $RepoRoot
$out = Join-Path $repo $OutRoot
$versionedOut = Join-Path $out "versioned"
$seedsOut = Join-Path $out "repeatable_seeds"

New-Item -ItemType Directory -Force -Path $out | Out-Null
New-Item -ItemType Directory -Force -Path $versionedOut | Out-Null
New-Item -ItemType Directory -Force -Path $seedsOut | Out-Null

$versionedSrc = Join-Path $repo "migrations/versioned"
$repeatableSrc = Join-Path $repo "migrations/repeatable"

if (-not (Test-Path $versionedSrc)) { throw "No existe migrations/versioned" }
if (-not (Test-Path $repeatableSrc)) { throw "No existe migrations/repeatable" }

Get-ChildItem -Path $versionedSrc -Filter "V*.sql" | Sort-Object Name | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $versionedOut $_.Name) -Force
}

Get-ChildItem -Path $repeatableSrc -Filter "*_seeds.sql" | Sort-Object Name | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $seedsOut $_.Name) -Force
}

Write-Output "Export completado"
Write-Output "Versioned -> $versionedOut"
Write-Output "Repeatable seeds -> $seedsOut"
