#!/bin/bash

set -e
SCRIPT_START=$(date +%s)

# shellcheck source=/dev/null
source ./scripts/check-env.sh
# shellcheck source=/dev/null
source ./scripts/functions.sh

DOCKER_COMPOSE_DIR=${SCRIPT_DIR}/../

cd "${DOCKER_COMPOSE_DIR}" || exit


log_n_echo "Begin DB prep! $(date \"+%Y-%m-%d H:i:s\")" "new"

# On host
CI_DUMP=${IMPORT_DB_DUMP_PATH}/${DB_DUMP_NAME}
TODAY=$(date "+%Y-%m-%d")
check_if_gz(){
    log_n_echo "Check for GZ"
    # shellcheck source=/dev/null
    source ./scripts/fetch-dump.sh
    if [ -f "$CI_DUMP.gz" ]; then
        GZ_DUMP_FROM=$(date -r "$CI_DUMP.gz" "+%Y-%m-%d")
        log_n_echo "GZIP found, from: ${GZ_DUMP_FROM}."
        if [ "${GZ_DUMP_FROM}" == "${TODAY}" ]; then
            log_n_echo "GZ dump is from today, Unzip."
            log_n_echo "Unzipping."
            gunzip -f "$CI_DUMP.gz"
            return 0;
        else
            log_n_echo "Dump is old, fetch new one"
            log_n_echo "Fetch new dump"
            fetch_dump "${DB_DUMP_NAME}"
            gunzip -f "$CI_DUMP.gz"
            return 0;
        fi
    else
        log_n_echo "No $CI_DUMP.gz, fetch new one"
        fetch_dump "${DB_DUMP_NAME}"
        gunzip -f "$CI_DUMP.gz"
        return 0;
    fi
    log_n_echo "GZ done."
    return 0;
}

# First step
if step_or_skip; then
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
            log_n_echo "Dump is old, check for GZ"
            check_if_gz
        fi
    else
        log_n_echo "No $CI_DUMP, check for GZ"
        check_if_gz
    fi

    # Check again if above steps failed
    if [ -f "$CI_DUMP" ]; then
        log_n_echo "We have file."
    else
        log_n_echo "Still no file, exit."
        SKIP="Couldn't determine which dump to prep."
    fi
fi

if step_or_skip; then
    # Launch docker and execute commands inside container
    log_n_echo "Launch docker"
    if ${DOCKER_COMPOSE} -f ./docker-compose-ci.yml up -d; then
        log_n_echo "Checking for version:"
        log_n_echo "Wait for response."
        while ! ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console core:version
            do
                log_n_echo "Still waiting."
                sleep 1
        done
    else
        log_n_echo "Docker not launching." "skip"
    fi
fi

# More reliable way of determin DB host
# CI_DB_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db-ci)
# export CI_DB_HOST

if step_or_skip; then
    # Just output something to see if get a response
    SQL="SHOW DATABASES;"
    log_n_echo "Try: ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec db-ci mysql -AN -e${SQL}"
    log_n_echo "Wait for DB."
    while ! ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec db-ci mysql -u"${CI_DB_USER}" -p"${CI_DB_PASS}" -h"${CI_DB_HOST}" -P"${CI_DB_PORT_INTERNAL}" -AN -e"${SQL}" ; do sleep 1; done
fi

log_n_echo "We mount the dump and import it at start up." "skip"
if step_or_skip; then
    # Do Import
    log_n_echo "Import DB, this might take a while."
    start=$(date +%s)
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} 'matomo-ci' < /docker-entrypoint-initdb.d/99-matomo-ci.sql"; then
        end=$(date +%s)
        IMPORT_RUNTIME=$((end-start))
        log_n_echo "DB import done in: ... $IMPORT_RUNTIME"
    else
        log_n_echo "Errhm, something went wrong!"
        SKIP=true
    fi
fi
SKIP=false

if step_or_skip; then
    log_n_echo "Check if we see tables."
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec db-ci bash -c \
    "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} -AN -e\"USE 'matomo-ci'; SHOW TABLES;\""; then
        log_n_echo "We're up!"
    else
        log_n_echo "No tables, can't proceed!"
        SKIP=true
    fi
fi

if step_or_skip; then
    log_n_echo "Make config file writable"
    docker exec --user=root -it  matomo-ci chown www-data:www-data /var/www/html/config/config.ini.php
    # Fix config file for Matomo inside docker
    log_n_echo "Try to update conf file."
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="dbname" --value="${CI_DB_NAME}"; then
        # We need to update credentials somehow
        # sed -i 's/CI_DB_PASS/${CI_DB_PASS}/g' ./config/config.ini.php"; then
        log_n_echo "Config file has write access. Set configs."
        ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="host" --value="${CI_DB_HOST}"
        ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="username" --value="${CI_DB_USER}"
        ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="password" --value="${CI_DB_PASS}"
        ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="port" --value="${CI_DB_PORT_INTERNAL}"
        log_n_echo "Configured config file."
    else
        log_n_echo "Config not writable!"
        SKIP=true
    fi
fi


