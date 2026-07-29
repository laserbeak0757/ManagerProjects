SET NOCOUNT ON;
GO

-- =============================================================================
-- R__configuracion_seeds.sql
-- Seed idempotente del catálogo de errores (esquema configuracion).
-- Estrategia: MERGE por PK de negocio (id_categoria / id_cat_error_catalogo).
-- Repetible: reaplica en cada cambio de checksum sin duplicar ni perder datos.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- configuracion.cat_error_categoria  (8 categorías; id 500-507)
-- PK explícita (no IDENTITY) -> MERGE directo sin IDENTITY_INSERT.
-- -----------------------------------------------------------------------------
MERGE configuracion.cat_error_categoria AS target
USING (VALUES
    (500, N'validacion', N'Errores de validación de parámetros, formato, rango, estructura y consistencia', 0, 1),
    (501, N'inexistencia', N'Errores por inexistencia, ausencia, no vigencia o no disponibilidad de referencias', 0, 1),
    (502, N'conflicto', N'Errores de duplicidad, unicidad, reserva, uso y conflictos que impiden la operación', 1, 1),
    (503, N'estado', N'Errores de valor de estado, estado actual y transiciones permitidas', 1, 1),
    (504, N'regla_negocio', N'Errores de reglas funcionales o restricciones del proceso', 1, 1),
    (505, N'autorizacion', N'Errores de autenticación, autorización y acceso funcional', 1, 1),
    (506, N'precondicion', N'Errores por requisitos previos internos no cumplidos', 1, 1),
    (507, N'integracion', N'Errores por dependencias, contratos y respuestas de sistemas externos', 1, 1)
) AS src (id_categoria, nombre_categoria, descripcion, registrar_log, vigente)
ON target.id_categoria = src.id_categoria
WHEN MATCHED THEN UPDATE SET
    target.nombre_categoria = src.nombre_categoria,
    target.descripcion      = src.descripcion,
    target.registrar_log    = src.registrar_log,
    target.vigente          = src.vigente
WHEN NOT MATCHED THEN INSERT (id_categoria, nombre_categoria, descripcion, registrar_log, vigente)
    VALUES (src.id_categoria, src.nombre_categoria, src.descripcion, src.registrar_log, src.vigente);
GO

