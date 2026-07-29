# OpenProject Community en Docker

## 1) Validar y asignar puerto

Desde esta carpeta ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-openproject.ps1
```

- Intenta usar el puerto `8080`.
- Si `8080` esta ocupado, busca automaticamente el siguiente puerto libre.
- Genera el archivo `.env` con el puerto seleccionado, credenciales de PostgreSQL y la URL de conexion requerida por OpenProject.

## 2) Levantar OpenProject

```powershell
docker compose up -d
```

## 3) Abrir en navegador

Usa la URL:

- `http://localhost:<PUERTO_ASIGNADO>`

Puedes ver el puerto en el archivo `.env` (`OPENPROJECT_HOST_PORT`).

Nota: el primer arranque puede tardar varios minutos mientras OpenProject inicializa su base de datos.

## Comandos utiles

```powershell
docker compose ps
docker compose logs -f openproject
docker compose down
```

## Gestion y operacion recomendada

- Propuesta de gestion por subproyectos de agentes:
	- `docs/01-propuesta-gestion-openproject.md`
- Checklist operativo estandar:
	- `docs/02-checklist-operativo-openproject.md`
- Implementacion ejecutada y comandos rapidos:
	- `docs/03-implementacion-gestion-y-respaldo.md`

## Scripts de automatizacion

- Bootstrap de portafolio y backlog inicial en OpenProject:
	- `tools/bootstrap-openproject-portfolio.ps1`
- Respaldo local del directorio completo `c:\Projects`:
	- `tools/backup-projects.ps1`
- Restauracion desde backup comprimido:
	- `tools/restore-projects.ps1`
- Programacion de respaldo cada 4 horas (Task Scheduler):
	- `tools/register-backup-task.ps1`
