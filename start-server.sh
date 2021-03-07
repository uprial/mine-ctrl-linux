#!/bin/bash

set -e

source `dirname $0`/config.sh

if [ -f ./`dirname $0`/before-start.sh ]; then
    ./`dirname $0`/before-start.sh
fi

#Uncomment is 80 port is busy with httpd
#if which systemctl; then
#    systemctl stop httpd.service
#fi

echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

OPTS=""

java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ "${OSTYPE}" = darwin* ]]; then
    java_version=$(echo ${java_version} | cut -d'.' -f1)
else
    java_version=$(echo ${java_version} | cut -d'.' -f2)
fi
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

# Please refer to https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
java -server \
    -Xmx${MEMORY_MAX} \
    -Xms${MEMORY_MAX} \
    -Djline.terminal=jline.UnsupportedTerminal \
    -XX:+UseG1GC \
    -XX:+UnlockExperimentalVMOptions \
    -XX:MaxGCPauseMillis=100 \
    -XX:+DisableExplicitGC \
    -XX:TargetSurvivorRatio=90 \
    -XX:G1NewSizePercent=50 \
    -XX:G1MaxNewSizePercent=80 \
    -XX:G1MixedGCLiveThresholdPercent=35 \
    -XX:+AlwaysPreTouch \
    -XX:+ParallelRefProcEnabled \
    -Dusing.aikars.flags=mcflags.emc.gs \
    -Djava.awt.headless=true \
    ${OPTS} \
    -jar "${JAR_FILE}" \
    nogui
