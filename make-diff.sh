#!/bin/bash

cd $(dirname $(dirname $(realpath $0)))

ORIG_PATH="minecraft-clear"

cmp() {
    filename="$1"
    filename_orig="../${ORIG_PATH}/${filename}"
    diffname=`echo ${filename} | sed -e 's/\//-/g'`
    diffname="diffs/${diffname,,}.diff"
    if [[ ! -z `diff  "${filename_orig}" "${filename}"` ]]; then
        if [[ -d "${filename}" ]]; then
            from="${filename}/"
            from=`echo "${from}" | sed -e 's/\//\\\\\//g'`
            diff  "${filename_orig}" "${filename}" | sed -e "s/${from}//g" > "${diffname}"
        else
            diff  "${filename_orig}" "${filename}" > "${diffname}"
        fi
    else
        rm -f "${diffname}"
    fi
}

mkdir -p diffs
rm -f diffs/*.diff

cmp bukkit.yml
cmp commands.yml
cmp spigot.yml
cmp server.properties
cmp plugins/CraftBook/config.yml
cmp plugins/CraftBook/mechanisms.yml
cmp plugins/CustomDamage/config.yml
cmp plugins/CustomNukes/config.yml
cmp plugins/dynmap/configuration.txt
cmp plugins/dynmap-mobs/config.yml
cmp plugins/dynmap/shaders.txt
cmp plugins/Dynmap-WorldGuard/config.yml
cmp plugins/dynmap/worlds.txt
cmp plugins/HealthBar/config.yml
cmp plugins/Herobrine/config.yml
cmp plugins/Herobrine/npc.yml
cmp plugins/PermissionsEx/config.yml
cmp plugins/PermissionsEx/permissions.yml
cmp plugins/TerrainControl/TerrainControl.ini
cmp plugins/TerrainControl/worlds/world/WorldBiomes
cmp plugins/TerrainControl/worlds/world/WorldConfig.ini
cmp plugins/Vault/config.yml
cmp plugins/WorldBorder/config.yml
cmp plugins/WorldEdit/config.yml
cmp plugins/WorldGuard/config.yml
cmp plugins/xAuth/config.yml
