local stub = require("luassert.stub")

local alloy = require("none-ls.diagnostics.alloy")

stub(vim, "notify")

describe("diagnostics alloy", function()
    local parser = alloy._opts.on_output

    it("should create a diagnostic with error severity", function()
        local line = "Error: /home/user/config.alloy:10:5: unexpected token"
        local diagnostic = parser(line, {})
        assert.same({
            col = "5",
            filename = "/home/user/config.alloy",
            message = "unexpected token",
            row = "10",
            severity = 1,
        }, diagnostic)
    end)

    it("should create a diagnostic with warning severity", function()
        local line = "Warning: /home/user/config.alloy:3:1: deprecated block usage"
        local diagnostic = parser(line, {})
        assert.same({
            col = "1",
            filename = "/home/user/config.alloy",
            message = "deprecated block usage",
            row = "3",
            severity = 2,
        }, diagnostic)
    end)

    it("should return nil for non-matching lines", function()
        local line = "  some context line or stack trace"
        local diagnostic = parser(line, {})
        assert.is_nil(diagnostic)
    end)
end)
