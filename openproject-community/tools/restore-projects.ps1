param(
    [Parameter(Mandatory = $true)]
    [string]$BackupZip,
    [string]$RestorePath = "c:\Restore\Projects"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $BackupZip)) {
    throw "BackupZip no existe: $BackupZip"
}

$shaPath = "$BackupZip.sha256"
if (Test-Path -Path $shaPath) {
    $line = Get-Content -Path $shaPath -ErrorAction Stop
    $parts = $line -split ' '
    if ($parts.Count -ge 2) {
        $expected = $parts[1].Trim()
        $actual = (Get-FileHash -Algorithm SHA256 -Path $BackupZip).Hash
        if ($expected -ne $actual) {
            throw "Hash SHA256 no coincide. Esperado=$expected, Actual=$actual"
        }
        Write-Host "[OK] Hash verificado"
    }
}
else {
    Write-Warning "No se encontro archivo SHA256. Se omite validacion criptografica."
}

New-Item -ItemType Directory -Path $RestorePath -Force | Out-Null

Write-Host "[INFO] Restaurando en: $RestorePath"
Expand-Archive -Path $BackupZip -DestinationPath $RestorePath -Force

Write-Host "[DONE] Restauracion completada"
