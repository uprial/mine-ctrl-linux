#!/bin/bash

set -e

#echo "ACCESS DENIED"
#exit 1

cd $(dirname $(dirname $(realpath $0)))

#rm -rf world
#rm -rf world_nether
#rm -rf world_the_end
rm -f crash-reports/*
rm -f logs/*
#rm -f timings/*
#rm -f plugins/CustomNukes/block-meta.txt
#rm -f plugins/CustomNukes/repeater-task.txt
#sed -i 's/authkey: /authkey: ''/g' plugins/EnjinMinecraftPlugin/config.yml
#rm -rf plugins/WorldGuard/worlds
#rm -f plugins/WorldBorder/config.yml
