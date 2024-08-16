local h = require("null-ls.helpers")
local u = require("null-ls.utils")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

-- eslint_d has a --fix-to-stdout flag, so we can avoid parsing json

return h.make_builtin({
    name = "eslint_d",
    meta = {
        url = "https://github.com/mantoni/eslint_d.js/",
        description = "Like ESLint, but faster.",
        notes = {
            "Once spawned, the server will continue to run in the background. This is normal and not related to null-ls. You can stop it by running `eslint_d stop` from the command line.",
        },
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
    },
    generator_opts = {
        command = "eslint_d",
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        to_stdin = true,
        cwd = h.cache.by_bufnr(function(params)
            return u.cosmiconfig("eslint", "eslintConfig")(params.bufname)
        end),
        on_output = function(params, done)
            done({ { text = params.output } })
        end
    },
    factory = h.formatter_factory,
})
