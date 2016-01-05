#!/bin/bash

set -e

radius=2
tiles=125

seed=$(grep "seed" server.properties | cut -d '=' -f 2)
tmpdir=$(dirname $0)/tmpimgs/${seed}/${tiles}
workdir=$(dirname $(dirname $0))
outdir=~/Yandex.Disk/Minecraft

mkdir -p ${tmpdir}
for x in $(seq -${radius} ${radius}); do
    for z in $(seq -${radius} ${radius}); do
        xo=$(( ${x} * ${tiles} * 16 ))
        zo=$(( ${z} * ${tiles} * 16 ))

        if [ ! -f ${tmpdir}/[${xo}_${zo}]world_biome.png ]; then
            rm -f ${workdir}/world_biome.png
            rm -f ${workdir}/world_temperature.png

            cmd="tc map world -s ${tiles} -o ${xo} ${zo}"
            echo "mine> ${cmd}..."
            $(dirname $0)/rcon-do.sh ${cmd}

            while [[ ! -f ${workdir}/world_biome.png \
                || ! -f ${workdir}/world_temperature.png ]]; do sleep 1; done
            mv ${workdir}/world_biome.png ${tmpdir}/[${xo}_${zo}]world_biome.png
            mv ${workdir}/world_temperature.png ${tmpdir}/[${xo}_${zo}]world_temperature.png
        fi
    done
done

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

size=$(( ${radius} * 2 + 1 ))
namesize=$(( ${tiles} * (${radius} * 16 + 8)))

echo "Creating world_biome.png..."
${cmd1} -geometry +1+1 -background black -tile ${size}x \
    ${tmpdir}/world_biome_${seed}_${namesize}x${namesize}.png
echo "Creating world_temperature.png..."
${cmd2} -geometry +1+1 -background black -tile ${size}x \
    ${tmpdir}/world_temperature_${seed}_${namesize}x${namesize}.png

mkdir -p ${outdir}
cp ${tmpdir}/world_*png ${outdir}
yandex-disk sync
