<!-- Description: Understanding global variables for _ENV and _G in Lua language. It is important to understand the best practices of using global variables and what to avoid.  -->

tags: lua beginner

# Understanding globals _ENV and _G

To write effective Lua programs, it is important to understand the purpose of two special tables: `_ENV` and `_G.` Every
Lua script/program operates within the context of these tables, which store nearly all values and functions. Lua has
three main types of variables: *global variables*, *local variables*, and *table fields*. Let’s take a closer look at
each of them.

## What are global variables in Lua?

In Lua, if you assign a value to a variable without explicitly declaring it as `local`, it becomes a global variable by
default. Global variables are stored in a global environment, which is essentially a table `_G` that holds all global
names—both functions and variables.

Consider:

```lua
x = 10  -- This is a global variable
print(_G.x) -- 10
print(x) -- 10
print(_G.print(x)) -- 10
```

## What are local variables in Lua?

Local variables are the variables that are declared with keyword `local` and these have lexical scope. Local variables are
faster and safer because they are not accessible from outside their scope. Consider:

```lua
local x = 10
function getX()
	local x = 20
	return x
end
print(x) -- 10
print(getX()) -- 20
```

Inside the `getX()` function `x` has its own scope and is visible only inside the function block. Same as for the
`if-else` statements:

!!! tip
    Every [chunk](/post/what-are-lua-chunk.html) in Lua has own local variables.

```lua
local x = 10
if x == 10 then
	local x = 50
end
print(x)
```

`x` is still 10, because inside the `if` block `x` is a local variable and visible only inside the`if` block.

## What table fields variables in Lua?

Any table key-value pair is the variable with its own value. Undefined variables in Lua are always `nil`.

Consider:

```lua
local t = {}
t.x = 10
print(t.x) -- 10
print(t.y) -- nil
print(t.z) -- nil
```

## `_ENV` and `_G` tables

`_ENV` table it is a table that defines the environment in which code runs. By assigning a new table to `_ENV`, you
can sandbox or restrict access to globals. This feature is especially useful for creating safe environments when
running untrusted code. By assigning a new table to `_ENV`, you can sandbox or restrict access to globals.

```lua
_ENV = { print = print } -- only print is accessible in this environment

print("Hello")   -- Works
math.sqrt(9)     -- Error: math is nil
```

`_G `is a predefined global variable that refers to the table containing all other global variables. Consider:

```lua
print(_G["print"]) 
```

In Lua, the global variable `_G` is initialized with this same value. `_G` is never used internally, so changing
its value will affect only your **own code**. Moreover, `_G` also contains reference to itself[^1].

```lua
print(_ENV, _G) 			-- table: 0x30d14c50	table: 0x30d14c50
print(_ENV._G, _G._G._G) 	-- table: 0x30d14c50	table: 0x30d14c50
```

## Best practices

While globals can be convenient, overusing them can lead to hard-to-maintain code, unexpected behaviors, and
hard-to-detect bugs. Following best practices, you can avoid common pitfalls and write safer programs. Always prefer
local variables and treat globals as a shared resource—use them sparingly and intentionally.

1. Use local variables whenever possible.
2. Explicitly declare globals if needed, e.g. `global_x = 10` or `globalX = 10`.
3. Use `_ENV` for namespacing or sandboxing only. 

```lua
local safeENV = {
	print = print,
	tostring = tostring
}

_ENV = safeENV

print(tonumber)  -- nil
print(type)      -- nil
print(print)     -- function: 0x00000001
print(tostring)  -- function: 0x00000002
```

4. Do not overuse tables `_ENV` and `_G` to keep your code more transparent and easy to maintain. It is easy to make
  a mess with globals.
5. Be careful when changing variables inside blocks; it is easy to accidentally make side effects.

```lua
local x = 10
function getX()
	x = 40 -- side effect overrides local variable that is declared at upper level.
end
getX()
print(x) -- 40
```

## References

[^1]: [Lua Manual: 2.2 Environments and the Global Environment](https://www.lua.org/manual/5.4/manual.html#2.2)
[^2]: [Lua Manual: 3.2 Variables](https://www.lua.org/manual/5.4/manual.html#3.2)