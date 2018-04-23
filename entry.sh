#!/usr/bin/env bash

# SOS Web .war is already unpacked!
SOS_WEBAPP_DIR=${CATALINA_HOME}/webapps/sos52n

envsubst < /opt/sos52n/datasource.properties > ${SOS_WEBAPP_DIR}/WEB-INF/datasource.properties
cp /opt/sos52n/configuration.db ${SOS_WEBAPP_DIR}/

sqlite3 ${SOS_WEBAPP_DIR}/configuration.db "UPDATE administrator_user SET username = '${SOS_USERNAME}', password = '${SOS_PASSWD}'"

${CATALINA_HOME}/bin/catalina.sh run