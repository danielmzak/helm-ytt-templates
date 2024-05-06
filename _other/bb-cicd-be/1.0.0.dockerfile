#
# build:
# $ ./docker-build-and-push.sh 1.0.0
#

FROM google/cloud-sdk:460.0.0

#
# os info
#

RUN cat /etc/os-release

#
# install helm
# https://helm.sh/
# https://github.com/helm/helm/releases \
#

RUN curl https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz --output helm-v3.14.0-linux-amd64.tar.gz && \
    tar xvf helm-v3.14.0-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm

RUN helm version

#
# install ytt
# https://carvel.dev/ytt/
# https://github.com/carvel-dev/ytt/releases
#

RUN curl -LO https://github.com/carvel-dev/ytt/releases/download/v0.47.0/ytt-linux-amd64 && \
    chmod +x ytt-linux-amd64 && \
    mv ytt-linux-amd64 /usr/local/bin/ytt

RUN ytt version

#
# install java SDK
# https://bell-sw.com/libericajdk/
# https://bell-sw.com/pages/downloads/
#

RUN curl -LO https://download.bell-sw.com/java/21.0.2+14/bellsoft-jdk21.0.2+14-linux-amd64.deb && \
    shasum -a 1 bellsoft-jdk21.0.2+14-linux-amd64.deb && \
    apt install ./bellsoft-jdk21.0.2+14-linux-amd64.deb

RUN java --version

#
# install gradle
# https://gradle.org/
# https://gradle.org/releases/
#

ENV GRADLE_HOME=/opt/gradle/gradle-8.5
ENV PATH=${GRADLE_HOME}/bin:${PATH}

RUN apt install unzip && \
    mkdir /opt/gradle && \
    curl -LO https://services.gradle.org/distributions/gradle-8.5-bin.zip && \
    unzip -d /opt/gradle gradle-8.5-bin.zip

RUN gradle --version

#
# Check python version (debian 11 default python3 version is: 3.9
#

# Check Python version
RUN python3 --version
RUN pip3 --version
