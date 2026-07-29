-- =============================================================================
-- SIP — Repeatable Migration: R__auth_seeds.sql
-- =============================================================================
-- Tipo:         Repeatable migration (Flyway). Se re-ejecuta cuando cambia
--               el checksum del archivo. Usa MERGE para idempotencia: si los
--               registros ya existen, los actualiza; si no, los inserta.
-- Compatible:   SQL Server 2017+ (forward-compatible 2022)
-- Depende de:   V0002__nuevo_esquema_auth.sql (esquema auth con sus tablas)
--
-- ALCANCE:
--   Carga el catálogo RBAC institucional del Sistema Integrado Policial
--   (PDI) según el documento "Modelo operacional SIP - Perfiles y Roles".
--
-- CONTENIDO:
--   - 7 perfiles institucionales (VIS, CIP, POL, PER, ALA, CAD, SOP)
--   - 15 roles funcionales
--   - 5 niveles de seguridad (1=Pública .. 5=Secreta propia)
--   - 16 combinaciones perfil-rol-nivel con sus claim_codes para JWT
--     (POL-IN aparece dos veces: nivel 2 y 3, según experiencia)
--   - 34 permisos atómicos: 14 operativas (O*), 12 documentales (D*),
--     5 control y auditoría (C*), 3 mantención (M*)
--   - 229 asignaciones perfil_rol → permiso según matriz de funciones
--
-- NOTA SOBRE LOS PERMISOS C* (control y auditoría):
--   El documento PDI tiene un C1 duplicado (aparece como C1 en dos filas:
--   "Ver bitácora de actividades de caso" y "Ver logs generales"). Para
--   evitar el conflicto con el UNIQUE de codigo_funcion, se reasignó así
--   conservando la semántica original de C2/C3/C4 del documento:
--     C1 = Ver bitácora de actividades de caso  (sin cambios)
--     C2 = Ver historial de cambios             (sin cambios)
--     C3 = Generar observación de mal ingreso   (sin cambios)
--     C4 = Generar amonestación por mal ingreso (sin cambios)
--     C5 = Ver logs generales                   (era el segundo C1)
--   TODO: confirmar con PDI la numeración definitiva de C*.
--
-- ESTRUCTURA DEL ARCHIVO:
--   PASO 1 — Catálogos base: perfil, rol, nivel_seguridad, permiso
--   PASO 2 — perfil_rol (combinaciones perfil-rol-nivel con claim_code)
--   PASO 3 — perfil_rol_permiso (matriz de funciones por claim)
--
-- IDEMPOTENCIA:
--   Cada bloque usa MERGE matcheando por la columna de negocio (sigla,
--   nivel, codigo_funcion, claim_code). Re-ejecutar este script no genera
--   duplicados ni rompe — actualiza nombres/descripciones si cambiaron.
-- =============================================================================
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


-- =============================================================================
-- PASO 1 — CATÁLOGOS BASE
-- =============================================================================

-- ----- auth.perfil -----

MERGE [auth].[perfil] AS tgt
USING (VALUES
    (N'Visualizador', 'VIS', N'Personal de apoyo o administrativo que no desarrolla investigaciones ni ingresa datos al sistema, sino que sólo consume datos de nivel básico.'),
    (N'Central comunicaciones', 'CIP', N'Personal que recibe llamados al nivel de emergencia y gestiona las concurrencias de los carros de turno.'),
    (N'Policial', 'POL', N'Funcionarios policiales que desarrollan investigaciones e ingresan información al sistema.'),
    (N'Perito', 'PER', N'Personal pericial que elabora informes y alimenta casos con información de carácter pericial.'),
    (N'Analista', 'ALA', N'Funcionarios que se desempeñan en Oficinas de Análisis Criminal y elaboran reportes analíticos.'),
    (N'Control y auditoría', 'CAD', N'Personal a cargo de control, auditoría, gobernanza de datos y asuntos internos.'),
    (N'Soporte', 'SOP', N'Personal técnico de soporte, administración de base de datos y desarrollo de la plataforma.'),
    (N'Investigador', 'INV', N'Investigador.'),
    (N'Jefe', 'JEF', N'Jefatura.')
) AS src(nombre, sigla, descripcion)
ON tgt.sigla = src.sigla
WHEN MATCHED THEN
    UPDATE SET nombre = src.nombre, descripcion = src.descripcion
