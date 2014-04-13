#!/bin/sh

self=`readlink -f "$0"`
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

. $scriptdir/config
. $nlogrotatepath/redirectlog.src.sh

if [ "$1" = "quiet" ]; then
	quietmode=1
	redirectlog
fi

# Appending "-snd" to the log file name to distinct it from camcapure.sh's log.
logfile=`echo $logfile | sed -r 's/\.[^\.]+$//'`-snd.log

for sndcardconfig in `ls $scriptdir/soundcards`; do
	capturecommand1=
	capturecommand2=
	capturecommand3=
	capturecommand4=
	capturecommand5=
	uploadurl=

	. $scriptdir/soundcards/$sndcardconfig

	if [ "$enabled" != "1" ]; then
		continue
	fi

	echo "processing $sndcardname..."

	echo "  running $capturecommand1..."
	eval $capturecommand1

	if [ ! -z "$capturecommand2" ]; then
		echo "  running $capturecommand2..."
		eval $capturecommand2
	fi

	if [ ! -z "$capturecommand3" ]; then
		echo "  running $capturecommand3..."
		eval $capturecommand3
	fi

	if [ ! -z "$capturecommand4" ]; then
		echo "  running $capturecommand4..."
		eval $capturecommand4
	fi

	if [ ! -z "$capturecommand5" ]; then
		echo "  running $capturecommand5..."
		eval $capturecommand5
	fi

	if [ "$uploadurl" != "" ]; then
		if [ -e $soundfile ]; then
			echo "  uploading..."
			response=`curl -s -F FILE1=@$soundfile "$uploadurl"`
			result=$?
			if [ $result -ne 0 ] || [ "$response" != "ok" ]; then
				echo "  upload error: curl exited with error code $result. response: $response"
			else
				echo "  upload: ok"
			fi
			rm -f $soundfile
		else
			echo "  error: sound file $soundfile not found."
		fi
	fi
done

echo "finished."

checklogsize
