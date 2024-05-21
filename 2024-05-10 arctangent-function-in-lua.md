<!-- Description: math.atan and math.atan2 in Lua. Explanation of arctangent function and why it is inconsistent in different versions of Lua. -->

tags: lua beginner

# Arctangent function in Lua

Looks like simple mathematical function arctangent is very confusing in Lua.
In Lua version 5 this function changed many times. I found such variants:

- `math.atan(x)`: 5.1, 5.2
- `math.atan2(x, y)`: 5.1, 5.2
- `math.atan(y [, x])`: 5.3, 5.4

It is very confusing. Let's try to figure out what is what.

## What is the trigonometric arctangent function

Time to remind a school math class.

This is a very common function for game developers. It allows us to find the
angle between a point and X axis. This is how rotations are calculated in
game development.

![Figure 01. Arctangent angles with arctangent](/assets/img/atan01.svg)

We know two points: *A(10, 10) and *O(0, 0)* is center. If 2 points are known, 
then we can make a line between them. General equation of a line
(linear function):

```text
y = kx + c*
```

Where:

- ***y*** is the value on the Y-axis.
- ***k*** is the tangent of the angle between the line and the X-axis
  (***k = tan(α)***). 
- ***x*** value on the X-axis.
- ***c*** offset by the Y-axis.

Consider point ***A(10, 10)***:

```text
y = tan(α) * x
tan(k) = y/x
α = arctan(y/x)
α = arctan(10/10) = arctan(1)
α ≈ 0.78539 = 45°
```

Consider point ***B(5, -10)***:

```text
y = tan(α) * x
tan(k) = y/x
α = arctan(y/x)
α = arctan(-10/5) = arctan(-2)
α ≈ -1.107149 ≈ -63.4349°
```
## Lua function

Lua's built-in `math` library calculates everything written above for you. But
there are many versions in different Lua versions and which to use.
Usually `math.atan()` or `math.atan2()` functions confuse beginners.

> Function `math.atan2()` is deprecated and might not work in your environment.

The general rule is to use `math.atan()` in the form. 

```lua
local x, y = 10, 10
print(math.atan(y / x)) --> 0.78539816339745 radians which equal 45 degrees
```

This should work with every Lua version.

## Conclusion

Use `math.atan()` not `math.atan2()` everywhere possible.

## Bonus: converting radians to degrees and vice-versa

Function to convert radians to degrees:

```lua
local function rad2deg(r)
	return r * (180 / math.pi)
end
```

Function to convert degrees to radians:

```lua
local function deg2rad(d)
	return d * (math.pi / 180)
end
```

## Links

- [Lua manual: math.atan()](https://www.lua.org/manual/5.4/manual.html#pdf-math.atan)
- [Wikipedia: Inverse trigonometric functions](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions)
- [Another good explanation](https://www.omnicalculator.com/math/arctan)