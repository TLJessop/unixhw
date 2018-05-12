#!/bin/bash

set -- $(cat $1 )

while [ $# -gt 0 ]
do
	case $1 in
		SUMMARY:*)
			echo "The Summary was  ${1:8}">line_stich
			
			until [[ $2 = *:* ]]; do
				echo "$2">>line_stich
				shift 1 
			done
			
			echo "$(cat line_stich | tr '\n' ' ' | tr -d \\ 2>/dev/null)"
			rm line_stich;;

		DTSTART:*)
			if [[ $1 = DTSTART:*T* ]]; then
				echo "The event starts at ${1:17:2}:${1:19:2} ${1:14:2}/${1:12:2}/${1:8:4}"
			else
				echo "The event starts at ${1:14:2}/${1:12:2}/${1:8:4}"
			fi;;
		DTEND:*)
			if [[ "$1" = DTEND:*T* ]]; then
				echo "The event ends at ${1:15:2}:${1:17:2} ${1:12:2}/${1:10:2}/${1:6:4}"   
			else
				echo "The event ends at ${1:12:2}/${1:10:2}/${1:6:4}"
			fi;;
		LOCATION:*)
			echo "$(echo "The event is held at ${1:9:40} $2" | tr -d \\ 2>/dev/null)";;
		DESCRIPTION:*)
			echo "Descripton of the event: ${1:12}">line_stich
			
			until [[ $2 = *:* ]]; do
				echo "$2">>line_stich
				shift 1 
			done 
			echo "$(cat line_stich | tr '\n' ' ' | tr -d \\ 2>/dev/null)"
			rm line_stich;;
		*)
			;;
	esac
	shift 1
done

