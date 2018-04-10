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

#End of variable asignments

#Welcome message
echo "Welcome to GetInfo $rname"

#Naming current host

echo "You are currently logged onto $host"
