#!/bin/bash

clear

name=`whoami`

rname=`pinky -l  $name | cut -d: -f 3 | head -n 1 | tr -s ' '`

echo 'Welcome to About me '$rname

numClasses=`id | tr '(' '\n' | grep -c '^c3'`

echo "You are taking $numClasses classes"   

hostName=`hostname -s`

echo 'Your current host is' $hostName

upTimeLocal=`uptime | tr , ' ' | tr -s ' ' | cut -d ' ' -f 3-6`

echo 'The current up time on this mechine is ' $upTimeLocal

actUsers=`uptime | tr , ' ' | tr -s ' ' | cut -d ' ' -f 7-8`

echo 'The number of current active users is ' $actUsers

aveload=`uptime | tr , ' ' | tr -s ' ' | cut -d ' ' -f 11-14`

echo 'The current average load time is ' $aveload

echo 'The directories in your search path are:'

echo $PATH | tr ':' '\n'

echo 'Your current is terminal type is ' $TERM

homeDis=`du ~ -skh | cut -d 'M' -f 1`

numDir=`find ~ -type d | wc -l`

echo "Your home directory is using $homeDis M space, and containts $numDir directors"
