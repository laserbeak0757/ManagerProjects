SET NOCOUNT ON;

GO
-- SECCION 1: I. CATÁLOGO DE DELITOS

IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_seccion_catalogo
    WHERE nombre = N'I. CATÁLOGO DE DELITOS'
)
BEGIN
    INSERT INTO investigacion.cat_seccion_catalogo (
        nombre,
        descripcion
    )
    VALUES (
        N'I. CATÁLOGO DE DELITOS',
        N'I. CATÁLOGO DE DELITOS'
    );
END;

DECLARE @id_seccion_1 INT;

SELECT @id_seccion_1 = id_seccion_catalogo
FROM investigacion.cat_seccion_catalogo
WHERE nombre = N'I. CATÁLOGO DE DELITOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'CUASIDELITOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'CUASIDELITOS'
    );
END;

DECLARE @id_familia_1_1_CUASIDELITOS INT;

SELECT @id_familia_1_1_CUASIDELITOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'CUASIDELITOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 901
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        901,
        N'CUASIDELITO DE LESIONES. ART 490, 491 INC 2° Y 492.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 905
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        905,
        N'CUASIDELITO DE HOMICIDIO. CÓDIGO AGRUPADOR. ART. 492 INC. 2º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 910
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        910,
        N'CUASIDELITO DE LESIONES COMETIDOS POR PROFES. DE LA SALUD',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 911
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        911,
        N'CUASIDELITO DE HOMICIDIO COMETIDO POR PROFES. DE LA SALUD',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 999
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        999,
        N'OTROS DE LOS CUASIDELITOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_1_CUASIDELITOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (901,905,910,911,999)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS CONTRA LA FE PÚBLICA'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS CONTRA LA FE PÚBLICA'
    );
END;

DECLARE @id_familia_1_2_DELITOS_CONTRA_LA_FE_PUBLICA INT;

SELECT @id_familia_1_2_DELITOS_CONTRA_LA_FE_PUBLICA = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS CONTRA LA FE PÚBLICA';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 301
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        301,
        N'FALSIF MONEDA (PARA BILLETES CÓD 12031). ART 162 AL 214 CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 302
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        302,
        N'FALSIFICACION O USO MALICIOSO DE DOCUMENTOS PUBLICOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 303
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        303,
        N'FALSIFICACIÓN O USO MALICIOSO DE DOC. PRIVADOS ART.197 Y 198',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 304
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        304,
        N'FALSIFIC. O USO DE PASAP. O PERM. PORTE ARMAS ARTS. 199-201',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 306
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        306,
        N'FALSO TEST, PERJURIO O DEN.CALUM. ART.206,209,210,211 Y 212',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 307
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        307,
        N'PRES. PERITOS, TEST O INTÉR.QUE FALTAREN A VERD.O DOC.FALSOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 308
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        308,
        N'EJERCICIO ILEGAL DE LA PROFESIÓN. ART. 213 INC 1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 309
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        309,
        N'USURPACIÓN DE NOMBRE. ART. 214.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 310
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        310,
        N'FINGIMIENTO DE CARGOS O PROFESIONES. ART. 213 INC. 2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 311
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        311,
        N'FALSIFICACION DE LICENCIAS MEDICAS O PENSIONES ART 202',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 312
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        312,
        N'FALSIFICACION DE CERTIFICADOS POR FFPP, PRIV Y USO MALICIOSO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 399
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        399,
        N'OTROS DELITOS C/ FE PÚBLICA, FALSIFIC, FALSO TEST Y PERJURIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 405
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        405,
        N'PREVARICACIÓN DEL ABOGADO Y PROCURADOR ARTS. 231 y 232.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 502
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        502,
        N'OBSTRUCCIÓN A LA INVESTIGACION. ART. 269 BIS Y 269 TER.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 503
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        503,
        N'ROTURA DE SELLOS.ARTS. 270 y 271.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 520
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        520,
        N'OBSTRC.INVSTG. PR. FISCAL. O ASIST. FISC. MIN.PUBLIC.ART269.TER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 528
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        528,
        N'CORRUPCIÓN ENTRE PARTICULARES. ART. 287 BIS Y 287 TER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 529
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        529,
        N'CORRUP. ENTRE PARTICULARES POR PERS. JURIDICA 287 BIS Y TER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 897
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        897,
        N'FALSIFIC. DOCS. TRANSP. O COMERC. MADERA. 448 OCTIES INC 2º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12031
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12031,
        N'FALSIFICACIÓN DE DINERO ART. 64 Ley 18.840 DEL BANCO CENTRAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12032
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12032,
        N'FALSIFIC. MALICIOSOSA DOCS. ART 59 LEY 18840 BANCO CENTRAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12149
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12149,
        N'DESACATO (Art. 240 Código de Procedimiento Civil)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12189
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12189,
        N'USO MALICIOSO RECETAS MÉD (ART. 1º INC. FINAL, LEY 21.267)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_2_DELITOS_CONTRA_LA_FE_PUBLICA
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (301,302,303,304,306,307,308,309,310,311,312,399,405,502,503,520,528,529,897,12031,12032,12149,12189)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS CONTRA LA LIBERTAD E INTIMIDAD DE LAS PERSONAS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS CONTRA LA LIBERTAD E INTIMIDAD DE LAS PERSONAS'
    );
END;

DECLARE @id_familia_1_3_DELITOS_CONTRA_LA_LIBERTAD_E_INTIMIDAD_DE_LAS_PERSONAS INT;

SELECT @id_familia_1_3_DELITOS_CONTRA_LA_LIBERTAD_E_INTIMIDAD_DE_LAS_PERSONAS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS CONTRA LA LIBERTAD E INTIMIDAD DE LAS PERSONAS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 202
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        202,
        N'SECUESTRO. ART. 141 INC. 1 Y 2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 203
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        203,
        N'SUSTRACCIÓN DE MENORES. ART. 142',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 204
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        204,
        N'VIOLACIÓN DE MORADA. ART. 144',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 205
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        205,
        N'APERTURA, REG. O INTERCEPTACIÓN DE CORRESP. ART.146 Y 156',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 207
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        207,
        N'DETENCION, DESTIERRO O ARRESTO IRREGULAR ART. 148',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 210
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        210,
        N'ALLANAMIENTOS IRREGULARES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 214
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        214,
        N'DELITOS C/ LA LIBERTAD AMBULATORIA Y DERECHO DE ASOCIACIÓN',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 219
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        219,
        N'PROLONGACIÓN DE INCOMUNICACIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 220
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        220,
        N'TORMENTOS A DETENIDOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 221
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        221,
        N'DELITOS C/ LA VIDA Y PRIVACIDAD DE CONVERSACIONES 161 A Y B',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 222
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        222,
        N'SECUESTRO CON HOMICIDIO, VIOLACIÓN O LES. ART.141 INC. FINAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 235
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        235,
        N'SECUESTRO CON HOMICIDIO. ART. 141 INC. FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 236
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        236,
        N'SECUESTRO CON VIOLACIÓN. ART. 141 INC. FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 237
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        237,
        N'SECUESTRO CON LESIONES. ART. 141 INC. FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 248
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        248,
        N'SECUESTRO EXIG. RESCATE O SE PROLONGUE MÁS 24 HRS. 141 INC.3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 249
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        249,
        N'SECUESTRO MÁS 15 DÍAS O GRAVE DAÑO PERSONA 141 INC. 4°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 511
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        511,
        N'AMENAZAS DE ATENTADOS CONTRA PERSONAS Y PROPIEDADES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 515
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        515,
        N'ATENTADOS Y AMENAZAS CONTRA LA AUTORIDAD. ART. 261 Nº1 Y 264',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 523
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        523,
        N'AMENAZA A FISCAL O DEFENSOR EN DESEMP. DE FUNC. ART 268 QUIN',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 524
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        524,
        N'AMENAZAS SIMPLES CONTRA PERSONAS Y PROPIEDADES ART. 296 Nº3.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 525
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        525,
        N'AMENAZAS CONDIC. CONTRA PERSONAS Y PROP. ART. 296 1 y 2, 297',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 530
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        530,
        N'AMENAZA CONTR. PROF.Y FUNC. SALUD Y MANIPULADORES ALIMENTO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 721
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        721,
        N'TRAFICO DE MIGRANTES 411 BIS INCISO 1, 2 Y 3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 723
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        723,
        N'TRATA DE PERSONAS PARA LA EXPLOTACIÓN SEXUAL ART 411 QUATER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 724
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        724,
        N'TRATA DE MENORES 18 AÑOS ART. 411 QUATER INC2°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 725
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        725,
        N'ASOC ILICTA PARA TRÁFICO Y/O TRATA PERSONAS ART411 QUINQUIES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 727
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        727,
        N'TRATA PARA TRABAJOS FORZADOS Y OTROS ART411 QUATER INC1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11004,
        N'AMENAZAR U OFENDER A FUNC DE INVESTIGACIONES. ART. 17 quáter',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11103
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11103,
        N'AMENAZA GENDARME EN DESEMP. DE FUNC. ART 15 D DL 2589',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12082
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12082,
        N'AMENAZAS A CARABINEROS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12132
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12132,
        N'INFRAC LEY GRAL TELECOM. LETRAS A, B, C, D, F, G y H (EXCL LET E)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_3_DELITOS_CONTRA_LA_LIBERTAD_E_INTIMIDAD_DE_LAS_PERSONAS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (202,203,204,205,207,210,214,219,220,221,222,235,236,237,248,249,511,515,523,524,525,530,721,723,724,725,727,11004,11103,12082,12132)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS CONTRA LEYES DE PROPIEDAD INTELECTUAL E INDUSTRIAL'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS CONTRA LEYES DE PROPIEDAD INTELECTUAL E INDUSTRIAL'
    );
END;

DECLARE @id_familia_1_4_DELITOS_CONTRA_LEYES_DE_PROPIEDAD_INTELECTUAL_E_INDUSTRIAL INT;

SELECT @id_familia_1_4_DELITOS_CONTRA_LEYES_DE_PROPIEDAD_INTELECTUAL_E_INDUSTRIAL = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS CONTRA LEYES DE PROPIEDAD INTELECTUAL E INDUSTRIAL';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 8002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        8002,
        N'DELITOS MARCARIOS ARTS. 28 Y 28 BIS LEY 19.039',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 8003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        8003,
        N'DEMÁS DELITOS CONTRA LEY DE PROPIEDAD INDUSTRIAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9002,
        N'FALSIF OBRAS PROTEGIDAS LEY PROP INTELECT ART.79 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9003,
        N'VENTA ILICITA OBRAS PROTEGIDAS LEY PROP INTELECT ART. 81',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9004,
        N'UTILIZACIÓN SIN AUTOR. DE OBRAS DE DOM. AJENO POR LEY PR.INT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9099,
        N'OTROS DELITOS CONTEMPLADOS EN LEY DE PROPIEDAD INTELECTUAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_4_DELITOS_CONTRA_LEYES_DE_PROPIEDAD_INTELECTUAL_E_INDUSTRIAL
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (8002,8003,9002,9003,9004,9099)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS DE JUSTICIA MILITAR'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS DE JUSTICIA MILITAR'
    );
END;

DECLARE @id_familia_1_5_DELITOS_DE_JUSTICIA_MILITAR INT;

SELECT @id_familia_1_5_DELITOS_DE_JUSTICIA_MILITAR = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS DE JUSTICIA MILITAR';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12087
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12087,
        N'TRAICION, ESPIONAJE ART. 244 AL 258 COD JUST MILITAR',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12088
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12088,
        N'USO UNIFORME O INSIGNIAS FFAA O CARABINEROS DE CHILE',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12089
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12089,
        N'OTRAS INFRACCIONES AL CÓDIGO JUSTICIA MILITAR',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12123
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12123,
        N'ROBO O HURTO DE MATERIAL DE GUERRA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12124
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12124,
        N'ADQUISICION MATERIAL DE GUERRA O VESTUARIO INSTIT ARMADAS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12125
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12125,
        N'FALSEDADES ART. 367 AL 371 CODIGO JUSTICIA MILITAR',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12139
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12139,
        N'INF. C. AERO 133 G, 190, 194 BIS, 195 A, 198, 200 LEY 18.916',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12203
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12203,
        N'EMPLEO DE VIOLENCIA INNECESARIA ART 330 CÓD JUSTICIA MILITAR',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_5_DELITOS_DE_JUSTICIA_MILITAR
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (12087,12088,12089,12123,12124,12125,12139,12203)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS DE LEYES ESPECIALES'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS DE LEYES ESPECIALES'
    );
END;

DECLARE @id_familia_1_6_DELITOS_DE_LEYES_ESPECIALES INT;

