FROM adoptopenjdk/openjdk11 AS builder
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootJAR

FROM adoptopenjdk/openjdk11
RUN apt-get update && apt-get install -y redis-server
COPY --from=builder build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "redis-server & java -jar /app.jar"]