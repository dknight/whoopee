<!-- Description: The Visitor pattern is a behavioral design pattern that enables you to separate an algorithm from the object structure it operates on. -->

tags: lua design-patterns

# Visitor

The Visitor pattern is a behavioral design pattern that enables you to separate an algorithm from the object structure
it operates on. In other words, the visitor extends the functionality of the object by changing the initial
implementation.

![Visitor Scheme](/assets/img/dp-visitor.svg)

## Monster class

Every monster instance can be visited by the visitor and print information about the monster. Also, the monster can
accept as many visitors as needed. This is the simplest example of a usage visitor. Visitor is a good pattern if
you, for some reason, do not want, or you cannot to add the `printMonster` method in the `Monster` class.

```lua
---@class Monster
---@field public name string
---@field public hp number
---@field public damange number
local Monster = {}
Monster.__index = Monster

---@return Monster
function Monster:new(name, hp, damage)
	local t = {
		name = name,
		hp = hp,
		damange = damage,
	}
	return setmetatable(t, self)
end

---@param visitor Visitor
function Monster:accept(visitor)
	visitor:visit(self)
end

return Monster
```

## PrintVisitor class

The `PrintVisitor` class only prints the information about the monster. The class has a method called `visit`, but
this method can also be used as a single function.[OOP](/post/object-oriented-programming-in-lua.html) principles are
used only for consistency reasons.

```lua
---@class PrintVisitor
local PrintVisitor = {}
PrintVisitor.__index = PrintVisitor

---@return PrintVisitor
function PrintVisitor:visit(instance)
	for k, v in pairs(instance) do
		print(k, v)
	end
end

return PrintVisitor
```

## Usage

```lua
local Monster = require("Monster")
local PrintVisitor = require("PrintVisitor")

local goblin = Monster:new("Goblin", 100, 5)
local skelly = Monster:new("Skeleton", 80, 7)
local demon = Monster:new("Demon", 200, 15)

goblin:accept(PrintVisitor)
skelly:accept(PrintVisitor)
demon:accept(PrintVisitor)
--[[
hp      100
damange 5
name    Goblin
hp      80
damange 7
name    Skeleton
hp      200
damange 15
name    Demon
--]]
```