<!-- Description: StyLua is an amazing code formatter inspired by prettier. -->

tags: lua

# StyLua is an optimized code formatter for Lua

## Setup

I have discovered an amazing tool called StyLua for Lua's code formatting.
So you do not need to think about formatting anymore. It works like a
[prettier](https://prettier.io/) version of JavaScript or TypeScript,
but for Lua.

It is extremely easy to set up. StyLua can be installed using Rust's
[cargo](https://crates.io/crates/stylua) or
[npm](https://www.npmjs.com/package/@johnnymorganz/stylua). It depends on the
packaging tools you prefer; the responding commands are:

```sh
cargo install stylua
```

or

```sh
npm i -g @johnnymorganz/stylua
```

### NeoVim

In my init.lua for [neovim](https://neovim.io/), I just added plugin
[ckipp01/stylua-nvim](https://github.com/ckipp01/stylua-nvim) and

```lua
"ckipp01/stylua-nvim"
```

And `BufWritePre` hook to format on auto-save.

```lua
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
	callback = function()
	  -- more commands if needed
		vim.cmd([[silent! !stylua %]])
	end
})
```

My complete init.lua, which is constantly updated, can be checked
on [GitHub](<(https://github.com/dknight/dotfiles/blob/main/init.lua)>).

### VSCode

For VSCode, installation is even easier; StyLua extension is available on the
[marketplace](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua).
Just one click and install.

## Configuration

Currently, I am happy with the default settings, except for line width.
I prefer 80 or even 78-column width. Let's fix that.
[Several options](https://github.com/JohnnyMorganz/StyLua?tab=readme-ov-file#options)
can be adjusted. Let's `stylua.toml` somewhere on the system with the contents:

```toml
column_width = 78
```

Now we have 2 options:

### Set a flag `--config-path` in the `stylua` command

```lua
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
	callback = function()
		vim.cmd([[silent! --config-path={path-to-stylua.toml} !stylua %]])
	end
})
```

### Set in plugins options

Consider we use [lazy](https://github.com/folke/lazy.nvim) for NeoVim.

```lua
{
	"ckipp01/stylua-nvim",
	config_file="path-to-stylua.toml",
}
```

For VSCode it should everything much easier, all configurations should be
available in the extension settings.

## Conclusion

There is no need to think about code style while coding in Lua and
Concentrate on the tasks; the formatter does its job.
For more detailed and editors' integration guides
Check out [the official GitHub repo of StyLua](https://github.com/JohnnyMorganz/StyLua).
