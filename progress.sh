#!/bin/bash

set -e

LINK="${1}"
N="${2:-100000}"

X=0
E=0

while test ${X} -lt ${N}; do
  echo -ne "${X} / ${N}, ${E} errors...       \r"


  if wget -O /dev/null ${LINK} 1>/dev/null 2>&1; then
    X=$((${X}+1))
  else
    E=$((${E}+1))
  fi

  sleep 1
done
echo "${X} / ${N} - DONE"
