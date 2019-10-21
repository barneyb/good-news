#!/bin/bash
set -e

cd `dirname $0`
wc -l queue/*.txt

CHANNELS=`cat log.txt | cut -d ] -f 2 | cut -d ' ' -f 2 | sort -u`
TYPES=`cat log.txt | cut -d ] -f 2 | cut -d ' ' -f 3 | sort -u`

for c in $CHANNELS; do
  echo $c
  n=`cat log.txt | grep "\] $c " | wc -l`
  if [ $n -eq 0 ]; then
    continue
  fi
  echo " total: $n"
  for t in $TYPES; do
    n=`cat log.txt | grep "\] $c $t " | wc -l`
    if [ $n -eq 0 ]; then
      continue
    fi
    echo "  $t: $n"
  done
done