WHEN NOT MATCHED THEN
    INSERT (nombre, sigla, descripcion)
    VALUES (src.nombre, src.sigla, src.descripcion);
GO


-- ----- auth.rol -----

MERGE [auth].[rol] AS tgt
USING (VALUES
    (N'Consulta', 'CO'),
    (N'Operador', 'OP'),
    (N'Digitador', 'DI'),
    (N'Investigador', 'IN'),
    (N'Jefe', 'JE'),
    (N'Pericial', 'PE'),
    (N'Visador', 'VI'),
    (N'Análisis', 'AN'),
    (N'Encargado', 'EN'),
    (N'Contralor', 'CN'),
    (N'Data steward', 'DS'),
    (N'Asuntos internos', 'AI'),
    (N'Mantenedor', 'MA'),
    (N'DBA', 'DB'),
    (N'Desarrollador', 'DE')
) AS src(nombre, sigla)
ON tgt.sigla = src.sigla
WHEN MATCHED THEN
    UPDATE SET nombre = src.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre, sigla)
    VALUES (src.nombre, src.sigla);
GO


-- ----- auth.nivel_seguridad -----

MERGE [auth].[nivel_seguridad] AS tgt
USING (VALUES
    (1, N'Ver información Pública.'),
    (2, N'Ver información Pública. Crear información Pública.'),
    (3, N'Ver información Pública. Crear información Pública. Crear información Reservada (con validación). Ver información Reservada propia.'),
    (4, N'Ver información Pública. Crear información Pública. Crear información Reservada (con validación). Ver información Reservada.'),
    (5, N'Ver información Pública. Crear información Pública. Crear información Reservada (con validación). Ver información Reservada. Crear información Secreta (con validación). Ver información Secreta propia.')
) AS src(nivel, descripcion)
ON tgt.nivel = src.nivel
WHEN MATCHED THEN
    UPDATE SET descripcion = src.descripcion
WHEN NOT MATCHED THEN
    INSERT (nivel, descripcion)
    VALUES (src.nivel, src.descripcion);
GO


-- ----- auth.permiso -----

MERGE [auth].[permiso] AS tgt
USING (VALUES
    ('O1', N'Ver entidad', N'Operativas'),
    ('O2', N'Crear entidad', N'Operativas'),
    ('O3', N'Editar entidad', N'Operativas'),
    ('O4', N'Vincular entidades', N'Operativas'),
    ('O5', N'Desvincular entidades', N'Operativas'),
    ('O6', N'Crear caso', N'Operativas'),
    ('O7', N'Desplegar caso', N'Operativas'),
    ('O8', N'Alimentar caso', N'Operativas'),
    ('O9', N'Editar caso', N'Operativas'),
    ('O10', N'Vincular casos', N'Operativas'),
    ('O11', N'Desvincular casos', N'Operativas'),
    ('O12', N'Crear actividad de caso', N'Operativas'),
    ('O13', N'Crear agrupación criminal', N'Operativas'),
    ('O14', N'Editar agrupación criminal', N'Operativas'),
    ('D1', N'Crear documento externo', N'Documentales'),
    ('D2', N'Crear documento policial', N'Documentales'),
    ('D3', N'Crear documento analítico', N'Documentales'),
    ('D4', N'Crear documento pericial', N'Documentales'),
    ('D5', N'Ver documento externo', N'Documentales'),
    ('D6', N'Endosar documento externo', N'Documentales'),
    ('D7', N'Ver documentos policiales', N'Documentales'),
    ('D8', N'Visar documentos policiales', N'Documentales'),
    ('D9', N'Ver documentos analíticos', N'Documentales'),
    ('D10', N'Visar documentos analíticos', N'Documentales'),
    ('D11', N'Ver documentos periciales', N'Documentales'),
    ('D12', N'Visar documentos periciales', N'Documentales'),
    ('C1', N'Ver bitácora de actividades de caso', N'Control y auditoría'),
    ('C2', N'Ver historial de cambios', N'Control y auditoría'),
    ('C3', N'Generar observación de mal ingreso', N'Control y auditoría'),
    ('C4', N'Generar amonestación por mal ingreso', N'Control y auditoría'),
    ('C5', N'Ver logs generales', N'Control y auditoría'),
    ('M1', N'Gestionar perfiles y roles de usuarios', N'Mantención'),
    ('M2', N'Gestionar la base de datos', N'Mantención'),
    ('M3', N'Efectuar cambios a nivel de desarrollo', N'Mantención')
) AS src(codigo_funcion, nombre, categoria)
ON tgt.codigo_funcion = src.codigo_funcion
WHEN MATCHED THEN
    UPDATE SET nombre = src.nombre, categoria = src.categoria
