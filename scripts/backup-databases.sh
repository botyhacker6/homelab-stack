#!/bin/bash
BACKUP_DIR="/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

echo "Starting PostgreSQL backup..."
pg_dumpall -U "$POSTGRES_USER" | gzip > "$BACKUP_DIR/pg_all_$TIMESTAMP.sql.gz"

echo "Starting Redis backup..."
redis-cli -a "$REDIS_PASSWORD" BGSAVE
# Note: In a real docker environment, we would wait for BGSAVE to finish and then copy the dump.rdb

echo "Cleaning up old backups (older than 7 days)..."
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup process completed."
