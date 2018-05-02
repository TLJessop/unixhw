#!/bin/bash

#var

#mode control var
mode_cv=$1

#user inputed file
ucal_file=$2

#end of var

#wellcome message
echo "Wellcome to $(basename $0) your terminal calandar event wisard"

error(){
	echo "$(basename $0): Error your first argument must be -c or -r"
	echo "-c is for create mode and -r is for read mode"
	echo "If useing read mode your second argument must be an .ical file"
	echo "If useing create mode only the first argument is required"
	exit 1  	
}

#Input validation

#Tests to see if valid number of arguments was given
if [ $# -lt 1 -o $# -gt 2 ]; then
	echo "You may give one or two arguments depending on mode used"
	echo "You gave $# arguments"
	error

#tests to see if first argument is a valid option
elif [ $1 != "-c" -a $1 != "-r" ]; then
	echo "That was not a valid option: You input $1"
	error

elif [ "$1" = "-c" ]; then
	echo "create mode"

elif [ "$1" = "-r" ]; then
	if [ $# -lt 2 ]; then 
		error	
	elif [ ! -e $2 ]; then 
		error
	elif [ ! -r $2 ]; then
		echo "$2 must be readable"
		exit 1
	elif [ "$2" != '*.ical' ]; then
		echo "Error: your second arguments was $2"
		error  
	fi

	echo "read mode"
fi


#writes file to be exported

echo "BEGIN:VCALENDAR" >>cal_test.ical
#echo "VERSION:2.0" >>cal_test.ical
#echo "PRODID:-//tljessop.com" >>cal_test.ical
#echo "METHOD:PUBLISH" >>cal_test.ical
#echo "BEGIN:VEVENT" >>cal_test.ical
#echo "SUMMARY:Abraham Lincoln" >>cal_test.ical
#echo "UID:2008-04-2" >>cal_test.ical
#echo "DTSTART:20080212" >>cal_test.ical
#echo "DTEND:20080213" >>cal_test.ical
#echo "DTSTAMP:20150421T141403" >>cal_test.ical
#echo "LOCATION:Hodgenville\, Kentucky" >>cal_test.ical
#echo "DESCRIPTION:Born February 12\, 1809" >>cal_test.ical
#echo "END:VEVENT" >>cal_test.ical
#echo "END:VCALENDAR" >>cal_test.ical
