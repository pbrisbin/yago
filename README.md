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

Define your script's options and their nature in a single string.

Newlines are used to separate options and commas are used to separate 
the different attributes of each option. These values must be escaped if 
used not as a delimitation.

At minimum, one option with three values must be defined:

~~~ { .bash }
opts='some_flag, s, a simple flag'
~~~

This option is a simple boolean flag. Passing `--some_flag` or `-s` to 
your script should result in the variable `$some_flag` being set to
`true` when you execute `yago_parse 'myprog' "$opts" -s`.

If omitted, the default value will be assigned to the variable (which 
for argument-less options is `false`).

Note: the long option will become a variable in your script so it is 
subject to any limitations bash places on variable names (for now).

Passing `-h` or `--help` to would print and automatically generated help 
message:

~~~ 
usage: myprog [ -s ]

options:
    -s, --some_flag         a simple flag

~~~

Through this system, even a complex parse becomes very short.

~~~ { .bash }
opts='

    quiet, q, output less crap
    files, f, list of files to process , REQUIRED, N, FILE
    size , s, desired output size\, ok?, 150     , 1, SIZE, n_size

'
~~~

Whitespace is trimmed so you're free to align things as desired for 
readability.

This version defines 3 options.

The second definition introduces a special value in the default field. 
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
to store the value (this feature is not implemented yet).

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
`args` array. You are free to use or ignore these extra values.

### Example

Typical usage would be:

~~~ { .bash }
#!/bin/bash

opts=' ... '

source yago

yago_parse 'testprog' "$opts" "$@"

# continue program knowing that options have been parsed and variable 
# have been set according the your $opts declaration...
~~~

So, given our example option string, the following call:

~~~ { .bash }
yago_parse 'testprog' "$opts" -f foo bar -s 10 -q some extra args
~~~

Would be exactly equivalent to doing

~~~ 
files=( "foo" "bar" )
size=( "10" )
quiet=true
args=( "some" "extra" "args" )
~~~

directly.

Please read and play with `./example.sh` for the most up to date usage example.

### Requirements

Bash 4 for associative arrays.

### TODO

* support grouped options like (think `ls -la`)
* implement custom variables (like `n_size` in the example)
* think through various required/optional scenarios
* test more non-best-case scenarios (beef up example.sh for automated 
  testing)
