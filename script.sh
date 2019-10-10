#!/bin/bash
set -e
cd `dirname $0`

F_HOOK=hook_url.txt
F_FEED=feed.txt
F_TEMP=temp.txt
F_LOG=log.txt
F_IMAGES=images.txt

CHANNEL="$2"
if [ "$CHANNEL" = "" ]; then
	CHANNEL="#brennas-news-feed"
fi
HOOK=`grep $CHANNEL $F_HOOK | cut -d ' ' -f 2`
if [ "$HOOK" = "" ]; then
	echo "Invalid channel spec: '$CHANNEL'"
	exit 2
fi

if [ "$1" = "--feed" ]; then
	ITEM=`head -n 1 $F_FEED`
	if [ "$ITEM" = "" ]; then
		echo "No items in feed"
		exit 1
	fi
	
	# send it to the web hook
	echo -n "[`date`] F $ITEM " >> $F_LOG
	curl -s -S -X POST -H 'Content-type: application/json' --data '{"text":"<'$ITEM'>","unfurl_links":true,"unfurl_media":true}' $HOOK >> $F_LOG
	echo >> $F_LOG # curl doesn't add a newline for body-less 200
	
	# remove it from the feed
	tail -n +2 $F_FEED > $F_TEMP
	mv $F_TEMP $F_FEED
	
	# see if the feed is low
	N=`cat $F_FEED | wc -l`
	if [ "$N" -lt 5 ]; then
		date
		echo
		echo "Items in Good News feed: $N"
		echo
		echo "Need to go find some more, yo."
	fi
elif [ "$1" = "--image" ]; then
	N=`cat $F_IMAGES | wc -l`
	if [ "$N" -eq 0 ]; then
		echo "No images are queued..."
		exit 1
	fi
	I=$((RANDOM % N + 1))
	ITEM=`head -n $I $F_IMAGES | tail -n 1`
	
	# send it to the web hook
	echo -n "[`date`] I $ITEM " >> $F_LOG
	curl -s -S -X POST -H 'Content-type: application/json' --data '{"blocks":[{"type":"image","title":{"type":"plain_text","text":"image'$I'"},"image_url":"'$ITEM'","alt_text":"image'$I'"}]}' $HOOK >> $F_LOG
	echo >> $F_LOG # curl doesn't add a newline for body-less 200

	# remove it from the queue
	head -n $((I - 1)) $F_IMAGES > $F_TEMP
	tail -n +$((I + 1)) $F_IMAGES >> $F_TEMP
	mv $F_TEMP $F_IMAGES
else
	echo "Usage: `basename $0` [ --feed | --image ]"
	exit 2
fi


