#!/bin/bash
set -e

F_HOOK=hook_url.txt
F_FEED=feed.txt
F_ARCHIVE=archive.txt
F_TEMP=temp.txt
F_LOG=log.txt

cd `dirname $0`

ITEM=`head -n 1 $F_FEED`
if [ "$ITEM" = "" ]; then
	echo "No items in feed"
	exit 1
fi

# send it to the web hook
HOOK=`head -n 1 $F_HOOK`
echo -n "[`date`] $ITEM " >> $F_LOG
curl -s -S -X POST -H 'Content-type: application/json' --data '{"text":"'$ITEM'"}' $HOOK >> $F_LOG
echo >> $F_LOG # curl doesn't add a newline for body-less 200

# record it in the archive
echo $ITEM >> $F_ARCHIVE

# remove it from the feed
tail -n +2 $F_FEED > $F_TEMP
mv $F_TEMP $F_FEED
