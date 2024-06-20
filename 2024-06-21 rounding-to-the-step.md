<!-- Description: Rounding integers to a given step is a very common task, sometimes asked at technical interviews and very often such a task appears in daily jobs. -->

tags: lua

# Rounding a number to step

Rounding integers to a given step is a very common task, sometimes asked at
technical interviews and very often such a task appears in daily jobs.

## Algorithm

![Figure 01: Rounding to step ](/assets/img/rounding-step.svg)

1. (optional) Subtract `offset` from `n`;
  ```text
    x = n - offset    
  ```
2. divide *step #1 value* by `step`;
  ```text
    x = x / step    
  ```
3. (optional) to make it work like a round function, then add to the *step
  #3 value* `0.5`; 
  ```text
    x = x + 0.5    
  ```
4. apply `math.ceil` function to *step #3 value*, 
  ```text
    x = ceil(x)    
  ```
5. multiply *step #2 value* by `step`;
  ```text
    x = x * 2
  ```
6. (optional) After adding `offset` to the final result.
  ```text
    x = x + offset
  ```

## Function for the rounding

```lua
---@param n number
---@param step number
---@param offset? number is added to the result
local function round(n, step, offset)
	offset = offset or 0
	return math.ceil((n - offset) / step + 0.5) * step + offset
end
```

## Examples

```lua
print(round(-643, 50)) --> -650
print(round(-117, 10, 10)) --> -120
print(round(-113, 10)) --> -110
print(round(0, 10)) --> 0
print(round(9, 10)) --> 10
print(round(10, 10)) --> 10
print(round(133, 20)) --> 140
print(round(122, 20)) --> 120
print(round(134, 50)) --> 150
print(round(1123, 50)) -->1100
```