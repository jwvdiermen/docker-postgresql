#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <db_name> <username> <password> > your_backup.bak"
  exit 1
fi

DB_NAME=$1
DB_USER=$2
DB_PASSWORD=$3

echo "=> Exporting backup to STDOUT"

PGPASSWORD=$DB_PASSWORD /usr/lib/postgresql/9.3/bin/pg_dump \
  --dbname=$DB_NAME \
  --format=custom \
  --ignore-version \
  --host $DB_PORT_5432_TCP_ADDR --port $DB_PORT_5432_TCP_PORT \
  --username=$DB_USER --no-password

echo "=> Done!"
