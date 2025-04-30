<!-- Description: Learn about the Prototype design pattern in the Lua programming language, including how to create and modify object clones without altering the original. -->

tags: lua design-patterns

# Prototype

The Prototype pattern is a creational design pattern that enables the creation of object copies without requiring
knowledge of their underlying implementation. These clones can be independently modified, allowing changes without
affecting the original prototype object.

![Prototype Scheme](/assets/img/dp-prototype.svg)

## MonsterPrototype class

```lua
---@class MonsterPrototype
---@field name string
---@field damage number
---@field hp number
local MonsterPrototype = {}
MonsterPrototype.__index = MonsterPrototype

---@return MonsterPrototype
function MonsterPrototype:new(name, damage, hp)
	local t = {
		name = name,
		damage = damage,
		hp = hp,
	}
	return setmetatable(t, self)
end

---Clones the prototype
---@return MonsterPrototype
function MonsterPrototype:clone()
	return MonsterPrototype:new(self.name, self.damage, self.hp)
end

return MonsterPrototype
```

### MonsterPrototype usage

```lua
local monsterProto = MonsterPrototype:new("monter", 1, 1)
print(monsterProto.name, monsterProto.damage, monsterProto.hp) --> monster	1	1

local goblin = monsterProto:clone()
goblin.name = "goblin"
goblin.damage = 2
goblin.hp = 10
print(goblin.name, goblin.damage, goblin.hp) --> goblin  2       10

local troglodyte = monsterProto:clone()
troglodyte.name = "troglodyte"
troglodyte.damage = 4
troglodyte.hp = 14
print(troglodyte.name, troglodyte.damage, troglodyte.hp) --> troglodyte      4       14

local hobogoblin = monsterProto:clone()
hobogoblin.name = "hobogoblin"
hobogoblin.damage = 5
hobogoblin.hp = 15
print(hobogoblin.name, hobogoblin.damage, hobogoblin.hp) --> hobogoblin      5       15
```

As you can see, the prototype pattern is very similar to [factory method](/post/design-pattern-factory-method.html).
