#!/bin/bash

# shellcheck source=/dev/null
source ./scripts/check-env.sh
source ./scripts/fetch-processed-local.sh

set -e

# Check if DB exists:
if mysql -u"${IMPORT_DB_USER}" -p"${IMPORT_DB_PASS}" -e"SHOW DATABASES" 2> /dev/null | grep "${IMPORT_DB_NAME}"; then
    # Delete DB:
    echo "This will wipe the DB: $IMPORT_DB_NAME"
    while true; do
    read -p "Are you sure? (y / n): " -r yn
    case $yn in
        [Yy]* )
            mysql -u"${IMPORT_DB_USER}" -p"${IMPORT_DB_PASS}" -e"DROP SCHEMA \`${IMPORT_DB_NAME}\`" 2> /dev/null
            break;;
        [Nn]* )
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
    done
fi

# Create Schema
CREATE="CREATE DATABASE \`${IMPORT_DB_NAME}\` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */"
mysql -u"${IMPORT_DB_USER}" -p"${IMPORT_DB_PASS}" -e"${CREATE}" 2> /dev/null

# Import DB
if [ -f "${IMPORT_DB_DUMP_PATH}/${IMPORT_DB_DUMP_NAME}" ]; then
    echo "Importing:"
    mysql -u"${IMPORT_DB_USER}" -p"${IMPORT_DB_PASS}" "${IMPORT_DB_NAME}" < "${IMPORT_DB_DUMP_PATH}/${IMPORT_DB_DUMP_NAME}"
    # 2> /dev/null
    # If you wanna surpress mysql warning
    # 2> /dev/null
    echo "Done."
else
    echo "Something went wrong."
    exit;
fi

