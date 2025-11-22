<!-- Description: Object-oriented tutorial for the Lua language using a prototype-based approach. -->

tags: lua

# Prototype-Based OOP in Lua

In a previous [post](/post/object-oriented-programming-in-lua.html) I described Object-Oriented Programming in Lua using a class-like, Java-style pattern.
However, Lua’s metatable system makes it straightforward to implement a more natural and lightweight prototype-based model—closer to JavaScript or Self.

Consider the following:

```lua
local Animal = { kind = "Unknown", name = "", age = 0 }

function Animal:greet()
	print(
		"Hello, I'm " .. self.name .. " the " .. self.kind
		.. " " .. self.age .. " year(s) old."
	)
end

-- Create a new object using Animal as prototype
function Animal:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- Usage
local animal = Animal:new({ kind = "Cat", name = "Jess", age = 25 })
animal:greet()

-- OUTPUT:
-- "Hello, I'm Jess the Cat 3 year(3) old.
```


## Inheritance (Prototype Chain)

```lua
-- Child prototype
local Cat = Animal:new()

function Cat:greet()
	print("Meowww, I am " .. self.name)
end

-- Usage
local bars = Cat:new({ name = "Bars", age = 9 })
bars:greet()

-- OUTPUT:
-- Meowww, I am Bars
```

## Calling Parent Methods (super)

You can call the parent method manually:

```lua
function Cat:greet()
	-- call parent method
	Animal.greet(self)
	print("And I am also a cat.")
end

local annaCat = Cat:new({ name = "Anna", kind = "Cat", age = 4 })
annaCat:greet()

-- OUTPUT:
-- Hello, I'm Anna the Cat 4 year(s) old.
-- And I am also a cat.
```

## Static Members

There is no clean way in Lua to create static field, but it
can be easily emulated.

```lua
local Animal = {
	kind = "Unknown",
	name = "",
	age = 0,
	TotalAnimals = 0, -- static field
}

-- Create a new object using Animal as prototype
function Animal:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	Animal.TotalAnimals = Animal.TotalAnimals + 1
	return o
end

for i = 1, 10 do
	Animal:new({kind = "Mammal", name = "None", age = i})
end
print(Animal.TotalAnimals)

-- OUTPUT: 10
```

## Private fields and methods

There are also no strictly private members in Lua; usually, private things that should not be accessed are prefixed with `_` (underscore).

```lua
local Animal = {
	-- ...
	_privateField = "something",
}

local a = Animal:new()
a._privateField -- bad practice, cannot access private fields
```

Prototype-based OOP is much simpler and much cleaner than imitation of Java-like classes.