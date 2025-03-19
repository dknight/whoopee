<!-- Description: By default, Lua does not provide a built-in tool to print the structure of a table. While there are many existing solutions available online, this tutorial will guide you through creating your own custom function to inspect and display Lua tables in a clear and readable format. By implementing this yourself, you'll gain a deeper understanding of Lua tables and how to work with them efficiently. -->

tags: lua beginner

# Printing a table in Lua tutorial

<div>
<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>
</div>
[TOC]

## The problem

Beginners are often confused when they have a table, like:

```lua
local person = {
	firstname = "John",
	lastname = "Doe",
	age = 33,
}
```

...and try to print it:

```lua
print(person) --> table: 0x2733d5b0
```

...only to get something like `table: 0x2733d5b0`. **What is it?**

- **table**: type, that we are dealing with a table.;
- **0x2733d5b0**:  the memory address where the table is stored. In Lua, a `table` is a [reference type](https://www.whoop.ee/post/types-in-lua-references-vs-values.html). 

We can <span id=":iterate">iterate over a table</span> using a [`for loop`](https://www.lua.org/manual/5.4/manual.html#3.3.5) and key-value pairs.

```lua
for key, value in pairs(t) do
	print(key, value)
end 
--Output:
--firstname	John"
--lastname	"Doe"
--age	33
```

This seems to be OK, unless we have a nested table; consider:

```lua
local person = {
	firstname = "john",
	lastname = "doe",
	 age = 33,
	hobbies = {
		"painting",
		programming = {
			Lua = {
				skill = 7,
				years = 5
			},
			C = {
				skill =  2,
				years =  4
			},
			JavaScript = {
				skill = 10,
				years = 8
			}
		}
		"cars",
	},
}
```

If we use again the same print approach, we will get the table address instead of the hobbies list.

```lua
print(person)
-- Output:
-- lastname        doe                                                                 
-- hobbies table: 0x2f966fb0                                                           
-- firstname       john                                                                
-- age     33
```

Unfortunately, Lua, due to its tiny footprint, doesn't have any built-in method like [console.log](https://developer.mozilla.org/en-US/docs/Web/API/console/log_static) in JavaScript or any other built-in tools to print out the full table.

## Solution

We need a recursive function to print out the table.

There are plenty of ways, libraries, and solutions on the Internet written in Lua or even written in C for extreme performance. Let's try to make our own one step-by-step.

### Step 1. Prepare test example

Let's start with the defining function.

```lua
---Recursively print the table; if the value is not a table, then just print the value.
---@param t any
---@param level? number
local function printTable(t, level)
	level = level or 0
	-- function body
end
```

Here we only define the function with two arguments:

- **t**: a table or any other value to be printed;
- **level**: level of indentation for nested tables. If it `level` is not set, we give it a default value 0 on line 5.

### Step 2. Adding for loop

Now we are ready to iterate the table in one level, and we can already see what we got [above](#:iterate):
```lua
---Recursively print the table; if the value is not a table, then just print the value.
---@param t any
---@param level? number
local function printTable(t, level)
	level = level or 0
	for key, value in pairs(t) do
		io.write(string.rep("\t", level) .. string.format("[%s] = %s", key, value))
		io.write(",\n")
	end
end
printTable(test)
--Output:
--[lastname] = doe,
--[hobbies] = table: 0x3599de50,
--[age] = 33,
--[firstname] = john, 
```

### Step 3. Recursion

It is time to add a recursion trick to the function if the type of the key is a table, and as a fallback, we will just print the value.


> The process in which a function calls itself directly or indirectly is called **recursion** and the corresponding function is called a **recursive function**.

```lua
---Recursively print the table; if the value is not a table, then just print the value.
---@param t any
---@param level? number
local function printTable(t, level)
    level = level or 0
    if type(t) == "table" then
        io.write("{\n")
        for key, value in pairs(t) do
            io.write(string.rep("\t", level) .. string.format("[%s] = ", key))
            printTable(value, level)
            io.write(",\n")
        end
        io.write("}")
    else
        io.write(tostring(t))
    end
end
printTable(person)
--Output:
{
--[hobbies] = {
--[1] = painting,
--[2] = cars,
--[programming] = {
--[Lua] = {
--[years] = 5,
--[skill] = 7,
--},
--[JavaScript] = {
--[years] = 8,
--[skill] = 10,
--},
--[C] = {
--[years] = 4,
--[skill] = 2,
--},
--},
--},
--[age] = 33,
--[lastname] = doe,
--[firstname] = john,
--}
```

So we already have the whole table printed, but we haven't utilized a `level` variable to make the correct indentation for good readability.

### Step 4. Add indentation

Readability is one of the key features of well-written code and debugging information. We use the built-in function [string.rep](https://www.lua.org/manual/5.4/manual.html#pdf-string.rep) which just repeats a string N-times.

```lua
---Recursively print the table; if the value is not a table, then just print the value.
---@param t any
---@param level? number
local function printTable(t, level)
	level = level or 0
	if type(t) == "table" then
        -- do not print new line on the level 0
        if level ~= 0 then
            io.write("\n")
        end

        io.write(string.rep("\t", level), "{\n")
		level = level + 1

		for key, value in pairs(t) do
			io.write(string.rep("\t", level) .. string.format("[%s] = ", key))
			printTable(value, level)
			io.write(",\n")
		end

		level = level - 1
		io.write(string.rep("\t", level), "}")
	else
		io.write(tostring(t))
	end
    -- print new line on the level 0
    if level == 0 then
        io.write("\n")
    end

end
printTable(person)
--Output:
--[[
{
	[lastname] = doe,
	[age] = 33,
	[hobbies] =
	{
		[1] = painting,
		[2] = cars,
		[programming] =
		{
			[Lua] =
			{
				[skill] = 7,
				[years] = 5,
			},
			[C] =
			{
				[skill] = 2,
				[years] = 4,
			},
			[JavaScript] =
			{
				[skill] = 10,
				[years] = 8,
			},
		},
	},
	[firstname] = john,
}
--]]
```

### Step 5. Creating module

Actually, we are done with our `printTable` function, but we can go even further and create a Lua module. Modules are easy to reuse or share with the world by publishing them to [LuaRocks](https://luarocks.org/) &ndash; the package manager for Lua modules.

Do not forget to save this to a file named `printTable.lua`.

```lua
--printTable.lua
--Storing functions in separate variables would access them faster. because
-- it is not required to make a key lookup in the table.
local format = string.format
local rep = string.rep
local write = io.write

---Recursively print the table, if not table value is just printed.
---@param t any
---@param level? number
local function printTable(t, level)
    level = level or 0
    if type(t) == "table" then
        -- do not print new line on the level 0
        if level ~= 0 then
            write("\n")
        end
        write(rep("\t", level), "{\n")
        level = level + 1

        for key, value in pairs(t) do
            write(rep("\t", level) .. format("[%s] = ", key))
            printTable(value, level)
            write(",\n")
        end

        level = level - 1
        write(rep("\t", level), "}")
    else
        write(tostring(t))
    end
    -- print new line on the level 0
    if level == 0 then
        write("\n")
    end
end

-- exporting module
return {
    printTable = printTable,
}
```

Now we are ready to use our module:

```lua
local myModule = require("printTable")

local test = {
	firstname = "john",
	lastname = "doe",
	age = 33,
	hobbies = {
		"painting",
		programming = {
			Lua = {
				skill = 7,
				years = 5,
			},
			C = {
				skill = 2,
				years = 4,
			},
			JavaScript = {
				skill = 10,
				years = 8,
			},
		},
		"cars",
	},
}
myModule.printTable(test)
-- we also print non-table values
myModule.printTable(123) -- 123
myModule.printTable("Hello") -- Hello
myModule.printTable(nil) -- nil
```

## More possibilities

If we go deeper, the table type actually has the meta-method [`__tostring`](https://www.lua.org/manual/5.4/manual.html#pdf-tostring), which prints the table in the format table: 0x11111111. We can override the [`__tostring`](https://www.lua.org/manual/5.4/manual.html#pdf-tostring) method, bit do not do it.

!!! danger
	I strongly discourage overriding built-in native library meta-methods, especially if you are going to share your code with somebody else. This might lead to unpredictable results and hard-to-detect bugs.