SELECT @id_familia_1_6_DELITOS_DE_LEYES_ESPECIALES = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS DE LEYES ESPECIALES';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 540
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        540,
        N'USO INDEBIDO FAC. TÉCNICAS ESPECIALES INV. 226 C Y K CPP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 541
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        541,
        N'INFRACCIÓN SECRETO TÉCNICAS ESPECIALES INV. 226 J, O Y T CPP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 543
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        543,
        N'INCUMPLIMIENTO RESERVA REGISTRO DE LLAMADAS ART 218 TER CPP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 548
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        548,
        N'REGISTRO DE LAS ACTUACIONES POLICIALES ART. 228 BIS C.P.P.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 550
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        550,
        N'COMERCIALIZ. DISTRIB. INSTALAR MAQ. DE JUEGOS ILEGAL ART 276',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 626
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        626,
        N'TRATA DE PERSONAS CON FINES DE PROSTITUCIÓN. ART. 367 BIS.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 627
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        627,
        N'TRATA DE PERSONAS CALIFICADA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 726
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        726,
        N'PROMOVER O FACILITAR ENTRADA O SALIDA DEL PAIS PARA PROSTIT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2001,
        N'DELITOS INFORMÁTICOS LEY N°19.223',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2002,
        N'SABOTAJE INFORMÁTICO. ARTS. 1 Y 3 LEY 19.223.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2003,
        N'ESPIONAJE INFORMÁTICO ART. 2 Y 4 LEY 19223',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2004,
        N'ATAQUE A LA INTEGRIDAD DE SIST. INFORMÁTICO ART 1 LEY 21459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2005,
        N'ACCESO ILÍCITO ART. 2 LEY 21.459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2006,
        N'INTERCEPTACIÓN ILÍCITA ART. 3 LEY 21.459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2007
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2007,
        N'ATAQUE A LA INTEGRIDAD DE DATOS INFORMÁTICOS ART 4 LEY 21459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2008
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2008,
        N'FALSIFICACIÓN INFORMÁTICA ART. 5 LEY 21.459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2009
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2009,
        N'RECEPTACIÓN DE DATOS INFORMÁTICOS ART. 6 LEY 21.459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2010
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2010,
        N'OTROS FRAUDES INFORMÁTICOS ART. 7 LEY 21.459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2011
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2011,
        N'ABUSO DE LOS DISPOSITIVOS ART. 8 LEY 21.459',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 3001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        3001,
        N'OBTENCION FRAUDULENTA DE CREDITOS. ART. 160. DFL 252 DE 1960',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 3003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        3003,
        N'INVASION DEL GIRO BANCARIO. ART. 39',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 8001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        8001,
        N'DELITOS CONTRA LEY DE PROPIEDAD INDUSTRIAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9001,
        N'DELITOS CONTRA LEY DE PROPIEDAD INTELECTUAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10001,
        N'POSESIÓN, TENENCIA, PORTE ARMAS ART 9 INC 1 LEY 17779',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10004,
        N'PORTE ILEGAL DE ARMA DE FUEGO, MUNIC.Y OTR.SUJETAS A CONTROL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10005,
        N'ADQUISICIÓN Y VENTA INDEB.DE CARTUCHOS Y MUN.ART.9 A L.17798',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10006,
        N'VIOLACIÓN RESERVA BASE DE DATOS SOBRE INSCRIP Y REG. DE ARMA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10007
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10007,
        N'ABANDONO DE ARMAS O ELEMENTOS SUJETAS A CONTROL. ART. 14 A.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10008
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10008,
        N'PORTE DE ARMA PROHIBIDA (ART. 14 INC. 1°)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10009
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10009,
        N'TENENCIA DE ARMAS PROHIBIDAS ART. 13',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10010
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10010,
        N'TRÁFICO DE ARMAS (ART. 10)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_6_DELITOS_DE_LEYES_ESPECIALES
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (540,541,543,548,550,626,627,726,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,3001,3003,8001,9001,10001,10004,10005,10006,10007,10008,10009,10010)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS DE TORTURA, MALOS TRATOS, GENOCIDIO Y LESA HUMANIDAD'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS DE TORTURA, MALOS TRATOS, GENOCIDIO Y LESA HUMANIDAD'
    );
END;

DECLARE @id_familia_1_7_DELITOS_DE_TORTURA_MALOS_TRATOS_GENOCIDIO_Y_LESA_HUMANIDAD INT;

SELECT @id_familia_1_7_DELITOS_DE_TORTURA_MALOS_TRATOS_GENOCIDIO_Y_LESA_HUMANIDAD = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS DE TORTURA, MALOS TRATOS, GENOCIDIO Y LESA HUMANIDAD';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 224
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        224,
        N'TORTURAS POR PARTICULARES AGENTES DEL ESTADO (150 A INC. 2)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 225
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        225,
        N'TORTURAS COMETIDAS POR FUNCIONARIOS PÚBLICOS (150 A INC 1)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 227
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        227,
        N'TORTURA PARA ANULAR VOLUNTAD (ART. 150 A, INC. 4°)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 228
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        228,
        N'TORTURA CON HOMICIDIO (ART. 150 B N°1)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 229
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        229,
        N'TORTURA CON VIOL. ABUSO SEX. AGRAV. OTROS (ART. 150 B N° 2)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 230
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        230,
        N'TORTURA CON CUASIDELITO (ART. 150 B N°3)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 231
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        231,
        N'APREMIOS ILEGÍTIMOS COMETIDOS POR EMPLEADOS PÚBLICOS 150 D',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 232
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        232,
        N'APREMIOS ILEGÍTIMOS CON HOMICIDIO. (ART. 150 E N 1°)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 233
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        233,
        N'APRMIO ILEG. CON VIOL., AB. SEX. AGRAV. OTROS (ART. 150 E 2)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 234
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        234,
        N'APREMIOS ILEGÍTIMOS CON CUASIDELITO (ART. 150 E N° 3)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11002,
        N'OBTENCIÓN DECLARACIONES FORZADAS ART.19 DL 2460 LEY ORG. INV',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 22200
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        22200,
        N'CRÍMENES LESA HUMANIDAD Y GENOCIDIO LEY 20.357',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_7_DELITOS_DE_TORTURA_MALOS_TRATOS_GENOCIDIO_Y_LESA_HUMANIDAD
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (224,225,227,228,229,230,231,232,233,234,11002,22200)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS ECONÓMICOS Y TRIBUTARIOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS ECONÓMICOS Y TRIBUTARIOS'
    );
END;

DECLARE @id_familia_1_8_DELITOS_ECONOMICOS_Y_TRIBUTARIOS INT;

SELECT @id_familia_1_8_DELITOS_ECONOMICOS_Y_TRIBUTARIOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS ECONÓMICOS Y TRIBUTARIOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 425
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        425,
        N'NEGOCIACIÓN INCOMPATIBLE POR PERSONA JURÍDICA ART 240',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 426
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        426,
        N'NEGOCIACIÓN INCOMPATIBLE DE PARTICULARES ART 240 N°2 AL 7',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 506
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        506,
        N'VIOL, REV. Y/O APROV. SECRETOS 284, 284 BIS, TER Y QUAT CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 507
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        507,
        N'ALTERACIÓN FRAUDULENTA DE PRECIOS. ARTS. 285 Y 286.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 597
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        597,
        N'DECLARACIÓN FALSA DENUNC. ANÓNIMO ART. 100 QUÁTER C. TRIB.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 815
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        815,
        N'INSOLVENCIA PUNIBLE (ALZAMIENTO DE BIENES)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 816
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        816,
        N'ESTAFAS Y OTRAS DEFRAUDACIONES CONTRA PARTICULARES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 817
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        817,
        N'USURA. ART. 472.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 818
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        818,
        N'APROPIACIÓN INDEBIDA (INCL. DEPOSITARIO ALZADO) ART.470 Nº1',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 824
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        824,
        N'ABUSO DE FIRMA EN BLANCO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 845
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        845,
        N'FRAUDE DE SUBVENCIONES ART 470 N°8',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 852
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        852,
        N'CELEBRACIÓN DE CONTRATO SIMULADO. ART. 471 Nº 2.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 856
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        856,
        N'APROPIACION INDEBIDA ART.470 N°1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 857
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        857,
        N'DEPOSITARIO ALZADO ART. 444 CPC',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 859
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        859,
        N'DEUDOR, ADMINIST. O REPRESENT. PERJUICIO ACREED. 463 Y SS.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 860
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        860,
        N'VEEDOR O LIQ REALICE CONDUC. ARTS 464; 464 BIS, TER Y QUATER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 863
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        863,
        N'ADMINISTRACION DESLEAL DE PERSONA NATURAL ART. 470 N°11',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 865
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        865,
        N'ADMINISTRACIÓN DESLEAL DE PERSONA JURIDICA ART. 470 N°11',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 866
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        866,
        N'APROPIACIÓN INDEBIDA COMETIDO POR P. JURÍDICA ART. 470 Nº 1.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 898
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        898,
        N'PAGO DE REMUN. DESPROPOR. INFERIOR AL IMM. ART 472 BIS CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 3002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        3002,
        N'ALTER. OCULT. DESTR. BALNC. LIBR. FISCALIZ/ART.158 LEY.GRL.BCO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 3099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        3099,
        N'DELITOS LEY BANCOS ARTS 110,141,142,154,157,159,161 DFL 252',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4001,
        N'GIRO DOLOSO DE CHEQUES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4002,
        N'TACHA FALSA DE FIRMA AUTÉNTICA. ART. 43. DFL 707',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4003,
        N'GIRO DOLOSO CHEQUES (FALTA FONDOS). ART. 22. DFL 707',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4004,
        N'GIRO DOLOSO CHEQUES (CUENTA CERRADA) ART. 22. DFL 707',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4005,
        N'GIRO DOLOSO DE CHEQUES AC. PENAL PÜBLICA. ART. 42. DFL 707',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4006,
        N'TACHA FALSA DE FIRMA AUTENTICA. ART. 43. D.L. 707',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4099,
        N'OTROS DELITOS LEY DE CUENTAS CORRIENTES BANCARIAS Y CHEQUE',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5001,
        N'DELITOS QUE CONTEMPLA EL CÓDIGO TRIBUTARIO. ARTS. 97 AL 114',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5002,
        N'COMERCIO CLANDESTINO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5003,
        N'DECLARACION MALICIOSA IMPSTOS 97N4(EXCEPTO INC 3) COD TRIB',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5004,
        N'OBTENCION INDEBIDA DEVOL IMPUESTOS 97 Nº4 INC 3 COD TRIB',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5005,
        N'FACILITACIÓN FACTURAS FALSAS ART 97 N°4 INC FINAL. COD TRIB',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5098
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5098,
        N'OTROS DELITOS DEL CÓDIGO TRIBUTARIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5099,
        N'INFRACCIONES TRIBUTARIAS CONTEMPLADAS EN OTRAS LEYES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12040
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12040,
        N'INFRACCION LEY DE QUIEBRAS. ART.218 AL 221.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12050
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12050,
        N'INFRACCIÓN ORDENANZA ADUANAS (FRAUDE Y CONTRABANDO) ART.176.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12051
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12051,
        N'CONTRABANDO. INFRACCIÓN A ORDZA ADUANAS ART 168 LEY 20780',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12052
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12052,
        N'FRAUDE ADUANERO. INFRACCIÓN ORDZA ADUANAS ART 169 LEY 20780',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_8_DELITOS_ECONOMICOS_Y_TRIBUTARIOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (425,426,506,507,597,815,816,817,818,824,845,852,856,857,859,860,863,865,866,898,3002,3099,4001,4002,4003,4004,4005,4006,4099,5001,5002,5003,5004,5005,5098,5099,12040,12050,12051,12052)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS FUNCIONARIOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS FUNCIONARIOS'
    );
END;

DECLARE @id_familia_1_9_DELITOS_FUNCIONARIOS INT;

