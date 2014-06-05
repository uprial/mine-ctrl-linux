#!/bin/bash

set -e

action="$1"

if [[ -z "${action}" ]]; then
    echo "ERROR: Empty action."
    exit 1
fi

`dirname $0`/mcrcon/mcrcon \
    -H 94.250.254.176 \
    -P 25576 \
    -p mine230886 \
    "${action}" || :
