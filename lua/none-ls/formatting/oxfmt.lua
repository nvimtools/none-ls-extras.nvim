local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "oxfmt",
    meta = {
        url = "https://github.com/web-infra-dev/oxc",
        description = "Tailwind CSS class sorter and formatter powered by Oxc.",
    },
    method = FORMATTING,
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
        "html",
        "css",
        "scss",
        "less",
    },
    factory = h.formatter_factory,
    generator_opts = {
        command = "oxfmt",
        args = { "$FILENAME" },
        to_temp_file = true,
        from_temp_file = true,
        timeout = 10000,
        cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern(".oxfmtrc.json")(params.bufname)
        end),
    },
})