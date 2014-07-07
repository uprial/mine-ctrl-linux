#!/bin/bash

set -e

source `dirname $0`/config.sh

echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

java -server \
    -d64 \
    -XX:MaxPermSize=128m \
    -Xmx${MEMORY_MAX} \
    -Xms${MEMORY_START} \
    -Djline.terminal=jline.UnsupportedTerminal \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=100 \
    -Djava.awt.headless=true \
    -XX:ParallelGCThreads=2 \
    -XX:+AggressiveOpts \
    -jar "spigot-1.7.9-R0.3.jar" \
    nogui
