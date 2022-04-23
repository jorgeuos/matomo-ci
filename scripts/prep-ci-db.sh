#!/bin/bash

set -e

# shellcheck source=/dev/null
source ./scripts/check-env.sh

DOCKER_COMPOSE_DIR=${SCRIPT_DIR}/../

cd "${DOCKER_COMPOSE_DIR}" || exit

CI_DUMP=${CI_DB_DUMP_PATH}/${DB_DUMP_NAME}
TODAY=$(date "+%Y-%m-%d")
fetch_db_dump(){
    if [ -f "$CI_DUMP.gz" ]; then
        GZ_DUMP_FROM=$(date -r "$CI_DUMP.gz" "+%Y-%m-%d")
        echo "GZIP found, from: ${GZ_DUMP_FROM}."
        if [ "${GZ_DUMP_FROM}" == "${TODAY}" ]; then
            echo "GZ dump is from today, Unzip."
            echo "Unzipping."
            gunzip "$CI_DUMP.gz"
        else
            echo "Dump is old, fetch new one"
            echo "Fetch new dump"
            # shellcheck source=/dev/null
            source ./scripts/fetch-dump.sh
        fi
    fi
}

# Check if file exists and latest
echo "Check if dump exists and from today"
if [ -f "$CI_DUMP" ]; then
    echo "DB dump found:"
    echo "$CI_DUMP"
    DUMP_FROM=$(date -r "$CI_DUMP" "+%Y-%m-%d")
    echo "From: ${DUMP_FROM}"
    if [ "${DUMP_FROM}" == "${TODAY}" ]; then
        echo "Dump is from today, ${TODAY}, continue"
    else
        fetch_db_dump
    fi
else
    fetch_db_dump
fi

echo "Launch docker"
docker-compose -f ./docker-compose-ci.yml up -d

check_version(){
    echo "Checking for version:"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console core:version
}
echo "Wait for response."
while ! check_version ; do echo "Still waiting." && sleep 1; done

# More reliable way of determin DB host
# CI_DB_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db-ci)
# export CI_DB_HOST

# Just output something to see if get a response
echo "Wait for DB."
SQL="SHOW DATABASES;"
echo "Try: docker-compose -f docker-compose-ci.yml exec db-ci mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} -P${CI_DB_PORT} -AN -e${SQL}"
while ! docker-compose -f docker-compose-ci.yml exec db-ci mysql -u"${CI_DB_USER}" -p"${CI_DB_PASS}" -h"${CI_DB_HOST}" -P"${CI_DB_PORT}" -AN -e"${SQL}" ; do sleep 1; done

# Do Import
echo "Import DB"
docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} 'matomo-ci' < /docker-entrypoint-initdb.d/99-matomo-ci.sql"

echo "Check if we see tables."
if docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} -AN -e\"USE 'matomo-ci'; SHOW TABLES;\""; then
    echo "We're up!"
else
    echo "No tables, can't proceed!"
fi

# Fix config file for Matomo inside docker
echo "Try to update conf file."
if docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="dbname" --value="${CI_DB_NAME}"; then
    # We need to update credentials somehow
    # sed -i 's/CI_DB_PASS/${CI_DB_PASS}/g' ./config/config.ini.php"; then
    echo "Config file has write access. Set configs."
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="host" --value="${CI_DB_HOST}"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="username" --value="${CI_DB_USER}"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="password" --value="${CI_DB_PASS}"
    docker-compose -f docker-compose-ci.yml exec matomo-ci ./console config:set --section="database" --key="port" --value="${CI_DB_PORT}"
    echo "Configured config file."
else
    echo "Config not writable!"
    exit;
fi


# Delete old logs:
echo "Delete old logs"
LAST_DATE=$(date -v "-90d" "+%Y-%m-%d")
EARLIEST_DATE=2021-08-12
if docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:delete-logs-data -n --dates=${EARLIEST_DATE},${LAST_DATE}"; then
    echo "Logs deleted, commence archiving."
else
    echo "Errhm, somethings wrong!"
fi

# Perform DB update
docker-compose -f docker-compose-ci.yml exec matomo-ci ./console core:update

echo "Run core:archive:"
start=$(date +%s)
if time docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:archive"; then
    end=$(date +%s)
    runtime=$((end-start))
    echo "Archiving done in: ... $runtime"
else
    echo "Errhm, somethings wrong!"
fi

docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "curl -f -sS https://plugins.matomo.org/api/2.0/plugins/UserConsole/download/latest > /tmp/UserConsole.zip";
docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "unzip /tmp/UserConsole.zip -q -d /var/www/html/plugins -o";
docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console plugin:activate UserConsole";

echo "Reset password:"
if docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console user:reset-password --login=admin-test --new-password=\"mtmo@rocks\""; then
    echo "Password resetted!"
else
    echo "Errhm, somethings wrong!"
fi

echo "Dump prepped CI DB:"
docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysqldump -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} ${CI_DB_NAME} > ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"

echo "GZIP dump:"
docker-compose -f docker-compose-ci.yml exec db-ci bash -c "gzip -f ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"

echo "CP to host:"
docker-compose -f docker-compose-ci.yml cp db-ci:"${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}.gz" "./dumps/${CI_DB_DUMP_NAME}.gz" 

echo "Send to minio."
$MINIO_CLIENT --config-dir "${MINIO_CONFIG}" cp "./dumps/${CI_DB_DUMP_NAME}.gz" "minio/drone/mtmo/${CI_DB_DUMP_NAME}.gz"

echo "Done!"
