FROM debian:jessie
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-get update && \
    apt-get install -y git cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD backup-git.sh /backup-git.sh
RUN chmod +x /backup-git.sh

RUN mkdir -p /target

ENTRYPOINT ["/start.sh"]
CMD [""]
