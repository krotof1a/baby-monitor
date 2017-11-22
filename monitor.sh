#!/bin/bash

PID=/tmp/monitor
WDIR=/home/pi/baby-monitor/chuuuuttt
PIN=12
WAIT=3

if [ $# -ne 1 ] 
then
	echo "Usage $0 [start|stop]"
	exit 1
else
	if [ "$1" = "start" ]
	then
		if [ -f $PID ]
		then
			echo "Monitor is already running ..."
			exit 1
		else
			echo "Starting monitor ..."
			echo "1" > $PID
		fi
	else if [ "$1" = "stop" ]
	then
		echo "Stoping monitor ..."
		rm -f $PID
		PIDNUM=`ps -edf | grep gpio | grep -v grep | cut -f2-8 -d' '`
		if [ "$PIDNUM" = "" ]
		then
			ps -edf | grep -v grep | grep -v stop | grep $0 > /dev/zero 2>&1
			if [ $? -eq 0 ]
			then
				sleep $WAIT
				$0 $1
			fi
		else
			kill $PIDNUM
		fi
		exit 0
	else
		echo "Usage $0 [start|stop]"
		exit 1
	fi
	fi
fi

while [ -f $PID ]
do
	file=`ls $WDIR | shuf -n 1`
	#echo "Play the file $file"
	IT=`cat $PID`
	if [ "$IT" = "1" ]
	then
		echo "2" > $PID
	else
		aplay $WDIR/$file > /dev/zero 2>&1
	fi
	sleep $WAIT
	gpio wfi $PIN falling
done
