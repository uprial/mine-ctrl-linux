#!/bin/bash

set -e

FILE_SIZE_LIMIT="1G"
FILE_COUNT_LIMIT=50

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
    --exclude="diffs/*" \
    --exclude="${SERVER_ID}*tar.gz" \
    * || echo "tar ERROR"
cd - > /dev/null

split -b ${FILE_SIZE_LIMIT} -d ${FILEPATH}/${FILENAME} ${FILEPATH}/${FILENAME}-part-

yandex-upload ${FILEPATH}/${FILENAME}-part-*
yandex-disk start

YDP=$(yandex-path)

COUNT=$(ls ${YDP}${SERVER_ID}-*-part-* | wc -l)

if [ ${COUNT} -gt ${FILE_COUNT_LIMIT} ]; then
    REMOVE_COUNT=$(expr ${COUNT} - ${FILE_COUNT_LIMIT})
    echo "File limit of ${FILE_COUNT_LIMIT} exceeded, cleaning up ${REMOVE_COUNT} files..."
    for i in $(seq 1 ${REMOVE_COUNT}); do
        REMOVE_FILENAME=$(ls ${YDP}${SERVER_ID}-* | head -1)
        echo "Removing ${REMOVE_FILENAME}..."
        rm ${REMOVE_FILENAME}
    done
fi
