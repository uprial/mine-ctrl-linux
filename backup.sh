#!/bin/bash

set -e

SRCPATH=$(dirname $(realpath $0))
source ${SRCPATH}/config.sh

FILENAME="${SERVER_ID}-`date +'%Y-%m-%d_%H.%M.%S'`.tar.gz"
FILEPATH=$(dirname ${SRCPATH})

rcon_do() {
    ${SRCPATH}/rcon-do.sh "$@"
}

cleanup() {
    rcon_do bluemap start
    rm -f ${FILEPATH}/${FILENAME}
    rm -f ${FILEPATH}/${FILENAME}-part-*
}
trap cleanup EXIT SIGINT

rcon_do save-all
rcon_do bluemap stop

sleep 5

set -x

cd ${FILEPATH}
tar -zcf "${FILENAME}" \
    --exclude="bluemap/web" \
    --exclude="crash-reports/*" \
    --exclude="logs/*" \
    --exclude="diffs/*" \
    --exclude="${SERVER_ID}*tar.gz" \
    *
cd - > /dev/null

split -b 1G -d ${FILEPATH}/${FILENAME} ${FILEPATH}/${FILENAME}-part-

yandex-upload ${FILEPATH}/${FILENAME}-part-*
yandex-disk start
