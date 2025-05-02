<!-- Description: Flyweight implementation in Lua. The Flyweight pattern is a structural design pattern that helps conserve memory by sharing common parts of an object's state across multiple instances, rather than storing all data separately in each object. -->

tags: lua design-patterns

# Flyweight

The Flyweight pattern is a structural design pattern that helps conserve memory by sharing common parts of an object's
state across multiple instances, rather than storing all data separately in each object. Flyweight is easier to create
and work with than the [factory](/post/design-pattern-factory-method.html) design pattern. Factory can produce flyweight
with all internal state values. The advantage of the factory is that it can be realized as a
[singleton](/post/design-pattern-singleton.html) to avoid extra memory allocation.

Flyweight has one important requirement: it must be immutable; this means that it can't be changed after creation
(contain neither public fields nor setters).

![Flyweight Scheme](/assets/img/dp-flyweight.svg)

## Monster class

Here is a simple monster class with some fields: `name`, `damage`, `HP` and `special`. Nothing special here just a 
common class.

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

return Monster
```

## MonsterFactory class

Factory of the monsters is also pretty straightforward. It has a table of monsters and a method to create a new monster.
If the monster with `name` already exists, it will return it. Otherwise, it will create a new monster and store it in
the table. It works like a [singleton](/post/design-pattern-singleton.html). Maybe this example is not the best, but
it's enough to show the idea of how to save memory.

```lua
---@class MonsterFactory
---@field private monsters Monster[]
local MonsterFactory = {}
MonsterFactory.__index = MonsterFactory

---@return MonsterFactory
function MonsterFactory:new()
	local t = {
		monsters = {},
	}
	return setmetatable(t, self)
end

---@return Monster
function MonsterFactory:create(name, damage, hp, special)
	local monster = self.monsters[name]
	if monster then
		return monster
	end
	self.monsters[name] = Monster:new(name, damage, hp, special)
	return self.monsters[name]
end

return MonsterFactory
```

## Usage of Flyweight

Notice that variables `goblin01` and `goblin02` are references to the same object in memory.

```lua
local MonsterFactory = require("MonsterFactory")

local factory = MonsterFactory:new()
local goblin01 = factory:create("Goblin", 10, 100, "None")
local goblin02 = factory:create("Goblin", 10, 100, "None")
local skelly = factory:create("Skeleton", 12, 120, "Reform")
print(goblin01, goblin02, skelly)
--[[
table: 0x561795c73af0   table: 0x561795c73af0   table: 0x561795c74090 
--]]
```

*[HP]: Hit Points