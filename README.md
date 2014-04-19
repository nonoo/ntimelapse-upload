ntimelapse-upload
=================

Captures and uploads multiple webcam images and sound recordings to a PHP script
in [ntimelapse](https://github.com/nonoo/ntimelapse).

## Usage

Copy config-example to config and edit it. You'll need my nlogrotate script which
can be found [here](https://github.com/nonoo/nlogrotate).

There are two scripts:

- *camcapture.sh*: loads and executes each config file in the *cameras* subdir.
- *sndcapture.sh*: loads and executes each config file in the *soundcards* subdir.

### camcapture.sh

Here's an example config for a webcam, this should be placed in the *cameras* subdir,
with the file name *camname.inc.sh*:

````
enabled=0
camname=${camconfig%%.*}
imagefile="$tempcapturedir/$camname.jpg"
device=/dev/video0
capturecommand1="$v4lctl -d $device -c white_balance_temperature_auto=1 -c focus_auto=0 -c focus_absolute=0"
capturecommand2="$uvccapture -v -d$device -x1280 -y720 -D4"
capturecommand3="$uvccapture -v -d$device -x1280 -y720 -D3 -o$imagefile"
capturecommand4=
capturecommand5=
uploadurl="http://ntimelapse/upload.php?p=pass&i=$camname&d=`date +%s`"
````

### sndcapture.sh

Explanation of the parameters:

- *enabled*: if it's 1, then the config file is enabled.
- *camname*: this is the camera name which is derived from the config file name
             (for example if the file name is camname.inc.sh, then the camera's
             name will be camname).
- *imagefile*: this is the file where the image will be (temporarily) saved.
- *device*: the v4l device file of the webcam.
- *capturecommands*: these commands will be executed to capture the image.
- *uploadurl*: if this is set, then the image file will be uploaded to the given
               URL with curl.

An example soundcard config which records 20 seconds from the ALSA audio device
hw:1,0, and then encodes it with lame.

````
enabled=1
sndcardname=${sndcardconfig%%.*}
soundfile="$tempcapturedir/$sndcardname.wav"
capturecommand1="AUDIODEV=hw:1,0 rec -q $soundfile trim 0 20"
capturecommand2="lame -S -b 320 -m s -q 0 $soundfile"
capturecommand3="rm -f $soundfile"
soundfile=$soundfile.mp3
capturecommand4=
capturecommand5=
uploadurl="http://ntimelapse/upload.php?p=pass3&i=$sndcardname&d=`date +%s`"
````

Explanation of the parameters:

- *enabled*: if it's 1, then the config file is enabled.
- *sndcardname*: this is the sound card name which is derived from the config
                 file name (for example if the file name is test.inc.sh, then
                 the sound card's name will be test).
- *soundfile*: this is the file where the image will be (temporarily) saved.
- *capturecommands*: these commands will be executed to capture the image.
- *uploadurl*: if this is set, then the sound file will be uploaded to the given
               URL with curl.
