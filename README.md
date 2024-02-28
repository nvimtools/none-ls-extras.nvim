# none-ls-extras.nvim

Extra sources for
[nvimtools/none-ls.nvim](https://github.com/nvimtools/none-ls.nvim).

## Usage

```lua
require("null-ls").setup {
    sources = {
        require("none-ls.diagnostics.cpplint"),
        require("none-ls.formatting.jq"),
        require("none-ls.code_actions.eslint"),
    }
}
```
