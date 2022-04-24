#!/bin/bash

# shellcheck source=/dev/null
source ./scripts/check-env.sh

mc cp "${MINIO_BUCKET_PATH}/${DB_DUMP_NAME}.gz" "${IMPORT_DB_DUMP_PATH}/${DB_DUMP_NAME}.gz"
