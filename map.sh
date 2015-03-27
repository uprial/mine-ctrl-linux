#!/bin/bash

set -e

radius=20
tiles=125
tmpdir=$(dirname $0)/tmpimgs/${tiles}
changed=0

for x in $(seq -${radius} ${radius}); do
    for z in $(seq -${radius} ${radius}); do
        xo=$(( ${x} * ${tiles} * 16 ))
        zo=$(( ${z} * ${tiles} * 16 ))

        if [ ! -f ${tmpdir}/[${xo}_${zo}]world_biome.png ]; then
            cmd="tc map world -s ${tiles} -o ${xo} ${zo}"
            echo "mine> ${cmd}..."
            $(dirname $0)/rcon-do.sh ${cmd}
            changed=1
        fi
    done
done

if [[ "${changed}" != 0 ]]; then
    sleep 60
fi

mkdir -p ${tmpdir}

cmd1="montage"
cmd2="montage"
for z in $(seq -${radius} ${radius}); do
    for x in $(seq -${radius} ${radius}); do
        xo=$(( ${x} * ${tiles} * 16 ))
        zo=$(( ${z} * ${tiles} * 16 ))

        cmd1="${cmd1} ${tmpdir}/[${xo}_${zo}]world_biome.png"
        cmd2="${cmd2} ${tmpdir}/[${xo}_${zo}]world_temperature.png"
    done
done

if [[ "${changed}" != 0 ]]; then
    echo "Moving images..."
    mv $(dirname $(dirname $0))/*png ${tmpdir}/
fi

size=$(( ${radius} * 2 + 1 ))
namesize=$(( ${tiles} * (${radius} * 16 + 8)))

echo "Creating world_biome.png..."
${cmd1} -geometry +1+1 -background black -tile ${size}x \
    ${tmpdir}/world_biome_${namesize}x${namesize}.png
echo "Creating world_temperature.png..."
${cmd2} -geometry +1+1 -background black -tile ${size}x \
    ${tmpdir}/world_temperature_${namesize}x${namesize}.png

cp ${tmpdir}/world_*png ~/Yandex.Disk/Minecraft/
yandex-disk sync
