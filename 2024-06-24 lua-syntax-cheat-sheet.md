<!-- Description: Very brief syntax cheat sheet of Lua language syntax. -->

tags: lua

# Lua Syntax Cheat Sheet (Short Version)

[TOC]

This is a short version of the [full Lua cheatsheet](/post/lua-cheatsheet.html).

[PDF Version](/assets/docs/Whoopee-Lua-Cheetsheat.pdf)

## Comments

```lua
-- Single line comment

--[[
	Block comment
	Everything inside this block is
	treated as a comment
--]]
```

## Variables

```lua
numValue = 42  -- number (integer)
numFloatValue = 10.37 -- number (float)
stringValue = "Hello World!" -- string
boolValue = true -- boolean
```

## String

```lua
-- String concatenation operator ..
"Hello" .. " " .. "World" -- "Hello world"
```

## Arithmetics

```lua
num = 1
num = num + 1 -- increment
num = num - 1 -- decrement 
num = 42 + 10 -- addition
num = 42 * 10 -- multiplication
num = 42 % 10 -- modulus
num = 42 - 10 -- subtraction
num = 42 / 10 -- division
num = 2 ^ 10  -- power
```

## Conditionals

```lua
if num == 0 then
	primt("num is equal 0")
end

if num > 1 then
	primt("num is greater than 1")
elseif num < 1 then
	print("num is less than 1")
else
	print("num is equal to 1")
end
```

## Loops

```lua
while num < 50 do
	print(num)
	num = num + 1
end

-- First parameter: start
-- Second paramenter stop
-- (Optional, default = 1) Third parameter: step
for i = 1, 100, 1 do
	print(num)
	num = num + 1
end

repeat
	print(num)
	num = num + 1
until num > 10
```

## Tables

!!! note
    Tables in Lua language begins with 1.

```lua
t = {} -- Creates empty table (table constructor)
t[1] = "a" -- Put character 'a' at index 1

t["lua"] = 20 -- `t` contains 20 at index "lua"
t[1] = nil -- Removes value stored at index 1

t.name = "Victoria"  -- t["name"] contains string "Victoria"

t2 = {2, 3, 4} -- Creates table with 2 stored at index 1,
               -- 3 stored at index 2, and 5 at index 3

-- Iterate through all values in a table.
-- i current index
-- n value at current index
for i, n in ipairs(t2) do
	print(i, n)
end

-- # table size
print(#t2) -- prints 3
```

## Functions

```lua
function isNegative(n)
	return n < 0
end

isNegative(-42) -- returns true
isNegative(42)  -- returns false

-- Multiple arguments
function fullName(firstName, lastName)
	return string.format("%s %s", firstName, firstName)
end

-- Assign function to a variable.
negFn = isNegative
negFn(20) -- Returns false
```