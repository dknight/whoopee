<!-- Description: Coroutines are a powerful tool in Lua language to provide asynchronous programming, but these might be a bit hard to understand for beginners.-->

tags: lua

# Understanding coroutines in Lua

<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>

[TOC]

## Basics

Coroutines in Lua are special threads with their own scope, stack, and instruction pointers.
Coroutines  are able to run simultaneously in the main thread. Another important
statement that coroutines  share global variables. All coroutines are stored in Lua's built-in
`coroutine` table.

Coroutines are not really parallel; **Lua is a strictly single-threaded language**. Coroutine
executes the function for a while, after returns back to the point (with the same state), where
it was called. Using coroutines, you can modify (and in some cases facilitate) how the code
behaves, to make it more evident or legible.

Coroutine has a special type `thread`.

Coroutine might have 4 states:

- **Suspended**: The state of a coroutine when it is newly created or after it has yielded.
- **Running**: The state of a coroutine when it is actively executing.
- **Normal**: The state of a coroutine after it has completed its execution successfully.
- **Dead**: The state of a coroutine when it has either encountered an error or is no longer able to resume.

When a coroutine is created, it starts in a `suspended` state.

```lua
local co = coroutine.create(function()
	print("Hello, world")
end)

print(co) --> thread: 0x69fcea8
coroutine.status(co) --> suspended
```

Function `coroutine.resume()` continues or begins to execute the coroutine.

```lua
coroutine.resume(co) --> true	"Hello, world"
```

After the run of the coroutine, it finishes its own lifecycle and get `dead` status.

```lua
coroutine.status(co) --> dead
```

In the example above, it makes no sense to create coroutines, because it looks like a common
function call. But the most powerful feature of coroutines is `corputine.yield()` function,
which allows you to suspend an execution of the coroutine for later. On the creation, the
coroutine has `suspended` state. When the coroutine is finished, the statue becomes `dead` and
the call-off with `corputine.resume()` returns `false` and the error message
`cannot resume dead coroutine`.

Consider:

```lua
local co = coroutine.create(function()
	for i = 1, 5 do
		print("iteration " .. i)
		coroutine.yield()
	end
end)

print(coroutine.status(co)) --> "suspended"
coroutine.resume(co) --> "iteration 1"
print(coroutine.status(co)) --> "suspended"
coroutine.resume(co) --> "iteration 2"
print(coroutine.status(co)) --> "suspended"
coroutine.resume(co) --> "iteration 3"
print(coroutine.status(co)) --> "suspended"
coroutine.resume(co) --> "iteration 4"
print(coroutine.status(co)) --> "suspended"
coroutine.resume(co) --> "iteration 5"
print(coroutine.status(co)) --> "suspended"
coroutine.resume(co) --> "iteration 5"
print(coroutine.status(co)) --> "dead"

local ok, err = coroutine.resume(co)
print(ok, err) --> false	"cannot resume dead coroutine"
```

Illustration of coroutine lifecycle of the example above.

![Illustration of coroutine lifecycle](/assets/img/coroutines01.svg)

![Coroutines working with main thread](/assets/img/coroutines02.svg)

## Error handling in coroutines

!!! tip
    It is always a good practice to check for the errors.

Execution of the coroutine happens in *protected mode*; this means if there is an error inside
coroutine body nothing will be reported.

Consider:

```lua
local co = coroutine.create(function()
	error("Kabooom!")
end)
coroutine.resume(co)
-- nothing printed nor reported
```

Correct way to handle the errors in the coroutine.

```lua
local co = coroutine.create(function()
	error("Kabooom!")
end)
local ok, err = coroutine.resume(co)
print(ok, err) --> false   co.lua:2: Kabooom!
```

### Wrapping coroutines

As we already know, coroutines are implicitly running in *protected mode*. If there is a need
to handle error with `pcall` or, `xpcall` coroutine can be wrapped with `coroutine.wrap()`.

`coroutine.wrap` creates a new coroutine with the function `func` as its body; it `func `must
be a valid function. The coroutine returns a function that resumes execution each time it is
invoked. Any arguments passed to this returned function are treated as additional arguments
for the resume operation. The function yields the same results as, `coroutine.resume`
excluding the initial boolean value. If an error occurs, the coroutine is closed, and the
error is propagated and can be caught with `pcall` or `xpcall`.