SELECT @id_familia_1_9_DELITOS_FUNCIONARIOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS FUNCIONARIOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 206
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        206,
        N'EXACCIONES ILEGALES (ART. 147, 157 Y 241 CÓDIGO PENAL)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 216
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        216,
        N'USURPACIÓN DE PROPIEDAD, DESCUBRIMIENTO O PROD. ART.158 Nº5.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 218
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        218,
        N'EMPL PUBL EXPROPIE BIENES O PERTURBE POSESION ART. 158 N°6',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 223
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        223,
        N'EXACCIONES ILEGALES COMETIDAS POR PARTICULARES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 299
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        299,
        N'OTROS DELITOS QUE AFECTAN DºS GARANTIDOS POR LA CONSTITUCIÓN',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 402
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        402,
        N'NOMBRAMIENTOS ILEGALES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 403
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        403,
        N'USURPACIÓN DE ATRIBUCIONES DE EMPLEADOS PÚB. Y JUDICIALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 404
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        404,
        N'PREVARICACIÓN JUDICIAL Y ADMINISTRATIVA ART. 223 AL 229.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 406
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        406,
        N'MALVERSACION DE CAUDALES PUBLICOS. ARTS 233, 234, 235 Y 236',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 407
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        407,
        N'FRAUDES AL FISCO Y ORGANISMOS DEL ESTADO (Art. 239)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 408
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        408,
        N'INFIDELIDAD EN LA CUSTODIA DE DOCUMENTOS ARTS 242, 243, 244',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 409
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        409,
        N'VIOLACIÓN DE SECRETOS. ART. 246, 246 BIS, 247 Y 247 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 410
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        410,
        N'COHECHO COMETIDO POR EMPLEADO PÚBLICO ART 248, 248 BIS Y 249',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 411
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        411,
        N'COHECHO O SOBORNO COMETIDO POR PARTICULAR. ART. 250',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 413
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        413,
        N'ABANDONO DE DESTINO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 414
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        414,
        N'ABUSOS CONTRA PARTICULARES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 415
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        415,
        N'NEGOCIACIÓN INCOMPATIBLE ART. 240 N°1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 416
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        416,
        N'TRÁFICO DE INFLUENCIAS. ART. 240 BIS.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 417
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        417,
        N'EXACCIONES ILEGALES COMETIDAS POR FUNC. PÚB. ART.157 y 241.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 418
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        418,
        N'ENRIQUECIMIENTO ILÍCITO. ART. 241 BIS.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 419
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        419,
        N'FRAUDES AL FISCO Y ORGANISMOS DEL ESTADO. ART.239',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 420
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        420,
        N'ABUSOS CONTRA PARTICULARES.ARTS. 255.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 421
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        421,
        N'OTROS ABUSOS CONTRA PARTICULARES.ART. 256,257,258,259',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 422
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        422,
        N'SOBORNO DE FUNC PBCO EXTRANJ PERSONA NATURAL ART. 251 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 423
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        423,
        N'SOBORNO.ART. 250. PERSONA JURIDICA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 424
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        424,
        N'SOBORNO DE FUNC PUB EXTRANJ PERSONA JURIDICA ART 251 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 429
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        429,
        N'USO DE INFORMACIÓN PRIVILEGIADA ART. 247 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 499
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        499,
        N'OTROS DELITOS EMPLEADOS PÚBLICOS EN DESEMPEÑO DE SUS CARGOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 722
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        722,
        N'TRAFICO MIGRANTES POR FUNCIONARIO PUB ART 411 BIS INC FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11006,
        N'FALSIFICACIÓN DE PARTE POLICIAL ART. 22',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12057
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12057,
        N'FACILITACION DE DELITOS ADUANEROS POR EMPLEADO PUBLICO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 23000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        23000,
        N'INFRACCIONES A LEY EDUC SUPERIOR ART 30 Y 78 LEY 21.091',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_9_DELITOS_FUNCIONARIOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (206,216,218,223,299,402,403,404,406,407,408,409,410,411,413,414,415,416,417,418,419,420,421,422,423,424,429,499,722,11006,12057,23000)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS LEY DE DROGAS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS LEY DE DROGAS'
    );
END;

DECLARE @id_familia_1_10_DELITOS_LEY_DE_DROGAS INT;

SELECT @id_familia_1_10_DELITOS_LEY_DE_DROGAS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS LEY DE DROGAS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7000,
        N'LEY 19.366 TRÁFICO ILÍCITO DE ESTUPEFACIENTES Y SUSTANCIAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7001,
        N'ELABORACIÓN ILEGAL DE DROGAS O SUST. SICOT. ART.1 L.20000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7006,
        N'CULTIVO ESPECIES VEGET. ESTUPEF. Y FALS. RECET. 8 LEY 20.000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7007
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7007,
        N'TRÁFICO ILÍCITO DE DROGAS ART. 3 LEY Nº20.000.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7014
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7014,
        N'ASOCIACIONES ILÍCITAS LEY DE DROGAS ART. 16 LEY Nº 20.000.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7030
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7030,
        N'DESVIO ILÍCITO PRECURSORES Y SUST. ESENCIALES ART 3 L.20000',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7031
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7031,
        N'PRODUCCIÓN Y TRÁFICO POR DESVÍO DE PRECURS. ART.2 LEY 20000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7032
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7032,
        N'SUMINISTRO INDEBIDO DE DROGAS. ART. 7 LEY Nº20.000.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7033
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7033,
        N'PRESCRIPCIÓN MÉDICA ABUSIVA DE DROGAS ESTUPEF.O SICOTRÓPICAS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7034
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7034,
        N'SUMINISTRO HIDROCARBUROS. MENORES ART. 5 BIS LEY 20.000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7035
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7035,
        N'CONSUMO DE DROGAS (ART. 41)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7036
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7036,
        N'PORTE DE DROGAS (ART. 41)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7037
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7037,
        N'MICROTRÁFICO (TRÁFICO DE PEQUEÑAS CANTID. ART. 4 LEY 20000)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7042
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7042,
        N'FACILITACIÓN DE BIENES AL TRÁFICO DE DROGAS ART. 11',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7043
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7043,
        N'TOLERANCIA AL TRÁFICO O CONSUMO DE DROGAS. ART. 12',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7044
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7044,
        N'TRÁFICO DE ESPECIES VEGETALES. ART. 10 inc. 1º LEY 20.000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7045
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7045,
        N'OMISIÓN DE DENUNCIAR POR FUNCIONARIO PÚB. LEY 20.000 ART. 13',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7046
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7046,
        N'DELITO COMETIDO POR MILITAR Y GENTE DE MAR L.20.000ART14 Y15',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7047
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7047,
        N'CONSPIRACIÓN DE LA LEY 20.000, ART. 17',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7048
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7048,
        N'NEGATIVA INJUSTIFICADA A ENTREGAR COPIA (ART. 28 Y 29)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7049
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7049,
        N'DIFUSION DE IDENTIDAD DE TESTIGOS PROTEGIDOS (ART. 31)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7050
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7050,
        N'USO MALICIOSO DE IDENTIDAD ANTERIOR (ART. 35)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7051
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7051,
        N'VIOLACIÓN DE SECRETO PARCIAL (ART. 36 Y 37)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7052
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7052,
        N'VIOLACIÓN DEL SECRETO ABSOLUTO (ART. 38)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7053
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7053,
        N'ABANDONO DE SEMILLAS U OTRAS ART 10 inc. 2º LEY 20000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7054
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7054,
        N'SUMINISTRO ESTUPEF. SIN CONSENTIMIENTO ART. 5 LEY 20.000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7098
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7098,
        N'OTRAS FALTAS A LA LEY 19.366',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7099,
        N'OTROS DELITOS DE LA LEY 20.000',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13005,
        N'CONSUMO Y OTRAS FALTAS LEY DE DROGAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_10_DELITOS_LEY_DE_DROGAS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (7000,7001,7006,7007,7014,7030,7031,7032,7033,7034,7035,7036,7037,7042,7043,7044,7045,7046,7047,7048,7049,7050,7051,7052,7053,7054,7098,7099,13005)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS LEY DE TRÁNSITO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS LEY DE TRÁNSITO'
    );
END;

DECLARE @id_familia_1_11_DELITOS_LEY_DE_TRANSITO INT;

SELECT @id_familia_1_11_DELITOS_LEY_DE_TRANSITO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS LEY DE TRÁNSITO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12071
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12071,
        N'OTORG. IRREGULAR DE DOCTOS (Art. 196 a Ley 18.290 Tráns)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12072
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12072,
        N'FALSIFICACIÓN LIC.DE COND. Y OTRAS FALSIF. ART.196 B L.18290',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12073
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12073,
        N'ACCIDENTE CON RESUL. MUERTE O LES.GRAVES ART.196 C LEY 18290',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12074
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12074,
        N'CONDUCCIÓN SIN LA LICENCIA DEBIDA ART 196 D LEY 18.290',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12075
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12075,
        N'CONDUC BAJO INFLUENCIA DEL ALCOHOL ART.196 C LEY 18290 TRÁNS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12076
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12076,
        N'INSTAL. INDEB. SEÑALES DE TRÁN.O BARRERAS ART.196 A1 LEY 18290',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12077
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12077,
        N'NO DAR CUENTA DE ACCIDENTE DE TRÁNSITO ART. 96 D 1 LEY 18290',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12078
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12078,
        N'CONDUCC. INF. ALCOHOL CON O SIN DAÑO O LES. LEVE 193 INC 1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12079
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12079,
        N'CONDUC. BAJO LA INFLUENCIA DEL ALCOHOL CAUSANDO LES.MEN.GRAV',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12080
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12080,
        N'CONDUCCIÓN BAJO LA INFLUENCIA DEL ALCOHOL CAUSANDO LES.GRAV',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12083
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12083,
        N'CONDUC. INFLUENCIA ALCOHOL CAUSANDO LES.GRAVÍSIMAS O MUERTE',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12184
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12184,
        N'CONDUCIR INFL ALCOHOL CAUSANDO LES GRAVÍSIMAS ART 193 INC 4',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12185
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12185,
        N'CONDUCIR INFL ALCOHOL CAUSANDO MUERTE. ART 193 INC 4',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14001,
        N'CONDUCCIÓN ESTADO DE EBRIEDAD CON RESULTADO DE MUERTE',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14002,
        N'CONDUCCIÓN ESTADO DE EBRIEDAD CON RESULTADO DE LESIONES.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14003,
        N'CONDUCCIÓN ESTADO DE EBRIEDAD CON RESULTADO DE DAÑOS.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14004
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14004,
        N'CONDUC EBRIEDAD C/SUSP LICENCIA ART 196,209 LEY TRANSITO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14005,
        N'NEGATIVA A EFECTUARSE EXAMEN. ART. 195 BIS LEY DE TRANSITO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14006,
        N'CONDUC EBRIEDAD C/RESULT MUERTE ART196INC3 LEY TRANSITO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14007
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14007,
        N'CONDUC EBRIEDAD C/LESIONS GRAVÍSIMAS ART196 INC3LEY TRANS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14008
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14008,
        N'CONDUC EBRIEDAD C/LESIONS GRAVES ART 196 INC2LEY TRANS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14009
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14009,
        N'CONDUC EBRIDAD C/LESIONS MENOS GRAVESART196 INC2 LEY TRAN',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14020
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14020,
        N'CUASIDELITO VEHICULO MOTORIZADO LEY TRANSITO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14021
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14021,
        N'MARCHARSE SITIO SUCESO S/AUXILIAR VÍCTIMA ART 195 INC 2 y 3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14022
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14022,
        N'OCULTAMIENTO DE PLACA PATENTE (ART. 192 LETRA E)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14050
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14050,
        N'OTROS DELITOS CONTRA LA LEY DE ALCOHOLES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14052
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14052,
        N'CONDUCCIÓN EBRIEDAD CON O SIN DAÑO O LES. LEVE 196 INC. 1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14056
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14056,
        N'ATENTADO A VEH.MOT. EN CIRC. CON OBJ.CONTUNDENTE U OTRO SEM.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14057
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14057,
        N'CONDUCIR VEHICULO CON SANCIÓN VIGENTE. ART.209 LEY 18.290.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14060
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14060,
        N'OTROS DELITOS CONTRA LA LEY DEL TRÁNSITO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14061
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14061,
        N'NEGATIVA INJUSTIFICADA ALCOHOLEMIA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14062
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14062,
        N'FALSIF MEDIOS PAGO TRANSPORTES ART 196 QUATER L TRANSIT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14063
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14063,
        N'FALSIF MEDIOS PAGO TRANSP ART 196 QUINQUIES L TRANSIT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14064
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14064,
        N'COMERCIAR DISPOSITIVO FALSIFICADO ART196SEXIES L.TRANSIT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14065
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14065,
        N'MAL USO INFO MEDIOS TECNO TRANSP PÚB ART196SEPTIES LTRANSIT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14066
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14066,
        N'LESION/AMENAZA FISCALIZADOR TRANSP PUB ART196OCTIES LTRANSIT',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14087
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14087,
        N'COND. CARR. NO AUT. CON O SIN DAÑ. O LES. LEVES 197 TER INC2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14088
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14088,
        N'COND. CARR. NO AUTOR. LES. MENOS GRAV. O GRAVES 197 TER INC3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14089
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14089,
        N'COND. CARRERAR NO AUTOR. LES. GRAVÍSIMAS MUERTE 197 TER.INC4',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14090
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14090,
        N'ORGANIZAR CARRERAS NO AUTORIZADAS. ART. 197 TER.INC7°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14091
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14091,
        N'FACILITAR VEHIC. MOTOR. PART. CARRERAS CLAND. 197 TER.INC6°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14092
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14092,
        N'SOBREPASAR 60 KM/H LÍMITES VELOCIDAD MÁXIMA. ART. 197 QUINQ.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_11_DELITOS_LEY_DE_TRANSITO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (12071,12072,12073,12074,12075,12076,12077,12078,12079,12080,12083,12184,12185,14001,14002,14003,14004,14005,14006,14007,14008,14009,14020,14021,14022,14050,14052,14056,14057,14060,14061,14062,14063,14064,14065,14066,14087,14088,14089,14090,14091,14092)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS SEXUALES'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS SEXUALES'
    );
