#!/bin/bash

log_n_echo () {
    if [ -n "$2" ]; then
        echo "$2" | tee "${SCRIPT_LOGSFILE}"
    else
        echo "$1" | tee -a "${SCRIPT_LOGSFILE}"
    fi
}
