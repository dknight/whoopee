<!-- Description: The Proxy pattern is a structural design pattern that provides a substitute or placeholder for another object. It manages access to the original object, enabling you to execute specific actions either before or after forwarding a request to that object. Check Proxy implementation in Lua. -->

tags: lua design-patterns

# Proxy

The Proxy pattern is a structural design pattern that provides a substitute or placeholder for another object. It
manages access to the original object, enabling you to execute specific actions either before or after forwarding a
request to that object. By nature, Proxy is very similar to [Decorator](/post/design-pattern-decorator.html), but with
one significant difference that decorator extends the object, but proxy substitutes the object.

Usually Proxy is used for:

- Lazy loading;
- Filters;
- Cache;
- Logging;
- Remote Proxy.

While [Decorator](/post/design-pattern-decorator.html) for:

- Composite behavior without inheritance;
- Extend functionality.

In mane aspects Proxy and Decorator are very similar.

## Hero class

Here is simple `Hero` class with some fields like damage, hit points, damage, and experience. Also it contains two
methods `Hero:attack()` and `Hero:defend()`.

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

function Hero:attack()
	print("Hero is attacking")
end

function Hero:defend()
	print("Hero is defending")
end

return Hero
```

## HeroProxy class

In this example, the proxy pattern might be very overwhelming, but it is done for simplicity. Here Proxy acts like a
filter and checks can the hero perform any actions like attack or defend.

```lua
---@class HeroProxy
---@field private hero Hero
local HeroProxy = {}
HeroProxy.__index = HeroProxy

---@param hero Hero
---@return HeroProxy
function HeroProxy:new(hero)
	local t = {
		hero = hero,
	}
	return setmetatable(t, self)
end

function HeroProxy:attack()
	if self:canAttackOrDefend then
		self.hero:attack()
	else
		print("cannot attack, hero is dead")
	end
end

function HeroProxy:defend()
	if self:canAttackOrDefend then
		self.hero:defend()
	else
		print("cannot defend, hero is dead")
	end
end

---@return boolean
function HeroProxy:canAttackOrDefend()
	return self.hero.hp > 0
end

return HeroProxy
```

### HeroProxy usage

```lua
local Hero = require("Hero")
local HeroProxy = require("HeroProxy")

local hero = Hero:new("Max", 100, 10, 22)
local proxy = HeroProxy:new(hero)
proxy:attack() -- Hero is attacking
hero.hp = 0    -- set hit points to zero, which means hero is dead
proxy:attack() -- cannot attack, hero is dead
```