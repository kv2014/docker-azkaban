# VERSION 1.0
# AUTHOR: Matthieu "Puckel_" Roisil
# DOCKER HUB: https://hub.docker.com/u/puckel/
# DESCRIPTION: Simple Debian image for azkaban-executor based on official java:8
# BUILD: docker build --rm -t azkaban-webserver .
# SOURCE: https://github.com/puckel/docker-azkaban

FROM alpine

MAINTAINER Kevin Yang <yx3957@163.com>

ENV AZK_VERSION 3.79.0
ENV MYSQL_JDBC_VERSION 5.1.35

RUN apk add --update openjdk8-jre curl bash mysql-client && rm -rf /var/cache/apk/*

RUN curl -sLk https://github.com/kv2014/docker-azkaban/blob/master/pkgs/azkaban-web-server-$AZK_VERSION.tar.gz| tar xz
RUN curl -sLk http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_JDBC_VERSION.tar.gz| tar xz
RUN mv mysql-connector-java-$MYSQL_JDBC_VERSION/mysql-connector-java-$MYSQL_JDBC_VERSION-bin.jar azkaban-web-server-$AZK_VERSION/extlib/
RUN rm -rf mysql-connector-java-$MYSQL_JDBC_VERSION
RUN mkdir azkaban-web-server-$AZK_VERSION/logs/
# Work around to run container as a daemon
RUN sed -i "s/&//" azkaban-web-server-$AZK_VERSION/bin/azkaban-web-start.sh

ADD keystore azkaban-web-server-$AZK_VERSION/keystore
ADD conf/azkaban.properties azkaban-web-server-$AZK_VERSION/conf/azkaban.properties

# Azkaban web server port
EXPOSE 8443

# Define default workdir
WORKDIR /azkaban-web-server-$AZK_VERSION
ADD conf/run.sh run.sh
RUN chmod +x run.sh

CMD ["./run.sh"]
