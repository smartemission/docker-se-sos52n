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

# Check if database schema exists otherwise create schema.

# Check if we need to create DB tables
# See https://www.postgresql.org/docs/current/static/functions-info.html#FUNCTIONS-INFO-CATALOG-TABLE
SOS_DB_TABLE=observation
DB_NAME=gis
export PGUSER=${DB_USERNAME}
export PGPASSWORD=${DB_PASSWD}

# First check if DB Schema present: if not: no use to proceed.
#echo "Check if ${SOS_DB_SCHEMA} exists"
#schema_present=$(psql -qtAX -h "${DB_HOSTNAME}" -c "SELECT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = '${SOS_DB_SCHEMA}')" ${DB_NAME})
## echo "schema_present = ${schema_present}"
#if [ "${schema_present}" != "t" ]
#then
#	echo "Schema ${SOS_DB_SCHEMA} does not exist, create this first, quitting..."
#	exit -1
#else
#	echo "OK: Schema ${SOS_DB_SCHEMA} exists"
#fi
#
#echo "Check if ${SOS_DB_SCHEMA}.${SOS_DB_TABLE} exists"
#table_present=$(psql -qtAX -h "${DB_HOSTNAME}" -c "select count(to_regclass('${SOS_DB_SCHEMA}.${SOS_DB_TABLE}'))" ${DB_NAME})
## echo "table_present=${table_present}"
#if [ "${table_present}" = "0" ]
#then
#	echo "Creating Postgres DB tables..."
#	psql -q -h "${DB_HOSTNAME}" "${DB_NAME}" -f /opt/sos52n/db-schema.sql
#else
#	echo "OK: Postgres DB already populated"
#fi

# Remove any old cache on each start
/bin/rm -f ${SOS_WEBAPP_DIR}/cache.tmp > /dev/null

echo "Entry.sh: END - updating settings"

# runnit
${CATALINA_HOME}/bin/catalina.sh run