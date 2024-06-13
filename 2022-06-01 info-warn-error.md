<!-- Description: Lua has some useful functions for debugging and error handling: print, warn, and error. Here are some tricks to using them. -->

tags: lua

# warn, error and print functions in Lua


Lua has some useful built-in functions for debugging and error handling:
`print`, `warn`, and `error`. Here are some tricks to using them.

## print

**Never underestimate the power of `print` function in debugging!**

[`print`](https://www.lua.org/manual/5.4/manual.html#pdf-print) is one of the
simplest ways to debug a program and print the intermediate results. The
function prints a list of tab-separated arguments as strings to `stdout` and
adds the line-ending symbol to the end of the output.

Consider:

```lua
print() --> prints empty line
print("") --> prints empty line
print("Hello") --> Hello
print("Hello", " ", "World", 42) --> Hello	World	42 (tab separated)
```

Complex data structures, such as tables, cannot be printed using the `print`
function. For the complex data structures, it prints the address in the
computer's memory. To print out a table, you need to use loops, 3rd party
libraries, or your homemade solutions. Lua is supposed to be as minimal
as possible, and there is no magic function like `console.log()` in JavaScript.

Consider:

```lua
local t = {name = "Jonh", age = 25}
print(t) --> table: 0x557cfeb01d70

local fn = function() return 1 + 1 end
print(fn) --> function: 0x557cfeb034a0

-- Simple one-level table print
for k, v in pairs(t) do
	print(k, v)
end
-- Outputs (order changes):
--	"name"	"John"
--	"age"	25
```

## warn

Lua 5.4 introduces the
[`warn`](https://www.lua.org/manual/5.4/manual.html#pdf-warn)
function, which allows the user to output warning
messages to `stderr` when warning output has been turned on.

### Enable and disable warnings

You can enable or disable warnings inside your program's code with
`@on` or `@off` arguments.

Consider:

```lua
warn("Clean the room") --> empty output
warn("@on") --> Warnings are enabled
warn("Clean the room again") --> Lua warning: Clean the room again
warn("@off") -> Warnings are disabled
warn("Once again clean room") --> empty output
```

Another option to enable warnings' emission in run a program with
<kbd>-W</kbd> flag.

Consider **test.lua**:

```lua
-- Your amazing code here ...
warn("Clean the room")
-- Also your amazing code here ...
```

Shell/Bash:

```bash
lua -W test.lua
Lua warning: Clean the room
```

### warn multiple arguments

All arguments should be strings and all string arguments are concatenated
into one string.

Consider:

```lua
warn("@on")
warn("Foo", "Bar", "Xyzzy") --> Lua warning: FooBarXyzzy
```

## error

[error](https://www.lua.org/manual/5.4/manual.html#pdf-error) function raises
the error and, by default, it stops the program execution. The function
accepts 2 arguments: the message as a string and an error level number (0, 1,
2). The level argument specifies how to get the error position.

- Level 0: Skips the addition of error position information to the message.
- Level 1 (default): The error position is where the `error` function was
  called.
- Level 2: Points to where the function that called `error`
  was called. This level shows the stack of function calls. It might be
  very useful to check the call stack and find what caused the error.

If `error` function is called in the main program, it prints the error and
stops the program execution.

Examples:

#### Level 0:

```lua
error("Something is wrong", 0)

--[[
Something is wrong
stack traceback:
  [C]: in function 'error'
  stdin:1: in main chunk
  [C]: in ?
--]]
```

#### Level 1 (default):

```lua
error("Something is wrong")
--[[
stdin:1: Something is wrong
stack traceback:
  [C]: in function 'error'
  stdin:1: in main chunk
  [C]: in ?
--]]
```

#### Level 2:

```lua
f = function() error("Error from f()", 2) end
g = function() f() end
g()
--[[
stdin:1: Error from f()
stack traceback:
[C]: in function 'error'
stdin:1: in function 'f'
stdin:1: in function 'g'
(...tail calls...)
[C]: in ?
--]]
```

### Catch errors with _protected call_

In Lua language, you can use [pcall()](https://www.lua.org/manual/5.4/manual.html#pdf-pcall)
function to catch errors. This is called a _protected call_. `pcall()` returns
two values: the first is a boolean status which determines whether the call was
successful or not, and the second value is a return string of an error message.
When using _protected call_ the program catches the error and continues to execute.

Failed call:

```lua
local cube = function(a)
  return a * a * "a"
end
local success, result = pcall(cube, 10)
print(success, result)
--> false test.lua:2: attempt to mul a 'number' with a 'string'
```

Artificially failed call:

```lua
local err = function()
  error("Sonething went wrong")
end
--> false test.lua:2: Sonething went wrong
```

Successful case:

```lua
local cube = function(a)
  return a * a * a
end
local success, result = pcall(cube, 10)
print(success, result)
--> true 1000
```

The common case might be like in this example:

```lua
local cube = function(a)
  return a * a * a
end
local success, result = pcall(cube, 10)

if (success) then --> 1000
  print(result)
else
  error(result) --> error message
end
```

There is also a function [xpcall()](https://www.lua.org/manual/5.4/manual.html#pdf-xpcall).
It is similar to `pcall()`, but also accepts the error handler, which might
be defined as a common error handler in your program or project.

Consider:

```lua
local error_hander = function(e)
  return "Error handler says: " .. e
end
local cube = function(a)
  return a * a * a
end
local success, result = xpcall(cube, error_hander, "a")

if (success) then --> 1000
  print(result)
else
  error(result)
end

--[[ output
lua: test.lua:12: Error handler says: test.lua:5: attempt to mul a 'string' with a 'string'
stack traceback:
  [C]: in function 'error'
  test.lua:12: in main chunk
  [C]: in ?
--]]
```

## Links

- [Lua manual: Error Handling](https://www.lua.org/manual/5.4/manual.html#2.3)