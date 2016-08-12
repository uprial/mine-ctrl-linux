#!/bin/bash

set -e

unset $MINE_VERSION
unset $SERVER_IP
unset $MEMORY_MAX
unset $MEMORY_START
unset $SERVER_ID
unset $JAR_FILE

source `dirname $0`/config.local.sh

check_var() {
    varname="$1"
    if [[ -z "${!varname}" ]]; then
        echo "ERROR: '${varname}' is empty'."
        exit 1
    fi
}

check_var "MINE_VERSION"
check_var "SERVER_IP"
check_var "MEMORY_MAX"
check_var "MEMORY_START"
check_var "SERVER_ID"
check_var "JAR_FILE"
