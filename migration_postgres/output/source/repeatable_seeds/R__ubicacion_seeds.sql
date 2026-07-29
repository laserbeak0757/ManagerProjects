IF NOT EXISTS (SELECT 1 FROM [ubicacion].[pais])
BEGIN

INSERT INTO [ubicacion].[pais] (id_pais, descripcion, codigo_iso_alpha_3, codigo_iso_alpha_2)
VALUES
(4, N'Afganistán', N'AFG', N'AF'), (8, N'Albania', N'ALB', N'AL'), (10, N'Antártida', N'ATA', N'AQ'), (12, N'Argelia', N'DZA', N'DZ'), (16, N'Samoa Americana', N'ASM', N'AS'), (20, N'Andorra', N'AND', N'AD'), (24, N'Angola', N'AGO', N'AO'), (28, N'Antigua y Barbuda', N'ATG', N'AG'), (31, N'Azerbaiyán', N'AZE', N'AZ'), (32, N'Argentina', N'ARG', N'AR'), (36, N'Australia', N'AUS', N'AU'), (40, N'Austria', N'AUT', N'AT'), (44, N'Bahamas', N'BHS', N'BS'), (48, N'Bahrein', N'BHR', N'BH'), (50, N'Bangladesh', N'BGD', N'BD'), (51, N'Armenia', N'ARM', N'AM'), (52, N'Barbados', N'BRB', N'BB'), (56, N'Bélgica', N'BEL', N'BE'), (60, N'Bermudas', N'BMU', N'BM'), (64, N'Bután', N'BTN', N'BT'), (68, N'Bolivia', N'BOL', N'BO'), (70, N'Bosnia y Herzegovina', N'BIH', N'BA'), (72, N'Botswana', N'BWA', N'BW'), (74, N'Isla Bouvet', N'BVT', N'BV'), (76, N'Brasil', N'BRA', N'BR'), (84, N'Belice', N'BLZ', N'BZ'), (86, N'Territorio Británico del Océano Índico', N'IOT', N'IO'), (90, N'Islas Salomón', N'SLB', N'SB'), (92, N'Islas Vírgenes del Reino Unido', N'VGB', N'VG'), (96, N'Brunei', N'BRN', N'BN'), (100, N'Bulgaria', N'BGR', N'BG'), (104, N'Myanmar', N'MMR', N'MM'), (108, N'Burundi', N'BDI', N'BI'), (112, N'Bielorrusia', N'BLR', N'BY'), (116, N'Camboya', N'KHM', N'KH'), (120, N'Camerún', N'CMR', N'CM'), (124, N'Canadá', N'CAN', N'CA'), (132, N'Cabo Verde', N'CPV', N'CV'), (136, N'Islas Caimán', N'CYM', N'KY'), (140, N'República Centroafricana', N'CAF', N'CF'), (144, N'Sri Lanka', N'LKA', N'LK'), (148, N'Chad', N'TCD', N'TD'), (152, N'Chile', N'CHL', N'CL'), (156, N'China', N'CHN', N'CN'), (158, N'Taiwán', N'TWN', N'TW'), (162, N'Isla de Navidad', N'CXR', N'CX'), (166, N'Islas Cocos o Islas Keeling', N'CCK', N'CC'), (170, N'Colombia', N'COL', N'CO'), (174, N'Comoras', N'COM', N'KM'), (175, N'Mayotte', N'MYT', N'YT');

INSERT INTO [ubicacion].[pais] (id_pais, descripcion, codigo_iso_alpha_3, codigo_iso_alpha_2)
VALUES
(178, N'Congo', N'COG', N'CG'), (180, N'Congo (Rep. Dem.)', N'COD', N'CD'), (184, N'Islas Cook', N'COK', N'CK'), (188, N'Costa Rica', N'CRI', N'CR'), (191, N'Croacia', N'HRV', N'HR'), (192, N'Cuba', N'CUB', N'CU'), (196, N'Chipre', N'CYP', N'CY'), (203, N'Chequia', N'CZE', N'CZ'), (204, N'Benín', N'BEN', N'BJ'), (208, N'Dinamarca', N'DNK', N'DK'), (212, N'Dominica', N'DMA', N'DM'), (214, N'República Dominicana', N'DOM', N'DO'), (218, N'Ecuador', N'ECU', N'EC'), (222, N'El Salvador', N'SLV', N'SV'), (226, N'Guinea Ecuatorial', N'GNQ', N'GQ'), (231, N'Etiopía', N'ETH', N'ET'), (232, N'Eritrea', N'ERI', N'ER'), (233, N'Estonia', N'EST', N'EE'), (234, N'Islas Faroe', N'FRO', N'FO'), (238, N'Islas Malvinas', N'FLK', N'FK'), (239, N'Islas Georgias del Sur y Sandwich del Sur', N'SGS', N'GS'), (242, N'Fiyi', N'FJI', N'FJ'), (246, N'Finlandia', N'FIN', N'FI'), (248, N'Alandia', N'ALA', N'AX'), (250, N'Francia', N'FRA', N'FR'), (254, N'Guayana Francesa', N'GUF', N'GF'), (258, N'Polinesia Francesa', N'PYF', N'PF'), (260, N'Tierras Australes y Antárticas Francesas', N'ATF', N'TF'), (262, N'Djibouti', N'DJI', N'DJ'), (266, N'Gabón', N'GAB', N'GA'), (268, N'Georgia', N'GEO', N'GE'), (270, N'Gambia', N'GMB', N'GM'), (275, N'Palestina', N'PSE', N'PS'), (276, N'Alemania', N'DEU', N'DE'), (288, N'Ghana', N'GHA', N'GH'), (292, N'Gibraltar', N'GIB', N'GI'), (296, N'Kiribati', N'KIR', N'KI'), (300, N'Grecia', N'GRC', N'GR'), (304, N'Groenlandia', N'GRL', N'GL'), (308, N'Grenada', N'GRD', N'GD'), (312, N'Guadalupe', N'GLP', N'GP'), (316, N'Guam', N'GUM', N'GU'), (320, N'Guatemala', N'GTM', N'GT'), (324, N'Guinea', N'GIN', N'GN'), (328, N'Guyana', N'GUY', N'GY'), (332, N'Haití', N'HTI', N'HT'), (334, N'Islas Heard y McDonald', N'HMD', N'HM'), (336, N'Ciudad del Vaticano', N'VAT', N'VA'), (340, N'Honduras', N'HND', N'HN'), (344, N'Hong Kong', N'HKG', N'HK');

