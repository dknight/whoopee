<!-- Description:Understanding chunks in Lua: local and global variable scope, loading, and execution chunks independently from the host program. -->

tags: lua beginner

# Using Lua Command Line Client (CLI)

Lua is an amazing, performant, and very lightweight scripting language, and 
why not to use these advantages for daily automation jobs? Lua package 
shipped with interpreter and can be very easily used from the command line.

Installation of Lua CLI is very straightforward; for Linux, you might have
root privileges or use the `sudo` command:

Ubuntu or Debian-based GNU Linux

```sh
apt install lua
```
Fedora or RPM-based GNU Linux

```sh
dnf install lua
```

Arch GNU Linux

```sh
pacman -S lua
```

Mac OS with [brew](https://brew.sh/)
```sh
brew install lua
```

Microsoft Windows Lua binaries can be found on
[SourceForge](https://luabinaries.sourceforge.net/download.html).

After installing or [compiling Lua from source code](http://localhost:8000/post/a-definitive-guide-for-compiling-lua-from-source-code.html), `lua`
(for Microsoft Windows, `lua.exe` or similar) is available.

!!! tip
      Be sure that `lua` is located in the `PATH` environment variable.
      File can start with a line and execute it on any Unix-like platform.

      <code>#!/usr/bin/env lua</code>
      
      Lua skips the first line of a file if it starts with `#`.


```text
lua
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
>
```

Output of the `lua` command, it runs the interpreter in interactive mode
default. Symbol `>` means: waiting for the input. Here Lua language
commands can be entered like:

```text
> 1 + 23
24
> "hello" .. " " .. "world"
hello world
>
```

To quit interactive mode, press on the keyboard <kbd>Ctrl</kbd>+<kbd>D</kbd>.

Every line is interpreted as [single chunk](/post/what-are-lua-chunk.html),
so this means every statement has its own scope.

Consider:

```text
lua
> local x = 10
> local y = 32
> x + y
stdin:1: attempt to perform arithmetic on a nil value (global 'x')
stack traceback:
        stdin:1: in main chunk
        [C]: in ?
```

To enter multiline code, use the `do-end` statement:

```text
lua
> do    
>> local x = 10
>> local y = 32
>> print(x + y)
>> end
42
>
```

Notice the symbol `>>` means continue the statement. Other ways to enter 
multi-statement command in single line use `;` (semicolon) as statements
separator.

If this is still not clear, read the post about [chunks](/post/what-are-lua-chunk.html).

```text
lua 
> local x = 10; local y = 32 print(x + y);
42
>
```

## Options aka flags

`lua` command has some options to run with; to see help, enter into terminal
`lua --help`:

```text
lua --help
lua: unrecognized option '--help'
usage: lua [options] [script [args]]
Available options are:
  -e stat   execute string 'stat'
  -i        enter interactive mode after executing 'script'
  -l mod    require library 'mod' into global 'mod'
  -l g=mod  require library 'mod' into global 'g'
  -v        show version information
  -E        ignore environment variables
  -W        turn warnings on
  --        stop handling options
  -         stop handling options and execute stdin
```

- **-e**: execute statement;

```text
lua -e 'print(400 + 10 * 4)'
440
>
```
- **-i**: interactive mode will be active after execution of `script.lua`, 
 and you can continue entering commands.

```text
lua -i tt.lua 
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
>
```

- **-l mod** extra 3rd party any *home-made* module `mod` can be
  included in the script.

```text
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
> print(socket)
table: 0x1a50350
> 
```

- **-l g=mod** same as above, but `mod` will be stored in the variable `g`,
  (This form was introduced in release 5.4.4):

```text
lua -i -l soc=socket 
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
> print(soc)
table: 0x11524c0
> 
```
- **-v** prints the version of Lua and exits the program;

```text
lua -v
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
```
- **-E** ignore environment variables; This flag is a bit confusing.
 This means that you can still read environment variables with function
 `os.getenv('USER')`, but variables such as `LUA_PATH` and `LUA_CPATH` are ignored.

Example:

```text
lua -E -l socket
lua: module 'socket' not found:
        no field package.preload['socket']
        no file '/usr/local/share/lua/5.4/socket.lua'
        no file '/usr/local/share/lua/5.4/socket/init.lua'
        no file '/usr/local/lib/lua/5.4/socket.lua'
        no file '/usr/local/lib/lua/5.4/socket/init.lua'
        no file './socket.lua'
        no file './socket/init.lua'
        no file '/usr/local/lib/lua/5.4/socket.so'
        no file '/usr/local/lib/lua/5.4/loadall.so'
        no file './socket.so'
stack traceback:
        [C]: in function 'require'
        [C]: in ?
```

It cannot find the `socket` module because `LUA_PATH` is ignored. This cause
the error.

- **-W** turn warnings on; the built-in function `warn` will start to output
messages. I have a [post about warnings](/post/info-warn-error.html).

- **-**, **--** both work the same as in the bash command line. Check the [GNU bash manual](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html) for more details.

## References

- [Lua Manual: Standalone](https://www.lua.org/manual/5.4/manual.html#7)
- [Shell Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html)

*[CLI]: Command Line Interface
