#!/bin/bash

opts='
quiet , q, output less crap
files , f, list of files to processed, REQUIRED, N, FILE
size  , s, desired output size\, ok? , 150     , 1, SIZE, n_size
'

output="$(./yago 'testprog' "$opts" "$@")" && eval "$output" || exit $?

echo "quiet is $quiet"
echo "size is ${size[@]}"
echo "files are ${files[@]}"
echo "leftover args are ${args[@]}"

exit 0
