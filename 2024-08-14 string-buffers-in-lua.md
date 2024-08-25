<!-- Description: Working with string in Lua in performant way, using string buffers. -->

tags: lua algorithms

# String buffers in Lua

## The problem

When working with strings, using the concatenation operator `..` looks fine,
but there is a pitfall, that might lead to catastrophic performance issues.

Consider:

```lua
"Hello" .. "World" --> "HelloWorld"
```

The statement above is fair only for small strings and short loops. If there
is concatenation in the loop, there is a huge performance problem.

!!! danger
    Bad code ahead!

Consider:

```lua
local s = "abcdefghij"
local buf = ""
for i = 1, 1000000 do
	buf = buf .. s .. "\n"
end
print(buf)
```

At first glance, it seems to be very innocent, but why is it bad? Since strings
in Lua are **immutable**, each concatenation creates a new string object and
copies the data from the source strings to it. That makes successive
concatenations of a single string have very poor performance.

Let's assume we read 10 bytes from each line.

| Iteration | Old string size | New string size | Copied memory |
|----------:|----------------:|----------------:|--------------:|
|         1 |               0 |              10 |            10 |
|         2 |              10 |              20 |            30 |
|         3 |              20 |              30 |            50 |
|         4 |              30 |              40 |            70 |
|         5 |              40 |              50 |            90 |
|       ... |             ... |             ... |           ... |
|      1999 |           19980 |           19990 |         20000 |
|      2000 |           19990 |           20000 |         20010 |
|           |                 |       **Total** |  **19992000** |

Let's continue to the 1999th iteration. A new string will be created with a
length of 20,000 bytes. Lua needs to allocate 20,000 bytes of memory and copy
old and new strings into this buffer. In every iteration, Lua should allocate
more and more memory to newly created strings. There is also more memory to
clean up the old strings, which must be cleaned by the garbage collector.
This procedure has *O(n<sup>2</sup>)* complexity, which is the worst for
such a simple task.

![Figure 01: String concatenation problem](/assets/img/string-buffers.svg)

## Solution

This problem is not valid only for Lua; most of the C-like languages have the same
issues with memory allocation. To avoid this, other languages like Java have
`StringBuffer` and `StringBuilder` classes; in Go, there are `bytes.Buffer`
and `strings.Builder`, etc. In Lua, there is an old-good `table` data
structure for this purpose. The initial example can be rewritten using
`table.concat()`, as follows:

```lua
local s = "abcdefghij"
local buf = {}
for i = 1, 1000000 do
	buf[#buf + 1] = s
end
table.concat(buf, "\n")
```
The code above is 1000+ times faster than using `..` operator in the loop.

## Going deeper

It is good to know why `table.concat()` is so much faster than concatenations.
If we check Lua’s source code ([ltablib.c](https://www.lua.org/source/5.4/ltablib.c.html#tconcat))
for the `table.concat()` function, it is not hard to understand that it uses the stack data structure.

Demonstration of implementation using [a stack data structure](/post/stack.html).
This is definitely slower than `table.concat()` because the Lua standard library is compiled
into binary from C code. Still, home-made stack implementation is much faster
than only concatenations.

```lua
local Stack = require("Stack")

-- Create an empty stack
local stack = Stack:new()

-- Start with an empty string
stack:push("")

--- Add 1 million records
for i = 1, 1000000 do
	stack:push(s)
	for j = #stack - 1, 1, -1 do
		if string.len(stack[j]) > string.len(stack[j + 1]) then
			break
		end
		stack[j] = stack[j] .. table.remove(stack)
	end
end
```

## Benchmarking

I use my old Lenovo laptop (3.7GHz 4-core, 8Gb RAM) to benchmark the code.
Even with the rough benchmarking, using `time` utility, the results are
self-explanatory: **the difference is about an hour**!

### Code with table buffer (the fastest)

```
real    0m0.091s
user    0m0.072s
sys     0m0.018s
```

### Code with Stack the class (fast)

```
real    0m0.592s
user    0m0.563s
sys     0m0.021s
```
### Code with concatenation (incredibly slow)

```
real    55m16.051s
user    25m52.709s
sys     27m0.053s
```

## Conclusion

First of all, if there is a need to concatenate strings in the loop, it is a good idea to
stop for a moment and think twice. For small strings or short loops, the `..` concatenation
operator is OK. But for longer strings and long loops with concatenation, `table.concat()`
is worth trying to significantly improve the performance.

## References

- [Lua Manual: 3.4.6 Concatenation](https://www.lua.org/manual/5.4/manual.html#3.4.6)
- [Programming In Lua: 11.6 String Buffers](https://www.lua.org/pil/11.6.html)