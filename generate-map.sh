#!/bin/bash

set -e

source `dirname $0`/realpath-mock.sh

radius=2
tiles=125

workdir=$(dirname $(realpath $(dirname $0)))
seed=$(grep "seed" ${workdir}/server.properties | cut -d '=' -f 2)
tmpdir=$(dirname $0)/tmpimgs/${seed}/${tiles}

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
            while $(dirname $0)/rcon-do.sh ${cmd} 2>&1 \
                | grep --ignore-case "error"; do
                sleep 5
                echo "retry> ${cmd}..."
            done

            while [[ ! -f ${workdir}/world_biome.png \
                || ! -f ${workdir}/world_temperature.png ]]; do
                sleep 1
            done
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

google-upload ${tmpdir}/world_*${seed}*png
