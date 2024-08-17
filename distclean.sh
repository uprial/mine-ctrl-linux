#!/bin/bash

set -e

source `dirname $0`/config.sh

echo "ACCESS DENIED"
exit 1

cd $(dirname $(dirname $(realpath $0)))

for dir in $(ls \
	| grep -v "^${JAR_FILE}$" \
	| grep -v "^ctrl-linux$" \
	| grep -v "^plugins$"); do
	rm -rf ./${dir}
done

LPED=plugins/LuckPerms/extensions/
if [ -f ${LPED}extension-legacy-api* ]; then
    mv ${LPED}extension-legacy-api* .
fi

for dir in $(ls plugins); do
	dir="plugins/${dir}"
	if [ -d ${dir} ]; then
		rm -rf ./${dir}
	fi
done

if [ -f extension-legacy-api* ]; then
    mkdir -p ${LPED}
    mv extension-legacy-api* ${LPED}
fi
