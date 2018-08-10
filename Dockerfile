FROM 52north/sos:4.3.7
# see https://github.com/52North/docker-images

LABEL maintainer="Gerwin Hulsteijn, Just van den Broecke"

# OVERRULE, see https://github.com/kartoza/docker-geoserver/blob/master/Dockerfile
# Original:
#ENV GEOSERVER_OPTS "-Djava.awt.headless=true -server -Xms2G -Xmx4G -Xrs -XX:PerfDataSamplingInterval=500 \
# -Dorg.geotools.referencing.forceXY=true -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+UseParallelGC -XX:NewRatio=2 \
# -XX:+CMSClassUnloadingEnabled"
ENV TZ="Europe/Amsterdam" \
	SOS_WEBAPP_DIR="${CATALINA_HOME}/webapps/sos52n" \
	SOS_WEBAPP_WAR="${CATALINA_HOME}/webapps/sos52n.war"  \
	JAVA_OPTS="-Djava.awt.headless=true -server -Xrs -XX:PerfDataSamplingInterval=500 \
    -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap \
    -Dorg.geotools.referencing.forceXY=true -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:NewRatio=2 \
    -XX:+CMSClassUnloadingEnabled"

# Remove unneccesary standard Tomcat Webapps and install required libs
# for initializing config and sqlite config DB. Rename webapp
# and unzip .war for convenience.
# (SOS .war is originally installed at: ${CATALINA_HOME}/webapps/52n-sos-webapp.war).

# 10.8.2018, JvdB: also upgrade Java OpenJDK version to support new JAVA_OPTS settings
RUN \
    rm -rf ${CATALINA_HOME}/webapps/ROOT \
    && rm -rf ${CATALINA_HOME}/webapps/docs \
    && rm -rf ${CATALINA_HOME}/webapps/examples \
    && rm -rf ${CATALINA_HOME}/webapps/host-manager \
    && rm -rf ${CATALINA_HOME}/webapps/manager \
    && mv ${CATALINA_HOME}/webapps/52n-sos-webapp.war ${SOS_WEBAPP_WAR} \
    && unzip ${SOS_WEBAPP_WAR} -d ${SOS_WEBAPP_DIR} \
    && rm -rf ${SOS_WEBAPP_WAR} \
    && echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install gettext-base sqlite3 libsqlite3-dev \
    && apt-get -t jessie-backports install -y "openjdk-8-jre-headless" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/sos52n

COPY data/datasource.properties /opt/sos52n/datasource.properties
COPY data/configuration.db /opt/sos52n/configuration.db
COPY data/db-schema.sql /opt/sos52n/db-schema.sql
COPY data/logback.xml ${SOS_WEBAPP_DIR}/WEB-INF/classes/logback.xml
COPY data/timeseries-api_v1_beans.xml ${SOS_WEBAPP_DIR}/WEB-INF/spring/timeseries-api_v1_beans.xml 
COPY data/jsclient.json ${SOS_WEBAPP_DIR}/static/client/jsClient/settings.json

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

CMD /entry.sh