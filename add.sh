#!/bin/bash

total=0

while [ $# -gt 0 ]; 
do 
	if [ $1 -eq $1 2>/dev/null ]; then
	echo "$1" >> add_list 2>/dev/null
else 
	echo "$1" >> bad_list
fi

shift 1
done

set -- $(cat add_list 2>/dev/null)

while [ $# -gt 0 ];
do
	total=$(( $1 + $total )) 
	shift 1
done
echo "The total was $total"
rm add_list 2>/dev/null

if [ -e bad_list ]; then
	echo "Your bad arguments were: $(cat bad_list)" 1>&2
	rm bad_list 2>/dev/null
	exit 1
fi
