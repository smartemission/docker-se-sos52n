#!/usr/bin/env bash

echo "Entry.sh: START - updating settings from Env Args"

# SOS Web .war is already unpacked!
SOS_WEBAPP_DIR=${CATALINA_HOME}/webapps/sos52n

# DB settings
envsubst < /opt/sos52n/datasource.properties > ${SOS_WEBAPP_DIR}/WEB-INF/datasource.properties
cp /opt/sos52n/configuration.db ${SOS_WEBAPP_DIR}/

# set admin user/pass
sqlite3 ${SOS_WEBAPP_DIR}/configuration.db "UPDATE administrator_user SET username = '${SOS_USERNAME}', password = '${SOS_PASSWD}'"

# externally provided URL
# CREATE TABLE uri_settings (value varchar, identifier varchar not null, primary key (identifier));
# uri_settings with e.g. http://test.smartemission.nl/sos52n/service for identifier service.sosUrl
sqlite3 ${SOS_WEBAPP_DIR}/configuration.db "UPDATE uri_settings SET value = '${SOS_SERVICE_URL}' WHERE identifier = 'service.sosUrl'"

echo "Entry.sh: END - updating settings"

# runnit
${CATALINA_HOME}/bin/catalina.sh run