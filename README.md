istepanov/backup-to-git
=======================

[![Docker Stars](https://img.shields.io/docker/stars/istepanov/backup-to-git.svg)](https://hub.docker.com/r/istepanov/backup-to-git/)
[![Docker Pulls](https://img.shields.io/docker/pulls/istepanov/backup-to-git.svg)](https://hub.docker.com/r/istepanov/backup-to-git/)
[![Docker Build](https://img.shields.io/docker/automated/istepanov/backup-to-git.svg)](https://hub.docker.com/r/istepanov/backup-to-git/)
[![Layers](https://images.microbadger.com/badges/image/istepanov/backup-to-git.svg)](https://microbadger.com/images/istepanov/backup-to-git)

Docker container that periodically backups files to a remote git repository.

### Usage

    docker run -d [OPTIONS] istepanov/backup-to-git [no-cron]

### Required parameters:

* `-e GIT_NAME='Backup User'`: git user name.
* `-e GIT_EMAIL='backup_user@example.com'`: git user email.
* `-e GIT_URL=https://username:password@example.com/path`: git remote repo.
* `-v /path/to/target/folder:/target:ro`: mount target local folder to container's data folder. Content of this folder will be pushed to git repo.

### Optional parameters:

* `-e 'CRON_SCHEDULE=0 1 * * *'`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)). Default is `0 1 * * *` (runs every day at 1:00 am).
* `-e GIT_BRANCH=branch_name`: git branch to put commits to (default is 'master').
* `-e GIT_COMMIT_MESSAGE='Custom message'`: Custom commit message (default is 'Automatic backup').
* `-e TARGET_FOLDER=/target`: target folder inside the container (default is '/target').

### Commands:

* `no-cron`: if specified, run container once and exit (no cron scheduling).

### Examples:

Backup changes to git every minute:

    docker run -d \
        -v GIT_NAME: 'Backup User' \
        -v GIT_EMAIL: 'backup_user@example.com' \
        -v GIT_URL: https://username:password@bitbucket.org/username/repo.git
        -v  CRON_SCHEDULE: '* * * * *'
        -v /home/user/data:/target:ro
        istepanov/backup-to-git
