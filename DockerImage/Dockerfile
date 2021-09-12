FROM tomcat

COPY tomcatxmls/tomcat-users.xml /usr/local/tomcat/conf/

COPY tomcatxmls/context.xml /usr/local/tomcat/webapps/manager/META-INF/

ADD  images /usr/local/tomcat/webapps/webapp/

ADD  htmlcode /usr/local/tomcat/webapps/webapp/ 
