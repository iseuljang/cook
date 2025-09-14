FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY cook.war /usr/local/tomcat/webapps/ROOT.war

ENV JAVA_TOOL_OPTIONS="-Dserver.port=$PORT"
EXPOSE $PORT

CMD ["catalina.sh", "run"]
