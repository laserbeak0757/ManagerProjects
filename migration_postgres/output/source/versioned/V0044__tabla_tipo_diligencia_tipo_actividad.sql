-- =============================================================================
-- V0044 -- Creacion tabla tipo_diligencia_tipo_actividad
-- PDI Chile -- SIP. SQL Server. Flyway.
-- =============================================================================
-- 1. Crear relación diligencias.tipo_diligencia_tipo_actividad
-- =============================================================================

CREATE TABLE [diligencias].[tipo_diligencia_tipo_actividad] (
    [id_diligencia_actividad]       [int]          IDENTITY(1,1) NOT NULL,
    [id_tipo_diligencia]            [int]                        NOT NULL,
    [id_tipo_actividad]             [int]                        NOT NULL,
    [activo]                        [bit]                        NOT NULL
        CONSTRAINT [df_tipo_diligencia_tipo_actividad_activo] DEFAULT (1),
    [id_usuario_creador]            [int]                        NULL,
    [id_usuario_modificador]        [int]                        NULL,
    [id_usuario_eliminador]         [int]                        NULL,
    [fecha_creacion]                [datetime2](7)               NULL,
    [fecha_actualizacion]           [datetime2](7)               NULL,
    CONSTRAINT [pk_tipo_diligencia_tipo_actividad]
        PRIMARY KEY CLUSTERED ([id_diligencia_actividad] ASC),
    CONSTRAINT [uq_tipo_diligencia_tipo_actividad]
        UNIQUE NONCLUSTERED ([id_tipo_diligencia], [id_tipo_actividad]),
    CONSTRAINT [fk_tipo_diligencia_tipo_actividad_tipo_diligencia]
        FOREIGN KEY ([id_tipo_diligencia])
        REFERENCES [diligencias].[cat_tipo_diligencia] ([id_tipo_diligencia]),
    CONSTRAINT [fk_tipo_diligencia_tipo_actividad_tipo_actividad]
        FOREIGN KEY ([id_tipo_actividad])
        REFERENCES [diligencias].[cat_tipo_actividad] ([id_tipo_actividad])
) ON [PRIMARY]
GO