#!/bin/bash

#Variable assignments

prog_name=$( basename $0 )

#End of variable assignments

error() {
	echo "Error : $1 reguires two arguments, the first argument must be either -a or -b"
	echo "The second argment must be vaid and readable"
	exit 1 
}

if [ -z $1 ]; then
	error $prog_name

elif [ $1 != "-a" -a $1 != "-b" ]; then
	echo "Your first argument was $1"
	error $prog_name

elif [ ! -f $2 -a ! -r $2 ]; then
	echo "Your second argument was $2"
	error $prog_name

fi
