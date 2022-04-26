#!/bin/bash

# shellcheck source=/dev/null
source ./scripts/check-env.sh

fetch_dump(){
    DUMP_TO_FETCH=$1

    # echo "$MINIO_CLIENT --config-dir ${MINIO_CONFIG} cp ${MINIO_BUCKET_PATH}/${DUMP_TO_FETCH}.gz ${IMPORT_DB_DUMP_PATH}/${DUMP_TO_FETCH}.gz"
    $MINIO_CLIENT --config-dir "${MINIO_CONFIG}" cp "${MINIO_BUCKET_PATH}/${DUMP_TO_FETCH}.gz" "${IMPORT_DB_DUMP_PATH}/${DUMP_TO_FETCH}.gz"
}
