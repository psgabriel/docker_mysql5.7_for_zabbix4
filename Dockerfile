# Mysql 5.7 Install

FROM centos:7

## USER AND GROUP
ENV MY_USER="mysql"
ENV MY_GROUP="mysql"
ENV MY_UID="5000"
ENV MY_GID="5000"
RUN groupadd -g ${MY_GID} -r ${MY_GROUP} && \
    adduser ${MY_USER} -u ${MY_UID} -g ${MY_GROUP}

## INSTALL
WORKDIR /
RUN yum -y install wget sudo
RUN wget https://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm && \
    rpm -ivh mysql57-community-release-el7-10.noarch.rpm

RUN yum -y install epel-release && \
    yum -y install hostname && \
    yum -y update

RUN yum -y install mysql-community-server

RUN yum -y autoremove && \
    yum clean metadata && \
    yum clean all && \
    yum -y install hostname && \
    yum clean all

## VOLUMES
VOLUME  /var/lib/mysql && \
        /var/log/mysql && \
        /var/sock/mysqld && \
        /etc/mysql/conf.d && \
        etc/mysql/docker-default.d

## DB INIT & CONFIG
COPY ./files/dbconfig.sh /
COPY ./files/my.cnf /etc/
RUN chmod 777 /dbconfig.sh
RUN chmod 777 /etc/my.cnf
#ENTRYPOINT ["/dbconfig.sh"]

EXPOSE 3306

VOLUME [ “/sys/fs/cgroup” ]
CMD ["/usr/sbin/init"]

USER mysql
