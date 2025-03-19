<!-- Description: Definite guide of Lua syntax in one place. -->

tags: lua beginner

# Lua cheatsheet

<div>
<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>
</div>
[TOC]

[Shorter version of this page and PDF](/post/lua-syntax-cheat-sheet.html).

A definitive short guide for Lua, including syntax, basic syntax constructs,
and some useful techniques. Probably the content of this article is enough to
start writing programs in Lua. Also, this page can be used for reference as a
handbook.

## Comments
```lua
-- Single line comment

--[[
	This is a multi-line comment.
	Large comments can be split into many lines,
	everything inside this block is a comment.
--]]
```

## Variables

```lua
x = 12                -- number (integer)
y = 14.3              -- number (float)
z = 0x12              -- number (hexadecimal)

name = "Billy"        -- string
something = nil       -- nil
condition = true      -- boolean
data = {a = 4, b = 2} -- table
multiString = [[
	This is the multi-line string
	Very similar to template
	literals in JavaScript
]]
anotherMultiString = [===[
	After first brackets can you can insert equal number of equal sign '=' (3 in
	this case).
	[[ Square brackets inside multi-line string ]]
]===]

local name = "John"  -- string (local variable)
```

### Reserved words

There are reserved words that cannot be used to name variables, table fields,
labels, and functions.

```text
     and       break     do        else      elseif    end
     false     for       function  goto      if        in
     local     nil       not       or        repeat    return
     then      true      until     while

```

### String literals

