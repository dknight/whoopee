<!-- Description: The State pattern is a behavioral design pattern that allows an object to change its behavior based on its internal state. It can make the object behave as if it belongs to a different class, depending on the current state. -->

tags: lua design-patterns

# State

The State pattern is a behavioral design pattern that allows an object to change its behavior based on its internal state. It can make the object behave as if it belongs to a different class, depending on the current state.

![State Scheme](/assets/img/dp-state.svg)

Again, let’s look at the RPG topic; a warrior hero has several tiers: squire, soldier, knight, and paladin. The tier
will represent the State pattern; a hero can progress from one tier to another, so changing its state.

## Warrior class

```lua
---@class Warrior
---@field public name string
---@field public tier Tier
local Warrior = {}
Warrior.__index = Warrior

---@return Warrior
function Warrior:new(name)
	local t = {
		name = name,
		tier = Squire:new(),
	}
	return setmetatable(t, self)
end

function Warrior:printTier()
	print("Tier: " .. self.tier.name)
end

function Warrior:nextTier()
	self.tier = self.tier:next()
end

function Warrior:castHealing()
	if self.tier.name == "paladin" then
		print("casting healing spell")
	else
		print("only paladin can heal")
	end
end

return Warrior
```

## Tier class and its states (subclasses) Squire, Solder, Knight, Paladin

Here is an interesting moment that we can change behavior, which depends on the state of the object. Consider only
paladin tier (state) can cast a healing spell; in all other cases, we just print a message `"only paladins can heal"`.

```lua
---@class Tier
---@field public name string
---@field public nextTier Tier
local Tier = {}
Tier.__index = Tier

---@param name string
---@param nextTier Tier
---@return Tier
function Tier:new(name, nextTier)
	local t = {
		name = name,
		nextTier = nextTier,
	}
	return setmetatable(t, self)
end

---@return Tier
function Tier:next()
	return self.nextTier:new()
end

---@class Paladin
local Paladin = {}

---@return Paladin
function Paladin:new()
	local t = {
		name = "paladin",
		nextTier = Paladin
	}
	setmetatable(t, { __index = Paladin })
	setmetatable(self, { __index = Tier })
	return t
end

---@class Knight
local Knight = {}

---@return Knight
function Knight:new()
	local t = {
		name = "knight",
		nextTier = Paladin,
	}
	setmetatable(t, { __index = Knight })
	setmetatable(self, { __index = Tier })
	return t
end

---@class Soldier
local Soldier = {}

---@return Soldier
function Soldier:new()
	local t = {
		name = "soldier",
		nextTier = Knight,
	}
	setmetatable(t, { __index = Soldier })
	setmetatable(self, { __index = Tier })
	return t
end

---@class Squire
local Squire = {}

---@return Squire
function Squire:new()
	local t = {
		name = "squire",
		nextTier = Soldier,
	}
	setmetatable(t, { __index = Squire })
	setmetatable(self, { __index = Tier })
	return t
end
```

## Usage

```lua
local warrior = Warrior:new("Max")
warrior:printTier()
warrior:nextTier()
warrior:castHealing()
warrior:printTier()
warrior:nextTier()
warrior:printTier()
warrior:nextTier()
warrior:printTier()
warrior:castHealing()
--[[
Tier: squire
only paladin can heal
Tier: soldier
Tier: knight
Tier: paladin
casting healing spell
--]]
```