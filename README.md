enabled=0
camname=${camconfig%%.*}
imagefile="$tempcapturedir/$camname.jpg"
device=/dev/video0
capturecommand1="$v4lctl -d $device -c white_balance_temperature_auto=1 -c focus_auto=0 -c focus_absolute=0"
capturecommand2="$uvccapture -v -d$device -x1280 -y720 -D4"
capturecommand3="$uvccapture -v -d$device -x1280 -y720 -D3 -o$imagefile"
capturecommand4=
capturecommand5=
uploadurl="http://ntimelapse/upload.php?p=pass&i=$camname&d=`date +%Y%m%d%H%M%S`"

enabled=1
sndcardname=${sndcardconfig%%.*}
soundfile="$tempcapturedir/$sndcardname.wav"
device=/dev/dsp1
capturecommand1="AUDIODEV=hw:1,0 rec $soundfile trim 0 20"
capturecommand2=
capturecommand3=
capturecommand4=
capturecommand5=
uploadurl="http://ntimelapse/upload.php?p=pass&s=$sndcardname&d=`date +%Y%m%d%H%M%S`"
