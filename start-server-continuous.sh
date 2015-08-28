#!/bin/bash

set -e

while true; do
    `dirname $0`/start-server.sh || :
    echo "`date`" >> /var/log/crashes
    echo ""
    echo ""
    sleep 30
done
