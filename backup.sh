#!/bin/bash

set -e

`dirname $0`/save-server.sh
sleep 5

source `dirname $0`/config.sh

set -x
cd $(dirname $(dirname $(realpath $0)))
FILENAME="${SERVER_ID}-`date +'%Y-%m-%d_%H.%M.%S'`.tar.gz"

tar -zcf "${FILENAME}" \
    --exclude="crash-reports/*" \
    --exclude="logs/*" \
    --exclude="timings/*" \
    --exclude="diffs/*" \
    --exclude="${SERVER_ID}*tar.gz" \
    *

mv "${FILENAME}" /root/Yandex.Disk/Minecraft/
sleep 5
yandex-disk sync
