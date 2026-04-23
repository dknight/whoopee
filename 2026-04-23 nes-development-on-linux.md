<!--Description: Simple guide on how to set up Linux for NES development. -->

tags: nes

# Linux for NES development

<div>
<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>
</div>
[TOC]

## Compiler: cc65

The easiest option is to use the [cc65 compiler](https://cc65.github.io/), which supports multiple 6502 variants, including the NES.

On Ubuntu:

```sh
sudo apt install cc65
```

On Fedora and other DNF-based distributions:

```sh
sudo dnf install cc65
```

This installs the libraries and binaries required for 6502 development.

## Vim / Neovim as an IDE

NES programming is essentially assembly programming for the [6502](https://en.wikipedia.org/wiki/MOS_Technology_6502) processor. By default, Vim and Neovim understand basic assembler syntax for `*.s` and `*.asm` files.

I developed and maintain the [nes.nvim](https://github.com/dknight/nes.nvim) plugin for Neovim. It works well with [lazy.nvim](https://www.lazyvim.org/) and provides features such as syntax highlighting, error detection, and quick build-and-run, out of the box. If you find bugs or other issues, please open an issue or submit a pull request.

That's it. For more tools, see the [NES toolbox page](/post/nes-toolbox.html).