INSERT INTO [ubicacion].[pais] (id_pais, descripcion, codigo_iso_alpha_3, codigo_iso_alpha_2)
VALUES
(348, N'Hungría', N'HUN', N'HU'), (352, N'Islandia', N'ISL', N'IS'), (356, N'India', N'IND', N'IN'), (360, N'Indonesia', N'IDN', N'ID'), (364, N'Iran', N'IRN', N'IR'), (368, N'Irak', N'IRQ', N'IQ'), (372, N'Irlanda', N'IRL', N'IE'), (376, N'Israel', N'ISR', N'IL'), (380, N'Italia', N'ITA', N'IT'), (384, N'Costa de Marfil', N'CIV', N'CI'), (388, N'Jamaica', N'JAM', N'JM'), (392, N'Japón', N'JPN', N'JP'), (398, N'Kazajistán', N'KAZ', N'KZ'), (400, N'Jordania', N'JOR', N'JO'), (404, N'Kenia', N'KEN', N'KE'), (408, N'Corea del Norte', N'PRK', N'KP'), (410, N'Corea del Sur', N'KOR', N'KR'), (414, N'Kuwait', N'KWT', N'KW'), (417, N'Kirguizistán', N'KGZ', N'KG'), (418, N'Laos', N'LAO', N'LA'), (422, N'Líbano', N'LBN', N'LB'), (426, N'Lesotho', N'LSO', N'LS'), (428, N'Letonia', N'LVA', N'LV'), (430, N'Liberia', N'LBR', N'LR'), (434, N'Libia', N'LBY', N'LY'), (438, N'Liechtenstein', N'LIE', N'LI'), (440, N'Lituania', N'LTU', N'LT'), (442, N'Luxemburgo', N'LUX', N'LU'), (446, N'Macao', N'MAC', N'MO'), (450, N'Madagascar', N'MDG', N'MG'), (454, N'Malawi', N'MWI', N'MW'), (458, N'Malasia', N'MYS', N'MY'), (462, N'Maldivas', N'MDV', N'MV'), (466, N'Mali', N'MLI', N'ML'), (470, N'Malta', N'MLT', N'MT'), (474, N'Martinica', N'MTQ', N'MQ'), (478, N'Mauritania', N'MRT', N'MR'), (480, N'Mauricio', N'MUS', N'MU'), (484, N'México', N'MEX', N'MX'), (492, N'Mónaco', N'MCO', N'MC'), (496, N'Mongolia', N'MNG', N'MN'), (498, N'Moldavia', N'MDA', N'MD'), (499, N'Montenegro', N'MNE', N'ME'), (500, N'Montserrat', N'MSR', N'MS'), (504, N'Marruecos', N'MAR', N'MA'), (508, N'Mozambique', N'MOZ', N'MZ'), (512, N'Omán', N'OMN', N'OM'), (516, N'Namibia', N'NAM', N'NA'), (520, N'Nauru', N'NRU', N'NR'), (524, N'Nepal', N'NPL', N'NP');

INSERT INTO [ubicacion].[pais] (id_pais, descripcion, codigo_iso_alpha_3, codigo_iso_alpha_2)
VALUES
(528, N'Países Bajos', N'NLD', N'NL'), (531, N'Curazao', N'CUW', N'CW'), (533, N'Aruba', N'ABW', N'AW'), (534, N'Sint Maarten', N'SXM', N'SX'), (535, N'Caribe Neerlandés', N'BES', N'BQ'), (540, N'Nueva Caledonia', N'NCL', N'NC'), (548, N'Vanuatu', N'VUT', N'VU'), (554, N'Nueva Zelanda', N'NZL', N'NZ'), (558, N'Nicaragua', N'NIC', N'NI'), (562, N'Níger', N'NER', N'NE'), (566, N'Nigeria', N'NGA', N'NG'), (570, N'Niue', N'NIU', N'NU'), (574, N'Isla de Norfolk', N'NFK', N'NF'), (578, N'Noruega', N'NOR', N'NO'), (580, N'Islas Marianas del Norte', N'MNP', N'MP'), (581, N'Islas Ultramarinas Menores de Estados Unidos', N'UMI', N'UM'), (583, N'Micronesia', N'FSM', N'FM'), (584, N'Islas Marshall', N'MHL', N'MH'), (585, N'Palau', N'PLW', N'PW'), (586, N'Pakistán', N'PAK', N'PK'), (591, N'Panamá', N'PAN', N'PA'), (598, N'Papúa Nueva Guinea', N'PNG', N'PG'), (600, N'Paraguay', N'PRY', N'PY'), (604, N'Perú', N'PER', N'PE'), (608, N'Filipinas', N'PHL', N'PH'), (612, N'Islas Pitcairn', N'PCN', N'PN'), (616, N'Polonia', N'POL', N'PL'), (620, N'Portugal', N'PRT', N'PT'), (624, N'Guinea-Bisáu', N'GNB', N'GW'), (626, N'Timor Oriental', N'TLS', N'TL'), (630, N'Puerto Rico', N'PRI', N'PR'), (634, N'Catar', N'QAT', N'QA'), (638, N'Reunión', N'REU', N'RE'), (642, N'Rumania', N'ROU', N'RO'), (643, N'Rusia', N'RUS', N'RU'), (646, N'Ruanda', N'RWA', N'RW'), (652, N'San Bartolomé', N'BLM', N'BL'), (654, N'Santa Elena, Ascensión y Tristán de Acuña', N'SHN', N'SH'), (659, N'San Cristóbal y Nieves', N'KNA', N'KN'), (660, N'Anguilla', N'AIA', N'AI'), (662, N'Santa Lucía', N'LCA', N'LC'), (663, N'Saint Martin', N'MAF', N'MF'), (666, N'San Pedro y Miquelón', N'SPM', N'PM'), (670, N'San Vicente y Granadinas', N'VCT', N'VC'), (674, N'San Marino', N'SMR', N'SM'), (678, N'Santo Tomé y Príncipe', N'STP', N'ST'), (682, N'Arabia Saudí', N'SAU', N'SA'), (686, N'Senegal', N'SEN', N'SN'), (688, N'Serbia', N'SRB', N'RS'), (690, N'Seychelles', N'SYC', N'SC');

