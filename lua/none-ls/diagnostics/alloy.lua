local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS_ON_SAVE = methods.internal.DIAGNOSTICS_ON_SAVE

return h.make_builtin({
    name = "alloy_validate",
    meta = {
        url = "https://grafana.com/docs/alloy/latest/reference/cli/validate/",
        description = "Validate Grafana Alloy configuration files using `alloy validate`.",
    },
    method = DIAGNOSTICS_ON_SAVE,
    filetypes = { "alloy" },
    generator_opts = {
        command = "alloy",
        args = { "validate", "$FILENAME" },
        from_stderr = true,
        format = "line",
        on_output = h.diagnostics.from_patterns({
            {
                -- Matches: Error: /path/to/file.alloy:10:5: message
                pattern = [[^(%w+):%s+(.-):(%d+):(%d+):%s+(.*)$]],
                groups = { "severity", "filename", "row", "col", "message" },
                overrides = {
                    severities = {
                        ["Error"] = h.diagnostics.severities.error,
                        ["Warning"] = h.diagnostics.severities.warning,
                    },
                },
            },
        }),
    },
    factory = h.generator_factory,
})
