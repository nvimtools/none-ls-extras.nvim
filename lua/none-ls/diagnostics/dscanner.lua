local h = require("null-ls.helpers")
local u = require("null-ls.utils")

return h.make_builtin({
    name = "dscanner",
    meta = {
        url = "https://github.com/dlang-community/D-Scanner/",
        description = "D-Scanner is a tool for analyzing D source code",
    },
    method = require("null-ls.methods").internal.DIAGNOSTICS,
    filetypes = { "d" },
    generator_opts = {
        command = "dscanner",
        args = {
            "lint",
            "--errorFormat",
            "github",
        },
        cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern("dub.sdl", "dub.json")(params.bufname)
        end),
        from_stderr = true,
        multiple_files = true,
        format = "line",
        on_output = h.diagnostics.from_pattern(
            "::([^%s]*) file=(.*),line=(.*),endLine=(.*),col=(.*),endColumn=(.*),title=[^%s]* %((.*)%)::(.*)",
            { "severity", "filename", "row", "end_lnum", "col", "end_col", "code", "message" },
            {
                severities = {
                    error = h.diagnostics.severities["error"],
                    warning = h.diagnostics.severities["warning"],
                },
            }
        ),
        to_temp_file = false,
    },
})
