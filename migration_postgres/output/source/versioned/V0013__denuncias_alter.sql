-- =============================================================================
--
-- Cambios derivados del análisis de la pantalla PNT03.02.02
-- (Antecedentes del delito, secciones 1 y 2).
--
-- Contenido:
--   PARTE A: Catálogos de denuncias para "Lugar" y "Detalle del lugar"
--     - denuncias.cat_lugar_recepcion_denuncia (cuartel/terreno)
--     - denuncias.cat_detalle_lugar_recepcion_denuncia (FK al lugar padre)
--     - denuncia.id_detalle_lugar_recepcion_denuncia (única FK al detalle)
--
--   PARTE B: Reestructuración de fecha/hora del hecho para soportar rangos
--     - DROP fecha_ocurrencia_aproximada y hora_ocurrencia_ajustada (no documentados)
--     - DROP fecha_ocurrencia (DATETIME2)
--     - ADD fecha_ocurrencia_inicio + fecha_ocurrencia_fin (DATE)
--     - ADD hora_ocurrencia_inicio + hora_ocurrencia_fin (TIME(0))
--     - CHECKs de coherencia (fin >= inicio)
--
--   PARTE C: Nuevos campos Sí/No en denuncia
--     - puede_reconocer_imputado SMALLINT NOT NULL (CHECK 0/1)
--     - teme_por_seguridad SMALLINT NOT NULL (CHECK 0/1)
--
--   PARTE D: Nuevos campos en lugar_base (sección 2 de la pantalla)
--     - intercepta_con NVARCHAR(200) (calle que intersecta, RN17.3)
--     - villa_poblacion NVARCHAR(100) (nombre de villa o población)
--     - direccion_exacta SMALLINT NOT NULL (CHECK 0/1)
--
--   PARTE E: Catalogación de tipo_organismo y nivel + FK fiscalía en denuncia
--     - Crea organizacion.cat_tipo_organismo (catálogo)
--     - Crea organizacion.cat_nivel_organismo (catálogo)
--     - Reemplaza tipo_organismo y nivel (string libre) por FK
--     - Agrega denuncia.id_organismo_fiscalia (FK a cat_organismo_externo)
--
-- Pre-requisito para PARTE E: ejecutar R__organizacion_seed_01.sql DESPUÉS
-- de aplicar este V0013, ya que los nuevos FKs son NOT NULL pero al inicio
-- los catálogos están vacíos. Como cat_organismo_externo tampoco tiene datos,
-- esto no causa fallas durante el ALTER.
--
-- Decisión de tipos:
--   La fecha/hora del hecho es información reportada por el denunciante en
--   hora local Chile. Por eso usa DATE + TIME (sin zona), distinto de los
--   timestamps del sistema (que siguen siendo DATETIME2 UTC).
--
-- Pre-requisito: tablas transaccionales (denuncia, hecho) deben estar vacías,
-- ya que se hacen DROP de columnas y ADD de columnas NOT NULL sin DEFAULT.
-- =============================================================================

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

BEGIN TRANSACTION;
GO

-- =============================================================================
-- PARTE A: Catálogos de lugar de recepción de la denuncia
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla padre: denuncias.cat_lugar_recepcion_denuncia
-- Valores esperados: cuartel / terreno
-- -----------------------------------------------------------------------------
CREATE TABLE [denuncias].[cat_lugar_recepcion_denuncia](
    [id_lugar_recepcion_denuncia] [int] IDENTITY(1,1) NOT NULL,
    [codigo] [nvarchar](20) NOT NULL,
    [descripcion] [nvarchar](100) NOT NULL,
    [activo] [smallint] NOT NULL CONSTRAINT [df_cat_lugar_recepcion_denuncia_activo] DEFAULT 1,
    CONSTRAINT [pk_cat_lugar_recepcion_denuncia] PRIMARY KEY CLUSTERED ([id_lugar_recepcion_denuncia] ASC),
    CONSTRAINT [uq_cat_lugar_recepcion_denuncia_codigo] UNIQUE NONCLUSTERED ([codigo] ASC),
    CONSTRAINT [ck_cat_lugar_recepcion_denuncia_activo] CHECK ([activo] IN (0, 1))
);
GO

