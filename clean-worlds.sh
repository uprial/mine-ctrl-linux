#!/bin/bash

set -e

echo "ACCESS DENIED"
exit 1

cd $(dirname $(dirname $(realpath $0)))

rm -rf \
    world \
    world_nether \
    world_the_end \
    world_herobrine_graveyard \
    plugins/dynmap/web/tiles/world/* \
    plugins/WorldGuard/worlds

rm -f \
    crash-reports/* \
    logs/* \
    plugins/CustomNukes/block-meta.txt \
    plugins/CustomNukes/repeater-task.txt \
    usercache.json
