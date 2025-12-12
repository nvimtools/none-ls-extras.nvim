local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "golangci_lint",
    meta = {
        url = "https://golangci-lint.run/",
        description = "Go formatter using `golangci-lint fmt` command.",
        notes = {
            "Requires golangci-lint v2.",
            "Formatters can be configured in the `formatters` section of `.golangci.yml`.",
        },
    },
    method = FORMATTING,
    filetypes = { "go" },
    generator_opts = {
        command = "golangci-lint",
        args = { "fmt", "--stdin" },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
