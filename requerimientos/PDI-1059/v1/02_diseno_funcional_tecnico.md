# PDI-1059 - Diseno funcional y tecnico

## Objetivo tecnico

Implementar una lectura consistente de instrucciones de diligencia desde BD para consumo en capa de negocio.

## Flujo propuesto

1. Consumidor solicita instrucciones por diligenciaId.
2. Capa de aplicacion valida parametros.
3. Repositorio ejecuta query de lectura en BD.
4. Se mapean resultados a DTO de salida.
5. Se retorna respuesta estandar (encontrado/no encontrado/error).

## Contrato sugerido (provisional)

### Request

- diligenciaId (requerido)

### Response

- diligenciaId
- instrucciones (texto o estructura)
- fechaActualizacion (opcional)
- usuarioActualizacion (opcional)

## Reglas tecnicas sugeridas

1. Si no existe diligencia/instruccion: retornar 404 o resultado vacio segun estandar del repo.
2. Evitar multiples filas ambiguas; definir criterio de vigencia.
3. Proteger query contra acceso no autorizado a diligencias fuera de contexto.

## Consideraciones de datos

1. Confirmar origen exacto: tabla principal o vista consolidada.
2. Confirmar si "instrucciones" es columna unica o composicion.
3. Revisar necesidad de indice por diligenciaId.

## Criterios de listo tecnico

1. Contrato de salida validado por consumidor.
2. Query validada con casos: encontrado, no encontrado, datos incompletos.
3. Documentacion de mapeo campo BD -> DTO disponible.
