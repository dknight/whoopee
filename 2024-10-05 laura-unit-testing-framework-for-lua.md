<!-- Description: Documentation for Laura is a lightweight unit-testing framework for Lua with simplicity in mind. -->

tags: lua

# Documentation for Laura unit-testing framework

<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>

[TOC]

## Install

[Source code on GitHub](https://github.com/dknight/laura/)

There are several ways to install: LuaRocks, Make utility, and manual.

### LuaRocks

```sh
luarocks install laura
```

...or use the tree in the user's home directory.

```sh
luarocks --local install laura
```

### Makefile

Using the `make` utility to install.

Clone the source code.

```sh
git clone https://github.com/dknight/laura.git
```

Run `make`

```sh
make install
```

There are variables that can be set with `make`.

- `PREFIX`: basic installation prefix for the module (default `/usr/local`);
- `BINDIR`: use the binary path in the file system tree (default `${PREFIX}/bin`);
- `LIBDIR`: where to put the shared libraries (default `${PREFIX}/share/lua/${LUA_VERSION}`)

Consider:

```sh
PREFIX=/opt/lua/libs BINDIR=/opt/bin LIBDIR=/opt/share make install
```

### Manual installation

Just clone the repository and include the location to `LUA_PATH` environment
variable.

## Using Command Line Client (CLI)

After installation, `laura` executable will be available in OS `$PATH`. To check version and 
all available flags, use `-h` or `--help` flag.

```sh
laura --help
```

### CLI flags

- `-c`, `--config`: path to [config](#configuration) file, override defaults.
- `-r`, `--reporters`: comma-separated reporters.
- `-S`, `--nosummary`: do not print summary; just run the tests without summary information.
- `-v`, `--version`: print the current version of the Laura framework.
- `-h`, `-?`, `--help`: prints the help information.

Example command:

```sh
laura -c ~/my-custom-config.lua --reporters text,blank -S ./tests
```

## Configuration

There are open configurations, which can be configured. Config options are in
capitalized case due to Lua @enum convention.

- **Color**: enables colors in terminal if possible, default `true`.
- **Dir**: directory where tests are located. Current directory
  `.` by default.
- **FilePattern**: pattern for test files, default `"*_test.lua"`.
- **Tab**: tabulation string, default `"\t"`.
- **Traceback**: print full traceback from debug library on test
  failure, default `false`.
- **Reporters**:  list of reporters. Currently available
  reporters are **blank**, **count**, **dot** and **text**,
  default `{ "text" }`.
- **ReportSummary**: print test summary If the reporter supports it,
  default `true`.
- **UTF8**: use UTF-8 for string comparison, default `true`.
  Compatibility note: Before Lua 5.3 there was no UTF8 support.
	Install an [extra module for UTF8 support](https://github.com/starwing/luautf8)
- **Coverage**: Coverage config table;
  - **Enabled**: disables or enables coverage collection, default `false`; 
  - **Threshold**: if target coverage is less than the percentage, program will
    exit with `Config._exitCoverageFailed` (2). Zero or negative value of this
    option will ignore threshold.

Also, there are ["private" configuration fields](https://github.com/dknight/laura/blob/main/src/laura/Config.lua), which are not recommended to change unless you know that
you know what you are doing.

### Set config with command line

Use the `-c` flag to pass the path to your config file.

```sh
laura -c ./path-to-config-file.lua .
```

### Set configuration from API

Use `setup` method from `laura` module to set configuration from the API.

Consider:

```lua
local laura = require("laura")

laura.setup({
  ReportSummary = false,
  UTF8 = false,
  Dir = "./specs",
  Pattern = "*.spec.lua",
  -- etc.
 })

-- rest of the code
```

## Writing tests

## Using CLI runner

Writing tests is pretty simple and straightforward. Create a file with the
suffix `*_test.lua` (the suffix can be changed in the [configuration](#configuration)).

Consider **simple_test.lua**:

```lua
local describe = require("laura.Suite")
local it = require("laura.Test")
local expect = require("laura.expect")

describe("my test case", function()
	it("should be equal to three", function()
		expect(1 + 2).toEqual(3)
	end)
end)
```

After this run code snippet, just run the command:

```sh
laura
```

Output is similar to:

```text
my test case
        [passing] should be equal to three (1.1ms)

SUMMARY
1 of 1 passing
0 failing
0 skipping

time: ≈1.0ms / mem: 20.80KB @ Sun Sep 29 02:09:02 2024
pass
```
### Using standalone API

If, for some reason, CLI is not an option or there is a need for more complex logic. There is an option to use the API.

Consider **api_test.lua**:

```lua
local laura = require("laura")
local TextReporter = require("laura.reporters.text")

local it = laura.it
local describe = laura.describe
local expect = laura.expect
local Runner = laura.Runner

describe("my test case", function()
	it("should be equal to three", function()
		expect(1 + 2).toEqual(3)
	end)
end)

local runner = Runner:new()
local results = runner:runTests()
local reporter = TextReporter:new(results)
reporter:report()
runner:done()
```

Use Lua interpreter to run the example above; use command:

```sh
lua api_test.lua
```

## Suite

A test suite is a collection of test cases that are grouped together to
test a particular piece of software, a specific functionality, or an
entire application. Test suites help in organizing and running tests
in a structured and efficient way, ensuring that multiple tests can be
executed as part of a single execution flow.

Consider:

```lua
local describe = require("laura.Suite")

describe("Everything related to API module", function()
  -- test cases
end)
```

Or using suite [BDD](#testing-techniques-bdd-tdd) style:

```lua
local suite = require("laura.Suite")

suite("API module", function()
	-- test cases
end)
```

## Test case

A test case is a specific scenario or condition under which a tester or developer determines whether a piece of software (e.g., a function, module, or feature) behaves as expected. It typically consists of an input, execution conditions, and expected results that validate a particular function or feature of the unit.

Consider:

```lua
local describe = require("laura.Suite")
local it = require("laura.Test")

describe("Everything related to API module", function()
	it("should execute something and be true", function()
		-- expect the condition
	end)
end)
```

Or using suite [BDD](#testing-techniques-bdd-tdd) style:

```lua
local suite = require("laura.Suite")
local when = require("laura.Test")

suite("API module", function()
	when("function XXX executes it returns true", function()
		-- expect the condition
	end)
end)
```

## Testing Techniques: BDD, TDD

There are different techniques; like TDD, BDD, etc. Explanation of them
is out-of-scope of this article; just search on [the web definition and difference of them](https://duckduckgo.com/?q=bbd+vs+tdd).

## Skipping tests

There is a possibility to skip the test case or suite using the `skip` method.
Skipped tests won't run and will be reported as **[SKIPPED]**. Please note
that there is a `:` colon. If you mark a suite as skipped, all its children will
also be skipped.

```lua
local describe = require("laura.Suite")
local it = require("laura.Test")
local expect = require("laura.expect")

describe:skip("skipped suite", function()
	it:sli("should be skipped", function()
		expect(1 + 2).toEqual(3)
	end)
end)
```

## Only tests

Like skipped tests, mark tests with `only`; only marked tests will run;
others will be ignored, useful for debugging.

```lua
local describe = require("laura.Suite")
local it = require("laura.Test")
local expect = require("laura.expect")

describe:only("only suite", function()
	it("should be three", function()
		expect(1 + 2).toEqual(3)
	end)
end)
```
## Expect (Assertion)

When a function is being tested, often it is checked to meet certain conditions.
`expect` (or assertion) gives such possibility. The idea
is like native Lua's `assert(ok, error)` function. If the first argument is `true`,
then assertion is successful; otherwise, assertion will **fail** with a second
argument error; usually it stops the program.

Laura is just a wrapper around `assert` function with a much larger scope of
features and test structure and organization.

The syntax of expect is pretty simple:

```lua
expect(ActualValue).toMatcher(ExpectedValue)
```

Where:

- **ActualValue**: value to be tested.
- **ExpectedValue**: expected that ExpectedValue meets the condition for ActualValue.
- **toMatcher**: matcher function which specifies the conditions, check predefined [matchers](#matchers) below.

### Some tips to make functions testable

- Use the "pure function" concept from the functional programming paradigm.
  This means that the function always returns the same value(s) with the
	same argument(s). This approach helps to avoid side effects.
- Keep functions so small that they do only 1 thing. Do not try to write large
  universal function, the smaller functions much easier to test and maintain.
- Less arguments the better; personally, I prefer not more than 3. If there
  are more, it is hard to remember which argument and what its order is.
- Lua specific rule. Lua supports multiple values to be returned. I would
  prefer to return not more than two. There might be issues. which is hard
	to detect when a function returns more than one value.

Of course there are exceptions to these rules. These are best practices and
my personal recommendation based on experience. It is up to you.

## Matchers

### Equality

#### `toEqual`

Uses the equality `==` operator to compare the values.

Do not use `toEqual` when:

- Comparing float values, e.g., 0.2 + 0.3 might be equal to something like 0.50000000001.
  Use [`toBeCloseTo`](#tobecloseto) to compare float numbers.
- Be careful with tables. Tables in Lua are references; the equality operator
  `==` compares references, not key-value pairs. To compare tables by values, use
	[`toDeepEqual`](#todeepequal) (or its alias [`toBe`](#tobe)).


```lua
local Tim = {
	name = "Tim",
	age = 13,
	boy = true,
}

describe("toEqual", function()
	it("should be 13 years old", function()
		expect(Tim.age).toEqual(13)
	end)

	it("should be Tim", function()
		expect(Tim.name).toEqual("Tim")
	end)

	it("should be boy", function()
		expect(Tim.boy).toEqual(true)
	end)

	it("should have been play Doom 1", function()
		expect(Tim.playedDoom1).toEqual(nil)
	end)
end)
```

#### `toBe`

Alias of [`toDeepEqual`](#todeepequal).

#### `toBeNil`

If there is a need to check that something is `nil` use `toBeNil` matcher.
In Lua, everything that is not defined is `nil`.

```lua
local function beepBoop()
	-- by default nil is returned
end

it('bloop returns null', function ()
  expect(beepBoop()).toBeNil();
end)
```

#### `toBeFalsy`

Checks that value is false; in Lua everything expects `nil` and `false`
is true.

```lua
local function redIsNotBlue()
	return "red" == "blue"
end

it('beepBoop returns nil', function ()
  expect(redIsNotBlue()).toBeFalsy();
end)

local function beepBoop()
	-- by default nil is returned
end

it('beepBoop returns nil', function ()
  expect(beepBoop()).toBeFalsy();
end)
```

#### `toBeTruthy`

Checks that value is true; in Lua, everything else expects `nil` and `false`
is true.

```lua
local function isDarkAtNight()
	return true
end

it('beepBoop returns nil', function ()
  expect(isDarkAtNight()).toBeTruthy();
end)
```

#### `toHaveTypeOf`

Checks type of the value.

```lua
it('should be a number', function ()
  expect(123).toHaveTypeOf("number");
end)

it('should be a string', function ()
  expect("hello").toHaveTypeOf("string");
end)

it('should be a nil', function ()
  expect(nil).toHaveTypeOf("nil");
end)

it('should be a table', function ()
  expect({a = 12, b = 13}).toHaveTypeOf("table");
end)

-- etc. 
```

### Tables

#### `toDeepEqual`

`toDeepEqual` works similar to `toEqual` with one exception: for types
which are references; it compares by value, not by reference. Usually this
is how tables are compared: two tables have the same values, but these
might have different memory addresses. Also, there is an alias for this matcher
[`toBe`](#tobe).

```lua
local fruits1 = {
	apples = {
		count = 12,
		color = "green",
	},
	oranges = {
		count = 5,
		color = "orange",
	},
	bananas = {
		count = 3,
		color = "yellow",
	},
}

local fruits2 = {
	apples = {
		count = 12,
		color = "green",
	},
	oranges = {
		count = 5,
		color = "orange",
	},
	bananas = {
		count = 3,
		color = "yellow",
	},
}

it("should have different references", function()
	expect(fruits1).notToEqual(fruits2)
end)

it("should be same values", function()
		expect(fruits1).toDeepEqual(fruits2)
end)
```

In the example above, 2 different tables have the same value but different
references.  So in the sense of computer memory, these are different tables
which have the same values.

#### `toHaveLength`

Use the `#` length operator to match the table length. Be careful with "gaps" in the arrays.
For more details, read about the [length operator](https://www.lua.org/manual/5.4/manual.html#3.4.7) from Lua manual.

```lua
local fibonacci = { 1, 2, 3, 5, 8, 13 }

it("should have 6 first fibonacci numbers", function()
	expect(fibonacci).toHaveLength(6)
end)
```

#### `toHaveKeysLength`

Counts the table's keys that are not `nil`.

```lua
local pets = {
	["cat"] = "Barsik",
	["dog"] = "Woofey",
	["hamster"] = "Cookie",
	["rat"] = "Lara",
}

it("should have 4 animals", function()
	expect(pets).toHaveKeysLength(4)
end)
```

#### `toHaveKey`

Looks for specific key in the table.

```lua
local pets = {
	["cat"] = "Barsik",
	["dog"] = "Woofey",
	["hamster"] = "Cookie",
	["rat"] = "Lara",
}

it("should have a cat", function()
	expect(pets).toHaveKey("cat")
end)

it("should not to have a panda", function()
	expect(pets).notToHaveKey("panda")
end)
```

### Numbers

#### `toBeFinite`

The given number is finite. In Lua values `math.huge`, `-math.huge` and `n / 0`
may be threatened as "infinity".

```lua
it("should be infinite", function()
	expect(math.huge).notToBeFinite()
end)

it("should infinite if divide by zero", function()
	expect(42 / 0).notToBeFinite()
end)

it("should be finite", function()
	expect(555).toBeFinite()
end)
```

#### `toBeCloseTo`

`toBeCloseTo` is used to compare float numbers. At expected value, it
can accept a table, where the first value is a number.
The second value is the precision number of digits (default 2).

Mathematical test criteria is **|10<sup>-precision / 2</sup>|**, Lua code `math.abs(10 ** -precision) / 2`.

```lua
it("should be close with default precision 2", function()
	expect(4.715).toBeCloseTo(4.72)
end)

it("should be close with precision 4", function()
	expect(4.7777).toBeCloseTo({ 4.77765, 4 })
end)
```

#### `toBeGreaterThan`

Test the condition `actual > expected`.

```lua
it("should be greater than 40", function()
	expect(42).toBeGreaterThan(40)
end)
```

#### `toBeGreaterThanOrEqual`

Test the condition `actual >= expected`.

```lua
it("should be greater or equal than 42", function()
	expect(42).toBeGreaterThanOrEqual(42)
end)
```

#### `toBeLessThan`

Test the condition `actual < expected`.

```lua
it("should be less than 44", function()
	expect(42).toBeLessThan(44)
end)
```

#### `toBeLessThanOrEqual`

Test the condition `actual <= expected`.

```lua
it("should be less or equal than 42", function()
	expect(42).toBeLessThanOrEqual(42)
end)
```

### Strings

#### `toMatch`

Use `toMatch` to check that a string matches a
[pattern](https://www.lua.org/manual/5.4/manual.html#6.4.1). Please consider,
that Lua's patterns differ from POSIX-compatible regular expressions.

```lua
it("should match substring", function()
	expect("Hello world").toMatch("world")
end)

it("should match float number", function()
	expect("-12.43256").toMatch("^-?%d+%.%d+$")
end)
```

#### `toContain`

Use`toContain` when there is a need to check that an item is in an array or string.

```lua
it("should have a cat in a table", function()
	expect({"cat", "dog", "panda"}).toContain("cat")
end)

it("should have a cat in a string", function()
	expect("Grey cat jumped out of window").toContain("cat")
end)
```

### Errors

#### `toFail`

Check that function failed due to execution. The expected value can be a `string`,
which is Lua [pattern](https://www.lua.org/manual/5.4/manual.html#6.4.1) that
matches the error message.

```lua
local errorFn = function()
	error("something went wrong")
end

it("should fail", function()
	expect(errorFn).toFail()
end)

it("should fail and match error pattern", function()
	expect(errorFn).toFail("wrong")
end)
```

### Spies

#### `toHaveBeenCalled`

`toHaveBeenCalled` ensures that a spy has been called any number of times.

```lua
local function eatCandy(callback)
	print("eat a candy")
	callback()
end

local spy = Spy:new()

it("should be called", function()
	eatCandy(spy)
	eatCandy(spy)
	expect(spy).toHaveBeenCalled()
end)
```

#### `toHaveBeenCalledOnce`

`toHaveBeenCalledOnce` ensures that a spy has been called only once.

```lua
it("should be called", function()
	eatCandy(spy)
	expect(spy).toHaveBeenCalled()
end)
```

#### `toHaveBeenCalledTimes`

`toHaveBeenCalledTimes` ensures that a spy has been called an exact number of times.

```lua
it("should be called 4 times", function()
	for _ = 1, 4 do
		eatCandy(spy)
	end
	expect(spy).toHaveBeenCalledTimes(4)
end)
```

#### `toHaveBeenCalledWith`

`toHaveBeenCalledWith` ensures that a spy has been called with a specific argument.
The arguments are checked with the logical equality `==`.

```lua
local spy = Spy:new()
local meals = { "soup", "meat", "dessert" }

local eat = function(meal, callback)
	print("Eating" .. " " .. meal)
	callback()
end

it("should be called with 'meat'", function()
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveBeenCalledWith("meat")
end)
```

#### `toHaveBeenFirstCalledWith`

`toHaveBeenFirstCalledWith` ensures that the first call of a spy has been
called with a specific argument. The arguments are checked with the logical equality `==`.

```lua
it("should be firstly called with 'soup'", function()
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveBeenFirstCalledWith("soup")
end)
```

#### `toHaveBeenLastCalledWith`

`toHaveBeenLastCalledWith` ensures that the last call of a spy has been called
with a specific argument. The arguments are checked with the logical equality `==`.

```lua
it("should be lastly called with 'dessert'", function()
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveBeenLastCalledWith("dessert")
end)
```

#### `toHaveBeenNthCalledWith`

`toHaveBeenNthCalledWith` ensures that the n-th call of a spy has been called with a specific argument. The arguments are checked with the logical equality `==`. As expected value, it accepts the table argument, where the first value is the position (index) of a call and the second is expected value.

```lua
it("should be secondly called with 'meat'", function()
	for _, meal in ipairs(meals) do
		spy(vmeal)
	end
	expect(spy).toHaveBeenNthCalledWith({ 2, "meat" })
end)
```

#### `toHaveReturned`

Test a spy that returned a non-`nil` value and did not throw any error at least one time.

```lua
it("should return a value", function()
	local spy = Spy:new(function(a)
		return a
	end)
	spy()
	expect(spy).toHaveReturned()
end)
```

#### `toHaveReturnedTimes`

Test a spy that returned a non-`nil` value and did not throw any error at least once.

```lua
local getMeal = function(i)
	return meals[i]
end

it("should return all meals", function()
	local spy = Spy:new(getMeal)
	for i in ipairs(meals) do
		spy(i)
	end
	expect(spy).toHaveReturnedTimes(3)
end)
```

#### `toHaveReturnedWith`

Test a spy that returned with a certain value and did not throw any error.

```lua
it("should be return with argument", function()
	local spy = Spy:new(function(a)
		return a
	end)
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveReturnedWith("meat")
end)
```

#### `toHaveFirstReturnedWith`

Test a spy's first return with a certain value and did not throw any error.

```lua
it("should be return with argument", function()
	local spy = Spy:new(function(a)
		return a
	end)
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveFirstReturnedWith("soup")
end)
```

#### `toHaveLastReturnedWith`

Test a spy's last return with a certain value and did not throw any error.

```lua
it("should be return with argument", function()
	local spy = Spy:new(function(a)
		return a
	end)
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveLastReturnedWith("dessert")
end)
```

#### `toHaveNthReturnedWith`

Test a spy's last return with a certain value and did not throw any
error.  Expected value is a table where the first value is an index.
(position) of the return, the second value is the expected value.

```lua
it("should be return with argument", function()
	local spy = Spy:new(function(a)
		return a
	end)
	for _, meal in ipairs(meals) do
		spy(meal)
	end
	expect(spy).toHaveNthReturnedWith({ 2, "meat" })
end)
```

## Negative matchers

Any matcher can be inverted with the prefix **not** and after following the same
camelCase convention. E.g., `toEqual` => `notToEqual`, `toBe` => `notToBe` and so on.

Consider:

```lua
it("should be 'hello'", function()
	expect("hello").toEqual("hello")
end)

it("should not be 'hello'", function()
	expect("hello").notToEqual("hi")
end)
```

## Spies (Mock Functions)

Spies are especially useful in unit tests where you want to isolate the
component or function being tested from its dependencies, ensuring
the test focuses on the behavior of the specific unit.


### Use cases and features of the Spies

- **Isolating Tests**: encapsulate unit that it will run independently
 from the rest environment.
- **Testing Side Effects**: ensure that function has returned
 certain value with certain arguments
- **Capture calls, arguments, and return values**: spy tracks how many
 times it is called, simulating arguments and return values as it
 would be real case.
- **Simulate Errors**: ensure that unit is not crashing the program,
 if there is an error. This is a very important case that makes function
 error-prone.

### Spy interface

#### Methods

There are public methods of the [Spy](https://github.com/dknight/laura/blob/main/src/laura/Spy.lua) class.

- **getCalls(): SpyCall[]**: return all calls;
- **getCall(n): SpyCall | nil**: returns the n-nth call, `nil` when it does not exist;
- **getLastCall(): SpyCall | nil**: returns the last call, `nil` when it does not exist;
- **getFirstCall(): SpyCall | nil**: returns the first call, `nil` when it does not exist;
- **getCallsCount(): number**: returns total amount of calls;
- **getReturns(): SpyReturn[]**: returns table of return values;
- **getReturn(n): SpyReturn | nil**: returns the n-th return value, `nil` when it does not exist;
- **getFirstReturn(): SpyReturn | nil**: returns the first return value, `nil` when it does not exist;
- **getLastReturn(): SpyReturn | nil**: returns the last return value, `nil` when it does not exist;
- **getReturnsCount(): number**: returns the total amount of return values, which are not `nil`.



### Types

Note: in the current version, types are just aliases to `table`, but later this
helps to extend the framework with a better typing system.

- `---@alias SpyArgs table`
- `---@alias SpyCall table`
- `---@alias SpyReturn table`

### Example of Spy

```lua
local describe = require("laura.Suite")
local it = require("laura.Test")
local expect = require("laura.expect")
local Spy = require("laura.Spy")

describe("testing spies", function()
	it("should be called once", function() 
		local spy = Spy:new()
		spy()
		expect(spy).toHaveBeenCalledOnce()
	end)

	it("should be called once", function() 
		local spy = Spy:new()
		spy("foo")
		expect(spy).toHaveBeenCalledWith("foo")
	end)
end)
```
## Hooks

Suite has hooks run functions, which help to setup some state after or before all test cases.

### afterAll

The hook runs once after all test cases in the suite. This is often useful if
there is a need to clean up some global setup state that is shared across tests.

```lua
local describe = require("laura.Suite")
local expect = require("laura.expect")
local it = require("laura.Test")
local hooks = require("laura.hooks")

-- abstract function of closing database
local function closeDatabase()
	print("Database closed")
end

describe("afterAll hook", function()
	hooks.afterAll(function()
		closeDatabase()
	end)
	
	it("should be true", function()
		expect(1 == 1).toBe(true)
	end)
	
	it("should be false", function()
		expect(1 == 2).toBe(true)
	end)
end)
```

In the example above, the `closeDatabase` hook ensures that the database connection is closed.
after all test cases finish.

### afterEach

The hook runs after every test case in the suite. This is often useful if you want to clean up some temporary state that is created by each test.

```lua
local describe = require("laura.Suite")
local expect = require("laura.expect")
local it = require("laura.Test")
local hooks = require("laura.hooks")

-- imaginative function to clean cache
local function clearCache(t)
	for i in pairs(t) do
		t[i] = nil
	end
end

describe("afterAll hook", function()
	local cacheTable = {}
	
	hooks.afterEach(function()
		clearCache(cacheTable)
	end)

	it("should be true", function()
		cacheTable[#cacheTable + 1] = "some data"
		expect(cacheTable).toHaveLength(1)
	end)

	it("should be false", function()
		cacheTable[#cacheTable + 1] = "some data"
		expect(cacheTable).toHaveLength(1)
	end)
end)
```

In the example above, the `clearCache` hook ensures that cache is being cleaned
before any test case starts.

### beforeAll

The hook runs once before any test case in the suite. This is often
useful if there is need to set a global setup state that is shared across tests.

```lua
local describe = require("laura.Suite")
local expect = require("laura.expect")
local it = require("laura.Test")
local hooks = require("laura.hooks")

-- abstract log function
local function log(msg)
	print(os.date() .. " " .. msg)
end

describe("beforeAll hook", function()
	hooks.beforeAll(function()
		log("Start testing, this message will be printed once.")
	end)

	it("should be true", function()
		expect(1 == 1).toBe(true)
	end)

	it("should be false", function()
		expect(1 == 2).toBe(true)
	end)
end)
```

In the example above, the `beforeAll` hook ensures that logging happens
only once before all tests start.

### beforeEach

The hook runs before every test case in the suite. This is often useful if
you want to set some temporary state that is created by each test.

```lua
local describe = require("laura.Suite")
local expect = require("laura.expect")
local it = require("laura.Test")
local hooks = require("laura.hooks")

describe("beforeEach hook", function()
	local spy = Spy:new()
	hooks.beforeEach(function()
		spy(function()
			print("hook is funning")
		end)
	end)
	it("should be true", function()
		expect(1 == 1).toBe(true)
	end)
	it("should be false", function()
		expect(1 == 4).toBe(false)
	end)
	it("should call spy 3 times", function()
		expect(spy).toHaveBeenCalledTimes(3)
	end)
end)
```

## Compatibility Notes

There was no UTF-8 support in Lua before 5.3; to add support for UTF8, please
install [an extra UTF-8 module](https://github.com/starwing/luautf8),if you are
going to compare UTF-8 strings.

## Who is Laura? And how to meet her?

Initially, the project name was _"aura"_, while most of the packages
in Lua ecosystem are prefixed with _"L"_, aura just became _"Laura"_.
There is no any real girl with the name Laura who is associated with
this framework.

<!-- After that, another person proposed to use his created girl-anime like
mascot to make this library more memorable, rather than yet another,
testing library. Actually a pure marketing-like move. -->

TODO IMAGE HERE

[Source code on GitHub](https://github.com/dknight/laura/)

## Contribution

Any help is appreciated. Found a bug, typo, inaccuracy, etc.? Please do
not hesitate to create [a pull request](https://github.com/dknight/laura/pulls) or submit an [issue](https://github.com/dknight/laura/issues).

*[TDD]: Test Driven Development
*[BDD]: Behaviour Driven Development