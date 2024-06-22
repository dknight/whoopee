<!-- Description: Implementation of the priority queue in Lua. Priority queue is an abstract data type similar to queue and stack. The difference is that each element has a priority value. Values with higher priority are pulled first. -->

tags: data-structures

# Priority queue

Priority queue is an abstract data type similar to [queue](/post/queue.html)
and [stack](/post/stack.html). The difference is that each element has a
priority value. Values with higher priority are pulled first. There might be
different implementations of handling priority. 

![Figure 01: Priority queue](/assets/img/priorityqueue01.svg)

## Priority queue class

Here is a demonstration of the most simple using ***unsorted list*** class
O(1) where the insertion time is `O(1)` and the pulling time is
`O(n)`.

There are different possible implementations:

| Implementation                       | Insert          | Pull                   | Peek       |
|--------------------------------------|-----------------|------------------------|------------|
| Binary Heap                          | O(log *n*)      | O(log *n*)             | O(1)       |
| Fibonacci Heap                       | O(1)<sup>1</sup>| O(log *n*)<sup>1</sup> | O(1)       |
| Binary Search Tree (BST)<sup>2</sup> | O(log *n*)      | O(log *n*)             | O(log *n*) |
| ***Unsorted List<sup>3</sup>***      | O(n)            | O(n)                   | O(1)       |
| Sorted List                          | O(n)            | O(1)                   | O(1)       |

- <sup>1</sup> - amortized;
- <sup>2</sup> - worst case is ***O(n)***
- <sup>3</sup> - below is the implementation of the unsorted list class.

Class implementation with [OOP principles](/post/object-oriented-programming-in-lua.html) and
[annotations](/post/object-oriented-programming-in-lua.html#annotations).

`PriorityQueue.lua`

```lua
---@class Node
---@field value any
---@field priority number
local Node = {}
Node.__index = Node

---@return Node
---@param value any
---@param priority number
function Node:new(value, priority)
	return setmetatable({
		priority = priority,
		value = value,
	}, self)
end

---@class PriorityQueue
local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

---@return PriorityQueue
function PriorityQueue:new()
	return setmetatable({}, self)
end

---@return number
function PriorityQueue:size()
	return #self
end

---@param value any
---@param priority? number
function PriorityQueue:insert(value, priority)
	priority = priority or 1
	self[#self + 1] = Node:new(value, priority)
end

---Pulls the value with the highest priority. If priority queue is empty
---then nil and zero are returned.
---@return any, number
function PriorityQueue:pull()
	if self:size() == 0 then
		return nil, 0
	end
	local node, idx = self:peek()
	table.remove(self, idx)
	return node.value, idx
end

---Retuns the last element with highest priority and its index.
---@return any, number
function PriorityQueue:peek()
	if self:size() == 0 then
		return nil, 0
	end
	local highestIndex = 1
	local highest = self[1]
	for i, node in ipairs(self) do
		if highest.priority < node.priority then
			highest = node
			highestIndex = i
		end
	end
	return highest.value, highestIndex
end

---@return string
function PriorityQueue:toString(sep)
	sep = sep or ","
	local t = {}
	for i in ipairs(self) do
		t[#t + 1] = "{" .. tostring(self[i].value) .. ", " .. self[i].priority .. "}"
	end
	return table.concat(t, sep)
end

return PriorityQueue
```

### Usage of PriorityQueue class

```lua
local pq = PriorityQueue:new()
pq:insert("A", 1)
pq:insert("B", 2)
pq:insert("C", 4)
pq:insert("D", 3)
print(pq:pull()) --> "C"
print(pq:pull()) --> "D"
print(pq:peek()) --> "B"	2
print(pq:toString()) --> "{A, 1},{B, 2}"
```

## Links

- [Wikipedia: Priority Queue](https://en.wikipedia.org/wiki/Priority_queue)