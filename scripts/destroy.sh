#!/bin/bash

# shellcheck source=/dev/null
source ./scripts/check-env.sh

DOCKER_COMPOSE_DIR=${SCRIPT_DIR}/../

cd "${DOCKER_COMPOSE_DIR}" || exit

docker-compose -f docker-compose-ci.yml down --remove-orphans

docker system prune -a -f
docker system prune --volumes -f

rm -f ./dumps/matomo-ci.sql
rm -f ./dumps/matomo-ci.sql.gz
