#!/bin/bash

#Variable Assignments

#Local minus Operator variable number
ENV_VAR=$(printenv | wc -l)

#All System Variables
ALL_VAR=$(set | wc -l)

#This variable does arithmetic to know the number of local variables
LOCAL_VAR=$((ALL_VAR - ENV_VAR))

#User name
uname=$(whoami)

#Real name
rname=`pinky -l  $uname | cut -d: -f 3 | head -n 1 | tr -s ' '`

#Name of host
host=$(hostname)

#Last twos logins cut into one line
log_last_2=$(last -2 $LOGNAME | sed -e 's/'.'*\.[[:digit:]][[:digit:]][[:digit:]]//' -e 's/-.*//' -e 's/s.*//' | head -2 | sed 'N;s/\n//')

#Uptime cut down to a useable form
uptime_par=$(uptime | sed -e 's/'.'*p//' -e 's/us'.'*//')

#Mount point
mount_point=$(df -h "$PWD" | tail -1 | cut -d " " -f 1)

#Percentage of space used
per_used=$(df -h "$PWD" | tail -1 | cut -d " " -f 10 | tr -d %)

#Percentage of space free
per_free=$(( 100 - per_used ))

#Data size 
data_size=$(df -h "$PWD" | tail -1 | cut -d " " -f 3 | tr -d "G")

#Used space
used_space=$(df -h "$PWD" | tail -1 | cut -d " " -f 5 | tr -d "G")

#Free space
free_space=$(( data_size - used_space))

#Ip adress
ip=$(ifconfig | tail -8 | grep "inet " | cut -d " " -f 10)

#End of variable asignments

#Welcome message
echo "Welcome to GetInfo $rname"

#Naming current host
echo "You are currently logged onto $host"

#Outputs last two logins
echo "Your last two logins were $log_last_2"

#Outputs the number of local and environment variables
echo "There are $LOCAL_VAR local variables and $ENV_VAR environmental variables"

#Outputs the PATH variable with each listing on a new line
echo "Below your PATH variable is listed:"
echo $PATH | tr : '\n'

#Outputs system uptime
echo "Your system has been up for $uptime_par sec"

#Outputs mount point and current directory storage info
echo "Your mount point is $mount_point"
echo "You have $per_free%  free which equals $free_space G free of the $data_size G aloted to your current directory." 

#Outputs your ip adress
echo "Your ip adress is $ip"
