# Dockerized version of PostgreSQL 9.3
# 
# Version: 0.1.0

FROM ubuntu:14.04
MAINTAINER jwvdiermen

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install postgresql postgresql-contrib pwgen

# Remove pre-installed database
RUN rm -rf /var/lib/postgresql/9.3/main/*

# Add image configuration and scripts
ADD start.sh /start.sh
ADD create_db.sh /create_db.sh
ADD import_sql.sh /import_sql.sh
ADD export_db.sh /export_db.sh
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf.tpl
RUN chmod 755 /*.sh

# Expose data directory volume
VOLUME ["/var/lib/postgresql/9.3/main"]
RUN chown postgres:postgres /var/lib/postgresql/9.3/main

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configuration defaults
ENV CFG_SHARED_BUFFERS 256
ENV CFG_WORK_MEM 1

USER postgres
EXPOSE 5432
CMD ["/start.sh"]
