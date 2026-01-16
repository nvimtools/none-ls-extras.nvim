local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "hongdown",
    meta = {
        url = "https://github.com/dahlia/hongdown",
        description = "A Markdown formatter that enforces Hong Minhee's Markdown style conventions",
    },
    method = FORMATTING,
    filetypes = { "markdown" },
    generator_opts = {
        command = "hongdown",
        args = { "--stdin" },
        to_stdin = true,
        format = "raw",
    },
    factory = h.formatter_factory,
})
