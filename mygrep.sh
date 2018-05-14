#!/bin/bash

read_file=$2

set -- $( cat $1)

while [ $# -gt 0 ]; do
	if grep $1 $read_file >/dev/null 2>&1; then
		echo "The Phase: $1 : was found in $(basename $read_file) on $(grep -c $1 $read_file 2>/dev/null) lines"
	fi
	shift 1
done

