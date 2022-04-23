#!/bin/bash

set -ex

# shellcheck source=/dev/null
source ./scripts/check-env.sh

cd "${WORKSPACE_DIR}" || exit

# Delete old logs:
echo "Delete old logs"
DAYS_TO_KEEP=90
LAST_DATE=$(date -v "-${DAYS_TO_KEEP}d" "+%Y-%m-%d")
EARLIEST_DATE=2021-01-01
if ./console core:delete-logs-data -n --dates=${EARLIEST_DATE},"${LAST_DATE}"; then
    echo "Logs deleted."
else
    echo "Errhm, somethings wrong with: core:delete-logs-data"
    exit;
fi

# Disable dev:mode because it breaks archiving
./console development:disable

# Perform DB update
echo "Perform DB update"
./console core:update

echo "Run core:archive:"
start=$(date +%s)
if time ./console core:archive; then
    end=$(date +%s)
    runtime=$((end-start))
    echo "Archiving done in: ... $runtime"
else
    echo "Errhm, somethings wrong with: core:archive"
    exit;
fi

# Get UserConsole so we can reset PW for test-user
curl -f -sS https://plugins.matomo.org/api/2.0/plugins/UserConsole/download/latest > /tmp/UserConsole.zip
unzip /tmp/UserConsole.zip -q -d "${WORKSPACE_DIR}/plugins/UserConsole" -o;
./console plugin:activate UserConsole

echo "Reset password:"
if ./console user:reset-password --login="${CI_MTMO_USER}" --new-password="${CI_MTMO_PASS}"; then
    echo "Password resetted!"
else
    echo "Errhm, somethings wrong with: user:reset-password"
    exit;
fi

echo "Dump prepped CI DB:"
"mysqldump -u${CI_DB_USER} -p${CI_DB_PASS} -h${CI_DB_HOST} ${CI_DB_NAME} > ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"

echo "GZIP dump:"
"gzip -f ${CI_DB_DUMP_PATH}/${CI_DB_DUMP_NAME}"

echo "Send to minio."
$MINIO_CLIENT --config-dir "${MINIO_CONFIG}" cp "./dumps/${CI_DB_DUMP_NAME}.gz" "minio/drone/mtmo/${CI_DB_DUMP_NAME}.gz"

# Enable development mode again.
./console development:enable

echo "Done!"
