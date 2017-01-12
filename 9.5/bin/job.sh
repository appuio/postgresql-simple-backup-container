#!/bin/sh
DATE=$(date +%Y-%m-%d-%H-%M)
dump=$(pg_dump --username=$POSTGRESQL_USER --host=$POSTGRESQL_HOST -w $POSTGRESQL_DATABASE)

export PGPASSFILE=/tmp/pgpass

echo $POSTGRESQL_HOST":5432:"$POSTGRESQL_DATABASE":"$POSTGRESQL_USER":"$POSTGRESQL_PASSWORD > $PGPASSFILE
chmod 600 $PGPASSFILE
chown $UID:$UID $PGPASSFILE

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
