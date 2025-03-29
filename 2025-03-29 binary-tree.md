<!-- Description:  Definitive guide and implementation of the binary tree in Lua language. Binary is one of the most important data structures, used in different kinds of advanced algorithms, like pathfinding, detecting cycles, logistics, maps, etc.  -->

tags: lua data-structures algorithms

# Binary tree

<div>
<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>
</div>
[TOC]

A **Binary Tree** is a non-linear and hierarchical data structure where each node can have up to two children, known as the **left child** and **right child**. It is widely used in computer science and makes it easy to store and retrieve data by letting you do things like adding, deleting, and traversing. The topmost node in a binary tree is called the **root**, and the bottom-most nodes are called leaves.

## Structure of Binary Tree

![Example of Binary tree Data Structure](/assets/img/binary-tree-01.svg)

- **Nodes**: The core components of a binary tree, each containing data and links to two child nodes (left and right).
- **Root**: The highest node in the tree, which has no parent and acts as the origin of all other nodes.
- **Parent node**: A node that has one or more children. **In a binary tree, a parent node can have at most two child nodes**.
- **Child node**: A node that descends from another node (its parent), categorized as either a left or right child.
- **Leaf node**: A node without any children. In Lua, this means both of its child nodes are `nil`.
- **Height of binary tree**: The count of nodes along the longest path from the root to the deepest leaf, or the total number of levels.
- **Depth of a node**: The number of edges between a given node and the root. The root node has a depth of `0`.
- **Subtree**: A section of the tree that forms its own hierarchy, often represented as a magenta triangle in a diagram above.  

## Building Binary tree

### Binary Tree module

First, let's create a class `BinaryTree` with a static method `createNode` Also, here we can define type `Node` to improve DX.

```lua
---@class BinaryTree
local BinaryTree = {
    ---Create a new node
    ---@param data any
    ---@return Node
    createNode = function(data)
        return {
            left = nil,
            right = nil,
            data = data,
        }
    end,
}
BinaryTree.__index = BinaryTree

---Creates new Binary Tree
---@return BinaryTree
function BinaryTree:new()
    local t = {
        root = nil,
    }
    return setmetatable(t, self)
end
```

### Building Binary Tree as the diagram

To build a tree, we need to create nodes and make relations between them.

```lua
local a = BinaryTree.createNode("A") -- root
local b = BinaryTree.createNode("B")
local c = BinaryTree.createNode("C")
local d = BinaryTree.createNode("D")
local e = BinaryTree.createNode("E")
local f = BinaryTree.createNode("F")
local g = BinaryTree.createNode("G")
local h = BinaryTree.createNode("H")

local btree = BinaryTree:new()
btree.root = a

a.left = b
a.right = c
b.left = d
b.right = e
e.left = g
e.right = h
c.left = f
```

## Binary Tree operations

### Traverse

Traversal in a binary tree involves visiting all the nodes of the binary tree. Like in [graphs](/post/graph.html) traversal algorithms can be classified broadly into two categories, **DFS** and **BFS**. Here we use `callback` pattern to make operations with the node on traversal.

```lua
---@alias BinaryTreeCallback fun(node: Node)
```

#### Depth-First Search (DFS) algorithms

DFS explores as far down a branch as possible before backtracking. It is implemented using recursion. The main traversal methods in DFS for binary trees.

##### Pre-order Traversal

Visits the node first, then the left subtree, then the right subtree.

```lua
---Pre-order DFS: Root, Left, Right
---@param node Node | nil
---@param callback BinaryTreeCallback
function BinaryTree:preOrderDFS(node, callback)
    if node == nil then
        return
    end
    if type(callback) == "function" then
        callback(node)
    end
    self:preOrderDFS(node.left, callback)
    self:preOrderDFS(node.right, callback)
end
```

##### Post-order Traversal

Visits the left subtree, then the right subtree, then the node.

```lua
---Post-order DFS: Left, Right, Root
---@param node Node | nil
---@param callback BinaryTreeCallback
function BinaryTree:postOrderDFS(node, callback)
    if node == nil then
        return
    end
    self:postOrderDFS(node.left, callback)
    self:postOrderDFS(node.right, callback)
    if type(callback) == "function" then
        callback(node)
    end
end
```

##### In-order Traversal

Visits the left subtree, then the node, then the right subtree.

```lua
---In-order DFS: Left, Root, Right
---@param node Node
---@param callback BinaryTreeCallback
function BinaryTree:inOrderDFS(node, callback)
    if node == nil then
        return
    end
    self:inOrderDFS(node.left, callback)
    if type(callback) == "function" then
        callback(node)
    end
    self:inOrderDFS(node.right, callback)
end
```

