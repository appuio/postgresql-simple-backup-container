# postgresql-simple-backup-container
Provide a PostgreSQL database backup container that does backups using a cron job. The backup is done by the `pg_dump` tool.

Full backups using `pg_basebackup` are available in the [postgresql-backup-container](https://github.com/appuio/postgresql-backup-container) repository.

## Different PostgreSQL versions
Backup for different versions are provided:
* 9.5
* 9.4
* 9.2

Use the Docker file of the directory of your desired PostgreSQL version.

## How to deploy the backup container
Before executing the following commands make sure that you are logged into OpenShift via the commandline (`oc login`) and using the correct project (`oc project`). The postgresql service doesn't have to be located in the same project, if you can access it remotely.

The first command creates the container. The second command configures the container to do backups of your database in a desired schedule.

```
$ oc new-app https://github.com/appuio/postgresql-simple-backup-container.git \
     --strategy=docker \
     --context-dir=9.5 \
     -l app=backup

$ oc env dc postgresql-simple-backup-container -e POSTGRES_USER=user -e PGPASSWORD=pw -e POSTGRES_SERVICE_HOST=mysql -e POSTGRES_SERVICE_PORT=port -e POSTGRES_DATABASE=database -e BACKUP_DATA_DIR=/tmp/ -e BACKUP_KEEP=5 -e BACKUP_MINUTE=10 -e BACKUP_HOUR=11
```

This will create a container for backups of a PostgreSQL database 9.5. To backup an other version, change the value of the `--context-dir` option.

**Note:** For values with comma (eg. 11,23) you will have to edit the dc with vim: `oc edit dc postgresql-simple-backup-container`
