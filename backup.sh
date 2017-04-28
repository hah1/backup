#!/bin/bash

ZABBIXHOST="主机IP"
ZABBIXPORT="MySQL端口"
ZABBIXUSER="MySQL账号"
ZABBIXPASSWD="MySQL密码"
ZABBIXDUMPPATH="/root/backup/"
ZABBIXDUMPDATABASE="MySQL数据库名"
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

[[ "$?" == 0 ]] && echo "#${ZABBIXDATE}:backup zabbix MySQL succeed!    `date`" >> ${ZABBIXDUMPPATH}${ZABBIXLOGS}
[[ "$?" != 0 ]] && echo "${ZABBIXDATE}:backup zabbix MySQL fail!!!      `date`" >> ${ZABBIXDUMPPATH}${ZABBIXLOGS}

cd ${ZABBIXDUMPPATH}
rm -rf $(date '+%Y-%m-%d' --date='20 days ago')

exit 0
