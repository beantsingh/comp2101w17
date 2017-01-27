#!/bin/bash
#this script prints out a welcome message
#it demostrate using variables

export MYNAME="Beant"
mytitle="Supreme Commander"

myhostname=`hostname`
dayoftheweek=$(date +%A)
echo "Welcome to planet $myhostname, $mytitle $MYNAME!"
echo "Today is $dayoftheweek."
