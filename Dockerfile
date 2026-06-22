# Requiere libs-msvc-commons. Build desde el directorio raíz SpringCloud:
#   docker build -f msvc-products/Dockerfile -t msvc-products .
# Run:
#   docker run -p 8001:8001 -e PORT=8001 msvc-products

FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /workspace

COPY libs-msvc-commons/pom.xml libs-msvc-commons/pom.xml
COPY libs-msvc-commons/src libs-msvc-commons/src
RUN mvn -B -f libs-msvc-commons/pom.xml install -DskipTests

COPY msvc-products/pom.xml msvc-products/pom.xml
COPY msvc-products/src msvc-products/src
RUN mvn -B -f msvc-products/pom.xml package -DskipTests

FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /app
ENV SPRING_PROFILES_ACTIVE=docker
RUN groupadd -r spring && useradd -r -g spring spring
USER spring:spring
COPY --from=build /workspace/msvc-products/target/*.jar app.jar
EXPOSE 8001
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
