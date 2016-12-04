#!/bin/bash

function checksum() {
  grep -o '[a-z]' | sort | uniq -c | sort -rns | head -n5 | grep -o '[a-z]' | tr -d '\n'
}

sum=0
while read line; do
  [[ $line =~ ^([a-z-]+)-([0-9]+)\[([a-z]+)\]$ ]]
  name=${BASH_REMATCH[1]}
  code=${BASH_REMATCH[2]}
  input_checksum=${BASH_REMATCH[3]}
  computed_checksum=$(echo $name | checksum)
  if [[ $input_checksum == $computed_checksum ]]; then
    (( sum += code ))
  fi
done
echo $sum
