# 1. Java 17 기반의 경량 이미지 사용
FROM openjdk:17-jdk-slim

# 2. 빌드된 JAR 파일을 컨테이너에 복사
ARG JAR_FILE=build/libs/demo-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} demo.jar

# 3. Spring Boot 기본 포트
EXPOSE 8081

# 4. 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/demo.jar"]