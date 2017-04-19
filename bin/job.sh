#!/bin/sh
DATE=$(date +%Y-%m-%d-%H-%M)
export PGPASSWORD=$POSTGRESQL_PASSWORD
pg_dump --username=$POSTGRESQL_USER --host=$POSTGRESQL_SERVICE_HOST --port=$POSTGRESQL_SERVICE_PORT $POSTGRESQL_DATABASE > /tmp/dump.sql

if [ $? -ne 0 ]; then
    echo "db-dump not successful: ${DATE}"
    exit 1
fi

gzip -c /tmp/dump.sql > $BACKUP_DATA_DIR/dump-${DATE}.sql.gz

if [ $? -eq 0 ]; then
    echo "backup created: ${DATE}"
else
    echo "backup not successful: ${DATE}"
    exit 1
fi

# Delete old files
old_dumps=$(ls -1 $BACKUP_DATA_DIR/dump* | head -n -$BACKUP_KEEP)
if [ "$old_dumps" ]; then
    echo "Deleting: $old_dumps"
    rm $old_dumps
fi

function cleanup {
    rm -f /tmp/dump.sql.gz /tmp/dump.sql
}

trap cleanup EXIT
