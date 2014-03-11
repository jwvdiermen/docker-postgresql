# Dockerized version of PostgreSQL 9.3
# 
# Version: 0.1.0

FROM ubuntu:latest
MAINTAINER jwvdiermen

# Install PostgreSQL APT repository
RUN apt-get update && apt-get -y --force-yes install wget
RUN echo deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main > /etc/apt/sources.list.d/peer60-postgres.list
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

# Create the PostgreSQL user
RUN adduser --system --disabled-login --home /var/lib/postgresql --no-create-home --group --gecos "PostgreSQL administrator" --shell /bin/bash --uid 5432 postgres

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install postgresql-9.3 pwgen

# Add image configuration and scripts
ADD start.sh /start.sh
ADD create_db.sh /create_db.sh
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
RUN chmod 755 /*.sh

# Expose data directory volume
VOLUME ["/var/lib/postgresql/9.3/main"]
RUN chown postgres:postgres /var/lib/postgresql/9.3/main

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER postgres
EXPOSE 5432
CMD ["/start.sh"]
