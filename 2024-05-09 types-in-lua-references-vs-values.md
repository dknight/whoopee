<!-- Description: Explanation of what means 'pass by value' and 'pass by reference' in Lua language. Difference between simple values and reference types. -->

tags: lua beginner

# Types in Lua: References vs Values

[TOC]

Sometimes it is confusing for beginners to understand how the argument is
passed to a function. Usually, there are the phrases "*passed by reference*"
and "*passed by value*" without a concrete explanation. It is my attempt to
explain the topic in very simple terms.

## Lua is a dynamically typed language 

First of all, Lua is a dynamically typed language. This means that variables
do not have types; **only values do**. All values in Lua are first-class
citizens, which means that all values can be stored in variables and passed to
functions as arguments.

## Types in Lua

There are eight (8) basic types in Lua: `nil`, `boolean`, `number`, `string`,
`table`, `function`, `userdata` and `thread`.

Values with types: `table`, `function`, `userdata` and `thread` are objects,
these do not contain values, but only the
**reference (location, address) in the computer's memory**.
The variables with these four (4) types are passed by reference.

Consider:

```lua
local t = { hello = "world" }
print(t) --> table: 0x55d95d5136f0
```
`0x55d95d5136f0` is the address in the memory.

Correspondingly values with type: `nil`, `boolean`, `number` and `string` are
passed **by value**

## Pass by value

Values with type: `nil`, `boolean`, `number` and `string` are passed
**by value**.

Consider:

```lua
local x = 10 -- number

local function double(x)
	x = x * 2
	return x
end

print(x) -- 10
print(double(x)) -- 20
print(x) -- 10 (not changed)
```

When we pass by value, the initial value of `x` has not changed (not mutated),
the value is just copied into the argument.

## Pass by reference

We know that values with types: `table`, `function`, `userdata` and `thread`
are passed by reference because these do not contain values only the addresses
in the memory.

Consider:

```lua
local t = {}

local function addToTable(t, v)
	t[#t + 1] = v
end

-- initially empty table
print(#t, t[#t]) --> 0	nil

-- pass table as the first argument
addToTable(t, "some value")

-- here the initial t is changed (mutated)
print(#t, t[#t]) --> 1	"some value"
```

The reference type `table` holds the address in memory. After the change,
**the address in memory stays unchanged, but the content in memory is changed (mutated)**.

## Table to memoize

| Value   | Reference |
|:--------|:----------|
| nil     | table     |
| boolean | function  |
| string  | thread    |
| number  | userdata  |

## Conclusion
For a better understanding of this topic it is strongly recommended (maybe read even
several times) [the corresponding topic in Lua manual](https://www.lua.org/manual/5.4/manual.html#2.1).

## References

- [Lua manual: Values and Types](https://www.lua.org/manual/5.4/manual.html#2.1)
