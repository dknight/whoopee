<!-- Description: Implementation of the Abstract Factory design pattern in Lua. Creational pattern Abstract Factory enables the creation of families of related objects without specifying their exact classes. In other words, abstract factory can produce other factories. -->

tags: lua design-patterns

# Abstract Factory

Creational pattern Abstract Factory enables the creation of families of related objects without
specifying their exact classes. In other words, abstract factory is a pattern which creates and 
groups other factories, which logically are related to each other.

## When is abstract factory appropriate?

Then, there is a family of common products; in our case, these are the [monsters from factory method](/post/design-pattern-factory-method.html): goblin, skeleton, and demon. All these monsters have the same 
properties: name, hit points (hp), damage, and special power. What if we want to add another class of
character in our RGP like NPC. Let's imagine that we already have some complex logic which produces our
monsters. I think you have no too much will to inject another logic inside the monster production/generation.
This is where Abstract Factory comes to help. Abstract Factory is a kind of super-wrapper over other factories.
Here one thing should be considered that sub-factories should have the same interface to produce products (monsters),
in our case it is only `Factory:create()` method. So the interface has only one method.

```lua
---@alias FactoryIntrerface { create: fun(type: string): Monster }
```

![Abstract Factory Scheme](/assets/img/dp-abstract-factory.svg)

!!! tip
	Use design patterns to solve real-world problems, do not adapt your code to the problem.
	Think firstly, maybe abstract factory is not the best solution for your problem and makes
	extra overhead?

## Implementation

### MonsterFactory.lua

```lua
---@class Monster
---@field public name string
---@field public damage number
---@field public hp number
---@field public special string
local Monster = {}
Monster.__index = Monster

---@return Monster
function Monster:new(name, damage, hp, special)
	local t = {
		name = name,
		damage = damage,
		hp = hp,
		special = special
	}
	return setmetatable(t, self)
end

---@class Goblin: Monster
local Goblin = {}
---@return Goblin
function Goblin:new()
	return Monster:new("Goblin", 2, 10, "None") --[[@as Goblin]]
end

---@class Skeleton: Monster
local Skeleton = {}
---@return Skeleton
function Skeleton:new()
	return Monster:new("Skeleton", 4, 12, "Reform") --[[@as Skeleton]]
end

---@class Demon: Monster
local Demon = {}
---@return Demon
function Demon:new()
	return Monster:new("Demon", 10, 50, "Fire hit") --[[@as Demon]]
end

---@class MonsterFactory
local MonsterFactory = {}

---@return MonsterFactory
function MonsterFactory:create(type)
	if type == "Goblin" then
		return Goblin:new()
	elseif type == "Skeleton" then
		return Skeleton:new()
	elseif type == "Demon" then
		return Demon:new()
	else
		error("unknown monster")
	end
end

return MonsterFactory
```

### NPCFactory.lua

```lua
---@class NPC
---@field public name string
---@field public say string
---@field public hp number
---@field public special string
local NPC = {}
NPC.__index = NPC

---@return NPC
function NPC:new(name, say, hp, special)
	local t = {
		name = name,
		say = say,
		hp = hp,
		special = special,
	}
	return setmetatable(t, self)
end

---@class Healer: NPC
local Healer = {}
---@return Healer
function Healer:new()
	return NPC:new("Healer", "Hello", 100, "Heals") --[[@as Healer]]
end

---@class Blacksmith: NPC
local Blacksmith = {}
---@return Blacksmith
function Blacksmith:new()
	return NPC:new("Blacksmith", "Welcome", 100, "Repairs") --[[@as Blacksmith]]
end

---@class NPCFactory
local NPCFactory = {}

---@return NPCFactory
function NPCFactory:create(type)
	if type == "Healer" then
		return Healer:new()
	elseif type == "Blacksmith" then
		return Blacksmith:new()
	else
		error("unknown npc")
	end
end

return NPCFactory
```

### AbstractFactory.lua

```lua
local MonsterFactory = require("MonsterFactory")
local NPCFactory = require("NPCFactory")

---@class AbstractFactory
local AbstractFactory = {}
AbstractFactory.__index = AbstractFactory

---@return AbstractFactory
function AbstractFactory:new(type)
	if type == "NPC" then
		return NPCFactory
	elseif type == "Monster" then
		return MonsterFactory
	else
		error("unknown factory type")
	end
end

return AbstractFactory
```

### Usage of Abstract Factory

```lua
local AbstractFactory = require("AbstractFactory")

local monsterFactory = AbstractFactory:new("Monster")
local npcFactory = AbstractFactory:new("NPC")

local goblin = monsterFactory:create("Goblin")
print(goblin.name, goblin.damage, goblin.hp, goblin.special)
local demon = monsterFactory:create("Demon")
print(demon.name, demon.damage, demon.hp, demon.special)

local healer = npcFactory:create("Healer")
print(healer.name, healer.speak, healer.hp, healer.special)
--[[
Goblin  2       10      None                                                    
Demon   10      50      Fire hit                                                
Healer  nil     100     Heals       
--]]
```

*[RPG]: Role-Playing Game
*[NPC]: Non-Playable Character 