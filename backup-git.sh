#!/bin/bash

set -e

export GIT_DIR="/var/git"
export GIT_WORK_TREE="/target"

if [ ! -d $GIT_DIR ]; then
    mkdir -p $GIT_DIR
    git init
    git config user.name "$GIT_NAME"
    git config user.email "$GIT_EMAIL"
    git remote add origin "$GIT_URL"
    git fetch --all
    git symbolic-ref HEAD refs/remotes/origin/$GIT_BRANCH
    git reset
    git checkout -b $GIT_BRANCH
fi

git add -A
git commit -m 'Automatic backup'
git push origin $GIT_BRANCH
