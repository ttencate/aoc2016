#!/bin/bash

function decrypt() {
  steps=$(($1 % 26))
  alphabet=abcdefghijklmnopqrstuvwxyz
  tr ${alphabet} ${alphabet:$steps}${alphabet:0:$((26 - steps))}
}

while read line; do
  [[ $line =~ ^([a-z-]+)-([0-9]+)\[([a-z]+)\]$ ]]
  name=${BASH_REMATCH[1]}
  code=${BASH_REMATCH[2]}
  echo $(echo $name | decrypt $code)-$code
done | grep north
