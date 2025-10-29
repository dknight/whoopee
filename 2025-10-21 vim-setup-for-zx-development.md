<!-- Description: The article explains how to prepare NeoVim for writing and building programs for the ZX Spectrum. With the right setup, NeoVim can be easily turned into a small but powerful development environment for both ZX BASIC. -->

tags: zx vim

# Setup NeoVim for BASIC ZX Spectrum development

Definitely, typing on the original ZX Spectrum keyboard gives a
romantic retro charm. That’s not arguable. But if you want to speed
up development, testing, and overall DX, it makes sense to use
modern environments like today’s text editors and operating systems.
Here’s my humble attempt to set up NeoVim and terminal for a simple 
workflow with minimal effort. With this setup, you can enjoy the spirit of the
1980s while using the comfort of modern development tools.

## Requirements

We will need three things.

1. [NeoVim](https://neovim.io/) -- it can usually be installed with your package manager, such as `dnf`, `apt`, `apk`, etc.  
2. Emulator -- nowadays, there are plenty of ZX Spectrum emulators.  
   Here I use [fbzx](https://gitlab.com/rastersoft/fbzx), simply
   because it’s free and released under the GPL license.  
3. BASIC to `.TAP` file compiler -- I use the simplest one I
    could find on the web:
    [zmakebas](https://github.com/z00m128/zmakebas). It’s very easy to build using:
   ```bash
   make
   make install
   ```
   This software has no external dependencies, only the standard C library.

## Workflow Overview

The idea is stupid simple:

- Write your BASIC program in NeoVim.
- Convert it into a `.TAP` file using `zmakebas` with a shortcut.
- Run the generated `.TAP` in fbzx emulator.

## Configuration

If you struggle with setup NeoVim there are plenty resources on the web how to do this,
or check [my setup NeoVim IDE](https://www.whoop.ee/post/turn-neovim-nto-lua-ide.html).

### Compile zmakbase

You need any C compiler. On Linux it is straightforward,
[download the source code](https://github.com/z00m128/zmakebas) and run:

```bash
make
make install
```

### NeoVim setup

Set up BASIC syntax through NeoVim/Vim’s **autocommand** feature.
Add the snippet below to your `init.lua`, and you’re ready to go.

```lua
-- ZX emulator. Here I use fbzx; replace it if you different one.
local zxEmulator = "fbzx"

-- Command to run the zmakebas compiler.
local zmakebasCmd = "<cmd>!zmakebas -o %<.tap %"

-- Command to run the emulator. It may differ for other emulators;
-- adjust as needed.
local zxCmd = "<cmd>!" .. zxEmulator .. " %<.tap"

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "basic" },
	callback = function(args)
		-- In BASIC, we usually type line numbers manually.
		-- Set this to true if you want automatic line numbering,
      -- during compilation.
		vim.opt.number = false

		-- Map the F5 key to save and compile.
		vim.keymap.set(
			"n",
			"<f5>",
			"<cmd>w<cr>" .. zmakebasCmd .. "<cr>"
		)

		-- Map the F6 key to save, compile and run.
		vim.keymap.set(
			"n",
			"<f6>",
			zmakebasCmd .. "<cr>" .. zxCmd .. "<cr>"
		)
	end,
})
```


## Usage

- Open neovim `nvim test.bas`.
- Type <kbd>i</kbd> `10 PRINT "HELLO WORLD"`.
- Hit <kbd>F6</kbd>; NeoVim saves the file, compiles it to `.TAP` and run tape in emulator.

In emulator type `LOAD ""` and hit <kbd>F6</kbd>

That's all. Easy.