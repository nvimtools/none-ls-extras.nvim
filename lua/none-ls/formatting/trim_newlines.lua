-- You probably want to use the builtin EditorConfig support instead of this.
-- Other alternative solutions: https://github.com/nvimtools/none-ls.nvim/discussions/81#discussioncomment-8674427

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "trim_newlines",
    meta = {
        description = "A simple wrapper around `awk` to remove trailing newlines.",
    },
    method = FORMATTING,
    filetypes = {},
    generator_opts = {
        command = "awk",
        args = { 'NF{print s $0; s=""; next} {s=s ORS}' },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