-- -----------------------------------------------------------------------------
-- Tabla hija: denuncias.cat_detalle_lugar_recepcion_denuncia
-- Valores esperados: oficina, vía pública, domicilio, comercio, etc.
-- Cada lugar incluye un detalle "Sin informar" para cuando no se especifica.
-- -----------------------------------------------------------------------------
CREATE TABLE [denuncias].[cat_detalle_lugar_recepcion_denuncia](
    [id_detalle_lugar_recepcion_denuncia] [int] IDENTITY(1,1) NOT NULL,
    [id_lugar_recepcion_denuncia] [int] NOT NULL,
    [codigo] [nvarchar](20) NOT NULL,
    [descripcion] [nvarchar](100) NOT NULL,
    [activo] [smallint] NOT NULL CONSTRAINT [df_cat_detalle_lugar_recepcion_denuncia_activo] DEFAULT 1,
    CONSTRAINT [pk_cat_detalle_lugar_recepcion_denuncia] PRIMARY KEY CLUSTERED ([id_detalle_lugar_recepcion_denuncia] ASC),
    CONSTRAINT [uq_cat_detalle_lugar_recepcion_denuncia_codigo] UNIQUE NONCLUSTERED ([codigo] ASC),
    CONSTRAINT [ck_cat_detalle_lugar_recepcion_denuncia_activo] CHECK ([activo] IN (0, 1)),
    CONSTRAINT [fk_cat_detalle_lugar_recepcion_lugar] FOREIGN KEY ([id_lugar_recepcion_denuncia])
        REFERENCES [denuncias].[cat_lugar_recepcion_denuncia] ([id_lugar_recepcion_denuncia])
);
GO

-- -----------------------------------------------------------------------------
-- Modificación: denuncias.denuncia
-- Una sola FK al detalle. El lugar padre se infiere navegando vía JOIN.
-- NULL-able para soportar borradores y migraciones desde sistemas externos.
-- -----------------------------------------------------------------------------
ALTER TABLE [denuncias].[denuncia]
    ADD [id_detalle_lugar_recepcion_denuncia] [int] NULL;
GO

ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT [fk_denuncia_detalle_lugar_recepcion]
    FOREIGN KEY ([id_detalle_lugar_recepcion_denuncia])
    REFERENCES [denuncias].[cat_detalle_lugar_recepcion_denuncia] ([id_detalle_lugar_recepcion_denuncia]);
GO

-- =============================================================================
-- PARTE B: Reestructuración de fecha/hora del hecho
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Drop CHECK + DEFAULT + columna fecha_ocurrencia_aproximada
-- -----------------------------------------------------------------------------
ALTER TABLE [investigacion].[hecho] DROP CONSTRAINT [ck_hecho_fecha_ocurrencia_aproximada];
GO
ALTER TABLE [investigacion].[hecho] DROP CONSTRAINT [df_hecho_fecha_ocurrencia_aproximada];
GO
ALTER TABLE [investigacion].[hecho] DROP COLUMN [fecha_ocurrencia_aproximada];
GO

-- -----------------------------------------------------------------------------
-- 2. Drop CHECK + DEFAULT + columna hora_ocurrencia_ajustada
-- -----------------------------------------------------------------------------
ALTER TABLE [investigacion].[hecho] DROP CONSTRAINT [ck_hecho_hora_ocurrencia_ajustada];
GO
ALTER TABLE [investigacion].[hecho] DROP CONSTRAINT [df_hecho_hora_ocurrencia_ajustada];
GO
ALTER TABLE [investigacion].[hecho] DROP COLUMN [hora_ocurrencia_ajustada];
GO

-- -----------------------------------------------------------------------------
-- 3. Drop columna fecha_ocurrencia (DATETIME2)
-- -----------------------------------------------------------------------------
ALTER TABLE [investigacion].[hecho] DROP COLUMN [fecha_ocurrencia];
GO

-- -----------------------------------------------------------------------------
-- 4. Agregar columnas de rango: fecha (DATE) y hora (TIME(0)) separadas
-- -----------------------------------------------------------------------------
ALTER TABLE [investigacion].[hecho]
    ADD [fecha_ocurrencia_inicio] [date]    NULL,
        [fecha_ocurrencia_fin]    [date]    NULL,
        [hora_ocurrencia_inicio]  [time](0) NULL,
        [hora_ocurrencia_fin]     [time](0) NULL;
