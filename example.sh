#!/bin/bash

opts='
simple, m, simple flag
quiet , q, output less crap          , true
files , f, list of files to processed, REQUIRED, N, FILE
size  , s, desired output size\, ok? , 150     , 1, SIZE, n_size
'

./yago 'testprog' "$opts" "$@" || exit $?
