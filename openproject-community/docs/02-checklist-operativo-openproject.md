# Checklist Operativo Estandar (OpenProject en Docker)

## Alcance
Este checklist define comandos y validaciones para:
- Arranque
- Validacion
- Creacion de admin
- Respaldo
- Recuperacion

## Prerrequisitos
- Docker Desktop instalado y activo.
- PowerShell 7 recomendado para scripts:
  - Verificar: `pwsh --version`
- Carpeta de trabajo: `c:\Projects\openproject-community`

## 1) Arranque
1. Entrar al directorio del proyecto:
```powershell
Set-Location "c:\Projects\openproject-community"
```
2. Generar `.env`:
```powershell
powershell -ExecutionPolicy Bypass -File .\setup-openproject.ps1
```
3. Levantar servicios:
```powershell
docker compose up -d
```
4. Confirmar estado:
```powershell
docker compose ps
```

## 2) Validacion
1. Validar endpoint web:
```powershell
curl.exe -I http://localhost:8080/login
```
2. Revisar logs:
```powershell
docker compose logs --tail=200 openproject
```
3. Validar salud general:
- Debe responder HTTP 200 en `/login`.
- No debe haber reinicios continuos del contenedor.

## 3) Creacion o verificacion de usuario admin
### Verificar si existe admin
```powershell
@"
u = User.find_by(login: 'admin')
p u&.attributes&.slice('id','login','mail','status')
"@ | docker compose exec -T openproject bin/rails runner -
```

### Crear admin si no existe
```powershell
@"
user = User.new(
  login: 'admin',
  firstname: 'Admin',
  lastname: 'User',
  mail: 'admin@example.com',
  password: 'OpenProject2026!',
  password_confirmation: 'OpenProject2026!',
  status: 1,
  admin: true,
  language: 'en'
)
user.save!
puts user.id
puts user.login
"@ | docker compose exec -T openproject bin/rails runner -
```

### Verificar password de admin
```powershell
@"
u = User.find_by(login: 'admin')
p [u&.check_password?('OpenProject2026!'), u&.status, u&.admin]
"@ | docker compose exec -T openproject bin/rails runner -
```
Resultado esperado: `[true, "active", true]`.

## 4) Respaldo (directorio completo Projects)

### Estrategia recomendada
- Politica 3-2-1.
- Frecuencia:
  - Incremental cada 4 horas.
  - Snapshot nocturno.
- Retencion:
  - 14 diarios
  - 8 semanales
  - 12 mensuales

### Opcion simple inmediata (local comprimido)
1. Crear carpeta de backups:
```powershell
New-Item -ItemType Directory -Force -Path "D:\backups\projects" | Out-Null
```
2. Generar backup comprimido:
```powershell
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dest = "D:\backups\projects\projects-$stamp.zip"
Compress-Archive -Path "c:\Projects\*" -DestinationPath $dest -CompressionLevel Optimal
```

### Opcion profesional (recomendada)
- Restic + almacenamiento externo (Azure Blob, B2 o S3 compatible).
- Cifrado, deduplicacion y validacion automatica.

## 5) Recuperacion
### Recuperacion local rapida (desde zip)
1. Preparar carpeta destino:
```powershell
New-Item -ItemType Directory -Force -Path "c:\Restore\Projects" | Out-Null
```
2. Extraer backup:
```powershell
Expand-Archive -Path "D:\backups\projects\projects-YYYYMMDD-HHMMSS.zip" -DestinationPath "c:\Restore\Projects" -Force
```
3. Verificar contenido restaurado:
```powershell
Get-ChildItem "c:\Restore\Projects"
```

## 6) Checklist de control (antes de cerrar)
- [ ] `docker compose ps` sin errores.
- [ ] `/login` responde correctamente.
- [ ] Usuario admin validado.
- [ ] Backup ejecutado.
- [ ] Prueba de restauracion realizada.

## 7) Roles y responsabilidades
- Owner tecnico: administra contenedores y configuracion.
- Owner operativo: valida checklist diario/semanal.
- Owner de respaldo: ejecuta y audita restauraciones.

## 8) Notas operativas
- Si aparece error de CSRF en pruebas con `curl`, revisar cookie y token en la misma sesion.
- Evitar cambios manuales directos en base de datos sin respaldo previo.
- Mantener evidencia de cada ejecucion operativa (fecha, responsable, resultado).
