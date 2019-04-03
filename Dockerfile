FROM docker:latest

RUN apk add --no-cache py-pip && pip install s3cmd

ADD bin/backup.sh /usr/bin/backup
ADD conf/.s3cfg /root/.s3cfg

WORKDIR /tmp

VOLUME /tmp
VOLUME /var/lib/rancher
VOLUME /var/run

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/backup"]
