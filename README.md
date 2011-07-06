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

Yago will read your script's options and their nature from a single 
string fed to it via `stdin`.

Newlines are used to separate options and commas are used to separate 
the different attributes of each option. These values must be escaped if 
not used as a delimitation.

At minimum, one option with three values must be defined:

~~~ { .bash }
'some_flag, s, a simple flag'
~~~

This option is a simple boolean flag.

Passing `--some_flag` or `-s` to your script will result in the variable 
`$some_flag` being set to `true`.

If that flag is omitted, the default value will be assigned to the 
variable (for argument-less options, this would be `false`).

Note: the long option will become a variable in your script so it is 
subject to any limitations bash places on variable names (for now).

Through this system, even a complex parse becomes very simple:

~~~ { .bash }
yago_parse 'myprog' "$@" << EOF

    quiet, q, output less crap
    files, f, list of files to process , REQUIRED, N, FILE
    size , s, desired output size\, ok?, 150     , 1, SIZE, n_size

EOF
~~~

Whitespace is trimmed so you're free to align things as desired for 
readability.

This version defines 3 options.

The second definition introduces a special value in the default field. 
`REQUIRED` means that no default is present because the flag requires 
its arguments be specified.

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

Passing `-h` or `--help` would show the following automatically 
generated help message:

~~~ 
usage: myprog [ -q ] -f FILE ... [ -s SIZE ]

options:
    -q, --quiet             output less crap
    -f, --files FILE ...    list of files to process
    -s, --size SIZE         desired output size, ok?
~~~

When the `yago_parse` sees a `--` or an argument that doesn't belong 
elsewhere, processing stops and the remaining values are placed in an 
`args` array. You are free to use or ignore these extra values.

So, given this small call to `yago_parse`, and given that `"$@"` held `{ 
-f foo bar -s 10 -q some extra args }` (for example), the outcome would 
be exactly as if you had done

~~~ 
files=( "foo" "bar" )
size=( "10" )
quiet=true
args=( "some" "extra" "args" )
~~~

directly.

### Requirements

Bash 4 for associative arrays.

### TODO

* support grouped options (think `ls -la`)
* implement custom variables (like `n_size` in the example)
* think through various required/optional scenarios
* test more non-best-case scenarios (beef up example.sh for automated 
  testing)
