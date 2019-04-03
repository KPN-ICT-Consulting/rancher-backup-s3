# rancher-backup-s3

Docker image for creating a backup for a single-node Rancher 2.x server. Backup will be pushed to a S3 ObjectStore (in our case Minio).

This backup script will first stop the running rancher server, create a tgz of /var/lib/rancher and puts the file on a S3 ObjectStore. When completed the Rancher server will be started.

## Build

```bash
docker build -t kpnictconsulting/rancher-backup-s3 .
```

## Run

You need a server with Rancher installed.

```bash
docker run --rm -e S3_ACCESS_KEY=x -e S3_SECRET_KEY=y -e S3_HOST=play.minio.io:9000 -e S3_BUCKET=rancher-server-backup -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher kpnictconsulting/rancher-backup-s3

Using:
Docker version 18.09.4, build d14af54
s3cmd version 2.0.2
Stopping Rancher Server
84fd5522ba5c
Create backup from /var/lib/rancher
Starting Rancher Server
84fd5522ba5c
Transfer backup to S3 play.minio.io:9000/rancher-server-backups
Remove local backup
```