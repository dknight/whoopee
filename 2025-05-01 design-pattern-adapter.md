<!-- Description: The Adapter is a structural design pattern that enables collaboration between objects with incompatible interfaces. Here's how you can implement an Adapter in Lua. -->

tags: lua design-patterns

# Adapter

The Adapter is a structural design pattern that enables collaboration between objects with incompatible interfaces.
Consider we have a game where we save the state in Lua format, but after publishing the game to a kind of platform or 
gaming service. This service supports only JSON format. So our XML format is not compatible with JSON. Here adapter
is the best solution.

![Adapter Scheme](/assets/img/dp-adapter.svg)

## Game class

This is a mostly hard-coded demonstration of the class. Implementation of full XML support is out of scope, and not
important for this example.

```lua
---@class Game
local Game = {}
Game.__index = Game

---@param state table
---@return Game
function Game:new(state)
	local t = {
		state = state,
	}
	return setmetatable(t, self)
end

---@return string
function Game:save()
	local t = {}
	t[#t + 1] = "<savegame>"
	t[#t + 1] = "\t<date>" .. os.date() .. "</date>"
	t[#t + 1] = "\t<level>" .. self.state.level .. "</level>"
	t[#t + 1] = "\t<score>" .. self.state.score .. "</score>"
	t[#t + 1] = "</savegame>"
	return table.concat(t, "\n")
end

return Game
```

## Adapter class

This is the adapter class, which adapts the XML format to JSON. In this case adapter can be a function. I use here
class for demonstration and constituency.

```lua
---@class SaveGameAdapter
local SaveGameAdapter = {}
SaveGameAdapter.__index = SaveGameAdapter

---@param game Game
---@return SaveGameAdapter
function SaveGameAdapter:new(game)
	local t = {
		game = game,
	}
	return setmetatable(t, self)
end

---@return string
function SaveGameAdapter:save()
	local t = {}
	t[#t + 1] = "{"
	t[#t + 1] = string.format('\t"date": "%s",', os.date())
	t[#t + 1] = string.format('\t"level": %d,', self.game.state.level)
	t[#t + 1] = string.format('\t"score": %d', self.game.state.score)
	t[#t + 1] = "}"
	return table.concat(t, "\n")
end

return SaveGameAdapter
```

## Adapter class usage

```lua
local gameState = {
	level = 2,
	score = 32100,
}

local game = Game:new(gameState)
print(game:save())
--[[
<savegame>
        <date>Thu May  1 20:01:24 2025</date>
        <level>2</level>
        <score>32100</score>
</savegame>
--]]

local adapter = SaveGameAdapter:new(game)
print(adapter:save())
--[[
{                                                                               
        "date": "Thu May  1 20:01:24 2025",
        "level": 2,
        "score": 32100
}
--]]
```

*[XML]: Extensible Markup Language
*[JSON]: JavaScript Object Notation