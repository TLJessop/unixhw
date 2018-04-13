#!/bin/bash

#Assigns the variable line and runs realy simple input validattion
line=${1:?"must run $(basename $0) with a line of text as an argument"}

#Number of characters in the input string
num_char=$(echo $line | wc -m)

#Number of words in the input string
num_word=$(echo $line | wc -w)

#Number of users not counting yourself
num_user=$(( $(users | wc -w) - 1))

#outputs the string given by user
echo "$line"

#outputs number of char and words in the input string
echo "Your string contains $num_char characters and $num_word words"

#outputs number of users
echo "There are $num_user users logedon right now"

#output an random number less 1000
echo "Lastly here's your random number: ${RANDOM: : -2}"
