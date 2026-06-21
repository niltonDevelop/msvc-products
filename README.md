# msvc-products

Microservicio de **gestión de productos**. Expone una API REST CRUD y persiste datos en MySQL usando la entidad compartida `Product` de `libs-msvc-commons`.

## Stack

- Java 21 · Spring Boot 4.0.6 · Spring Cloud 2025.1.1
- Puerto: **dinámico** (`${PORT:0}`) — consultar instancia en Eureka
- Base de datos: MySQL `db_springboot_cloud`

## Endpoints

Base del servicio: `/product`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/product` | Lista todos los productos |
| GET | `/product/{id}` | Obtiene un producto por ID |
| POST | `/product` | Crea un producto |
| PUT | `/product/{id}` | Actualiza un producto |
| DELETE | `/product/{id}` | Elimina un producto |

### Vía API Gateway (puerto 8080)

Prefijo: `/api/product/**` (StripPrefix=2)

| Método | Ruta Gateway |
|--------|--------------|
| GET | `/api/product/product` |
| GET | `/api/product/product/{id}` |
| POST | `/api/product/product` |
| PUT | `/api/product/product/{id}` |
| DELETE | `/api/product/product/{id}` |

## Importancia en el ecosistema

Microservicio de **dominio de catálogo**. Es la fuente de datos de productos para **msvc-items**, que lo consume vía Feign/WebClient con circuit breaker.

**Dependencias:** Eureka, MySQL, **libs-msvc-commons**.

**Consumido por:** **msvc-items**, **msvc-gateway-server** (proxy).

**Orden de arranque recomendado:** 3.º, después de Eureka, MySQL y `libs-msvc-commons` instalada.
