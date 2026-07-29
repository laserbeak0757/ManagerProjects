# Flowchart Integral: Operacion + Desarrollo + Revision

```mermaid
flowchart TD
    A[Inicio] --> B[Levantar entorno\ndocker compose up -d]
    B --> C[Actualizar base\nflyway migrate en sip]
    C --> D{Hay cambio nuevo?}
    D -- No --> Z[Operacion estable]
    D -- Si --> E[Crear/usar sip_dev]
    E --> F[Aplicar cambios DDL/SP/Seeds]
    F --> G[Comparar sip_dev vs sip\ncompare.sql]
    G --> H[Empaquetar migracion\nVxxxx o R__]
    H --> I[Probar migrate en sip]
    I --> J{Pruebas OK?}
    J -- No --> F
    J -- Si --> K[Commit y Push]
    K --> L[Crear PR]
    L --> M[Clasificar archivos\nDDL/SP/Seed]
    M --> N[Aplicar checklist DDL]
    M --> O[Aplicar checklist SP]
    N --> P{Bloqueantes?}
    O --> P
    P -- Si --> Q[Solicitar correcciones\ncon archivo y linea]
    Q --> F
    P -- No --> R[Aprobar PR]
    R --> S[Merge a develop]
    S --> T[Sincronizar local\ny re-ejecutar migrate]
    T --> Z
```

## Uso recomendado

1. Usar las vistas separadas para analisis puntual por rol.
2. Usar este flowchart para onboarding, gobernanza y coordinacion de equipo.
