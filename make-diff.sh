#!/bin/bash

set -e

source `dirname $0`/config.sh

CONTROL_DIR=$(dirname $(realpath $0))
cd $(dirname "${CONTROL_DIR}")

ORIG_PATH="clean-${MINE_VERSION}"

chk_path() {
	path="${1}"
	if [ ! -r "${path}" ]; then
		echo "ERROR: path ${path} does not exist"
		exit 2
	fi
}

gen_diff() {
	filename="${1}"
	filename_clear="${2}"
	diffname="${3}"

	if [[ "${filename}" == "server.properties" ]]; then
		${CONTROL_DIR}/cmp-server-properties.py \
			"${filename}" "${filename_clear}" | sort > "${diffname}"
	else
		if [[ -d "${filename}" ]]; then
			from="${filename}/"
			from=`echo "${from}" | sed -e 's/\//\\\\\//g'`
			diff -r "${filename_clear}" "${filename}" | sed -e "s/${from}//g" > "${diffname}"
		else
			diff "${filename_clear}" "${filename}" > "${diffname}"
		fi
	fi
}

#
# To remove all *.orig files please use the following command:
# $ find . -name '*.orig' -exec rm -rf {} \;
#
cmp() {
    filename="${1}"
    filename_clear="../${ORIG_PATH}/${filename}"
	chk_path "${filename}"
	chk_path "${filename_clear}"

	filename_orig="${filename_clear}.orig"
	if [ -f "${filename_orig}" ]; then
		if [[ ! -z `diff "${filename_clear}" "${filename_orig}"` ]]; then
			filename_clear="${filename_orig}"
			echo "WARNING: use original file from ${filename_clear}"
		fi
	fi

    diffname=`echo "${filename}" | sed -e 's/\//-/g'`
    diffname="diffs/${diffname}.diff"
    if [[ ! -z `diff  "${filename_clear}" "${filename}"` ]]; then
		gen_diff "${filename}" "${filename_clear}" "${diffname}"
		if [[ "${filename_clear}" != "${filename_orig}" ]]; then
			cp -r "${filename_clear}" "${filename_orig}"
		fi
    else
        rm -f "${diffname}"
    fi
}

mkdir -p diffs
rm -f diffs/*.diff

for path in $(cat "${CONTROL_DIR}/diff-list.txt"); do
	cmp "${path}"
done
