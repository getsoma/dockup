#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh
fi

if [ -n "$CRON_TIME" ]; then
  echo "${CRON_TIME} /backup.sh >> /dockup.log 2>&1" > /crontab.conf
  env | grep 'AWS\|BACKUP_NAME\|S3_BUCKET_NAME|PATHS_TO_BACKUP' | cat - /crontab.conf > temp && mv temp /crontab.conf
  crontab  /crontab.conf
  echo "=> Running dockup backups as a cronjob for ${CRON_TIME}"
  exec cron -f
fi
