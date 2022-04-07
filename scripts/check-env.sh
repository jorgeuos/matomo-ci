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

