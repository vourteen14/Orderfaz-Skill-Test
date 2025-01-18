#!/bin/bash

MINIO_ALIAS="postgresql-backup"
MINIO_BUCKET="postgresql-backup"
LOCAL_RESTORE_DIR="/tmp/restore"
RETENTION_DAYS=7
BACKUP_FILE=""

mkdir -p $LOCAL_RESTORE_DIR

echo "Menampilkan 7 file backup terbaru di MinIO..."

mcli ls $MINIO_ALIAS/$MINIO_BUCKET/ | sort -r | head -n $RETENTION_DAYS

echo "Masukkan nama file backup yang ingin di-restore (misalnya, postgresql_databases_full_backup_20250118.sql.gz):"
read BACKUP_FILE

if ! mcli ls $MINIO_ALIAS/$MINIO_BUCKET/$BACKUP_FILE &>/dev/null; then
    echo "File backup tidak ditemukan di MinIO!" >&2
    exit 1
fi

echo "Mengunduh file backup dari MinIO..."
mcli cp $MINIO_ALIAS/$MINIO_BUCKET/$BACKUP_FILE $LOCAL_RESTORE_DIR/

if [ $? -ne 0 ]; then
    echo "Gagal mengunduh file backup dari MinIO!" >&2
    exit 1
fi

echo "File backup berhasil diunduh ke: $LOCAL_RESTORE_DIR/$BACKUP_FILE"

echo "Mendekompresi file backup..."
gunzip -c $LOCAL_RESTORE_DIR/$BACKUP_FILE > $LOCAL_RESTORE_DIR/postgresql_databases_full_backup.sql

if [ $? -ne 0 ]; then
    echo "Gagal mendekompresi file backup!" >&2
    exit 1
fi

echo "File backup berhasil didekompresi."

echo "Melakukan restore database ke PostgreSQL..."
sudo -u postgres psql < $LOCAL_RESTORE_DIR/postgresql_databases_full_backup.sql

if [ $? -ne 0 ]; then
    echo "Restore database gagal!" >&2
    exit 1
fi

echo "Restore database berhasil dilakukan!"

echo "Membersihkan file sementara..."
rm -f $LOCAL_RESTORE_DIR/$BACKUP_FILE $LOCAL_RESTORE_DIR/postgresql_databases_full_backup.sql

echo "Proses restore selesai pada $(date)."
