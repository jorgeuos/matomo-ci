#!/bin/bash

set -ex

# shellcheck source=/dev/null
source ./scripts/check-env.sh

DOCKER_COMPOSE_DIR=${SCRIPT_DIR}/../

cd "${DOCKER_COMPOSE_DIR}" || exit

CI_DUMP=./dumps/matomo-ci.sql
if [[ -f $CI_DUMP ]]; then
    echo "We have dump!"
elif [[ -f $CI_DUMP/.gz ]]; then
    echo "We have gzip file!"
    gunzip $CI_DUMP.gz
else
    echo "No file, fetching from bucket."
    mc cp minio/drone/mtmo/matomo-ci.sql.gz $CI_DUMP.gz
    gunzip $CI_DUMP.gz
fi

docker-compose -f ./docker-compose-ci.yml up -d

while ! docker-compose -f docker-compose-ci.yml exec matomo-ci ./console core:version ; do sleep 1; done
# while ! docker-compose -f docker-compose-ci.yml exec matomo-ci ls -lah ./ ; do sleep 1; done

# SQL="SHOW FULL PROCESSLIST;"
SQL="SHOW DATABASES;"

# More reliable way of determin DB host
# CI_DB_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db-ci)
# export CI_DB_HOST

while ! docker-compose -f docker-compose-ci.yml exec db-ci mysql -u"${CI_DB_USER}" -p"${CI_DB_PASS}" -h"${CI_DB_HOST}" -AN -e"${SQL}" ; do sleep 1; done

# Do Import
# docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} 'matomo-ci' < /docker-entrypoint-initdb.d/99-matomo-ci.sql"

if docker-compose -f docker-compose-ci.yml exec db-ci bash -c "mysql -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} -AN -e\"USE 'matomo-ci'; SHOW TABLES;\""; then
    echo "We're up!"
else
    echo "No tables, can't proceed!"
fi

# Perform DB update
docker-compose -f docker-compose-ci.yml exec matomo-ci ./console core:update

# Delete old logs:
echo "Delete old logs"
LAST_DATE=$(date -v "-30d" "+%Y-%m-%d")
EARLIEST_DATE=2021-08-12
if docker-compose -f docker-compose-ci.yml exec matomo-ci bash -c "./console core:delete-logs-data -n --dates=${EARLIEST_DATE},${LAST_DATE}"; then
    echo "Logs deleted, commence archiving."
else
    echo "Errhm, somethings wrong!"
fi

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
