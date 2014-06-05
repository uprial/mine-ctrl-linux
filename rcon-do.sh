#!/bin/bash

set -e

source `dirname $0`/config.sh

action="$1"

if [[ -z "${action}" ]]; then
    echo "ERROR: Empty action."
    exit 1
fi

`dirname $0`/mcrcon/mcrcon \
    -H ${SERVER_IP} \
    -P 25575 \
    -p mine230886 \
    "${action}" || :
