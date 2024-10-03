local notes = [[
WARNING: You might not want to use this source.
If you don't understand what this does, use ruff-lsp instead.
]]

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local code_to_severity = {
    E = h.diagnostics.severities["error"], -- pycodestyle errors
    W = h.diagnostics.severities["warning"], -- pycodestyle warnings
    F = h.diagnostics.severities["information"], -- pyflakes
    A = h.diagnostics.severities["information"], -- flake8-builtins
    B = h.diagnostics.severities["warning"], -- flake8-bugbear
    C = h.diagnostics.severities["warning"], -- flake8-comprehensions
    T = h.diagnostics.severities["information"], -- flake8-print
    U = h.diagnostics.severities["information"], -- pyupgrade
    D = h.diagnostics.severities["information"], -- pydocstyle
    M = h.diagnostics.severities["information"], -- Meta
}
local severity_default = h.diagnostics.severities["error"]

local function nested_entry_getter(key1, key2)
    return function(entries, line)
        return entries[key1][key2]
    end
end

local function ruff_severity(entries, line)
    local code = entries["code"]
    if code ~= nil then
        return code_to_severity[string.sub(code, 1, 1)] or severity_default
    end
    return severity_default
end

return h.make_builtin({
    name = "ruff",
    meta = {
        url = "https://github.com/astral-sh/ruff/",
        description = "An extremely fast Python linter, written in Rust.",
        notes = notes,
    },
    method = DIAGNOSTICS,
    filetypes = { "python" },
    generator_opts = {
        command = "ruff",
        args = {
            "check",
            "-n",
            "-e",
            "--output-format=json",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        format = "json",
        check_exit_code = function(code)
            return code == 0
        end,
        to_stdin = true,
        ignore_stderr = true,
        on_output = h.diagnostics.from_json({
            attributes = {
                _location = "location",
                _end_location = "end_location",
                code = "code",
            },
            adapters = {
                {
                    row = nested_entry_getter("_location", "row"),
                    col = nested_entry_getter("_location", "column"),
                    end_row = nested_entry_getter("_end_location", "row"),
                    end_col = nested_entry_getter("_end_location", "column"),
                    severity = ruff_severity,
                },
            },
        }),
    },
    factory = h.generator_factory,
})
