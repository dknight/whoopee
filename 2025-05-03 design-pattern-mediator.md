<!-- Description: The Mediator design pattern helps different parts of a program work together without being directly connected to each other. Instead of objects talking to each other directly, they send messages through a special object called a mediator. This makes the program easier to manage and change. -->

tags: lua design-patterns

# Mediator

The Mediator design pattern helps different parts of a program work together without being directly connected to each
other. Instead of objects talking to each other directly, they send messages through a special object called a mediator. 
This makes the program easier to manage and change.

![Mediator Scheme](/assets/img/dp-mediator.svg)

Let's imagine we have heroes represented programmatically with the [`Hero`](#hero-class) class. We want to develop a 
multiplayer mode and create the party. We do not want to embed the logic of the party into a `Hero` class. We can
create a mediator, [`PartyCreator`](#partycreator-class), which handles the logic of adding to the party. In this case
`Hero` class won't know anything about the party. This provides encapsulation logic of the hero and party, and both
can be reused.

## Hero class

```lua
---@class Hero
---@field private name string
---@field private hp number
---@field private damage number
---@field private partyMediator PartyCreator
local Hero = {}
Hero.__index = Hero

---@return Hero
function Hero:new(name, hp, damage, partyMediator)
	local t = {
		name = name,
		hp = hp,
		damage = damage,
		party = partyMediator,
	}
	return setmetatable(t, self)
end

function Hero:addToParty()
	self.party:addHero(self)
end

function Hero:removeFromParty()
	self.party:removeHero(self)
end

return Hero
```

## PartyCreator class

The class encapsulates the logic of the party, this can be extended by creating a separate `Party` class to encapsulate
party logic. But it is skipped here to keep the demonstration simpler.

```lua
---@class PartyCreator
---@field public name string
---@field private heroes Hero[]
local PartyCreator = {}
PartyCreator.__index = PartyCreator

---@return PartyCreator
function PartyCreator:new(name)
	local t = {
		name = name,
		heroes = {},
	}
	return setmetatable(t, self)
end

---@param hero Hero
function PartyCreator:addHero(hero)
	table.insert(self.heroes, hero)
	print(hero.name .. " has beed added to party " .. self.name .. ".")
end

---@param hero Hero
function PartyCreator:removeHero(hero)
	print(hero.name .. " has beed from party " .. self.name .. ".")
	for i, h in ipairs(self.heroes) do
		if h.name == hero.name then
			table.remove(self.heroes, i)
			break
		end
	end
end

function PartyCreator:printHeroes()
	for i, hero in ipairs(self.heroes) do
		print(i .. ". " .. hero.name)
	end
end

return PartyCreator
```

### Usage of Mediator

```lua
local Hero = require("Hero")
local PartyCreator = require("PartyCreator")

local party = PartyCreator:new("Master of Magic")
local tank = Hero:new("Bill", 100, 5, party)
local healer = Hero:new("Aldorn", 70, 1, party)
local archer = Hero:new("Robin", 40, 15, party)
local mage = Hero:new("Merlin", 20, 20, party)

tank:addToParty()
healer:addToParty()
archer:addToParty()
mage:addToParty()
party:printHeroes()
archer:removeFromParty()
party:printHeroes()
--[[
Bill has beed added to party Master of Magic.
Aldorn has beed added to party Master of Magic.
Robin has beed added to party Master of Magic.
Merlin has beed added to party Master of Magic.
1. Bill
2. Aldorn
3. Robin
4. Merlin
Robin has beed from party Master of Magic.                                      
1. Bill
2. Aldorn
3. Merlin
--]]
```