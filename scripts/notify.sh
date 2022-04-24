#!/bin/bash

set -e
SCRIPT_START=$(date +%s)


# shellcheck source=/dev/null
source ./scripts/check-env.sh

DOCKER_COMPOSE_DIR=${SCRIPT_DIR}/../

cd "${DOCKER_COMPOSE_DIR}" || exit

# $(cat "${SCRIPT_LOGSFILE}")
notify_slack(){
    SLACK_MESSAGE="${1}"
    curl -0 -v -X POST "https://hooks.slack.com/services/$SLACK_T000/$SLACK_B000/$SLACK_TOKEN" \
    -H 'Content-Type: application/json; charset=utf-8' \
    --data-binary @- << EOF
{
    "channel":"${SLACK_CHANNEL}",
    "icon_emoji":"${SLACK_EMOJI}",
    "username":"${SLACK_USER}",
    "text":"${SLACK_MESSAGE}"
}
EOF
}
