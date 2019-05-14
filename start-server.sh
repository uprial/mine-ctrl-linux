#!/bin/bash

set -e

source `dirname $0`/config.sh

if [ -f ./`dirname $0`/before-start.sh ]; then
    ./`dirname $0`/before-start.sh
fi

echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

OPTS=""

java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
echo "Detected java version is ${java_version}..."
if test ${java_version} -lt 6; then
    echo "ERROR: Java version is too old."
    exit 1
fi
if test ${java_version} -lt 8; then
    OPTS="${OPTS} -XX:MaxPermSize=128m"
fi
if test ${java_version} -lt 10; then
    OPTS="${OPTS} -d64"
fi

java -server \
    -Xmx${MEMORY_MAX} \
    -Xms${MEMORY_START} \
    -Djline.terminal=jline.UnsupportedTerminal \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=100 \
    -Djava.awt.headless=true \
    -XX:ParallelGCThreads=2 \
    -XX:+AggressiveOpts \
    ${OPTS} \
    -jar "${JAR_FILE}" \
    nogui
