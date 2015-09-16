#!/bin/bash

set -e

# required parameters
GIT_NAME=${GIT_NAME:?"GIT_NAME env variable is required"}
GIT_EMAIL=${GIT_EMAIL:?"GIT_EMAIL env variable is required"}
GIT_URL=${GIT_URL:?"GIT_URL env variable is required"}

# optional parameters
CRON_SCHEDULE=${CRON_SCHEDULE:-0 * * * *}
COMMAND=${1:-backup}
export GIT_BRANCH=${GIT_BRANCH:-master}
export GIT_COMMIT_MESSAGE=${GIT_COMMIT_MESSAGE:-Automatic backup}
export TARGET_FOLDER=${TARGET_FOLDER:-/target}

case "$COMMAND" in
    backup)
        exec /backup-git.sh
        ;;

    backup-cron)
        LOGFIFO='/var/log/cron.fifo'
        if [[ ! -e "$LOGFIFO" ]]; then
            mkfifo "$LOGFIFO"
        fi
        CRON_ENV=$(cat << EOM
GIT_NAME='$GIT_NAME'
GIT_EMAIL='$GIT_EMAIL'
GIT_BRANCH='$GIT_BRANCH'
GIT_URL='$GIT_URL'
GIT_COMMIT_MESSAGE='$GIT_COMMIT_MESSAGE'
GIT_IGNORE='$GIT_IGNORE'
TARGET_FOLDER='$TARGET_FOLDER'
EOM
)
        echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup-git.sh > $LOGFIFO 2>&1" | crontab -
        crontab -l
        cron

        tail -f "$LOGFIFO"
        ;;

    *)
        echo -e $"Error: unknown command $COMMAND. List of available commands:\n* backup (default)\n* backup-cron"
        exit 1

esac
