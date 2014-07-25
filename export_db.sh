#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <db_name> <username> <password> > your_backup.bak" 1>&2
  exit 1
fi

DB_NAME=$1
DB_USER=$2
DB_PASSWORD=$3

PGPASSWORD=$DB_PASSWORD /usr/lib/postgresql/9.3/bin/pg_dump \
  --dbname=$DB_NAME \
  --format=plain \
  --ignore-version \
  --no-owner \
  --host $DB_PORT_5432_TCP_ADDR --port $DB_PORT_5432_TCP_PORT \
  --username=$DB_USER --no-password
