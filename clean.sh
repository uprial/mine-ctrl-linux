#!/bin/bash

set -e

cd $(dirname $(dirname $(realpath $0)))

rm -f logs/*
rm -f timings/*
rm -f plugins/AuthMe/auths.db
rm -f plugins/CustomNukes/block-meta.txt
rm -f plugins/CustomNukes/repeater-task.txt
sed -i 's/authkey: /authkey: ''/g' plugins/EnjinMinecraftPlugin/config.yml
rm -rf plugins/WorldGuard/worlds
rm -f plugins/WorldBorder/config.yml
