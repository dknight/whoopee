<!-- Desecription: Explanation and implementation of the Binary Search Algorithm in Lua.-->

tag: lua algorithms

# Binary Search Algorithm

An alorithm known as binary search is used to locate a target value's
position (index) within a sorted array. Until the goal value is found or
the interval is empty, it operates by halving the search interval periodically.
By comparing the target element with the search space's middle value, the
search interval is cut in half.

Method usd method [**dichotomy**](https://en.wikipedia.org/wiki/Dichotomy),
in Greek language it means "divided by two".

## Sorted data

- Array or similar data structure must be sorted.
- Access to any element of the array/data structure should take constant time.



## Bonus. Function to check is table is sorted

Simple function to check is array is sorted in ascending order as complexity `O(n)`.

```lua
---@param t table
---@return boolean
local function isSorted(t)
	for i = 2, #t do
		if t[i - 1] > t[i] then
			return false
		end
	end
	return true
end

-- examples

local t1 = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 10 }
print(isSorted(t1)) --> true

local t2 = { 0, 1, 6, 10, 4, 9, 7, 5, 10 }
print(isSorted(t2)) --> false

```
## References

- [Wikipedia: Dichotomy](https://en.wikipedia.org/wiki/Dichotomy)