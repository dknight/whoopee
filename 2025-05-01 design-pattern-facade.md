<!-- Description: The Facade pattern is a structural design pattern that provides a simplified interface to a complex system like a library, framework, or a group of related methods or classes.-->

tags: lua design-patterns

# Facade

The Facade pattern is a structural design pattern that provides a simplified interface to a complex system, such as a library, framework, or a group of related methods or classes.

Let’s imagine we have a class with many methods related to complex logic. For example, consider an `Inventory `class that
manages the backpack of our hero. It allows us to add items, remove items, check if the backpack is full, and so on. To
pick up an item, we need to perform the following steps:

1. Check if the backpack is not full;
2. Add the item to the backpack;
3. Write a log message.

We might call these methods in the order listed above. It's likely that this same sequence of operations will be needed
in multiple places in our game. If the logic for picking up items changes, we would have to update it in several places.
This increases the risk of forgetting to make a necessary change somewhere.

To avoid this, it’s a good idea to create an additional abstraction, called a Facade, over the Inventory class. This
facade would group all methods related to picking up an item.

You might ask, "Why do we need another abstraction? Why not just implement the logic for picking up items directly in
the `Inventory` class?" That’s a valid point of view. However, the facade becomes more valuable when the logic is more
complex. Ultimately, it’s up to the developer to decide whether to use a design pattern in a given situation or not to 
use it.

## Inventory class

```lua
---@class Inventory
---@field public items table
local Inventory = {}
Inventory.__index = Inventory

---@return Inventory
function Inventory:new()
	local t = {
		items = {}
	}
	return setmetatable(t, self)
end

---@return boolean
function Inventory:isEmpty()
	return #self.items == 0
end

---@return boolean
function Inventory:isFull()
	return #self.items == 20
end

---@param item string
function Inventory:put(item)
	table.insert(self.items, item)
end

function Inventory:log(item)
	print("Item " .. item .. " has been added to invetory")
end

---@param item string
function Inventory:remove(item)
	local index = 0
	for i, v in pairs(self.items) do
		if v == item then
			index = i
			break
		end
	end
	table.remove(self.items, index)
end

return Inventory
```

## InventoryFacade class

In `pickUpItem` we group all logic related to picking up item, checking the fullness of the backpack, adding the item
to the backpack, and logging the message.

```lua
---@class InventoryFacade
---@field private inventory Inventory
local InventoryFacade = {}
InventoryFacade.__index = InventoryFacade

---@return InventoryFacade
---@param inventory Inventory
function InventoryFacade:new(inventory)
	local t = {
		inventory = inventory,
	}
	return setmetatable(t, self)
end

---Pickup up the item
---@param item string
function InventoryFacade:pickUpItem(item)
	if self.inventory:isFull() then
		print("inventory is full")
		return
	end

	self.inventory:put(item)
	self.inventory:log(item)
end

return InventoryFacade
```

## InventoryFacade usage

A short demonstration of the usage of the facade.

```lua
local Inventory = require("Inventory")
local inventoryFacade = require("inventoryFacade")

local inventory = Inventory:new()
local inventoryFacade = InventoryFacade:new(inventory)

inventoryFacade:pickUpItem("bow")
inventoryFacade:pickUpItem("19 arrows")

print(inventory.items[1], inventory.items[2])
--[[
Item bow has been added to invetory                                             
Item 19 arrows has been added to invetory                                       
bow     19 arrows     
--]]
```