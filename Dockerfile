#
# Copyright 2015 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Dockerfile for hawkular-kettle

FROM vnguyen/docker-maven

MAINTAINER Viet Nguyen <vnguyen@redhat.com>

ENV REPO_URL=http://snapshots.jboss.org/maven2
ENV KETTLE_VERSION=1.0.0-SNAPSHOT
ENV ARTIFACT=org.hawkular:hawkular-kettle:${KETTLE_VERSION}:zip:distribution

USER root

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get\
 -DremoteRepositories=${REPO_URL}\
 -Dartifact=${ARTIFACT}\
 -Dtransitive=false &&\
 mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:copy\
 -Dartifact="${ARTIFACT}"\
 -DoutputDirectory=.\
 -Dmdep.stripVersion=true\
 -Dmdep.stripClassifier=true

RUN unzip -qq -d /opt /opt/hawkular-kettle.zip;\
    rm /opt/hawkular-kettle.zip;\
    /opt/wildfly-8.2.0.Final/bin/add-user.sh hawkularadmin hawkularadmin --silent

EXPOSE 8080 9990

CMD ["/opt/wildfly-8.2.0.Final/bin/standalone.sh","-b","0.0.0.0","-bmanagement","0.0.0.0"]
