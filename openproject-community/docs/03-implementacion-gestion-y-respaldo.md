# Implementacion ejecutada: gestion por agentes + respaldo

## Resultado aplicado hoy
1. Se creo el proyecto padre `Plataforma Agentes`.
2. Se crearon 15 subproyectos (1 por agente).
3. Se creo backlog inicial por subproyecto:
   - 1 Epic
   - 1 Feature
4. Se crearon scripts operativos para respaldo y recuperacion de `c:\Projects`.

## Scripts creados
- Bootstrap OpenProject:
  - `tools/bootstrap-openproject-portfolio.ps1`
- Backup:
  - `tools/backup-projects.ps1`
- Restore:
  - `tools/restore-projects.ps1`
- Programacion automatica (cada 4 horas):
  - `tools/register-backup-task.ps1`

## Comandos de uso
### 1) Reejecutar bootstrap de portafolio (idempotente)
```powershell
Set-Location "c:\Projects\openproject-community"
powershell -ExecutionPolicy Bypass -File .\tools\bootstrap-openproject-portfolio.ps1
```

### 2) Ejecutar backup manual
```powershell
Set-Location "c:\Projects\openproject-community"
powershell -ExecutionPolicy Bypass -File .\tools\backup-projects.ps1
```

### 3) Registrar backup automatico cada 4 horas
```powershell
Set-Location "c:\Projects\openproject-community"
powershell -ExecutionPolicy Bypass -File .\tools\register-backup-task.ps1
```

### 4) Restaurar un backup
```powershell
Set-Location "c:\Projects\openproject-community"
powershell -ExecutionPolicy Bypass -File .\tools\restore-projects.ps1 -BackupZip "c:\Projects\_backups\projects\projects-YYYYMMDD-HHMMSS.zip"
```

## Validaciones recomendadas
- Validar que existan 15 subproyectos bajo `Plataforma Agentes`.
- Validar 30 work packages iniciales (15 Epic + 15 Feature).
- Ejecutar al menos una prueba de restauracion por semana.

## Nota de seguridad
- Cambiar la clave `admin` por una gestionada por el equipo.
- Restringir permisos del directorio `c:\Projects\_backups`.
- Mantener una copia externa para estrategia 3-2-1.
