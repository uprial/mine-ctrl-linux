#!/bin/bash

set -e

X=0
N=10

while test ${X} -lt ${N}; do
  echo -ne "${X} / ${N}...       \r"
  X=$((${X}+1))
  sleep 1
done
echo "${X} / ${N} - DONE"