INSERT INTO [ubicacion].[pais] (id_pais, descripcion, codigo_iso_alpha_3, codigo_iso_alpha_2)
VALUES
(694, N'Sierra Leone', N'SLE', N'SL'), (702, N'Singapur', N'SGP', N'SG'), (703, N'República Eslovaca', N'SVK', N'SK'), (704, N'Vietnam', N'VNM', N'VN'), (705, N'Eslovenia', N'SVN', N'SI'), (706, N'Somalia', N'SOM', N'SO'), (710, N'Sudáfrica', N'ZAF', N'ZA'), (716, N'Zimbabue', N'ZWE', N'ZW'), (724, N'España', N'ESP', N'ES'), (728, N'Sudán del Sur', N'SSD', N'SS'), (729, N'Sudán', N'SDN', N'SD'), (732, N'Sahara Occidental', N'ESH', N'EH'), (740, N'Surinam', N'SUR', N'SR'), (744, N'Islas Svalbard y Jan Mayen', N'SJM', N'SJ'), (748, N'Suazilandia', N'SWZ', N'SZ'), (752, N'Suecia', N'SWE', N'SE'), (756, N'Suiza', N'CHE', N'CH'), (760, N'Siria', N'SYR', N'SY'), (762, N'Tayikistán', N'TJK', N'TJ'), (764, N'Tailandia', N'THA', N'TH'), (768, N'Togo', N'TGO', N'TG'), (772, N'Islas Tokelau', N'TKL', N'TK'), (776, N'Tonga', N'TON', N'TO'), (780, N'Trinidad y Tobago', N'TTO', N'TT'), (784, N'Emiratos Árabes Unidos', N'ARE', N'AE'), (788, N'Túnez', N'TUN', N'TN'), (792, N'Turquía', N'TUR', N'TR'), (795, N'Turkmenistán', N'TKM', N'TM'), (796, N'Islas Turks y Caicos', N'TCA', N'TC'), (798, N'Tuvalu', N'TUV', N'TV'), (800, N'Uganda', N'UGA', N'UG'), (804, N'Ucrania', N'UKR', N'UA'), (807, N'Macedonia del Norte', N'MKD', N'MK'), (818, N'Egipto', N'EGY', N'EG'), (826, N'Reino Unido', N'GBR', N'GB'), (831, N'Guernsey', N'GGY', N'GG'), (832, N'Jersey', N'JEY', N'JE'), (833, N'Isla de Man', N'IMN', N'IM'), (834, N'Tanzania', N'TZA', N'TZ'), (840, N'Estados Unidos', N'USA', N'US'), (850, N'Islas Vírgenes de los Estados Unidos', N'VIR', N'VI'), (854, N'Burkina Faso', N'BFA', N'BF'), (858, N'Uruguay', N'URY', N'UY'), (860, N'Uzbekistán', N'UZB', N'UZ'), (862, N'Venezuela', N'VEN', N'VE'), (876, N'Wallis y Futuna', N'WLF', N'WF'), (882, N'Samoa', N'WSM', N'WS'), (887, N'Yemen', N'YEM', N'YE'), (894, N'Zambia', N'ZMB', N'ZM'), (999, N'Kosovo', N'UNK', N'XK');

