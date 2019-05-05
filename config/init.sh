#!/bin/bash
 
EXISTS=`
psql -U postgres <<-EOSQL
  SELECT 1 FROM pg_database WHERE datname='$DB_NAME'
EOSQL
`
 
if [[ $EXISTS == "1" ]]; then
  echo "******DOCKER DATABASE ALREADY CONFIGURED******"
else
  echo "******CONFIGURING DOCKER DATABASE******"
 
  echo "Creating user"
psql -U postgres <<-EOSQL
  CREATE ROLE $DB_USER WITH LOGIN ENCRYPTED PASSWORD '${DB_PASS}' SUPERUSER;
EOSQL
 
  echo "Creating table"
psql -U postgres <<-EOSQL
  CREATE DATABASE $DB_NAME WITH OWNER $DB_USER ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
EOSQL
 
  echo "Granting privileges to user"
psql -U postgres <<-EOSQL
  GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOSQL
 
  echo "******DOCKER DATABASE CONFIGURED******"
fi