GO

-- -----------------------------------------------------------------------------
-- 5. CHECKs de coherencia
-- Reglas:
--   a) Si hay fecha_fin, debe haber fecha_inicio y fecha_fin >= fecha_inicio
--   b) Si hay hora_fin, debe haber hora_inicio y hora_fin >= hora_inicio
-- -----------------------------------------------------------------------------
ALTER TABLE [investigacion].[hecho]
    ADD CONSTRAINT [ck_hecho_rango_fecha_coherente]
    CHECK (
        [fecha_ocurrencia_fin] IS NULL
        OR ([fecha_ocurrencia_inicio] IS NOT NULL AND [fecha_ocurrencia_fin] >= [fecha_ocurrencia_inicio])
    );
GO

ALTER TABLE [investigacion].[hecho]
    ADD CONSTRAINT [ck_hecho_rango_hora_coherente]
    CHECK (
        [hora_ocurrencia_fin] IS NULL
        OR ([hora_ocurrencia_inicio] IS NOT NULL AND [hora_ocurrencia_fin] >= [hora_ocurrencia_inicio])
    );
GO

-- =============================================================================
-- PARTE C: Nuevos campos Sí/No en denuncia
-- =============================================================================

ALTER TABLE [denuncias].[denuncia]
    ADD [puede_reconocer_imputado] [smallint] NOT NULL,
        [teme_por_seguridad]       [smallint] NOT NULL;
GO

ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT [ck_denuncia_puede_reconocer_imputado] CHECK ([puede_reconocer_imputado] IN (0, 1));
GO

ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT [ck_denuncia_teme_por_seguridad] CHECK ([teme_por_seguridad] IN (0, 1));
GO

-- =============================================================================
-- PARTE D: Nuevos campos en ubicacion.lugar_base (sección 2 de la pantalla)
-- =============================================================================

ALTER TABLE [ubicacion].[lugar_base]
    ADD [intercepta_con]    [nvarchar](200) NULL,
        [villa_poblacion]   [nvarchar](100) NULL,
        [direccion_exacta]  [smallint]      NOT NULL;
GO

ALTER TABLE [ubicacion].[lugar_base]
    ADD CONSTRAINT [ck_lugar_base_direccion_exacta] CHECK ([direccion_exacta] IN (0, 1));
GO

-- =============================================================================
-- PARTE E: Catalogación de tipo_organismo y nivel + FK fiscalía en denuncia
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: organizacion.cat_tipo_organismo
-- Valores esperados (poblar en R__organizacion_seed_01.sql):
--   POLICIA, FISCALIA, TRIBUNAL, LABORATORIO, AGENCIA_GOB, INT_INTERNACIONAL, OTRO
-- -----------------------------------------------------------------------------
CREATE TABLE [organizacion].[cat_tipo_organismo](
    [id_tipo_organismo] [int] IDENTITY(1,1) NOT NULL,
    [codigo] [nvarchar](30) NOT NULL,
    [descripcion] [nvarchar](100) NOT NULL,
    [activo] [smallint] NOT NULL CONSTRAINT [df_cat_tipo_organismo_activo] DEFAULT 1,
    CONSTRAINT [pk_cat_tipo_organismo] PRIMARY KEY CLUSTERED ([id_tipo_organismo] ASC),
    CONSTRAINT [uq_cat_tipo_organismo_codigo] UNIQUE NONCLUSTERED ([codigo] ASC),
    CONSTRAINT [ck_cat_tipo_organismo_activo] CHECK ([activo] IN (0, 1))
);
GO

-- -----------------------------------------------------------------------------
-- Tabla: organizacion.cat_nivel_organismo
-- Valores esperados (poblar en R__organizacion_seed_01.sql):
--   NACIONAL, REGIONAL, INTERNACIONAL
-- -----------------------------------------------------------------------------
CREATE TABLE [organizacion].[cat_nivel_organismo](
    [id_nivel_organismo] [int] IDENTITY(1,1) NOT NULL,
    [codigo] [nvarchar](20) NOT NULL,
    [descripcion] [nvarchar](100) NOT NULL,
    [activo] [smallint] NOT NULL CONSTRAINT [df_cat_nivel_organismo_activo] DEFAULT 1,
    CONSTRAINT [pk_cat_nivel_organismo] PRIMARY KEY CLUSTERED ([id_nivel_organismo] ASC),
    CONSTRAINT [uq_cat_nivel_organismo_codigo] UNIQUE NONCLUSTERED ([codigo] ASC),
    CONSTRAINT [ck_cat_nivel_organismo_activo] CHECK ([activo] IN (0, 1))
);
GO

