# msvc-products

Microservicio **Spring Boot** para gestión de productos dentro de un ecosistema Spring Cloud. Expone una API REST con prefijo versionado (`/api/{versión}`), persiste datos en **MySQL** con **JPA/Hibernate** y expone **Actuator** para observabilidad básica.

## Requisitos

- **Java 21** (configurado en el `pom.xml`)
- **MySQL** con la base y credenciales indicadas en `application.properties` (o variables de entorno equivalentes en tu despliegue)
- **Maven** (o usar el wrapper: `./mvnw`)

## Cómo ejecutar

```bash
./mvnw spring-boot:run
```

Por defecto el servicio escucha en el puerto **8001** (`server.port`).

## API HTTP (hasta ahora)

El prefijo global se configura en `ApiWebConfiguration` y en `app.api.version` (por defecto `v1`).

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/api/v1/product` | Lista todos los productos |
| `GET` | `/api/v1/product/{id}` | Detalle por id; `404` si no existe |

En la respuesta JSON, el campo `port` en `Product` es **transient** (no se guarda en BD): se rellena en el servicio con el puerto local del servidor Spring (`local.server.port`) para depuración o demostración en entornos con varias instancias.

## Configuración relevante

- **Aplicación:** `spring.application.name=products`, `server.port=8001`
- **Versión de API:** `app.api.version` (p. ej. `v1`)
- **Base de datos:** URL, usuario, contraseña y `spring.jpa.hibernate.ddl-auto` en `src/main/resources/application.properties`  
  En producción suele usarse `validate` + migraciones (Flyway/Liquibase) en lugar de `update`.

## Estructura del código

```
src/main/java/com/ngonzano/springcloud/msmc/products/
├── ProductsApplication.java      # Punto de entrada (@SpringBootApplication)
├── config/
│   ├── ApiProperties.java       # app.api.version → prefijo /api/{version}
│   └── ApiWebConfiguration.java # PathPrefix para @RestController
├── controllers/
│   └── ProductController.java   # REST /product
├── entities/
│   └── Product.java             # Entidad JPA products
├── repositories/
│   └── ProductRepository.java   # Spring Data JPA
└── services/
    ├── ProductService.java
    └── ProductServiceImpl.java  # Lógica + port en findAll / findById
```

## Dependencias Maven (`pom.xml`)

Stack principal gestionado por **Spring Boot 4.0.6** y **Spring Cloud 2025.1.1** (`dependencyManagement`).

| Dependencia | Uso en este proyecto |
|-------------|----------------------|
| `spring-boot-starter-webmvc` | API REST (controllers, Jackson, servlet stack) |
| `spring-boot-starter-data-jpa` | Repositorios JPA, Hibernate, transacciones |
| `mysql-connector-j` (runtime) | Driver JDBC para MySQL |
| `spring-cloud-starter` | Bootstrap de utilidades Spring Cloud (BOM 2025.1.1) |
| `spring-boot-starter-actuator` | Endpoints de salud y metadatos (p. ej. bajo `/actuator`) |
| `spring-boot-devtools` (optional, runtime) | Recarga en desarrollo |
| `lombok` (optional) | Getters/setters y reducción de boilerplate en entidades |
| `spring-boot-configuration-processor` (optional) | Metadatos de configuración para IDEs |
| `spring-boot-starter-data-jpa-test` (test) | Pruebas con contexto JPA |
| `spring-boot-starter-webmvc-test` (test) | Pruebas Web/MVC |

## Pruebas

```bash
./mvnw test
```

## Notas

- El **API Gateway** (si lo usas en el monorepo Spring Cloud) puede enrutar tráfico externo hacia este servicio; la versión visible al cliente puede coincidir o no con `app.api.version` según cómo configures el gateway (rewrite/strip).
