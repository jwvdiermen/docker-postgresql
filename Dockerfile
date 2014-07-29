# Dockerized version of PostgreSQL 9.3
# 
# Version: 0.1.0

FROM ubuntu:12.04
MAINTAINER jwvdiermen

# Setup locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install PostgreSQL APT repository
RUN apt-get update && apt-get -y --force-yes install wget
RUN echo deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main > /etc/apt/sources.list.d/peer60-postgres.list
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

# Create the PostgreSQL user
RUN adduser --system --disabled-login --home /var/lib/postgresql --no-create-home --group --gecos "PostgreSQL administrator" --shell /bin/bash --uid 5432 postgres

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install postgresql-9.3 pwgen

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
