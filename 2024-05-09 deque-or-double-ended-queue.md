<!-- Description: Deque or double-ended queue abstract data structure in Lua language. Implementation of push front, push back, pop front and pop back methods. -->

tags: data-structures

# Deque or double-ended queue

Deque is very similar to [queue](/post/queue.html), but with one significant
difference: elements can be added or removed from both sides. In other meaning
deque and queue are very similar and usually serve the same purposes.

Usually, deque implements 4 methods:

- `pushFront` - adds an element into the front of the queue;
- `popFront` - removes an element from the front of the queue;
- `pushEnd` - adds an element to the end of the queue;
- `popEnd` - removes an element from the end of the queue;

![Figure 01: Deque illustration](/assets//img/deque01.svg)

Implementation of the deque using `table` module is very simple in Lua.

```lua
-- create deque as empty table
local deque = {}

-- push front
table.insert(deque, 1, "B")
table.insert(deque, 1, "A")

-- push back
table.insert(deque, "C")
table.insert(deque, "D")

--pop front
print(table.remove(deque, 1)) -- "A"

--pop back
print(table.remove(deque)) -- "D"

-- traverse
for i, v in ipairs(deque) do
	print(i, v)
end
-- Output:
-- 1	"B"
-- 2	"C"
```

But it also has the same disadvantage as [queue](/post/queue.html)
does. If we remove or add a new element to the front, the next elements after
the first should be recalculated. This is how `table.remove`
method works. In this case, the complexity will be `O(n-1)`. Let's assume there
are one million records (10<sup>6</sup>), every index will be recalculated
10<sup>6</sup>-1 times. This is very inefficient. Let's implement a wrapper
class for the queue with complexity `O(1)`.

## Deque class

Class implementation with [OOP principles](/post/object-oriented-programming-in-lua.html) and
[annotations](/post/object-oriented-programming-in-lua.html#annotations).

`Deque.lua`

```lua
---@class Deque
---@field private _first number
---@field private _last number
local Deque = {}
Deque.__index = Deque

---@return Deque
function Deque:new()
	local t = {
		_first = 0,
		_last = -1,
	}
	return setmetatable(t, self)
end

---@param v any
function Deque:pushFront(v)
	local first = self._first - 1
	self._first = first
	self[first] = v
end
--
---@return any
function Deque:popFront()
	if self:isEmpty() then
		return nil
	end
	local first = self._first
	local v = self[first]
	self[first] = nil -- garbage collection removes it
	self._first = self._first + 1
	return v
end

---@param v any
function Deque:pushBack(v)
	local last = self._last + 1
	self._last = last
	self[last] = v
end
--
---@return any
function Deque:popBack()
	if self:isEmpty() then
		return nil
	end
	local last = self._last
	local v = self[last]
	self[last] = nil -- garbage collection removes it
	self._last = self._last - 1
	return v
end

---@return boolean
function Deque:isEmpty()
	return self._first > self._last
end

---@return any
function Deque:front()
	return self[self._first]
end

---@return any
function Deque:rear()
	return self[self._last]
end

---@params sep? string
---@return string
function Deque:toString(sep)
	sep = sep or ","
	local t = {}
	for i = self._first, self._last do
		t[#t + 1] = self[i]
	end
	return table.concat(t, sep)
end

return Deque
```

### Usage of Deque class

```lua
local dq = Deque:new()
dq:pushFront("C")
dq:pushFront("B")
dq:pushFront("A")
dq:pushBack("D")
dq:pushBack("E")
dq:pushBack("F")

print(dq:front(), dq:rear()) --> "A"	"F"
print(dq:popFront()) --> "A"
print(dq:popBack()) --> "F""
print(dq:toString()) --> "B,C,D,E""
```

## Links

- [Wikipedia: Double-ended queue](https://en.wikipedia.org/wiki/Double-ended_queue)