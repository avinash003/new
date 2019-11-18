#!/bin/bash
short_host=`hostname -s`
long_host=`hostname`
#IP="`wget -q -O - http://169.254.169.254/latest/meta-data/public-ipv4`"
#PVT_IP="Hostname=`wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`"
IP=`curl ifconfig.me`
PVT_IP=`curl ifconfig.me`

export path1=/data01/backups/db_backups
#export path2=/s3backups/"$short_host"_$IP/db_backups/
#export path3=/s3backups/"$short_host"_$IP/monthly_backups/
date1=`date +%y%m%d_%H%M%S`
/usr/bin/find $path1/* -type d -mtime +2 -exec rm -r {} \; 2> /dev/null
cd $path1/
mkdir $date1
USER="backupuser"
PASSWORD="temp"
OUTPUTDIR="$path1/$date1"
MYSQLDUMP="/usr/bin/mysqldump"
MYSQL="/usr/bin/mysql"
HOST="localhost"
databases=`$MYSQL --user=$USER --password=$PASSWORD --host=$HOST \
 -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
echo "` for db in $databases; do
    echo $db

        if [ "$db" = "performance_schema" ] ; then
        $MYSQLDUMP --force --opt --single-transaction --lock-tables=false --skip-events --user=$USER --password=$PASSWORD --host=$HOST --routines $db | gzip > "$OUTPUTDIR/$db.sql.gz"
         else

 $MYSQLDUMP --force --opt --single-transaction --lock-tables=false --events --user=$USER --password=$PASSWORD --host=$HOST --routines $db | gzip > "$OUTPUTDIR/$db.sql.gz"
fi
done `"

if [ $? -eq 0 ] ; then
cp -r $path1/$date1 $path2/
fi

if [ $sysdate -eq 1 ] ; then
cp -r $path1/$date1 
fi

#rm -r /data/tmp/s3backups/"$short_host"_$IP/db_backups/*
#rm -r /data/tmp/s3backups/"$short_host"_$IP/monthly_backups/*
/home/som/db_monitor.sh 99 | tee /home/som/db_backup_report >> /home/db_monthly_backup_report #to create a backup report in /home/som/backup_report file-
cat /home/som/db_backup_report | mail -s "backup_report of $long_host ($IP) " -r $short_host@mitainfotech.com support@mitainfotech.com