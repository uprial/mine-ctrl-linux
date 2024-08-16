#!/bin/bash

set -e

source `dirname $0`/config.sh

if [ -f ./`dirname $0`/before-start.sh ]; then
    ./`dirname $0`/before-start.sh
fi

#Uncomment if 80 port is busy with httpd
#if which systemctl; then
#    systemctl stop httpd.service
#fi

echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ "${OSTYPE}" = darwin* || "${OSTYPE}" = linux-gnu ]]; then
    java_version=$(echo ${java_version} | cut -d'.' -f1)
else
    java_version=$(echo ${java_version} | cut -d'.' -f2)
fi
echo "Detected java version is ${java_version}..."
if [ -z "${java_version}" ]; then
    echo "ERROR: Java is not installed."
    exit 1
fi
if test ${java_version} -lt 21; then
    echo "ERROR: Java version is too old."
    exit 1
fi

#
# Please refer to https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
#
# My personal preferences are:
# -server
# -Djline.terminal=jline.UnsupportedTerminal
# -Djava.awt.headless=true
#

java -server \
    -Xmx${MEMORY_MAX} \
    -Xms${MEMORY_MAX} \
    -Djline.terminal=jline.UnsupportedTerminal \
    -Djava.awt.headless=true \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar "${JAR_FILE}" \
    nogui
