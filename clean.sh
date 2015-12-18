#!/bin/bash

set -e

echo "ACCESS DENIED"
exit 1

cd $(dirname $(dirname $(realpath $0)))

rm -rf world
rm -rf world_nether
rm -rf world_the_end
rm -rf plugins/dynmap/web/tiles/world/*
rm -f crash-reports/*
rm -f logs/*
rm -f plugins/CustomNukes/block-meta.txt
rm -f plugins/CustomNukes/repeater-task.txt
rm -rf plugins/WorldGuard/worlds
