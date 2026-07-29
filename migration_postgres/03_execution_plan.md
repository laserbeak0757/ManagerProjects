# Execution Plan

Fase 1 - Structure + Seeds
1. Exportar source (versioned + seeds) a staging local.
2. Convertir sintaxis SQL Server a PostgreSQL en output/postgres.
3. Validar patrones incompatibles pendientes.
4. Ejecutar en base PostgreSQL de prueba.
5. Ajustar manualmente bloqueos detectados.

Fase 2 - Hardening
1. Corregir constraints y defaults avanzados.
2. Validar integridad referencial completa.
3. Validar performance basica (indices criticos).

Fase 3 - Programmability (fuera de alcance inicial)
1. Priorizar SPs por uso real.
2. Reescribir en PL/pgSQL por dominio.
3. Agregar tests SQL para funciones/procedures.

Criterios de salida fase 1
- Esquemas creados.
- Tablas creadas.
- PK/FK/indexes principales creados.
- Seeds base cargados.
- Sin dependencias de SP para boot inicial.
