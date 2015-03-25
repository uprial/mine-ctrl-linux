#!/bin/bash

set -e

radius=1
tiles=100

for x in $(seq -${radius} ${radius}); do
    for z in $(seq -${radius} ${radius}); do
        xo=$(( ${x} * ${tiles} * 16 ))
        zo=$(( ${z} * ${tiles} * 16 ))
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
        $(dirname $0)/rcon-do.sh \
            tc map world -s ${tiles} -o ${xo} ${zo} -l ${tx} ${tz}
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

mv $(dirname $(dirname $0))/*png ${tmpdir}/

size=$(( ${radius} * 2 + 1 ))
${cmd1} -geometry +0+0 -tile ${size}x ${tmpdir}/world_biome.png
${cmd2} -geometry +0+0 -tile ${size}x ${tmpdir}/world_temperature.png
