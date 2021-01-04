#/bin/bash
#指定日期(14天前)
DATA=`date -d "2 week ago" +%Y.%m.%d`
#当前日期
time=`date`
#删除14天前的日志
curl -XDELETE http://127.0.0.1:9200/*-${DATA}
if [ $? -eq 0 ];then
echo $time"-->del $DATA log success.." >> /tmp/es-index-clear.log
else
echo $time"-->del $DATA log fail.." >> /tmp/es-index-clear.log
fi
################
#crontab -e
#10 1 * * * sh /apps/sh/es-index-clear.sh > /dev/null 2>&1
