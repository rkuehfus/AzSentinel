#! /usr/bin/env bash

function max2 {
   while [ `jobs | wc -l` -ge 11 ]
   do
      sleep 5
   done
}

find . -type f | while read name ; 
do 
   max2; nmap -sV 10.0.2.5 -A -Pn &
done
wait