Consider:

```lua
local co = coroutine.wrap(function()
	error("Kabooom!")
end)
local ok, err = pcall(co)
print(ok, err) --> false   co.lua:2: Kabooom!
```

## Arguments in the coroutines and data exchange

Coroutines can receive any number of arguments like common functions.

```lua
local co = coroutine.create(function(a, b) 
	print(a * b)
end)

coroutine.resume(co, 6, 7) --> 42
```

Arguments also can be yielded `coroutine.yield()` returns status `true` in case of success, or
`false` in case of an error inside a coroutine, after the status arguments follow
the `coroutine.resume()` function.

```lua
local co = coroutine.create(function(a, b)
	coroutine.yield("The meaning of life is", a * b)
end)

local ok, message, value = coroutine.resume(co, 6, 7)
print(message, value, ok) --> "The meaning of life is"	42	true
```

## Basic example

Here is an artificial example, but it very well demonstrates how multiple coroutines are
running simultaneously. Every coroutine has a delay number.

```lua
local heavyFunction = function(secondsDelay, number)
	local start = os.time()
	while (os.time() - start) < secondsDelay do
		-- do nothing, loop just for a delay
	end
	print(
			string.format(
					"coroutine %d finshed after %d second(s)",
					number,
					secondsDelay
			)
	)
end

local co1 = coroutine.create(heavyFunction)
local co2 = coroutine.create(heavyFunction)
local co3 = coroutine.create(heavyFunction)
coroutine.resume(co1, 1, 3)
print("returned to main thread")
coroutine.resume(co2, 2, 2)
print("returned to main thread")
coroutine.resume(co3, 3, 1)
print("returned to main thread")
-- Output:
-- coroutine 3 finished after 1 second(s)
-- returned to main thread
-- coroutine 2 finished after 2 second(s)
-- returned to main thread
-- coroutine 1 finished after 3 second(s)
-- returned to main thread
```

## HTTP request example

Making the HTTP request with coroutine, for the example below
[LuaSocket](https://github.com/lunarmodules/luasocket) library is required to be installed.

```lua
local http = require("socket.http")
local URL = "https://www.whoop.ee"

local request = coroutine.create(function(url, headers)
	headers = headers or {}
	local body, status = http.request(url)
	coroutine.yield(status, #body)
end)

local ok, code, length = coroutine.resume(request, URL)
print(ok, code, length) --> true	200	7641
```

## Advanced

### Producer, filter, consumer pattern.

Pretty common pattern using coroutines: producer, filter, consumer. In this pattern there might
be any number of filters between producer and consumer. Benefits of this approach are easy to
maintain.

![Producer, filter, consumer pattern with coroutines in Lua](/assets/img/coroutines03.svg)

```lua
---Some delay
---@oaran seconds number
local function sleep(seconds)
    -- Fox Unix-like
    os.execute(string.format("sleep %d", seconds))
    -- For Windows
    -- os.execute(string.format("timeout %d", seconds))
end

---Pong producer
---@return thread
local pong = function()
    return coroutine.create(function()
        coroutine.yield("pong")
    end)
end

---Ping producer
---@return thread
local ping = function()
    return coroutine.create(function()
        coroutine.yield("ping")
    end)
end

---Filter adds "ping|ping hit X"
---@param coPing function
---@param coPong function
local hitsFilter = function(coPing, coPong)
    return coroutine.create(function()
        local hit = 0
        while true do
            hit = hit + 1
            local _, x = coroutine.resume(coPing())
            coroutine.yield(x .. " hit " .. hit)
            hit = hit + 1
            sleep(1)
            _, x = coroutine.resume(coPong())
            coroutine.yield(x .. " hit " .. hit)
            sleep(1)
        end
    end)
end

---Play consumer
---@param filter thread
local function play(filter)
    while true do
        local _, s = coroutine.resume(filter)
        print(s)
    end
end

---Run
play(hitsFilter(ping, pong))
-- Output every second:
-- ping hit 1
-- pong hit 2
-- ping hit 3
-- pong hit 4
-- etc..
```

## References

- [Programming in Lua: Coroutine Basics](https://www.lua.org/pil/9.1.html)
- [Lua Manual: Coroutines](https://www.lua.org/manual/5.4/manual.html#2.6)