#!/bin/bash

BACKUP_DIR="/root/backups"                          
RETENTION_DAYS=7                               
MINIO_ALIAS="postgresql-backup"                         
MINIO_BUCKET="postgresql-backup"                     
BACKUP_FILE="postgresql_databases_full_backup_$(date +%Y%m%d).sql.gz"

mkdir -p $BACKUP_DIR

echo "Memulai proses backup..."
sudo -u postgres pg_dumpall | gzip > $BACKUP_DIR/$BACKUP_FILE

if [ $? -ne 0 ]; then
    echo "Backup gagal!" >&2
    exit 1
fi

echo "Backup sukses dibuat: $BACKUP_DIR/$BACKUP_FILE"

echo "Mengupload backup..."
mcli cp $BACKUP_DIR/$BACKUP_FILE $MINIO_ALIAS/$MINIO_BUCKET/

if [ $? -eq 0 ]; then
    echo "Upload sukses!"
else
    echo "Upload gagal!" >&2
    exit 1
fi

echo "Menghapus lokal backup dalam retensi $RETENTION_DAYS hari..."
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "Proses backup selesai pada $(date)."
