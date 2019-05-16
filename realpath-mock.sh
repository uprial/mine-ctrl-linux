#!/bin/bash

set -e

if ! which realpath; then
	realpath() {
		[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
	}
fi
