<!-- Description:Understanding chunks in Lua: local and global variable scope, loading, and execution chunks independently from the host program. -->

tags: lua beginner

# What are chunks in Lua?

**Chunk** is an independent compilation unit in Lua. In other words, chunk
is an independently executable sequence of statements. 

A chunk can be stored in a file or as a string within the host program. When
executing a chunk, Lua first loads it and precompiles the code into virtual
machine instructions (bytecode). Lua then interprets and runs this compiled
code on the virtual machine.

## Code example

A common sequence of statements, here variables `x` and `y` have been declared
without `local` keyword, so these are in the global scope.

```lua
x = 1              -- assignment statement
y = 2 * 10         -- assignment statement
if x < y then      -- if-else statement
	print("OK")      -- function call statement
else               -- if-else statement
	print("NOK")     -- function call statement 
end                -- if-else statement
```

`do-end` block can be considered a chunk because it has its own scope.
Variables declared as local `x` and `y`, thus both are in the chunks scope.

```lua
do                        -- do-end statement
	local x = 2 * 10        -- assignment statement
	local y = 1             -- assignment statement
	if x < y then           -- if-else statement
		print("OK in chunk")  -- function call statement
	else                    -- if-else statement
		print("NOK in chunk") -- function call statement 
	end                     -- if-else statement
end                       -- end of do-end statement
```
Combining two code snippets from above into one file. After execution of
the program expected output will be:

```lua
"OK"           -- x < y = 1 < 1024 (x and y have global scope)
"NOK in chunk" -- x < y = 1024 < 1 (x and y have chunk scope)
```

Functions in Lua are also chunks. Variable `x` in the scope of `addNumbers`
function.

```lua
local x = 10
function addNumbers(a, b)
  local x = a + b
  return x
end

addNumbers(10, 32) --> 42
print(x)           --> 10
```

## Loading chunks

Built-in functions `load`, 'loadfile', and `dofile` load or execute Lua code 
as chunk.

Consider:

```lua
local x = 100
local someChunk = [[
	local x = 25
	print(x)
]]

local chunk, err = load(someChunk, "example", "t")
if chunk ~= nil then
	chunk()
else
S	error(err)
end
print(x)

-- Output:
-- 25
-- 100
```

After this example should be very clear, that `x` inside a chunk (chunk is
a string `someChunk`) and `x` in the beginning of the snippet above are 
different variables in different scopes, despite the variable having the same
name.  So chunks have their own scope and are executed or compiled completely. 
independently, with own scope. Only the global variable `_ENV` shares the global
scope between whole program. `_ENV` is available in all chunks of the
program.

!!! tip
    It is a bad practice to change anything in the global variable `_ENV` 
    and change it. This might lead to unexpected results and hardly detectable bugs.

Similar functions `loadfile` and `dofile` work in very similar
way. Refer to the [Lua Manual](https://www.lua.org/manual/5.4/manual.html#pdf-load) for detailed documentation.

## Precompiled chunks

Chunks can be pre-compiled with the `luac` utility or `string.dump` function.
Usually pre-compiled code loads faster because Lua skips the compilation step.
Here comes a fair question. "Why not always use pre-compiled code?"
Because compiled binary bytecode is platform dependent. This means that,
compiled code on GNU Linux might not work in Microsoft Windows operating 
system.

## Chunks and Lua Command Line Client (CLI)

When using the CLI by running the command `lua` which opens the command-line
interface.  Every line entered was explicitly interpreted as a separate *chunk*.
To enter more statements, use the `do-end` statement.

Consider:

```text
lua
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
> local x = 10    -- chunk, x has scoped in the chunk
> print(x)
nil               -- x is nil because it is out of scope
> do              -- start do-end statement
>> local x = 10   -- x is scoped in the chunk
>> print(x)
>> end            -- end of do-end statement
10
> 

```

## References

- [Lua Manual: Chunks](https://www.lua.org/manual/5.4/manual.html#3.3.2)