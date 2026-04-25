FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY .mvn .mvn
COPY mvnw mvnw
COPY mvnw.cmd mvnw.cmd
COPY pom.xml pom.xml

RUN chmod +x mvnw && ./mvnw -DskipTests dependency:go-offline

COPY src ./src
RUN ./mvnw -DskipTests clean package

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app
COPY --from=build /app/target/App-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