END
GO
IF NOT EXISTS (SELECT 1 FROM ubicacion.cat_tipo_lugar)
BEGIN
INSERT INTO ubicacion.cat_tipo_lugar
(
codigo,
nombre,
fecha_creacion
)
VALUES
('BLOCK', 'Block', GETDATE()),
('CASA', 'Casa', GETDATE()),
('DEPARTAMENTO', 'Departamento', GETDATE()),
('LOCAL_COMERCIAL', 'Local Comercial', GETDATE()),
('RUCA', 'RUCA', GETDATE()),
('CITE', 'CITE', GETDATE()),
('CASA_RODANTE', 'Casa Rodante', GETDATE()),
('VIA_PUBLICA', 'Vía Pública', GETDATE()),
('PLAYA_DE_ESTACIONAMIENTO', 'Playa de Estacionamiento', GETDATE()),
('MUSEO', 'Museo', GETDATE()),
('MALL_O_CENTRO_COMERCIAL', 'Mall o Centro Comercial', GETDATE()),
('SUPERMERCADO', 'Supermercado', GETDATE()),
('IGLESIA', 'Iglesia', GETDATE()),
('PARCELA', 'Parcela', GETDATE()),
('INTERIOR_OFICINA', 'Interior - Oficina', GETDATE()),
('INTERIOR_BUS_LOCOM_COLECTIVA', 'Interior - Buses y Locomotoras Colectivas', GETDATE()),
('RESTAURANT', 'Restaurante', GETDATE()),
('INT_ESTACIONAMIENTO_SUPER_MALL', 'Interior - Estacionamiento Super Mall', GETDATE()),
('INTERIOR_BOSQUE', 'Interior - Bosque', GETDATE()),
('INTERIOR_CUARTEL_POLICIAL', 'Interior - Cuartel Policial', GETDATE()),
('INTERIOR_DE_VEHICULO', 'Interior - De Vehículo', GETDATE()),
('BANCO_SIMILARES', 'Banco Similares', GETDATE()),
('HOSPITAL', 'Hospital', GETDATE()),
('COLEGIO', 'Colegio', GETDATE()),
('INDUSTRIAS_SIMILARES', 'Industrias Similares', GETDATE()),
('SECTOR', 'Sector', GETDATE()),
('RESIDENCIAL', 'Residencial', GETDATE()),
('HOSPEDAJES', 'Hospedaje', GETDATE()),
('MOTEL', 'Motel', GETDATE()),
('DOMICILIO', 'Domicilio', GETDATE()),
('INTERIOR_SUCURSAL_INP', 'Interior - Sucursal INP', GETDATE()),
('INTERIOR_ESTACION_DE_SERVICIO', 'Interior - Estación de Servicio', GETDATE()),
('PLAZA', 'Plaza', GETDATE()),
('RECINTO_MILITAR', 'Recinto Militar', GETDATE()),
('RECINTO_CARCELARIO', 'Recinto Carcelario', GETDATE()),
('SITIO_ERIAZO', 'Sitio Eriazo', GETDATE()),
('RECINTO_DEPORTIVO', 'Recinto Deportivo', GETDATE()),
('TERMINAL_DE_LOCOMOCIONES', 'Terminal de Locomociones', GETDATE()),
('RIBERA_DE_RIO', 'Ribera de Río', GETDATE()),
('RIBERA_DE_LAGO', 'Ribera de Lago', GETDATE()),
('BORDE_COSTERO', 'Borde Costero', GETDATE()),
('INTERIOR_OBRA_EN_CONSTRUCCION', 'Interior - Obra en Construcción', GETDATE()),
('BODEGA', 'Bodega', GETDATE()),
('EMPRESA', 'Empresa', GETDATE()),
('CENTRO_COMERCIAL', 'Centro Comercial', GETDATE()),
('NO_REGISTRA', 'No Registra', GETDATE()),
('UNIVERSIDAD', 'Universidad', GETDATE()),
('HIJUELA', 'Hijuela', GETDATE()),
('MUNICIPALIDAD', 'Municipalidad', GETDATE()),
('QUEBRADA', 'Quebrada', GETDATE()),
('FUNDO', 'Fundo', GETDATE()),
('CENTROS_CLINICOS_SIMILARES', 'Centros Clínicos Similares', GETDATE()),
('CONSULTORIO', 'Consultorio', GETDATE()),
('LABORATORIO', 'Laboratorio', GETDATE()),
('TERMINAL_DE_COLECTIVOS', 'Terminal de Colectivos', GETDATE()),
('CENTRO_EDUCACIONAL', 'Centro Educativo', GETDATE()),
('JARDIN_INFANTIL', 'Jardín Infantil', GETDATE()),
('PARQUE', 'Parque', GETDATE()),
('AEROPUERTO', 'Aeropuerto', GETDATE()),
('SERVICIO_MEDICO_LEGAL', 'Servicio Médico Legal', GETDATE()),
('CABANA', 'Cabaña', GETDATE()),
('PISO', 'Piso', GETDATE()),
('VILLA_POB', 'Villa Poblada', GETDATE())
END
GO

IF NOT EXISTS (SELECT 1 FROM ubicacion.cat_tipo_calle)
BEGIN
INSERT INTO ubicacion.cat_tipo_calle
(
descripcion,
fecha_creacion
)
VALUES
('CALLE', GETDATE()),
('AVENIDA', GETDATE()),
('CARRETERA', GETDATE()),
('PASAJE', GETDATE()),
('PASO BAJO NIVEL', GETDATE()),
('PASO SOBRE NIVEL', GETDATE()),
('HUELLA', GETDATE()),
('PASEO', GETDATE()),
('PUENTE', GETDATE()),
('ROTONDA', GETDATE()),
('CALLEJON', GETDATE()),
('CAMINO', GETDATE()),
('ESCALERA', GETDATE()),
('SENDERO', GETDATE()),
('ASFALTO', GETDATE()),
('PEATONAL', GETDATE()),
('ESCALA', GETDATE()),
('AUTOPISTA', GETDATE()),
('CALETERA', GETDATE()),
('PASAJE INTERIOR', GETDATE()),
('RUTA', GETDATE()),
('SECTOR', GETDATE()),
('CRUCE', GETDATE())
END
GO

-- temporal (pendiente carga definitiva)
IF NOT EXISTS (SELECT 1 FROM ubicacion.cat_tipo_subdivision)
BEGIN
INSERT INTO ubicacion.cat_tipo_subdivision
(
id_tipo_subdivision,
codigo,
nombre,
activo,
fecha_creacion
)
VALUES
(1,	 'GENERAL',     'GENERAL', 1, GETUTCDATE()),
(2,	 'HABITACION',  'HABITACION', 1, GETUTCDATE()),
(3,	 'DEPARTAMENTO','DEPARTAMENTO', 1, GETUTCDATE()),
(4,	 'OFICINA',     'OFICINA', 1, GETUTCDATE()),
(5,	 'LOCAL',       'LOCAL', 1, GETUTCDATE()),
(6,	 'BODEGA',      'BODEGA', 1, GETUTCDATE()),
(7,	 'CELDA',       'CELDA', 1, GETUTCDATE()),
(8,	 'SALA',        'SALA', 1, GETUTCDATE()),
(9,	 'SUITE',       'SUITE', 1, GETUTCDATE()),
(10, 'OTRO',        'OTRO', 1, GETUTCDATE())
END
GO