WHEN NOT MATCHED THEN
    INSERT (codigo_funcion, nombre, categoria)
    VALUES (src.codigo_funcion, src.nombre, src.categoria);
GO



-- =============================================================================
-- PASO 2 — perfil_rol (combinaciones perfil-rol-nivel con claim_code)
-- =============================================================================
-- Resuelve los IDs por sigla/nivel desde los catálogos cargados arriba.
-- El claim_code es el identificador estable que viaja en el JWT.

MERGE [auth].[perfil_rol] AS tgt
USING (
    SELECT
        p.id_perfil,
        r.id_rol,
        ns.id_nivel_seguridad,
        v.claim_code
    FROM (VALUES
        ('VIS', 'CO', 1, 'VIS-CO-1'),
        ('CIP', 'OP', 2, 'CIP-OP-2'),
        ('POL', 'DI', 2, 'POL-DI-2'),
        ('POL', 'IN', 2, 'POL-IN-2'),
        ('POL', 'IN', 3, 'POL-IN-3'),
        ('POL', 'JE', 3, 'POL-JE-3'),
        ('PER', 'PE', 2, 'PER-PE-2'),
        ('PER', 'VI', 3, 'PER-VI-3'),
        ('ALA', 'AN', 3, 'ALA-AN-3'),
        ('ALA', 'EN', 4, 'ALA-EN-4'),
        ('CAD', 'CN', 4, 'CAD-CN-4'),
        ('CAD', 'DS', 4, 'CAD-DS-4'),
        ('CAD', 'AI', 5, 'CAD-AI-5'),
        ('SOP', 'MA', 2, 'SOP-MA-2'),
        ('SOP', 'DB', 2, 'SOP-DB-2'),
        ('SOP', 'DE', 2, 'SOP-DE-2')
    ) AS v(perfil_sigla, rol_sigla, nivel, claim_code)
    INNER JOIN [auth].[perfil]          p  ON p.sigla  = v.perfil_sigla
    INNER JOIN [auth].[rol]             r  ON r.sigla  = v.rol_sigla
    INNER JOIN [auth].[nivel_seguridad] ns ON ns.nivel = v.nivel
) AS src
ON tgt.claim_code = src.claim_code
WHEN MATCHED THEN
    UPDATE SET
        id_perfil          = src.id_perfil,
        id_rol             = src.id_rol,
        id_nivel_seguridad = src.id_nivel_seguridad
WHEN NOT MATCHED THEN
    INSERT (id_perfil, id_rol, id_nivel_seguridad, claim_code)
    VALUES (src.id_perfil, src.id_rol, src.id_nivel_seguridad, src.claim_code);
GO


-- =============================================================================
-- PASO 3 — perfil_rol_permiso (matriz de funciones)
-- =============================================================================
-- Resuelve los IDs por claim_code y codigo_funcion. Cada par (claim_code,
-- codigo_funcion) presente significa "este claim tiene este permiso".
-- Total de filas en la matriz: 229 asignaciones según el documento PDI.