END;

DECLARE @id_familia_1_12_DELITOS_SEXUALES INT;

SELECT @id_familia_1_12_DELITOS_SEXUALES = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS SEXUALES';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 607
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        607,
        N'VIOLACIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 608
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        608,
        N'ESTUPRO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 609
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        609,
        N'INCESTO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 610
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        610,
        N'PROMOVER O FACILITAR EXPLOTACIÓN SEXUAL MENOR 18 ART. 367',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 611
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        611,
        N'SODOMIA. ART. 365.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 612
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        612,
        N'VIOLACIÓN SODOMÍTICA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 613
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        613,
        N'ABUSOS SEXUALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 615
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        615,
        N'ULTRAJE PÚBLICO A LAS BUENAS COSTUMBRES. ART. 373.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 619
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        619,
        N'ABUSO SEXUAL SIN CONTACTO MAYOR 14 MENOR 18 366 QUÁTER INC 4',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 620
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        620,
        N'ABUSO SEXUAL SIN CONTACTO MENOR 14 366 QUÁTER INC. 1, 2 Y 3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 621
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        621,
        N'VIOLACIÓN DE MENOR DE 14 AÑOS. ART. 362.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 622
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        622,
        N'ABUSO SEXUAL ADULTO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 623
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        623,
        N'ABUSO SEX C/CONTACTO CORP. A MENOR DE 14 AÑOS ART 366 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 628
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        628,
        N'VIOLACIÓN CON HOMICIDIO O FEMICIDIO ART. 372 BIS.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 629
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        629,
        N'PRODUCCIÓN MATERIAL PORNOGRÁFICO UTILIZANDO MENOR.DE 18 AÑOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 630
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        630,
        N'COMERCIALIZACIÓN MAT. PORNOGRÁFICO ELAB.UTIL. MEN.DE 18 AÑOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 631
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        631,
        N'ADQ. O ALMACENAMIENTO MAT.PORNOGRÁFICO INF.ART.374 BIS INC 2',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 632
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        632,
        N'OBTENCIÓN REALIZACIÓN ACCIÓN SEXUAL MENOR 18 367 TER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 633
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        633,
        N'ABUSO SEXUAL CALIFICADO (CON OBJETOS O ANIMALES) ART.365 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 634
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        634,
        N'ABUSO SEX MAYOR 14/MENOR 18 CON CIRCUNS ESTUPRO ART 366 INC2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 635
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        635,
        N'ABUSO SEXUAL DE MAYOR DE 14 (CON CIRC. DE VIOLACIÓN) ART 366',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 637
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        637,
        N'VIOLACIÓN DE MAYOR DE 14 AÑOS. ART. 361.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 638
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        638,
        N'CAPTACIÓN, GRAB Y DIFUS DE REGISTROS AUDIOVIS. PARTES ÍNTIMA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 639
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        639,
        N'ABUSO SEX MAYOR DE 14 AÑOS POR SORPRESA Y/O S/CONSENTIM. ART',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 640
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        640,
        N'ACOSO SEX EN LUGARES PÚBLICOS O DE LIBRE ACCESO PÚBLICO. ART',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 647
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        647,
        N'TRANS. IMAGENES CONNOTACIÓN SEXUAL MENOR 18 367 SEPT.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 648
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        648,
        N'COMERC. MATERIAL PORN. MENOR 18 ART. 367 QUATER INC. 1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 649
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        649,
        N'PRODUCCIÓN MAT. PORN. UTILIZANDO MENOR 18 367 QUÁTER INC. 2°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 650
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        650,
        N'ADQ. O ALMACENAMIENTO MAT. PORN. INFANTIL 367 QUÁTER INC. 3°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 651
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        651,
        N'EXHIB. REGIS.CONTDO SEX. S/CONSENT. ART. 161 D C.P. INC. 1º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 652
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        652,
        N'DIFUS.REGIS. CONTNDO SEX. S/CONSENT ART. 161 D C.P. INC. 2º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 699
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        699,
        N'OTROS DEL C/ ORDEN FAMILIA, MORALIDAD Pº, INTEGRIDAD SEXUAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13021
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13021,
        N'OFENSAS AL PUDOR (495 Nº5 Código Penal)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_12_DELITOS_SEXUALES
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (607,608,609,610,611,612,613,615,619,620,621,622,623,628,629,630,631,632,633,634,635,637,638,639,640,647,648,649,650,651,652,699,13021)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'FALTAS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'FALTAS'
    );
END;

DECLARE @id_familia_1_13_FALTAS INT;

SELECT @id_familia_1_13_FALTAS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'FALTAS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5006,
        N'FALTA AL DEBER DE INFORMAR ART. 66 BIS CÓDIGO TRIBUTARIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7038
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7038,
        N'CONSUMO/PORTE EN LUG. PÚB.O PRIV. CON PREV.CONCIERTO(ART.50)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7039
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7039,
        N'CONSUMO/PORTE DE DROGAS EN LUGARES CALIFICADOS (ART.51)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13022
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13022,
        N'DISENSIONES DOMÉSTICAS 495 Nº6 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13023
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13023,
        N'ALTERAR EL ORDEN PÚBLICO 495 Nº1 CODIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13024
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13024,
        N'OCULTACIÓN DE IDENTIDAD 496 Nº5 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13025
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13025,
        N'DEJAR ANIMALES SUELTOS (496 Nº17 Código Penal)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13026
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13026,
        N'ARROJAMIENTO DE PIEDRAS U OTROS OBJETOS (496 Nº26 Cód. Penal)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13027
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13027,
        N'DAÑO FALTA (495 N°21 Código Penal)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13028
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13028,
        N'HURTO FALTA 494 BIS CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13030
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13030,
        N'AMENAZA CON ARMA (FALTA) ART. 494 Nº4 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13031
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13031,
        N'FALTA DE RESPETO A LA AUTORIDAD PÚBLICA 495 Nº4 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13032
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13032,
        N'MALVERSACIÓN, DEFRAUDACIÓN E INCENDIO POR MENOS DE 1 UTM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13033
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13033,
        N'RIÑA PÚBLICA 496 Nº 10 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13034
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13034,
        N'INFRAC. A REGLAMENTO DE CARRUAJES PÚB.O DE PART. 496 Nº14 CP',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13035
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13035,
        N'DESÓRDENES EN ESPECTÁCULOS PÚBLICOS 494 Nº1 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13037
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13037,
        N'CAZA Y PESCA CON VIOLENCIA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13038
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13038,
        N'GANADO QUE ENTRA A PREDIO AJENO CAUSANDO DAÑOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13052
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13052,
        N'OCULTACIÓN IDENT. EN CONTROL INVESTIGATIVO 496 N°5 Y 85 CPP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13053
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13053,
        N'OCULTACIÓN DE IDENTIDAD CONTROL PREVENTIVO ART. 496 N°5',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13096
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13096,
        N'DIRIGIR REUNIONES TUMULTUOSAS ART. 494 Nº2 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13097
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13097,
        N'OTRAS FALTAS CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13100
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13100,
        N'IMPEDIR EJER. DE FUNC. A INSP. MUNIC. ART 496 N°3 C. PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13101
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13101,
        N'TRANSPRTE DESECH. VERT. CLAND 192 BIS, INC. 6 LEY 20.879',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13103
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13103,
        N'PERRO POTENCIALMENTE PELIGROSO NO INSCRITO ART 16 LEY 21.020',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13104
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13104,
        N'ARROJAR BASURA EN PLAYAS, P. NACIONALES U OTROS ART 494 N°3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13105
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13105,
        N'IMPEDIR ACCESO A PLAYAS (ART. 13 INC. FINAL. LEY 21.149)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13106
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13106,
        N'NO INFORMAR DOMICILIO POR DELITOS SEXUALES (NNA) (ART.372)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14051
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14051,
        N'EBRIEDAD',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14053
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14053,
        N'EXPENDIO DE BEBIDAS ALCOHÓLICAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14054
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14054,
        N'CONSUMO DE BEBIDAS ALCOHÓLICAS EN LA VÍA PÚBLICA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14099,
        N'OTRAS INFRACCIONES CONTRA LA LEY DE ALCOHOLES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 18001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        18001,
        N'EXPENDIO DE BEBIDAS ALCOHOLICAS A MENORES. ART 42 LEY 19925',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 18002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        18002,
        N'OTORGAMIENTO DE PATENTES DE ALCOHOLES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 18003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        18003,
        N'DIVULGACIÓN DE DATOS MILITANTES P. POLITICOS (23 BIS 18.603)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_13_FALTAS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (5006,7038,7039,13022,13023,13024,13025,13026,13027,13028,13030,13031,13032,13033,13034,13035,13037,13038,13052,13053,13096,13097,13100,13101,13103,13104,13105,13106,14051,14053,14054,14099,18001,18002,18003)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'HECHOS DE RELEVANCIA CRIMINAL'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'HECHOS DE RELEVANCIA CRIMINAL'
    );
END;

DECLARE @id_familia_1_14_HECHOS_DE_RELEVANCIA_CRIMINAL INT;

SELECT @id_familia_1_14_HECHOS_DE_RELEVANCIA_CRIMINAL = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'HECHOS DE RELEVANCIA CRIMINAL';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1001,
        N'PRESUNTA DESGRACIA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1002,
        N'MUERTES Y HALLAZGO DE CADÁVER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1006
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1006,
        N'HALLAZGO DE VEHÍCULO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1014
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1014,
        N'PRESUNTA DESGRACIA INFANTIL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1018
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1018,
        N'HALLAZGO DE DROGAS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1099,
        N'OTROS HECHOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_14_HECHOS_DE_RELEVANCIA_CRIMINAL
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (1001,1002,1006,1014,1018,1099)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'HOMICIDIOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'HOMICIDIOS'
    );
END;

DECLARE @id_familia_1_15_HOMICIDIOS INT;

SELECT @id_familia_1_15_HOMICIDIOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'HOMICIDIOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 521
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        521,
        N'HOMICIDIO FISCAL, DEFENSOR EN DESEMP. DE FUNC. ART. 268 TER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 701
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        701,
        N'PARRICIDIO.ART. 390 inc.1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 702
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        702,
        N'HOMICIDIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 703
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        703,
        N'HOMICIDIO CALIFICADO. ART. 391 Nº1.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 704
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        704,
        N'HOMICIDIO SIMPLE',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 705
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        705,
        N'HOMICIDIO EN RIÑA O PELEA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 706
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        706,
        N'AUXILIO AL SUICIDIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 707
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        707,
        N'INFANTICIDIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 720
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        720,
        N'FEMICIDIO INTIMO ART. 390 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 766
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        766,
        N'FEMICIDIO NO INTIMO ART. 390 ter.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 768
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        768,
        N'SUIC FEM, INDUC SUIC Y/O SUIC FEM ARTS 393 BIS; 390 SEX, TER CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 769
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        769,
        N'CONSPIRACIÓN HOMICIDIO CALIFICADO POR PREMIO 391 BIS INC 1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 770
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        770,
        N'CONSP. HOMICIDIO CALIF. PREMIO CONTRA AUTOR. 391 BIS INC. 2°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11003,
        N'CAUSAR MUERTE PERSONAL PDI ART. 17 DL 2640',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11101
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11101,
        N'HOMICIDIO GENDARME DESEMPEÑO FUNCIONES ART. 15 DL 2859',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12086
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12086,
        N'MATAR A CARABINERO POR SU CARGO O EJERCICIO FUNC. 416 CJM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 23785
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        23785,
        N'HOMICIDIO FUNCIONARIO FFAA DESEMPEÑO FUNCIONES 281 BIS CJM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_15_HOMICIDIOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (521,701,702,703,704,705,706,707,720,766,768,769,770,11003,11101,12086,23785)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'HURTOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'HURTOS'
    );
END;

DECLARE @id_familia_1_16_HURTOS INT;

SELECT @id_familia_1_16_HURTOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'HURTOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 801
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        801,
        N'HURTO SIMPLE',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 821
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        821,
        N'HURTO DE HALLAZGO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 826
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        826,
        N'HURTO AGRAVADO (ART. 447 CÓDIGO PENAL)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 846
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        846,
        N'HURTO SIMPLE POR UN VALOR SOBRE 40 UTM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 847
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        847,
        N'HURTO SIMPLE POR UN VALOR DE 4 A 40 UTM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 848
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        848,
        N'HURTO SIMPLE POR UN VALOR DE MEDIA A 4 UTM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 853
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        853,
        N'HURTO DE BIENES PERTENECIENTES A REDES DE SUMINISTRO PÚBLICO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 871
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        871,
        N'HURTO CON OCASION DE CALAMIDAD O ALTERACION AL ORDEN PUBLICO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_16_HURTOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (801,821,826,846,847,848,853,871)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'LESIONES'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'LESIONES'
    );
END;

DECLARE @id_familia_1_17_LESIONES INT;

