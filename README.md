# none-ls-extras.nvim

Extra sources for
[nvimtools/none-ls.nvim](https://github.com/nvimtools/none-ls.nvim).

## 📦 Installation

This should be used as a dependency of **none-ls.nvim**.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  }
```

### [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim)

```vim
:Rocks install none-ls-extras.nvim scm
```

Installing this plugin with rocks.nvim will automatically install none-ls.nvim
if not already installed.

## Setup

Follow the steps in null-ls
[setup](https://github.com/nvimtools/none-ls.nvim?tab=readme-ov-file#setup)
section.

```lua
local null_ls = require("null-ls")

null_ls.setup {
    sources = {
        require("none-ls.diagnostics.cpplint"),
        require("none-ls.formatting.jq"),
        require("none-ls.code_actions.eslint"),
        ...
    }
}
```

Use `require("none-ls.METHOD.TOOL")` instead of `null_ls.builtins.METHOD.TOOL`
to use these extras.

## Related projects

You can search for sources via the
[`none-ls-sources` topic](https://github.com/topics/none-ls-sources).

- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)
- [none-ls-php.nvim](https://github.com/gbprod/none-ls-php.nvim)
- [none-ls-shellcheck.nvim](https://github.com/gbprod/none-ls-shellcheck.nvim)
- [none-ls-luacheck.nvim](https://github.com/gbprod/none-ls-luacheck.nvim)
- [none-ls-psalm.nvim](https://github.com/gbprod/none-ls-psalm.nvim)
- [none-ls-ecs.nvim](https://github.com/gbprod/none-ls-ecs.nvim)
