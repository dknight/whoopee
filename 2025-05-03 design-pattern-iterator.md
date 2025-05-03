<!-- Description: An iterator is a design pattern that allows you to go through all the items in a collection (like a list, stack, or tree) one by one, without needing to know how the collection is built or stored. Lua language already has a built-in iterator for tables. -->

tags: lua design-patterns

# Iterator

An iterator is a design pattern that allows you to go through all the items in a collection (like a list, stack, or tree) one by one, without needing to know how the collection is built or stored.

One of the main data structures in the Lua programming language is a table. Lua already has a built-in iterator for
tables [`next`](https://www.lua.org/manual/5.4/manual.html#pdf-next), read a
[post about iterators](https://www.whoop.ee/post/iterators.html) in Lua. To keep the consistency of the design patterns series, here we will make a simple [class implementation](/post/object-oriented-programming-in-lua.html) of the iterator.

## TableIterator class and usage

```lua
---@class TableIterator
---@field private collection table
---@field private index number
local TableIterator = {}
TableIterator.__index = TableIterator

---@return TableIterator
---@param collection table
function TableIterator:new(collection)
	local t = {
		index = 1,
		collection = collection,
	}
	return setmetatable(t, self)
end

function TableIterator:next()
	local element = self.collection[self.index]
	if not element then
		return nil
	end
	self.index = self.index + 1
	return element
end

local t = { "Hello", "World", "of", "Iterators" }
local iterator = TableIterator:new(t)
local element = iterator:next()
while element do
	print(element)
	element = iterator:next()
end
--[[
Hello                                                                           
World                                                                           
of                                                                              
Iterators
--]]
```

## Without class

Class is really overhead for this simple example and can be replaced with a simple function.

```lua
---@param collection table
---@return function
function createTableIterator(collection)
	local index = 1
	return function()
		local element = collection[index]
		if not element then
			return nil
		end
		index = index + 1
		return element
	end
end

local tableNext = createTableIterator(t)
local element = tableNext()
while element do
	print(element)
	element = tableNext()
end
--[[
Hello                                                                           
World                                                                           
of                                                                              
Iterators
--]]
```