-- -----------------------------------------------------------------------------
-- Reemplazar columnas string libres por FKs en cat_organismo_externo
-- Drop directo + add NOT NULL es seguro porque cat_organismo_externo está vacía.
-- La columna 'nivel' tiene DEFAULT 'NACIONAL' que debe dropearse primero.
-- -----------------------------------------------------------------------------
ALTER TABLE [organizacion].[cat_organismo_externo] DROP COLUMN [tipo_organismo];
GO

ALTER TABLE [organizacion].[cat_organismo_externo] DROP CONSTRAINT [df_cat_organismo_externo_nivel];
GO
ALTER TABLE [organizacion].[cat_organismo_externo] DROP COLUMN [nivel];
GO

ALTER TABLE [organizacion].[cat_organismo_externo]
    ADD [id_tipo_organismo]  [int] NOT NULL,
        [id_nivel_organismo] [int] NOT NULL;
GO

ALTER TABLE [organizacion].[cat_organismo_externo]
    ADD CONSTRAINT [fk_cat_organismo_externo_tipo]
    FOREIGN KEY ([id_tipo_organismo])
    REFERENCES [organizacion].[cat_tipo_organismo] ([id_tipo_organismo]);
GO

ALTER TABLE [organizacion].[cat_organismo_externo]
    ADD CONSTRAINT [fk_cat_organismo_externo_nivel]
    FOREIGN KEY ([id_nivel_organismo])
    REFERENCES [organizacion].[cat_nivel_organismo] ([id_nivel_organismo]);
GO

-- -----------------------------------------------------------------------------
-- Modificación: denuncias.denuncia
-- Nueva FK al subconjunto de organismos con tipo='FISCALIA' (filtrado en UI).
-- NULL-able porque la fiscalía puede no estar definida al momento del ingreso.
-- -----------------------------------------------------------------------------
ALTER TABLE [denuncias].[denuncia]
    ADD [id_organismo_fiscalia] [int] NULL;
GO

ALTER TABLE [denuncias].[denuncia]
    ADD CONSTRAINT [fk_denuncia_organismo_fiscalia]
    FOREIGN KEY ([id_organismo_fiscalia])
    REFERENCES [organizacion].[cat_organismo_externo] ([id_organismo_externo]);
GO

-- =============================================================================
-- DESCRIPCIONES (Extended Properties)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: denuncias.cat_lugar_recepcion_denuncia
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Catálogo de lugares de recepción de la denuncia (cuartel/terreno). Indica la modalidad física donde el funcionario PDI tomó la denuncia. No confundir con ubicacion.lugar (sitio del suceso).', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_lugar_recepcion_denuncia';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del lugar de recepción. Clave primaria autoincremental.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'id_lugar_recepcion_denuncia';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código corto del lugar de recepción. Único. Ej: CUARTEL, TERRENO.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'codigo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción del lugar de recepción para mostrar en UI. Ej: Cuartel, Terreno.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'descripcion';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = lugar vigente, disponible para selección. 0 = lugar deshabilitado. CHECK IN (0,1).', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'activo';
GO

