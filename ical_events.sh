#!/bin/bash

#wellcome message
echo "Wellcome to $(basename $0) your terminal calandar event wizard"

#this function stiches lines back together in read mode
stich(){	
	until [[ $2 = *:* ]]; do
	echo "$2">>line_stich
	shift 1 
	done
	echo "$(cat line_stich | tr '\n' ' ' | tr -d \\ 2>/dev/null)"
	rm line_stich
}

date_writer(){
	#reads in date
	read wdate
	#validation loop for date input
	until [[ "$wdate" = [0-1][[:digit:]]/[0-3][[:digit:]]/[[:digit:]][[:digit:]][[:digit:]][[:digit:]] ]]; do
		echo "Sorry that's not not the right format"
		echo "You gave $wdate as the date"
		echo "$(basename $0) accepts date in the month/day/year format. ie 07/04/1776"
		read wdate
	done 
	#reformats the date to match the .ical spec
	wdate=$( echo "$wdate" | sed -E 's_([[:digit:]]+/)([[:digit:]]+/)([[:digit:]]+)_\3\2\1_' | sed -E 's_/__g')


}

time_writer(){
	read wtime
	until [[ "$wtime" = [0-1][[:digit:]]:[0-5][[:digit:]]am ]] || [[ "$wtime" = [0-1][[:digit:]]:[0-5][[:digit:]]pm ]]; do
		echo "Sorry that's not not the right format"
		echo "You gave $wtime as the time"
		echo "$(basename $0) accepts time in the hour:minute am or pm format. ie 07:45am or 05:20pm"
		read wtime
	done 
	#checks to see if inputed time is am
	if [[ "$wtime" = *am ]]; then
		#formats input time for am input
		wtime=$(echo $wtime | sed -E 's/([[:digit:]]+:)([[:digit:]]+)(.+)/T\1\200/' | tr -d : )
		
		#convets 12am to military time
		if [[ ${wtime:1:2} = 12 ]]; then
			conver_hour=00
			#adds back the converted hour and formats the string
			wtime=$(echo T${conver_hour}$(echo ${wtime:3} | sed -E 's/([[:digit:]]+:)([[:digit:]]+)(.+)/\200/' | tr -d :) )
		fi
	#checks if inputed time is pm
	elif [[ "$wtime" = *pm ]]; then
		#formats time for pm input

		#cuts the hour value off and adds 12 to convert to military time
		conver_hour=$(( ${wtime:0:2} + 12))

		#Prevents the hour reading out at 24 
		if [ $conver_hour -eq 24 ]; then
			conver_hour=12
		fi
		#adds back the converted hour and formats the string
		wtime=$(echo T${conver_hour}$(echo $wtime | sed -E 's/([[:digit:]]+:)([[:digit:]]+)(.+)/\200/' | tr -d :) )
	fi
}

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

#create mode option test
elif [ "$1" = "-c" ]; then
	#Create Mode declaration
	echo "Entering: Create Mode"

