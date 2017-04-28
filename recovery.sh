#!/bin/bash

ZABBIXHOST="主机IP"
ZABBIXPORT="MySQL端口"
ZABBIXUSER="MySQL数据库"
ZABBIXPASSWD="MySQL密码"
ZABBIXDATABASE="MySQL数据库名"
ZABBIXRECOVERYPATH=`ls -t ~/backup | grep -v "zabbixLogs.log" | head -1`
echo $ZABBIXRECOVERY

cd ~/backup/$ZABBIXRECOVERYPATH
for i in `ls ~/backup/$ZABBIXRECOVERYPATH`
do
        echo $i
        mysqldump -u$ZABBIXUSER -p$ZABBIXPASSWD -P$ZABBIXPORT -h$ZABBIXHOST $ZABBIXDATABASE < $i
        sleep 1
done

[[ "$?" == 0 ]] && echo "`date`:recovery succeed!" >> ~/backup/zabbixLogs.log
[[ "$?" != 0 ]] && echo "`date`:recovery fail!!!" >> ~/backup/zabbixLogs.log