-- -----------------------------------------------------------------------------
-- Tabla: denuncias.cat_detalle_lugar_recepcion_denuncia
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Catálogo de detalles del lugar de recepción de la denuncia. Cada detalle pertenece a un lugar específico (FK a cat_lugar_recepcion_denuncia). Ej: bajo Cuartel = Oficina, Sala de atención. Bajo Terreno = Vía pública, Domicilio, Comercio.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_detalle_lugar_recepcion_denuncia';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del detalle del lugar de recepción. Clave primaria autoincremental.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_detalle_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'id_detalle_lugar_recepcion_denuncia';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK al lugar padre (cuartel/terreno). Determina bajo qué lugar de recepción se clasifica este detalle.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_detalle_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'id_lugar_recepcion_denuncia';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código corto del detalle. Único en toda la tabla. Ej: CUARTEL_OFICINA, TERRENO_VIA_PUBLICA, CUARTEL_SIN_INFORMAR.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_detalle_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'codigo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción del detalle para mostrar en UI. Ej: Oficina, Vía pública, Domicilio, Sin informar.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_detalle_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'descripcion';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = detalle vigente, disponible para selección. 0 = detalle deshabilitado. CHECK IN (0,1).', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'cat_detalle_lugar_recepcion_denuncia', @level2type=N'COLUMN',@level2name=N'activo';
GO

-- -----------------------------------------------------------------------------
-- Columnas nuevas en denuncias.denuncia
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK a denuncias.cat_detalle_lugar_recepcion_denuncia. Detalle del lugar donde se recibió la denuncia (oficina, vía pública, domicilio, etc.). El lugar padre (cuartel/terreno) se infiere navegando al catálogo de detalle. NULL en borradores o migraciones.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'denuncia', @level2type=N'COLUMN',@level2name=N'id_detalle_lugar_recepcion_denuncia';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica si el denunciante puede reconocer al imputado. 1 = sí, 0 = no. Cuando es 1, los campos de descripción del imputado pasan a obligatorios (RN19.5).', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'denuncia', @level2type=N'COLUMN',@level2name=N'puede_reconocer_imputado';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica si el denunciante teme por su seguridad personal o de su familia. 1 = sí, 0 = no. Información sensible para protocolos de protección a víctimas y testigos.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'denuncia', @level2type=N'COLUMN',@level2name=N'teme_por_seguridad';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK a organizacion.cat_organismo_externo. Identifica la fiscalía competente para tramitar el caso ante el Ministerio Público. La UI filtra por tipo_organismo=FISCALIA. NULL cuando aún no se ha definido.', @level0type=N'SCHEMA',@level0name=N'denuncias', @level1type=N'TABLE',@level1name=N'denuncia', @level2type=N'COLUMN',@level2name=N'id_organismo_fiscalia';
GO

-- -----------------------------------------------------------------------------
-- Columnas modificadas en investigacion.hecho
-- (Se eliminaron: fecha_ocurrencia, fecha_ocurrencia_aproximada, hora_ocurrencia_ajustada)
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fecha de ocurrencia del hecho según declaración del denunciante. Si hay rango, representa el inicio. Tipo DATE sin zona (hora local Chile, no UTC) por ser información reportada por humano. NULL si se desconoce.', @level0type=N'SCHEMA',@level0name=N'investigacion', @level1type=N'TABLE',@level1name=N'hecho', @level2type=N'COLUMN',@level2name=N'fecha_ocurrencia_inicio';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fecha de fin del rango de ocurrencia del hecho. Solo se llena cuando el denunciante reporta un rango ("entre el 5 y el 8 de octubre"). NULL cuando la fecha es exacta.', @level0type=N'SCHEMA',@level0name=N'investigacion', @level1type=N'TABLE',@level1name=N'hecho', @level2type=N'COLUMN',@level2name=N'fecha_ocurrencia_fin';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hora de ocurrencia del hecho según declaración del denunciante. Si hay rango horario, representa el inicio. Tipo TIME sin zona (hora local Chile). NULL si se desconoce.', @level0type=N'SCHEMA',@level0name=N'investigacion', @level1type=N'TABLE',@level1name=N'hecho', @level2type=N'COLUMN',@level2name=N'hora_ocurrencia_inicio';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hora de fin del rango de ocurrencia del hecho. Solo se llena cuando el denunciante reporta un rango horario ("entre las 14 y las 18"). NULL cuando la hora es exacta.', @level0type=N'SCHEMA',@level0name=N'investigacion', @level1type=N'TABLE',@level1name=N'hecho', @level2type=N'COLUMN',@level2name=N'hora_ocurrencia_fin';
GO