-- temporal (pendiente carga definitiva)
IF NOT EXISTS (SELECT * FROM ubicacion.cat_rol_lugar)
BEGIN
INSERT INTO ubicacion.cat_rol_lugar
(
id_rol_lugar,
codigo,
nombre
)
VALUES
(1,  'DOM','Domicilio particular'),
(2,   'LH','Lugar del hecho'),
(3,   'LT','Lugar de trabajo'),
(4, 'LDET','Lugar de detención'),
(5, 'LINC','Lugar de incautación')
END
GO

MERGE ubicacion.region AS target
USING (VALUES
(1, 152, N'Tarapacá', 2),
(2, 152, N'Antofagasta', 3),
(3, 152, N'Atacama', 4),
(4, 152, N'Coquimbo', 5),
(5, 152, N'Valparaíso', 6),
(6, 152, N'Libertador General Bernardo O''Higgins', 8),
(7, 152, N'Maule', 9),
(8, 152, N'Biobío', 11),
(9, 152, N'La Araucanía', 12),
(10, 152, N'Los Lagos', 14),
(11, 152, N'Aysén del General Carlos Ibáñez del Campo', 15),
(12, 152, N'Magallanes y de la Antártica Chilena', 16),
(13, 152, N'Metropolitana de Santiago', 7),
(14, 152, N'Los Ríos', 13),
(15, 152, N'Arica y Parinacota', 1),
(16, 152, N'Ñuble', 10)
) AS source (id_region, id_pais, descripcion, orden)
ON target.id_region = source.id_region
WHEN MATCHED AND (
    target.id_pais <> source.id_pais
    OR target.descripcion <> source.descripcion
    OR target.orden <> source.orden
) THEN
    UPDATE SET
        id_pais = source.id_pais,
        descripcion = source.descripcion,
        orden = source.orden
WHEN NOT MATCHED BY TARGET THEN
    INSERT (id_region, id_pais, descripcion, orden)
    VALUES (source.id_region, source.id_pais, source.descripcion, source.orden);
GO

MERGE ubicacion.provincia AS target
USING (VALUES
(11, 1, N'Iquique'),
(14, 1, N'Tamarugal'),
(21, 2, N'Antofagasta'),
(22, 2, N'El Loa'),
(23, 2, N'Tocopilla'),
(31, 3, N'Copiapó'),
(32, 3, N'Chañaral'),
(33, 3, N'Huasco'),
(41, 4, N'Elqui'),
(42, 4, N'Choapa'),
(43, 4, N'Limarí'),
(51, 5, N'Valparaíso'),
(52, 5, N'Isla de Pascua'),
(53, 5, N'Los Andes'),
(54, 5, N'Petorca'),
(55, 5, N'Quillota'),
(56, 5, N'San Antonio'),
(57, 5, N'San Felipe de Aconcagua'),
(58, 5, N'Marga Marga'),
(61, 6, N'Cachapoal'),
(62, 6, N'Cardenal Caro'),
(63, 6, N'Colchagua'),
(71, 7, N'Talca'),
(72, 7, N'Cauquenes'),
(73, 7, N'Curicó'),
(74, 7, N'Linares'),
(81, 8, N'Concepción'),
(82, 8, N'Arauco'),
(83, 8, N'Biobío'),
(91, 9, N'Cautín'),
(92, 9, N'Malleco'),
(101, 10, N'Llanquihue'),
(102, 10, N'Chiloé'),
(103, 10, N'Osorno'),
(104, 10, N'Palena'),
(111, 11, N'Coihaique'),
(112, 11, N'Aisén'),
(113, 11, N'Capitán Prat'),
(114, 11, N'General Carrera'),
(121, 12, N'Magallanes'),
(122, 12, N'Antártica Chilena'),
(123, 12, N'Tierra del Fuego'),
(124, 12, N'Última Esperanza'),
(131, 13, N'Santiago'),
(132, 13, N'Cordillera'),
(133, 13, N'Chacabuco'),
(134, 13, N'Maipo'),
(135, 13, N'Melipilla'),
(136, 13, N'Talagante'),
(141, 14, N'Valdivia'),
(142, 14, N'Ranco'),
(151, 15, N'Arica'),
(152, 15, N'Parinacota'),
(161, 16, N'Diguillín'),
(162, 16, N'Itata'),
(163, 16, N'Punilla')
) AS source (id_provincia, id_region, descripcion)
ON target.id_provincia = source.id_provincia
WHEN MATCHED AND (
    target.id_region <> source.id_region
    OR target.descripcion <> source.descripcion
) THEN
    UPDATE SET
        id_region = source.id_region,
        descripcion = source.descripcion
WHEN NOT MATCHED BY TARGET THEN
    INSERT (id_provincia, id_region, descripcion)
    VALUES (source.id_provincia, source.id_region, source.descripcion);
GO

