#!/bin/bash

set -e

echo "Starting bukkit minecraft server..."

cd $(dirname $(dirname $(realpath $0)))

java -server \
    -d64 \
    -XX:MaxPermSize=128m \
    -Xmx700M \
    -Xms300M \
    -Djline.terminal=jline.UnsupportedTerminal \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=100 \
    -Djava.awt.headless=true \
    -XX:ParallelGCThreads=2 \
    -XX:+AggressiveOpts \
    -jar "spigot-1.7.9-R0.2.jar" \
    nogui
