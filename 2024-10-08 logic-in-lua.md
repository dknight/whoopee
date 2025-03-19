<!-- Description: Definitive guide to logical operation in Lua. Ternary logical operator in Lua. Truth tables for AND, OR, NOT, XOR, NXOR. -->

tags: lua beginner

# Logic in Lua: AND, OR, NOT, XOR, NXOR

<div>
<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>
</div>
[TOC]

Logical operators in Lua are: `and`, `or`, and `not`. In addition to this here are covered `xor` and `nxor`. Logical operators always produce so-called *boolean* value: `true` or `false`.

In boolean algebra, such an operation is called:

- **and**: conjunction;
- **or**: disjunction;
- **not**: negation.
- **xor**: exclusive disjunction.
- **xnor**: exclusive negative disjunction *XNOR = XOR Gate + NOT Gate*.

In Lua language, _false_ values are: `nil` and `false` everything else is interpreted as `true`.

!!! tip
    Don’t be confused with JavaScript, where `0` is false. In Lua 0 is also `true`.

Logical operators can be used in if-statements and loops, and the result can be
assigned to a variable.

## If-statements

```lua
if condition1 then
  -- Statements are executed when condition(1) is true.
elseif condition2 then
  -- Statements are executed when condition(2) is true.
elseif condition3 then
  -- Statements are executed when condition(3) is true.
else
  -- Statements are executed in any other case.
end
```

## Loops

```lua
while condition do
  -- Statements are executed while a condition is true.
end

repeat
  -- Statements are executed until a condition is true.
until condition
```

## Assignment to variable

```lua
local isBlack = true
local isRed = color == "red"
local isNotBlackButRed = color ~= "black" and color == "red"
-- etc.
```

## Conditional ternary operator

There is no ternary operator in Lua. But... both **and** and **or** use short-circuit evaluation; that means that second part of logical expression is evaluated only when necessary.  Some examples from the [Lua manual](https://www.lua.org/manual/5.4/manual.html#3.4.5):

```lua
10 or 20            --> 10
10 or error()       --> 10
nil or "a"          --> "a"
nil and 10          --> nil
false and error()   --> false
false and nil       --> false
false or nil        --> nil
10 and 20           --> 20
```

The short-circuit evaluation can be used to emulate a conditional ternary operator.

Consider:
```lua
true and "ok" or "nok"   --> "ok"
1 == 2 and "ok" or "nok" --> "nok"
"red" == "green" and "Red is green" or "Red is not green" --> "Red is not green"
```

There is a caveat. If you are using a function that returns two values and the
first returned value is falsy (**false** or **nil**), consider:

```lua
local function fn()
	-- ...
	return false, 100
end
```
In this case, only the first returned argument is evaluated. This confusion might
lead to very hard-detecting errors and bugs. 

```lua
if fn() then
	print("True, not printed")
else
	print("False, printed")
end

-- Output: "False, printed"

-- Same applies to ternary operator

print(fn() and "True, not printed" or "False, printed")
```

For myself, I make it a habit to not use functions that return multiple values.
But of course there are exceptions. Depends on the task and personal preferences.

## Logical connectives in Lua

### AND

```lua
A and B
```

### OR

```lua
A or B
```

### NOT
```lua
not A
```
### XOR

Same as logical inequality.

```lua
not A ~= not B
```

### NXOR

Same as logical equality.

```lua
not A == not B
```

### Truth table


|         |         | AND     | OR      | NOT     | XOR            | NXOR           |
|---------|---------|---------|---------|---------|----------------|----------------|
| A       | B       | A and B | A or B  | not A   | not A ~= not B | not A == not B |
| `true`  | `true`  | `true`  | `true`  | `false` | `false`        | `true`         |
| `true`  | `false` | `false` | `true`  | `false` | `true`         | `false`        |
| `false` | `true`  | `false` | `true`  | `true`  | `true`         | `false`        |
| `false` | `false` | `false` | `false` | `true`  | `true`         | `true`         |


## Logical tricks

Convert anything to boolean type; double negation can be used.

```lua
not not 1              --> true
not not "anything"     --> true
not not false          --> false
not not nil            --> false
not not {a= 1}         --> true
not not function() end --> true
-- and so on...
```

Not only booleans can be negated.

```lua
not nil         --> true
not false       --> true
not 111         --> false
not "something" --> false
not {a=1}       --> false
-- and so on...
```

## References

- [Wikipedia: Truth_ table](https://en.wikipedia.org/wiki/Truth_table)
- [Wikipedia: Boolean_algebra](https://en.wikipedia.org/wiki/Boolean_algebra)
- [Lua Manual: Logical Operators](https://www.lua.org/manual/5.4/manual.html#3.4.5)