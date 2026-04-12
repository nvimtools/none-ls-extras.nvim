local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local get_first_span = function(entry)
    return entry.labels and entry.labels[1] and entry.labels[1].span or {}
end

local handle_oxlint_output = function(params)
    local parser = h.diagnostics.from_json({
        attributes = {
            code = "code",
            severity = "severity",
        },
        severities = {
            warning = h.diagnostics.severities["warning"],
            error = h.diagnostics.severities["error"],
        },
    })
    local diagnostics = {}

    for _, entry in ipairs(params.output and params.output.diagnostics or {}) do
        local span = get_first_span(entry)

        table.insert(diagnostics, {
            message = entry.message,
            code = entry.code,
            severity = entry.severity,
            line = span.line,
            column = span.column,
            endLine = span.line,
            endColumn = span.column and span.length and span.column + span.length or span.column,
        })
    end

    return parser({ output = diagnostics })
end

return h.make_builtin({
    name = "oxlint",
    meta = {
        url = "https://oxc.rs/docs/guide/usage/linter.html",
        description = "A high-performance linter for the JavaScript ecosystem.",
        notes = {
            "Config discovery follows the [Oxlint configuration docs](https://oxc.rs/docs/guide/usage/linter/config.html), which document `.oxlintrc.json` and `.oxlintrc.jsonc`.",
        },
    },
    method = DIAGNOSTICS,
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
        command = "oxlint",
        args = { "-f", "json", "$FILENAME" },
        to_temp_file = true,
        format = "json",
        check_exit_code = function(code)
            return code <= 1
        end,
        on_output = handle_oxlint_output,
        cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern(".oxlintrc.json", ".oxlintrc.jsonc")(params.bufname)
        end),
    },
    factory = h.generator_factory,
})
