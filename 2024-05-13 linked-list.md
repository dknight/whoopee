<!-- Description: A linked list is a fundamental data structure in computer science used for storing and managing collections of data. Linked list implementation in Lua. -->

tags: data-structures

# Linked list

A linked list is a fundamental data structure in computer science used for
storing and managing collections of data. Unlike arrays, linked lists do not
require contiguous memory allocation, allowing for efficient insertion and
deletion operations. Each element, known as a node, contains a data field and
a reference (or pointer) to the next node in the sequence. This dynamic
structure provides flexibility but may involve more memory overhead due to the
additional pointers. Nodes are stored in different memory locations, not
sequentially like in arrays, so access might be slower. 

![Figure 01: Linked list example](/assets/img/linkedlist01.svg)

Usually in Lua language linked lists aren't widely used, but these might be
great as temporary data storage for more complex data structures and algorithms.

Usually liked list have methods:

- `append` &ndash; appends a new node to the end of the list;
- `prepend` &ndash; appends a new node to the beginning of the list;
- `removeHead` &ndash; remove a node from the beginning of the list;
- `traverse` &ndash; traverse through the list.
- `insertAfter` &ndash; inserts new node after giving value;
- `removeAfter` &ndash; removes a node after giving value;
- `contains` &ndash; checks that the list has a node with value.
- More if needed...

Since we can't iterate backward, efficient `insertBefore` or `removeBefore`
operations are not possible. Inserting to a list before a specific node requires
traversing the list, which would have a worst-case running time of `O(n)`.
<sup><a href="#link-1">[1]</a></sup>

When removing and inserting the nodes need to care about pointers. The next
figure shows how pointers are re-assigned on the removing and inserting the
node.

![Figure 02: Removing and inserting a node in a linked list](/assets/img/linkedlist02.svg)

Implementation of the simple linked list in Lua is extremely simple. There is 
a table with value and next pointer.

Consider:

```lua
local list = nil
list = {
	value = "A",
	next = list,
}
list = {
	value = "B",
	next = list,
}
list = {
	value = "C",
	next = list,
}

-- traverse while has next
local l = list
while l do
	print(l.value)
	l = l.next
end
-- Output:
-- "C"
-- "B"
-- "A"
```

## Linked list class

Class implementation with [OOP principles](/post/object-oriented-programming-in-lua.html) and
[annotations](/post/object-oriented-programming-in-lua.html#annotations).

`LinkedList.lua`

```lua
---@class Node
---@field value any
---@field next Node | nil
local Node = {}
Node.__index = Node

---@param value any
---@param next? Node | nil
---@return Node
function Node:new(value, next)
	return setmetatable({
		value = value,
		next = next,
	}, self)
end

---@class LinkedList
---@field private _head Node | nil
---@field private _size number
local LinkedList = {}
LinkedList.__index = LinkedList

---@return LinkedList
function LinkedList:new()
	local t = {
		_head = nil,
		_size = 0,
	}
	return setmetatable(t, self)
end

---@return Node | nil
function LinkedList:head()
	return self._head
end

---Complexity `O(n)`
---@return Node | nil
function LinkedList:tail()
	local tail = nil
	self:traverse(function(node)
		tail = node
	end)
	return tail
end

---@return number
function LinkedList:size()
	return self._size
end

---@return boolean
function LinkedList:isEmpty()
	return self._size == 0
end

---Prepends the node with a value to the beginning of the list.
---@param value any
---@return Node
function LinkedList:prepend(value)
	self._size = self._size + 1
	self._head = Node:new(value, self._head)
	return self._head
end

---Appends the node with a value to the end of the list.
---@param value any
---@return Node
function LinkedList:append(value)
	local node = Node:new(value)
	if self._head == nil then
		self._head = node
	else
		local ptr = self._head
		while ptr and ptr.next do
			ptr = ptr.next
		end
		ptr.next = node
	end
	self._size = self._size + 1
	return self._head
end

---Inserts a new node with value after given node. If after node is nil,
---then it will be inserted at the beginning of the list.
---@param after Node
---@param value any
---@return Node | nil
function LinkedList:insertAfter(after, value)
	if after == nil then
		return nil
	end
	self._size = self._size + 1
	local node = Node:new(value, after.next)
	after.next = node
	return node
end

---Removes and returns the head. Pointer moves to next node. If next node is
---not exists nil is returned.
---@return Node | nil
function LinkedList:removeHead()
	local tmp = self._head
	if not tmp then
		return nil
	end
	self._head = self._head.next
	return tmp
end

---Removes and returns a node after given node. If given node not found nil is
---returned.
---@param node Node
---@return Node | nil
function LinkedList:removeAfter(node)
	local tmp = node.next
	node.next = tmp and tmp.next
	return tmp
end

---Chekcs if the list contins a give value.
---@param value any
---@return boolean
function LinkedList:contains(value)
	return self:findByValue(value) ~= nil
end

---Finds the first occurrence of the value.
---@param value any
---@return Node | nil
function LinkedList:findByValue(value)
	local node = self._head
	while node do
		if node.value == value then
			return node
		end
		node = node.next
	end
	return nil
end

---Traversal of a linked list.
---@param fn fun(node: Node)
function LinkedList:traverse(fn)
	local node = self._head
	while node do
		fn(node)
		node = node.next
	end
end

---@param sep? string
---@return string
function LinkedList:toString(sep)
	sep = sep or " -> "
	local t = {}
	self:traverse(function(node)
		t[#t + 1] = node.value
	end)
	return table.concat(t, sep)
end

return LinkedList
```

### Usage of LinkedList class

```lua
local li = LinkedList:new()
li:append("A")
li:append("B")
li:append("C")
local found = li:findByValue("B")
if found then
	li:insertAfter(found, "D")
end
li:prepend("E")
found = li:findByValue("D")
if found then
	print(li:removeAfter(found).value, "?!")
end

-- Manual traversing
local l = li:head()
while l do
	print(l.value)
	l = l.next
end

-- Traversing with iterator callback
li:traverse(function(node)
	print(node.value)
end)

-- Both traversal outputs are:
--	"E"
--	"A"
--	"B"
--	"D"
--	"C"

print(li:removeHead().value) --> "E"
print(li:removeHead().value) --> "A""
print(li:head().value) --> "B"
print(li:size()) --> 2
print(li:contains("B")) --> true
print(li:toString()) --> "B -> D"
```

## Links

- [Wikipedia: Linked list](https://en.wikipedia.org/wiki/Linked_list) <sup id="link-1">[1]</sup>
- [Programming in Lua: Linked lists](https://www.lua.org/pil/11.3.html)