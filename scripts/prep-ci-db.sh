#!/bin/bash

set -e
SCRIPT_START=$(date +%s)


# shellcheck source=/dev/null
source ./scripts/check-env.sh

DOCKER_COMPOSE_DIR=${SCRIPT_DIR}/../

cd "${DOCKER_COMPOSE_DIR}" || exit

# Make sure no old stuff lying around
git co .
git pull origin main

log_n_echo () {
    echo "$1" | tee "${SCRIPT_LOGSFILE}"
}

# On host
CI_DUMP=${CI_DB_DUMP_PATH}/${DB_DUMP_NAME}
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
            gunzip "$CI_DUMP.gz"
        fi
    else
        # shellcheck source=/dev/null
        source ./scripts/fetch-dump.sh
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

# Launch docker and execute commands inside container
log_n_echo "Launch docker"
docker-compose -f ./docker-compose-ci.yml up -d

log_n_echo "Checking for version:"
log_n_echo "Wait for response."
while ! docker-compose -f docker-compose-ci.yml exec matomo-ci ./console core:version
    do 
        log_n_echo "Still waiting."
        sleep 1
done

# More reliable way of determin DB host
# CI_DB_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db-ci)
# export CI_DB_HOST

# Just output something to see if get a response
SQL="SHOW DATABASES;"
log_n_echo "Try: docker-compose -f docker-compose-ci.yml exec db-ci mysql -AN -e${SQL}"
log_n_echo "Wait for DB."
while ! docker-compose -f docker-compose-ci.yml exec db-ci mysql -u"${CI_DB_USER}" -p"${CI_DB_PASS}" -h"${CI_DB_HOST}" -P"${CI_DB_PORT_INTERNAL}" -AN -e"${SQL}" ; do sleep 1; done

if [ "$TEST" != true ]; then
    # Do Import
    log_n_echo "Import DB, this might take a while."
    start=$(date +%s)
    if docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} 'matomo-ci' < /docker-entrypoint-initdb.d/99-matomo-ci.sql"; then
        end=$(date +%s)
        runtime=$((end-start))
        log_n_echo "DB import done in: ... $runtime"
    else
        log_n_echo "Errhm, something went wrong!"
        exit;
    fi
fi

log_n_echo "Check if we see tables."
if docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} -AN -e\"USE 'matomo-ci'; SHOW TABLES;\""; then
    log_n_echo "We're up!"
else
    log_n_echo "No tables, can't proceed!"
fi

log_n_echo "Make config file writable"
docker exec --user=root -it  matomo-ci chown www-data:www-data /var/www/html/config/config.ini.php
# Fix config file for Matomo inside docker
log_n_echo "Try to update conf file."
if docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="dbname" --value="${CI_DB_NAME}"; then
    # We need to update credentials somehow
    # sed -i 's/CI_DB_PASS/${CI_DB_PASS}/g' ./config/config.ini.php"; then
    log_n_echo "Config file has write access. Set configs."
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="host" --value="${CI_DB_HOST}"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="username" --value="${CI_DB_USER}"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="password" --value="${CI_DB_PASS}"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="port" --value="${CI_DB_PORT_INTERNAL}"
    log_n_echo "Configured config file."
else
    log_n_echo "Config not writable!"
    exit;
fi


# Delete old logs:
log_n_echo "Delete old logs"
if [ "$MACHINE" == "Mac" ]; then
    LAST_DATE=$(date -v "-90d" "+%Y-%m-%d")
else
    LAST_DATE=$(date +%Y-%m-%d -d "90 days ago")
fi
EARLIEST_DATE=2021-08-12
if docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:delete-logs-data -n --dates=${EARLIEST_DATE},${LAST_DATE}"; then
    log_n_echo "Logs deleted, commence archiving."
else
    log_n_echo "Errhm, somethings wrong!"
    exit;
fi


if [ "$TEST" != true ]; then
    # Perform DB update
    log_n_echo "Core update"
    start=$(date +%s)
    if docker-compose -f docker-compose-ci.yml exec matomo-ci ./console core:update; then
        end=$(date +%s)
        runtime=$((end-start))
        log_n_echo "Core:update done in: ... $runtime"
    else
        log_n_echo "Errhm, somethings wrong!"
        exit;
    fi
fi

if [ "$TEST" != true ]; then
    log_n_echo "Run core:archive:"
    start=$(date +%s)
    if docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:archive"; then
        end=$(date +%s)
        runtime=$((end-start))
        log_n_echo "Archiving done in: ... $runtime"
    else
        log_n_echo "Errhm, something went wrong with core:archive, check output for more info."
        exit;
    fi
fi

log_n_echo "Download and activate UserConsole if it's not active"
if ! docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "test -d /var/www/html/plugins/UserConsole && echo 'UserConsole Exists'"; then
    log_n_echo "Couldn't find, downloading."
    docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "curl -f -sS https://plugins.matomo.org/api/2.0/plugins/UserConsole/download/latest > /tmp/UserConsole.zip";
    docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "unzip /tmp/UserConsole.zip -q -d /var/www/html/plugins -o";
fi
log_n_echo "Files in place, activating."
docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console plugin:activate UserConsole";

log_n_echo "Reset password:"
if docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console user:reset-password --login=admin-test --new-password=\"mtmo@rocks\""; then
    log_n_echo "Password resetted to a very insecure password, use only in testing environment!"
else
    log_n_echo "Errhm, something went wrong!"
    exit;
fi

# Inside container still
log_n_echo "Dump prepped CI DB:"
docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysqldump -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} ${CI_DB_NAME} > ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"

# Use mounted dir, so we can run this from host
log_n_echo "GZIP dump:"
gzip -f "${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"

log_n_echo "Give current user writable permission"
chmod +w "${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}".gz

# Consider using minio docker image 🤔
log_n_echo "Send to minio."

$MINIO_CLIENT --config-dir "${MINIO_CONFIG}" cp "${IMPORT_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}.gz" "${MINIO_BUCKET_PATH}/${CI_DB_DUMP_NAME}.gz"



SCRIPT_END=$(date +%s)
SCRIPT_RUNTIME=$((SCRIPT_END-SCRIPT_START))
log_n_echo "Done in ${SCRIPT_RUNTIME}s!"

log_n_echo "Cleaning up."
git co .
# shellcheck source=/dev/null
source ./scripts/destroy.sh
