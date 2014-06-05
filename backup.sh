#!/bin/bash

set -e

`dirname $0`/save-server.sh

cd $(dirname $(dirname $(realpath $0)))
FILENAME="m0-`date +'%Y-%m-%d %H.%M.%S'`.tar.gz"

tar -zcf "${FILENAME}" \
    --exclude="crash-reports/*" \
    --exclude="logs/*" \
    --exclude="timings/*" \
    --exclude="server*tar.gz" \
    *
mv "${FILENAME}" /root/Yandex.Disk/Minecraft/
yandex-disk sync
