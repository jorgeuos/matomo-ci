#!/bin/bash


# shellcheck source=/dev/null
source ./scripts/check-env.sh

# Defaults Env variables are fetched from ../check-env.sh

# We don't need DATE right now, we overwrite existing one every day.
# DATE="$(date +%F)"

rm ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null
rm ${DB_DUMP_PATH}/${DB_DUMP_NAME}.gz 2> /dev/null

# Examples of mysqldump usage:
# mysqldump -h 1.1.1.1 -u root -p --no-data dbname > ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null
# mysqldump --no-data ${DB_TO_DUMP} > ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null

# Explained:
# mysqldump							The command `mysqldump`
# -u${DB_USER}						The user we are using
# -p${DB_PASSWORD}					User password
# -h"${DB_HOST}"						Host to DB
# --no-data							Dump without data
# ${DB_TO_DUMP}						DB name we want to dump
# >									Write to a file
# >>								Append to a file
# ${DB_DUMP_PATH}/${DB_DUMP_NAME}	Path and filename for the dump
# 2> /dev/null						Supress warnings to /dev/null

#1/6:
echo "#1/6: Dump all without data."
# mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" --no-data ${DB_TO_DUMP} > ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null
mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" --no-data ${DB_TO_DUMP} > ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null

# Tables we don't need everything from, but some tables we might need something from.
IGNORE_TABLES_ALT="'matomo_user','matomo_user_dashboard','matomo_user_language','matomo_log_hsr_blob','matomo_logger_message','matomo_log_hsr_event','matomo_access','matomo_activity_log','matomo_alert','matomo_alert_site','matomo_alert_triggered','matomo_brute_force_log','matomo_site_form','matomo_log_form','matomo_log_form_field','matomo_log_form_page','matomo_queuedtracking_queue','matomo_report_subscriptions','matomo_session','matomo_sequence'"

echo "#2/6: Dump all essentials"
# SELECT All essentials
# 
TABLES_WITH_IDSITE=$(cat << EOF
SET group_concat_max_len = 10240;
SELECT DISTINCT GROUP_CONCAT(table_name separator ' ')
FROM
	information_schema.columns
WHERE
	table_name NOT LIKE "matomo_archive_numeric_%"
	AND table_name NOT LIKE "matomo_archive_blob_%"
	AND column_name IN('idsite')
	AND table_schema = '${DB_TO_DUMP}';
EOF
)
TBLIST=$(mysql -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" -AN -e"${TABLES_WITH_IDSITE}")

# Ignore TBLIST word splitting, this is what we want.
# mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" ${DB_TO_DUMP} $TBLIST --where='idsite=1' >> ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null
mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" ${DB_TO_DUMP} $TBLIST --where='idsite=1' >> ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null

old_IFS=$IFS
IFS="','"
TBLIST_WITH_COMMAS="${TBLIST[*]}"
IFS=${old_IFS}

# 3
echo "#3/6: Dump all complementary, that doesnt have siteid column"
SQL="SET group_concat_max_len = 10240;"
SQL="$SQL SELECT GROUP_CONCAT(table_name separator ' ')"
SQL="$SQL FROM information_schema.tables"
SQL="$SQL WHERE table_schema='${DB_TO_DUMP}'"
SQL="$SQL AND table_name NOT LIKE \"matomo_archive_numeric_%\""
SQL="$SQL AND table_name NOT LIKE \"matomo_archive_blob_%\""
SQL="$SQL AND table_name NOT IN('${TBLIST_WITH_COMMAS}')"
SQL="$SQL AND table_name NOT IN (${IGNORE_TABLES_ALT});"
TBLIST=$(mysql -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" -AN -e"${SQL}")

# Ignore TBLIST word splitting, this is what we want.
# mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" ${DB_TO_DUMP} ${TBLIST} >> ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null
mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" ${DB_TO_DUMP} ${TBLIST} >> ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null

echo "#4/6: Dump test user only."
# Get just the user we need for testing
# mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" ${DB_TO_DUMP} matomo_user --where="login='admin-test'" matomo_user_dashboard --where="login='admin-test'" matomo_user_language --where="login='admin-test'" >> ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null
mysqldump -u${DB_USER} -p${DB_PASSWORD} -h"${DB_HOST}" ${DB_TO_DUMP} matomo_user --where="login='admin-test'" matomo_user_dashboard --where="login='admin-test'" matomo_user_language --where="login='admin-test'" >> ${DB_DUMP_PATH}/${DB_DUMP_NAME} 2> /dev/null

echo "#5/6: GZIP dump."
gzip -f ${DB_DUMP_PATH}/${DB_DUMP_NAME}

echo "#6/6: Send to minio."
$MINIO_CLIENT --config-dir ${MINIO_CONFIG} cp ${DB_DUMP_PATH}/${DB_DUMP_NAME}.gz backup-stage/drone/mtmo/${DB_DUMP_NAME}.gz

echo "Done!"
echo "Remember to run:"
echo "./console user:reset-password --login=admin-test --new-password=\"mtmo@rocks\""
echo "after import."


