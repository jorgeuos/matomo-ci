#!/bin/bash

set -e

# shellcheck disable=SC2046
SCRIPT_DIR="$(cd $(dirname "$0") || exit; pwd)"

# Put credentials in your envs
ENV_FILE=${SCRIPT_DIR}/../.env

if [ -f "${ENV_FILE}" ]; then
    # shellcheck disable=SC2046
    export $(sed 's/#.*//g' .env | xargs)
else
    echo "You need a .env file. Check env.sample"
    exit;
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac

MAC="Mac"
MYSQL_DATADIR=/var/lib/mysql
if [[ "$MAC" == "$MACHINE" ]]; then
    export MYSQL_DATADIR=/usr/local/var/mysql
fi

