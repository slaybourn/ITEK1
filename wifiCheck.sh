#!/bin/bash

ping -c 4 1.1.1.1 > /dev/null

if [ $? != 0 ]
then
        echo "No network connection, restarting wlan0"
        /sbin/ifconfig wlan0 down
        sleep 5
        /sbin/ifconfig wlan0 up
fi

