<!-- Description: The Observer pattern is a behavioral design pattern that provides a way for one object to notify one or many other objects when something changes, using a simple subscription system. -->

tags: lua design-patterns

# Observer

The Observer pattern is a behavioral design pattern that provides a way for one object to notify one or
many other objects when something changes, using a simple subscription system.

![Observer Scheme](/assets/img/dp-observer.svg)

The Observer pattern is useful when you need one or more objects (observers) to automatically respond to changes in
another object (the subject). This is especially helpful when you want to monitor specific properties of an object and 
react whenever those properties change. For example, if an object’s value is updated, all subscribed observers are 
immediately notified and can take appropriate action, such as updating the user interface or triggering another process. 
This pattern helps decouple the subject from its observers, making the code more flexible and easier to maintain.

Let's imagine that we have a group of players playing on a server. We want to notify everybody with a server message.
All players are subscribed to [`ServerNotifier`](#servernotifier-class), which can notify all players with kinds of 
messages.

## Player class

The class is very basic for simplicity. Notice the `inform` method, which implements the notification for the players.

```lua
---@class Player
---@field public name string
local Player = {}
Player.__index = Player

---@return Player
function Player:new(name)
	local t = {
		name = name,
	}
	return setmetatable(t, self)
end

---@param message string
function Player:inform(message)
	print("Player " .. self.name .. " recieved: " .. message)
end

return Player
```

## ServerNotifier class

Notifier can register and unregister players to be notified.

```lua
---@class ServerNotifier
---@field players Player[]
local ServerNotifier = {}
ServerNotifier.__index = ServerNotifier

---@return ServerNotifier
function ServerNotifier:new()
	local t = {
		players = {},
	}
	return setmetatable(t, self)
end

---@param player Player
function ServerNotifier:register(player)
	table.insert(self.players, player)
end

---@param player Player
function ServerNotifier:unregister(player)
	for i, p in ipairs(self.players) do
		if p == player then
			table.remove(self.players, i)
			break
		end
	end
end

---@param message string
function ServerNotifier:notifyAll(message)
	for _, p in ipairs(self.players) do
		p:inform(message)
	end
end

return ServerNotifier
```

## Usage

```lua
local Player = require("Player")
local ServerNotifier = require("ServerNotifier")

local notifier = ServerNotifier:new()
local warrior = Player:new("Warrior")
local mage = Player:new("Mage")
local rogue = Player:new("Rogue")
notifier:register(warrior)
notifier:register(rogue)
notifier:register(mage)
notifier:notifyAll("The server will go down for maintenance in 20 minutes.")
--[[
Player Warrior recieved: The server will go down for maintenance in 20 minutes. 
Player Rogue recieved: The server will go down for maintenance in 20 minutes.
Player Mage recieved: The server will go down for maintenance in 20 minutes.  
--]]
```