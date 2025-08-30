#!/bin/bash

set -e

cd $(dirname $(dirname $(realpath $0)))

files=(logs/*gz)
if [ -e "${files[0]}" ]; then
    gzip -dc logs/*gz
fi

if [ -f "logs/latest.log" ]; then
    cat logs/latest.log
fi
