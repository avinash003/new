date1=`date +%y%m%d_%H%M%S`

cd /backups
mkdir $date1
USER="root"
PASSWORD="temp"
OUTPUTDIR=/backups/$date1
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
sshpass -p "temp" scp -r * root@192.168.72.52:/backups/db_backups
rm -rf /backups/*