<!-- Description: A function that can accept a variable number of arguments is called a variadic function, which is indicated by three dots ('...') vararg expressions at the end of its argument list. Explanation of how variadic functions and vararg expression work in Lua. -->

tags: lua beginner

# How does the three dots parameter work in Lua?

A function in Lua can accept any number of arguments from zero to any amount. There
might be a case where there is no exact number of arguments; `string.format`, from the standard library, is a good example of such a function. Where the first argument is 
format string with specifiers and after follow variables corresponding to the specifiers.
The signature of this function is `string.format(formatstring, ...)`.
Such a function is called *variadic*, which means that the number of parameters is not determined. Variadic function is indicated by
three dots `...`, called *vararg expression*.

Consider:

```lua
-- no arguments
local function sayHello()
	return "Hello"
end

-- 2 arguments
local function sum2(a, b)
	return a + b
end

-- variadic function with undetermined number of arguments
local function sum(...)
	-- sum all arguments
end 
```

*vararg expression* (`...`) contains a list of arguments,
*vararg expression* **always** should be the last in the argument list.

```lua
local function sum(a, b, ...)
	print(a, b, ...)
end

sum(1, 2, 3, 4, 5) --> 1	2	3	4	5
```

Making a table from *vararg expression* using table constructor `{}`:

```lua
local function sum(a, b, ...)
	local t = {a, b, ...}
	print(t, #t)
end

sum(1, 2, 3, 4, 5) --> table:	0x11c2fc0	5
```

!!! warning
    Here is the caveat: if in *varag expression* one of the values is `nil`, then `{...}` might not be a sequence. To avoid this,
    there is a function from the table module: `table.pack`.

    ```lua
    function variadicFn(...)
      local args = table.pack(...)
      --[[ rest of code ]]
    end
    ```

    Also, consider that table constructor `{}` works much faster
    than `table.pack`. I would recommend making a habit, always
    avoid `nil` values in the Lua tables.


Finally, let's finish our sum.

```lua
local function sum(a, b, ...)
	local t = {a, b, ...}
	local s = 0
	for i = 1, #t do
		s = s + t[i]
	end
  return s
end

print(sum(1, 2, 3, 4, 5)) --> 15
```

Destruct *vararg expression* arguments to variables.

```lua
local function sum(a, b, ...)
  local c, d, e = ...
  return a + b + c + d + e
end

print(sum(1, 2, 3, 4, 5)) --> 15
```

In the example above, if any parameter is a non-number, then function
will fail because the interpreter will try to sum non-numbers. This
example is only for demonstration, in real code type checking and
error handling should be done.

## Word of warning

There might be issues that might be caused by using *vararg expression*. On
[lua-users.org there is full article](http://lua-users.org/wiki/VarargTheSecondClassCitizen)
about potential problems with *vararg expression*.
In my daily job, I'd like to avoid such complex solutions, if
possible. Code readability and maintainability are always one of the
top priorities for me.

!!! note
    In JavaScript, [rest parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) works mostly the same as *vararg expression* in Lua.

## References

- [Lua Manual: Function Definitions](https://www.lua.org/manual/5.4/manual.html#3.3.6)
- [Lua Manual: string.format](https://www.lua.org/manual/5.4/manual.html#pdf-string.format)
- [lua-users.org: Vararg The Second Class Citizen](http://lua-users.org/wiki/VarargTheSecondClassCitizen)
- [Programming in Lua: Variable Number of Arguments](https://www.lua.org/pil/5.2.html)
