<!-- Description: The Strategy pattern is a behavioral design pattern that enables you to define a group of algorithms, encapsulate each one in its own class or function, and allow them to be used interchangeably. -->

tags: lua design-pattern

# Strategy

The Strategy pattern is a behavioral design pattern that enables you to define a group of algorithms, encapsulate each
one in its own class or function, and allow them to be used interchangeably.

![Strategy Scheme](/assets/img/dp-strategy.svg)

Let's describe a hypothetical example in the RPG game. Where reward for a quest will depend on the reputation of a
player. Players with a low reputation will get a reward of 50%, players with mid-reputation will get a reward of 100%,
and players with a high reputation will get a reward of 150%.

## Player class

```lua
---@class Player
---@field public reputation number
local Player = {}
Player.__index = Player

---@param reputation number
---@return Player
function Player:new(reputation)
	local t = {
		reputation = reputation or 1
	}
	return setmetatable(t, self)
end

return Player
```

## QuestReward class and its strategies

The strategies are defined in the `QuestReward` class only for simplicity reasons. This can be created as separate
classes or functions.

```lua
---@class QuestReward
---@field public player Player
local QuestReward = {
	lowReputationStrategy = function(reputation)
		return reputation * 0.5
	end,
	midReputationStrategy = function(reputation)
		return reputation * 1
	end,
	hightReputationStrategy = function(reputation)
		return reputation * 1.5
	end,
}
QuestReward.__index = QuestReward

---@param player Player
---@param gold number
---@return QuestReward
function QuestReward:new(player, gold)
	if player.reputation < 5 then
		return self.lowReputationStrategy(gold)
	elseif player.reputation < 10 then
		return self.midReputationStrategy(gold)
	else
		return self.hightReputationStrategy(gold)
	end
end

return QuestReward
```

## Usage

```lua
local Player = require("Player")
local QuestReward = require("QuestReward")

local player01 = Player:new(15)
print(QuestReward:new(player01, 100)) -- 150
local player02 = Player:new(7)
print(QuestReward:new(player02, 100)) -- 100
local player03 = Player:new(1)
print(QuestReward:new(player03, 100)) -- 50
```