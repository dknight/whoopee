<!-- Description: Learn how to use design pattern Builder in Lua applications. Builder is the design pattern to build objects with complex state. -->

tags: lua design-patterns

# Builder

Builder is a creational design pattern to build objects with complex state step-by-step.
This article only covers a builder pattern without a director and abstract builder. To learn
how to use builders without the director, check out [the article on refactoring.guru](https://refactoring.guru/design-patterns/builder).

!!! tip
	Use builder pattern when the state of the object is complex and it is hard to put everything
	in the constructor.

Let's imagine we have a `Player` class with lots of properties. We want to be able to create
a player with different properties, and those properties depend on external factors and might change
due to different circumstances. In this case, class constructor is not a good option, because
it would be too complex and hard to maintain.

![Builder Scheme](/assets/img/dp-builder.svg)

Consider:

```lua
---@class Player
local Player = {}
Player.__index = Player

---@return Player
function Player:new(name, hp, damage, armor, mana, inventory, xp)
	local t = {
		name = name,
		hp = hp,
		damage = damage,
		armor = armor,
		mana = mana,
		inventory = inventory,
		xp = xp,
		-- more props
	}
	return setmetatable(t, self)
end

return Player
```

In the case above, the constructor already has too many arguments. We can use a builder pattern to
simplify the constructor:

```lua
---@class Player
local Player = {}
Player.__index = Player

---@return Player
function Player:new()
	local t = {}
	return setmetatable(t, self)
end


---@class PlayerBuilder
---@field player Player
local PlayerBuilder = {}
PlayerBuilder.__index = PlayerBuilder

---@return PlayerBuilder
function PlayerBuilder:new()
	local t = {
		player = Player:new()
	}
	return setmetatable(t, self)
end

---@param name string
---@return PlayerBuilder
function PlayerBuilder:setName(name)
	self.player.name = name
	return self
end

---@param hp string
---@return PlayerBuilder
function PlayerBuilder:setHitPoints(hp)
	self.player.hp = hp
	return self
end

---@param damage string
---@return PlayerBuilder
function PlayerBuilder:setDamage(damage)
	self.player.damage = damage
	return self
end

---@param item string
---@return PlayerBuilder
function PlayerBuilder:addItem(item)
	table.insert(self.player.inventory, item)
	return self
end

--- etc. for the rest of the properties

---@return Player
function PlayerBuilder:build()
	return self.player
end
```

### PlayerBuilder usage

Also notice that the builder's method returns the builder itself, so we can chain calls.

```lua
local PlayerBuilder = require("PlayerBuilder")

local builder = PlayerBuilder:new()
local player = builder:setDamage(10):setHitPoints(120):setName("Max"):build()

print(player.name, player.damage, player.hp)
--[[
Max     10      120
--]]
```

## StringBuilder

Another example of a builder pattern is the `StringBuilder` class, which uses
[sting buffers](/post/string-buffers-in-lua.html) to build strings very fast.
A similar mechanism is used in the Java language for [StringBuilder class](https://docs.oracle.com/javase/8/docs/api/java/lang/StringBuilder.html?from_column=20423&from=20423), or Go's [strings.Builder](https://pkg.go.dev/strings#Builder), and other languages.

```lua
---@class StringBuilder
---@field private parts table
local StringBuilder = {}
StringBuilder.__index = StringBuilder

---@return StringBuilder
function StringBuilder:new()
	local t = {}
	t.parts = {}
	return setmetatable(t, self)
end

---@param s string
---@return StringBuilder
function StringBuilder:add(s)
	table.insert(self.parts, s)
	return self
end

---@return string
function StringBuilder:build()
	return table.concat(self.parts)
end

return StringBuilder
```

### StringBuilder usage

```lua
local StringBuilder = require("StringBuilder")
local builder = StringBuilder:new()
builder:add("Hello"):add(" "):add("world")
builder:add("!!!")
local str = builder:build()
print(str) --> Hello world!!!
```