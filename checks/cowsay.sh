#!/bin/bash

# Check if cowsay has been installed

RESULTS="/root/scripts/results"
LAST="false"

while true; do

	ssh root@192.168.6.2 "dpkg -s cowsay" &> /dev/null

	RESULT=$?

	if [ $RESULT -ne 0 ] && [ $LAST == "false" ]; then
		echo "Cowsay not installed"
	elif [ $RESULT -eq 0 ] && [ $LAST == "false" ]; then
		echo "Cowsay has been installed"
		touch $RESULTS/cowsay
		LAST="true"
	elif [ $RESULT -ne 0 ] && [ $LAST == "true" ]; then
		echo "Cowsay has been uninstalled"
		rm $RESULTS/cowsay	
		LAST="false"
       	elif [ $RESULT -eq 0 ] && [ $LAST == "true" ]; then
		echo "Cowsay is still installed"
	else
		echo "Something went wrong!"
	fi

	sleep 5

done

