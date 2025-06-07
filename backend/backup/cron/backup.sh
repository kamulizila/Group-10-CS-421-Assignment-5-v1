#!/bin/sh

# Backup directory (shared volume)
BACKUP_DIR="/backups"
mkdir -p "$BACKUP_DIR"

# PostgreSQL connection
DB_HOST=${POSTGRES_HOST:-db}
DB_PORT=${POSTGRES_PORT:-5432}
DB_NAME=${POSTGRES_DB:-group_db}
DB_USER=${POSTGRES_USER:-postgres}
DB_PASS=${POSTGRES_PASSWORD:-admin}

# Timestamped filename
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$BACKUP_DIR/db_backup_$DATE.sql"

# Export password to avoid interactive prompt
export PGPASSWORD="$DB_PASS"

# Perform backup
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" > "$FILENAME"

echo "Backup created at $FILENAME"
