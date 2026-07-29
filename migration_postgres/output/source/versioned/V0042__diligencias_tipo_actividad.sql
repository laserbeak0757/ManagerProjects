-- =============================================================================
-- V0042 -- Cambio de tipo_actividad en diligencias.actividad_investigativa
-- PDI Chile -- SIP. SQL Server. Flyway.
--
-- 1. Crea el catálogo diligencias.cat_tipo_actividad (estructura basada en
--    cat_estado_diligencia).
-- 2. Elimina la columna tipo_actividad (nvarchar) de actividad_investigativa.
-- 3. Agrega la columna id_tipo_actividad (int NOT NULL) con FK al nuevo catálogo.
-- =============================================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

-- =============================================================================
-- 1. Crear catálogo diligencias.cat_tipo_actividad
-- =============================================================================

CREATE TABLE [diligencias].[cat_tipo_actividad] (
    [id_tipo_actividad]          [int]           IDENTITY(1,1)  NOT NULL,
    [codigo]                     [nvarchar](20)                 NOT NULL,
    [nombre]                     [nvarchar](100)                NOT NULL,
    [id_usuario_modificador]     [int]                          NULL,
    [id_usuario_eliminador]      [int]                          NULL,
    [fecha_creacion]             [datetime2](7)                 NULL,
    [fecha_actualizacion]        [datetime2](7)                 NULL,
    [fecha_eliminacion_logica]   [datetime2](7)                 NULL,
    CONSTRAINT [pk_cat_tipo_actividad] PRIMARY KEY CLUSTERED
    (
        [id_tipo_actividad] ASC
    ) WITH (
        PAD_INDEX               = OFF,
        STATISTICS_NORECOMPUTE  = OFF,
        IGNORE_DUP_KEY          = OFF,
        ALLOW_ROW_LOCKS         = ON,
        ALLOW_PAGE_LOCKS        = ON
    ) ON [PRIMARY]
) ON [PRIMARY]
GO

-- =============================================================================
-- 2. Modificar diligencias.actividad_investigativa
--    Reemplazar tipo_actividad (nvarchar) por id_tipo_actividad (int FK)
-- =============================================================================

ALTER TABLE [diligencias].[actividad_investigativa]
    DROP COLUMN [tipo_actividad]
GO

ALTER TABLE [diligencias].[actividad_investigativa]
    ADD [id_tipo_actividad] [int] NOT NULL
GO

ALTER TABLE [diligencias].[actividad_investigativa]
    ADD CONSTRAINT [fk_actividad_investigativa_tipo_actividad]
    FOREIGN KEY ([id_tipo_actividad])
    REFERENCES [diligencias].[cat_tipo_actividad] ([id_tipo_actividad])
GO
