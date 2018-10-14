# Mysql 5.7 Install

FROM centos:7

## USER AND GROUP
ENV MY_USER="mysql"
ENV MY_GROUP="mysql"
ENV MY_UID="50"
ENV MY_GID="50"
RUN groupadd -g ${MY_GID} -r ${MY_GROUP} && \
    adduser ${MY_USER} -u ${MY_UID} -M -s /sbin/nologin -g ${MY_GROUP}

## INSTALL
RUN mkdir /
RUN wget https://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm && \
    rpm -ivh mysql57-community-release-el7-10.noarch.rpm

RUN yum -y install epel-release && \
    yum -y install hostname
    yum -y update

RUN yum -y install mysql-community-server

RUN yum -y autoremove && \
    yum clean metadata && \
    yum clean all && \
    yum -y install hostname && \
    yum clean all

## VOLUMES
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
VOLUME /var/sock/mysqld
VOLUME /etc/mysql/conf.d
VOLUME etc/mysql/docker-default.d

## INIT
RUN systemctl start mysqld.service

## DB CONFIG
COPY ./files/dbconfig.sh /
ENTRYPOINT ["/dbconfig.sh"]

EXPOSE 3306
