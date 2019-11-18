HOST="localhost"
short_host=`hostname -s`
long_host=`hostname`
IP=`curl ifconfig.me`"
PVT_IP=`curl ifconfig.me`"
backuploc=/data01/backups/web_backups
#s3backuploc=/s3backups/"$short_host"_$IP/web_backups
case $1 in 
        0)  tail -100f /var/log/syslog;;
        1) tail -100f /var/log/auth.log;;
        2) tail -100f /var/spool/mail/root;;
        3) tail -100f /var/log/dmesg;;
        4) tail -20f /var/log/maillog;;
        5) echo "********************************** START *********************************"
                df -h
                echo ""
                echo "TEMP FILE SIZE : " `du -ch /tmp | tail -1`
                echo ""
                w
                echo ""
                uptime
                echo ""
                free -m
                /usr/bin/crontab -l
                ls -ltrh $backuploc
                date
                crontab -l
                echo ""
                echo "Files greater than 500MB";;
                #find / -type f -size +500000k -exec ls -lh {} \; | awk '{print $9 " : " $5}';;

        6) top;;

        99) echo "BACKUP REPORT $long_host FOR DATE : " `date` 
                echo "" 
                echo "*** BACKUP REPORT FOR $long_host - $IP LINUX SERVER ***" 
                echo "PRIVATE IP :" $PVT_IP
                echo "HOSTNAME :" `hostname` 
                echo "SCHEDULE TIME OF BACKUP : 00:15 PER DAY" 
                echo "BACKUP LOCATION : $backuploc" 
                echo "S3 BACKUP LOCATION : $s3backuploc" 
                echo "CURRENT TIME : " `date` 
                echo "WEBFILE SIZE :" `du -ch /var/www/html | tail -1 | awk '{ print $1}'` 
                dir=`ls -ltrh $backuploc | tail -1 | awk '{print $9}'`
                echo "WEBFILE BACKUP SIZE :" `du -ch $backuploc/$dir | tail -1 | awk '{print $1}'` 
                echo "BACKUP STATUS : " 
                ls -ltrh $backuploc/ | tail -20f
                echo "DISK SPACE STATUS : "
                df -h
                echo "CRONTAB ENTRY:"
                crontab -l
                echo "TEMP FILE STATUS :" `du -ch /tmp | tail -1 | awk '{ print $1}'` 
                echo "MEMORY SPACE STATUS : "
                free -m 
                #echo "LIST OF BLOCKED IP : "
                #cat /var/log/syslog | grep "`date +%b` `date +%e --date=\"-1 day\"`" | grep Ban | awk '{print $1" - "$2" - "$3" - " $4 " - " $9}'
                echo "APACHE2 SERVICE STATUS :" `/bin/systemctl status apache2`;
                                echo "BACKUP SIZE :" `du -ch $backuploc/$dir | tail -1 | awk '{print $1}'`
                                echo "BACKUP STATUS : "
                                ls -ltrh $backuploc | tail -20 ;
                                echo "S3 backup Status :"
                                 $s3backuploc | tail -20 ;;
        *) echo "Wrong Option"
                exit;;
esac