#!/bin/bash
DATE=$(date +%d-%m-%Y_%H-%M-%S)
echo "########## BACKUP $(date +%d-%m-%Y_%H-%M-%S) ##########" >> /var/log/bkp/backup_log_$DATE.txt
echo "^^^^^^^\n1. Start Backup Job at $(date +%d-%m-%Y_%H-%M-%S)" >>  /var/log/bkp/backup_log_$DATE.txt
echo "^^^^^^^\n2. Starting TAR archieving at $(date +%d-%m-%Y_%H-%M-%S)" >>  /var/log/bkp/backup_log_$DATE.txt
tar --selinux\
 --acls\
 --xattrs\
 -cvvvvvzf\
 /tmp/docker_bkp_$(date +%d-%m-%Y_%H-%M-%S).tgz\
 /docker/*\
 &>>  /var/log/bkp/backup_log_$DATE.txt
echo "^^^^^^^\n3. Send to remote backup server  $(date +%d-%m-%Y_%H-%M-%S)" >>  /var/log/bkp/backup_log_$DATE.txt
rsync -vvv /tmp/docker_bkp_*.tgz  artys@test1:/backups >>  /var/log/bkp/backup_log_$DATE.txt
echo "^^^^^^^\n3. Cleaning TMP dir at  $(date +%d-%m-%Y_%H-%M-%S)" >>  /var/log/bkp/backup_log_$DATE.txt
rm -f /tmp/docker_bkp_*
echo "\n########### BACKUP FINISHED archieving at $(date +%d-%m-%Y_%H-%M-%S) ##########\n\n" >>  /var/log/bkp/backup_log_$DATE.txt
