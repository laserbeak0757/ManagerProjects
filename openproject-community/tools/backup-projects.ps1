param(
    [string]$SourcePath = "c:\Projects",
    [string]$BackupRoot = "c:\Projects\_backups\projects",
    [int]$DailyRetentionDays = 14,
    [int]$WeeklyRetentionWeeks = 8,
    [int]$MonthlyRetentionMonths = 12
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $SourcePath)) {
    throw "SourcePath no existe: $SourcePath"
}

New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$zipPath = Join-Path $BackupRoot "projects-$stamp.zip"
$hashPath = "$zipPath.sha256"

Write-Host "[INFO] Creando backup comprimido: $zipPath"
Compress-Archive -Path (Join-Path $SourcePath "*") -DestinationPath $zipPath -CompressionLevel Optimal -Force

$hash = Get-FileHash -Algorithm SHA256 -Path $zipPath
"$($hash.Algorithm) $($hash.Hash) $($zipPath | Split-Path -Leaf)" | Set-Content -Path $hashPath -Encoding ASCII

Write-Host "[OK] Backup creado"
Write-Host "[OK] Hash guardado en: $hashPath"

$now = Get-Date
$files = Get-ChildItem -Path $BackupRoot -Filter "projects-*.zip" | Sort-Object LastWriteTime

foreach ($file in $files) {
    $ageDays = ($now - $file.LastWriteTime).TotalDays
    $keep = $false

    if ($ageDays -le $DailyRetentionDays) {
        $keep = $true
    }
    elseif ($ageDays -le ($WeeklyRetentionWeeks * 7)) {
        if ($file.LastWriteTime.DayOfWeek -eq 'Sunday') {
            $keep = $true
        }
    }
    elseif ($ageDays -le ($MonthlyRetentionMonths * 30.5)) {
        if ($file.LastWriteTime.Day -le 2) {
            $keep = $true
        }
    }

    if (-not $keep) {
        Write-Host "[CLEAN] Eliminando backup por retencion: $($file.Name)"
        Remove-Item -Path $file.FullName -Force
        $shaPath = "$($file.FullName).sha256"
        if (Test-Path $shaPath) {
            Remove-Item -Path $shaPath -Force
        }
    }
}

Write-Host "[DONE] Proceso de respaldo finalizado"
