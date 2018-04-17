#!/bin/bash

#Variable assignments

#Numbers of Args
arg_num=$#

#Takes the first arg and puts it into a variable for or testing
a_or_b=$1

#Takes the second arg to test if it's a file
usr_file=$2

#Error flag
error_flag=0

#End of variable assignments

#Welcome Message

echo "Welcome to $(basename $0)"
 
#Tests to see if min number of arg is met
if [ "$arg_num" -ne 2 ]; then
	echo "You must give this program 2 arguments, but not any more then 2 arguments"
	echo "You gave this program $arg_num arguments"
	error_flag=1
	exit 1
fi

#Tests to see if first arg is -a or -b
if [ "$a_or_b" != "-a" "-a" "$a_or_b" != "-b" ]; then
	echo "Your first argument must be -a or -b"
	echo "Your first argument was $a_or_b"
	error_flag=1
	exit 1
fi

#Tests to see if second arg is a valid file
if [ ! -f "$usr_file" ]; then
	echo "Your second argument must be a valid/existing file"
	echo "Your second argument was $usr_file"
	error_flag=1
	exit 1
fi

#Checking the error flag
if [ "$error_flag" -eq 0 ]; then
	echo "You have completed this program with valid arguments, Thank you and Good bye"
	exit 0

fi
