#!/bin/bash

set -e

workdir=$(dirname $0)
gamedir=$(dirname $(realpath ${workdir}))
PIDFILE=${workdir}/pidfile

if [ -z "${1}" -o -z "${2}" ]; then
    echo "Usage:"
    echo "$0 seed1 seedN"
    exit 2
fi


seed1="${1}"
seedN="${2}"

while [[ "${seed1}" -le "${seedN}" ]]; do
    echo "Generate map for seed #${seed1}..."

    sed -i "s/^level-seed=.*$/level-seed=${seed1}/" ${gamedir}/server.properties

    ${workdir}/clean-worlds.sh -y

    nohup ${workdir}/start-server.sh 1>${workdir}/console-${seed1}.log 2>&1 &
    pid=$!
    echo "${pid}" > "${PIDFILE}"

    sleep 60

    ${workdir}/generate-map.sh

    sleep 5

    kill -9 ${pid}

    sleep 5

    seed1=$((${seed1}+1))
done