#### Breadth-First Search (BFS)

BFS explores all nodes at the present depth before moving on to nodes at the next depth level. It is typically implemented using a [queue](/post/queue.html).

```lua
---BFS: Level order traversal
---@param callback BinaryTreeCallback
function BinaryTree:BFS(callback)
    if self.root == nil then
        return
    end
    local queue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local node = queue:dequeue()
        if type(callback) == "function" then
            callback(node)
        end
        if node.left ~= nil then
            queue:enqueue(node.left)
        end
        if node.right ~= nil then
            queue:enqueue(node.right)
        end
    end
end
```

### Searching

Searching for a value in a binary tree means looking through the tree to find a node that has that value. Since binary trees do not have a specific order like binary search trees, we typically use any [traversal method](#traverse) to search. It is good to define `predicate` type to make possible more complex search comparisons.

```lua
---@alias BinaryTreePredicate fun(node: Node, needle: any): boolean 
```

```lua
---Checks that value has a node
---@param node Node | nil
---@param needle any
---@param predicate BinaryTreePredicate
function BinaryTree:contains(node, needle, predicate)
    -- Base case: If the tree is empty or we've reached
    if node == nil then
        return false
    end

    -- If the node's data is equal to the value we are searching for.
    if predicate(node, needle) then
        return true
    end

    -- Recursively search in the left and right subtrees
    local leftFound = self:contains(node.left, needle, predicate)
    local rightFound = self:contains(node.right, needle, predicate)

    return leftFound or rightFound
end
```

### Insertion

Inserting elements into a binary tree involves adding a new node. Since a binary tree does not follow a specific ordering of elements, there is no need to consider their arrangement. If the tree is empty, the first step is to create a root node. For subsequent insertions, the process involves iteratively searching each level of the tree for an available spot. When an empty left or right child is found, the new node is inserted in that position. By convention, insertion begins with the left child node.

```lua
---Inserts new element to the binary tree.
---@param data any
---@return Node
function BinaryTree:insert(data)
    if self.root == nil then
        self.root = BinaryTree.createNode(data)
        return self.root
    end
    local queue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local temp = queue:dequeue()

        if temp.left == nil then
            temp.left = BinaryTree.createNode(data)
            break
        else
            queue:enqueue(temp.left)
        end

        if temp.right == nil then
            temp.right = BinaryTree.createNode(data)
            break
        else
            queue:enqueue(temp.right)
        end
    end
    return root
end
```

### Deletion

Deleting a node from a binary tree involves removing a specific node while maintaining the tree’s structure. First, locate the node to be deleted by traversing the tree using any traversal method. Then, replace its value with the value of the last node in the tree, which can be found by navigating to the rightmost leaf. After that, delete the last node to preserve the tree's structure. It is essential to handle special cases, such as deleting from an empty tree, to prevent errors.

!!! tip
	There is no fixed rule for deletion, but it is crucial to ensure that the fundamental properties of the binary tree are maintained.

```lua
---Deletes an element from the binary tree.
---@param data any
---@return Node | nil
function BinaryTree:delete(data)
    if self.root == nil then
        return nil
    end
    local target
    local queue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local currNode = queue:dequeue()

        if currNode.data == data then
            target = currNode
            break
        end
        if currNode.left ~= nil then
            queue:enqueue(currNode.left)
        end
        if currNode.right ~= nil then
            queue:enqueue(currNode.right)
        end
    end
    if target == nil then
        return self.root
    end

    -- Find the deepest rightmost node and its parent
    local lastNode, lastParent
    queue = Queue:new()
    local parentQueue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local currentNode = queue:dequeue()
        local parentNode = parentQueue:dequeue()
        lastNode = currentNode
        lastParent = parentNode

        if currentNode.left ~= nil then
            queue:enqueue(currentNode.left)
            parentQueue:enqueue(currentNode)
        end
        if currentNode.right ~= nil then
            queue:enqueue(currentNode.right)
            parentQueue:enqueue(currentNode)
        end
    end

    -- Replace target's value with the last node's value
    target.data = lastNode.data

    -- Remove the last node
    if lastParent ~= nil then
        if lastParent.left == lastNode then
            lastParent.left = nil
        else
            lastParent.right = nil
        end
    else
        return nil
    end
    return self.root
end
```

### Get size of the tree

Calculates the number of nodes in the binary tree.

```lua
---Gets the number of nodes in BinaryTree.
---@return number
function BinaryTree:size()
    local n = 0
    self:preOrderDFS(self.root, function()
        n = n + 1
    end)
    return n
end
```

### Get level (depth) of a node

Gets how deep the node is.

```lua
---Gets the depth of the given node. 0 is for the root node, -1 if tree is empty.
---@param target any
---@param level? number
---@param node? Node | nil
---@return number
function BinaryTree:getLevel(target, level, node)
    level = level or 0
    node = node or self.root
    if node == nil then
        return -1
    end

    if target == node.data then
        return level
    end

    local leftLevel = -1
    if node.left ~= nil then
        leftLevel = self:getLevel(target, level + 1, node.left)
        if leftLevel ~= -1 then
            return leftLevel
        end
    end

    if node.right ~= nil then
        return self:getLevel(target, level + 1, node.right)
    end
    return -1
end
```

### Get the height (depth) of the tree

Get the total levels (depth or height) of the binary tree.

```lua
---@param node Node | nil
---@return number
function BinaryTree:getHeight(node)
    node = node or self.root
    if node == nil then
        return -1
    end

    local leftHeight = node.left ~= nil and self:getHeight(node.left) or -1
    local rightHeight = node.right ~= nil and self:getHeight(node.right) or -1
    return math.max(leftHeight, rightHeight) + 1
end
```

## `BinaryTree.lua`

```lua
local Queue = require("./Queue")

---@class Node
---@field public left Node | nil
---@field public right Node | nil
---@field public data any

---@alias BinaryTreeCallback fun(node: Node)
---@alias BinaryTreePredicate fun(node: Node, needle: any): boolean

---@BinaryTreePredicate
local compare = function(node, value)
    return node.data == value
end

---@class BinaryTree
local BinaryTree = {
    ---Create a new node
    ---@param data any
    ---@return Node
    createNode = function(data)
        return {
            left = nil,
            right = nil,
            data = data,
        }
    end,
}
BinaryTree.__index = BinaryTree

---Creates new Binary Tree
---@return BinaryTree
function BinaryTree:new()
    local t = {
        root = nil,
    }
    return setmetatable(t, self)
end

---Pre-order DFS: Root, Left, Right
---@param node Node | nil
---@param callback BinaryTreeCallback
function BinaryTree:preOrderDFS(node, callback)
    if node == nil then
        return
    end
    if type(callback) == "function" then
        callback(node)
    end
    self:preOrderDFS(node.left, callback)
    self:preOrderDFS(node.right, callback)
end

---Post-order DFS: Left, Right, Root
---@param node Node | nil
---@param callback BinaryTreeCallback
function BinaryTree:postOrderDFS(node, callback)
    if node == nil then
        return
    end
    self:postOrderDFS(node.left, callback)
    self:postOrderDFS(node.right, callback)
    if type(callback) == "function" then
        callback(node)
    end
end

---In-order DFS: Left, Root, Right
---@param node Node
---@param callback BinaryTreeCallback
function BinaryTree:inOrderDFS(node, callback)
    if node == nil then
        return
    end
    self:inOrderDFS(node.left, callback)
    if type(callback) == "function" then
        callback(node)
    end
    self:inOrderDFS(node.right, callback)T
end

---BFS: Level order traversal
---@param callback BinaryTreeCallback
function BinaryTree:BFS(callback)
    if self.root == nil then
        return
    end
    local queue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local node = queue:dequeue()
        if type(callback) == "function" then
            callback(node)
        end
        if node.left ~= nil then
            queue:enqueue(node.left)
        end
        if node.right ~= nil then
            queue:enqueue(node.right)
        end
    end
end

---Checks that value has a node
---@param node Node | nil
---@param needle any
---@param predicate BinaryTreePredicate
function BinaryTree:contains(node, needle, predicate)
    -- Base case: If the tree is empty or we've reached
    if node == nil then
        return false
    end

    -- If the node's data is equal to the value we are
    -- searching for
    if predicate(node, needle) then
        return true
    end

    -- Recursively search in the left and right subtrees
    local leftFound = self:contains(node.left, needle, predicate)
    local rightFound = self:contains(node.right, needle, predicate)

    return leftFound or rightFound
end

---Inserts new element to the binary tree.
---@param data any
---@return Node
function BinaryTree:insert(data)
    if self.root == nil then
        self.root = BinaryTree.createNode(data)
        return self.root
    end
    local queue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local temp = queue:dequeue()

        if temp.left == nil then
            temp.left = BinaryTree.createNode(data)
            break
        else
            queue:enqueue(temp.left)
        end

        if temp.right == nil then
            temp.right = BinaryTree.createNode(data)
            break
        else
            queue:enqueue(temp.right)
        end
    end
    return root
end

---Deletes an element from the binary tree.
---@param data any
---@return Node | nil
function BinaryTree:delete(data)
    if self.root == nil then
        return nil
    end
    local target
    local queue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local currNode = queue:dequeue()

        if currNode.data == data then
            target = currNode
            break
        end
        if currNode.left ~= nil then
            queue:enqueue(currNode.left)
        end
        if currNode.right ~= nil then
            queue:enqueue(currNode.right)
        end
    end
    if target == nil then
        return self.root
    end

    -- Find the deepest rightmost node and its parent
    local lastNode, lastParent
    queue = Queue:new()
    local parentQueue = Queue:new()
    queue:enqueue(self.root)

    while not queue:isEmpty() do
        local currentNode = queue:dequeue()
        local parentNode = parentQueue:dequeue()
        lastNode = currentNode
        lastParent = parentNode

        if currentNode.left ~= nil then
            queue:enqueue(currentNode.left)
            parentQueue:enqueue(currentNode)
        end
        if currentNode.right ~= nil then
            queue:enqueue(currentNode.right)
            parentQueue:enqueue(currentNode)
        end
    end

    -- Replace target's value with the last node's value
    target.data = lastNode.data

    -- Remove the last node
    if lastParent ~= nil then
        if lastParent.left == lastNode then
            lastParent.left = nil
        else
            lastParent.right = nil
        end
    else
        return nil
    end
    return self.root
end

---Gets the number of nodes in BinaryTree.
---@return number
function BinaryTree:size()
    local n = 0
    self:preOrderDFS(self.root, function(_)
        n = n + 1
    end)
    return n
end

---@param node Node | nil
---@return number
function BinaryTree:getHeight(node)
    node = node or self.root
    if node == nil then
        return -1
    end

    local leftHeight = node.left ~= nil and self:getHeight(node.left) or -1
    local rightHeight = node.right ~= nil and self:getHeight(node.right) or -1
    return math.max(leftHeight, rightHeight) + 1
end

---Gets the depth of the given node. 0 is for the root node, -1 if the Binary Tree is empty.
---@param target any
---@param level? number
---@param node? Node | nil
---@return number
function BinaryTree:getLevel(target, level, node)
    level = level or 0
    node = node or self.root
    if node == nil then
        return -1
    end

    if target == node.data then
        return level
    end

    local leftLevel = -1
    if node.left ~= nil then
        leftLevel = self:getLevel(target, level + 1, node.left)
        if leftLevel ~= -1 then
            return leftLevel
        end
    end

    if node.right ~= nil then
        return self:getLevel(target, level + 1, node.right)
    end
    return -1
end

return BinaryTree
```

### Usage of BinaryTree class

```lua
-- Create a new binary tree instance
local btree = BinaryTree:new()

-- Creating nodes
local a = BinaryTree.createNode("A") -- root
local b = BinaryTree.createNode("B")
local c = BinaryTree.createNode("C")
local d = BinaryTree.createNode("D")
local e = BinaryTree.createNode("E")
local f = BinaryTree.createNode("F")
local g = BinaryTree.createNode("G")
local h = BinaryTree.createNode("H")

-- Make relation between root and nodes
btree.root = a
a.left = b
a.right = c
b.left = d
b.right = e
e.left = g
e.right = h
c.left = f

btree:preOrderDFS(btree.root, function(node)
    io.write(node.data, " -> ")
end)
print()
-- A -> B -> D -> E -> G -> H -> C -> F -> nil

btree:postOrderDFS(btree.root, function(node)
    io.write(node.data, " -> ")
end)
print()
-- D -> G -> H -> E -> B -> F -> C -> A -> nil

btree:inOrderDFS(btree.root, function(node)
    io.write(node.data, " -> ")
end)
print()
-- D -> B -> G -> E -> H -> A -> F -> C -> nil

btree:BFS(function(node)
    io.write(node.data, " -> ")
end)
print()
-- A -> B -> C -> D -> E -> F -> G -> H -> nil

print(btree:contains(a, "F", compare), btree:contains(a, "J", compare))

btree:insert("I")
btree:insert("J")
btree:insert("K")
btree:insert("L")
btree:preOrderDFS(btree.root, function(node)
    io.write(node.data, " -> ")
end)
print()
--A -> B -> D -> J -> K -> E -> G -> H -> C -> F -> L -> I -> nil

btree:delete("C")
btree:delete("E")
btree:preOrderDFS(btree.root, function(node)
    io.write(node.data, " -> ")
end)
print()
-- A -> B -> D -> J -> K -> H -> G -> L -> F -> I ->

print(btree:size()) --> 10
print(btree:getHeight()) --> 3
print(btree:getLevel("A")) --> 0
print(btree:getLevel("B")) --> 1
print(btree:getLevel("D")) --> 2
print(btree:getLevel("G")) --> 3
```

*[DX]: Developer Experience
*[DFS]: Depth-First Search
*[BFS]: Breadth-First Search