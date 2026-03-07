FROM tomcat:9

COPY target/indigo.war /usr/local/tomcat/webapps/

EXPOSE 8080