SELECT @id_familia_1_17_LESIONES = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'LESIONES';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 522
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        522,
        N'MALTRATO OBRA FISCAL, DEFENSOR EN DESEMP. DE FUNC. ART. 268',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 531
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        531,
        N'LESIONES CONTRA PROF.Y FUNC.SALUD Y MANIPULADORES ALIMENTO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 708
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        708,
        N'LESIONES CORPORALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 709
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        709,
        N'LESIONES GRAVES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 710
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        710,
        N'LESIONES MENOS GRAVES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 717
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        717,
        N'LESIONES GRAVES GRAVÍSIMAS. ART. 397 Nº1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 718
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        718,
        N'CASTRACIÓN Y MUTILACIÓN',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 719
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        719,
        N'MUTILACIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 767
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        767,
        N'LESIONES GRAV Y MEN GRAV MIEMBROS DE BOMBEROS. ART 400 INC 3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 799
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        799,
        N'OTROS DELITOS CONTRA LAS PERSONAS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11001,
        N'MALTRATO OBRA PERS. PDI CON O SIN LESIONES 17 BIS DL 2460',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11102
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11102,
        N'MALTRATO OBRA GENDARME DESEMP. FUNCIONES 15 B Y C DL 2859',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12081
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12081,
        N'MALTRATO DE OBRA CARABINEROS ART. 416 BIS CJM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13001,
        N'LESIONES LEVES ART. 494 N° 5',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13036
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13036,
        N'LESIONES LEVES 494 Nº 5 CODIGO PENAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 23786
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        23786,
        N'MALTRATO DE OBRA FUNC. FFAA DESEMPEÑO FUNCIONES 281 TER CJM',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_17_LESIONES
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (522,531,708,709,710,717,718,719,767,799,11001,11102,12081,13001,13036,23786)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'OTROS DELITOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'OTROS DELITOS'
    );
END;

DECLARE @id_familia_1_18_OTROS_DELITOS INT;

SELECT @id_familia_1_18_OTROS_DELITOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'OTROS DELITOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 0
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        0,
        N'NO DEFINIDO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 90
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        90,
        N'RECLAMO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 100
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        100,
        N'LIBRO I TÍTULO IV QUEBRANTAMIENTO DE SENTENCIAS Y LOS QU',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 101
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        101,
        N'QUEBRANTAMIENTO. ART. 90',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 200
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        200,
        N'LIBRO II TÍTULO III CRÍMENES Y SIMPLES DELITOS QUE AFECTAN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 201
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        201,
        N'LIBERTAD DE CULTO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 208
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        208,
        N'VIOLACIÓN DE PRERROGATIVAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 209
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        209,
        N'CONDENAS IRREGULARES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 211
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        211,
        N'DELITO CONTRA LIBERTAD DE OPINIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 212
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        212,
        N'DELITO CONTRA LIBERTAD DE TRABAJO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 213
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        213,
        N'DELITOS CONTRA LIBERTAD DE REUNIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 215
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        215,
        N'DELITO CONTRA EL DERECHO DE PETICIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 217
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        217,
        N'VIOLACIÓN DE SECRETO DE INVENTO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 300
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        300,
        N'LIBRO II TÍTULO IV CRÍMENES Y SIMPLES DELITOS CONTRA LA FE',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 305
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        305,
        N'FALSIFICACIÓN DE PORTES DE ARMAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 400
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        400,
        N'LIBRO II TÍTULO V CRÍMENES Y SIMPLES DELITOS COMETIDOS POR',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 401
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        401,
        N'ANTICIPACIÓN Y PROLONGACIÓN INDEBIDA DE FUNCIONES PÚBLICA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 412
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        412,
        N'DENEGACIÓN DE AUXILIO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 500
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        500,
        N'LIBRO II TÍTULO VI CRÍMENES Y SIMPLES DELITOS CONTRA EL OR',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 501
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        501,
        N'DELITO DESÓRDENES PÚBLICOS ART. 269 (NO FALTA DEL CÓD 13035)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 504
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        504,
        N'CRÍMENES Y SIMPLES DELITOS DE LOS PROVEEDORES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 505
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        505,
        N'LOTERIA ILEGAL, CASA JUEGO Y PRÉSTAMO PRENDA ARTS 275 AL 283',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 508
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        508,
        N'PROPAGAR ENFERM ANIMAL, VEGETAL O ELEMENTOS QUIM Y OTROS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 509
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        509,
        N'ABANDONO O MALTRATO ANIMAL ART. 291 BIS.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 510
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        510,
        N'ASOCIACIONES ILICITAS. ARTS. 292 AL 293 BIS.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 512
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        512,
        N'CONNIVENCIA FUGA Y EVASIÓN CULPABLE DETENIDO ART. 299 A 304',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 513
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        513,
        N'CONTRA SALUD PÚBLICA. ARTS. 313 AL 318.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 514
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        514,
        N'INFRACCIÓN NORMAS INHUMACIONES Y EXHUMACIONES. ART 320 Y 322',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 516
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        516,
        N'OPONERSE A ACCIÓN DE LA AUTORIDAD PÚBLICA O SUS AGENTES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 518
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        518,
        N'PORTE DE ARMA CORTANTE O PUNZANTE (288 bis)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 519
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        519,
        N'FALSA ALARMA INCENDIO, EMERGENCIA O CALAMIDAD ART 268 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 526
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        526,
        N'CONTRA SALUD PUBLICA. ARTS. 313 A Y 313 B',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 527
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        527,
        N'CONTRA SALUD PÚBLICA. ARTS. 313 D AL 315 y ART. 317.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 532
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        532,
        N'BLOQUEO TOTAL CIRCULACIÓN CON VIOLENCIA-INTIMIDAC. - OBSTÁCULO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 533
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        533,
        N'LANZAR A PERSONA-VEHÍCULO OBJETO APTO PRODUCIR LESIÓN-MUERTE',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 534
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        534,
        N'DISEMINAR GÉRMENES PARA CAUSAR ENFERMEDAD',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 535
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        535,
        N'INFRINGIR NORMAS HIGIÉNICAS Y DE SALUBRIDAD (Art. 318)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 536
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        536,
        N'PROPAGAR CONTAGIO A SABIENDAS (Art. 318 bis)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 537
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        537,
        N'EMPLEADOR QUE ORDENA INFRINGIR CUARENTENA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 538
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        538,
        N'ULTRAJE DE CADÁVER ART. 322 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 539
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        539,
        N'ULTRAJE DE SEPULTURA ART. 322 TER',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 542
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        542,
        N'ASOC. DELICTIVA O CRIM. MEDIANTE PERSONA JDCA ART 294 CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 544
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        544,
        N'ATENTADOS CONTRA EL MEDIO AMBIENTE ART 305 A 310 CP',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 545
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        545,
        N'PORTAR APARATOS DE COMUNIC. EN RECINTO PENIT. ART 304 TER CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 546
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        546,
        N'OMISIÓN DENUNCIA FUN. PBCO. TENEN. ELEM. TEC. ART 304 TER CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 547
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        547,
        N'PORTAR INJUSTIF. COMBUST. EN LUG. USO PBCO. ART 288 TER CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 549
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        549,
        N'CONTAMINACIÓN GRAVE IMPRUDENTE ART. 309',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 551
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        551,
        N'DELITOS MEDIOAMB. DOLOSOS ART. 305, 306, 307, 308 Y 310.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 552
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        552,
        N'ASOC. ILICITA PARA LA COMISION DE SIMPLES DELITOS ART 293',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 553
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        553,
        N'ASOC. ILICITA PARA LA COMISION DE CRIMENES ART 293',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 554
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        554,
        N'AMEN. U OFREC. ECON. PREST. FALSO TEST. ASOC. ILIC. 293 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 599
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        599,
        N'OTROS DELITOS C/ ORDEN Y SEGURIDAD Pº COMETIDOS PARTICULARES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 600
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        600,
        N'LIBRO II TÍTULO VII CRÍMENES Y SIMPLES DELITOS CONTRA EL O',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 601
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        601,
        N'ABORTO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 602
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        602,
        N'ABANDONO DE NIÑOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 603
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        603,
        N'ABANDONO DE CÓNYUGE O DE PARIENTES ENFERMOS. ART. 352.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 604
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        604,
        N'USURPACIÓN DE ESTADO CIVIL. ART. 354.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 605
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        605,
        N'INDUCIR A UN MENOR A ABANDONAR EL HOGAR',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 606
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        606,
        N'RAPTO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 614
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        614,
        N'TRATA DE BLANCAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 616
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        616,
        N'DIFUSIÓN DE MATERIAL PORNOGRÁFICO (PORNOGRAFÍA)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 617
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        617,
        N'BIGAMIA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 624
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        624,
        N'ABORTO CONSENTIDO POR CAUSLAES N/REGULADAS ART 342 N 3 Y 344',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 625
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        625,
        N'ABORTO SIN CONSENTIMIENTO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 636
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        636,
        N'ABORTO COMETIDO POR FACULTATIVO POR CAUSALES NO REGULADAS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 700
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        700,
        N'LIBRO II TÍTULO VIII CRÍMENES Y SIMPLES DELITOS CONTRA LA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 715
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        715,
        N'CALUMNIA (ACCIÓN PRIVADA). ART. 412 AL 415.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 716
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        716,
        N'INJURIA (ACCIÓN PRIVADA). ART. 416 AL 420.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 763
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        763,
        N'MALTRATO CORPORAL A PERSONAS VULNERABLES ART 403 BIS INC 1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 764
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        764,
        N'MALTRATO COMETIDO POR GARANTE ART. 403 BIS INC FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 765
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        765,
        N'TRATOS DEGRADANTES A PERSONAS VULNERABLES. ART. 403 TER.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 819
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        819,
        N'INCENDIO Y OTROS ESTRAGOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 837
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        837,
        N'INCENDIO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 850
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        850,
        N'INCENDIO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 900
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        900,
        N'LIBRO II TÍT X DE LOS CUASIDELITOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1000,
        N'HECHOS DE RELEVANCIA CRIMINAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1007
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1007,
        N'AMPLIACIÓN DE PARTE',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1012
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1012,
        N'INTENTO DE SUICIDIO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 2000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        2000,
        N'LEY 19.223 DELITOS INFORMÁTICOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 3000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        3000,
        N'LEY GENERAL DE BANCOS D.F.L. N°2 DE 1960',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 4000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        4000,
        N'LEY DE CUENTAS CORRIENTES BANCARIAS Y CHEQUES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 5000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        5000,
        N'DELITOS TRIBUTARIOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 6000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        6000,
        N'LEY N°16.643 ABUSOS DE PUBLICIDAD',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 6001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        6001,
        N'CALUMNIAS A TRAVÉS DE MEDIOS DE DIFUSIÓN (ACCIÓN PRIVADA)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 6002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        6002,
        N'INJURIA A TRAVÉS DE MEDIOS DE DIFUSIÓN (ACCIÓN PRIVADA)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 6099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        6099,
        N'OTROS DELITOS LEY 16.643 SOBRE ABUSOS DE PUBLICIDAD',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7012
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7012,
        N'RECETA INNECESARIA DE DROGAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 7013
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        7013,
        N'LAVADO DE DINERO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 8000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        8000,
        N'LEY N°19.039 DE PROPIEDAD Y PRIVILEGIOS INDUSTRIALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9000,
        N'LEY N°17.336 DE PROPIEDAD INTELECTUAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 9005
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        9005,
        N'INDUCIR PERMITIR U OCULTAR INFRACC. DER. DE AUTOR ART 81 TER',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 10000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        10000,
        N'LEYES DE CONTROL DE ARMAS. LEY 17.798; LEY 21.250',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11000,
        N'FRACCIÓN AL D.L. 2.460 L.O.C. DE INVESTIGACIONES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 11104
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        11104,
        N'INGRESO ILEG. APAR. DE COMUNIC. Y TECN. CENT. PENIT. 304 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12000
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12000,
        N'INFRACCIÓN A OTROS TEXTOS LEGALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12060
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12060,
        N'INFRACCIÓN ARTÍCULO 74 BIS B DEL C.P.P (SECRETO SUMARIO)',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12099,
        N'DELITOS CONTEMPLADOS EN OTROS TEXTOS LEGALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13002,
        N'FALTAS CÓDIGO PENAL CONOCIDAS POR JUZGADOS DEL CRIMEN.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13017
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13017,
        N'INFRACCIÓN A LA LEY N°16.643 DE ABUSOS DE PUBLICIDAD',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13098
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13098,
        N'OTRAS FALTAS LEYES ESPECIALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13099,
        N'OTROS QUE NO DAN MOTIVO A INGRESO DE SUMARIO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 14055
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        14055,
        N'RECLAMO DE CLAUSURA',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 15002
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        15002,
        N'CRIM Y SD SEG INT ESTADO; ART 121 Y SS CP Y 4 Y SS LEY 12927',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 15003
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        15003,
        N'CRIM Y SD SOB NAC Y SEG EXT ART. 106 Y SS CP Y 1 LEY 12.927',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 17001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        17001,
        N'DELITOS QUE COMPROMETEN RELACIONES INTERNACIONALES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 23800
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        23800,
        N'OBTENCIÓN FRAUDULENTA BENEFICIOS COVID 19',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_18_OTROS_DELITOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (0,90,100,101,200,201,208,209,211,212,213,215,217,300,305,400,401,412,500,501,504,505,508,509,510,512,513,514,516,518,519,526,527,532,533,534,535,536,537,538,539,542,544,545,546,547,549,551,552,553,554,599,600,601,602,603,604,605,606,614,616,617,624,625,636,700,715,716,763,764,765,819,837,850,900,1000,1007,1012,2000,3000,4000,5000,6000,6001,6002,6099,7012,7013,8000,9000,9005,10000,11000,11104,12000,12060,12099,13002,13017,13098,13099,14055,15002,15003,17001,23800)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'OTROS DELITOS CONTRA LA PROPIEDAD'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'OTROS DELITOS CONTRA LA PROPIEDAD'
    );
