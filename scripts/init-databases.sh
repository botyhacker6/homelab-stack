#!/bin/bash
set -e

create_db() {
    local db=$1
    local password=$2
    echo "Creating database and user: $db"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
        CREATE USER $db WITH PASSWORD '$password';
        CREATE DATABASE $db;
        GRANT ALL PRIVILEGES ON DATABASE $db TO $db;
EOSQL
}

# Liste des services à initialiser
create_db "nextcloud" "${NEXTCLOUD_DB_PASSWORD}"
create_db "gitea"     "${GITEA_DB_PASSWORD}"
create_db "outline"   "${OUTLINE_DB_PASSWORD}"
create_db "authentik" "${AUTHENTIK_DB_PASSWORD}"
create_db "grafana"   "${GRAFANA_DB_PASSWORD}"

echo "Database initialization completed successfully."
