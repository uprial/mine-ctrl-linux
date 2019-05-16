#!/bin/bash

set -e

source `dirname $0`/config.sh

curl \
	-o BuildTools.jar \
	https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

java -jar BuildTools.jar --rev ${MINE_VERSION}

rm -rf \
	apache-maven-* \
	BuildData \
	Bukkit \
	CraftBukkit \
	Spigot \
	work

rm -f \
	BuildTools.jar \
	BuildTools.log.txt \
	craftbukkit-*.jar
