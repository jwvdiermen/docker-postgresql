#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: cat your_backup.bak | $0 <db_name> <username> <password>"
  exit 1
fi

DB_NAME=$1
DB_USER=$2
DB_PASSWORD=$3

echo "=> Importing backup from STDIN"

cat | PGPASSWORD=$DB_PASSWORD /usr/lib/postgresql/9.3/bin/pg_restore --clean --create \
  --dbname=$DB_NAME \
  --format=custom \
  --ignore-version \
  --jobs=2 \
  --host $DB_PORT_5432_TCP_ADDR --port $DB_PORT_5432_TCP_PORT \
  --username=$DB_USER --no-password
  
echo "=> Done!"
