<!-- Description: This demonstration showcases the process of testing a piece of code across six different versions of the Lua programming language. The goal is to ensure compatibility, identify potential issues, and observe any differences in behavior between versions. By running these tests, we can assess the code’s performance, stability, and necessary adjustments for seamless functionality across all Lua versions. -->

tags: lua

# Testing multiple Lua versions with Laura and GitHub Actions

![Laura avatar](/assets/img/laura-512.png)

Lua 5 has several major versions, each introducing changes that may cause incompatibilities. Code that works in Lua 5.3 may not function correctly in Lua 5.1 or may behave differently. This is a natural part of the language's evolution, with bug fixes, new features, and occasional removals. If you're developing a library, it's wise to test it across multiple Lua versions. GitHub Actions provides a nearly out-of-the-box solution for this task.

Here is the showcase of how to do this.

## Preparing files for the test

Let's create two files: one for the main code, placed in the src directory, and another for unit tests, located in the test directory. However, the specific directory structure is not mandatory. You change paths later in workflow file.

```lua
--src/mymath.lua
local mymath = {
    add = function(a, b)
        return a + b
    end,
    sub = function(a, b)
        return a - b
    end,
    mul = function(a, b)
        return a * b
    end,
    div = function(a, b)
        return a / b
    end,
}

return mymath
```

```lua
--src/mymath.test.lua
local laura = require("laura")
local mymath = require("src/mymath")

local describe = laura.describe
local it = laura.it
local expect = laura.expect

describe("my-math module", function()
    it("should add two number", function()
        expect(mymath.add(40, 2)).toEqual(42)
    end)
    it("should subtract two number", function()
        expect(mymath.sub(40, 2)).toEqual(38)
    end)
    it("should multiply  two number", function()
        expect(mymath.mul(40, 2)).toEqual(80)
    end)
    it("should divide two number", function()
        expect(mymath.div(40, 2)).toEqual(20)
    end)
    it("should divide by zero and get infinity", function()
        expect(mymath.div(40, 0)).notToBeFinite()
    end)
end)
```

So structure is very trivial:

```text
.
├── src
│   └── mymath.lua
└── test
    └── mymath.test.lua
```

## Setup GitHub Actions

Assumed that you have already created a GitHub repository; if not, here is the [guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository) on how to do this.

Inside your repository, choose actions from the top menu.

![GitHub Action location in the menu](/assets/img/lua-gh-actions-01.png)

Search for the Simple workflow and select it.

![GitHub Action Simple workflow](/assets/img/lua-gh-actions-02.png)

The GitHub code editor will be opened. Paste the configuration below into the editor.

```yaml
name: Tests
on: [push]
jobs:
  test:
    strategy:
      matrix:
        # Put here Lua versions to be tested
        luaVersion: ['5.1', '5.2', '5.3', '5.4', 'luajit-2.1', 'luajit-openresty']
    runs-on: ubuntu-latest
    env:
      TERM: xterm
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      # Lua and LuaRocks installation
      - uses: leafo/gh-actions-lua@v11
      - uses: leafo/gh-actions-luarocks@v4
        with:
          luaVersion: ${{ matrix.luaVersion }}
      - name: "install luacheck"
        run: luarocks install luacheck

      - name: "install laura"
        run: luarocks install laura

      # Here you change test directory, if is different.
      - name: test
        run: laura test/ 

      # Here you change source directory, if is different.
      - name: lint
        run: luacheck src/ test/
```

After press the button "Commit changes..." and set any commit message you like. The new directory with workflow configuration will be committed to the repository `.github/workflows/<action>.yml`.

![GitHub Actions commit changes button](/assets/img/lua-gh-actions-03.png)

So we are done, now on every push the code will be tested with versions specified in `jobs.test.strategy.matrix.luaVersions`,
check [working demo on GitHub](https://github.com/dknight/laura-actions-demo).

![GitHub Actions all builds are passed](/assets/img/lua-gh-actions-04.png)

## References

- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [Understanding GitHub Actions](https://docs.github.com/en/actions/about-github-actions/understanding-github-actions)