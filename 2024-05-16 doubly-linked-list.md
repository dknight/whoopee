<!-- Description: Doubly linked list is a data structure similar to a singly linked list. With one significant difference: it stores 2 pointers, one is pointing to the next node, the other to the previous node. Check implementation of doubly linked list in Lua programming language. -->

tags: data-structures

# Doubly linked list

Doubly linked list is a data structure similar to a
[singly linked list](/post/linked-list.html). With one significant difference:
it stores 2 pointers, one is pointing to the **next node**, other to the
**previous node**. Such kind of list is useful when there is a need to traverse
in both directions: backwards or forwards. Such kind of structures are very
rarely used in Lua, but maybe someone finds this useful. Or learn it for
educational purposes.

![Figure 01: Doubly linked list example](/assets/img/doubly-linkedlist01.svg)

## Inserting node

Lets assume that a new node is **B**.

1. Create node **B**.
2. Set the next pointer of **A** to **B**, **A &rarr; B**.
3. Set the next pointer of **B** to **C**, **B &rarr; C**.
4. Set the previous pointer of **B** to **A**, **B &larr; A**.
4. Set the previous pointer of **C** to **B**, **C &larr; B**.

![Figure 2: Doubly linked list example insertion](/assets/img/doubly-linkedlist02.svg)

## Removing node

Let's assume that the removed node is **B**.

1. Set the next pointer of **A** to **C**, **A &rarr; C**.
2. Set the previous pointer of **C** to **A**, **C &larr; A**.
3. Nothing pointing to **B** anymore and it should be removed by the garbage
  collector.

![Figure 3: Doubly linked list example removing](/assets/img/doubly-linkedlist03.svg)

Implementation of the most simple doubly linked list in Lua is extremely
simple. There is a just table with value, previous and next pointers.

Consider:

```lua
local list = nil
local head, tail
list = {
	value = "A",
	prev = nil,
	next = nil,
}
head = list

list = {
	value = "B",
	prev = list,
	next = nil,
}
list.prev.next = list

list = {
	value = "C",
	prev = list,
	next = nil,
}
list.prev.next = list
tail = list

-- traverse forwards
local l = head
while l do
	print(l.value)
	l = l.next
end
-- output:
-- "A"
-- "B"
-- "C"

-- traverse backwards
l = tail
while l do
	print(l.value)
	l = l.prev
end
-- output:
-- "C"
-- "B"
-- "A"
```

## Doubly linked list class

Class implementation with [OOP principles](/post/object-oriented-programming-in-lua.html) and
[annotations](/post/object-oriented-programming-in-lua.html#annotations).

`DoublyinkedList.lua`

```lua
---@class Node
---@field value any
---@field next Node | nil
---@field prev Node | nil
local Node = {}
Node.__index = Node

---@param value any
---@param next? Node | nil
---@param prev? Node | nil
---@return Node
function Node:new(value, next, prev)
	return setmetatable({
		value = value,
		next = next,
		prev = prev,
	}, self)
end

---@class DoubleLinkedList
---@field private _head Node | nil
---@field private _tail Node | nil
---@field private _size number
local DoubleLinkedList = {}
DoubleLinkedList.__index = DoubleLinkedList

---@return DoubleLinkedList
function DoubleLinkedList:new()
	local t = {
		_head = nil,
		_tail = nil,
		_size = 0,
	}
	return setmetatable(t, self)
end

---@return Node | nil
function DoubleLinkedList:head()
	return self._head
end

---@return Node | nil
function DoubleLinkedList:tail()
	return self._tail
end

---@return number
function DoubleLinkedList:size()
	return self._size
end

---@return boolean
function DoubleLinkedList:isEmpty()
	return self._size == 0
end

---Prepends the node with a value to the beginning of the list.
---@param value any
---@return Node
function DoubleLinkedList:prepend(value)
	local node = Node:new(value)
	if self._head == nil then
		self._tail = node
		self._head = node
	else
		node = self:insertBefore(self._head, node.value)
	end
	self._size = self._size + 1
	return node
end

---Appends the node with a value to the end of the list.
---@param value any
---@return Node
function DoubleLinkedList:append(value)
	local node = Node:new(value)
	if self._tail == nil then
		node = self:prepend(value)
	else
		node = self:insertAfter(self._tail, node.value)
	end
	self._size = self._size + 1
	return node
end

---Inserts a new node with value after given node.
---@param after Node
---@param value any
---@return Node
function DoubleLinkedList:insertAfter(after, value)
	local node = Node:new(value)
	node.prev = after
	if node.next == nil then
		self._tail = node
	else
		node.next = after.next
		after.next.prev = node
	end
	self._size = self._size + 1
	after.next = node
	return node
end

---Inserts a new node with value before given node.
---@param before Node
---@param value any
---@return Node
function DoubleLinkedList:insertBefore(before, value)
	local node = Node:new(value)
	node.next = before
	if node.prev == nil then
		self._head = node
	else
		node.prev = before.prev
		before.prev.next = node
	end
	self._size = self._size + 1
	before.prev = node
	return node
end

---Removes and returns a node after given node. If given node not
---found nil is returned.
---@param node Node nil
---@return Node | nil
function DoubleLinkedList:removeNode(node)
	if not node then
		return nil
	end
	self._size = self._size - 1
	if node.prev == nil then
		self._head = node.next
	else
		node.prev.next = node.next
	end

	if node.next == nil then
		self._tail = node.prev
	else
		node.next.prev = node.prev
	end
	return node
end

---Removes and returns a node after given node. If given node not found nil is
---returned.
---@param node Node
---@return Node | nil
function DoubleLinkedList:removeAfter(node)
	local tmp = node.next
	node.next = tmp and tmp.next
	return tmp
end

---Chekcs if the list contins a give value.
---@param value any
---@return boolean
function DoubleLinkedList:contains(value)
	return self:findByValue(value) ~= nil
end

---Finds the first occurrence of the value.
---@param value any
---@return Node | nil
function DoubleLinkedList:findByValue(value)
	local node = self._head
	while node do
		if node.value == value then
			return node
		end
		node = node.next
	end
	return nil
end

---Traversal of a linked list in forwards direction.
---@param fn fun(node: Node)
function DoubleLinkedList:traverseForwards(fn)
	local node = self._head
	while node do
		fn(node)
		node = node.next
	end
end
--
---Traversal of a linked list in backwards direction.
---@param fn fun(node: Node)
function DoubleLinkedList:traverseBackwards(fn)
	local node = self._tail
	while node do
		fn(node)
		node = node.prev
	end
end

---@param sep? string
---@return string
function DoubleLinkedList:toString(sep)
	sep = sep or " -> "
	local t = {}
	self:traverseForwards(function(node)
		t[#t + 1] = tostring(node.value)
	end)
	return table.concat(t, sep)
end

return DoubleLinkedList
```

### Usage of DoublyLinkedList class

```lua
local dll = DoubleLinkedList:new()
dll:append("A")
dll:append("B")
dll:prepend("C")
dll:prepend("D")
print(dll:toString()) --> "D -> C -> A -> B"
print(dll:contains("A"), dll:contains("X")) --> true	false
local found = dll:findByValue("A")
if found then
	print(dll:removeNode(found).value) --> "A""
end
print(dll:toString()) --> "D -> C ->  B"
```

## References

- [Wikipedia: Linked list](https://en.wikipedia.org/wiki/Linked_list)
- [Wikipedia: Doubly linked list](https://en.wikipedia.org/wiki/Doubly_linked_list)
- [Programming in Lua: Linked lists](https://www.lua.org/pil/11.3.html)