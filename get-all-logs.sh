#!/bin/bash

set -e

cd $(dirname $(dirname $(realpath $0)))

if [ -f "logs/*gz" ]; then
    gzip -dc logs/*gz
fi

if [ -f "logs/latest.log" ]; then
    cat logs/latest.log
fi
