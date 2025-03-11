<!-- Description: Explanation of the typing system in the Lua language provided by Lua Language Server Annotations. Learn how to annotate types for your projects and functions. -->

tags: lua

# Strictly typed Luas

First of all, Lua is a dynamically typed language. This means that variables do not have types; **only values do**. All values in Lua are first-class citizens, which means that all values can be stored in variables and passed to functions as arguments. So the heading of this article is not so true. Sometimes it is needed to keep track of types, especially in larger projects.

The [Lua Language Server (LSP)](https://luals.github.io/) provides [annotations](https://luals.github.io/wiki/annotations/) (triple-dash comments `---`) to help define and manage the typing system in the Lua language. These annotations allow developers to specify and enforce types within their projects, improving code readability, maintainability, and reducing potential runtime errors. By using these type annotations, you can create structured type definitions for your project, as well as for individual functions, ensuring consistency and clarity throughout the codebase.

The LSP does not perform type checking at runtime; instead, it is designed solely to enhance the developer experience (DX) within supported code editors. It provides annotations that help document and define types, improving code navigation, autocompletion, and error detection during development.

If you're familiar with [TypeScript](https://www.typescriptlang.org/), Lua annotations work very similarly, but simpler.

Consider:

```lua
---@class (exact) User
---@field name string
---@field password string
---@field age number
---@field hobbies string[]

---Creates a new user
---@param name string
---@param password string
---@param age number
---@param hobbies? string[]
---@return User
local function createUser(name, password, age, hobbies)
    hobbies = hobbies or {}
    return {
        name = name,
        password = password,
        age = age,
        hobbies = hobbies
    }
end

local user = createUser("Bill", "secret", 25, {"horses", "cars"})
user.age = 33
print(user)
```

By adding simple type annotations as comments in your Lua code, you can greatly enhance the developer experience (DX) in your code editor. These annotations enable features like improved type checking, better code completion, and easier refactoring, making development more efficient and error-free.

Since the Lua Language Server (LSP) operates within your editor rather than at runtime, it helps with static analysis, guiding you while writing code without affecting execution. Installing the LSP is straightforward—whether you're using [install for NeoVim](/post/turn-neovim-nto-lua-ide.html), or [VS Code](https://marketplace.visualstudio.com/items?itemName=sumneko.lua), you can quickly set it up to take advantage of these benefits.

Demo in NeoVim:

![Demonstration of Lua Annotation in NeoVim](/assets/img/lua-lsp-annotations.gif)

## When Might You Need Type Annotations?

1. You are developing a large-scale project—later, it will be much easier to debug and catch potential problems during the coding phase.
2. You are working in a team with people of varying skill levels.

## When might you not need annotations?

1. Prototyping—if you need to create a prototype or proof of concept.
2. The project is very small.
3. You are working on the project alone and fully understand your code.

## Some Tips

1. Avoid using the any type whenever possible, as it any effectively disables type checking.
2. Make it a habit to always add annotations, at least for function arguments, using [@param](https://luals.github.io/wiki/annotations/#param) and [@return](https://luals.github.io/wiki/annotations/#return). This is a valuable investment in your project.
3. Read and learn from the [documentation](https://luals.github.io/wiki/annotations/) to improve your understanding of Lua type annotations.

*[LSP]: Language Server Protocol
*[DX]: Developer Experience

## References

- [Lua Language Server Documentation](https://luals.github.io/wiki/)
- [Emmy annotations](hhttps://emmylua.github.io/annotation.html)