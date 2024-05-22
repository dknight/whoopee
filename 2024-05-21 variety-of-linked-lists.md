<!-- Description: Linked list is a classical data structure that can be used as data storage for different algorithms and efficient data management. -->

tags: data-structures

# Variety of linked lists

A linked list is a classical data structure that can be used as data storage
for different algorithms and efficient memory management. Usually, for the
tasks that Lua programming language solves, linked lists are rarely used. In
most cases [stack](/post/stack.html) and [queue](/post/queue.html) are enough,
but for some tasks linked lists are irreplaceable.

Here are some variations of linked lists with links to implementation in Lua.

- [Singly linked list](/post/linked-list.html) -- the most simple linked list
  where nodes are connected linearly and sequentially, where a node has its
  value and points to the next node.
- [Circular singly linked list](/post/circular-linked-list.html) -- same as
  the linear singly linked list, but nodes are connected in a continuous
  circular manner.
- [Doubly linked list](/post/doubly-linked-list.html) -- linked list with
  two pointers: one for the next node and the other for the previous.
- [Circular doubly linked list](/post/circular-doubly-linked-list.html) --
  same as the doubly linked list with two pointers to the next and previous
  node connected in a continuous circular manner.

## Advanced

There are much more advanced variations of linked lists, which are rarely used
and almost never in interpreted languages like Lua. These are meant for working
and optimizing work with memory on a lower level. Maybe someday I will also 
implement them as examples for Lua language.

- XOR linked list
- Asymmetric linked list
- Sparse linked lists
- In-memory linked list
- Intrusive linked list
- More...