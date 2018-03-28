FROM 52north/sos:4.3.7
MAINTAINER Gerwin Hulsteijn

ENV TZ Europe/Amsterdam

RUN \
  apt-get update \
  && apt-get -y install gettext-base sqlite3 libsqlite3-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY data/datasource.properties /opt/sos52n/datasource.properties
COPY data/configuration.db /opt/sos52n/configuration.db

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

CMD /entry.sh