-- -----------------------------------------------------------------------------
-- Columnas nuevas en ubicacion.lugar_base
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Calle que intersecta con la calle principal del lugar. Útil para localización por intersección cuando no hay número (RN17.3). Ej: "Pedro de Valdivia" si la calle principal es "Providencia".', @level0type=N'SCHEMA',@level0name=N'ubicacion', @level1type=N'TABLE',@level1name=N'lugar_base', @level2type=N'COLUMN',@level2name=N'intercepta_con';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre de villa, población o conjunto habitacional. Texto libre. Ej: Villa Los Naranjos, Población La Pincoya, Condominio Las Condes.', @level0type=N'SCHEMA',@level0name=N'ubicacion', @level1type=N'TABLE',@level1name=N'lugar_base', @level2type=N'COLUMN',@level2name=N'villa_poblacion';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica si la dirección registrada es exacta. 1 = exacta, 0 = aproximada. CHECK IN (0,1).', @level0type=N'SCHEMA',@level0name=N'ubicacion', @level1type=N'TABLE',@level1name=N'lugar_base', @level2type=N'COLUMN',@level2name=N'direccion_exacta';
GO

-- -----------------------------------------------------------------------------
-- Tabla: organizacion.cat_tipo_organismo
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Catálogo de tipos de organismo externo. Clasifica funcionalmente los organismos: POLICIA, FISCALIA, TRIBUNAL, LABORATORIO, AGENCIA_GOB, INT_INTERNACIONAL, OTRO. Reemplaza la columna string libre tipo_organismo NVARCHAR(30) que existía previamente en cat_organismo_externo.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_tipo_organismo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del tipo de organismo. Clave primaria autoincremental.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_tipo_organismo', @level2type=N'COLUMN',@level2name=N'id_tipo_organismo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código corto del tipo de organismo. Único. Valores: POLICIA, FISCALIA, TRIBUNAL, LABORATORIO, AGENCIA_GOB, INT_INTERNACIONAL, OTRO.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_tipo_organismo', @level2type=N'COLUMN',@level2name=N'codigo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción del tipo de organismo para mostrar en UI. Ej: Policía, Fiscalía, Tribunal.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_tipo_organismo', @level2type=N'COLUMN',@level2name=N'descripcion';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = tipo vigente, disponible para selección. 0 = tipo deshabilitado. CHECK IN (0,1).', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_tipo_organismo', @level2type=N'COLUMN',@level2name=N'activo';
GO

-- -----------------------------------------------------------------------------
-- Tabla: organizacion.cat_nivel_organismo
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Catálogo de niveles de alcance territorial de los organismos: NACIONAL, REGIONAL, INTERNACIONAL. Reemplaza la columna string libre nivel NVARCHAR(20) que existía previamente en cat_organismo_externo.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_nivel_organismo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del nivel. Clave primaria autoincremental.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_nivel_organismo', @level2type=N'COLUMN',@level2name=N'id_nivel_organismo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código corto del nivel. Único. Valores: NACIONAL, REGIONAL, INTERNACIONAL.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_nivel_organismo', @level2type=N'COLUMN',@level2name=N'codigo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción del nivel para mostrar en UI. Ej: Nacional, Regional, Internacional.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_nivel_organismo', @level2type=N'COLUMN',@level2name=N'descripcion';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = nivel vigente, disponible para selección. 0 = nivel deshabilitado. CHECK IN (0,1).', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_nivel_organismo', @level2type=N'COLUMN',@level2name=N'activo';
GO

-- -----------------------------------------------------------------------------
-- Columnas reemplazadas en organizacion.cat_organismo_externo
-- -----------------------------------------------------------------------------
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK a organizacion.cat_tipo_organismo. Clasificación funcional del organismo. Reemplaza la columna string libre tipo_organismo NVARCHAR(30) anterior. Permite filtrar por tipo según contexto de uso (ej: filtrar fiscalías para el dropdown de denuncia.id_organismo_fiscalia).', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_organismo_externo', @level2type=N'COLUMN',@level2name=N'id_tipo_organismo';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK a organizacion.cat_nivel_organismo. Alcance territorial del organismo. Reemplaza la columna string libre nivel NVARCHAR(20) anterior.', @level0type=N'SCHEMA',@level0name=N'organizacion', @level1type=N'TABLE',@level1name=N'cat_organismo_externo', @level2type=N'COLUMN',@level2name=N'id_nivel_organismo';
GO

COMMIT TRANSACTION;
GO
