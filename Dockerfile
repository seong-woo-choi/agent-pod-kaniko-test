# jar 빌드
FROM gradle:7.5.1-jdk-alpine as builder
WORKDIR /build

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

RUN chmod +x gradlew
RUN gradle clean -x test -Dspring.profiles.active=devel --stacktrace
RUN gradle build -x test --parallel

# jar 파일 실행
FROM openjdk:11.0-slim
WORKDIR /app

ARG JAVA_PROFILE
ARG PROFILE
ARG ELASTIC_APM_URL

ENV JAVA_PROFILE=$JAVA_PROFILE
ENV PROFILE=$PROFILE
ENV ELASTIC_APM_URL=$ELASTIC_APM_URL

COPY --from=builder /build/build/libs/*-SNAPSHOT.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]