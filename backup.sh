#!/bin/bash

set -e

`dirname $0`/save-server.sh

cd $(dirname $(dirname $(realpath $0)))
FILENAME="${SERVER_NAME}-`date +'%Y-%m-%d_%H.%M.%S'`.tar.gz"

tar -zcf "${FILENAME}" \
    --exclude="crash-reports/*" \
    --exclude="logs/*" \
    --exclude="timings/*" \
    --exclude="server*tar.gz" \
    *
mv "${FILENAME}" /root/Yandex.Disk/Minecraft/
yandex-disk sync
