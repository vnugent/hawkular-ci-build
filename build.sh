#!/bin/bash

: ${MVN=/usr/local/bin/mvn}
: ${KETTLE_VERSION=1.0.0-SNAPSHOT}
: ${REPO_URL=http://snapshots.jboss.org/maven2}
: ${DOCKER_TAG=vnguyen/hawkular:snapshot}

echo "KETTLE_VERSION: ${KETTLE_VERSION}"
echo "DOCKER_TAG: ${DOCKER_TAG}"

ARTIFACT=org.hawkular:hawkular-kettle:${KETTLE_VERSION}:zip:distribution
echo "ARTIFACT: ${ARTIFACT}"

${MVN} org.apache.maven.plugins:maven-dependency-plugin:2.10:get\
 -DremoteRepositories=${REPO_URL}\
 -Dartifact=${ARTIFACT}\
 -Dtransitive=false\
&&
${MVN} -X org.apache.maven.plugins:maven-dependency-plugin:2.10:copy\
 -Dartifact="${ARTIFACT}"\
 -DoutputDirectory=.\
 -Dmdep.stripVersion=true\
 -Dmdep.stripClassifier=true\
&&
docker build --force-rm --rm --tag="${DOCKER_TAG}" .
