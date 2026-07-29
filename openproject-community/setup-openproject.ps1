param(
    [int]$PreferredPort = 8080,
    [int]$MaxPortChecks = 30
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-PortAvailable {
    param([int]$Port)

    $existingListener = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
    if ($existingListener) {
        return $false
    }

    $probe = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
    try {
        $probe.Start()
        return $true
    }
    catch {
        return $false
    }
    finally {
        try { $probe.Stop() } catch { }
    }
}

function New-Secret {
    $bytes = New-Object byte[] 48
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $rng.GetBytes($bytes)
    }
    finally {
        $rng.Dispose()
    }
    return [Convert]::ToBase64String($bytes)
}

function New-DbPassword {
    param([int]$Length = 32)

    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $bytes = New-Object byte[] $Length
        $rng.GetBytes($bytes)
        $builder = New-Object System.Text.StringBuilder
        foreach ($b in $bytes) {
            [void]$builder.Append($chars[$b % $chars.Length])
        }
        return $builder.ToString()
    }
    finally {
        $rng.Dispose()
    }
}

$selectedPort = $null
for ($candidate = $PreferredPort; $candidate -lt ($PreferredPort + $MaxPortChecks); $candidate++) {
    if (Test-PortAvailable -Port $candidate) {
        $selectedPort = $candidate
        break
    }
}

if (-not $selectedPort) {
    throw "No se encontro un puerto libre entre $PreferredPort y $($PreferredPort + $MaxPortChecks - 1)."
}

$envPath = Join-Path $PSScriptRoot ".env"
$secret = New-Secret
$dbPassword = New-DbPassword
$hostName = "localhost:$selectedPort"
$dbUser = "openproject"
$dbName = "openproject"
$dbUrl = "postgres://${dbUser}:${dbPassword}@postgres:5432/${dbName}"

@(
    "OPENPROJECT_HOST_PORT=$selectedPort"
    "OPENPROJECT_HTTPS=false"
    "OPENPROJECT_HOST_NAME=$hostName"
    "OPENPROJECT_SECRET_KEY_BASE=$secret"
    "OPENPROJECT_DB_HOST=postgres"
    "OPENPROJECT_DB_PORT=5432"
    "OPENPROJECT_DB_DATABASE=$dbName"
    "OPENPROJECT_DB_USERNAME=$dbUser"
    "OPENPROJECT_DB_PASSWORD=$dbPassword"
    "OPENPROJECT_DB_URL=$dbUrl"
) | Set-Content -Path $envPath -Encoding ASCII

if ($selectedPort -ne $PreferredPort) {
    Write-Host "Puerto $PreferredPort ocupado. Se asigno automaticamente el puerto $selectedPort."
}
else {
    Write-Host "Puerto $selectedPort disponible."
}

Write-Host "Archivo .env generado en: $envPath"
Write-Host "Siguiente paso: docker compose up -d"