#Read mode option tests
elif [ "$1" = "-r" ]; then
	#tests to see if second argument is given
	if [ $# -lt 2 ]; then 
		echo "Read mode requires an input file"
		error	
	#tests to see if the second argument is an existing file
	elif [ ! -e $2 ]; then 
		echo "Error: $2 doesn't exist"
		error
	#tests to see if the second argument is readable
	elif [ ! -r $2 ]; then
		echo "$2 must be readable"
		exit 1
	#tests to see if the second argument is a valid calendar file
	elif ! file $2 | grep "vCalendar" >/dev/null 2>/dev/null; then
		echo "Error: your second arguments was not a valid calendar file"
		echo "Your second argument was $2"
		error  
	fi
	#Read mode declaration
	echo "Entering: Read Mode"
fi
#End of Input verification

#Mode Fuctional Branching
if [ "$1" = "-c" ]; then

#Start time and date layer
	#reads in event name
	echo "What would you like to call your event?"
	read event_name

	#reads in start date
	echo "In what on date does your event start?"
	date_writer
	stdate=$(echo $wdate)
	wdate=
	
	#reads in start time
	echo "What time does your event start?"
	time_writer
	stime=$wtime	
	wtime=

	#Merges start date and start time which is needed for proper formating
	stdate=$(echo ${stdate}${stime})

#End time and date layer
	#reads in end date
	echo "On what date does your event end?"
	date_writer
	endate=$wdate

	#reads in end time
	echo "What time does your event end?"
	time_writer
	entime=$wtime

	#Merges end date and end time which is needed for proper formating
	endate=$(echo ${endate}${entime})
	
#Location layer
	#intakes event location
	read -p "Where is this event going to be ?  " event_loc
	#escapes any commas

#Description layer
	#asks if user would like to add a description
	read -p "Would you like to add a description of your event ?  " descrip_decis
	until [ "$descrip_decis" = y -o "$descrip_decis" = n ]; do
	       read -p "Please enter y for yes or n for no:  " descrip_decis
 	done
	
	#intakes event description
	if [ "$descrip_decis" =	y ]; then
		read -p "Please describe your event: "  event_descrip
	fi
#Write output file
	echo "BEGIN:VCALENDAR" >${event_name:0:3}${stdate:4:4}.ical
	echo "VERSION:2.0" >>${event_name:0:3}${stdate:4:4}.ical
	echo "PRODID:-//tljessop.com" >>${event_name:0:3}${stdate:4:4}.ical
	echo "METHOD:PUBLISH" >>${event_name:0:3}${stdate:4:4}.ical
	echo "BEGIN:VEVENT" >>${event_name:0:3}${stdate:4:4}.ical
	echo "SUMMARY:$event_name" >>${event_name:0:3}${stdate:4:4}.ical
	echo "UID:${event_name:0:2}_$stdate" >>${event_name:0:3}${stdate:4:4}.ical
	echo "DTSTART:$stdate" >>${event_name:0:3}${stdate:4:4}.ical
	echo "DTEND:$endate" >>${event_name:0:3}${stdate:4:4}.ical
	echo "DTSTAMP:$stdate" >>${event_name:0:3}${stdate:4:4}.ical
	echo "LOCATION:$event_loc" >>${event_name:0:3}${stdate:4:4}.ical
	echo "DESCRIPTION:$event_descrip" >>${event_name:0:3}${stdate:4:4}.ical
	echo "END:VEVENT" >>${event_name:0:3}${stdate:4:4}.ical
	echo "END:VCALENDAR" >>${event_name:0:3}${stdate:4:4}.ical
fi #close create mode functional path

if [ "$1" = -r ]; then
		
#resets the argument listing for the parsing while loop
set -- $(cat $2 )

#file parsing while loop
#loop is set to evalutate until it runs out of arguments
while [ $# -gt 0 ]
do
	case $1 in
		#parses out the event name
		SUMMARY:*)
			echo "The event is named: ${1:8}">line_stich
			#this function stichs line back together and prints it to the screen
			stich $*;;
		#parses out event start date
		DTSTART:*)
			#tests to see if the start date field was given a time element
			if [[ $1 = DTSTART:*T* ]]; then
				#parses and displays start date and time
				echo "The event starts at: ${1:17:2}:${1:19:2} ${1:14:2}/${1:12:2}/${1:8:4}"
			else
				#parses and displays the start date
				echo "The event starts at: ${1:14:2}/${1:12:2}/${1:8:4}"
			fi;;
		#parses out event end date
		DTEND:*)	
			#tests to see if the end date field was given a time element
			if [[ "$1" = DTEND:*T* ]]; then
				#parses and displays end date and time
				echo "The event ends at: ${1:15:2}:${1:17:2} ${1:12:2}/${1:10:2}/${1:6:4}"   
			else
				#parses and displays the end date
				echo "The event ends at: ${1:12:2}/${1:10:2}/${1:6:4}"
			fi;;
		#parses out the the event location
		LOCATION:*)
			echo "$(echo "The event is held at: ${1:9:40}" | tr -d \\ 2>/dev/null)" >line_stich
			stich $*;;
		#parses out the event description
		DESCRIPTION:*)
			echo "Descripton of the event: ${1:12}">line_stich	
			#this function stichs line back together and prints it to the screen
			stich $* ;;

			*)
			;;
	esac
	shift 1
done
fi #End read functional path
