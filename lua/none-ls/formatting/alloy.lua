local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "alloy_fmt",
    meta = {
        url = "https://grafana.com/docs/alloy/latest/reference/cli/fmt/",
        description = "Format Grafana Alloy configuration files using `alloy fmt`.",
    },
    method = FORMATTING,
    filetypes = { "alloy" },
    generator_opts = {
        command = "alloy",
        args = { "fmt" },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
