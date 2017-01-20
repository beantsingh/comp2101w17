#!/bin/bash
#My lab 1.7
#This command show the total numbers of the regular files in the Directory ~/Pictures
Totalf= `find ~/Pictures/ -maxdepth 1 -type f | awk '/\//{print ++c, $0}' | tail -n 1 | awk \'{print $1}'`
echo "The total of files on ~/Pictures directory is of $totalf files."

#This command will show how much space on disk these files used
totals= `find ~/Pictures/ -maxdepth 1 -type f | xargs du -shc | tail -nl | awk '{print $1}'`
echo "The total usage of disk space $totals"

#This command will show the 3 largest files on ~/Pictiures/

sizes=($(find ~/Pictures/ -maxdepth 1 -type f | xargs du -shc | sort | head -n3 | awk '{print $1}'))
filesnames=($(find ~/Pictures/ -maxdepth 1 -type f | xargs du -shc | sort | head -n3 | awk '{print $2}' | cut -d "/" -f5))
while [${sizes[@]}]
do
      echo