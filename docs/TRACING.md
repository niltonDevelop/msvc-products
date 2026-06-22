# Distributed Tracing en msvc-products

> **Guía completa:** [docs/ZIPKIN.md](../../docs/ZIPKIN.md)

[Micrometer Tracing](https://docs.micrometer.io/tracing/reference/) + **Brave** + **Zipkin**.

## ¿Qué se instrumenta?

| Componente | Span automático |
|------------|-----------------|
| Peticiones HTTP entrantes (`/product/**`) | Sí |
| JPA / Hibernate (consultas DB) | Parcial (via Observation) |
| Logs | Correlación `[msvc-products,traceId,spanId]` |

## Flujo con msvc-items

```
Cliente → msvc-items → msvc-products → MySQL
          traceId ────────────────► (mismo traceId, span hijo)
```

`msvc-items` propaga headers W3C/B3 en Feign/WebClient; este servicio continúa la traza en cada endpoint `/product/**`.

## Dependencia Maven

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-zipkin</artifactId>
</dependency>
```

## Arrancar Zipkin (local)

Solo hace falta **una** instancia de Zipkin. Desde la raíz del monorepo (`SpringCloud/`):

```bash
cd ../..   # o cd /ruta/a/SpringCloud
docker compose up -d
```

## Configuración

| Propiedad | Valor local | Descripción |
|-----------|-------------|-------------|
| `management.tracing.sampling.probability` | `1.0` | 100% en local (prod: reducir a `0.1`) |
| `management.tracing.export.zipkin.endpoint` | `http://localhost:9411/api/v2/spans` | Collector Zipkin |

Config en `application.yml`. En producción, sobreescribe con variables de entorno:

```bash
export MANAGEMENT_TRACING_SAMPLING_PROBABILITY=0.1
export MANAGEMENT_TRACING_EXPORT_ZIPKIN_ENDPOINT=http://zipkin:9411/api/v2/spans
```

## Verificar

1. `docker compose up -d` desde `SpringCloud/` (Zipkin)
2. Arranca Eureka, msvc-products y msvc-items
3. `GET http://localhost:8002/items` (items llama a products)
4. En [http://localhost:9411](http://localhost:9411) → **Run Query**
5. Deberías ver una traza con spans:
   - `http get /items` (msvc-items)
   - `http get /product` (msvc-products, span hijo)

## Referencias

- [Micrometer Tracing](https://docs.micrometer.io/tracing/reference/)
- [Spring Boot — Tracing](https://docs.spring.io/spring-boot/reference/actuator/tracing.html)
- [msvc-items/docs/TRACING.md](../msvc-items/docs/TRACING.md) — flujo completo del ecosistema
