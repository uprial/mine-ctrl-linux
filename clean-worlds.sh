#!/bin/bash

set -e

source `dirname $0`/realpath-mock.sh

if [[ "${1}" != "-y" ]]; then
    read -p "Do you really want to remove all the generated data? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "ACCESS DENIED"
        exit 1
    fi
fi

cd $(dirname $(dirname $(realpath $0)))

rm -rf \
    bluemap/web \
    world \
    world_nether \
    world_the_end \
    plugins/WorldGuard/worlds

rm -f \
    crash-reports/* \
    logs/* \
    plugins/CustomNukes/block-meta.txt \
    plugins/CustomNukes/repeater-task.txt \
    usercache.json
