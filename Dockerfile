# Minimal Minecraft Docker container for Pterodactyl Panel
FROM alpine:3.2

MAINTAINER Michael Parker, <parkervcp+docker@gmail.com>

# Credit to the original minimal java container go to roland@jolokia.org
# https://github.com/rhuss/docker-java-jolokia/blob/master/base/alpine/jre/8/Dockerfile

ENV JRE=jre1.8.0_60 \
    JAVA_HOME=/opt/jre

# That's an 1.8.0_60 JRE from OpenJDK.net Courtesy to https://github.com/frol/docker-alpine-oraclejdk8 from where the setup of glibc is borrowed
RUN apk add --update curl ca-certificates openssl perl && \
    cd /tmp && \
    wget "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
         "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    mkdir /opt && \
    wget http://www.java.net/download/jdk8u60/archive/b18/binaries/jre-8u60-ea-bin-b18-linux-x64-02_jun_2015.tar.gz -O /tmp/${JRE}.tgz && \
    cd /opt && tar zxvf /tmp/${JRE}.tgz && \
    ln -s /opt/${JRE} /opt/jre && \
    ln -s /opt/jre/bin/java /usr/bin/java && \
    cd /opt/jre/lib/amd64 && rm libjavafx_* libjfx* libfx* && \
    cd /opt/jre/lib/ && rm -rf ext/jfxrt.jar jfxswt.jar javafx.properties font* && \
    rm /tmp/* /var/cache/apk/*

RUN adduser -D -h /home/container container

USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./start.sh /start.sh

CMD ["/bin/ash", "/start.sh"]
