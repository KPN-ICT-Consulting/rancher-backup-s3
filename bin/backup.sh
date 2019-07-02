#!/bin/sh

# stop on first error
set -e

RANCHER_DATA_DIR="/var/lib/rancher"
BACKUP_DIR="/tmp"
BACKUP_DATE=$(date +"%F")
BACKUP_FILE="rancher_$BACKUP_DATE.tar.gz"
S3CMD_CONFIG=/root/.s3cfg

if [ -z "$S3_ACCESS_KEY" ]; then
    echo "No S3_ACCESS_KEY defined in environment"
    exit 1
fi

if [ -z "$S3_SECRET_KEY" ]; then
    echo "No S3_SECRET_KEY defined in environment"
    exit 1
fi

if [ -z "$S3_HOST" ]; then
    echo "No S3_HOST defined in environment"
    exit 1
fi

if [ -z "$S3_BUCKET" ]; then
    echo "No S3_BUCKET defined in environment"
    exit 1
fi

if [ ! -d "$RANCHER_DATA_DIR" ]; then
    echo "Rancher data dir $RANCHER_DATA_DIR does not exists"
    exit 2
fi

echo "Using:"
docker --version
s3cmd --version

# Set user provided key and secret in .s3cfg file
echo "" >> "$S3CMD_CONFIG"
echo "host_base=${S3_HOST}" >> "$S3CMD_CONFIG"
echo "host_bucket=${S3_HOST}" >> "$S3CMD_CONFIG"
echo "access_key=${S3_ACCESS_KEY}" >> "$S3CMD_CONFIG"
echo "secret_key=${S3_SECRET_KEY}" >> "$S3CMD_CONFIG"

RANCHER_DOCKER_ID=`docker ps | grep "rancher/rancher:" | awk '{ print $1 }'`

echo "Stopping Rancher Server"
docker stop $RANCHER_DOCKER_ID

echo "Create backup from $RANCHER_DATA_DIR"
cd $RANCHER_DATA_DIR 
tar -zcf $BACKUP_DIR/$BACKUP_FILE *

echo "Starting Rancher Server"
docker start $RANCHER_DOCKER_ID

# echo "Create bucket $S3_BUCKET if not exists"
# s3cmd mb s3://$S3_BUCKET

echo "Transfer backup to S3 $S3_HOST/$S3_BUCKET"
s3cmd --no-check-certificate put $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET/$BACKUP_FILE

echo "Remove local backup"
rm $BACKUP_DIR/$BACKUP_FILE

exit 0