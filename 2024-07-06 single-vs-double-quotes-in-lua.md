<!-- Description: There is no technical difference between single and double quotes in strings in Lua language. Just choose the style of quotes that you like and use it.-->

tags: lua

# Single vs double quotes in Lua

There is no difference in Lua language for quotes. You can use single
or double quotes but try to be persistent within a codebase. Preferable to use
double quotes because the single quote (`'` apostrophe) is much more often
used inside the text than a double quote `"`. So no need to escape the
sequence with `\` backslash.
[Roblox Lua Style Guide](https://roblox.github.io/lua-style-guide/) and
[StyLua](/post/stylua-opinionated-code-formatter-for-lua.html) also recommend
using double quotes.

Consider:

```lua
"5 o'clock" --- no need escape sequence
'Read "1984" book' -- double quotes inside single
"Read \"1984\" book" -- double quotes double single (escaped)
```

Another way to define string is to use blocks, in this case, no escape
sequences are needed at all.

Consider:

```lua
[[ Start reading "1984" book as 5 o'clock ]]
```

## Conclusion
Usually, code-style related discussions are a source of different holywars,
provoked by purists and pedantists. This problem is always artificially created
like this is a main problem in programming. Just choose the style of quotes
that you like and use it.
