local stub = require("luassert.stub")
local spy = require("luassert.spy")

local diagnostics = require("null-ls.builtins").diagnostics

stub(vim, "notify")

describe("diagnostics", function()
    describe("eslint", function()
        local linter = diagnostics.eslint
        local parser = linter._opts.on_output

        describe("with non fixable diagnostic", function()
            it("should create a diagnostic with warning severity", function()
                local output = vim.json.decode([[
            [{
              "filePath": "/home/luc/Projects/Pi-OpenCast/webapp/src/index.js",
              "messages": [
                {
                  "ruleId": "quotes",
                  "severity": 1,
                  "message": "Strings must use singlequote.",
                  "line": 1,
                  "column": 19,
                  "nodeType": "Literal",
                  "messageId": "wrongQuotes",
                  "endLine": 1,
                  "endColumn": 26
                }
              ]
            }] ]])
                local diagnostic = parser({ output = output })
                assert.same({
                    {
                        row = 1,
                        end_row = 1,
                        col = 19,
                        end_col = 26,
                        severity = 2,
                        code = "quotes",
                        message = "Strings must use singlequote.",
                        user_data = {
                            fixable = false,
                        },
                    },
                }, diagnostic)
            end)

            it("should create a diagnostic with error severity", function()
                local output = vim.json.decode([[
            [{
              "filePath": "/home/luc/Projects/Pi-OpenCast/webapp/src/index.js",
              "messages": [
                {
                  "ruleId": "quotes",
                  "severity": 2,
                  "message": "Strings must use singlequote.",
                  "line": 1,
                  "column": 19,
                  "nodeType": "Literal",
                  "messageId": "wrongQuotes",
                  "endLine": 1,
                  "endColumn": 26
                }
              ]
            }] ]])
                local diagnostic = parser({ output = output })
                assert.same({
                    {
                        row = 1,
                        end_row = 1,
                        col = 19,
                        end_col = 26,
                        severity = 1,
                        code = "quotes",
                        message = "Strings must use singlequote.",
                        user_data = {
                            fixable = false,
                        },
                    },
                }, diagnostic)
            end)
        end)

        describe("with fixable diagnostic", function()
            it("should create a diagnostic with warning severity", function()
                local output = vim.json.decode([[
            [{
              "filePath": "/home/luc/Projects/Pi-OpenCast/webapp/src/index.js",
              "messages": [
                {
                  "ruleId": "quotes",
                  "severity": 1,
                  "message": "Strings must use singlequote.",
                  "line": 1,
                  "column": 19,
                  "nodeType": "Literal",
                  "messageId": "wrongQuotes",
                  "endLine": 1,
                  "endColumn": 26,
                  "fix": {
                    "range": [
                      18,
                      25
                    ],
                    "text": "'react'"
                  }
                }
              ]
            }] ]])
                local diagnostic = parser({ output = output })
                assert.same({
                    {
                        row = 1,
                        end_row = 1,
                        col = 19,
                        end_col = 26,
                        severity = 2,
                        code = "quotes",
                        message = "Strings must use singlequote.",
                        user_data = {
                            fixable = true,
                        },
                    },
                }, diagnostic)
            end)

            it("should create a diagnostic with error severity", function()
                local output = vim.json.decode([[
            [{
              "filePath": "/home/luc/Projects/Pi-OpenCast/webapp/src/index.js",
              "messages": [
                {
                  "ruleId": "quotes",
                  "severity": 2,
                  "message": "Strings must use singlequote.",
                  "line": 1,
                  "column": 19,
                  "nodeType": "Literal",
                  "messageId": "wrongQuotes",
                  "endLine": 1,
                  "endColumn": 26,
                  "fix": {
                    "range": [
                      18,
                      25
                    ],
                    "text": "'react'"
                  }
                }
              ]
            }] ]])
                local diagnostic = parser({ output = output })
                assert.same({
                    {
                        row = 1,
                        end_row = 1,
                        col = 19,
                        end_col = 26,
                        severity = 1,
                        code = "quotes",
                        message = "Strings must use singlequote.",
                        user_data = {
                            fixable = true,
                        },
                    },
                }, diagnostic)
            end)
        end)
    end)

    describe("flake8", function()
        local linter = diagnostics.flake8
        local parser = linter._opts.on_output
        local file = {
            [[#===- run-clang-tidy.py - Parallel clang-tidy runner ---------*- python -*--===#]],
        }

        it("should create a diagnostic", function()
            local output = [[run-clang-tidy.py:3:1: E265 block comment should start with '# ']]
            local diagnostic = parser(output, { content = file })
            assert.same({
                row = "3",
                col = "1",
                severity = 1,
                code = "E265",
                message = "block comment should start with '# '",
            }, diagnostic)
        end)
    end)

    describe("dscanner", function()
        local linter = diagnostics.dscanner
        local parser = linter._opts.on_output
        local file = {
            [[enum uint min = uint.min;]],
        }

        it("should create a diagnostic", function()
            local output =
                [[::warning file=./source/crypto_random.d,line=31,endLine=31,col=13,endColumn=16,title=Warning (undocumented_declaration_check)::Public declaration 'min' is undocumented.]]
            local diagnostic = parser(output, { content = file })
            assert.same({
                filename = "./source/crypto_random.d",
                row = "31",
                end_lnum = "31",
                col = "13",
                end_col = "16",
                severity = 2, -- warning
                code = "undocumented_declaration_check",
                message = "Public declaration 'min' is undocumented.",
            }, diagnostic)
        end)
    end)
end)
