#!/bin/bash

echo "=> Preparing configuration"
cp /etc/postgresql/9.3/main/postgresql.conf.tpl /etc/postgresql/9.3/main/postgresql.conf
sed -i "s/\#{SHARED_BUFFERS}/${CFG_SHARED_BUFFERS}/" /etc/postgresql/9.3/main/postgresql.conf
sed -i "s/\#{WORK_MEM}/${CFG_WORK_MEM}/" /etc/postgresql/9.3/main/postgresql.conf

echo "=> Starting PostgreSQL"
/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf