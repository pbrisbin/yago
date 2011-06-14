# Yago

Yet Another GetOpt. An experiment in the flexibility and limitations of 
bash.

### Description

`yago` intends to be an easy way for bash scripts to parse command line 
options without the usual `while`/`case` staircase.

There are other tools that do this (which have inspired it), but I 
wanted to see if it could be done in pure bash.

The main features are automatic validation of options and arguments and 
an automatic help message.

### Terse usage

The idea is to define your script's options and their nature in a single 
string. Newlines are used to separate options and commas are used to 
separate the different attributes of each option.

At minimum, one option with three values must be defined:

~~~ { .bash }
opts='some_flag, s, a simple flag'
~~~

This option is a simple boolean flag. Passing `--some_flag` or `-s` to 
your script should result in the variable `$some_flag` being set to
`true` when you `eval` the output of `yago 'myprog' "$opts" "$@"`.

Passing `-h` or `--help` would print

~~~ 
usage: myprog [ -s ]

options:
    -s, --some_flag         a simple flag

~~~

Even a complex parse becomes very short.

~~~ { .bash }
opts='
quiet, q, output less crap
files, f, list of files to process , REQUIRED, N, FILE
size , s, desired output size\, ok?, 150     , 1, SIZE, n_size
'
~~~

Whitespace is trimmed so you're free to align things as desired. Be sure 
to escape any commas or newlines that you do not want to signify an 
option or attribute delimitation.

This version defines 4 options.

The second line introduces a special value in the default field. 
`REQUIRED` means that no default is present because the flag requires 
its arguments be specified. Defining `REQUIRED` for an option that takes 
no arguments is dumb, but should be safe.

The number of arguments is defined in the next field. Another special 
value, `N`, states that 1 or more arguments are accepted (and possibly 
`REQUIRED`). If the value is numeric, the number is enforced and extra 
or missing arguments will result in an error when `yago` is called. 
Options that take arguments (even just one) always store as array 
variables.

The next field is used only by the automatic help message printing. If 
omitted (and the option takes arguments), it defaults to `<ARG>`. 
Ellipsis are also added if the option accepts 2 or more arguments.

The final field can be used to specify an alternative variable in which 
to store the value.

Passing `-h` or `--help` would show the following:

~~~ 
usage: myprog [ -q ] -f FILE ... [ -s SIZE ]

options:
    -q, --quiet             output less crap
    -f, --files FILE ...    list of files to process
    -s, --size SIZE         desired output size, ok?
~~~

When the program sees a `--` or an argument that doesn't belong 
elsewhere, processing stops and the remaining values are placed in an 
`args` array.

### Example

Given the above option string, the following call:

~~~ { .bash }
./yago 'testprog' "$opts" -f foo bar -s 10 -q some extra args
~~~

Would output

~~~ 
files=( "foo" "bar" )
size=( "10" )
quiet=true
args=( "some" "extra" "args" )
~~~

Which, when `eval`ed, would set the variables for use in the script.

### Requirements

Bash 4 for associative arrays.

### TODO

A lot...
