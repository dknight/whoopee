<!-- Description: Quitting Vim or Neo is very challenging to people open vim for the first time. -->

tags: beginner humor vim

# Hot to quit Vim and NeoVim

![Wolf from soviet cartoon "Nu, pogodi!" trapped in the brick room](/assets/img/how-to-quit-vim.jpg)

To exit Vim, first press <kbd>Esc</kbd> to enter Normal mode. Next, try next commands:

- `:q` — Quit (short for `:quit`);
- `:q!` — Quit without saving changes (short for `:quit!`);
- `:wq` — Save and quit;
- `:wq!` — Save and quit, forcing the write if the file lacks write permissions;
- `:x` — Save and quit (like `:wq`, but only writes if changes were made, short for `:exit`);
- `:qa` — Quit all open windows (short for `:quitall`);
- `:cq` — Quit without saving, returning a nonzero exit code to indicate failure (short for `:cquit`).

After typing the command, press <kbd>Enter</kbd>.

## Alternative shortcuts to quit Vim

- `ZZ` — Save the current file (if modified) and close the current window. If multiple windows display the same file, only the current window is closed.
- `ZQ` — Quit without saving changes (same as `:q!`).
