local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "jsonnetfmt",
    meta = {
        url = "https://github.com/google/go-jsonnet",
        description = "Format Jsonnet files using `jsonnetfmt`.",
    },
    method = FORMATTING,
    filetypes = { "jsonnet" },
    generator_opts = {
        command = "jsonnetfmt",
        args = { "-" },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
