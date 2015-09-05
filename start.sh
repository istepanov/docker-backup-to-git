#!/bin/bash

set -e

# required parameters
GIT_NAME=${GIT_NAME:?"GIT_NAME env variable is required"}
GIT_EMAIL=${GIT_EMAIL:?"GIT_EMAIL env variable is required"}
GIT_URL=${GIT_URL:?"GIT_URL env variable is required"}

# optional parameters
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
COMMAND=${1:-backup}
export GIT_BRANCH=${GIT_BRANCH:-master}

case "$COMMAND" in
    backup)
        exec /backup-git.sh
        ;;

    backup-cron)
        CRON_ENV=$(cat << EOM
GIT_NAME=$GIT_NAME
GIT_EMAIL=$GIT_EMAIL
GIT_BRANCH=$GIT_BRANCH
GIT_URL=$GIT_URL
EOM
)
        echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup-git.sh >> /var/log/cron.log 2>&1" | crontab -
        exec cron -f
        ;;

    *)
        echo $"Usage: $0 {backup|backup-cron}"
        exit 1

esac
