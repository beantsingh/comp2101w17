#!/bin/bash
# this script demonstrats using arrays and getting user input

 colours=("red" "green" "blue")
declare -A animals
 animals=([red]="cardinal" [green]="frog" [blue]="lobster" )
 numcolours=${#colours[@]}
 read -p "Give me a number from 1 to $numcolours: " numrequested
 num=$((numrequested - 1))
 colour=${colours[$num]}
 animal=${animals[$colour]}
echo "$numrequested finds a $colour $animal"