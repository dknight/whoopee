<!-- Description: The Template Method is a behavioral design pattern that outlines the overall structure of an algorithm in a superclass while allowing subclasses to modify certain steps without altering the algorithm's core structure. -->

tags: lua design-patterns

# Template Method

The Template Method is a behavioral design pattern that outlines the overall structure of an algorithm in a superclass 
while allowing subclasses to modify certain steps without altering the algorithm's core structure.

![Template Method Scheme](/assets/img/dp-template-method.svg)

The template method is one of the simplest structural design patterns. Most probably you have already used it, without 
even knowing it.

## HeroCreator class

This is the template for all classes. Methods `setRace` and `setProficiency` are abstract and will be implemented in 
subclasses.

```lua
---@class HeroCreator
local HeroCreator = {}
HeroCreator.__index = HeroCreator

---@return HeroCreator
function HeroCreator:create()
	self:setRace()
	self:setProficiency()
	return setmetatable(self, { __index = self })
end

return HeroCreator
```

## HumanWarrior and ElfMage classes

These classes are subclasses of `HeroCreator` which is the template for them.

```lua
---@class HumanWarrior
local HumanWarrior = {
	create = HeroCreator.create,
}

---@return HumanWarrior
function HumanWarrior:new()
	local t = {}
	setmetatable(t, { __index = HumanWarrior })
	setmetatable(self, { __index = HeroCreator })
	return t
end

function HumanWarrior:setRace()
	self.race = "human"
end

function HumanWarrior:setProficiency()
	self.proficiency = "warrior"
end

return HumanWarrior
```

```lua
---@class ElfMage
local ElfMage = {
	create = HeroCreator.create,
}

---@return ElfMage
function ElfMage:new()
	local t = {}
	setmetatable(t, { __index = HumanWarrior })
	setmetatable(self, { __index = HeroCreator })
	return t
end

function ElfMage:setRace()
	self.race = "elf"
end

function ElfMage:setProficiency()
	self.proficiency = "mage"
end

return ElfMage
```

## Template Method usage

```lua
local HumanWarrior = require("HumanWarrior")
local ElfMage = require("ElfMage")

local humanWarrior = HumanWarrior:create()
local elfMage = ElfMage:create()
print(humanWarrior.race, humanWarrior.proficiency) -- human	warrior
print(elfMage.race, elfMage.proficiency)           -- elf	mage
```