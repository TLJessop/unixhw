#!/bin/bash

#var

#mode control var
mode_cv=$1

#user inputed file
ucal_file=$2

#end of var

#wellcome message
echo "Wellcome to $(basename $0) your terminal calandar event wizard"

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

#create mode path
elif [ "$1" = "-c" ]; then
	echo "create mode"
#Read mode path 
elif [ "$1" = "-r" ]; then
	if [ $# -lt 2 ]; then 
		error	
	elif [ ! -e $2 ]; then 
		echo "Error: $2 doesn't exist"
		error
	elif [ ! -r $2 ]; then
		echo "$2 must be readable"
		exit 1

	elif ! file $2 | grep "vCalendar" >/dev/null 2>/dev/null; then
		echo "Error: your second arguments was not a valid calendar file"
		echo "Your second argument was $2"
		error  
	fi
	echo "read mode"
fi
#End of Input verification

#Mode Branching
if [ "$1" = "-c" ]; then
	#reads in start date
	echo "In what on date does your event start?"
	read stdate
	until [[ "$stdate" = [0-1][[:digit:]]/[0-3][[:digit:]]/[[:digit:]][[:digit:]][[:digit:]][[:digit:]] ]]; do
		echo "Sorry that's not not the right format"
		echo "You gave $stdate as the date"
		echo "$(basename $0) accepts date in the month/day/year format. ie 07/04/1776"
		read stdate
	done 

	#reformats the date to match the .ical spec
	stdate=$( echo "$stdate" | sed -E 's_([[:digit:]]+/)([[:digit:]]+/)([[:digit:]]+)_\3\2\1_' | sed -E 's_/__g')

	#reads in start time
	echo "What time does your event start?"
	read stime
	until [[ "$stime" = [0-1][[:digit:]]:[0-5][[:digit:]]am ]] || [[ "$stime" = [0-1][[:digit:]]:[0-5][[:digit:]]pm ]]; do
		echo "Sorry that's not not the right format"
		echo "You gave $stime as the time"
		echo "$(basename $0) accepts time in the hour:minute am or pm format. ie 07:45am or 05:20pm"
		read stime
	done 
	#checks to see if start time is am or pm
	if [[ "$stime" = *am ]]; then
		#formats input time for am input
		stime=$(echo $stime | sed -E 's/([[:digit:]]+:)([[:digit:]]+)(.+)/T\1\200/' | tr -d : )
	elif [[ "$stime" = *pm ]]; then
		#cuts the hour value off and adds 12 to convert to military time
		conver_hour=$(( ${stime:0:2} + 12))
		#Prevents the hour reading out at 24 
		if [ $conver_hour -eq 24 ]; then
			conver_hour=00
		fi
		#adds back the converted hour and formats the string
		stime=$(echo T${conver_hour}$(echo $stime | sed -E 's/([[:digit:]]+:)([[:digit:]]+)(.+)/\200/' | tr -d :) )
	fi
	
	#Merges start date and start time which is needed for proper formating
	stdate=$(echo ${stdate}${stime})
	echo $stdate
fi
echo "BEGIN:VCALENDAR" >>cal_test.ical
echo "VERSION:2.0" >>cal_test.ical
echo "PRODID:-//tljessop.com" >>cal_test.ical
echo "METHOD:PUBLISH" >>cal_test.ical
echo "BEGIN:VEVENT" >>cal_test.ical
echo "SUMMARY:Abraham Lincoln" >>cal_test.ical
echo "UID:2008-04-2" >>cal_test.ical
echo "DTSTART:$stdate" >>cal_test.ical
echo "DTEND:20080213" >>cal_test.ical
echo "DTSTAMP:20150421T141403" >>cal_test.ical
echo "LOCATION:Hodgenville\, Kentucky" >>cal_test.ical
echo "DESCRIPTION:Born February 12\, 1809" >>cal_test.ical
echo "END:VEVENT" >>cal_test.ical
echo "END:VCALENDAR" >>cal_test.ical


