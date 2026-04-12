local stub = require("luassert.stub")
local spy = require("luassert.spy")

local diagnostics = {
    eslint = require("none-ls.diagnostics.eslint"),
    flake8 = require("none-ls.diagnostics.flake8"),
    dscanner = require("none-ls.diagnostics.dscanner"),
    oxlint = require("none-ls.diagnostics.oxlint"),
}

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

    describe("oxlint", function()
        local linter = diagnostics.oxlint
        local parser = linter._opts.on_output

        it("should create a diagnostic with error severity", function()
            local output = vim.json.decode([[
            {
              "diagnostics": [
                {
                  "message": "Variable 'foo' is declared but never used. Unused variables should start with a '_'.",
                  "code": "eslint(no-unused-vars)",
                  "severity": "error",
                  "causes": [],
                  "url": "https://oxc.rs/docs/guide/usage/linter/rules/eslint/no-unused-vars.html",
                  "help": "Consider removing this declaration.",
                  "filename": "/tmp/sample.js",
                  "labels": [
                    {
                      "label": "'foo' is declared here",
                      "span": {
                        "offset": 6,
                        "length": 3,
                        "line": 1,
                        "column": 7
                      }
                    }
                  ],
                  "related": []
                }
              ],
              "number_of_files": 1,
              "number_of_rules": 93,
              "threads_count": 12,
              "start_time": 0.017990223
            }]])
            local diagnostic = parser({ output = output })
            assert.same({
                {
                    row = 1,
                    end_row = 1,
                    col = 7,
                    end_col = 10,
                    severity = 1,
                    code = "eslint(no-unused-vars)",
                    message = "Variable 'foo' is declared but never used. Unused variables should start with a '_'.",
                },
            }, diagnostic)
        end)

        it("should create a diagnostic with warning severity", function()
            local output = vim.json.decode([[
            {
              "diagnostics": [
                {
                  "message": "`debugger` statement is not allowed",
                  "code": "eslint(no-debugger)",
                  "severity": "warning",
                  "causes": [],
                  "url": "https://oxc.rs/docs/guide/usage/linter/rules/eslint/no-debugger.html",
                  "help": "Remove the debugger statement",
                  "filename": "/tmp/sample.js",
                  "labels": [
                    {
                      "span": {
                        "offset": 0,
                        "length": 9,
                        "line": 1,
                        "column": 1
                      }
                    }
                  ],
                  "related": []
                }
              ],
              "number_of_files": 1,
              "number_of_rules": 93,
              "threads_count": 12,
              "start_time": 0.019340364
            }]])
            local diagnostic = parser({ output = output })
            assert.same({
                {
                    row = 1,
                    end_row = 1,
                    col = 1,
                    end_col = 10,
                    severity = 2,
                    code = "eslint(no-debugger)",
                    message = "`debugger` statement is not allowed",
                },
            }, diagnostic)
        end)
    end)
end)
