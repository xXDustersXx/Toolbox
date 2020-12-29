#!/bin/bash
#set -vx

CP=0
NBR_CPU=$(cat /proc/cpuinfo | grep processor | wc -l)
while [[ "$CP" -lt "$NBR_CPU" ]]; do
		time echo "scale=7500; 4*a(1)" | bc -l &	
	CP=$((CP+1))
done
