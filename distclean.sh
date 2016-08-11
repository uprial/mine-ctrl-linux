#!/bin/bash

set -e

source `dirname $0`/config.sh

echo "ACCESS DENIED"
exit 1

cd $(dirname $(dirname $(realpath $0)))

for dir in $(ls \
	| grep -v "^${JAR_FILE}$" \
	| grep -v "^ctrl-linux$" \
	| grep -v "^ctrl-windows$" \
	| grep -v "^plugins$"); do
	rm -rf ./${dir}
done

for dir in $(ls plugins); do
	dir="plugins/${dir}"
	if [ -d ${dir} ]; then
		rm -rf ./${dir}
	fi
done
