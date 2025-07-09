#!/bin/bash
set -e;

# Setup for non-root user (used by n8n)
if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
    GRANT CREATE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
EOSQL
else
  echo "SETUP INFO: No Environment variables given for n8n user!"
fi

# Setup for NocoDB-specific database and user
if [ -n "${NOCODB_USER:-}" ] && [ -n "${NOCODB_PASSWORD:-}" ] && [ -n "${NOCODB_DB:-}" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE ${NOCODB_DB};
    CREATE USER ${NOCODB_USER} WITH ENCRYPTED PASSWORD '${NOCODB_PASSWORD}';
    GRANT ALL PRIVILEGES ON DATABASE ${NOCODB_DB} TO ${NOCODB_USER};
EOSQL
else
  echo "SETUP INFO: No Environment variables given for NocoDB user!"
fi