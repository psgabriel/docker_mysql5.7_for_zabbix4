#!/bin/bash

systemctl start mysqld.service

zbx_default_db='./db_zbx_4.0/'
mysql_pas_temp=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

mysql -uroot -p"${mysql_pas_temp}" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Zbx@123:';"

mysql -uroot -p"Zbx@123:';" --connect-expired-password -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -p"Zbx@123:';" --connect-expired-password -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'Zbx@123:';"
mysql -uroot -p"Zbx@123:';" --connect-expired-password -e "grant all privileges on zabbix.* to 'zabbix'@'%' identified by 'Zbx@123:';"

mysql -uroot -p"Zbx@123:';" zabbix < "${zbx_default_db}"schema.sql
mysql -uroot -p"Zbx@123:';" zabbix < "${zbx_default_db}"images.sql
mysql -uroot -p"Zbx@123:';" zabbix < "${zbx_default_db}"data.sql

echo "Mysql intalled with credential: root / Zbx@123:"
