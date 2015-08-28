#!/bin/bash

set -e

source `dirname $0`/config.sh

VERSION="spigot-1.8.8.jar"
echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

# Work only in Java7:
# -XX:MaxPermSize=128m
java -server \
    -d64 \
    -Xmx${MEMORY_MAX} \
    -Xms${MEMORY_START} \
    -Djline.terminal=jline.UnsupportedTerminal \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=100 \
    -Djava.awt.headless=true \
    -XX:ParallelGCThreads=2 \
    -XX:+AggressiveOpts \
    -jar "${VERSION}" \
    nogui
