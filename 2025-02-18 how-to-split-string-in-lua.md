<!-- Description: Example how to split string in Lua with generic function considering utf8. -->

tags: lua algorithms

# How to split string in Lua

## Simple case

There are numerous examples available online that demonstrate how to split a string in the Lua
language. Most of them are very specific and do not cover generic and edge cases.

Like this one:

```lua
---A very dumb split string function.
---@param str string
---@param sep? string
---@return string[]
local function split(str, sep)
	sep = sep or "%s"
	local t = {}
	for s in string.gmatch(str, "([^" .. sep .. "]+)") do
		t[#t + 1] = s
	end
	return t
end
```

Probably in most cases it is enough. The advantage of this version is that it is very
performant. But if you need a more common solution with a more complex pattern for splitting,
even considering UTF-8 encoding, this example above will not work.

## Common solution

I would like to introduce the function that covers all edge cases. Of course, it is not such
performant as I would like to have. The resЛult is identical to JavaScript's
[`String.prototype.split()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/split).

```lua
---Generic split function for splitting the string, taking into account
---UTF-8 encoding.
---@param str string Input string.
---@param sep? string Separator pattern or string (default empty string).
---@param n? number Number of splits: if less than zero, then all substrings are returned.
---If 0 empty table is returned.
---@param offset? number UTF-8 bytes offset (default 1)
---@param plain? boolean Turns off the pattern matching facilities.
---@return string[]
local function split(str, sep, n, offset, plain)
    sep = sep or ""
    offset = offset or 1
    n = n or -1

    ---Result value
    ---@type string[]
    local t = {}

    if n == 0 then
        return t
    end

    local len = utf8.len(str)
    -- If empty string, then return table with single element containing empty string.
    if len == 0 then
        t[#t + 1] = ""
        return t
    end

    local i = 1
    local start = 1
    while true do
        local sepBegin, sepEnd = str:find(sep, start, plain)
        if not sepBegin then
            t[#t + 1] = str:sub(start)
            break
        elseif sepEnd < sepBegin then
            -- If empty separator, then explode string considering UTF8
            t[#t + 1] = str:sub(
                    utf8.offset(str, start),
                    utf8.offset(str, sepBegin + offset) - offset
            )
            if sepBegin < len then
                start = sepBegin + 1
            else
                break
            end
        else
            if sepBegin > start then
                t[#t + 1] = str:sub(start, sepBegin - offset)
            else
                t[#t + 1] = ""
            end
            start = sepEnd + offset
        end
        if n == i then
            break
        end
        i = i + 1
    end

    return t
end
```

### Testing common solution

Tests are performed using [Laura](https://github.com/dknight/laura) testing library.

```lua
local laura = require("laura")
local expect = laura.expect
local describe = laura.describe
local it = laura.it
local split = require("./split")

describe("function split()", function()
	local testPairs = {
		{ "", "", { "" } },
		{ "a,b,c", "def", { "a,b,c" } },
		{ "a,b,c", ",", { "a", "b", "c" } },
		{ " xyz ", "", { " ", "x", "y", "z", " " } },
		{ "abc def", "", { "a", "b", "c", " ", "d", "e", "f" } },
		{ "абв где", "", { "а", "б", "в", " ", "г", "д", "е" } },
		{ " a b c", " ", { "", "a", "b", "c" } },
		{ "Hello Mike, Hello Jane", "Hello", { "", " Mike, ", " Jane" } },
		{
			"a man a plan a canal panama",
			"a ",
			{ "", "man ", "plan ", "canal panama" },
		},
		{ "Миру - Мир!", "Мир", { "", "у - ", "!" } },
		{
			"月は明るく輝いているa",
			"",
			{
				"月",
				"は",
				"明",
				"る",
				"く",
				"輝",
				"い",
				"て",
				"い",
				"る",
				"a",
			},
		},
		{
			"hello,world.and.dots",
			"[.,]",
			{ "hello", "world", "and", "dots" },
		},
		{
			"/home/user/config",
			"[\\/]",
			{ "", "home", "user", "config" },
		},
		{ "===", "=", { "", "", "", "" } },
	}

	for _, pair in ipairs(testPairs) do
		local name = string.format(
			'should split "%s" with seprator "%s"',
			pair[1],
			pair[2]
		)
		it(name, function()
			expect(split(pair[1], pair[2])).toDeepEqual(pair[3])
		end)
	end

	local testPairsN = {
		{ "hello world", " ", 0, {} },
		{ "hello world", " ", -1, { "hello", "world" } },
		{ "hello world", " ", -999, { "hello", "world" } },
		{ "a,b,c,d", ",", 2, { "a", "b" } },
		{ "a,b,c,d", ",", 1, { "a" } },
		{ "a,b,c,d", ",", 49, { "a", "b", "c", "d" } },
	}

	for _, pair in ipairs(testPairsN) do
		local name = string.format(
			'should split "%s" %d times with seprator "%s"',
			pair[1],
			pair[3],
			pair[2]
		)
		it(name, function()
			expect(split(pair[1], pair[2], pair[3])).toDeepEqual(pair[4])
		end)
	end
end)

--[[
SUMMARY
20 of 20 passing
0 failing
0 skipping

time: ~13ms / mem: 302.93KB @ 2025-02-18 15:41:14
pass
--]]
```