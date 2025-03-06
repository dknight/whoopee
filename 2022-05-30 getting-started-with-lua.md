<!-- Description: Get stared with Lua programming language. A brief introduction to Lua language. Installation, compilation, REPL guide.-->

tags: lua beginner

# Getting started with Lua

This article was originally published on the
[Fedora Developer Project](https://developer.fedoraproject.org/tech/languages/lua/lua_installation.html),
but the website appears to be dormant and receives only infrequent updates. So
I moved this article to my personal blog with minor changes.

[Lua](https://www.lua.org) is a powerful, lightweight, interpreted scripting
language with a small footprint. It supports multi-paradigm programming:
procedural, object-oriented, functional, data-driven, and data-description.
Lua is rarely used as a stand-alone language. Instead, Lua focuses on
scripting, as a "secondary" language, which is integrated into other software
written in mainly C/C++.

Some examples of Lua's usage areas include: network software, video games,
user graphical interfaces, graphics/text processing software, etc. Lua is also
good for beginners to create simple video games.

Lua interpreter is written in ANSI C, and it is an tiny language.
Both the interpreter and the source code are only about 1 Mb. Lua is
considered one of the fastest interpreted languages.


## Checking Lua

Some distributions already have Lua pre-installed. Open your terminal and type:

```bash
lua
```

If the output is something like this:

```
Lua 5.4.6 Copyright (C) 1994-2023 Lua.org, PUC-Rio
>
```

Congratulations! Lua is already installed on your system and ready to use
<kbd>&gt;</kbd> means that you can type any Lua command.

!!! tip
    To exit Lua interpreter, press <kbd>Ctrl</kbd> +
    <kbd>D</kbd> or call `os.exit()` function from `os` module.

## Lua installation

If you see the message:

```bash
bash: lua: command not found
```

It means that Lua is not installed yet. The simplest way to install Lua from package manager `dnf`, which comes with Fedora. In your terminal, type then command:

Fedora/CentOS:

```bash
sudo dnf install lua
```

Debian/Ubuntu:

```bash
sudo apt-get install lua
```

Congratulations! Lua interpreter is installed!

## Compiling Lua (system-wide)

One of the best options is to compile Lua from source code. It is a very easy procedure.

* Be sure that you have installed [gcc](https://gcc.gnu.org/) on your system.
* Then get the latest [source code](https://www.lua.org/ftp/) of Lua.
* Consider version 5.4.6.

```bash
tar xvf lua-5.4.6.tar.gz
cd lua-5.4.6
make install
```

Congratulation! You have compiled and installed Lua on your machine.

### Compiling Lua locally

You can compile Lua in your local directory, not globally.
All you need to do is just use the `make` command with `local` argument.

```bash
make local
```

## Lua syntax

Lua syntax is very similar to languages like Python, Ruby and C. For details,
[check my syntax cheatsheet](/lua-syntax-cheatsheet.html) or [official Lua
manual](https://www.lua.org/manual/5.4/manual.html).

### Learning Lua

Lua is very fun and simple to learn, but it is hard to master. Here is an
example of classical `Hello World` program:

```lua
print("Hello, world!")
```

An example of the program to calculate factorial, from the book [Programming
in Lua](https://www.lua.org/pil/1.html).

```lua
function fact (n)
  if n == 0 then
    return 1
  else
    return n * fact(n-1)
  end
end

print("enter a number:")
a = io.read("*n") -- read a number
print(fact(a))
```