-- -----------------------------------------------------------------------------
-- configuracion.cat_error_catalogo  (118 códigos transversales; 50001-50799)
-- esquema_owner NULL = transversal. PK explícita -> MERGE sin IDENTITY_INSERT.
-- Los códigos de DOMINIO (>= 51000) se siembran en el R__ del esquema dueño.
-- -----------------------------------------------------------------------------
MERGE configuracion.cat_error_catalogo AS target
USING (VALUES
    (50001, NULL, 500, N'parametro_obligatorio', N'El parámetro es obligatorio.', 0, 1),
    (50002, NULL, 500, N'valor_fuera_dominio', N'El valor no es válido para el dominio permitido.', 0, 1),
    (50003, NULL, 500, N'parametro_vacio', N'El parámetro no puede venir vacío.', 0, 1),
    (50004, NULL, 500, N'formato_invalido', N'El formato del parámetro es inválido.', 0, 1),
    (50005, NULL, 500, N'combinacion_parametros_invalida', N'La combinación de parámetros no es válida.', 0, 1),
    (50006, NULL, 500, N'valor_fuera_de_rango', N'El valor del parámetro está fuera del rango permitido.', 0, 1),
    (50007, NULL, 500, N'longitud_invalida', N'La longitud del valor informado no es válida.', 0, 1),
    (50008, NULL, 500, N'precision_invalida', N'La precisión o escala del valor informado no es válida.', 0, 1),
    (50009, NULL, 500, N'fecha_invalida', N'La fecha informada no es válida.', 0, 1),
    (50010, NULL, 500, N'fecha_fuera_de_rango', N'La fecha informada está fuera del rango permitido.', 0, 1),
    (50011, NULL, 500, N'valor_no_positivo', N'El valor informado debe ser mayor que cero.', 0, 1),
    (50012, NULL, 500, N'valor_negativo_no_permitido', N'El valor informado no puede ser negativo.', 0, 1),
    (50013, NULL, 500, N'identificador_invalido', N'El identificador informado no es válido.', 0, 1),
    (50014, NULL, 500, N'lista_vacia', N'La lista informada no puede venir vacía.', 0, 1),
    (50015, NULL, 500, N'elemento_duplicado_en_lista', N'La lista informada contiene elementos duplicados.', 0, 1),
    (50016, NULL, 500, N'valor_no_unico_en_estructura', N'El valor informado debe ser único dentro de la estructura informada.', 0, 1),
    (50017, NULL, 500, N'estructura_json_invalida', N'La estructura JSON informada no es válida.', 0, 1),
    (50018, NULL, 500, N'estructura_xml_invalida', N'La estructura XML informada no es válida.', 0, 1),
    (50019, NULL, 500, N'codificacion_invalida', N'La codificación del contenido informado no es válida.', 0, 1),
    (50020, NULL, 500, N'contenido_no_permitido', N'El contenido informado no está permitido.', 0, 1),
    (50021, NULL, 500, N'campo_incompatible_con_otro', N'El valor informado es incompatible con otro campo relacionado.', 0, 1),
    (50022, NULL, 500, N'cardinalidad_invalida', N'La cardinalidad de los datos informados no es válida.', 0, 1),
    (50023, NULL, 500, N'orden_elementos_invalido', N'El orden de los elementos informados no es válido.', 0, 1),
    (50024, NULL, 500, N'valor_booleano_invalido', N'El valor informado no corresponde a un booleano válido.', 0, 1),
    (50025, NULL, 500, N'valor_nulo_no_permitido', N'El valor nulo no está permitido para este campo.', 0, 1),
    (50026, NULL, 500, N'expresion_busqueda_invalida', N'La expresión de búsqueda informada no es válida.', 0, 1),
    (50027, NULL, 500, N'patron_invalido', N'El patrón informado no cumple la estructura esperada.', 0, 1),
    (50028, NULL, 500, N'tamano_maximo_excedido', N'El tamaño máximo permitido fue excedido.', 0, 1),
    (50029, NULL, 500, N'tamano_minimo_no_cumplido', N'El tamaño mínimo requerido no se cumple.', 0, 1),
    (50030, NULL, 500, N'tipo_dato_incompatible', N'El tipo de dato informado no es compatible con la operación.', 0, 1),
    (50031, NULL, 500, N'rango_invalido', N'El rango informado no es válido.', 0, 1),
    (50032, NULL, 500, N'parametro_condicional_obligatorio', N'El parámetro es obligatorio según la condición informada.', 0, 1),
    (50100, NULL, 501, N'referencia_no_existe', N'La referencia solicitada no existe.', 0, 1),
    (50101, NULL, 501, N'registro_no_encontrado', N'No se encontró el registro solicitado.', 0, 1),
    (50102, NULL, 501, N'recurso_no_disponible', N'El recurso solicitado no está disponible.', 0, 1),
    (50103, NULL, 501, N'referencia_no_vigente', N'La referencia solicitada no se encuentra vigente.', 0, 1),
    (50104, NULL, 501, N'referencia_inactiva', N'La referencia solicitada se encuentra inactiva.', 0, 1),
    (50105, NULL, 501, N'referencia_eliminada_logicamente', N'La referencia solicitada fue eliminada lógicamente.', 0, 1),
    (50106, NULL, 501, N'relacion_no_existe', N'La relación solicitada no existe.', 0, 1),
    (50107, NULL, 501, N'archivo_no_existe', N'El archivo solicitado no existe.', 0, 1),
    (50108, NULL, 501, N'version_no_existe', N'La versión solicitada no existe.', 0, 1),
    (50109, NULL, 501, N'historial_no_existe', N'No existe historial para la referencia solicitada.', 0, 1),
    (50110, NULL, 501, N'resultado_no_disponible', N'El resultado solicitado no se encuentra disponible.', 0, 1),
    (50111, NULL, 501, N'dato_asociado_no_existe', N'No existe información asociada para la referencia solicitada.', 0, 1),
    (50112, NULL, 501, N'pagina_no_encontrada', N'La página o segmento solicitado no fue encontrado.', 0, 1),
    (50113, NULL, 501, N'cursor_sin_resultados', N'La consulta no devolvió resultados para la operación solicitada.', 0, 1),
    (50114, NULL, 501, N'documento_no_encontrado', N'No se encontró el documento solicitado.', 0, 1),
    (50115, NULL, 501, N'dependencia_requerida_no_existe', N'No existe una referencia requerida para completar la operación.', 0, 1),
    (50200, NULL, 502, N'entidad_ya_existe', N'Ya existe una entidad con esos identificadores.', 1, 1),
    (50201, NULL, 502, N'conflicto_concurrencia', N'El registro fue modificado por otro proceso; reintente con datos actualizados.', 1, 1),
    (50202, NULL, 502, N'registro_duplicado', N'Ya existe un registro con los datos informados.', 1, 1),
    (50203, NULL, 502, N'relacion_ya_existe', N'La relación informada ya existe.', 1, 1),
    (50204, NULL, 502, N'operacion_duplicada', N'La operación ya fue registrada previamente.', 1, 1),
    (50205, NULL, 502, N'token_ya_utilizado', N'El token informado ya fue utilizado.', 1, 1),
    (50206, NULL, 502, N'recurso_reservado', N'El recurso solicitado se encuentra reservado.', 1, 1),
    (50207, NULL, 502, N'idempotencia_repetida', N'La solicitud ya fue procesada anteriormente.', 1, 1),
    (50208, NULL, 502, N'restriccion_unicidad_violada', N'La operación viola una restricción de unicidad.', 1, 1),
    (50209, NULL, 502, N'clave_natural_duplicada', N'Ya existe un registro con la clave natural informada.', 1, 1),
    (50210, NULL, 502, N'dependencia_existente_impide_operacion', N'Existen dependencias activas que impiden completar la operación.', 1, 1),
    (50211, NULL, 502, N'recurso_en_uso', N'El recurso está siendo utilizado por otra operación en curso.', 1, 1),
    (50300, NULL, 503, N'estado_invalido', N'El valor de estado no es válido.', 1, 1),
    (50301, NULL, 503, N'estado_no_permite_operacion', N'El estado actual no permite la operación.', 1, 1),
    (50302, NULL, 503, N'transicion_no_permitida', N'La transición de estado no está permitida.', 1, 1),
    (50303, NULL, 503, N'estado_requerido_no_cumplido', N'El registro no se encuentra en el estado requerido para la operación.', 1, 1),
    (50304, NULL, 503, N'estado_previo_inconsistente', N'El estado previo del registro es inconsistente.', 1, 1),
    (50305, NULL, 503, N'estado_bloqueado', N'El registro se encuentra bloqueado para esta operación.', 1, 1),
    (50306, NULL, 503, N'cambio_estado_no_implementado', N'El cambio de estado solicitado no está implementado.', 1, 1),
    (50307, NULL, 503, N'estado_expirado', N'El estado informado ya expiró.', 1, 1),
    (50308, NULL, 503, N'estado_suspendido', N'El registro se encuentra suspendido para la operación solicitada.', 1, 1),
    (50309, NULL, 503, N'estado_incompleto', N'El registro se encuentra en un estado incompleto.', 1, 1),
    (50400, NULL, 504, N'regla_negocio_incumplida', N'La operación no cumple una regla de negocio.', 1, 1),
    (50401, NULL, 504, N'operacion_no_permitida', N'La operación no está permitida en el contexto actual.', 1, 1),
    (50402, NULL, 504, N'limite_excedido', N'La operación excede un límite permitido.', 1, 1),
    (50403, NULL, 504, N'dependencia_funcional_incompleta', N'La operación requiere información funcional previa no disponible.', 1, 1),
    (50404, NULL, 504, N'ventana_tiempo_no_valida', N'La operación no está permitida en la ventana de tiempo actual.', 1, 1),
    (50405, NULL, 504, N'correlacion_inconsistente', N'La correlación entre los datos informados es inconsistente.', 1, 1),
    (50406, NULL, 504, N'datos_insuficientes', N'No existe información suficiente para completar la operación.', 1, 1),
    (50407, NULL, 504, N'operacion_requiere_confirmacion', N'La operación requiere una confirmación previa.', 1, 1),
    (50408, NULL, 504, N'restriccion_juridica', N'La operación no puede ejecutarse por una restricción jurídica o normativa.', 1, 1),
    (50409, NULL, 504, N'operacion_fuera_de_secuencia', N'La operación se realizó fuera de la secuencia permitida.', 1, 1),
    (50410, NULL, 504, N'cantidad_maxima_superada', N'La cantidad máxima permitida fue superada.', 1, 1),
    (50411, NULL, 504, N'cantidad_minima_no_cumplida', N'La cantidad mínima requerida no se cumple.', 1, 1),
    (50500, NULL, 505, N'no_autorizado', N'No tiene autorización funcional para la operación.', 1, 1),
    (50501, NULL, 505, N'autenticacion_requerida', N'La operación requiere autenticación previa.', 1, 1),
    (50502, NULL, 505, N'credencial_invalida', N'La credencial informada no es válida.', 1, 1),
    (50503, NULL, 505, N'sesion_expirada', N'La sesión actual expiró.', 1, 1),
    (50504, NULL, 505, N'token_invalido', N'El token informado no es válido.', 1, 1),
    (50505, NULL, 505, N'token_expirado', N'El token informado expiró.', 1, 1),
    (50506, NULL, 505, N'ambito_insuficiente', N'El alcance autorizado es insuficiente para la operación.', 1, 1),
    (50507, NULL, 505, N'firma_invalida', N'La firma de seguridad informada no es válida.', 1, 1),
    (50508, NULL, 505, N'acceso_restringido', N'El acceso al recurso se encuentra restringido.', 1, 1),
    (50509, NULL, 505, N'politica_seguridad_rechazo_operacion', N'La política de seguridad rechazó la operación solicitada.', 1, 1),
    (50510, NULL, 505, N'contexto_identidad_inconsistente', N'El contexto de identidad no es consistente con la operación.', 1, 1),
    (50600, NULL, 506, N'precondicion_configuracion', N'Falta configuración o catálogo base requerido.', 1, 1),
    (50601, NULL, 506, N'recurso_no_inicializado', N'El recurso requerido no ha sido inicializado.', 1, 1),
    (50602, NULL, 506, N'parametro_configuracion_inexistente', N'No existe el parámetro de configuración requerido.', 1, 1),
    (50603, NULL, 506, N'contexto_no_preparado', N'El contexto necesario para la operación no está preparado.', 1, 1),
    (50604, NULL, 506, N'secuencia_no_disponible', N'La secuencia o numerador requerido no está disponible.', 1, 1),
    (50605, NULL, 506, N'dependencia_interna_no_disponible', N'Una dependencia interna requerida no está disponible.', 1, 1),
    (50606, NULL, 506, N'version_incompatible', N'La versión del recurso o contrato no es compatible.', 1, 1),
    (50607, NULL, 506, N'inicializacion_incompleta', N'La inicialización requerida para la operación está incompleta.', 1, 1),
    (50608, NULL, 506, N'catalogo_no_vigente', N'El catálogo requerido no se encuentra vigente.', 1, 1),
    (50609, NULL, 506, N'modo_mantenimiento_activo', N'La operación no está disponible por mantenimiento del sistema.', 1, 1),
    (50610, NULL, 506, N'dependencia_previa_no_cumplida', N'No se cumple una dependencia previa requerida para la operación.', 1, 1),
    (50611, NULL, 506, N'funcionalidad_deshabilitada', N'La funcionalidad requerida se encuentra deshabilitada.', 1, 1),
    (50700, NULL, 507, N'dependencia_externa_no_disponible', N'Una dependencia externa de integración no está disponible.', 1, 1),
    (50701, NULL, 507, N'timeout_dependencia_externa', N'La dependencia externa excedió el tiempo máximo de respuesta.', 1, 1),
    (50702, NULL, 507, N'respuesta_externa_invalida', N'La respuesta de la dependencia externa no es válida.', 1, 1),
    (50703, NULL, 507, N'servicio_externo_rechazo_solicitud', N'El servicio externo rechazó la solicitud.', 1, 1),
    (50704, NULL, 507, N'canal_integracion_no_disponible', N'El canal de integración no está disponible.', 1, 1),
    (50705, NULL, 507, N'respuesta_externa_inconsistente', N'La respuesta de la dependencia externa es inconsistente.', 1, 1),
    (50706, NULL, 507, N'autenticacion_externa_fallida', N'La autenticación contra la dependencia externa falló.', 1, 1),
    (50707, NULL, 507, N'autorizacion_externa_fallida', N'La autorización en la dependencia externa fue rechazada.', 1, 1),
    (50708, NULL, 507, N'contrato_integracion_incompatible', N'El contrato de integración no es compatible con la operación.', 1, 1),
    (50709, NULL, 507, N'transformacion_mensaje_fallida', N'No fue posible transformar el mensaje de integración.', 1, 1),
    (50710, NULL, 507, N'serializacion_mensaje_externo_fallida', N'No fue posible serializar el mensaje para la dependencia externa.', 1, 1),
    (50711, NULL, 507, N'deserializacion_mensaje_externo_fallida', N'No fue posible interpretar la respuesta del sistema externo.', 1, 1),
    (50712, NULL, 507, N'dependencia_externa_inestable', N'La dependencia externa presenta comportamiento inestable.', 1, 1)
) AS src (id_cat_error_catalogo, esquema_owner, id_categoria, nombre_corto, mensaje_base, registrar_log_si_categoria_habilitada, vigente)
ON target.id_cat_error_catalogo = src.id_cat_error_catalogo
WHEN MATCHED THEN UPDATE SET
    target.esquema_owner                         = src.esquema_owner,
    target.id_categoria                          = src.id_categoria,
    target.nombre_corto                          = src.nombre_corto,
    target.mensaje_base                          = src.mensaje_base,
    target.registrar_log_si_categoria_habilitada = src.registrar_log_si_categoria_habilitada,
    target.vigente                               = src.vigente
WHEN NOT MATCHED THEN INSERT (id_cat_error_catalogo, esquema_owner, id_categoria, nombre_corto, mensaje_base, registrar_log_si_categoria_habilitada, vigente)
    VALUES (src.id_cat_error_catalogo, src.esquema_owner, src.id_categoria, src.nombre_corto, src.mensaje_base, src.registrar_log_si_categoria_habilitada, src.vigente);
GO
