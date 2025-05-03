<!-- Description: The Memento pattern is a type of design pattern that helps you save and restore an object's earlier state without needing to understand how the object works internally. -->

tags: lua design-pattern

# Memento

The Memento pattern is a type of design pattern that helps you save and restore an object's earlier state without
needing to understand how the object works internally.

![Scheme Memento](/assets/img/dp-memento.svg)

The first thing that comes to mind is the undo (<kbd>Ctrl</kbd>+<kbd>z</kbd>) operation in any text or graphics editor.

Usually, memento is implemented with three classes: `Memento`, `Originator` and `Caretaker`, but these classes
can be combined into one class or use a function.

## Memento class

Memento itself is a very simple class, with a constructor and a field.

```lua
---@class Memento
---@field public value any
local Memento = {}
Memento.__index = Memento

---@return Memento
function Memento:new(value)
	local t = {
		value = value,
	}
	return setmetatable(t, self)
end

return Memento
```

## Originator class

This class is responsible for creating a memento, storing it, and returning it to the caretaker. This also can be omitted and moved to the `Memento` class as “static” methods. Or use the functions.

```lua
---@class Originator
local Originator = {
	---@param value any
	---@return Memento
	save = function(value)
		return Memento:new(value)
	end,
	---@param memento Memento
	---@return any
	restore = function(memento)
		return memento.value
	end,
}

return Originator
```

## Caretaker class

The `Caretaker` is responsible for storing the mementos and returning them to the originator. The logic behind the caretaker is to know "when" and "why" to capture the originator’s state, but also when the state should be restored.

```lua
---@class Caretaker
---@field private mementoes Memento[]
local Caretaker = {}
Caretaker.__index = Caretaker

---@return Caretaker
function Caretaker:new()
	local t = {
		mementoes = {},
	}
	return setmetatable(t, self)
end

---@param memento Memento
function Caretaker:addMemento(memento)
	table.insert(self.mementoes, memento)
end

---@param index number
---@return Memento
function Caretaker:getMemento(index)
	return self.mementoes[index]
end

return Caretaker
```

## Usage of Memento

```lua
local Caretaker = require("Caretaker")
local Originator = require("Originator")

local caretaker = Caretaker:new()
caretaker:addMemento(Originator.save("hi"))
caretaker:addMemento(Originator.save("hello"))
caretaker:addMemento(Originator.save("hello, world"))

print(Originator.restore(caretaker:getMemento(1))) -- hi
print(Originator.restore(caretaker:getMemento(2))) -- hello
print(Originator.restore(caretaker:getMemento(3))) -- hello, world!
print(Originator.restore(caretaker:getMemento(4))) -- error!
```