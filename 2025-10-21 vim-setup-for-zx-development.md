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

## Bonus. Simple line auto-increment

Very dirty BASIC line auto-increment, should be enough for the beginning.
Works for <kbd>Enter</kbd> in insert mode and <kbd>o</kbd> in normal mode.

```lua
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "basic" },
	callback = function(_)
		-- Auto increment line numbers
		local autoincrement = function(opts)
			local newline = opts.newline or false
			local line = vim.api.nvim_get_current_line()
			local num = line:match("^%s*(%d+)")
			if not num then
				return "\n"
			end

			local prev = tonumber(num)
			local step = 10

			return string.format(
				"%s\n%04d",
				newline and "\n" or "",
				prev + step
			)
		end
		vim.keymap.set(
			"i", "<CR>",
			function()
				return autoincrement({ newline = false })
			end,
			{ buffer = true, expr = true }
		)
		vim.keymap.set("n", "o", function()
			local text = autoincrement({ newline = true })
			local lines = {}
			for line in text:gmatch("([^\n]*)\n?") do
				if line ~= "" then table.insert(lines, line) end
			end
			vim.api.nvim_put(lines, "l", true, true)
			vim.cmd("startinsert!")
			end,{ noremap = true })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*.bas",
	callback = function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^(%d+)%s*", "%1\t")
		end
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end,
})
```

## Bonus 2. Re-number BASIC lines

***Updated 24.01.2026***

```lua

-- Beginning of the file --

local function renumber_basic_lines()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local new_lines = {}
	local number = 10
	local step = 10

	for _, line in ipairs(lines) do
		if line:match("^%s*$") then
			table.insert(new_lines, line)
		else
			-- remove existing leading line numbers
			local stripped = line:gsub("^%s*%d+%s*", "")
			table.insert(new_lines, string.format("%04d %s", number, stripped))
			number = number + step
		end
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "basic" },
	callback = function(_)
		-- Auto increment line numbers
		--
		-- Same as above in Bonus 1 section.
		--
		vim.keymap.set(
			"n",
			"<leader>ln",
			renumber_basic_lines,
			{ buffer = true, desc = "Renumber BASIC lines" }
		)
	end
})
```

## Full config file

Get full config file [`zx.lua`](https://github.com/dknight/dotfiles/blob/main/zx.lua) from GitHUb.

## Usage

- Open neovim `nvim test.bas`.
- Type <kbd>i</kbd> `10 PRINT "HELLO WORLD"`.
- Hit <kbd>F6</kbd>; NeoVim saves the file, compiles it to `.TAP` and run tape in emulator.

In emulator type `LOAD ""` and hit <kbd>F6</kbd>

That's all. Easy.