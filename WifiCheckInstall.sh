#!/bin/bash
# first line tells it it's a shell script

# Sets the file to be altered
FILE="/usr/local/bin/wifiCheck.sh"

# Nice friendly user message... don't panic / 42
echo "Working on the Wifi Check Installer....."

# bin/cat is the command we use, EOM is the "End of message"
# we use to tell when the command is done (can be anything) 
# $FILE calls the file we defined
# The  <<EOM > send all text untill the "EOM" part to the file
# Known as a "here document" for one > all is replaced in the file
# to append, use >>$FILE
# Followed by the the code we actually want to replace everything in the file with

/bin/cat <<EOM >$FILE

ping -c 4 1.1.1.1 > /dev/null

if [ $? != 0 ]
then
        echo "No network connection, restarting wlan0"
        /sbin/ifconfig wlan0 down
        sleep 5
        /sbin/ifconfig wlan0 up
fi

EOM

# friendly message

echo "Done"

echo "Starting Crontab job generation"

#Ask how often (in minutes) the job should run
read -p "How many minutes to wait between each test. Recommend  5 min, but 1 min is possible:" waitTime

echo "Generating crontab job"


#adding job to crontabs

(crontab -l 2>/dev/null; echo "/$waitTime * * * * /usr/bin/sudo -H /usr/local/bin/wifiCheck.sh >> /dev/null 2>&1")| crontab -

echo "Done"
