local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "ansiblelint",
    meta = {
        url = "https://ansible.readthedocs.io/projects/lint/autofix/",
        description = "Ansible style formatting using ansible-lint --fix",
        notes = {
            "Ansible-lint autofix provides autofixing capabilities for issues identified by ansible-lint via the ansible-lint --fix option. This command can automatically reformat YAML files and apply transforms for specific rules to fix or simplify identified issues.",
        },
    },
    method = FORMATTING,
    filetypes = { "yaml.ansible" },
    generator_opts = {
        command = "ansible-lint",
        args = { "--fix" },
        check_exit_code = function(code)
            return code == 0 or code == 2
        end,
        on_output = function(_)
            vim.cmd("checktime")
            return nil
        end,
    },
    factory = h.formatter_factory,
})
