#!/bin/bash

ZABBIXHOST="lo数据库IP"
ZABBIXPORT="数据库端口"
ZABBIXUSER="数据库账号"
ZABBIXPASSWD="数据库密码"
ZABBIXDUMPPATH="/root/backup/"
ZABBIXDUMPDATABASE="数据库库名"
ZABBIXDATE=`date '+%Y-%m-%d'`
ZABBIXLOGS="zabbixLogs.log"


[[ -d ${ZABBIXDUMPPATH} ]] || mkdir ${ZABBIXDUMPPATH}
cd ${ZABBIXDUMPPATH}
[[ -e ${ZABBIXLOGS} ]] || touch ${ZABBIXLOGS}
[[ -d ${ZABBIXDUMPPATH}${ZABBIXDATE} ]] || mkdir ${ZABBIXDUMPPATH}${ZABBIXDATE}
cd ./${ZABBIXDATE}

ZABBIXTABLENAMEALL=$(mysql -u${ZABBIXUSER} -p${ZABBIXPASSWD} -P${ZABBIXPORT} -h${ZABBIXHOST} ${ZABBIXDUMPDATABASE} -e "show tables" | egrep -v "(Tables_in_zabbix|history*|trends*|acknowledges|alerts|auditlog|events|service_alarms )")

for ZABBIXTABLENAME in $ZABBIXTABLENAMEALL
do
	mysqldump -u${ZABBIXUSER} -p${ZABBIXPASSWD} -P${ZABBIXPORT} -h${ZABBIXHOST} ${ZABBIXDUMPDATABASE} ${ZABBIXTABLENAME} > ${ZABBIXTABLENAME}.sql
	sleep 10
done

[[ "$?" == 0 ]] && echo "#${ZABBIXDATE}:backup zabbix MySQL succeed!" >> ${ZABBIXDUMPPATH}${ZABBIXLOGS}
[[ "$?" != 0 ]] && echo "${ZABBIXDATE}:backup zabbix MySQL fail!!!" >> ${ZABBIXDUMPPATH}${ZABBIXLOGS}

cd ${ZABBIXDUMPPATH}
rm -rf $(date '+%Y-%m-%d' --date='20 days ago')

exit 0
