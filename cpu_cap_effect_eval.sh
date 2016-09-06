#!/bin/bash

#
# Usage: script [Target VM IP] [User to access VM] [VM Name] [step] [repeats] 
#

VM_IP=$1
VM_USER=$2
VM_NAME=$3
STEP=$4
NUMBER_OF_REPEATS=$5

RESULTS_FILE="results.csv"

function factorial() 
  if (( $1 < 2 ))
  then
    echo 1
  else
    echo "$1 * $(factorial $(( $1 - 1 )))" | bc
  fi

N=100
START_CAP=10
END_CAP=100
LEVEL_NUMBER=1

echo "CAP,time" > $RESULTS_FILE

for r in `seq 1 $NUMBER_OF_REPEATS`
do
	echo "Repeat:$r"
	for CAP in `seq $START_CAP $STEP $END_CAP | shuf`
	do
		sleep 5
		echo "level:$LEVEL_NUMBER,CAP:$CAP%"
		virsh schedinfo $VM_NAME --set vcpu_quota=$(( $CAP * 1000 )) > /dev/null 
		TOTAL_TIME="`ssh $VM_USER@$VM_IP "$(typeset -f); { time -p factorial $N > /dev/null; } 2>&1" | grep "real" | awk '{print $2}'`"
		echo "$CAP,$TOTAL_TIME" >> $RESULTS_FILE
		LEVEL_NUMBER=$(( $LEVEL_NUMBER + 1 ))
	done

	LEVEL_NUMBER=1
done
