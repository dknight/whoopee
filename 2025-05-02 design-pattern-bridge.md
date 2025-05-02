<!-- Description: The Bridge design pattern helps you separate a big or complex class into two parts. Check bridge implementation in the Lua language.-->

tags: lua design patterns

# Bridge

The Bridge design pattern helps you separate a big or complex class into two parts: one for the main idea or logic 
(called abstraction) and one for the detailed work or how things are done (called implementation). This way, you can 
change or improve each part without affecting the other. Abstraction and implementation can be changed independently of 
each other.

![Bridge Scheme](/assets/img/dp-bridge.svg)

Let’s imagine we have `Hero` and `HeroProficiency` classes (like mage, warrior, rogue, etc.), and we want to create
subclasses for each proficiency. Later we add `HeroRace` (human, elf, dwarf, etc.). After this, we can have the
following subclasses:

- `HeroWarriorHuman`
- `HeroWarriorElf`
- `HeroWarriorDwarf`
- `HeroMageHuman`
- `HeroMageElf`
- `HeroMageDwarf`
- `HeroRogueHuman`
- `HeroRogueElf`
- `HeroRogueDwarf`
- ...


If we want to add a new proficiency or race, our number of subclasses will increase exponentially. The bridge pattern
helps us to avoid this. Classes `HeroProficiency` and `HeroRace` will be abstract, and we will have subclasses for each
proficiency and race, and these do not know about implementation or each other; the `Hero` class is a bridge between
them.

## Hero class (very simplified)

```lua
---@class Hero
---@field name string
---@field race HeroRace
---@field proficiency HeroProficiency
local Hero = {}
Hero.__index = Hero

---@return Hero
function Hero:new(name, race, proficiency)
	local t = {
		name = name,
		race = race,
		proficiency = proficiency,
	}
	return setmetatable(t, self)
end

---@return string
function Hero:tostring()
	return string.format("Hero: %s, race: %s, proficiency: %s",
		self.name,
		self.race:get(),
		self.proficiency:get()
	)
end

return Hero
```

## HeroProficiency class

```lua
---@class HeroProficiency
---@field private proficiency string
local HeroProficiency = {}
HeroProficiency.__index = HeroProficiency

---@return HeroProficiency
function HeroProficiency:new(proficiency)
	local t = {
		proficiency = proficiency,
	}
	return setmetatable(t, self)
end

---@return string
function HeroProficiency:get()
	return self.proficiency
end

return HeroProficiency
```

## HeroRace class

```lua
---@class HeroRace
---@field private race string
local HeroRace = {}
HeroRace.__index = HeroRace

---@return HeroRace
function HeroRace:new(race)
	local t = {
		race = race,
	}
	return setmetatable(t, self)
end

---@return string
function HeroRace:get()
	return self.race
end

return HeroRace
```

## HeroWarrior class is extending HeroProficiency

```lua
local HeroProficiency = require("HeroProficiency")

---@class HeroWarrior
local HeroWarrior = {}

---@return HeroWarrior
function HeroWarrior:new()
	local t = {
		proficiency = "warrior",
	}
	setmetatable(t, { __index = HeroWarrior })
	setmetatable(self, { __index = HeroProficiency })
	return t
end

return HeroWarrior
```

## HeroHuman class is extending HeroRace

```lua
local HeroRace = require("HeroRace")

---@class HeroHuman
local HeroHuman = {}

---@return HeroHuman
function HeroHuman:new()
	local t = {
		race = "human",
	}
	setmetatable(t, { __index = HeroHuman })
	setmetatable(self, { __index = HeroRace })
	return t
end

return HeroHuman
```

## Usage of the Bridge pattern

```lua
local Hero = require("Hero")
local HeroHuman = require("HeroHuman")
local HeroWarrior = require("HeroWarrior")

local hero = Hero:new("Max", HeroHuman:new(), HeroWarrior:new())
print(hero:tostring())
```

The same logic is applied to other classes and proficiencies. This pattern might be overkill for small projects, but it
can be invaluable for a large number of classes, entities, and logic.