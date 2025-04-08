<!-- Description: Comparing numbers with floating points is not as straightforward as it might seem. Here is a detailed explanation of how numbers work in Lua and how to compare them safely to avoid unexpected bugs. -->

tags: lua c beginner

# How to compare floating-point numbers in Lua

In Lua, the `number` type represents real (double-precision floating-point)
numbers. **Lua does not have a separate integer type.**

There’s a common misconception that floating-point numbers are unreliable even
for simple operations like increments. However, when you use a double to
represent integers (whole numbers), there is no rounding error—unless the
number exceeds 253. In other words, Lua numbers can safely represent huge
integers without rounding problems. Additionally, most modern CPUs handle
floating-point arithmetic just as fast as integer [^1].

By default, Lua is compiled to use either single or double precision
floating-point numbers. (You can check your configuration in
[`luaconf.h`](https://www.lua.org/source/5.4/luaconf.h.html)). With
double precision (64-bit floats), you are relatively safe. However, if
Lua is compiled with single precision (32-bit floats), comparing
numbers can become less reliable.

Consider the following example:

```lua
1/9 --> 0.11111111111111 (approximately 14 digits of 1)
1/9 == 1/9 --> true
0.11111111111111 == 0.11111111111111 --> true
1/9 == 0.11111111111111 --> false
```

This behavior occurs because of how floating-point numbers are
represented internally in C and Lua using the [IEEE 754](https://en.wikipedia.org/wiki/IEEE_754)[^2]
standard. When a number
cannot be exactly represented, direct comparisons can produce
unexpected results. This should always be in your head, there are very
basics of programming.

## Safer Float Comparison

!!! tip
	When comparing floats, always use a tiny allowed difference instead of `==`.

This avoids hardly detected bugs, especially when doing math like money calculations,
physics simulations, measurement, etc. Which might be critical in finance and game
development.

It’s a good idea to use a helper function to safely compare two
floating-point numbers:

```lua
---Compares two numbers for approximate equality, including edge cases.
---@param a number
---@param b number
---@param epsilon? number - Tolerance for precision (default: 0.000001)
---@return boolean
local function compareNumbers(a, b, epsilon)
    epsilon = epsilon or 1e-6
    return a == b or math.abs(a - b) < epsilon
end
```

When working with floats, using this function helps you avoid
unexpected surprises when comparing values with floating-point.

```lua
print(compareNumbers(42, 42))                             -- true
print(compareNumbers(1/9, 1/9))                           -- true
print(compareNumbers(1/9, 0.11111111111111))              -- true
print(compareNumbers(0.11111111111111, 0.11111111111111)) -- true
print(compareNumbers(0, 0))                               -- true
print(compareNumbers(0, -0))                              -- true
print(compareNumbers(math.huge, math.huge))               -- true
print(compareNumbers(1e-6,  0.000001))                    -- true
print(compareNumbers(0.00001, 0.000001))                  -- false
```

## References

[^1]: [Programming in Lua: 2.3 – Numbers](https://www.lua.org/pil/2.3.html)
[^2]: [IEEE 754](https://en.wikipedia.org/wiki/IEEE_754)

