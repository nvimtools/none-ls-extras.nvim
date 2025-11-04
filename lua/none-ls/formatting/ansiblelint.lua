local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "ansiblelint",
    meta = {
        url = "https://ansible.readthedocs.io/projects/lint/rules/yaml/",
        description = "Ansible style formatting using ansible-lint --fix",
        notes = {
            "`ansible-lint --fix` writes changes to the file on disk, instead of sending changes to stdout.",
            "This is because stdout is already being used to report linting violations.",
            "Diagnostics are reported to stderr, so it can't use that either.",
            "Both are reported, even when Autofix (`--fix`) is activated.",
            "We use a temporary file to get around this.",
            "The temporary file is modified and is then read back into the buffer.",
        },
    },
    method = FORMATTING,
    filetypes = { "yaml.ansible" },
    generator_opts = {
        command = "ansible-lint",
        args = {
            "--fix",
            "$FILENAME",
        },
        to_stdin = false,
        format = "raw",
        to_temp_file = true,
        from_temp_file = true,
        check_exit_code = function(code)
            return code == 0 or code == 2
        end,
    },
    factory = h.formatter_factory,
})
