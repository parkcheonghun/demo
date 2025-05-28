# 베이스 이미지: Tomcat
FROM tomcat:9.0-jdk17

# 기본 war 삭제 (선택)
RUN rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war

# WAR 복사 (이름을 ROOT.war로 바꾸면 http://localhost:8080으로 접속 가능)
COPY build/libs/demo-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# 8080을 8180으로 바꿔서 톰캣 포트를 변경
RUN sed -i 's/port="8080"/port="8180"/' /usr/local/tomcat/conf/server.xml

# 포트 노출 (컨테이너 포트)
EXPOSE 8280