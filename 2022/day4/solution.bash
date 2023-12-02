#!/bin/bash 

for file in "$@"; do
  fullOverlapCount=0
  partialOverlapCount=0
  while read -r line; do
    IFS=, read -ra pairs <<< "$line"
    IFS=- read -ra first <<< "${pairs[0]}"
    IFS=- read -ra second <<< "${pairs[1]}"
    if 
      (( first[0] <= second[0] && first[1] >= second[1] )) ||
      (( second[0] <= first[0] && second[1] >= first[1] )) 
    then
      fullOverlapCount=$(( fullOverlapCount + 1 ))
    elif ! (( first[0] > second[1] || second[0] > first[1] ))
    then
      partialOverlapCount=$(( partialOverlapCount + 1 ))
    fi
  done < "$file"
  echo "$file"
  echo "    Part 1: $fullOverlapCount"
  echo "    Part 2: $(( fullOverlapCount + partialOverlapCount ))"
done
