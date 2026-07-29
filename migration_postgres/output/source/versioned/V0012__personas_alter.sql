
-- 1. codigo_sii NOT NULL
ALTER TABLE personas.cat_ocupacion 
    ALTER COLUMN codigo_sii NVARCHAR(10) NOT NULL;
GO

-- 2. codigo_sii UNIQUE
ALTER TABLE personas.cat_ocupacion 
    ADD CONSTRAINT uk_cat_ocupacion_codigo_sii UNIQUE (codigo_sii);
GO

-- 3. Columna activo con DEFAULT 1 y CHECK (0,1)
ALTER TABLE personas.cat_ocupacion 
    ADD activo SMALLINT NOT NULL 
        CONSTRAINT df_cat_ocupacion_activo DEFAULT 1
        CONSTRAINT ck_cat_ocupacion_activo CHECK (activo IN (0, 1));
GO