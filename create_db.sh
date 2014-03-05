#!/bin/bash

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <db_name> <user_name>"
	exit 1
fi

DB_NAME=$1
DB_USER=$2

if [ ! -f /var/lib/postgresql/9.3/main/.initialized ]; then
	echo "=> Initializing PostgreSQL data directory"
	/usr/lib/postgresql/9.3/bin/initdb -D /var/lib/postgresql/9.3/main
	touch /var/lib/postgresql/9.3/main/.initialized
fi

DB_PASSWORD=$(pwgen -s 12 1)
echo "=> Creating user $DB_USER with random password"
/bin/sh -c "echo \"CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';\" | /usr/lib/postgresql/9.3/bin/postgres --single --config-file=/etc/postgresql/9.3/main/postgresql.conf"
/bin/sh -c "echo \"CREATE DATABASE $DB_NAME OWNER $DB_USER;\" | /usr/lib/postgresql/9.3/bin/postgres --single --config-file=/etc/postgresql/9.3/main/postgresql.conf"

echo "=> Done!"

echo "===================================================================="
echo "You can now connect to this PostgreSQL Server using:"
echo ""
echo "    PGPASSWORD=$DB_PASSWORD PSQL -h <host> -U $DB_USER -d $DB_NAME"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "===================================================================="
