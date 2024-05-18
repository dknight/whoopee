<!-- Description: Circular doubly linked list is a data structure that is a combination of both circular singly linked list and doubly linked list. It stores 2 pointers, one is pointing to the next node, the other to the previous node and the first pointer points to the last and correspondingly last to the first. This approach makes a continual circular loop. -->

tags: data-structures

# Circular doubly linked list

Circular doubly linked list is a data structure that is a combination of both
[circular singly linked list](/post/circular-linked-list.html) and
[doubly linked list](/post/doubly-linked-list.html). It stores 2 pointers,
one is pointing to the next node, the other to the previous node and the
first pointer points to the last and correspondingly last to the first. This
approach makes a continual circular loop.

![Figure 01: Circular doubly linked list example](/assets/img/circular-doubly-linkedlist01.svg)

## Doubly linked list class

Implementation of the insertion and deletion algorithms are very similar to a
linear doubly linked list, to check the description proceed to
[corresponding article](/post/doubly-linked-list.html).

Class implementation with [OOP principles](/post/object-oriented-programming-in-lua.html) and
[annotations](/post/object-oriented-programming-in-lua.html#annotations).

`CircularDoublyinkedList.lua`

```lua
---@class Node
---@field value any
---@field prev Node | nil
---@field next Node | nil
local Node = {}
Node.__index = Node

---@param value any
---@param prev? Node | nil
---@param next? Node | nil
---@return Node
function Node:new(value, prev, next)
	return setmetatable({
		value = value,
		prev = prev,
		next = next,
	}, self)
end

---@class CircularDoublyLinkedList
---@field private _size number
---@field private _tail Node
local CircularDoublyLinkedList = {}
CircularDoublyLinkedList.__index = CircularDoublyLinkedList

---@return CircularDoublyLinkedList
function CircularDoublyLinkedList:new()
	local t = {
		_size = 0,
		_tail = nil,
	}
	return setmetatable(t, self)
end

---@private
---@param value any
---@return Node
function CircularDoublyLinkedList:_addToEmpty(value)
	local node = Node:new(value)
	self._tail = node
	node.next = self._tail
	node.prev = self._tail
	return self._tail
end

---@return Node | nil
function CircularDoublyLinkedList:tail()
	return self._tail
end

---@return Node | nil
function CircularDoublyLinkedList:head()
	return self._tail and self._tail.next
end

---@return number
function CircularDoublyLinkedList:size()
	return self._size
end

---@return boolean
function CircularDoublyLinkedList:isEmpty()
	return self._size == 0
end

---Inserts new node at the end of the list.
---@param value any
---@return Node
function CircularDoublyLinkedList:append(value)
	local node = Node:new(value)
	if self:isEmpty() then
		node = self:_addToEmpty(value)
		self._size = self._size + 1
	else
		node = self:insertAfter(value, self._tail)
		self._tail = node
	end
	return node
end

---Inserts new node at the front of the list.
---@param value any
---@return Node
function CircularDoublyLinkedList:prepend(value)
	local node = Node:new(value)
	if self:isEmpty() then
		node = self:_addToEmpty(value)
		self._size = self._size + 1
	else
		node = self:insertAfter(value, self._tail)
	end
	return node
end

---Inserts a new node with value after given node. If after node is nil,
---then one node inserted and pointing to itself.
---@param value any
---@param after Node | nil
---@return Node
function CircularDoublyLinkedList:insertAfter(value, after)
	local node = Node:new(value)
	if after == nil then
		node = self:_addToEmpty(value)
	else
		node.next = after.next
		node.prev = after
		after.next.prev = node
		after.next = node
	end
	self._size = self._size + 1
	return node
end

---Inserts a new node with value before given node. If before node is nil,
---then one node inserted and pointing to itself.
---@param value any
---@param before Node | nil
---@return Node
function CircularDoublyLinkedList:insertBefore(value, before)
	local node = Node:new(value)
	if before == nil then
		node = self:_addToEmpty(value)
		self._size = self._size + 1
	else
		node = self:insertAfter(value, before.prev)
	end
	return node
end

---Removes and returns a node after given node. If given node not found nil is
---returned.
---@return any
function CircularDoublyLinkedList:removeNode(node)
	if node and node.next == node then
		self._tail = nil
	else
		node.next.prev = node.prev
		node.prev.next = node.next
		if node == self._tail then
			self._tail = node.prev
		end
		self._size = self._size - 1
	end
	return node
end

---Removes and returns a node after found node with gven value. If given
---node not found nil is
---returned.
---@return any
function CircularDoublyLinkedList:removeByValue(value)
	local node = self:findByValue(value)
	if node then
		self:removeNode(node)
	end
	return node
end

---Checks if the list contins a give value.
---@param value any
---@return boolean
function CircularDoublyLinkedList:contains(value)
	return self:findByValue(value) ~= nil
end

---Finds the first occurrence of the value. Returns nil if not found.
---@param value any
---@return Node | nil
function CircularDoublyLinkedList:findByValue(value)
	local node = self._tail
	if not node then
		return nil
	end
	repeat
		if node.value == value then
			return node
		end
		node = node.next
	until node == self._tail
	return nil
end

---Traversal of the list in forwards direction.
---@param fn fun(node: Node)
function CircularDoublyLinkedList:traverseForwards(fn)
	local node = self._tail and self._tail.next
	if not node then
		return
	end
	repeat
		fn(node)
		node = node.next
	until node == self._tail.next
end

---Traversal of the list in backwards direction.
---@param fn fun(node: Node)
function CircularDoublyLinkedList:traverseBackwards(fn)
	local node = self._tail
	if not node then
		return
	end
	repeat
		fn(node)
		node = node.prev
	until node == self._tail
end

---@param sep? string
---@return string
function CircularDoublyLinkedList:toString(sep)
	sep = sep or " <=> "
	local t = {}
	self:traverseForwards(function(node)
		t[#t + 1] = node.value
	end)
	return table.concat(t, sep)
end

return CircularDoublyLinkedList
```

### Usage of CircularDoublyLinkedList class

```lua
local cdll = CircularDoublyLinkedList:new()
cdll:insertAfter("A")
local foundA = cdll:findByValue("A")
cdll:prepend("B")
cdll:append("C")
cdll:insertBefore("D", foundA)
cdll:insertAfter("E", foundA)
cdll:removeNode(foundA)
print(cdll:toString(), cdll:size()) --> "B <=> D <=> E <=> C"	4
```

## Links

- [Wikipedia: Linked list](https://en.wikipedia.org/wiki/Linked_list)
- [Wikipedia: Doubly linked list](https://en.wikipedia.org/wiki/Doubly_linked_list)
- [Programming in Lua: Linked lists](https://www.lua.org/pil/11.3.html)