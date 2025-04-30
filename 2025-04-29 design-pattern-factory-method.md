<!-- Description: Factory method design pattern implementation in Lua. The factory method is a creational design pattern that defines an interface for creating objects in a super-class, while enabling subclasses to specify the exact type of objects that should be instantiated. -->

tags: lua design-patterns

# Factory Method

The Factory Method is a creational design pattern that defines an interface for creating objects in a super-class, while enabling subclasses to specify the exact type of objects that should be instantiated.
In other words, it is a way to create objects without specifying the exact class to instantiate, but
create an object of a specific class.

For the demo, let's create a monster factory which will create a monster of a specific type
for the abstract RPG game.

![Factory Method Schema](/assets/img/dp-factory-method.svg)

## Monster class

First, let's define our monster classes. There is abstract monster class and its subclasses: Goblin,
Skeleton and Demon.

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
```

## MonsterFactory class

Monster factory produces the monsters, depending on the type. In this pattern, you should not care about
constructors of the monster, but just to create a monster by type. This method is invaluable when there are
not too many monsters yet. But more `if-elseif` statements will be added for more types of
monster you have. Here comes in handy another design pattern: [Abstract factory](/post/design-pattern-abstract-factory.html).

```lua
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
```

## Usage of MonsterFactory

```lua
local goblin = MonsterFactory:create("Goblin")
print(goblin.name, goblin.damage, goblin.hp, goblin.special)
local skelly = MonsterFactory:create("Skeleton")
print(skelly.name, skelly.damage, skelly.hp, skelly.special)
local demon = MonsterFactory:create("Demon")
print(demon.name, demon.damage, demon.hp, demon.special)

--[[
Goblin  2       10      None                                                    
Skeleton        4       12      Reform                                          
Demon   10      50      Fire hit        
--]]
```

*[RPG]: Role-Playing Game