#!/bin/bash

set -e

radius=20
tiles=125

for x in $(seq -${radius} ${radius}); do
    for z in $(seq -${radius} ${radius}); do
        xo=$(( ${x} * ${tiles} * 16 ))
        zo=$(( ${z} * ${tiles} * 16 ))

        if [ ! -f ${tmpdir}/[${xo}_${zo}]world_biome.png ]; then
            if [[ ${xo} < 0 ]]; then
                tx="l$(( -${xo} ))"
            else
                tx="r${xo}"
            fi
            if [[ ${zo} < 0 ]]; then
                tz="u$(( -${zo} ))"
            else
                tz="d${zo}"
            fi
            cmd="tc map world -s ${tiles} -o ${xo} ${zo} -l ${tx} ${tz}"
            echo "mine> ${cmd}..."
            $(dirname $0)/rcon-do.sh ${cmd}
        fi
    done
done

sleep 60

tmpdir=$(dirname $0)/tmpimgs
rm -rf ${tmpdir}
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

echo "Moving images..."
mv $(dirname $(dirname $0))/*png ${tmpdir}/

size=$(( ${radius} * 2 + 1 ))
echo "Creating world_biome.png..."
${cmd1} -geometry +1+1 -background black -tile ${size}x ${tmpdir}/world_biome.png
echo "Creating world_temperature.png..."
${cmd2} -geometry +1+1 -background black -tile ${size}x ${tmpdir}/world_temperature.png

cp ${tmpdir}/world_*png ~/Yandex.Disk/Minecraft/
yandex-disk sync
