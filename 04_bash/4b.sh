#!/bin/bash

alphabet=abcdefghijklmnopqrstuvwxyz
while read line; do
  [[ $line =~ ^([a-z-]+)-([0-9]+)\[([a-z]+)\]$ ]]
  name=${BASH_REMATCH[1]}
  code=${BASH_REMATCH[2]}
  steps=$(($code % 26))
  echo $(echo $name | tr ${alphabet} ${alphabet:$steps}${alphabet:0:$((26 - steps))})-$code
done | grep north
