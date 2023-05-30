FROM postgres:15
# Set up database
ENV POSTGRES_USER=citizen_scientist
ENV POSTGRES_PASSWORD=reachforthestars
ENV POSTGRES_DB=exoplanet
RUN mkdir -p /opt/ingest
COPY . /opt/ingest
COPY initdb.sh docker-entrypoint-initdb.d/
