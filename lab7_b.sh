#!/bin/bash

#seting arg number variable
arg_num=$(( $# - 1 ))

#Welcome message
echo "Welcome to $(basename $0)"

#Testing to see if the first argument is -b
if [ "$1" = "-b" ]; then
	#Getting rid of the -b
	shift 1
	#while there are arguments run loop
	while [ $# -gt 0 ]; do
		#Does this file exist
		if [ ! -e $1 ]; then 
			echo "$1 does not exist"
		#Testing if this is text file
		elif file $1 2>/dev/null | grep "ASCII" >/dev/null 2>/dev/null; then
			#Output header with file name
			echo "**************$(basename $1)************"	
			#Output the contents of the file
			cat "$1"
		else
			#if file does not exist error message
			echo "You must give a text file, $1 was a $( file $1 | cut -d":" -f 2 )"
		fi 
		shift 1
	done
   echo "You gave $arg_num files to $(basename $0)"
else
	#while there are arguments run loop
        while [ $# -gt 0 ]; do
                #Does this file exist
                if [ ! -e $1 ]; then
                        echo "$1 does not exist"
                #Testing if this is text file
                elif file $1 2>/dev/null 2>/dev/null | grep "ASCII" >/dev/null 2>/dev/null; then
                	#Output the contents of the file
                	cat "$1"
                else
                        #if file does not exist error message and exit
                        echo "You must give a text file, $1 was a $( file $1 | cut -d":" -f 2 )"
                fi
                shift 1
        done
fi
