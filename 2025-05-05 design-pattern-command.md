<!-- Description: The Command pattern is a behavioral design pattern that turns a request into a separate object, allowing you to store, pass around, and manage requests more easily. -->

tags: lua design-patterns

# Command

The Command pattern is a behavioral design pattern that turns a request into a separate object, allowing you to store,
pass around, and manage requests more easily.

![Command Scheme](/assets/img/dp-command.svg)

Command design pattern is very useful in user interfaces (UI), where different elements and actions can open the menu. 
Let’s imagine that we want to open a menu in the hypothetical game. There are lots of possible ways to open the menu:

- Press on the menu with a mouse on a button;
- With a keyboard-like <kbd>Esc</kbd> button
- Focus the menu with the button with the joypad and open it with the A-button.
- Open with voice
- etc.

All of them execute only a single command. Which is encapsulated outside the menu and invokers.

## Menu class

The menu is represented by the `Menu` class with a state and only three methods for simplicity: `getState`,` open`, and 
`close`. By default, the menu is closed.

```lua
---@class Menu
---@field private state boolean
local Menu = {}
Menu.__index = Menu

---@return Menu
function Menu:new()
	local t = {
		state = false
	}
	return setmetatable(t, self)
end

function Menu:open()
	self.state = true
end

function Menu:close()
	self.state = false
end

---@return boolean
function Menu:getState()
	return self.state
end

return Menu
```

## MenuOpenCommand and MenuCloseCommand classes

There are two classes with a common interface, `execute()`, and both of them are receiving one argument, in the
`Menu` constructor. With these two classes, the menu opens or closes, and it doesn’t matter “who?” and “when?” called 
these commands; it can be a button, keyboard, joypad, or even programmatically.

```lua
---@class MenuOpenCommand
---@field menu Menu
local MenuOpenCommand = {}
MenuOpenCommand.__index = MenuOpenCommand

---@param menu Menu
---@return MenuOpenCommand
function MenuOpenCommand:new(menu)
	local t = {
		menu = menu,
	}
	return setmetatable(t, self)
end

function MenuOpenCommand:execute()
	self.menu:open()
end

return MenuOpenCommand
```

```lua
---@class MenuCloseCommand
---@field menu Menu
local MenuCloseCommand = {}
MenuCloseCommand.__index = MenuCloseCommand

---@param menu Menu
---@return MenuCloseCommand
function MenuCloseCommand:new(menu)
	local t = {
		menu = menu,
	}
	return setmetatable(t, self)
end

function MenuCloseCommand:execute()
	self.menu:close()
end

 return MenuCloseCommand
```

## OpenButton and CloseButton invokers

Next, let's define our invokers, two buttons: one will open the menu, and the second will close it. Clicking on the 
button will invoke the command.

```lua
---@class OpenButton
---@field private command MenuOpenCommand
local OpenButton = {}
OpenButton.__index = OpenButton

---@param command MenuOpenCommand
---@return OpenButton
function OpenButton:new(command)
	local t = {
		command = command
	}
	return setmetatable(t, self)
end

function OpenButton:click()
	self.command:execute()
end

 return OpenButton
```

```lua
---@class CloseButton
---@field private command MenuCloseCommand
local CloseButton = {}
CloseButton.__index = CloseButton

---@param command MenuCloseCommand
---@return CloseButton
function CloseButton:new(command)
	local t = {
		command = command
	}
	return setmetatable(t, self)
end

function CloseButton:click()
	self.command:execute()
end

return CloseButton
```

## Usage

```lua
local Menu = require("Menu")
local MenuOpenCommand = require("MenuOpenCommand")
local MenuCloseCommand = require("MenuCloseCommand")
local OpenButton = require("OpenButton")
local CloseButton = require("CloseButton")

local menu = Menu:new()
local openCmd = MenuOpenCommand:new(menu)
local closeCmd = MenuCloseCommand:new(menu)
local openBtn = OpenButton:new(openCmd)
local closeBtn = CloseButton:new(closeCmd)
-- closed by default
print(menu:getState()) -- false
openBtn:click()
print(menu:getState()) -- true
closeBtn:click()
print(menu:getState()) -- false
```

*[UI]: User Interface