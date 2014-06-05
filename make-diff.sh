#!/bin/bash

cd $(dirname $(dirname $(realpath $0)))

cmp() {
    filename="$1"
    filename_orig="../minecraft-clear/${filename}"
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

rm -rf diffs
mkdir diffs

cmp bukkit.yml
cmp server.properties
cmp spigot.yml
cmp plugins/AuthMe/config.yml
cmp plugins/CraftBook/config.yml
cmp plugins/CustomNukes/config.yml
cmp plugins/HealthBar/config.yml
cmp plugins/PermissionsEx/permissions.yml
cmp plugins/TerrainControl/TerrainControl.ini
cmp plugins/TerrainControl/worlds/world/WorldConfig.ini
cmp plugins/TerrainControl/worlds/world/WorldBiomes
cmp plugins/WorldBorder/config.yml
cmp plugins/WorldEdit/config.yml
cmp plugins/WorldGuard/config.yml
