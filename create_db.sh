#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <db_name>"
  exit 1
fi

DB_NAME=$1

if [ ! -f /var/lib/postgresql/9.3/main/.initialized ]; then
  echo "=> Preparing configuration"
  cp /etc/postgresql/9.3/main/postgresql.conf.tpl /etc/postgresql/9.3/main/postgresql.conf
  sed -i "s/\#{SHARED_BUFFERS}/${CFG_SHARED_BUFFERS}/" /etc/postgresql/9.3/main/postgresql.conf
  sed -i "s/\#{WORK_MEM}/${CFG_WORK_MEM}/" /etc/postgresql/9.3/main/postgresql.conf

  echo "=> Initializing PostgreSQL data directory"
  /usr/lib/postgresql/9.3/bin/initdb -D /var/lib/postgresql/9.3/main

  touch /var/lib/postgresql/9.3/main/.initialized
fi

DB_PASSWORD=$(pwgen -s 24 1)
DB_SUPER_PASSWORD=$(pwgen -s 24 1)

echo "=> Creating user admin with random password"
/bin/sh -c "echo \"CREATE USER admin WITH PASSWORD '$DB_PASSWORD';\" | /usr/lib/postgresql/9.3/bin/postgres --single --config-file=/etc/postgresql/9.3/main/postgresql.conf"
/bin/sh -c "echo \"CREATE DATABASE $DB_NAME OWNER admin;\" | /usr/lib/postgresql/9.3/bin/postgres --single --config-file=/etc/postgresql/9.3/main/postgresql.conf"

echo "=> Creating user superadmin with random password"
/bin/sh -c "echo \"CREATE USER superadmin WITH SUPERUSER PASSWORD '$DB_SUPER_PASSWORD';\" | /usr/lib/postgresql/9.3/bin/postgres --single --config-file=/etc/postgresql/9.3/main/postgresql.conf"

echo "=> Done!"

echo "===================================================================="
echo "You can now connect to this PostgreSQL Server using:"
echo ""
echo "    PGPASSWORD=$DB_PASSWORD PSQL -h <host> -U admin -d $DB_NAME"
echo "    PGPASSWORD=$DB_SUPER_PASSWORD PSQL -h <host> -U superadmin -d $DB_NAME"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "===================================================================="
