---
description: "Implement a BFF endpoint backed by downstream microservices, including OpenAPI/tests/docs and Postman validation artifacts."
---

# Prompt: Implementar endpoint BFF downstream

Objetivo:

Implementar o modificar un endpoint del BFF que consume uno o mas microservicios downstream.

Input minimo esperado:

- Repo BFF objetivo (ejemplo: `Proyectos/nexo-bff-diligencias`).
- Ruta/metodo publico del BFF.
- Ruta/metodo downstream.
- Reglas de autenticacion y errores esperados.

Instrucciones de ejecucion:

1. Leer arquitectura BFF y guia de endpoint downstream.
2. Definir caso de uso orientado a frontend (Application).
3. Implementar cliente downstream en Infrastructure y registrar HttpClient.
4. Exponer endpoint en Api con controller delgado.
5. Agregar pruebas.
6. Actualizar o validar OpenAPI si cambia el contrato.
7. Generar coleccion Postman + environment local para validar el endpoint.
8. Actualizar documentacion del repo y no cerrar sin ese paso.

Entregables obligatorios:

- Endpoint BFF implementado.
- Pruebas.
- OpenAPI y docs aplicables.
- Documentacion actualizada.
- Postman collection + environment.