if step_or_skip; then
    # Delete old logs:
    log_n_echo "Delete old logs"
    if [ "$MACHINE" == "Mac" ]; then
        LAST_DATE=$(date -v "-90d" "+%Y-%m-%d")
    else
        LAST_DATE=$(date +%Y-%m-%d -d "90 days ago")
    fi
    EARLIEST_DATE=2021-08-12
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:delete-logs-data -n --dates=${EARLIEST_DATE},${LAST_DATE}"; then
        log_n_echo "Logs deleted, commence archiving."
    else
        log_n_echo "Errhm, somethings wrong!"
        SKIP=true
    fi
fi

if step_or_skip; then
    # Perform DB update
    log_n_echo "Core update"
    start=$(date +%s)
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci ./console core:update; then
        end=$(date +%s)
        CORE_UPDATE_RUNTIME=$((end-start))
        log_n_echo "Core:update done in: ... $CORE_UPDATE_RUNTIME"
    else
        log_n_echo "Errhm, somethings wrong!"
        SKIP=true
    fi
fi

if step_or_skip; then
    log_n_echo "Run core:archive:"
    start=$(date +%s)
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:archive"; then
        end=$(date +%s)
        CORE_ARCHIVE_FIRST_RUNTIME=$((end-start))
        log_n_echo "Archiving done in: ... $CORE_ARCHIVE_FIRST_RUNTIME"
    else
        log_n_echo "Errhm, something went wrong with core:archive, check output for more info."
        SKIP=true
    fi
fi

if step_or_skip; then
    log_n_echo "Download and activate UserConsole if it's not active"
    if ! ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "test -d /var/www/html/plugins/UserConsole && echo 'UserConsole Exists'"; then
        log_n_echo "Couldn't find, downloading."
        ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "curl -f -sS https://plugins.matomo.org/api/2.0/plugins/UserConsole/download/latest > /tmp/UserConsole.zip";
        ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "unzip /tmp/UserConsole.zip -q -d /var/www/html/plugins -o";
    fi
    log_n_echo "Files in place, activating."
    ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "./console plugin:activate UserConsole";
fi

if step_or_skip; then
    log_n_echo "Reset password:"
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "./console user:reset-password --login=${CI_MTMO_USER} --new-password=${CI_MTMO_PASS}"; then
        log_n_echo "Password resetted to a very insecure password, use only in testing environment!"
    else
        log_n_echo "Errhm, something went wrong!"
        SKIP=true
    fi
fi

if step_or_skip; then
    # Just in case, archive again because of weird behaviour
    log_n_echo "Run core:archive:"
    start=$(date +%s)
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:archive"; then
        end=$(date +%s)
        CORE_ARCHIVE_SECOND_RUNTIME=$((end-start))
        log_n_echo "Archiving done in: ... $CORE_ARCHIVE_SECOND_RUNTIME"
    else
        log_n_echo "Errhm, something went wrong with core:archive, check output for more info."
        SKIP=true
    fi
fi

if step_or_skip; then
    # Inside container still
    log_n_echo "Dump prepped CI DB:"
    if ${DOCKER_COMPOSE} -f docker-compose-ci.yml exec db-ci bash -c "mysqldump -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} ${CI_DB_NAME} > ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"; then
        log_n_echo "Dump created: ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"
    else
        log_n_echo "Errhm, something went wrong with mysqldump."
        SKIP=true
    fi
fi

if step_or_skip; then
    # Use mounted dir, so we can run this from host
    log_n_echo "GZIP dump:"
    if gzip -f "${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"; then
        log_n_echo "GZIPPED ${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}.gz"
    else
        log_n_echo "Errhm, something went wrong with gzip."
        SKIP=true
    fi
fi

if step_or_skip; then
    log_n_echo "Give current user writable permission"
    chmod +w "${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}".gz
fi

if step_or_skip; then
    # Consider using minio docker image 🤔
    log_n_echo "Send to minio."
    $MINIO_CLIENT --config-dir "${MINIO_CONFIG}" cp "${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}.gz" "${MINIO_BUCKET_PATH}/${CI_DB_DUMP_NAME}.gz"
fi


SCRIPT_END=$(date +%s)
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))
log_n_echo "Done in ${SCRIPT_RUNTIME}:s!"

if [ -n "$SLACK_T000" ]; then
    log_n_echo "Notify Slack"
    # shellcheck source=/dev/null
    source ./scripts/notify.sh
    # All runtimes:
    # IMPORT_RUNTIME
    # CORE_UPDATE_RUNTIME
    # CORE_ARCHIVE_FIRST_RUNTIME
    # CORE_ARCHIVE_SECOND_RUNTIME
    # SCRIPT_RUNTIME
    notify_slack "Prepped DB in Total: ${SCRIPT_RUNTIME}:s,\n \
    DB-import in: ${IMPORT_RUNTIME}:s \n \
    core:update in: ${CORE_UPDATE_RUNTIME}:s \n \
    core:archive first in: ${CORE_ARCHIVE_FIRST_RUNTIME}:s \n \
    core:archive second in: ${CORE_ARCHIVE_SECOND_RUNTIME}:s \n \
    Skipped step: ${SKIP}"
fi

log_n_echo "Cleaning up."

# shellcheck source=/dev/null
source ./scripts/destroy.sh

log_n_echo "All done, bye 👋! $(date \"+%Y-%m-%d H:i:s\")"
