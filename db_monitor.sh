#!/bin/bash
export file1=/var/log/messages
export file2=/var/log/secure
export file3=/var/spool/mail/root
export file4=/var/log/maillog
#publicip="`wget -q -O - http://169.254.169.254/latest/meta-data/public-ipv4`"
short_host=`hostname -s`
host1=`hostname`

export backuploc=/data01/backups/db_backups
#export s3backuploc=/s3backups/"$short_host"_$publicip/db_backups
export schtime="DB Backup 00:00AM PER DAY"
export scriptloc=/backups/scripts/db_backup.sh

case $1 in
0) tail -100f $file1 ;;
1) tail -100f $file2;;
2) tail -100f $file3;;
3) tail -20f $file4;;
4) echo "*************************** START *********************"
df -h
echo ""
echo "Temp File Size : " `du -ch /tmp | tail -1`
echo ""
w
echo ""
uptime
echo ""
echo "CPU UTILIZATION STATUS"
#sar -u 2 5
echo "TOP 10 CPU USERS"
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
echo ""
free -m
echo ""
echo "DB Backup Status "
ls -ltrh $s3backuploc
echo ""
crontab -l
#find / -type f -size +500000k -exec ls -lh {} \; | awk '{print $9 " : " $5}';;
date;;
5) top;;

98) echo "DB BACKUP STATUS :" ; path1=`ls -ltrh $s3backuploc | tail -1 | awk '{print $9}'` ; echo "Backup Size : `ls -ltr /$path1/ | awk '{ SUM += $5} END { print SUM/1024/1024 }'` MB" ; ls -lth $s3backuploc/;;

99) echo "BACKUP REPORT OF $host1 FOR DATE : " `date`
echo ""
echo "*** BACKUP REPORT FOR $host1 ($publicip) ***"
echo "PRIVATE IP :" `/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
echo "HOSTNAME :" `hostname`
echo "DISK SPACE STATUS : "
df -h
echo "TEMP FILE STATUS :" `du -ch /tmp | tail -1 | awk '{ print $1}'`
echo ""
echo "CPU UTILIZATION STATUS"
#sar -u 2 5
echo "TOP 10 CPU USERS"
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
echo ""
echo "MEMORY SPACE STATUS : "
free -m
echo "**************************************************************************"
echo ""
echo "SCHEDULE TIME OF BACKUP :"$schtime 
echo "SCRIPT LOCATION : "$scriptloc
echo "LOCAL BACKUP LOCATION : "$backuploc
echo "S3 BACKUP LOCATION : "$s3backuploc
echo "CURRENT TIME : " `date`

echo "DATABASE SIZE :"
mysql -u root -pr00t123007 -e 'SELECT table_schema "DB Name", ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" FROM information_schema.tables GROUP BY table_schema; '
mysql -u root -pr00t123007 -e 'SELECT  "Total DB Size" , sum( data_length + index_length ) / 1024 / 1024 "Data Base Size in MB" FROM information_schema.TABLES;'
dir=`ls -ltrh $backuploc | tail -1 | awk '{print $9}'`
echo "DB BACKUP SIZE :" `du -ch $backuploc/$dir | tail -1 | awk '{print $1}'`
echo "BACKUP STATUS : "
ls -ltrh $backuploc | tail -20 ;
echo "S3 backup Status :";;
#ls -ltrh $s3backuploc | tail -20 ;;
*) echo "Wrong Option"
exit;;
esac