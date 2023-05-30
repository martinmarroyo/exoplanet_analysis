#!/bin/bash

# A script that creates the initial tables and functions in the database

# Check to make sure the database hasn't already been initialized
SCHEMA_CHECK="SELECT CASE WHEN EXISTS(SELECT schema_name FROM information_schema.schemata WHERE schema_name='exoplanet') THEN 1 ELSE 0 END AS exist"
if [ $(psql -qtAX -d exoplanet -U citizen_scientist -c "${SCHEMA_CHECK}") -eq 1 ]
    then
        echo "Database is already initialized. Continuing..."
        exit 0
fi
# Create schema & enable crosstab
echo "Initializing Exoplanet Database..."
SCHEMA_CREATE="CREATE SCHEMA IF NOT EXISTS exoplanet"
CROSSTAB="CREATE EXTENSION tablefunc"
psql -U citizen_scientist -d exoplanet -c "${SCHEMA_CREATE}"
psql -U citizen_scientist -d exoplanet -c "${CROSSTAB}"
echo "Exoplanet schema has been created"

# Create Tables
TABLE_SCRIPTS=/opt/ingest/table
echo "Creating tables..."
for script in $TABLE_SCRIPTS
    do
        psql \
        -U citizen_scientist \
        -d exoplanet $(for script in $(ls $TABLE_SCRIPTS); do echo -f $TABLE_SCRIPTS/$script; done)
    done
echo "Tables have been successfully created"

# Create Functions
FUNC_SCRIPTS=/opt/ingest/function
echo "Initializing functions..."
for script in $FUNC_SCRIPTS
    do
        psql \
        -U citizen_scientist \
        -d exoplanet $(for script in $(ls $FUNC_SCRIPTS); do echo -f $FUNC_SCRIPTS/$script; done)
    done
echo "Functions have been initialized"

# Create Views
VIEW_SCRIPTS=/opt/ingest/view
echo "Creating views..."
for script in $VIEW_SCRIPTS
    do
        psql \
        -U citizen_scientist \
        -d exoplanet $(for script in $(ls $VIEW_SCRIPTS); do echo -f $VIEW_SCRIPTS/$script; done)
    done
echo "Views have been created successfully"

echo "Database has been initialized successfully!"