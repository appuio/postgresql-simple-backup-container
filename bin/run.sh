#!/bin/sh
mkdir -p $BACKUP_DATA_DIR

echo "$BACKUP_MINUTE $BACKUP_HOUR * * * /opt/app-root/src/bin/job.sh" > /opt/app-root/src/crontab
devcron.py /opt/app-root/src/crontab
