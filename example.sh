#!/bin/bash

# setup the options definition
opts='
quiet, q, output less crap
files, f, list of files to processed, REQUIRED, N, FILE
size , s, desired output size\, ok? , 150     , 1, SIZE, n_size
'

# source the yago utility
source ./yago

# parse the options, sets in-script variables
yago_parse 'testprog' "$opts" "$@"

# print what was done
echo "quiet is          $quiet"
echo "size is           ${size[@]}"
echo "files are         ${files[@]}"
echo "leftover args are ${args[@]}"

exit 0
