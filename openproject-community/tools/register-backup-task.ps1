param(
    [string]$TaskName = "Projects-Backup-Each4Hours",
    [string]$ScriptPath = "c:\Projects\openproject-community\tools\backup-projects.ps1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $ScriptPath)) {
    throw "No existe el script de backup: $ScriptPath"
}

$taskCmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

schtasks.exe /Create /F /TN "$TaskName" /SC HOURLY /MO 4 /TR "$taskCmd" | Out-Null

Write-Host "[DONE] Tarea registrada: $TaskName"
Write-Host "[INFO] Ejecuta cada 4 horas"
