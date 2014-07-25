#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <file> <db_name> <username> <password>"
  echo "Example: docker run --rm -v /path/to/input.sql:/tmp/input.sql --link CONTAINER_ID:db jwvdiermen/postgresql:9.3 /import_sql.sh /tmp/input.sql DATABASE USER PASSWORD"
  exit 1
fi

BACKUP_FILE=$1
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4

echo "=> Importing backup from $BACKUP_FILE"

cat $BACKUP_FILE | PGPASSWORD=$DB_PASSWORD /usr/lib/postgresql/9.3/bin/psql -d $DB_NAME -U $DB_USER -h $DB_PORT_5432_TCP_ADDR -p $DB_PORT_5432_TCP_PORT -w -q >/dev/null

echo "=> Done!"