String literals are enclosed with `"` (double quotes) or `'` single quotes.
You just need to keep in mind that a single type of quotation mark cannot be
nested. To avoid errors [escape sequences](#escape-sequences)
or string blocks should be used.

```lua
name = 'Mr. O'hara'    -- error nested single question
name = 'Mr. O\'hara'   -- ok
name = [[Mr. O'hara']] -- ok
name = "Mr. O'hara"    -- ok
```

String blocks start with `[[` and end with `]]`, between brackets can be any
number of `=` signs. Why these `=` are needed? Very rarely, but it happens,
string literals can contain `[[` or `]]` inside the block.

Consider (error):

```lua
text=[[
	Display found point in the circle
	Point at points[x[i], y[j]]
]] --> lua: file.lua:4: unexpected symbol near ']'
```

With `=` works fine:

```lua
text=[==[
	Display found point in the circle
	Point at points[x[i], y[j]]
]==]
```

!!! warning
    - You cannot use [escape sequences](#escape-sequences) in the string blocks.
    - Do not misuse `=` signs in the blocks, these are needed really rarely,
      unless you want to make something cryptic.

The same rules apply to block comments:

```lua
--[=====[
I have seen the dark universe yawning
Where the black planets roll without aim—
Where they roll in their horror unheeded,
Without knowledge or lustre or name.
—Nemesis by H.P. Lovecraft
--]=====]
```

#### Escape sequences

Lua supports the same escape sequences as ANSI C language does.

- `\a` -- alert (beep, bell);
- `\b` -- backspace;
- `\f` -- form feed page break;
- `\n` -- newline (line feed); see below;
- `\r` -- carriage return;
- `\t` -- horizontal tab;
- `\v` -- vertical tab;
- `\\` -- backslash;
- `\'` -- apostrophe or single quotation mark;
- `\"` -- double quotation mark;
- `\?` -- question mark (used to avoid trigraphs);
- `\nnn` -- the byte whose numerical value is given by ***nnn***
  interpreted as an octal number;
- `\xhh...` --  the byte whose numerical value is given by ***hh…***
  interpreted as a hexadecimal number;

Lua's specials:

- `\uhhhh` -- Unicode code point below 10000 hexadecimal;
- `\uhhhhhhhh` -- Unicode code point below 10000 hexadecimal` Unicode code point
  below 10000 hexadecimal;
- `\z` -- skip the following spans of white spaces until the non-next white-space
  character, it is particularly useful to break and indent a long literal
  string;

#### String operators

- `..` -- strings concatenation (adds strings together);

```lua
"Measure twice" .. " " .. "cut once" -- "Measure twice cut once"
```

## Arithmetic

Arithmetic operators:

- `+` -- additions;
- `-` -- subtraction;
- `*` -- multiplication;
- `/` -- division;
- `//` -- floor division;
- `%` -- modulus division;
- `^` -- exponent (available since Lua 5.3);

```lua
40 + 2   -- 42
44 - 2   -- 42
6 * 7    -- 42
42 / 2   -- 21
42 // 10 -- 4
42 % 10  -- 2
2 ^ 5    -- 32
```

!!! warning
    There is no `++` and `--` operators in Lua. Use the form of `x = x + 1`.

## Control structures

## Conditionals

!!! warning
    In Lua language _false_ values are: `nil` and `false` everything else is interpreted as `true`.
    
    Don't be confused with JavaScript, where `0` is false. In Lua `0` is also`true`.

[Logical operators](/post/logic-in-lua.html):

- `and` -- logical AND;
- `or` -- logical OR;
- `not` -- logical NOT;

Comparison operators:

- `<` -- less than;
- `>` -- greater than;
- `<=` -- less than or equal to;
- `>=` -- greater than or equal to;
- `==` -- equality;
- `~=` -- inequality;

Bitwise operators (starting from Lua 5.3+):

- `&` -- bitwise AND;
- `|` -- bitwise OR;
- `~` -- unary NOT, or bitwise XOR;
- `<<` -- left bit shift;
- `>>` -- right bit shift;

Examples:

```lua
if apples == 2 then
	print("I have 2 apples")
end

if apples == 1 and name == "Mike" > 1 then
	print("Mike has 1 apple")
elseif apples == 4 and name =="Ann" 1 then
	print("Ann has 4 apples")
elseif appels > 5 then
	print("All othres have more than 5 apples")
else
	print("Undefined number of apples and who has them")
end
```

## Loops

```lua
-- while loop
local i = 10
while i > 0 do
	print(i)
	i = i - 1
end

-- repeat until loop (executes at least 1 time)
local i = 10
repeat
	print(i)
	i = i - 1
until i < 1

-- for loop with default increment 1
for i = 1, 10 do
	print(i)
	i = i + 1
end

-- for loop witn third parameter incement 10
for i = 0, 100, 10 do
	print(i)
	i = i + 1
end

-- for loop witn third incement parameter -10
for i = 100, 0, -10 do
	i = i + 1
end

-- for loop through the table where indexes are number
for i, n in ipairs(someTable) do
	print(someTable[i])
end

-- for loop through the table variation 2
for i = 1, #someTable do
	print(someTable[i])
end

-- for loop through the table where indexes any allowed type
-- NB! Output is unsroted order!
for k, v in pairs(someTable) do
	print(someTable[k], v)
end

-- forced break loop
for i = 0, 100 do
	print(i)
	if i == 42 then
		print('i is 42 stop loop')
		break
	end
end

-- Skip iteration, this is probably on one use case of goto operator in Lua
for i = 1, 10 do
	if i % 2 == 0 then goto continue end
	print(i, 'is even')
	::continue::
end
```

## goto

!!! danger
    Avoid `goto` as fire!

About `goto` there is only one thing, **do not use `goto`** misusing of `goto`
can lead to "spaghetti" and barely maintainable code. There is only a
single case where `goto` can be used in Lua language. Lua loops do not have
`continue` statement, but it can be emulated with `goto`.

Consider:

```lua
for i = 1, 10 do
	if i < 6 then
		goto endloop
	end
	print(i)
	-- do something with i
	print(i)
	::endloop::
end
-- Output:
-- 6
-- 7
-- 8
-- 9
-- 10
```

## Tables

Tables in Lua are the same as dictionaries, associative arrays, and map-like
data structures in other programming languages. But there are some differences
in comparison with other languages.

- Tables in Lua start from index 1, not from 0;
- values in a table stored unsorted;
- indexes can have a type `number`, `string`, `boolean`, or even
  another `table`.
- `#`: table length operator.

!!! tip
    Tables in Lua start at index 1, not from 0.

```lua
someTable = {} -- creates new empty table, aka table constructor

-- creates new table with values:
-- 11 at index 1
-- 42 at index 2
-- 34 at index 3
someTable = {11, 42, 34}

someTable[1] = 'first' -- put string 'first' at index 1
someTable['lua'] = 'Amazing' -- put string 'Amazing' at index 'lua'
someTable[1] = mil  -- assign nil same as removing value at index 1
someTable.level = 2 -- equivalent of someTable['level']

-- Iterate table through all its values
for key, value in ipairs(someTable) do
	result = result + n
	print(index, value)
end

-- Get length of the table with # operator
local fruits = {'apple', 'orange', 'melon'}
print(#fruits) -- 3
```

## Functions

Functions are code blocks it is good to put reusable code.

Here are my recommendations, based on my experience, for using
functions with efficiency and not shooting in the leg.

Try to follow the concept of [pure
functions](https://en.wikipedia.org/wiki/Pure_function) from the functional
programming paradigm. What does it mean to be pure? There are 2 rules:

- The function return values are identical for identical arguments; there
  are no variations or exceptions!
- The function has no side effects (no mutation of any external data); for
  example, if the function receives a table as an argument, it should not
  mutate (change) that table. Instead, the function returns a modified
  table. It is not always possible. There might be exceptions; for
  example, if tables are large, then such an approach becomes very
  inefficient. It depends on how large your data is.

Types `tables`, `userdata`, `threads`, and `function` are
[passed by reference](/post/types-in-lua-references-vs-values.html), not by
value. If a function changes the table received by an argument, it will
mutate it and cause a side effect. Keep this in mind!

```lua
-- One-liner function
function calculateArea(a, b)
	if a < 0 or b < 0 then
		print('sides of the shape cannot be negative')
		return -1
	end
	return a * b
end

function isNegative(n) return n < 0 end
```
## Error handling

### Assertion

If the assertion function `assert()` receives a boolean falsy expression,
then the program will be stopped with an error. If the expression is truth, the
program will continue to execute normally.

```lua
print('Program started')
assert(false, 'Second argument is optional messsage for failure')
print('will never be printed, because it stops on the next line')

```

### Protected calls

Protected calls are a great way to make your programs more stable and avoid
program crashes due to errors.

Consider:

```lua
function checkSpeed(mph)
	if mph > 60 then
		print('The police chasing you!')
		return true
	end
	return false
end

local ok, value = pcall(checkSpeed, "60")
-- ok = false
-- value = nil because argument is a string, not a number
local ok, value = pcall(checkSpeed, 60)
-- ok = true
-- value = true, execution of functions is successful
```

Another useful function is `xpcall()`. It is similar to `pcall()` but receives
an extra error handler argument.

Consider:

```lua
local ok, value = pcall(checkSpeed, debug.traceback, "60")
-- ok = false
-- value = nil because argument is a string, not a number
-- debug.traceback` is used as error handler
```

## References

- [Lua 5.4 Official Manual](https://www.lua.org/manual/5.4/manual.html)
