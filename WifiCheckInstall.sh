#!/bin/bash
# first line tells it it's a shell script

# Sets the file to be altered
FILE="/home/pi/wifiCheck.sh"

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

#ping a server and if the result is not 0 (success) then restart wifi


if ping -c 2 1.1.1.1 &> /home/pi/wifiStatus.log

then
        echo "network fine, waiting for next run"
else
        echo "Network down, resetting wlan0"
        ifconfig wlan0 down
        sleep 5
        ifconfig wlan0 up
fi

EOM

#Make file executable
sudo chmod +x $FILE

# friendly message

echo "Done"

echo "Starting Crontab job generation"

#Ask how often (in minutes) the job should run
read -p "How many minutes to wait between each test. Recommended is every 5 min, but 1 to 59 min is possible: " waitTime

echo "Generating crontab job"


#adding job to crontab of current user

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "*/$waitTime * * * * /usr/bin/sudo bash /home/pi/wifiCheck.sh" >> mycron
#install new cron file
crontab mycron
rm mycron

echo "Done"
