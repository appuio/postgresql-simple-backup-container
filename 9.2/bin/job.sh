#!/bin/sh
DATE=$(date +%Y-%m-%d-%H-%M)
dump=$(pg_dump --username=$POSTGRESQL_USER --host=$POSTGRES_SERVICE_HOST --port=$POSTGRES_SERVICE_PORT $POSTGRESQL_DATABASE)

if [ $? -ne 0 ]; then
    echo "db-dump not successful: ${DATE}"
    exit 1
fi

printf '%s' "$dump" | gzip > $BACKUP_DATA_DIR/dump-${DATE}.sql.gz

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
