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

for camconfig in `ls $scriptdir/cameras`; do
	capturecommand1=
	capturecommand2=
	capturecommand3=
	capturecommand4=
	capturecommand5=
	uploadurl=

	. $scriptdir/cameras/$camconfig

	if [ "$enabled" != "1" ]; then
		continue
	fi

	echo "processing $camname..."

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
		if [ -e $imagefile ]; then
			echo "  uploading..."
			curl -F FILE1=@$imagefile "$uploadurl"
			result=$?
			if [ $result -ne 0 ]; then
				echo "  upload error: curl exited with error code $result."
			else
				echo "  upload: ok"
			fi
			rm -f $imagefile
		else
			echo "  error: image file $imagefile not found."
		fi
	fi
done

echo "finished."

checklogsize
