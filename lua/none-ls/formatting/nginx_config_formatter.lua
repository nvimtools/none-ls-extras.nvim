local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "nginx-config-formatter",
    meta = {
        url = "https://github.com/slomkowski/nginx-config-formatter",
        description = "nginx config file formatter/beautifier written in Python with no additional dependencies.",
    },
    method = FORMATTING,
    filetypes = { "nginx" },
    generator_opts = {
        command = "nginxfmt",
        args = { "--pipe" },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