END;

DECLARE @id_familia_1_19_OTROS_DELITOS_CONTRA_LA_PROPIEDAD INT;

SELECT @id_familia_1_19_OTROS_DELITOS_CONTRA_LA_PROPIEDAD = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'OTROS DELITOS CONTRA LA PROPIEDAD';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 800
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        800,
        N'LIBRO II TÍT. IX CRIMENES Y SIMPLES DELITOS CONTRA LA PROP.',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 806
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        806,
        N'EXTORSIÓN. ART. 438',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 811
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        811,
        N'ABIGEATO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 812
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        812,
        N'RECEPTACIÓN. ART. 456 BIS A',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 813
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        813,
        N'USURPACIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 814
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        814,
        N'DESTRUCCIÓN O ALTERACIÓN DE DESLINDES ART 462 Y 462 BIS CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 820
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        820,
        N'DAÑOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 825
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        825,
        N'INFRACCIÓN ARTÍCULO 454',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 832
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        832,
        N'PORTAR ELEMENTOS CONOCIDAMENTE DESTINADOS A COMETER DELITO D',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 833
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        833,
        N'USURP. U OCUP. VIOLENTA DE INMUEBLE ART 457 INC 1º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 834
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        834,
        N'USURP. U OCUP. DE INM. NO VIOL. S/DAÑOS A LAS COSAS ART 458',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 835
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        835,
        N'INVASIÓN DE DERECHOS AJENOS ART. 459 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 836
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        836,
        N'USURPACION DE AGUAS. ART. 459.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 838
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        838,
        N'INCENDIO CON RESULTADO DE MUERTE Y/O LESIONES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 839
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        839,
        N'OTROS ESTRAGOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 840
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        840,
        N'DAÑOS SIMPLES. ART. 487.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 841
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        841,
        N'DAÑOS CALIFICADOS. ART. 485 Y 486',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 849
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        849,
        N'APROPIACIÓN DE CABLES DE TENDIDO ELÉC.O DE COM.ART.443 INC 2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 851
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        851,
        N'INCENDIO DE BOSQUES Art. 476 Nº 3 Y 4.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 854
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        854,
        N'INCENDIO CON PELIGRO PARA LAS PERSONAS (475 Y 476 N° 1 y 2)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 855
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        855,
        N'INCENDIO SOLO CON DAÑOS O SIN PELIGRO DE PROP. ART.477 Y 478',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 864
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        864,
        N'RECEPTACION COMETIDA POR PERSONA JURÍDICA ART. 456 BIS A',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 869
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        869,
        N'RECEPTACIÓN DE VEHÍCULOS MOTORIZADOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 877
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        877,
        N'PORTAR ELEMENTOS PARA PROVOCAR INCENDIO O ESTRAGOS ART. 481',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 896
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        896,
        N'POSESIÓN O TENENCIA ILEGÍTIMA MADERA. ART. 448 OCTIES INC1º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 899
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        899,
        N'OTROS DELITOS CONTRA LA PROPIEDAD',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 912
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        912,
        N'DUPLICACIÓN DE INSCRIPCIONES DE Dº DE AGUA (ART. 460 BIS)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1100
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1100,
        N'USURP. U OCUP. NO VIOLENTA C/DAÑO EN LAS COSAS ART 457 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1101
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1101,
        N'ENGAÑO PARA CELEBRAR CONTRATOS TRANS. INMUEBLES ART 470 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1102
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1102,
        N'INCENDIO SOLO CON DAÑOS A TERCEROS. ARTS. 477 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1103
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1103,
        N'INCEND.COSAS VALR INF. 4 SUELDS VITLS. ARTS. 478 COD PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_19_OTROS_DELITOS_CONTRA_LA_PROPIEDAD
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (800,806,811,812,813,814,820,825,832,833,834,835,836,838,839,840,841,849,851,854,855,864,869,877,896,899,912,1100,1101,1102,1103)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'ROBOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'ROBOS'
    );
END;

DECLARE @id_familia_1_20_ROBOS INT;

SELECT @id_familia_1_20_ROBOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'ROBOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 802
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        802,
        N'ROBO CON INTIMIDACIÓN. ART. 433, 436 INC. 1º.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 803
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        803,
        N'ROBO CON VIOLENCIA. ART.436 INC. 1º, 433, 439.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 804
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        804,
        N'ROBO POR SORPRESA. ART. 436 INC. 2°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 805
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        805,
        N'ROBO CALIFICADO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 827
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        827,
        N'ROBO CON HOMICIDIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 828
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        828,
        N'ROBO CON VIOLACIÓN. ART. 433 Nº1.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 829
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        829,
        N'ROBO CON CASTRACIÓN, MUTILACIÓN O LESIONES GRAVES GRAVÍSIMAS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 830
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        830,
        N'ROBO CON RETENCIÓN DE VÍCTIMAS O CON LESIONES GRAVES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 861
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        861,
        N'ROBO CON LESIONES GRAVES GRAVISIMAS ART. 433 Nº 2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 862
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        862,
        N'ROBO CON RET. DE VICTIMAS O LESIONES GRAVES ART. 433 Nº 3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 867
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        867,
        N'ROBO.VEHÍC. MOTORIZADO POR SORPRESA, VIOLENCIA O INTIMID.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_20_ROBOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (802,803,804,805,827,828,829,830,861,862,867)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'ROBOS NO VIOLENTOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'ROBOS NO VIOLENTOS'
    );
END;

DECLARE @id_familia_1_21_ROBOS_NO_VIOLENTOS INT;

SELECT @id_familia_1_21_ROBOS_NO_VIOLENTOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'ROBOS NO VIOLENTOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 807
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        807,
        N'ROBO CON FUERZA EN LAS COSAS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 808
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        808,
        N'ROBO EN BIENES NAC. DE USO PÚB. O SITIOS NO DESTINADOS A HAB',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 809
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        809,
        N'ROBO EN LUGAR HABITADO O DESTINADO A LA HABITACIÓN. ART. 440',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 810
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        810,
        N'ROBO EN LUGAR NO HABITADO. ART. 442.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 831
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        831,
        N'ROBO DE VEHICULO MOTORIZADO ART. 443 INC. 2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 858
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        858,
        N'ROBO CON FUERZA DE CAJEROS AUTOMATICOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 868
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        868,
        N'ROBO DE VEHÍCULO UTILIZANDO ELEMENTOS DISTRACTIVOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 870
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        870,
        N'ROBO CON OCASION DE CALAMIDAD O ALTERACION AL ORDEN PUBLICO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 872
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        872,
        N'SAQUEO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 891
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        891,
        N'SUST. DE MADERA ART. 448 SEPTIES INC 1º Y 448 OCTIES INC 1º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 892
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        892,
        N'SUST. MAD. PJ 448 SEPT. INC. 1 Y 448 OCT. INC 1 (1° 20.393).',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_1,
    @id_familia_1_21_ROBOS_NO_VIOLENTOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (807,808,809,810,831,858,868,870,872,891,892)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_1
);

GO
-- SECCION 2: II. CATÁLOGO DE DELITOS DE VIOLENCIA INTRAFAMILIAR, VIF.

IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_seccion_catalogo
    WHERE nombre = N'II. CATÁLOGO DE DELITOS DE VIOLENCIA INTRAFAMILIAR, VIF.'
)
BEGIN
    INSERT INTO investigacion.cat_seccion_catalogo (
        nombre,
        descripcion
    )
    VALUES (
        N'II. CATÁLOGO DE DELITOS DE VIOLENCIA INTRAFAMILIAR, VIF.',
        N'II. CATÁLOGO DE DELITOS DE VIOLENCIA INTRAFAMILIAR, VIF.'
    );
END;

DECLARE @id_seccion_2 INT;

SELECT @id_seccion_2 = id_seccion_catalogo
FROM investigacion.cat_seccion_catalogo
WHERE nombre = N'II. CATÁLOGO DE DELITOS DE VIOLENCIA INTRAFAMILIAR, VIF.';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'ABANDONO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'ABANDONO'
    );
END;

DECLARE @id_familia_2_1_ABANDONO INT;

SELECT @id_familia_2_1_ABANDONO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'ABANDONO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 602
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        602,
        N'ABANDONO DE NIÑOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 603
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        603,
        N'ABANDONO DE CÓNYUGE O DE PARIENTES ENFERMOS. ART. 352.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_1_ABANDONO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (602,603)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'AMENAZAS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'AMENAZAS'
    );
END;

DECLARE @id_familia_2_2_AMENAZAS INT;

SELECT @id_familia_2_2_AMENAZAS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'AMENAZAS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 511
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        511,
        N'AMENAZAS DE ATENTADOS CONTRA PERSONAS Y PROPIEDADES',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 524
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        524,
        N'AMENAZAS SIMPLES CONTRA PERSONAS Y PROPIEDADES ART. 296 Nº3.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 525
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        525,
        N'AMENAZAS CONDIC. CONTRA PERSONAS Y PROP. ART. 296 1 y 2, 297',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13030
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13030,
        N'AMENAZA CON ARMA (FALTA) ART. 494 Nº4 CÓDIGO PENAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_2_AMENAZAS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (511,524,525,13030)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DELITOS SEXUALES'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DELITOS SEXUALES'
    );
END;

DECLARE @id_familia_2_3_DELITOS_SEXUALES INT;

SELECT @id_familia_2_3_DELITOS_SEXUALES = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DELITOS SEXUALES';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 607
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        607,
        N'VIOLACIÓN',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 608
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        608,
        N'ESTUPRO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 609
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        609,
        N'INCESTO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 610
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        610,
        N'PROMOVER O FACILITAR EXPLOTACIÓN SEXUAL MENOR 18 ART. 367',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 619
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        619,
        N'ABUSO SEXUAL SIN CONTACTO MAYOR 14 MENOR 18 366 QUÁTER INC 4',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 620
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        620,
        N'ABUSO SEXUAL SIN CONTACTO MENOR 14 366 QUÁTER INC. 1, 2 Y 3',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 621
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        621,
        N'VIOLACIÓN DE MENOR DE 14 AÑOS. ART. 362.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 622
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        622,
        N'ABUSO SEXUAL ADULTO',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 623
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        623,
        N'ABUSO SEX C/CONTACTO CORP. A MENOR DE 14 AÑOS ART 366 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 628
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        628,
        N'VIOLACIÓN CON HOMICIDIO O FEMICIDIO ART. 372 BIS.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 629
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        629,
        N'PRODUCCIÓN MATERIAL PORNOGRÁFICO UTILIZANDO MENOR.DE 18 AÑOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 630
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        630,
        N'COMERCIALIZACIÓN MAT. PORNOGRÁFICO ELAB.UTIL. MEN.DE 18 AÑOS',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 633
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        633,
        N'ABUSO SEXUAL CALIFICADO (CON OBJETOS O ANIMALES) ART.365 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 634
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        634,
        N'ABUSO SEX MAYOR 14/MENOR 18 CON CIRCUNS ESTUPRO ART 366 INC2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 635
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        635,
        N'ABUSO SEXUAL DE MAYOR DE 14 (CON CIRC. DE VIOLACIÓN) ART 366',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 637
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        637,
        N'VIOLACIÓN DE MAYOR DE 14 AÑOS. ART. 361.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 638
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        638,
        N'CAPTACIÓN, GRAB Y DIFUS DE REGISTROS AUDIOVIS. PARTES ÍNTIMA',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 639
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        639,
        N'ABUSO SEX MAYOR DE 14 AÑOS POR SORPRESA Y/O S/CONSENTIM. ART',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 651
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        651,
        N'EXHIB. REGIS.CONTDO SEX. S/CONSENT. ART. 161 D C.P. INC. 1º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 652
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        652,
        N'DIFUS.REGIS. CONTNDO SEX. S/CONSENT ART. 161 D C.P. INC. 2º',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 699
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        699,
        N'OTROS DEL C/ ORDEN FAMILIA, MORALIDAD Pº, INTEGRIDAD SEXUAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_3_DELITOS_SEXUALES
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (607,608,609,610,619,620,621,622,623,628,629,630,633,634,635,637,638,639,651,652,699)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'DESACATO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'DESACATO'
    );
