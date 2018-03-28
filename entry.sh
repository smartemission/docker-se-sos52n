#!/usr/bin/env bash

# ToDo: Fix me
if [ ! -d "/usr/local/tomcat/webapps/52n-sos-webapp" ]; then
    $CATALINA_HOME/bin/catalina.sh start
    sleep 20
    $CATALINA_HOME/bin/catalina.sh stop
    sleep 10
fi

envsubst < /opt/sos52n/datasource.properties > /usr/local/tomcat/webapps/52n-sos-webapp/WEB-INF/datasource.properties
cp /opt/sos52n/configuration.db /usr/local/tomcat/webapps/52n-sos-webapp/

sqlite3 /usr/local/tomcat/webapps/52n-sos-webapp/configuration.db "UPDATE administrator_user SET username = '${SOS_USERNAME}', password = '${SOS_PASSWD}'"

$CATALINA_HOME/bin/catalina.sh run