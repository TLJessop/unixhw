#!/bin/bash

if [ $# -lt 2 -o $# -gt 3 ]; then
	echo "$(basename $0 ): error min arguments 2 max arguments 3. you gave $# arguments"
	exit 1
fi

if [ $# -eq 3 ]; then
	echo "${3}, $1 $2"
else
	echo "${2}, $1"
fi


#MONTH={MONTH:-"not there"}
