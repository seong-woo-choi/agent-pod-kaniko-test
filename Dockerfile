# jar 빌드
FROM gradle:7.5-jdk11-alpine as builder
WORKDIR /home/jenkins/agent/workspace/agent-pod-test

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

RUN chmod +x ./gradlew
#RUN ./gradle clean -x test -Dspring.profiles.active=devel --stacktrace
RUN ./gradle clean -x test -Dspring.profiles.active=devel --stacktrace
RUN ./gradle build -x test --parallel

# jar 파일 실행
FROM openjdk:11.0-slim
WORKDIR /home/jenkins/agent/workspace/agent-pod-test

ENV JAVA_PROFILE $JAVA_PROFILE
ENV PROFILE $PROFILE
ENV ELASTIC_APM_URL $ELASTIC_APM_URL

COPY --from=builder /build/libs/*-SNAPSHOT.jar ./app.jar

EXPOSE 8080

RUN java -jar app.jar