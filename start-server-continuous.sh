#!/bin/bash

set -e

WAIT_TIME=10
while true; do
    `dirname $0`/start-server.sh || :
    echo "`date`" >> /var/log/crashes
    echo ""
    echo ""
    echo "Waiting for ${WAIT_TIME} seconds before restart..."
    sleep ${WAIT_TIME}
done