MERGE ubicacion.comuna AS target
USING (VALUES
(1101, 11, N'Iquique', 1),
(1107, 11, N'Alto Hospicio', 0),
(1401, 14, N'Pozo Almonte', 0),
(1402, 14, N'Camiña', 0),
(1403, 14, N'Colchane', 0),
(1404, 14, N'Huara', 1),
(1405, 14, N'Pica', 0),
(2101, 21, N'Antofagasta', 1),
(2102, 21, N'Mejillones', 1),
(2103, 21, N'Sierra Gorda', 0),
(2104, 21, N'Taltal', 1),
(2201, 22, N'Calama', 0),
(2202, 22, N'Ollagüe', 0),
(2203, 22, N'San Pedro de Atacama', 0),
(2301, 23, N'Tocopilla', 1),
(2302, 23, N'María Elena', 0),
(3101, 31, N'Copiapó', 1),
(3102, 31, N'Caldera', 1),
(3103, 31, N'Tierra Amarilla', 0),
(3201, 32, N'Chañaral', 1),
(3202, 32, N'Diego de Almagro', 0),
(3301, 33, N'Vallenar', 0),
(3302, 33, N'Alto del Carmen', 0),
(3303, 33, N'Freirina', 1),
(3304, 33, N'Huasco', 1),
(4101, 41, N'La Serena', 1),
(4102, 41, N'Coquimbo', 1),
(4103, 41, N'Andacollo', 0),
(4104, 41, N'La Higuera', 1),
(4105, 41, N'Paiguano', 0),
(4106, 41, N'Vicuña', 0),
(4201, 42, N'Illapel', 0),
(4202, 42, N'Canela', 1),
(4203, 42, N'Los Vilos', 1),
(4204, 42, N'Salamanca', 0),
(4301, 43, N'Ovalle', 1),
(4302, 43, N'Combarbalá', 0),
(4303, 43, N'Monte Patria', 0),
(4304, 43, N'Punitaqui', 0),
(4305, 43, N'Río Hurtado', 0),
(5101, 51, N'Valparaíso', 1),
(5102, 51, N'Casablanca', 1),
(5103, 51, N'Concón', 1),
(5104, 51, N'Juan Fernández', 0),
(5105, 51, N'Puchuncaví', 1),
(5107, 51, N'Quintero', 1),
(5109, 51, N'Viña del Mar', 1),
(5201, 52, N'Isla de Pascua', 0),
(5301, 53, N'Los Andes', 0),
(5302, 53, N'Calle Larga', 0),
(5303, 53, N'Rinconada', 0),
(5304, 53, N'San Esteban', 0),
(5401, 54, N'La Ligua', 1),
(5402, 54, N'Cabildo', 0),
(5403, 54, N'Papudo', 1),
(5404, 54, N'Petorca', 0),
(5405, 54, N'Zapallar', 1),
(5501, 55, N'Quillota', 0),
(5502, 55, N'Calera', 0),
(5503, 55, N'Hijuelas', 0),
(5504, 55, N'La Cruz', 0),
(5506, 55, N'Nogales', 0),
(5601, 56, N'San Antonio', 1),
(5602, 56, N'Algarrobo', 1),
(5603, 56, N'Cartagena', 1),
(5604, 56, N'El Quisco', 1),
(5605, 56, N'El Tabo', 1),
(5606, 56, N'Santo Domingo', 1),
(5701, 57, N'San Felipe', 0),
(5702, 57, N'Catemu', 0),
(5703, 57, N'Llaillay', 0),
(5704, 57, N'Panquehue', 0),
(5705, 57, N'Putaendo', 0),
(5706, 57, N'Santa María', 0),
(5801, 58, N'Quilpué', 0),
(5802, 58, N'Limache', 0),
(5803, 58, N'Olmué', 0),
(5804, 58, N'Villa Alemana', 0),
(6101, 61, N'Rancagua', 0),
(6102, 61, N'Codegua', 0),
(6103, 61, N'Coinco', 0),
(6104, 61, N'Coltauco', 0),
(6105, 61, N'Doñihue', 0),
(6106, 61, N'Graneros', 0),
(6107, 61, N'Las Cabras', 0),
(6108, 61, N'Machalí', 0),
(6109, 61, N'Malloa', 0),
(6110, 61, N'Mostazal', 0),
(6111, 61, N'Olivar', 0),
(6112, 61, N'Peumo', 0),
(6113, 61, N'Pichidegua', 0),
(6114, 61, N'Quinta de Tilcoco', 0),
(6115, 61, N'Rengo', 0),
(6116, 61, N'Requínoa', 0),
(6117, 61, N'San Vicente', 0),
(6201, 62, N'Pichilemu', 1),
(6202, 62, N'La Estrella', 0),
(6203, 62, N'Litueche', 1),
(6204, 62, N'Marchihue', 0),
(6205, 62, N'Navidad', 1),
(6206, 62, N'Paredones', 1),
(6301, 63, N'San Fernando', 0),
(6302, 63, N'Chépica', 0),
(6303, 63, N'Chimbarongo', 0),
(6304, 63, N'Lolol', 0),
(6305, 63, N'Nancagua', 0),
(6306, 63, N'Palmilla', 0),
(6307, 63, N'Peralillo', 0),
(6308, 63, N'Placilla', 0),
(6309, 63, N'Pumanque', 0),
(6310, 63, N'Santa Cruz', 0),
(7101, 71, N'Talca', 0),
(7102, 71, N'Constitución', 1),
(7103, 71, N'Curepto', 1),
(7104, 71, N'Empedrado', 0),
(7105, 71, N'Maule', 0),
(7106, 71, N'Pelarco', 0),
(7107, 71, N'Pencahue', 0),
(7108, 71, N'Río Claro', 0),
(7109, 71, N'San Clemente', 0),
(7110, 71, N'San Rafael', 0),
(7201, 72, N'Cauquenes', 0),
(7202, 72, N'Chanco', 1),
(7203, 72, N'Pelluhue', 1),
(7301, 73, N'Curicó', 0),
(7302, 73, N'Hualañé', 0),
(7303, 73, N'Licantén', 1),
(7304, 73, N'Molina', 0),
(7305, 73, N'Rauco', 0),
(7306, 73, N'Romeral', 0),
(7307, 73, N'Sagrada Familia', 0),
(7308, 73, N'Teno', 0),
(7309, 73, N'Vichuquén', 1),
(7401, 74, N'Linares', 0),
(7402, 74, N'Colbún', 0),
(7403, 74, N'Longaví', 0),
(7404, 74, N'Parral', 0),
(7405, 74, N'Retiro', 0),
(7406, 74, N'San Javier', 0),
(7407, 74, N'Villa Alegre', 0),
(7408, 74, N'Yerbas Buenas', 0),
(8101, 81, N'Concepción', 1),
(8102, 81, N'Coronel', 1),
(8103, 81, N'Chiguayante', 0),
(8104, 81, N'Florida', 0),
(8105, 81, N'Hualqui', 0),
(8106, 81, N'Lota', 1),
(8107, 81, N'Penco', 1),
(8108, 81, N'San Pedro de la Paz', 1),
(8109, 81, N'Santa Juana', 0),
(8110, 81, N'Talcahuano', 1),
(8111, 81, N'Tomé', 1),
(8112, 81, N'Hualpén', 1),
(8201, 82, N'Lebu', 1),
(8202, 82, N'Arauco', 1),
(8203, 82, N'Cañete', 1),
(8204, 82, N'Contulmo', 0),
(8205, 82, N'Curanilahue', 0),
(8206, 82, N'Los Alamos', 1),
(8207, 82, N'Tirúa', 1),
(8301, 83, N'Los Angeles', 0),
(8302, 83, N'Antuco', 0),
(8303, 83, N'Cabrero', 0),
(8304, 83, N'Laja', 0),
(8305, 83, N'Mulchén', 0),
(8306, 83, N'Nacimiento', 0),
(8307, 83, N'Negrete', 0),
(8308, 83, N'Quilaco', 0),
(8309, 83, N'Quilleco', 0),
(8310, 83, N'San Rosendo', 0),
(8311, 83, N'Santa Bárbara', 0),
(8312, 83, N'Tucapel', 0),
(8313, 83, N'Yumbel', 0),
(8314, 83, N'Alto Biobío', 0),
(9101, 91, N'Temuco', 0),
(9102, 91, N'Carahue', 1),
(9103, 91, N'Cunco', 0),
(9104, 91, N'Curarrehue', 0),
(9105, 91, N'Freire', 0),
(9106, 91, N'Galvarino', 0),
(9107, 91, N'Gorbea', 0),
(9108, 91, N'Lautaro', 0),
(9109, 91, N'Loncoche', 0),
(9110, 91, N'Melipeuco', 0),
(9111, 91, N'Nueva Imperial', 0),
(9112, 91, N'Padre Las Casas', 0),
(9113, 91, N'Perquenco', 0),
(9114, 91, N'Pitrufquén', 0),
(9115, 91, N'Pucón', 0),
(9116, 91, N'Saavedra', 1),
(9117, 91, N'Teodoro Schmidt', 1),
(9118, 91, N'Toltén', 1),
(9119, 91, N'Vilcún', 0),
(9120, 91, N'Villarrica', 0),
(9121, 91, N'Cholchol', 0),
(9201, 92, N'Angol', 0),
(9202, 92, N'Collipulli', 0),
(9203, 92, N'Curacautín', 0),
(9204, 92, N'Ercilla', 0),
(9205, 92, N'Lonquimay', 0),
(9206, 92, N'Los Sauces', 0),
(9207, 92, N'Lumaco', 0),
(9208, 92, N'Purén', 0),
(9209, 92, N'Renaico', 0),
(9210, 92, N'Traiguén', 0),
(9211, 92, N'Victoria', 0),
(10101, 101, N'Puerto Montt', 1),
(10102, 101, N'Calbuco', 1),
(10103, 101, N'Cochamó', 1),
(10104, 101, N'Fresia', 1),
(10105, 101, N'Frutillar', 0),
(10106, 101, N'Los Muermos', 1),
(10107, 101, N'Llanquihue', 0),
(10108, 101, N'Maullín', 1),
(10109, 101, N'Puerto Varas', 0),
(10201, 102, N'Castro', 1),
(10202, 102, N'Ancud', 1),
(10203, 102, N'Chonchi', 1),
(10204, 102, N'Curaco de Vélez', 1),
(10205, 102, N'Dalcahue', 1),
(10206, 102, N'Puqueldón', 1),
(10207, 102, N'Queilén', 1),
(10208, 102, N'Quellón', 1),
(10209, 102, N'Quemchi', 1),
(10210, 102, N'Quinchao', 1),
(10301, 103, N'Osorno', 0),
(10302, 103, N'Puerto Octay', 0),
(10303, 103, N'Purranque', 1),
(10304, 103, N'Puyehue', 0),
(10305, 103, N'Río Negro', 1),
(10306, 103, N'San Juan de la Costa', 1),
(10307, 103, N'San Pablo', 0),
(10401, 104, N'Chaitén', 1),
(10402, 104, N'Futaleufú', 0),
(10403, 104, N'Hualaihué', 1),
(10404, 104, N'Palena', 0),
(11101, 111, N'Coihaique', 0),
(11102, 111, N'Lago Verde', 0),
(11201, 112, N'Aisén', 1),
(11202, 112, N'Cisnes', 1),
(11203, 112, N'Guaitecas', 1),
(11301, 113, N'Cochrane', 0),
(11302, 113, N'O''Higgins', 0),
(11303, 113, N'Tortel', 1),
(11401, 114, N'Chile Chico', 0),
(11402, 114, N'Río Ibáñez', 0),
(12101, 121, N'Punta Arenas', 1),
(12102, 121, N'Laguna Blanca', 1),
(12103, 121, N'Río Verde', 1),
(12104, 121, N'San Gregorio', 1),
(12201, 122, N'Cabo de Hornos', 1),
(12301, 123, N'Porvenir', 1),
(12302, 123, N'Primavera', 1),
(12303, 123, N'Timaukel', 1),
(12401, 124, N'Natales', 1),
(12402, 124, N'Torres del Paine', 1),
(13101, 131, N'Santiago', 0),
(13102, 131, N'Cerrillos', 0),
(13103, 131, N'Cerro Navia', 0),
(13104, 131, N'Conchalí', 0),
(13105, 131, N'El Bosque', 0),
(13106, 131, N'Estación Central', 0),
(13107, 131, N'Huechuraba', 0),
(13108, 131, N'Independencia', 0),
(13109, 131, N'La Cisterna', 0),
(13110, 131, N'La Florida', 0),
(13111, 131, N'La Granja', 0),
(13112, 131, N'La Pintana', 0),
(13113, 131, N'La Reina', 0),
(13114, 131, N'Las Condes', 0),
(13115, 131, N'Lo Barnechea', 0),
(13116, 131, N'Lo Espejo', 0),
(13117, 131, N'Lo Prado', 0),
(13118, 131, N'Macul', 0),
(13119, 131, N'Maipú', 0),
(13120, 131, N'Ñuñoa', 0),
(13121, 131, N'Pedro Aguirre Cerda', 0),
(13122, 131, N'Peñalolén', 0),
(13123, 131, N'Providencia', 0),
(13124, 131, N'Pudahuel', 0),
(13125, 131, N'Quilicura', 0),
(13126, 131, N'Quinta Normal', 0),
(13127, 131, N'Recoleta', 0),
(13128, 131, N'Renca', 0),
(13129, 131, N'San Joaquín', 0),
(13130, 131, N'San Miguel', 0),
(13131, 131, N'San Ramón', 0),
(13132, 131, N'Vitacura', 0),
(13201, 132, N'Puente Alto', 0),
(13202, 132, N'Pirque', 0),
(13203, 132, N'San José de Maipo', 0),
(13301, 133, N'Colina', 0),
(13302, 133, N'Lampa', 0),
(13303, 133, N'Tiltil', 0),
(13401, 134, N'San Bernardo', 0),
(13402, 134, N'Buin', 0),
(13403, 134, N'Calera de Tango', 0),
(13404, 134, N'Paine', 0),
(13501, 135, N'Melipilla', 0),
(13502, 135, N'Alhué', 0),
(13503, 135, N'Curacaví', 0),
(13504, 135, N'María Pinto', 0),
(13505, 135, N'San Pedro', 0),
(13601, 136, N'Talagante', 0),
(13602, 136, N'El Monte', 0),
(13603, 136, N'Isla de Maipo', 0),
(13604, 136, N'Padre Hurtado', 0),
(13605, 136, N'Peñaflor', 0),
(14101, 141, N'Valdivia', 1),
(14102, 141, N'Corral', 1),
(14103, 141, N'Lanco', 0),
(14104, 141, N'Los Lagos', 0),
(14105, 141, N'Máfil', 0),
(14106, 141, N'Mariquina', 1),
(14107, 141, N'Paillaco', 0),
(14108, 141, N'Panguipulli', 0),
(14201, 142, N'La Unión', 1),
(14202, 142, N'Futrono', 0),
(14203, 142, N'Lago Ranco', 0),
(14204, 142, N'Río Bueno', 0),
(15101, 151, N'Arica', 1),
(15102, 151, N'Camarones', 1),
(15201, 152, N'Putre', 0),
(15202, 152, N'General Lagos', 0),
(16101, 161, N'Chillán', 0),
(16102, 161, N'Bulnes', 0),
(16103, 161, N'Chillán Viejo', 0),
(16104, 161, N'El Carmen', 0),
(16105, 161, N'Pemuco', 0),
(16106, 161, N'Pinto', 0),
(16107, 161, N'Quillón', 0),
(16108, 161, N'San Ignacio', 0),
(16109, 161, N'Yungay', 0),
(16201, 162, N'Quirihue', 0),
(16202, 162, N'Cobquecura', 1),
(16203, 162, N'Coelemu', 1),
(16204, 162, N'Ninhue', 0),
(16205, 162, N'Portezuelo', 0),
(16206, 162, N'Ranquil', 0),
(16207, 162, N'Treguaco', 1),
(16301, 163, N'San Carlos', 0),
(16302, 163, N'Coihueco', 0),
(16303, 163, N'Ñiquén', 0),
(16304, 163, N'San Fabián', 0),
(16305, 163, N'San Nicolás', 0)
) AS source (id_comuna, id_provincia, descripcion, costera)
ON target.id_comuna = source.id_comuna
WHEN MATCHED AND (
    target.id_provincia <> source.id_provincia
    OR target.descripcion <> source.descripcion
    OR ISNULL(target.costera, -1) <> ISNULL(source.costera, -1)
) THEN
    UPDATE SET
        id_provincia = source.id_provincia,
        descripcion = source.descripcion,
        costera = source.costera
WHEN NOT MATCHED BY TARGET THEN
    INSERT (id_comuna, id_provincia, descripcion, costera)
    VALUES (source.id_comuna, source.id_provincia, source.descripcion, source.costera);
GO

IF NOT EXISTS (SELECT 1 FROM ubicacion.cat_tipo_poblacion)
BEGIN
INSERT INTO ubicacion.cat_tipo_poblacion
(
descripcion
)
VALUES
('población'),
('villa')
END
GO