END;

DECLARE @id_familia_2_4_DESACATO INT;

SELECT @id_familia_2_4_DESACATO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'DESACATO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 12149
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        12149,
        N'DESACATO (Art. 240 Código de Procedimiento Civil)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_4_DESACATO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (12149)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'FEMICIDIO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'FEMICIDIO'
    );
END;

DECLARE @id_familia_2_5_FEMICIDIO INT;

SELECT @id_familia_2_5_FEMICIDIO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'FEMICIDIO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 720
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        720,
        N'FEMICIDIO INTIMO ART. 390 BIS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_5_FEMICIDIO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (720)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'HOMICIDIO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'HOMICIDIO'
    );
END;

DECLARE @id_familia_2_6_HOMICIDIO INT;

SELECT @id_familia_2_6_HOMICIDIO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'HOMICIDIO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 702
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        702,
        N'HOMICIDIO',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 703
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        703,
        N'HOMICIDIO CALIFICADO. ART. 391 Nº 1.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_6_HOMICIDIO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (702,703)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'INCENDIO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'INCENDIO'
    );
END;

DECLARE @id_familia_2_7_INCENDIO INT;

SELECT @id_familia_2_7_INCENDIO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'INCENDIO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 854
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        854,
        N'INCENDIO CON PELIGRO PARA LAS PERSONAS (475 Y 476 N° 1 y 2)',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 855
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        855,
        N'INCENDIO SOLO CON DAÑOS O SIN PELIGRO DE PROP. ART.477 Y 478',
        NULL,
        NULL,
        0,
        0,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_7_INCENDIO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (854,855)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'INCUMPLIMIENTO PAGO PENSIONES'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'INCUMPLIMIENTO PAGO PENSIONES'
    );
END;

DECLARE @id_familia_2_8_INCUMPLIMIENTO_PAGO_PENSIONES INT;

SELECT @id_familia_2_8_INCUMPLIMIENTO_PAGO_PENSIONES = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'INCUMPLIMIENTO PAGO PENSIONES';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 22101
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        22101,
        N'INCUMP. REITERADO PAGO PENSIÓN ALIMENT. ART 14 bis LEY 20066',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_8_INCUMPLIMIENTO_PAGO_PENSIONES
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (22101)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'LESIONES'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'LESIONES'
    );
END;

DECLARE @id_familia_2_9_LESIONES INT;

SELECT @id_familia_2_9_LESIONES = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'LESIONES';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 709
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        709,
        N'LESIONES GRAVES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 710
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        710,
        N'LESIONES MENOS GRAVES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 717
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        717,
        N'LESIONES GRAVES GRAVÍSIMAS. ART. 397 Nº1',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 13001
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        13001,
        N'LESIONES LEVES',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_9_LESIONES
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (709,710,717,13001)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'MALTRATO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'MALTRATO'
    );
END;

DECLARE @id_familia_2_10_MALTRATO INT;

SELECT @id_familia_2_10_MALTRATO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'MALTRATO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 763
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        763,
        N'MALTRATO CORPORAL A PERSONAS VULNERABLES ART 403 BIS INC 1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 764
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        764,
        N'MALTRATO COMETIDO POR GARANTE ART. 403 BIS INC FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 765
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        765,
        N'TRATOS DEGRADANTES A PERSONAS VULNERABLES. ART. 403 TER.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_10_MALTRATO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (763,764,765)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'MALTRATO HABITUAL'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'MALTRATO HABITUAL'
    );
END;

DECLARE @id_familia_2_11_MALTRATO_HABITUAL INT;

SELECT @id_familia_2_11_MALTRATO_HABITUAL = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'MALTRATO HABITUAL';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 22100
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        22100,
        N'MALTRATO HABITUAL (VIOLENCIA INTRAFAMILIAR) ART 14 LEY 20066',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_11_MALTRATO_HABITUAL
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (22100)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'OTROS DELITOS'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'OTROS DELITOS'
    );
END;

DECLARE @id_familia_2_12_OTROS_DELITOS INT;

SELECT @id_familia_2_12_OTROS_DELITOS = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'OTROS DELITOS';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 204
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        204,
        N'VIOLACIÓN DE MORADA. ART. 144',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 221
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        221,
        N'DELITOS C/ LA VIDA Y PRIVACIDAD DE CONVERSACIONES 161 A Y B',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 768
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        768,
        N'SUIC FEM, INDUC SUIC Y/O SUIC FEM ARTS 393 BIS; 390 SEX, TER CP',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 840
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        840,
        N'DAÑOS SIMPLES. ART. 487.',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 1099
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        1099,
        N'OTROS HECHOS',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_12_OTROS_DELITOS
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (204,221,768,840,1099)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'PARRICIDIO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'PARRICIDIO'
    );
END;

DECLARE @id_familia_2_13_PARRICIDIO INT;

SELECT @id_familia_2_13_PARRICIDIO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'PARRICIDIO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 701
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        701,
        N'PARRICIDIO.ART. 390 inc.1°',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_13_PARRICIDIO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (701)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_familia_delito
    WHERE nombre = N'SECUESTRO'
)
BEGIN
    INSERT INTO investigacion.cat_familia_delito (
        nombre
    )
    VALUES (
        N'SECUESTRO'
    );
END;

DECLARE @id_familia_2_14_SECUESTRO INT;

SELECT @id_familia_2_14_SECUESTRO = id_familia_delito
FROM investigacion.cat_familia_delito
WHERE nombre = N'SECUESTRO';


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 202
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        202,
        N'SECUESTRO. ART. 141 INC. 1 Y 2',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 203
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        203,
        N'SUSTRACCIÓN DE MENORES. ART. 142',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 236
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        236,
        N'SECUESTRO CON VIOLACIÓN. ART. 141 INC. FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;


IF NOT EXISTS (
    SELECT 1
    FROM investigacion.cat_delito
    WHERE codigo_capj = 237
)
BEGIN
    INSERT INTO investigacion.cat_delito (
        codigo_capj,
        nombre,
        cuerpo_legal,
        articulo_legal,
        requiere_peritaje_adn,
        vigente,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
        237,
        N'SECUESTRO CON LESIONES. ART. 141 INC. FINAL',
        NULL,
        NULL,
        0,
        1,
        CAST(GETDATE() AS DATE),
        NULL,
        GETDATE(),
        NULL
    );
END;

INSERT INTO investigacion.clasificacion_delito (
    id_delito,
    id_seccion_catalogo,
    id_familia_delito
)
SELECT
    d.id_delito,
    @id_seccion_2,
    @id_familia_2_14_SECUESTRO
FROM investigacion.cat_delito d
WHERE d.codigo_capj IN (202,203,236,237)
AND NOT EXISTS (
    SELECT 1
    FROM investigacion.clasificacion_delito c
    WHERE c.id_delito = d.id_delito
      AND c.id_seccion_catalogo = @id_seccion_2
);
GO

IF NOT EXISTS (SELECT 1 FROM investigacion.cat_grado_ejecucion)
BEGIN
INSERT INTO investigacion.cat_grado_ejecucion
(
id_grado_ejecucion,
codigo,
nombre
)
VALUES
(1, 'CONSUMADO', 'Consumado'),
(2, 'TENTATIVA', 'Tentativa'),
(3, 'FRUSTRADO', 'Frustrado')
END
GO

IF NOT EXISTS (SELECT 1 FROM investigacion.cat_transporte_utilizado)
BEGIN
INSERT INTO investigacion.cat_transporte_utilizado
(
codigo,
nombre,
vigente,
fecha_creacion
)
VALUES
('A_PIE', 'A pie', 1, GETUTCDATE()),
('AUTO', 'Auto', 1, GETUTCDATE()),
('MOTO', 'Moto', 1, GETUTCDATE()),
('BICICLETA', 'Bicicleta', 1, GETUTCDATE()),
('TRANSPORTE_PUBLICO', 'Transporte público', 1, GETUTCDATE()),
('CAMION', 'Camión', 1, GETUTCDATE())
END
GO

IF NOT EXISTS (SELECT 1 FROM investigacion.cat_punto_acceso)
BEGIN
INSERT INTO investigacion.cat_punto_acceso
(
codigo,
nombre,
vigente,
fecha_creacion
)
VALUES
('PUERTA_PRINCIPAL', 'Puerta principal', 1, GETUTCDATE()),
('VENTANA', 'Puerta principal', 1, GETUTCDATE()),
('PATIO_TRASERO', 'Patio trasero', 1, GETUTCDATE()),
('FORZADO', 'Forzado', 1, GETUTCDATE()),
('VIA_PUBLICA', 'Sin acceso (vía pública)', 1, GETUTCDATE()),
('TECHO', 'Techo', 1, GETUTCDATE()),
('MURO', 'Muro', 1, GETUTCDATE()),
('BODEGA', 'Bodega', 1, GETUTCDATE()),
('SUBTERRANEO', 'Subterráneo', 1, GETUTCDATE()),
('ESTACIONAMIENTO', 'Estacionamiento', 1, GETUTCDATE())
END
GO

IF NOT EXISTS (SELECT 1 FROM investigacion.cat_forma_contacto)
BEGIN
INSERT INTO investigacion.cat_forma_contacto
(
codigo,
nombre,
vigente,
fecha_creacion
)
VALUES
('INTIMIDACION',		     'Intimidación', 1, GETUTCDATE()),
('ENGANIO',			     	 'Engaño', 1, GETUTCDATE()),
('ACERCAMIENTO_FISICO',		 'Acercamiento físico', 1, GETUTCDATE()),
('VIA_DIGITAL',				 'Vía digital', 1, GETUTCDATE()),
('DISTRACCION',				 'Distracción', 1, GETUTCDATE())
END
GO

SET IDENTITY_INSERT investigacion.cat_lugar_general_hecho ON;
GO

IF NOT EXISTS (SELECT 1 FROM investigacion.cat_lugar_general_hecho)
BEGIN
INSERT INTO investigacion.cat_lugar_general_hecho
(
id_lugar_general_hecho,
codigo,
descripcion,
activo
)
VALUES
(1 , 'LUGAR GEOGRÁFICO', 'LUGAR GEOGRÁFICO', 1),
(2 , 'DOMICILIO PARTICULAR', 'DOMICILIO PARTICULAR-RECINTO PRIVADO', 1),
(3 , 'LUGAR PUBLICO Y/O ME', 'LUGAR PUBLICO Y/O MEDIO TRANSPORTE', 1),
(4 , 'RECINTOS O LUGARES C', 'RECINTOS O LUGARES COMERCIALES', 1),
(5 , 'EDUCACION', 'EDUCACION', 1),
(6 , 'RECINTOS GUBERNAMENT', 'RECINTOS GUBERNAMENTALES', 1),
(7 , 'CENTRO DEPORTIVO-REC', 'CENTRO DEPORTIVO-RECREACIONAL', 1),
(8 , 'INTERNET', 'INTERNET', 1),
(9 , 'SBIF', 'SBIF', 1),
(10, 'TELEFONIA', 'TELEFONIA', 1),
(11, 'ESTACION DE SERVICIO', 'ESTACION DE SERVICIO (SERVICENTRO)', 1),
(12, 'SALUD', 'SALUD', 1),
(13, 'ESTABLECIMIENTOS PEN', 'ESTABLECIMIENTOS PENITENCIARIOS', 1),
(14, 'CULTURA', 'CULTURA', 1),
(15, 'RELIGIOSO', 'RELIGIOSO', 1),
(16, 'LUGAR DE HOSPEDAJE', 'LUGAR DE HOSPEDAJE', 1),
(17, 'FUERZAS ARMADAS Y DE', 'FUERZAS ARMADAS Y DE ORDEN', 1),
(18, 'HOGAR O CASA DE ACOG', 'HOGAR O CASA DE ACOGIDA', 1),
(20, 'AUTOPISTA', 'AUTOPISTA', 1)
END

SET IDENTITY_INSERT investigacion.cat_lugar_general_hecho OFF;
GO