MERGE [auth].[perfil_rol_permiso] AS tgt
USING (
    SELECT
        pr.id_perfil_rol,
        perm.id_permiso
    FROM (VALUES
        ('ALA-AN-3', 'O1'),
        ('ALA-AN-3', 'O2'),
        ('ALA-AN-3', 'O3'),
        ('ALA-AN-3', 'O4'),
        ('ALA-AN-3', 'O5'),
        ('ALA-AN-3', 'O6'),
        ('ALA-AN-3', 'O7'),
        ('ALA-AN-3', 'O8'),
        ('ALA-AN-3', 'O9'),
        ('ALA-AN-3', 'O10'),
        ('ALA-AN-3', 'O11'),
        ('ALA-AN-3', 'O13'),
        ('ALA-AN-3', 'O14'),
        ('ALA-AN-3', 'D1'),
        ('ALA-AN-3', 'D2'),
        ('ALA-AN-3', 'D3'),
        ('ALA-AN-3', 'D5'),
        ('ALA-AN-3', 'D6'),
        ('ALA-AN-3', 'D7'),
        ('ALA-AN-3', 'D9'),
        ('ALA-AN-3', 'D11'),
        ('ALA-AN-3', 'C2'),
        ('ALA-EN-4', 'O1'),
        ('ALA-EN-4', 'O2'),
        ('ALA-EN-4', 'O3'),
        ('ALA-EN-4', 'O4'),
        ('ALA-EN-4', 'O5'),
        ('ALA-EN-4', 'O6'),
        ('ALA-EN-4', 'O7'),
        ('ALA-EN-4', 'O8'),
        ('ALA-EN-4', 'O9'),
        ('ALA-EN-4', 'O10'),
        ('ALA-EN-4', 'O11'),
        ('ALA-EN-4', 'O13'),
        ('ALA-EN-4', 'O14'),
        ('ALA-EN-4', 'D1'),
        ('ALA-EN-4', 'D2'),
        ('ALA-EN-4', 'D3'),
        ('ALA-EN-4', 'D5'),
        ('ALA-EN-4', 'D6'),
        ('ALA-EN-4', 'D7'),
        ('ALA-EN-4', 'D9'),
        ('ALA-EN-4', 'D10'),
        ('ALA-EN-4', 'D11'),
        ('ALA-EN-4', 'C1'),
        ('ALA-EN-4', 'C2'),
        ('ALA-EN-4', 'C3'),
        ('ALA-EN-4', 'C4'),
        ('CAD-AI-5', 'O1'),
        ('CAD-AI-5', 'O2'),
        ('CAD-AI-5', 'O3'),
        ('CAD-AI-5', 'O4'),
        ('CAD-AI-5', 'O5'),
        ('CAD-AI-5', 'O6'),
        ('CAD-AI-5', 'O7'),
        ('CAD-AI-5', 'O8'),
        ('CAD-AI-5', 'O9'),
        ('CAD-AI-5', 'O10'),
        ('CAD-AI-5', 'O11'),
        ('CAD-AI-5', 'O12'),
        ('CAD-AI-5', 'O13'),
        ('CAD-AI-5', 'O14'),
        ('CAD-AI-5', 'D1'),
        ('CAD-AI-5', 'D2'),
        ('CAD-AI-5', 'D5'),
        ('CAD-AI-5', 'D6'),
        ('CAD-AI-5', 'D7'),
        ('CAD-AI-5', 'D8'),
        ('CAD-AI-5', 'D9'),
        ('CAD-AI-5', 'D11'),
        ('CAD-AI-5', 'C1'),
        ('CAD-AI-5', 'C2'),
        ('CAD-AI-5', 'C3'),
        ('CAD-AI-5', 'C4'),
        ('CAD-AI-5', 'C5'),
        ('CAD-CN-4', 'O1'),
        ('CAD-CN-4', 'O2'),
        ('CAD-CN-4', 'O7'),
        ('CAD-CN-4', 'D5'),
        ('CAD-CN-4', 'D7'),
        ('CAD-CN-4', 'D9'),
        ('CAD-CN-4', 'D11'),
        ('CAD-CN-4', 'C1'),
        ('CAD-CN-4', 'C2'),
        ('CAD-CN-4', 'C3'),
        ('CAD-CN-4', 'C5'),
        ('CAD-DS-4', 'O1'),
        ('CAD-DS-4', 'O2'),
        ('CAD-DS-4', 'O7'),
        ('CAD-DS-4', 'D5'),
        ('CAD-DS-4', 'D7'),
        ('CAD-DS-4', 'D9'),
        ('CAD-DS-4', 'D11'),
        ('CAD-DS-4', 'C2'),
        ('CAD-DS-4', 'C3'),
        ('CAD-DS-4', 'C4'),
        ('CAD-DS-4', 'C5'),
        ('CIP-OP-2', 'O1'),
        ('CIP-OP-2', 'O2'),
        ('CIP-OP-2', 'O6'),
        ('CIP-OP-2', 'O7'),
        ('CIP-OP-2', 'O8'),
        ('CIP-OP-2', 'O9'),
        ('CIP-OP-2', 'D5'),
        ('CIP-OP-2', 'D7'),
        ('PER-PE-2', 'O1'),
        ('PER-PE-2', 'O2'),
        ('PER-PE-2', 'O3'),
        ('PER-PE-2', 'O4'),
        ('PER-PE-2', 'O7'),
        ('PER-PE-2', 'O8'),
        ('PER-PE-2', 'O10'),
        ('PER-PE-2', 'D3'),
        ('PER-PE-2', 'D4'),
        ('PER-PE-2', 'D5'),
        ('PER-PE-2', 'D7'),
        ('PER-PE-2', 'D9'),
        ('PER-PE-2', 'D11'),
        ('PER-PE-2', 'C2'),
        ('PER-VI-3', 'O1'),
        ('PER-VI-3', 'O2'),
        ('PER-VI-3', 'O3'),
        ('PER-VI-3', 'O4'),
        ('PER-VI-3', 'O7'),
        ('PER-VI-3', 'O8'),
        ('PER-VI-3', 'O10'),
        ('PER-VI-3', 'D3'),
        ('PER-VI-3', 'D4'),
        ('PER-VI-3', 'D5'),
        ('PER-VI-3', 'D6'),
        ('PER-VI-3', 'D7'),
        ('PER-VI-3', 'D9'),
        ('PER-VI-3', 'D11'),
        ('PER-VI-3', 'D12'),
        ('PER-VI-3', 'C2'),
        ('PER-VI-3', 'C3'),
        ('PER-VI-3', 'C4'),
        ('POL-DI-2', 'O1'),
        ('POL-DI-2', 'O2'),
        ('POL-DI-2', 'O6'),
        ('POL-DI-2', 'O8'),
        ('POL-DI-2', 'D1'),
        ('POL-DI-2', 'D5'),
        ('POL-DI-2', 'D6'),
        ('POL-DI-2', 'D7'),
        ('POL-IN-2', 'O1'),
        ('POL-IN-2', 'O2'),
        ('POL-IN-2', 'O3'),
        ('POL-IN-2', 'O4'),
        ('POL-IN-2', 'O5'),
        ('POL-IN-2', 'O6'),
        ('POL-IN-2', 'O7'),
        ('POL-IN-2', 'O8'),
        ('POL-IN-2', 'O9'),
        ('POL-IN-2', 'O10'),
        ('POL-IN-2', 'O12'),
        ('POL-IN-2', 'D1'),
        ('POL-IN-2', 'D2'),
        ('POL-IN-2', 'D5'),
        ('POL-IN-2', 'D7'),
        ('POL-IN-2', 'D9'),
        ('POL-IN-2', 'D11'),
        ('POL-IN-2', 'C2'),
        ('POL-IN-3', 'O1'),
        ('POL-IN-3', 'O2'),
        ('POL-IN-3', 'O3'),
        ('POL-IN-3', 'O4'),
        ('POL-IN-3', 'O5'),
        ('POL-IN-3', 'O6'),
        ('POL-IN-3', 'O7'),
        ('POL-IN-3', 'O8'),
        ('POL-IN-3', 'O9'),
        ('POL-IN-3', 'O10'),
        ('POL-IN-3', 'O11'),
        ('POL-IN-3', 'O12'),
        ('POL-IN-3', 'O13'),
        ('POL-IN-3', 'O14'),
        ('POL-IN-3', 'D1'),
        ('POL-IN-3', 'D2'),
        ('POL-IN-3', 'D5'),
        ('POL-IN-3', 'D7'),
        ('POL-IN-3', 'D9'),
        ('POL-IN-3', 'D11'),
        ('POL-IN-3', 'C2'),
        ('POL-JE-3', 'O1'),
        ('POL-JE-3', 'O2'),
        ('POL-JE-3', 'O3'),
        ('POL-JE-3', 'O4'),
        ('POL-JE-3', 'O5'),
        ('POL-JE-3', 'O7'),
        ('POL-JE-3', 'O8'),
        ('POL-JE-3', 'O10'),
        ('POL-JE-3', 'O12'),
        ('POL-JE-3', 'O13'),
        ('POL-JE-3', 'O14'),
        ('POL-JE-3', 'D1'),
        ('POL-JE-3', 'D2'),
        ('POL-JE-3', 'D5'),
        ('POL-JE-3', 'D6'),
        ('POL-JE-3', 'D7'),
        ('POL-JE-3', 'D8'),
        ('POL-JE-3', 'D9'),
        ('POL-JE-3', 'D11'),
        ('POL-JE-3', 'C1'),
        ('POL-JE-3', 'C2'),
        ('POL-JE-3', 'C3'),
        ('POL-JE-3', 'C4'),
        ('SOP-DB-2', 'O1'),
        ('SOP-DB-2', 'C2'),
        ('SOP-DB-2', 'C3'),
        ('SOP-DB-2', 'C5'),
        ('SOP-DB-2', 'M2'),
        ('SOP-DE-2', 'O1'),
        ('SOP-DE-2', 'D5'),
        ('SOP-DE-2', 'C2'),
        ('SOP-DE-2', 'C3'),
        ('SOP-DE-2', 'C5'),
        ('SOP-DE-2', 'M1'),
        ('SOP-DE-2', 'M2'),
        ('SOP-DE-2', 'M3'),
        ('SOP-MA-2', 'O1'),
        ('SOP-MA-2', 'D5'),
        ('SOP-MA-2', 'C2'),
        ('SOP-MA-2', 'C3'),
        ('SOP-MA-2', 'C5'),
        ('SOP-MA-2', 'M1'),
        ('VIS-CO-1', 'O1'),
        ('VIS-CO-1', 'D5'),
        ('VIS-CO-1', 'D7')
    ) AS v(claim_code, codigo_funcion)
    INNER JOIN [auth].[perfil_rol] pr   ON pr.claim_code      = v.claim_code
    INNER JOIN [auth].[permiso]    perm ON perm.codigo_funcion = v.codigo_funcion
) AS src
ON tgt.id_perfil_rol = src.id_perfil_rol
   AND tgt.id_permiso = src.id_permiso
WHEN NOT MATCHED THEN
    INSERT (id_perfil_rol, id_permiso)
    VALUES (src.id_perfil_rol, src.id_permiso);
-- Nota: no hay WHEN MATCHED porque la tabla solo tiene las dos FKs (no hay
-- atributos a actualizar). Si se quiere hacer "limpieza" de asignaciones
-- removidas del seed, agregar:
--   WHEN NOT MATCHED BY SOURCE THEN DELETE;
-- (omitido por seguridad: evita borrar asignaciones manuales hechas por
-- admins en producción).
GO


-- =============================================================================
-- FIN — R__auth_seeds
-- =============================================================================
-- Validación recomendada (después de ejecutar):
--   SELECT COUNT(*) FROM [auth].[perfil];               -- esperado: 7
--   SELECT COUNT(*) FROM [auth].[rol];                  -- esperado: 15
--   SELECT COUNT(*) FROM [auth].[nivel_seguridad];      -- esperado: 5
--   SELECT COUNT(*) FROM [auth].[permiso];              -- esperado: 34
--   SELECT COUNT(*) FROM [auth].[perfil_rol];           -- esperado: 16
--   SELECT COUNT(*) FROM [auth].[perfil_rol_permiso];   -- esperado: 229
-- =============================================================================
