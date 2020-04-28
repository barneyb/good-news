#!/bin/bash
set -e
cd `dirname $0`

F_HOOK=hook_urls.txt
F_TEMP=temp.txt
F_LOG=log.txt

function usage() {
	echo "Usage: `basename $0` <channel> ( --link | --image ) <queue_file>"
}

function remove_line() {
	file=$1
	i=$2
	head -n $((i - 1)) $file > $F_TEMP
	tail -n +$((i + 1)) $file >> $F_TEMP
	mv $F_TEMP $file
}

CHANNEL="$1"
if [ "$CHANNEL" = "" ]; then
	CHANNEL="#brennas-news-feed"
fi

HOOK=`grep $CHANNEL $F_HOOK | cut -d ' ' -f 2`
if [ "$HOOK" = "" ]; then
	echo "Invalid channel spec: '$CHANNEL'"
	usage
	exit 2
fi

CMD="$2"
if [ "$CMD" != "--link" -a "$CMD" != "--image" ]; then
	echo "Unrecognized processor '$2'"
	usage
	exit 2
fi
CMD=`echo $CMD | cut -c 3-`

FILE=$3
if [ "$FILE" = "" -o ! -f $FILE ]; then
	echo "Unknown '$FILE' queue file"
	usage
	exit 2
fi

while true; do
	N=`cat $FILE | wc -l`
	if [ "$N" -eq 0 ]; then
	    exit 1
	fi

	I=$((RANDOM % N + 1))
	ITEM=`head -n $I $FILE | tail -n 1`
	if [ "$ITEM" = "" ]; then
		echo "No items in feed?"
		exit 1
	fi
	if curl --silent --head --location --output /dev/null --write-out '%{http_code}' $ITEM | grep '^2' > /dev/null; then
		break
	fi
	echo "[`date`] $CHANNEL $CMD $ITEM reject" >> $F_LOG
	remove_line $FILE $I
done

echo -n "[`date`] $CHANNEL $CMD $ITEM " >> $F_LOG
if [ "$CMD" = "link" ]; then
	curl -s -S -X POST -H 'Content-type: application/json' --data '{"text":"<'$ITEM'>","unfurl_links":true,"unfurl_media":true}' $HOOK >> $F_LOG
elif [ "$CMD" = "image" ]; then
	curl -s -S -X POST -H 'Content-type: application/json' --data '{"text":"image'$I'","blocks":[{"type":"image","title":{"type":"plain_text","text":"image'$I'"},"image_url":"'$ITEM'","alt_text":"image'$I'"}]}' $HOOK >> $F_LOG
else
	echo "Unknown '$CMD' command?!"
	exit 3
fi
echo >> $F_LOG # curl doesn't add a newline for body-less 200

remove_line $FILE $I

# see if the feed is low
if [ "$N" -lt 5 ]; then
	date
	echo
	echo "Items in '$FILE' feed: $N"
	echo
	echo "Need to go find some more, yo."
fi
