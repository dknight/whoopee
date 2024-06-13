<!-- Description: Object-oriented tutorial for Lua language. Examples with metatables, classes-, closure-, prototype-based and inheritance. -->

tags: lua featured

# Object-oriented programming in Lua

[TOC]

Lua doesn't have classes and objects. [`table`](https://www.lua.org/manual/5.4/manual.html#6.6) is a single data structure to represent everything: arrays, maps, sets,
lists, queues, etc. Classes and OOP can be emulated with `table` data
structure and [metatables and metamethods](https://www.lua.org/manual/5.4/manual.html#2.4).
At first sight, it might be a bit confusing, but actually, it is a dead
simple solution.

## Metametable based classes

The most simple way to create a class is just to use a `table`.

Consider:

```lua
local Animal = {
  age = 0,
  kind = "unknown",
  sound = "silence",
  makeSound = function(self)
    print(self.sound)
  end,
}

Animal.age = 2
Animal.kind = "feline"
Animal.sound = "Meow!"
print(Animal.makeSound(Animal)) --> "Meow!"
```

Looks like it works, but here is a drawback; there is only **one instance** of
the `Animal` class and new instances cannot be created. Also please notice the
`self` variable in the `Animal:makeSound()` function, this is the same as
`Animal.makeSound(Animal)`. It is similar to JavaScript
[function binding](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind).

### Making instances

Firstly, just create an empty table.

```lua
local Animal = {}
```

Next, create a `new()` method which will return the instance of the class.

```lua
function Animal:new()
	local t = {}
	return t
end
```

Arguments can be passed in the function to set properties.
Also, methods can be defined here, if needed:

```lua
function Animal:new(age, kind, sound)
	local t = {}
	t.age = age
	t.kind = kind
	t.sound = sound
	return t
end
```

Everything together with instances.

```lua
local Animal = {}

function Animal:new(age, kind, sound)
	local t = {}
	t.age = age
	t.kind = kind
	t.sound = sound
	return t
end

function Animal.makeSound(self)
	return self.sound
end

local cat = Animal:new(2, "feline", "Meow!")
print(cat.kind, Animal.makeSound(cat)) --> "feline" "Meow!"

local dog = Animal:new(3, "canis", "Woof!")
print(dog.kind, Animal.makeSound(dog)) --> "canis" "Woof!"

local hamster = Animal:new(1, "cricetinae", "Eeeee!")
print(hamster.kind, Animal.makeSound(hamster)) --> "cricetinae" "Eeeee!"
```

It works! In this approach, methods can be accessed from the class, but the
syntax is a bit weird. From this point, `__index` metamethod comes to help
to make everything better.

### Metamethod `__index`

Lua allows to overload operators like `+`, `-`, `/`, `*` with metamethods.
In a lot of cases, metamethods can lead to great confusion, but for OO classes,
it works greatly. There is metatmethod `__index` which overrides table
indexing mechanics. Failed methods lookups on the instances will get the class
table to access the methods and members.

Consider:

```lua
local t = { x = 1 }
print(t.x) --> 1
print(t.y) --> nil
print(t.z) --> nil
```

Here `t` table doesn't have `y` key, so `nil` is returned. But, `__index`
metamethod set using built-in Lua's function `setmetatable()` overrides
this behavior:

```lua
setmetatable(t, {
  __index = { y = 2, z = 3 }
})
print(t.x) --> 1
print(t.y) --> 2
print(t.z) --> 3
```

### Defining metatable

```lua
Animal.__index = Animal
```

This makes the "magic", if method lookup fails on the instances, then it will
return the class' table to access the methods. After this, `:` method access
operator can be used to make the syntax more clear.

```lua
local Animal = {}
Animal.__index = Animal -- this makes "magic"

function Animal:new(age, kind, sound)
	local t = {}
	t.age = age
	t.kind = kind
	t.sound = sound
	return setmetatable(t, self)
end

function Animal:makeSound()
	return self.sound
end

local cat = Animal:new(2, "feline", "Meow!")
print(cat.kind, cat:makeSound()) --> "feline"	"Meow!"

local dog = Animal:new(3, "canis", "Woof!")
print(dog.kind, dog:makeSound()) --> "canis"	"Woof!"

local hamster = Animal:new(1, "cricetinae", "Eeeee!")
print(hamster.kind, hamster:makeSound()) --> "cricetinae"	"Eeeee!"
```

### Inheritance

Inheritance means that the child (subclass) class should
access all its parent methods and members and override them if needed.
It is fairly easy to achieve.

Another way to use metatables:

```lua
local Cat = {}

function Cat:new(age)
	local t = {
		age = age,
		kind = "feline",
		sound = "Meow!",
	}
	setmetatable(t, { __index = Cat })
	setmetatable(Cat, { __index = Animal })
	return t
end

-- override
function Cat:makeSound()
	return string.rep(self.sound, 3)
end

local kitty = Cat:new(4)
print(kitty.age, kitty.kind, kitty:makeSound()) --> 4	"feline"	"Meow!Meow!Meow!"
```

### Limitations

There are no real private members or methods in Lua. Usually, these are
prefixed with underscore `_`. But actually, everything is public with
this approach.

Another good way to mark method or member as private use
[annotations](#annotations).
Modern IDEs should help with that.

```lua
Animal:_privateMethod()
```

Also, there is no static scope for classes. Somewhat similar to static can be
achieved using the table constructor. But such defined members also will be
accessible on the instances.

```lua
local Cat = {
	REIGN = "mammals"
  -- ...
}

function Cat:new()
	-- ...
end

print(Cat.REIGN) --> "mammals"
```

## Closure-based classes

Another approach is to use closure for classes. One of the
advantages private variables can be used as `local` variables. The Second
advantage is no need to deal with metatables and `:` method accessor.

Consider `Animal` class:

```lua
local function Animal(age, kind, sound)
	local self = {
		age = age or 0,
		kind = kind or "unknown",
		sound = sound or "silence",
	}

	function self.makeSound()
		return self.sound
	end

	---@private
	local function privateMethod()
		return 'something private'
	end

	return self
end

local cat = Animal(2, "feline", "Meow!")
print(cat.age, cat.kind, cat.makeSound())
```

### Inheritance

Inheritance for closure-based is also straightforward.

```lua
local function Animal(age, kind, sound)
	local self = {
		age = age or 0,
		kind = kind or "unknown",
		sound = sound or "silence",
	}

	function self.makeSound()
		return self.sound
	end

	---@private
	local function privateMethod()
		return 'something private'
	end

	return self
end

local function Cat(age)
	local self = Animal(age, "feline", "Meow!")

	-- override
	function self.makeSound()
		return string.rep(self.sound, 3)
	end

	return self
end

local kitty = Cat(4)
print(kitty.age, kitty.kind, kitty.makeSound())
```

## Prototype-based inheritance

Prototype-based approach doesn't use classes (class-free OOP), it uses cloning
and prototype delegation. More about
[prototype-based object-oriented programming](https://en.wikipedia.org/wiki/Prototype-based_programming).

Here is the most basic example of the prototype-based approach. First of all need
to define some helper functions.

```lua
---@param a any
---@param b any
---@return table
local function clone(a, b)
	if type(a) ~= "table" then
		return b or a
	end
	b = b or {}
	b.__index = a
	return setmetatable(b, b)
end

---@param a any
---@param b any
---@return boolean
local function isPrototypeOf(b, a)
	local bType = type(b)
	local aType = type(a)
	if bType ~= "table" and aType ~= "table" then
		return bType == aType
	end
	local index = b.__index
	local _isa = index == a
	while not _isa and index ~= nil do
		index = a.__index
		_isa = index == a
	end
	return _isa
end
```
After the functions, new instances can be created:

```lua
local Animal = clone(table, {
	age = 0,
	kind = "unknown",
	sound = "silence",
	makeSound = function(self)
		return self.sound
	end,
	clone = clone,
	isPrototypeOf = isPrototypeOf,
})
print(Animal.age, Animal.kind, Animal:makeSound(), Animal:isPrototypeOf(table)) --> 0	"unknown"	"silence"	true


local cat = Animal:clone()
cat.age = 4
cat.kind = "feline"
cat.sound = "Meow!"
print(cat.age, cat.kind, cat:makeSound(), cat:isPrototypeOf(Animal)) --> 4	"feline"	"Meow!"	true

local dog = Animal:clone()
dog.age = 3
dog.kind = "canis"
dog.sound = "Woof!"
print(dog.age, dog.kind, dog:makeSound(), cat:isPrototypeOf(Animal)) --> 3	"canis"	"Woof!"	true
```

## Annotations

[Annotations](https://luals.github.io/wiki/annotations/) for
[Lua Language Server](https://luals.github.io)
can be very handy and greatly improve the DX. Here is the example for `Animal`
and `Cat` classes with annotations.

!!! tip
    Notice that annotations are just Lua's comments, but begin witha a triple
		dash (`---`).

```lua
---@class Animal
---@field public age number
---@field public kind string
---@field public sound string
local Animal = {}
Animal.__index = Animal

---@param age number
---@param kind string
---@param sound string
---@return Animal
function Animal:new(age, kind, sound)
	local t = {}
	t.age = age
	t.kind = kind
	t.sound = sound
	return setmetatable(t, self)
end

---@return string
function Animal:makeSound()
	return self.sound
end

---@class Cat : Animal
local Cat = {}

---@return Cat
function Cat:new(age)
	local t = {}
	t.age = age
	t.kind = "feline"
	t.sound = "Meow!"
	setmetatable(t, { __index = Cat })
	setmetatable(Cat, { __index = Animal })
	return t
end

-- override
function Cat:makeSound()
	return string.rep(self.sound, 3)
end

local kitty = Cat:new(1)
local tom = Cat:new(2)
print(kitty.age, kitty.kind, kitty:makeSound()) --> 1	"feline"	"Meow!Meow!Meow!"
print(tom.age, tom.kind, tom:makeSound()) --> 2	"feline"	"Meow!Meow!Meow!"
```

## Comparison

This is a *very rough* comparison. The results are average for many runs.

Resources consumed:

| Approach  | Memory       | Time      |
| --------- | ------------ | --------- |
| Closure   | 257833.97 Kb | 0m6.259s  |
| Metatable | 164843.76 Kb | 0m6.495s  |
| Prototype | 164844.70 Kb | 0m16.715s |

The conclusion can be made that closure-based classes take
more memory. The methods and members' accessors aren't much faster,
as [mentioned in the article](https://www.lua-users.org/wiki/ObjectOrientationTutorial).

<details>
  <summary>Closure-based class test code</summary>
  <pre>local function Animal(age, kind, sound)
	local self = {
		age = age or 0,
		kind = kind or "unknown",
		sound = sound or "silence",
	}
	function self.makeSound()
		return self.sound
	end
	-- @private
	local function privateMethod()
		return "something private"
	end
	return self
end

local ITERS = 1000000
local cats = {}
for i = 1, ITERS do
	local cat = Animal(2, "feline", "Meow!")
	cats[i] = cat
	print(cat.age, cat.kind, cat:makeSound())
end

local res = collectgarbage("count")
print(res .. "kb")</pre>
</details>
<details>
  <summary>Metatables-based class test code</summary>
  <pre>local Animal = {}
Animal.__index = Animal

function Animal:new(age, kind, sound)
	self.age = age or 0
	self.kind = kind or "unknown",
	self.sound = sound or "silence",
	return setmetatable(t, self)
end

function Animal:makeSound()
	return self.sound
end

local ITERS = 1000000
local cats = {}
for i = 1, ITERS do
	local cat = Animal:new(2, "feline", "Meow!")
	cats[i] = cat
	print(cat.age, cat.kind, cat:makeSound())
end

local res = collectgarbage("count")
print(res .. "kb")</pre>
</details>
<details>
<summary>Prototype-based test code</summary>
<pre>---@param a any
---@param b any
---@return table
local function clone(a, b)
	if type(a) ~= "table" then
		return b or a
	end
	b = b or {}
	b.__index = a
	return setmetatable(b, b)
end

---@param a any
---@param b any
---@return boolean
local function isPrototypeOf(b, a)
	local bType = type(b)
	local aType = type(a)
	if bType ~= "table" and aType ~= "table" then
		return bType == aType
	end
	local index = b.__index
	local _isa = index == a
	while not _isa and index ~= nil do
		index = a.__index
		_isa = index == a
	end
	return _isa
end

local Animal = clone(table, {
	age = 0,
	kind = "unknown",
	sound = "silence",
	makeSound = function(self)
		return self.sound
	end,
	clone = clone,
	isPrototypeOf = isPrototypeOf,
})

local ITERS = 1000000
local cats = {}
for i = 1, ITERS do
	local cat = Animal:clone()
	cat.age = 4
	cat.kind = "feline"
	cat.sound = "Meow!"
	print(cat.age, cat.kind, cat:makeSound(), cat:isPrototypeOf(Animal))
	cats[i] = cat
	print(cat.age, cat.kind, cat:makeSound())
end

local res = collectgarbage("count")
print(res .. "kb")</pre>
</details>

### Metatable-based classes

#### Pros

- The lowest memory consumed;
- the fastest speed;
- possible to get methods directly from class `Class.method(instance, args))`.

#### Cons

- The code might be a bit more confusing than the closure approach.

### Closure-based classes

#### Pros
- More clear syntax (easier to write);
- a bit faster than metatable-based classes;
- can have truly private fields.

#### Cons

- More memory is required.

### Prototype-based

#### Pros

- Uses a different approach, but is technically very similar to meta tables.

#### Cons

- Probably the slowest solution;
- code can be confusing;
- extra code is required like `clone()` function.

Another comparison opinion can be read in
[lua-users.org article](https://www.lua-users.org/wiki/ObjectOrientationTutorial).

## Conclusion

In my opinion [metatable](#metametable-based-classes) method is the most optimal
in performance and maintainability. Of course, everything depends on the task.
Sometimes maintainability is more important than performance, especially
if you are working in a large team with different technical skills. What
approach to choose is up to you.

## Links

- [Object Orientation Tutorial](https://www.lua-users.org/wiki/ObjectOrientationTutorial)
- [Object Oriented Programming](https://www.lua-users.org/wiki/ObjectOrientedProgramming)
- [Article on GitHub](https://gist.github.com/liquidev/3f37f94efdacd14a654a4bdc37c8008f)
- [Programming in Lua Book Chapter 16: Object-Oriented Programming](https://www.lua.org/pil/16.html)
- [Lua Language Server](https://luals.github.io)
- [Object-Oriented Programming in Lua using Annotations](https://betterprogramming.pub/oop-in-lua-9962e47ed603)


*[LuaLS]: Lua Language Server
*[OOP]: Object-Oriented Programming
*[OO]: Object-Oriented
*[DX]: Developer Experience