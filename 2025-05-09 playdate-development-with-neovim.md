<!-- Description: Playate Development with NeoVim-->

tags: playdate vim gamedev

# Playate development with NeoVim

I’m not a big fan of bloated IDEs, so I prefer working in the terminal with NeoVim (or vim, or vi). I recently bought an amazing tiny gaming platform called [Playdate](https://play.date/), which comes with an excellent SDK and simulator.

To make development easier, I created a [bash script called `pd.sh`](https://github.com/dknight/pd.sh) that allows
you to run the Playdate Simulator directly from the terminal. Now, it's time to integrate it with NeoVim. In the
near future, I may rewrite this shell script as a complete NeoVim plugin. But for now, here’s my current setup.

If you haven't yet configured your NeoVim as a Lua IDE, check out [my blog post](/post/turn-neovim-nto-lua-ide.html) to learn how to do it easily.

## Preview

<video width="1078" height="808" controls>
	<source src="/assets/video/nvim-playdate.mp4" type="video/mp4">
	Your browser does not support the video tag.
</video>

## `pd.sh`

To install [`pd.sh`](https://github.com/dknight/pd.sh), follow the instructions in the project's
[README](https://github.com/dknight/pd.sh/blob/main/README.md). Basically, you just need to clone the
repository, run `make install`, and ensure that the `PLAYDATE_SDK_PATH` environment variable is set.

## `init.lua`

I defined some custom bridge commands in NeoVim’s `init.lua` file to run the Playdate Simulator directly from the editor.

This defines the following commands:

- `:PlaydateNew <dir>`
- `:PlaydateRun <dir >?`
- `:PlaydateBuild <dir>?`
- `:PlaydateStop <dir>?`
- `:PlaydateRestart <dir>?`

```lua
--init.lua

-------------------------------------------------------------------------------
-- Playdate
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("PlaydateNew", function(args)
	local projectName = args.fargs[1] or "."
	local command = table.concat({
			"terminal",
			"pd.sh",
			"new",
			projectName },
		" ")
	vim.cmd(command)
	vim.cmd("startinsert")
end, { nargs = 1 })

vim.api.nvim_create_user_command("PlaydateRun", function(args)
	local dir = args.fargs[1] or "."
	vim.system({ "pd.sh", "-d", dir, "run" })
end, { nargs = "?" })

local TerminalCommands = {
	build   = "Build",
	stop    = "Stop",
	restart = "Restart",
}
for cmd, capitalized in pairs(TerminalCommands) do
	vim.api.nvim_create_user_command("Playdate" .. capitalized, function(args)
		local dir = args.fargs[1] or "."
		local command = table.concat({
				"terminal",
				"pd.sh",
				"-d",
				dir,
				cmd },
			" ")
		vim.cmd(command)
		vim.cmd("startinsert")
	end, { nargs = "?" })
end
```

## Keybindings

We can go further and define keybindings for these commands, such as <kbd>F7</kbd> for `:PlaydateBuild` and
<kbd>F8</kbd> for `:PlaydateRestart`. Feel free to add your own key mappings to suit your workflow.

```lua
--init.lua

vim.keymap.set({ "i", "n", "v" }, "<F7>", "<cmd>PlaydateBuild<cr>")
vim.keymap.set({ "i", "n", "v" }, "<F8>", "<cmd>PlaydateRestart<cr>")
```