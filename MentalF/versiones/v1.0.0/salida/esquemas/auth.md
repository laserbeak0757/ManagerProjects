# Mapa Visual por Esquema: auth

Version artefacto: 1.0.0
Generado: 2026-07-28 16:47:19
Fuente: Proyectos/sip-bd-migrations/compare/source.dacpac
Esquemas incluidos: auth

```mermaid
flowchart LR
    N_auth_nivel_seguridad[auth.nivel_seguridad]
    N_auth_parametro[auth.parametro]
    N_auth_perfil[auth.perfil]
    N_auth_perfil_rol[auth.perfil_rol]
    N_auth_perfil_rol_permiso[auth.perfil_rol_permiso]
    N_auth_permiso[auth.permiso]
    N_auth_refresh_token[auth.refresh_token]
    N_auth_rol[auth.rol]
    N_auth_usuario[auth.usuario]
    N_auth_usuario_perfil[auth.usuario_perfil]
    N_organizacion_funcionario[organizacion.funcionario]
    N_auth_perfil_rol -->|auth.fk_perfil_rol_nivel_seguridad| N_auth_nivel_seguridad
    N_auth_perfil_rol -->|auth.fk_perfil_rol_perfil| N_auth_perfil
    N_auth_perfil_rol_permiso -->|auth.fk_perfil_rol_permiso_perfil_rol| N_auth_perfil_rol
    N_auth_perfil_rol_permiso -->|auth.fk_perfil_rol_permiso_permiso| N_auth_permiso
    N_auth_perfil_rol -->|auth.fk_perfil_rol_rol| N_auth_rol
    N_auth_refresh_token -->|auth.fk_refresh_token_reemplazo| N_auth_refresh_token
    N_auth_refresh_token -->|auth.fk_refresh_token_usuario| N_auth_usuario
    N_auth_usuario -->|auth.fk_usuario_funcionario| N_organizacion_funcionario
    N_auth_usuario_perfil -->|auth.fk_usuario_perfil_perfil| N_auth_perfil
    N_auth_usuario_perfil -->|auth.fk_usuario_perfil_usuario| N_auth_usuario
```

Tablas incluidas: 11
Relaciones incluidas: 10
