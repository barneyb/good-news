#!/bin/bash
set -e

cd `dirname $0`
cd queue

declare -a QUEUES

echo "Select a queue from below (or exit and touch a new one)"
i=0
for fn in `ls *.txt`; do
  i=$((i+1))
  QUEUES[$i]=$fn
  echo "  $i) $fn (`wc -l $fn | cut -d ' ' -f 1`)"
done

q="glerg"
until [ "$q" -ge 1 -a "$q" -le $i ] 2>/dev/null; do
  echo -n "Queue (1-$i, 'q' to quit): "
  read q
  if [ "$q" = "q" ]; then
    exit 0
  fi
done

echo
echo "Adding to '${QUEUES[$q]}'; hit Ctrl-D when done..."
cp ${QUEUES[$q]} ${QUEUES[$q]}.bak
cat >> ${QUEUES[$q]}
sort -u -o ${QUEUES[$q]} ${QUEUES[$q]}
echo Done!
wc -l *.txt

