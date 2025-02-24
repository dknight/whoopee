<!-- Description: An article provides a detailed explanation of iterators in Lua, including their purpose, functionality, and usage. It also includes practical examples to demonstrate how iterators work and how they can be implemented effectively in Lua programs. -->

tags: lua

# Iterators

An iterator is any structure that enables traversal through the elements of a collection (table). In Lua, iterators are
usually represented as functions that return the next element from the collection each time they are called. There are
built-in iterators: [`pairs`](https://www.lua.org/manual/5.4/manual.html#pdf-pairs)
and [`ipairs`](https://www.lua.org/manual/5.4/manual.html#pdf-ipairs). Under the hood `pairs` and `ipairs` iterators
use [`next`](https://www.lua.org/manual/5.4/manual.html#pdf-next) function.

## Generic for-loop

```text
for <var-list> in <expr-list> do
    <body>
end
```

Where:

- **var-list**: a comma-separated list of variable names available in the body;
- **exp-list**: a comma-separated list of expressions.

### Simple iterator

```lua
for k, v in ipairs(list) do
    print(k, v)
end
```

Can be rewritten without `pairs` or `iparis` iterator.

```lua
for k, v in next, list do
    print(k, v)
end
```

## Stateful iterator

Iterator that stores its state in itself (variable `i`). This example has one drawback; it creates the closure (function)
with each call at the cost of memory and CPU time. Notice that state can be stored not only in a single variable but also in
`table` if the more complex state is required.

!!! tip
    Read more about [Iterators with Complex State](https://www.lua.org/pil/7.4.html) in the PIL book.

    I would prefer to design software using [stateless iterators](#stateless-iterator) or
    [true iterators](#stateless-iterator)

```lua
local list = { 1, 2, 3, 4, 5 }

local function iterator10(t)
    local i = 0
    return function()
        i = i + 1
        if t[i] then
            return i, t[i] * 10
        end
    end
end

for i, x in iterator10(list) do
	print(i, x)
end
```

## Stateless iterator

It is obvious from the name that this is the iterator that does not store its state.
If possible, the stateless iterators are more preferable if performance matters.

```lua
local function iter(t, i)
	i = i + 1
	if t[i] then
		return i, t[i] * 10
	end
end

local function iterator10(t)
	return iter, t, 0
end

for k, v in iterator10(list) do
	print(k, v)
end
```

## True iterator

Actually in Lua, functions do not iterate anything; only the for loop does the iteration. There is another way to create
iterators. We can create a function which accepts list as the first argument, and callback function.

```lua
local function iterator10(t, callback)
	for k, v in ipairs(t) do
		callback(k, v)
	end
end

iterator10(list, function(k, v)
	print(k, v * 10)
end)
```

## References

- [For Statement](https://www.lua.org/manual/5.4/manual.html#3.3.5)
- [Programming in Lua: Iterators and the Generic for](https://www.lua.org/pil/7.html)