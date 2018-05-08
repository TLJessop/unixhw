#!/bin/bash

set -- $(cat $1)
while [ $# -gt 0 ]
do
	if [[ "$1" = ??? ]]; then
	       echo "${1}kB"
       else
		echo "$(( $1 / 1024))MB"
	fi
	shift 1

done
