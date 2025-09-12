local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

return h.make_builtin({
    name = "mado",
    meta = {
        description = "A fast Markdown linter written in Rust.",
        url = "https://github.com/akiomik/mado",
    },
    method = DIAGNOSTICS,
    filetypes = { "markdown" },
    factory = h.generator_factory,
    generator_opts = {
        command = "mado",
        args = {
            "check",
        },
        to_stdin = true,
        from_stderr = false,
        format = "line",
        check_exit_code = function(code)
            return code <= 1
        end,
        on_output = h.diagnostics.from_patterns({
            {
                pattern = [[^([^:]+):(%d+):(%d+):%s+(MD%d+)%s+(.+)$]],
                groups = { "filename", "row", "col", "code", "message" },
                overrides = { diagnostics = { severity = 2, source = "mado" } },
            },
            {
                pattern = [[^([^:]+):(%d+):%s+(MD%d+)%s+(.+)$]],
                groups = { "filename", "row", "col", "code", "message" },
                overrides = { diagnostics = { severity = 2, source = "mado" } },
            },
        }),
    },
})
