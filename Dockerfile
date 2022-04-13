FROM matrixdotorg/synapse:v1.53.0

RUN apt-get update && apt-get install -y git python-dev libpq-dev

# Install deps
RUN apt-get update
RUN apt-get install -y supervisor redis nginx

# Remove the default nginx sites
RUN rm /etc/nginx/sites-enabled/default

# Copy Synapse worker, nginx and supervisord configuration template files
#COPY ./user_data/data/* /data/
COPY ./user_data/etc/ /etc/
COPY ./user_data/conf/ /conf/

# Expose nginx listener port
EXPOSE 8080/tcp

# Volume for user-editable config files, logs etc.
#VOLUME ["/data"]

# A script to read environment variables and create the necessary
# files to run the desired worker configuration. Will start supervisord.
# COPY ./docker/configure_workers_and_start.py /configure_workers_and_start.py
# ENTRYPOINT ["/configure_workers_and_start.py"]

HEALTHCHECK --start-period=5s --interval=15s --timeout=5s \
    CMD /bin/sh /healthcheck.sh

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
