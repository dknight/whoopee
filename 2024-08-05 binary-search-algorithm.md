<!-- Desecription: Explanation and implementation of the Binary Search Algorithm in Lua.-->

tags: lua algorithms beginner

# Binary Search Algorithm

[TOC]

An algorithm known as binary search is used to locate a target value's
position (index) within a **sorted array**. Until the target value is found or
the interval is empty, it operates by halving the search interval iteratively.
By comparing the target element with the search space's middle value, the
search interval is cut in half. Such method used method is known as
[dichotomy](https://en.wikipedia.org/wiki/Dichotomy), in Greek language it
means "divided by two".

!!! tip
    If there is a task to find something in sorted data, the binary search is the
    way worth trying first.

## Presquities to use Binary Search

- Array or similar data structures must be sorted.
- Access to any element of the array/data structure should take constant time.
  (In Lua accessing table's element by index has complexity *O(1)* by default.)

## Linear Search vs Binary Search

For smaller data sets with few elements, there is no big difference between
linear and binary search. The difference becomes huge if there are many more
records like millions and billions. Linear search has complexity *O(n)*, which means the time
of the algorithm will grow linearly. Consider, an array with numbers from 1 to 100,
if we want to find the number 42, we need to start from 1 and go for each element
and compare if it equals 42 or the array ends and the search target is not found. In the best case, if we search for the number 1
only one iteration is needed. The worst case is for the number 100 and the same
number of the iterations is required correspondingly. Reminder from school math class linear function's equation
*f(x)=x*.

Binary search has complexity *O(log(n))*, which will require much fewer iterations
rather than *O(n)* when the number of records becomes larger.

## Algorithm

Considering we have an array, the target element will be 79.

```lua
local arr = { 0, 4, 13, 22, 35, 42, 57, 66, 79, 81, 91, 108, 120 }
```

1. Find the middle (**mid**) index, sum or lower (**low**) and higher (**high**)
   of the array divided by two halves.
2. Compare the middle element to the target (79).
3. If the middle element is equal to the target (79) then return it (found with 1 attempt).
    1. If the middle element is larger than the target (79), then the part (right) after the current middle will be used for the next search.
    2. If the middle element is smaller than the target (79), then the part (left) before the current middle will be used for the next search
4. Continue the procedure until the target is found or the search interval is empty
   return `nil`.

![Figure 01. Binary Search](/assets/img/binary-search.svg)

## Implemtatation

```lua
---Searches the value in sorted 't' table using binary search
---algorithm. Retuns nil if value not found.
---@param t table
---@param x any
---@return number|nil
local function binarySearch(t, x)
	local low = 1
	local high = #t
	local mid
	while high >= low do
		mid = (low + high) // 2
		if t[mid] == x then
			return mid
		elseif t[mid] > x then
			high = mid - 1
		else
			low = mid + 1
		end
	end
	return nil
end
```

## Number of maximum iterations

There is a simple math formula to calculate a possible number of iterations.

*n=⌊log<sub>2</sub>(r)⌉* (rounded to upper integer value)

Where: **n** -- number of iterations, **r** -- range;

| Range (r)        | log(r)                               | Approx.  | Iterations* |
-------------------|--------------------------------------|----------|--------------
| 10               |  log<sub>2</sub>(10<sup>1</sup>)     | 3.322    | 4           |
| 100              |  log<sub>2</sub>(10<sup>2</sup>)     | 6.644    | 7           |
| 1 000            |  log<sub>2</sub>(10<sup>3</sup>)     | 9.966    | 10          |
| 10 000           |  log<sub>2</sub>(10<sup>4</sup>)     | 13.288   | 14          |
| 100 000          |  log<sub>2</sub>(10<sup>5</sup>)     | 16.61    | 17          |
| 1 000 000        |  log<sub>2</sub>(10<sup>6</sup>)     | 19.93    | 20          |
| 10 000 000       |  log<sub>2</sub>(10<sup>7</sup>)     | 23.253   | 24          |
| 100 000 000      |  log<sub>2</sub>(10<sup>8</sup>)     | 26.575   | 27          |
| 1 000 000 000    |  log<sub>2</sub>(10<sup>8</sup>)     | 29.9     | 30          |
| 10 000 000 000   |  log<sub>2</sub>(10<sup>10</sup>)    | 33.22    | 34          |
| 10<sup>20</sup>  |  log<sub>2</sub>(10<sup>20</sup>)    | 66.44    | 67          |
| 10<sup>100</sup> |  log<sub>2</sub>(10<sup>100</sup>)   | 332.2    | 333         |
| 10<sup>300</sup> |  log<sub>2</sub>(10<sup>300</sup>)   | 999.6    | 1000        |

\* The approximate value is rounded to the upper integer, to get the iteration count.

## Bonus. `isSorted()` function

The Function to check is that the array is sorted in ascending order as
complexity *O(n)*.

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
- [Wikipedia: Logarithm](https://en.wikipedia.org/wiki/Logarithm)
- [GeeksForGeeks: Binary Search](https://www.geeksforgeeks.org/binary-search/)