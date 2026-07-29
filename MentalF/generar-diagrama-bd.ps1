param(
    [ValidateSet('all', 'schema', 'domain')]
    [string]$Scope = 'all',
    [string[]]$Schemas = @(),
    [string]$Domain = 'core',
    [string]$Version = 'v1.0.0'
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $root ("versiones/{0}/generar-diagrama-bd.ps1" -f $Version)

if (-not (Test-Path $target)) {
    throw "No se encontro el script versionado: $target"
}

$params = @{
    Scope = $Scope
}

if ($Scope -eq 'schema' -and $Schemas.Count -gt 0) {
    $params['Schemas'] = $Schemas
}

if ($Scope -eq 'domain') {
    $params['Domain'] = $Domain
}

& $target @params
