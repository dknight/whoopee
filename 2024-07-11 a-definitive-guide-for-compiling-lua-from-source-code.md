<!-- Description: Compiling Lua from the source code is an extremely easy procedure and every beginner in programming can do it, without any problems. Here is a detailed guide on how to compile Lua from the source code. -->

tags: lua beginner

# A definitive guide for compiling Lua from source code

<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>

[TOC]

Compiling Lua from the source code is an extremely easy procedure and every beginner
in programming can do it, without any problems. I would introduce my guide on how
to compile Lua from the source code.

## Prerequisites

- Source Code;
- C compiler;
- Make utility (optional, usually together installed with C compiler);
- `tar` command installed or any other archive manager which supports `.tar` format (optional).

### Download the source code

Lua is a completely [free-to-use language (MIT license)](https://opensource.org/license/mit)
and its source code can be downloaded
from [the official website](https://www.lua.org/ftp/). Let's assume that we use
the latest version in this case it is `5.4.7`.

### Compiler

Lua is written in [ANSI C](https://en.wikipedia.org/wiki/ANSI_C), so we will need
any C compiler that can compile ANSI C code. I prefer to use
[https://gcc.gnu.org/](https://gcc.gnu.org/).

#### Linux

For Debian-based GNU/Linux, you can install it with `apt` command:

```sh
sudo apt install build-essential
```

For the GNU/Linux using a DNF package manager like Fedora:

```sh
sudo dnf install gcc
```

#### MacOS

- On MacOS need to have [brew package manage](https://brew.sh) then use the command:

```sh
brew install gcc
```

- Also, XCode Command Line Tools is needed for MacOS.

```sh
xcode-select --install
```

#### Windows

For Windows, there might be different options: [MinGW](https://sourceforge.net/projects/mingw/),
[BPF Compiler Collection (BCC)](https://github.com/iovisor/bcc), etc.

!!! tip
    Windows users probably should follow different procedures. Lua initially is 
    designed to run on a Unix-like system, but the general logic should be 
    very similar to Microsoft Windows.

## Compilation

After we download the [source code](https://www.lua.org/ftp/), follow the
steps from a terminal:

- Go to the Download directory (let us assume that it is `~/Downloads/`).

```sh
cd ~/Downloads/
```

- Extract contents for the archive `lua-5.4.7.tar.gz` with `tar` command or
  any other your archive manager:

```sh
tar xvf lua-5.4.7.tar.gz
```

- A new directory `lua-5.4.7/` with Lua's source code is created.

```sh
ls -l
> doc/
> src/
> Makefile
> README
```

### Building Lua

There is a command to detect your OS `make help` will print the supported operating
systems.

```sh
make help
> guess aix bsd c89 freebsd generic ios linux linux-readline macosx mingw posix solaris
```

Let's assume that we are on Linux and we have to use 4 threads for `make`.

```sh
make -j4 linux
```

Once it is compiled it can be installed also with `make`:

```sh
sudo make install
```

By default (`INSTALL_TOP=/usr/local`) following files will be installed:

- `lua, luac` -> `/usr/local/bin`
- `lua.h, luaconf.h, lualib.h, lauxlib.h, lua.hpp` -> `/usr/local/include`
- `liblua.a` -> `/usr/local/lib`
- `lua.1, luac.1` -> `/usr/local/man/man1`

There is possible to change the path where Lua is installed, where `xxx` is 
the desired path in the file system.

```sh
INSTALL_TOP=xxx make install
```

## Testing installation

Now Lua is available in your system:

```text
lua -v
> Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
```

If you see similar output in the terminal then congratulations you have compiled
and installed Lua from the source code successfully!

## Getting help

In case you get stuck, then open the file in the downloaded source code directory `doc/readme.html`.
This readme is a good starting point to get help.

## Advanced compilation

There is an option to set up Lua compilation with a variety of needs. For example,
change the default buffer size or use only integers for numbers, change integer
size to 32, 64-bits (with some tricks even 8 and 16 bits), float precision, memory limits, and lots more.
Such a custom setup might be useful for microcontrollers and other IoT microdevices.

There is a file `src/luaconf.h` where all such settings are set. The file
is pretty large and there is no point to go here through it. I would recommend opening
in your text editor and just going through and checking what potential options are
there.

Modifying `src/luaconf.h` is a good practice to try different setups and help better
understand does Lua works internally.

*[IoT]: Internet Of Things