<!-- Description: Decorator is a pattern in Lua that adds new behavior to objects by wrapping them in other objects without changing the original code. -->

tags: lua design-patterns

# Decorator

Decorator is a design pattern that lets you add new features or behaviors to an object without changing its original
code. You do this by wrapping the object in another object (called a decorator) that adds the new behavior.

Decorator became so popular pattern that some programming languages like Java, TypeScript, and JavaScript added
the decorators to their syntax with `@Decorator` syntax.

Let's imagine we have the RPG game where our hero can be blessed, which increases the hero attributes by 10%. And we do
not want to change our hero's original attributes.

![Decorator Scheme](/assets/img/dp-decorator.svg)

## Hero class

Hero class is just straight to keep simplicity in demonstration it has only getters.

```lua
---@class Hero
---@field private name string
---@field private hp number
---@field private damage number
---@field private xp number
local Hero = {}
Hero.__index = Hero

---@return Hero
function Hero:new(name, hp, damage, xp)
	local t = {
		name = name,
		hp = hp,
		damage = damage,
		xp = xp,
	}
	return setmetatable(t, self)
end

---@return string
function Hero:getName()
	return self.name
end

---@return number
function Hero:getDamage()
	return self.damage
end

---@return number
function Hero:getHP()
	return self.hp
end

---@return number
function Hero:getXP()
	return self.xp
end

return Hero
```

## BlessSpellDecorator class

Here we have same interface as `Hero` class, but decorator can decorate not all methods and/or properties, but only 
which are needed to be decorated. As you can see we do not change `xp` field.

```lua
---@class BlessSpellDecorator
---@field private hero Hero
local BlessSpellDecorator = {}
BlessSpellDecorator.__index = BlessSpellDecorator

---@return Hero
---@param hero Hero
function BlessSpellDecorator:new(hero)
	local t = {
		hero = hero
	}
	return setmetatable(t, self)
end

---@return string
function BlessSpellDecorator:getName()
	return self.hero:getName() .. " (blessed)"
end

---@return number
function BlessSpellDecorator:getDamage()
	return self.hero:getDamage() + self.hero:getDamage() * 0.1
end

---@return number
function BlessSpellDecorator:getHP()
	return self.hero:getHP() + self.hero:getHP() * 0.1
end

return BlessSpellDecorator
```

### BlessSpellDecorator class usage

Here we decorate our hero with `BlessSpellDecorator` and get updated attributes.

```lua
local Hero = require("Hero")
local BlessSpellDecorator = require("BlessSpellDecorator")

local hero = Hero:new("Max", 100, 10, 0)
local blessedHero = BlessSpellDecorator:new(hero)
print(hero:getName(), hero:getDamage(), hero:getHP()) --> Max     10      100
print(blessedHero:getName(), blessedHero:getDamage(), blessedHero:getHP()) --> Max (blessed)    11.0    110.0
```
