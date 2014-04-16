#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: cat file_to_import.sql | $0 <db_name> <username> <password>"
  exit 1
fi

DB_NAME=$1
DB_USER=$2
DB_PASSWORD=$3

echo "=> Importing SQL from STDIN"
cat | PGPASSWORD=$DB_PASSWORD /usr/lib/postgresql/9.3/bin/psql -d $DB_NAME -U $DB_USER -h $DB_PORT_5432_TCP_ADDR -p $DB_PORT_5432_TCP_PORT -w -q
echo "=> Done!"
