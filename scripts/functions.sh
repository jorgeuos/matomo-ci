#!/bin/bash

log_n_echo () {
    STR=$1
    SUB="Step"
    if [[ "$STR" == *"$SUB"* ]]; then
        STR="############## $1 ##############"
    fi

    if [ "$2" = "new" ]; then
        echo "$STR" | tee "${SCRIPT_LOGSFILE}"
    elif [ "$2" = "skip" ]; then
        SKIP=$STR
        echo "$STR" | tee -a "${SCRIPT_LOGSFILE}"
    else
        echo "$STR" | tee -a "${SCRIPT_LOGSFILE}"
    fi
}


STEPS=$(while IFS= read -r i; do echo "${i%?}"; done < ./scripts/prep-ci-db.sh | grep -o 'step_or_skip' | wc -l | tr -d '[:space:]')
STEP=1
step_or_skip () {
    if [ "${SKIP}" = false ]; then
        log_n_echo "Step $((STEP++))/${STEPS}."
        return
    fi
    false
}