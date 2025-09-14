FROM openjdk:13-jdk-slim

COPY cook.war /app/app.war

ENV JAVA_TOOL_OPTIONS="-Dserver.port=$PORT"

CMD ["java", "-jar", "/app/app.war"]
