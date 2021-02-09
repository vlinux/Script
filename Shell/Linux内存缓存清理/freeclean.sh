#!/bin/bash
used=`free -m | awk 'NR==2' | awk '{print $3}'`
free=`free -m | awk 'NR==2' | awk '{print $4}'`
echo "===========================" >> /var/spool/cron/dropcache.log
date >> /var/spool/cron/dropcache.log
echo "Memory usage | [Use:${used}MB][Free:${free}MB]" >> /var/spool/cron/dropcache.log
#如果可用内存小于5.5G则进行清理释放
if [ $free -le 5500 ] ; then
  sync && echo 1 > /proc/sys/vm/drop_caches
  sync && echo 2 > /proc/sys/vm/drop_caches
  sync && echo 3 > /proc/sys/vm/drop_caches
  echo "OK" >> /var/spool/cron/delcache.log
else
  echo "Not required" >> /var/spool/cron/dropcache.log