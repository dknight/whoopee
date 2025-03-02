<!-- Description: A comprehensive step-by-step guide on transforming Neovim into a fully functional Integrated Development Environment (IDE) specifically tailored for Lua development-->

tags: lua

# Turn NeoVim into Lua IDE

<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>

[TOC]

NeoVim is a modern, Vim-based text editor with limitless customization possibilities. It is relatively lightweight and
compatible with Vim, which has been beloved by IT professionals for decades. I would show how easy it is to set it up
as IDE for Lua language.

## Step 1. Installation

First of all, let's install NeoVim. You can find [a detailed guide.](https://github.com/neovim/neovim/blob/master/INSTALL.md)
for your operating system.

### Prerequisites for plugins

- Required [Rust language compiler](https://www.rust-lang.org/tools/install);
- Or instead of Rust, you can use `npm` shipped with [Node.js®](https://nodejs.org/en/download).

I would recommend using Node because you also might need it later for other plugins. But this is completely up to you.

## Step 2. Detect Configuration Paths

The next step is to determine where NeoVim configuration files are stored. On Unix-like systems, they are usually stored in the `$XDG_CONFIG_HOME` environment variable.

To find your current configuration directory, run the following command inside Vim: `:echo stdpath('config')`. This will print the current configuration directory.

Usually, these are:

| OS       | Config Directory   | NeoVim Config Directory  |  
|----------|--------------------|--------------------------|  
| Unix     | ~/.config          | ~/.config/nvim           |  
| Windows  | ~/AppData/Local    | ~/AppData/Local/nvim     |  

Read more about standard paths in the [NeoVim documentation](https://neovim.io/doc/user/starting.html#_standard-paths).

## Step 3. Creating `init.lua` file

Let's start with an empty `init.lua` file in the config directory. Let's confisued we are on Linux and full path will be `~/.config/nvim/init.lua`.

```lua
--init.lua
```

## Step 4. Installing Lazy plugin manager

NeoVim has an amazing plugin manager called [Lazy](https://github.com/folke/lazy.nvim), which is easy to install and use. You can follow the [official installation guide](https://lazy.folke.io/installation), but this article covers the same approach.

After installation, paste the following code into an `init.vim` file:

```lua
--init.lua

-- Lazy setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
local plugins = require("config.plugins")
require("lazy").setup(plugins, {
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
```

This is the initial setup for Lazy, and after you run NeoVim, the Lazy Plugin Manager will install automatically.

Next, let's create a `plugins` table that we will need in `init.lua`. Create an empty table—we will need it later.

```lua
--init.lua

-- Lazy setup (code truncated) --

-- Plugins list
local plugins = {}

-- Setup lazy.nvim (code truncated) --
```

If you try to run **nvim** now, you will most likely get an error like:

```text
Error detected while processing ~/.config/nvim/init.lua: 
No specs found for module "plugins" 
Press ENTER or type command to continue 
```

**Do not panic!** This is normal because we have not yet installed any plugins. To check if Lazy is installed correctly, type `:Lazy` and hit <kbd>Enter</kbd>.

If you see a screen similar to this:

![NeoVim Lazy interface](/assets/img/neovim-lazy-start-screen.png)

!!! tip
	To quit the Lazy screen, press the <kbd>q</kbd> key.

As you can see, the menu is quite straightforward:

> - **Install (I)**: <kbd>Shift</kbd>+<kbd>i</kbd>
> - **Update (U)**: <kbd>Shift</kbd>+<kbd>u</kbd>
> - **Help (?)**: <kbd>?</kbd>
> - And so on; ask help with command `:Lazy help`.

Alternatively, you can run the same commands inside the NeoVim command line: `:Lazy install`, `:Lazy update`, `:Lazy help`, etc.

!!! tip
	It is recommended to run `:checkhealth lazy` after installation. Try to tix errors and warnings if they are reported.

!!! warning
	After running Lazy plugin manager commands, a `lazy-lock.json` file will be automatically created
	in the configuration directory. **Do not modify this file**, as it is updated and generated automatically,
	storing required metadata about plugins.

## Step 5: Installing StyLua

[StyLua](https://github.com/JohnnyMorganz/StyLua) is an opinionated code formatter for Lua.

To install it on your platform, there are three ways (return to [step 1](#prerequisites-for-plugins):

1. Use [Rust](https://www.rust-lang.org/): `cargo install stylua`
2. Use [NPM](https://www.npmjs.com/) with Node.js®: `npm i -g @johnnymorganz/stylua-bin`
3. Compile it yourself from the [source code](https://github.com/JohnnyMorganz/StyLua)

Choose whichever method you prefer.

StyLua allows you to set up custom rules to fit your needs. Read the official documentation on [configuration](/post/stylua-opinionated-code-formatter-for-lua.html) for more details.

If you want to configure StyLua per project, you can create a `.stylua.toml` file in the project root or check out [my article dedicated to Stylua](/post/stylua-opinionated-code-formatter-for-lua.html).

Another useful feature is auto-formatting files upon saving. For this purpose, we can create an *autocommand* in NeoVim. Edit your `init.lua` as follows:

```lua
-- init.lua

-- Lazy setup (code truncated)
-- Plugins list (code truncated)
-- Setup lazy.nvim (code truncated)

-- Autocommands
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.lua" },
    callback = function()
        local stylua_cmd = "silent! !stylua %"
        vim.cmd([[silent! %s/\s\+$//e]])
        vim.cmd(stylua_cmd)
    end,
})
```

## Step 6: Installing Language Server Protocol (LSP)

The Lua Language Server enhances Lua development by offering a range of features that streamline and accelerate the coding process. It includes [annotations and typing systems](https://luals.github.io/wiki/annotations/), autocompletion, linting, and many other useful features.

There are two ways to install LSP: compile it yourself or download a prebuilt binary for your platform. Compilation is out of scope for this article. If you are interested in the compilation process, check out the [official LSP documentation](https://luals.github.io/wiki/).

Here, we will use precompiled binaries. Download the [latest release for your platform](https://github.com/LuaLS/lua-language-server/releases), and unzip it into a directory such as `~/.config/lua-lsp`.

> If you used a path other than `~/.config/lua-lsp` , change it accordingly.

Next we need to tell OS where to install LSP; for this we need to add the LSP binary to the `$PATH` environment variable.  For Unix-like systems, add it to your `.bashrc`.

```shell
echo 'export PATH="$HOME/.config/lua-lsp/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
exec $SHELL 
```

!!! tip
	Maybe your shell is other than **bash**. For example, in macOS, by default, it is **zsh**, so settings are in `.zshrc`.
	Shell configuration depends on your platform and shell you use; possible files in your home directory are: `.bashrc` ,
	`.bash_profile`, `.zshrc`, `.zsh_profile` etc.

    Type the command in terminal `printenv SHELL` to get your current shell.

Next, add [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) plugin to our `plugins` table. Which we have already created in [Step 4](#step-4-installing-lazy-plugin-manager).

```lua
--init.lua

-- Lazy setup (code truncated)

-- Plugins list
local plugins = {
	"neovim/nvim-lspconfig"
}

-- Setup lazy.nvim (code truncated)
-- Autocommands (code truncated)
```

Now we need to initialize the LSP setup; this also should be done in init.lua a file. Just append these lines:

```lua
--init.lua

-- Lazy setup (code truncated)
-- Plugins list (code truncated)
-- Setup lazy.nvim (code truncated)
-- Autocommands (code truncated)

-- Setup LSP
require("lspconfig").lua_ls.setup({
	-- LSP can have lots of configurations.
	-- Check out possibilities at official docs https://luals.github.io/wiki/configuration/
})
```

You can use the [embedded code formatter](https://luals.github.io/wiki/formatter/) provided by LSP, but I prefer to use  StyLua. To use it or not is up to you.

Watch the demo of the LSP in action; notice that after `table.` <kbd>Ctrl</kbd>+<kbd>x</kbd>+<kbd>o</kbd>.

![Demonstration of NeoVim and Lua Language Server Protocol in action](/assets/img/nvim-recording.gif)

## Step 7. Useful options

NeoVim and Vim have a huge amount of preferences. Type `:h options` in NeoVim command line to read documentation about options.

I would recommend using this setup, but you can change what you want.  Lazy recommends setting up options before you initialize. Lazy

> Make sure to setup `mapleader` and `maplocalleader` before
> loading lazy.nvim so that mappings are correct.
> This is also a good place to setup other settings (vim.opt)

```lua
--init.lua

-- Lazy setup (code truncated)
-- Plugins list (code truncated)

-- Options
vim.g.mapleader = ","
vim.opt.exrc = false
vim.opt.secure = true
vim.opt.number = true
vim.opt.mouse = ""
vim.opt.spelllang = "en_us"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.clipboard = "unnamed"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true
vim.opt.rulerformat = "%l,%v"
vim.opt.colorcolumn = "75,79"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME") .. "/.undodir"
vim.opt.lazyredraw = false
vim.opt.textwidth = 78
vim.opt.endoffile = true

-- Setup lazy.nvim (code truncated)
-- Setup LSP (code truncated)
```

That is all. This is a bare minimum to make your NeoVim as a Lua IDE. Next steps are optional.

## Step 8. Run current buffer with Lua code in single key

Usually I use <kbd>F5</kbd> key to run the file, but you can map it to any other key or sequence. To achieve this, add a key map in the *autocommand* section.

```lua
--init.lua

-- Lazy setup (code truncated)
-- Plugins list (code truncated)
-- Setup lazy.nvim (code truncated)
-- Autocommands (code truncated)

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "lua" },
    callback = function()
        vim.keymap.set("n", "<f5>", "<cmd>w<cr><cmd>!lua %<cr>")
    end,
})

-- Setup LSP (code truncated)
```

In the same manner, you can use <kbd>F6</kbd> for the debugger or something else.

## Step 9 (Optional): Very Useful Plugins

Some plugins might make your life even happier with NeoVim.

- [tpope/vim-commentary](https://github.com/tpope/vim-commentary): A very useful plugin to comment/uncomment with the <kbd>gcc</kbd> keystroke.
- [tpope/vim-repeat](https://github.com/tpope/vim-repeat): If you've ever tried using the `.` command after a plugin mapping, you were likely disappointed to discover it only repeated the last native command inside that mapping, rather than the mapping as a whole.
- [tpope/vim-surround](https://github.com/tpope/vim-surround): This plugin is all about "surroundings": parentheses,  
  brackets, quotes, XML/HTML tags, and more. It provides mappings to easily delete, change, and add such surroundings  
  in pairs.
- [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline): A cool custom status line.
- [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes): A large set of themes for vim-airline.
- [ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): Allows opening files with <kbd>Ctrl</kbd>+<kbd>p</kbd> keystrokes. I also recommend setting wildcards to ignore files, like: `vim.g.wildignore = "*/node_modules/*,*.so,*.swp,*.zip,*.git,*.o,*.a,"`
- [jiangmiao/auto-pairs](https://github.com/jiangmiao/auto-pairs): Automatically completes closing pairs: `"`, `'`, `(`, `[`, `{`, etc.
- [neoclide/coc.nvim](https://github.com/neoclide/coc.nvim): Amazing autocompletion on the fly. You do not need to press <kbd>Ctrl</kbd>+<kbd>x</kbd>+<kbd>o</kbd> to get context suggestions. It might be tricky to install, but it is really worth it.  
  **Tip:** Try this if you are on Linux: `cd ~/.local/share/nvim/lazy/coc.nvim/ && npm ci` or `:CocInstall`.
  Run `:CocConfig` to create `coc-settings.json` and [configure JSON](https://luals.github.io/wiki/configuration/#using-cocnvim) as you wish, for the reference check my [`coc-settings.json`](https://github.com/dknight/dotfiles/blob/main/coc-settings.json) as example.
- [flazz/vim-colorschemes](https://github.com/flazz/vim-colorschemes): A large collection of color schemes for NeoVim. Use the `:color <tab>` command to find your favorite color scheme.
- [nelstrom/vim-visual-star-search](https://github.com/nelstrom/vim-visual-star-search): Allows searching words with <kbd>*</kbd> in visual mode.

List of full plugins in the table:

```lua

--init.lua

-- Lazy setup (code truncated)

-- Plugins list
local plugins = {
	"neovim/nvim-lspconfig",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"vim-airline/vim-airline",
	"vim-airline/vim-airline-themes",
	"ctrlpvim/ctrlp.vim",
	"jiangmiao/auto-pairs",
	"nelstrom/vim-visual-star-search",
	"dhruvasagar/vim-table-mode",
	"flazz/vim-colorschemes",
	"neoclide/coc.nvim",
}
-- Setup lazy.nvim (code truncated)
-- Autocommands (code truncated)
-- Setup LSP (code truncated)
```

## Step 10 (Optional). <kbd>jk</kbd> ninja trick

In NeoVim and Vim, by default, the key <kbd>Esc</kbd> is the default key to return to normal mode. The problem is that <kbd>Esc</kbd> key is too far from your main fingers. There is a ninja trick to map <kbd>jk</kbd> act as <kbd>Esc</kbd>. These small improvements greatly speed up coding.

```lua
--init.lua

-- Lazy setup (code truncated)

-- Custom key mappings
vim.keymap.set("i", "jk", "<Esc>")

-- Plugins list (code truncated)
-- Setup lazy.nvim (code truncated)
-- Autocommands (code truncated)
-- Setup LSP (code truncated)
```

Download complete [`init.lua`](/assets/docs/init.lua.txt) file.

## More Tips to Become a Vim/NeoVim Master

- From time to time, review your configuration and adjust it to fit your needs.
- Train your fingers daily to build muscle memory for keystrokes and learn new shortcuts.
- In the beginning, you might be slow with Vim/NeoVim. **Do not give up**; it takes time to understand the wisdom of the masters.
- Read the book [Practical Vim](https://pragprog.com/titles/dnvim2/practical-vim-second-edition/).
- Use `:h <topic>` the command to learn and get help;
- There are limitless possibilities to customize NeoVim to match your needs and habits.
- If you're struggling, you can check my [`init.lua`](https://github.com/dknight/dotfiles/blob/main/init.lua) as a starting
 point for your setup or inspiration.

That's all! Happy Vim-ing!

*[LSP]: Language Server Protocol
*[IDE]: Integrated Development Environment
*[OS]: Operating System
*[IT]: Information Technology