IF NOT EXISTS (SELECT 1 FROM investigacion.cat_detalle_lugar_general_hecho)
BEGIN
INSERT INTO investigacion.cat_detalle_lugar_general_hecho
(
id_lugar_general_hecho,
codigo,
descripcion,
activo
)
VALUES
(1, 'URBANO',	'URBANO',1),
(1, 'RURAL',	'RURAL',1),
(1, 'PASO NO HABILITADO',	'PASO NO HABILITADO',1),
(1, 'CORDILLERANO',	'CORDILLERANO',1),
(1, 'HIDROGRAFICO',	'HIDROGRAFICO',1),
(1, 'COSTERO',	'COSTERO',1),
(1, 'VALLES',	'VALLES',1),
(1, 'OTROSx',	'OTROS',1),
(2, 'PARTICULAR',	'PARTICULAR',1),
(2, 'LABORAL O COMERCIAL',	'LABORAL O COMERCIAL',1),
(2, 'OTROxx',	'OTRO',1),
(3, 'TRANSPORTE AEREO',	'TRANSPORTE AEREO',1),
(3, 'TRANSPORTE MARITIMO',	'TRANSPORTE MARITIMO',1),
(3, 'TREN',	'TREN',1),
(3, 'METROTREN',	'METROTREN',1),
(3, 'VEHICULO LIVIANO',	'VEHICULO LIVIANO',1),
(3, 'VEHICULO FISCAL',	'VEHICULO FISCAL',1),
(3, 'VEHICULOS PESADOS',	'VEHICULOS PESADOS',1),
(3, 'TREN SUBTERRANEO',	'TREN SUBTERRANEO',1),
(3, 'AEROPUERTO',	'AEROPUERTO',1),
(3, 'TERMINAL PUBLICO',	'TERMINAL PUBLICO',1),
(3, 'OTROSxxx',	'OTROS',1),
(3, 'PLAZA DE PEAJE',	'PLAZA DE PEAJE',1),
(3, 'PASO HABILITADO',	'PASO HABILITADO',1),
(3, 'VÍA PUBLICA',	'VÍA PUBLICA',1),
(4, 'BANCO - ENTIDAD FINA',	'BANCO - ENTIDAD FINACIERA',1),
(4, 'TIENDA - MERCADO - L',	'TIENDA - MERCADO - LOCAL',1),
(4, 'BODEGA',	'BODEGA',1),
(4, 'OFICINA - EMPRESA',	'OFICINA - EMPRESA',1),
(4, 'TALLER - FABRICA',	'TALLER - FABRICA',1),
(4, 'HOTEL - MOTEL',	'HOTEL - MOTEL',1),
(4, 'MALL-STREET CENTER',	'MALL-STREET CENTER',1),
(4, 'FERIAS LIBRES',	'FERIAS LIBRES',1),
(4, 'OTROSxxxx',	'OTROS',1),
(5, 'COLEGIO O LICEO',	'COLEGIO O LICEO',1),
(5, 'JARDIN INFANTIL-SALA',	'JARDIN INFANTIL-SALA CUNA',1),
(5, 'UNIVERSIDAD',	'UNIVERSIDAD',1),
(5, 'INSTITUTO TECNICO O ',	'INSTITUTO TECNICO O SUPERIOR',1),
(5, 'OTROSxxxxx',	'OTROS',1),
(6, 'ARMADA',	'ARMADA',1),
(6, 'GENDARMERIA',	'GENDARMERIA',1),
(6, 'FISCALIA',	'FISCALIA',1),
(6, 'BOMBEROS',	'BOMBEROS',1),
(6, 'MINISTERIO',	'MINISTERIO',1),
(6, 'OTRA ENTIDAD PUBLICA',	'OTRA ENTIDAD PUBLICA',1),
(6, 'INTENDENCIAS',	'INTENDENCIAS',1),
(6, 'GOBERNACIONES',	'GOBERNACIONES',1),
(6, 'MUNICIPALIDADES',	'MUNICIPALIDADES',1),
(7, 'ESTADIO',	'ESTADIO',1),
(7, 'MULTICANCHA',	'MULTICANCHA',1),
(7, 'GIMNASIO',	'GIMNASIO',1),
(7, 'CENTRO RECREACIONAL',	'CENTRO RECREACIONAL',1),
(7, 'PARQUE DE DIVERSION ',	'PARQUE DE DIVERSION O RECREATIVO',1),
(7, 'PISCINA',	'PISCINA',1),
(7, 'CENTRO DE SKY',	'CENTRO DE SKY',1),
(7, 'OTROSxxxxxx',	'OTROS',1),
(8, 'REDES SOCIALES',	'REDES SOCIALES',1),
(8, 'CORREO ELECTRONICO',	'CORREO ELECTRONICO',1),
(8, 'MENSAJERIA INSTANTAN',	'MENSAJERIA INSTANTANEA - CHAT',1),
(8, 'FOROS',	'FOROS',1),
(8, 'PAGINAS WEB',	'PAGINAS WEB',1),
(8, 'OTROSxxxxxxx',	'OTROS',1),
(9, 'BANCO DE CHILE',	'BANCO DE CHILE',1),
(9, 'BANCO INTERNACIONAL',	'BANCO INTERNACIONAL',1),
(9, 'BANCO DEL ESTADO DE ',	'BANCO DEL ESTADO DE CHILE',1),
(9, 'SCOTIABANK',	'SCOTIABANK',1),
(9, 'BANCO DE CRÉDITO E I',	'BANCO DE CRÉDITO E INVERSIONES',1),
(9, 'BANCO DO BRASIL S.A.',	'BANCO DO BRASIL S.A.',1),
(9, 'CORPBANCA',	'CORPBANCA',1),
(9, 'BANCO BICE',	'BANCO BICE',1),
(9, 'HSBC BANK (CHILE)',	'HSBC BANK (CHILE)',1),
(9, 'BANCO SANTANDER - CH',	'BANCO SANTANDER - CHILE',1),
(9, 'BANCO ITAU CHILE',	'BANCO ITAU CHILE',1),
(9, 'JP MORGAN CHASE BANK',	'JP MORGAN CHASE BANK, N.A.',1),
(9, 'BANCO DE LA NACIÓN A',	'BANCO DE LA NACIÓN ARGENTINA',1),
(9, 'THE BANK OF TOKYO - ',	'THE BANK OF TOKYO - MITSUBISHI UFJ LTD',1),
(9, 'BANCO SECURITY',	'BANCO SECURITY',1),
(9, 'BANCO FALABELLA',	'BANCO FALABELLA',1),
(9, 'DEUTSCHE BANK (CHILE',	'DEUTSCHE BANK (CHILE)',1),
(9, 'BANCO RIPLEY',	'BANCO RIPLEY',1),
(9, 'RABOBANK CHILE',	'RABOBANK CHILE',1),
(9, 'BANCO CONSORCIO',	'BANCO CONSORCIO',1),
(9, 'BANCO PENTA',	'BANCO PENTA',1),
(9, 'BANCO PARIS',	'BANCO PARIS',1),
(9, 'DNB BANK ASA',	'DNB BANK ASA',1),
(9, 'BANCO BILBAO VIZCAYA',	'BANCO BILBAO VIZCAYA ARGENTARIA, CHILE',1),
(10,'CELULAR',	'CELULAR',1),
(10,'FIJA',	'FIJA',1),
(10,'MENSAJERIA',	'MENSAJERIA',1),
(10,'OTROz',	'OTRO',1),
(11,'BENCINERA',	'BENCINERA',1),
(11,'LUBRICACION',	'LUBRICACION',1),
(11,'TIENDA',	'TIENDA',1),
(11,'LAVADO',	'LAVADO',1),
(11,'OTROSzz',	'OTROS',1),
(12,'CENTRO MEDICO',	'CENTRO MEDICO',1),
(12,'CLINICA',	'CLINICA',1),
(12,'CONSULTORIO',	'CONSULTORIO',1),
(12,'HOSPITAL',	'HOSPITAL',1),
(12,'POLICLINICO',	'POLICLINICO',1),
(12,'OTROSzzz',	'OTROS',1),
(13,'CENTRO DE DETENCI?N ',	'CENTRO DE DETENCI?N PENITENCIARIO',1),
(13,'CENTRO DE CUMPLIMIEN',	'CENTRO DE CUMPLIMIENTO PENITENCIARIO',1),
(13,'CENTRO PENITENCIARIO',	'CENTRO PENITENCIARIO FEMENINO',1),
(13,'COMPLEJO PENITENCIAR',	'COMPLEJO PENITENCIARIO',1),
(13,'SENAME',	'SENAME',1),
(14,'MUSEO',	'MUSEO',1),
(14,'BIBLIOTECA',	'BIBLIOTECA',1),
(14,'FERIAS O EXPOSICIONE',	'FERIAS O EXPOSICIONES',1),
(14,'OTROzzzz',	'OTRO',1),
(15,'IGLESIA-CAPILLA',	'IGLESIA-CAPILLA',1),
(15,'SALON',	'SALON',1),
(15,'MESQUITA',	'MESQUITA',1),
(15,'TEMPLO',	'TEMPLO',1),
(15,'CULTO',	'CULTO',1),
(15,'OTROzzzzz',	'OTRO',1),
(16,'APART-HOTEL',	'APART-HOTEL',1),
(16,'HOSTERIA',	'HOSTERIA',1),
(16,'HOTEL',	'HOTEL',1),
(16,'MOTEL-CABAÑAS',	'MOTEL-CABAÑAS',1),
(16,'RESIDENCIALES',	'RESIDENCIALES',1),
(16,'HOSPEDAJE',	'HOSPEDAJE',1),
(16,'CENTRO VACACIONAL',	'CENTRO VACACIONAL',1),
(16,'CASA DE ACOGIDA',	'CASA DE ACOGIDA',1),
(16,'OTROSzzzzzz',	'OTROS',1),
(17,'ARMADA2',	'ARMADA',1),
(17,'AVIACION',	'AVIACION',1),
(17,'EJERCITO',	'EJERCITO',1),
(17,'CARABINEROS',	'CARABINEROS',1),
(17,'PDI',	'PDI',1),
(18,'SENAME2',	'SENAME',1),
(18,'SERNAM',	'SERNAM',1),
(18,'FUNDACIONES',	'FUNDACIONES',1),
(18,'PARTICULARES',	'PARTICULARES',1),
(18,'OTROSy',	'OTROS',1),
(20,'AUTOPISTA CONCESIONA',	'AUTOPISTA CONCESIONADA',1),
(20,'AUTOPISTA ESTATAL',	'AUTOPISTA ESTATAL',1)
END
GO

-- fenómenos dummy para pruebas
IF NOT EXISTS (SELECT 1 FROM investigacion.fenomeno_delictual)
BEGIN
INSERT INTO investigacion.fenomeno_delictual
(
codigo_mp,
nombre,
descripcion,
anio_vigencia,
vigente,
fecha_creacion
)
VALUES
('FD001',	'Crimen Organizado',	'asociación criminal, lavado, tráfico, armas', 2025, 1, GETUTCDATE()),
('FD002',	'Narcotráfico',	'tráfico, microtráfico, precursores', 2025, 1, GETUTCDATE()),
('FD003',	'Homicidios y Violencia Grave',	'homicidio, secuestro, tortura', 2025, 1, GETUTCDATE()),
('FD004',	'Robo Violento',	'robo con violencia/intimidación, encerronas', 2025, 1, GETUTCDATE()),
('FD005',	'Robo Organizado de Vehículos',	'robo de vehículos, clonación, receptación', 2025, 1, GETUTCDATE()),
('FD006',	'Delitos Económicos y Financieros',	'estafa, fraude, lavado, apropiación indebida', 2025, 1, GETUTCDATE()),
('FD007',	'Ciberdelincuencia',	'phishing, sabotaje, fraude informático', 2025, 1, GETUTCDATE()),
('FD008',	'Delitos Sexuales',	'violación, abuso, explotación', 2025, 1, GETUTCDATE()),
('FD009',	'Violencia Intrafamiliar y Género',	'VIF, amenazas, desacato', 2025, 1, GETUTCDATE()),
('FD010',	'Trata y Tráfico de Personas',	'trata, explotación, tráfico migrantes', 2025, 1, GETUTCDATE()),
('FD011',	'Corrupción y Probidad',	'cohecho, fraude al fisco', 2025, 1, GETUTCDATE()),
('FD012',	'Tráfico y Tenencia de Armas',	'ley de armas, tráfico', 2025, 1, GETUTCDATE()),
('FD013',	'Delitos Migratorios',	'ingreso clandestino, falsificación documental', 2025, 1, GETUTCDATE()),
('FD014',	'Delitos Contra la Propiedad',	'hurtos, daños, usurpaciones', 2025, 1, GETUTCDATE()),
('FD015',	'Delitos Ambientales',	'contaminación, tráfico fauna', 2025, 1, GETUTCDATE()),
('FD016',	'Incendios e Infraestructura Crítica',	'incendios, sabotaje', 2025, 1, GETUTCDATE()),
('FD017',	'Violencia Rural',	'usurpación, atentados, armas', 2025, 1, GETUTCDATE()),
('FD018',	'Personas Desaparecidas y Secuestros',	'presunta desgracia, secuestro', 2025, 1, GETUTCDATE()),
('FD019',	'Receptación y Mercados Ilícitos',	'receptación, contrabando', 2025, 1, GETUTCDATE()),
('FD020',	'Delincuencia Juvenil Violenta',	'robos violentos cometidos por menores', 2025, 1, GETUTCDATE())
END
GO