<!-- Description: A step-by-step guide how to compile the Lua programming language interpreter for MS-DOS or FreeDOS. -->

tags: lua misc

# Compiling Lua for MS-DOS/FreeDOS

One cold spring day, while playing classic DOS games like *Wolfenstein 3D*, *Doom*, and *Mortal Kombat II*, I had a crazy idea—what if I could run the Lua programming language on DOS? Lua is lightweight, takes up very little memory, and is written in C. In theory, it should be possible to run it on any DOS-like operating system.

As I started researching, I realized I wasn’t the only one with this idea. I came across a developer from the United Kingdom who had already [solved the problem](https://mathr.co.uk/blog/2022-05-11_lua_on_freedos.html) for Lua 5.4.4.

Building on [Claude](https://mathr.co.uk/web/)’s solution, I made some minor modifications and improvements. Since I didn’t have an old machine, I had to run it on a modern computer via a USB flash drive. I tested the solution on three different setups:

- [FreeDOS 1.3](https://freedos.org)
- [MS-DOS 6.22](https://winworldpc.com/product/ms-dos/622)
- [DOSBox](https://www.dosbox.com/download.php?main=1)

All three ran Lua 5.4.7 without any issues, at least none that I’ve found so far!

## Preparing hardware/software

Me (as you probably as well) do not have a 30-40-year-old machine to install DOS on hardware.  Then a handy USB drive can [boot FreeDOS on a modern PC](/post/how-to-create-bootable-freedos-usb-flash-drive-from-linux.html).

Another option is to use [DOSBox](https://www.dosbox.com/download.php?main=1) emulator for the DOS operating system.

## Issues

[Claude](https://mathr.co.uk/blog/2022-05-11_lua_on_freedos.html) fixed many issues in Lua’s source code to make it compatible with *Turbo C*, which I used as a foundation while making additional minor modifications to the C code.

The main issue here is that Borland Turbo C's `offsetof` function is broken. As a workaround, Claude (thanks a lot!) defines it as `OFFSETOF`:

```diff
+#define OFFSETOF(T,f) ((size_t)(char *)&(((T*)(void*)0)->f))
```

Another challenge is the absence of locale support in DOS, which is inherently a Unix/Linux concept. To work around this, locale-related methods and constants are simply mocked in `luaconf.h`, and an empty `locale.h` file is placed in the source code directory to allow inclusion without errors.

```diff
+#define CLOCKS_PER_SEC CLK_TCK
 
-
+/* locale */
+#define LC_ALL 0
+#define LC_COLLATE 1
+#define LC_CTYPE 2
+#define LC_MONETARY 3
+#define LC_NUMERIC 4
+#define LC_TIME 5
+#define strcoll strcmp
+#define setlocale(x,y) ("C")
+#define mktime(x) (-1)
+#define strftime(x,y,z,w) (0)
 
 #endif
```

- [Download my modified patch](https://github.com/dknight/lua-for-dos/blob/main/lua-5.4.7-for-dos-with-borland-turbo-c-2.01.patch) lua-5.4.7-for-dos-with-borland-turbo-c-2.01.patch


After numerous attempts and failures—mostly due to frustrating `out-of-memory` errors—I also discovered that line endings differ between DOS and Unix/Linux. The `unix2dos` command is a helpful tool for converting them, but for some reason, it didn't completely resolve the issue. As a workaround, I passed the `--binary` flag to the `patch` utility.

You can find the scripts in the [GitHub repo *lua-for-dos*](https://github.com/dknight/lua-for-dos).

## The process

### Step 1

- Download *Borland Turbo C* and Lua source code;
- prepare Lua source code on the GNU/Linux machine.

- [`prepare.sh`](https://github.com/dknight/lua-for-dos/blob/main/prepare.sh): downloads required software and patches the source code. Runs on the GNU/Linux machine.

```shell
... downloading sofwtare ...
tar -xvf "$LUA.tar.gz"
mv "$LUA" lua

echo '/* blank */' > lua/src/locale.h
cd lua/
unix2dos src/* 
unix2dos ../lua-5.4.7-for-dos-with-borland-turbo-c-2.01.patch
patch -p1 -i "../lua-5.4.7-for-dos-with-borland-turbo-c-2.01.patch" --binary
```

!!! tip
	You can try to compile Lua with `LUA_32BITS` enabled, but for some reason it does not work in FreeDOS. Here is a
	32-bit patch [lua-5.4.7-for-dos-with-borland-turbo-c-2.01.patch32bits](https://github.com/dknight/lua-for-dos/blob/main/lua-5.4.7-for-dos-with-borland-turbo-c-2.01.patch32bits).

## Step 2

Compile under DOS by running the [`COMPILE.BAT`](https://github.com/dknight/lua-for-dos/blob/main/COMPILE.BAT). This DOS batch file should be run inside a DOS environment; it won’t execute on the GNU/Linux machine.

```batch
PATH=C:\TC
CD C:\LUA\SRC
TCC -w- -ms- -mh -I. -c *.c
DEL LUAC.OBJ
TCC -w- -ms- -mh -eLUA.EXE *.obj
DEL LUA.OBJ
TCC -w- -ms- -mh -I. -c LUAC.C
TCC -w- -ms- -mh -eLUAC.EXE *.OBJ
CD ..
MKDIR BIN
COPY SRC\LUA.EXE BIN
COPY SRC\LUAC.EXE BIN
CD BIN
LUA
```

[Download Lua binaries compiled for DOS](https://github.com/dknight/lua-for-dos/raw/refs/heads/main/bin/LUA4DOS.ZIP)

## Video demonstration

The compilation actually takes 5–10 minutes, depending on the machine. I tried to keep the videos under one minute.

### DOSBox

<video width="854" height="480" controls>
	<source src="/assets/video/luadosbox.mp4" type="video/mp4">
	Your browser does not support the video tag.
</video>

### PC

<video width="406" height="700" controls>
	<source src="/assets/video/luados.mp4" type="video/mp4">
	Your browser does not support the video tag.
</video>

## References

- [A definitive guide for compiling Lua from source code](/post/a-definitive-guide-for-compiling-lua-from-source-code.html).
- [Claude Heiland-Allen's post: Lua on FreeDOS](https://mathr.co.uk/blog/2022-05-11_lua_on_freedos.html)
- [A Step-by-Step Guide to Creating a Bootable FreeDOS Flash Drive with a Live CD](/post/how-to-create-bootable-freedos-usb-flash-drive-from-linux.html)