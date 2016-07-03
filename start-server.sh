#!/bin/bash

set -e

source `dirname $0`/config.sh

if [ -f ./`dirname $0`/before-start.sh ]; then
    ./`dirname $0`/before-start.sh
fi

VERSION="spigot-1.8.8.jar"
echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

OPTS=""
if ! java -version 2>&1 | grep 1.8; then
  OPTS="${OPTS} -XX:MaxPermSize=128m"
fi

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
    ${OPTS} \
    -jar "${VERSION}" \
    nogui
