# sos52n service

The `sos52n` service provides a complete 54North SOS (Sensor Observation Service) 
instance with a complete sqlite configuration.

## Hosting

The Docker Image is hosted as: 
[smartemission/se-sos52n at DockerHub](https://hub.docker.com/r/smartemission/se-sos52n).
Its GH Repo is at https://github.com/52North/SOS.

Versioning via GH tags is done following sos52n versions like `4.3.7` followed by an SE 
version number, for example `4.3.7-1, 4.3.7-2` etc.

## Environment

The following environment vars need to be set, either via `docker-compose` or
Kubernetes.


|Environment variable|
|---|
|DB_HOSTNAME|
|DB_NAME|
|DB_USERNAME|
|DB_PASSWD|
|SOS_DB_SCHEMA|
|SOS_USERNAME|
|SOS_PASSWD|
|SOS_SERVICE_URL|

## Architecture

The image includes the official [52North SOS Docker Image](https://hub.docker.com/r/52north/sos/).
Further vars from that config are overruled/set via its 
Container Environment at runtime via the [entry.sh](entry.sh) script.

## Dependencies

* PostGIS backend

## Links

* SE Platform doc: http://smartplatform.readthedocs.io/en/latest/
* 52North SOS: https://github.com/52North/SOS
* OGC SOS Standard: http://www.opengeospatial.org/standards/sos

