#!/bin/bash

if file $1 2>/dev/null | grep "directory" >/dev/null 2>&1; then
       cd $1 2>/dev/null
else 
	echo "Error that was not directory" 1>&2 
	exit 1
fi       

set -- $(ls * | tr -d : 2>>errors)

while [ $# -gt 0 ];
do
	if [ -f $1 ]; then
		chmod 644 $1 2>>errors
	elif file $1 2>>errors | grep "directory" >/dev/null 2>>errors; then
		chmod 755 $1 2>>errors
	else 
		echo "$1 was not a file or directory"
	fi

	shift 1
done	

if [ -e errors ]; then 
	echo "Then following errors occurd :" 1>&2
	cat errors 2>/dev/null
	rm errors 2>/dev/null
	exit 1
fi
