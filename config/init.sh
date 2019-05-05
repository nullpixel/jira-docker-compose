#!/bin/bash
 
EXISTS=`
psql -U postgres <<-EOSQL
  SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DB'
EOSQL
`
 
if [[ $EXISTS == "1" ]]; then
  echo "******DOCKER DATABASE ALREADY CONFIGURED******"
else
  echo "******CONFIGURING DOCKER DATABASE******"
 
  echo "Creating user"
psql -U postgres <<-EOSQL
  CREATE ROLE $POSTGRES_USER WITH LOGIN ENCRYPTED PASSWORD '${POSTGRES_PASSWORD}' SUPERUSER;
EOSQL
 
  echo "Creating table"
psql -U postgres <<-EOSQL
  CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
EOSQL
 
  echo "Granting privileges to user"
psql -U postgres <<-EOSQL
  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
EOSQL
 
  echo "******DOCKER DATABASE CONFIGURED******"
fi