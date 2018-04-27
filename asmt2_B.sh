#!/bin/bash

#error message function
error() {
	echo "$( basename $0 ): reguires two arguments. The first argument must be eithier -u or -f"
	echo " and the second argument must be eithier a username or a file depending on the chosen option."
	echo "Note the -u option in for user look-up, where as the -f option is for file checking"
	exit 1
}

#Testing if the first argument is a zero length string
if [ -z $1 ]; then
        echo "Please give input"
        error

#Testing if required number of arguments is met
elif [ $# -ne 2 ]; then
	echo "You gave $# arguments"
	error

#Testing to see if the first argument is -u or -f 
elif [ $1 != "-u" -a $1 != "-f" ]; then
	echo "Your first argument was $1"
	error
fi

#Variable assignments

last_log=$(last -n 1 -R $2 | head -n 1 | sed -E 's_.*/[[:digit:]][[:digit:]]__' | cut -d" " -f 9-12)

user_hdir=$( grep $2 /etc/passwd 2> /dev/null | cut -d: -f 6 )

#End of variable assignments

#File creation table
#These files are made for grep testing

users > on_users

cat /etc/passwd | cut -d":" -f 1 > ex_users

#End of file creation table

#This case statement goes down two diff logic paths.
#One of the -u option, and one for the -f option

case $1 in

	#User logic path
	-u)

	#Testing if inputed user exist
	if grep $2 ex_users > /dev/null 2> /dev/null; then

		#Outputs home directory
		echo "The home directory for $2 is $user_hdir"
			
		#Tesing to see if inputed user is logged-in
		if grep $2 on_users > /dev/null 2> /dev/null ; then
			
			#Outputs current logg-in message
			echo "$2 is currently logged on"
		else
        		#Outputs last log-in time
			echo "$2 last logged in on $last_log"
		fi
	else 
		#Error message for if inputed user does not exist
		echo "$2 user does not exist"
		exit 1
	fi;;
	
	#File testing path
	-f)

	#Does the file exist
	if [ -e $2 ]; then
		
		#Tells what type of file
		echo "$2 is a $(file $2 | cut -d: -f 2)"
		
		#testing for read premissions
		if [ -r $2 ]; then
			echo "You have read premissions for $2"
		fi

		#Testing for write premissions
		if [ -w $2 ]; then
			echo "You have write premissions for $2"
		fi

		#Testing for excute premissions
 		if [ -x $2 ]; then 
			echo "You have excute permission for $2"
		fi
	else
		echo "$2 does not exist"
		exit 1
	fi;;
esac

#Removing files made for grep testing
rm on_users ex_users
