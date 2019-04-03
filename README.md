# rancher-backup-s3

Docker image for creating a backup for a single-node Rancher 2.x server. Backup will be pushed to a S3 ObjectStore (in our case Minio).

This backup script will first stop the running rancher server, create a tgz of /var/lib/rancher and puts the file on a S3 ObjectStore. When completed the Rancher server will be started.

## Build

docker build -t kpnictconsulting/rancher-backup-s3 .

## Run

You need a server with Rancher installed.

'''bash
docker run --rm -e S3_ACCESS_KEY=x -e S3_SECRET_KEY=y -e S3_HOST=minio:9000 -e S3_BUCKET=rancher-server-backup -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher kpnictconsulting/rancher-backup-s3
'''