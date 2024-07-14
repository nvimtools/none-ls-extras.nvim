local notes = [[
WARNING: You might not want to use this source.
If you don't understand what this does, use ruff-lsp instead.
]]

local methods = require("null-ls.methods")
local h = require("null-ls.helpers")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "ruff",
    meta = {
        url = "https://github.com/astral-sh/ruff/",
        description = "An extremely fast Python linter, written in Rust.",
        notes = notes,
    },
    method = FORMATTING,
    filetypes = { "python" },
    generator_opts = {
        command = "ruff",
        args = {
            "check",
            "--fix",
            "-n",
            "-e",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
