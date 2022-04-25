#!/bin/bash

# shellcheck source=/dev/null
source ./scripts/check-env.sh
source ./scripts/functions.sh

set -e

# On host
CI_DUMP=${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}
TODAY=$(date "+%Y-%m-%d")
check_if_gz(){
    log_n_echo "Check for GZ"
    if [ -f "$CI_DUMP.gz" ]; then
        GZ_DUMP_FROM=$(date -r "$CI_DUMP.gz" "+%Y-%m-%d")
        log_n_echo "GZIP found, from: ${GZ_DUMP_FROM}."
        if [ "${GZ_DUMP_FROM}" == "${TODAY}" ]; then
            log_n_echo "GZ dump is from today, Unzip."
            log_n_echo "Unzipping."
            gunzip "$CI_DUMP.gz"
        else
            log_n_echo "Dump is old, fetch new one"
            log_n_echo "Fetch new dump"
            # shellcheck source=/dev/null
            source ./scripts/fetch-dump.sh
            fetch_dump "${CI_DB_DUMP_NAME}"
            gunzip "$CI_DUMP.gz"
        fi
    else
        # shellcheck source=/dev/null
        source ./scripts/fetch-dump.sh
        fetch_dump "${CI_DB_DUMP_NAME}"
        gunzip "$CI_DUMP.gz"
    fi
}

# Check if file exists and latest
log_n_echo "Check if dump exists and from today"
if [ -f "$CI_DUMP" ]; then
    log_n_echo "DB dump found:"
    log_n_echo "$CI_DUMP"
    DUMP_FROM=$(date -r "$CI_DUMP" "+%Y-%m-%d")
    log_n_echo "From: ${DUMP_FROM}"
    if [ "${DUMP_FROM}" == "${TODAY}" ]; then
        log_n_echo "Dump is from today, ${TODAY}, continue"
    else
        check_if_gz
    fi
else
    check_if_gz
fi

# Check again if above steps failed
if [ -f "$CI_DUMP" ]; then
    log_n_echo "We have file."
else
    log_n_echo "Still no file, exit."
    exit;
fi
