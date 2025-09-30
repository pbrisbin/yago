> [!NOTE]
> All of my GitHub repositories have been **archived** and will be migrated to
> Codeberg as I next work on them. This repository either now lives, or will
> live, at:
>
> https://codeberg.org/pbrisbin/yago
>
> If you need to report an Issue or raise a PR, and this migration hasn't
> happened yet, send an email to me@pbrisbin.com.

# Yago

Yet Another GetOpt. An experiment in the flexibility and limitations of 
bash.

### Description

`yago` intends to be an easy way for bash scripts to parse command line 
options without the usual `while`/`case` staircase.

There are other tools that do this (which have inspired it), but I 
wanted to see if it could be done in pure bash.

The main features are its terse usage, automatic validation, and an 
automatic help message.

### Usage

~~~ { .bash }
#!/bin/bash

source ./yago

yago_parse 'testprog' "$@" << EOF

  quiet, q, output less crap
  files, f, list of files to process , REQUIRED, N, FILE
  size , s, desired output size\, ok?, 150     , 1, SIZE, n_size

EOF

# continue your script knowing that options have been parsed and the 
# variables $quiet, $files[], and $size[] are set correctly. unprocessed 
# args are placed in $args[].

echo "quiet is          $quiet"
echo "size is           ${size[@]}"
echo "files are         ${files[@]}"
echo "leftover args are ${args[@]}"

exit 0
~~~

Note: the `quiet` option has the minimum required fields to be a valid 
definition and `size` has all available attributes utilized.

~~~ 
$ ./example.sh -h
usage: testprog [ -q ] -f FILE ... [ -s SIZE ] 
    -q, --quiet               output less crap
    -f, --files FILE ...      list of files to process
    -s, --size SIZE           desired output size, ok?
~~~

~~~ 
$ ./example.sh
error: option --files is required
~~~

~~~ 
$ ./example.sh -x
error: invalid option -x
~~~

~~~ 
$ ./example.sh -q --quiet
error: duplicate option --quiet 
~~~

~~~ 
$ ./example.sh --files foo
quiet is          false
size is           150
files are         foo
leftover args are 
~~~

~~~ 
$ ./example.sh -q -s 10 12 -f a b c
error: extra argument for --size
~~~

~~~ 
$ ./example.sh -q -s --files a b c
error: missing argument for --size
~~~

~~~ 
$ ./example.sh -q -s 10 -f foo bar -- baz bat
quiet is          true
size is           10
files are         foo bar
leftover args are baz bat
~~~

### TODO

* implement custom variable
